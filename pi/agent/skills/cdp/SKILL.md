---
name: cdp
description: Drive a headless Chrome via the Chrome DevTools Protocol (CDP) with zero dependencies — plain Node WebSocket, no puppeteer/playwright. Use when verifying web app behavior in a real browser from the agent (form submit, DOM inspection, network requests, console exceptions, computed styles, screenshots), testing streaming/DOM APIs, or when asked to "check in the browser" / "verify with CDP".
---

# CDP Browser Verification

Drive headless Chrome over CDP using only Node built-ins (WebSocket is global since Node 22). No libraries.

## 1. Ensure a browser binary

Default to **`chrome-headless-shell`** (official standalone old-headless binary, actively shipped; ideal for screenshots/scraping/basic verification, no X11/D-Bus needed — good for WSL2). Use full Chrome with `--headless=new` only when real-Chrome rendering fidelity matters (E2E tests, rendering-sensitive checks).

Check in this order:

1. `command -v google-chrome-stable chromium chrome-headless-shell`
2. The puppeteer cache layout: `find ~/.cache -name chrome-headless-shell -type f 2>/dev/null` (typical path: `~/.cache/cull-browsers/chrome-headless-shell/linux-*/chrome-headless-shell-linux64/chrome-headless-shell`)

If nothing exists, install the shell (no sudo needed):

```bash
npx @puppeteer/browsers install chrome-headless-shell@stable --path ~/.cache/cull-browsers
```

Note the printed binary path. If the shell is insufficient and real Chrome is needed, ask the user for approval before installing `google-chrome-stable` (sudo + official apt repo):

```bash
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update && sudo apt install -y google-chrome-stable
```

Avoid `chromium-browser` on Ubuntu 24.04 (snap; awkward in WSL2).

## 2. Launch

```bash
<binary> --headless=new \
  --remote-debugging-port=9333 \
  --user-data-dir=/tmp/cdp-profile-$$ \
  --enable-experimental-web-platform-features \
  --no-first-run about:blank >/tmp/chrome.log 2>&1 &
echo "$! /tmp/cdp-profile-$$" > /tmp/chrome-9333.pid
sleep 3
```

(With `chrome-headless-shell` the `--headless=new` flag is a harmless no-op — the shell is always headless.)

- **NEVER point `--user-data-dir` at the user's real profile** (`~/.config/google-chrome` etc.) — CDP exposes every cookie and login session to any local process.
- Each bash invocation is a separate shell, so `kill %1` won't work in a later call — and `$$` there would be a different PID too. That's why the launch saves the Chrome PID and its profile path: clean up with `read pid d < /tmp/chrome-9333.pid && kill $pid && rm -rf "$d" /tmp/chrome-9333.pid` (only your own profile dir — a concurrent session may own the others).
- Running as root or in Docker? Add `--no-sandbox` or Chrome refuses to start.
- Drop `--enable-experimental-web-platform-features` unless the page needs experimental APIs.
- Endpoint check: `curl -s http://localhost:9333/json/version`.

## 3. Connect and drive

Write a throwaway `.mjs` script (pattern below), run it, read its output. Keep it in `/tmp` while you iterate, delete it when done — never commit it.

```js
// /tmp/verify.mjs
const pages = await fetch('http://localhost:9333/json/list').then(r => r.json());
const page = pages.find(p => p.url.includes('localhost:3000')) ?? pages[0];
const ws = new WebSocket(page.webSocketDebuggerUrl);

let id = 0;
const pending = new Map(); // id -> { resolve, reject }
const exceptions = [], consoleErrors = [], requests = [];
ws.onmessage = (e) => {
  const m = JSON.parse(e.data);
  if (m.id && pending.has(m.id)) {
    const { resolve, reject } = pending.get(m.id); pending.delete(m.id);
    m.error ? reject(new Error(`CDP ${m.error.message}`)) : resolve(m.result);
    return;
  }
  if (m.method === 'Runtime.exceptionThrown')
    exceptions.push((m.params.exceptionDetails.exception?.description || m.params.exceptionDetails.text).split('\n')[0]);
  if (m.method === 'consoleAPICalled' && m.params.type === 'error')
    consoleErrors.push(m.params.args?.map(a => a.value ?? a.description).join(' '));
  if (m.method === 'Network.requestWillBeSent')
    requests.push(`${m.params.request.method} ${m.params.request.url}`);
};
ws.onclose = () => { for (const p of pending.values()) p.reject(new Error('WebSocket closed — did Chrome crash?')); };
await new Promise(r => ws.onopen = r);
const send = (method, params = {}) => new Promise((resolve, reject) => {
  pending.set(++id, { resolve, reject }); ws.send(JSON.stringify({ id, method, params }));
});

const load = new Promise(r => {
  const h = (e) => { if (JSON.parse(e.data).method === 'Page.loadEventFired') { ws.removeEventListener('message', h); r(); } };
  ws.addEventListener('message', h);
});
await send('Page.enable');
await send('Runtime.enable');
await send('Network.enable');
await send('Page.navigate', { url: 'http://localhost:3000/' });
await Promise.race([load, new Promise(r => setTimeout(r, 10000))]);

const evaluate = async (expression) => {
  const r = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
  if (r.exceptionDetails) throw new Error(r.exceptionDetails.exception?.description || r.exceptionDetails.text);
  return r.result?.value;
};

// app fetches data after load? poll for readiness inside ONE evaluate, not a fixed sleep
await evaluate(`(async () => { for (let i = 0; i < 50 && document.querySelector('[data-loading]'); i++) await new Promise(r => setTimeout(r, 100)); })()`).catch(() => {});

console.log(await evaluate(`document.title`));
console.log('exceptions:', exceptions.join(' | ') || 'none');
console.log('console errors:', consoleErrors.join(' | ') || 'none');
console.log('requests:', requests.join(', ') || 'none');
ws.close(); // a thrown evaluate error escapes as an unhandled rejection → node exits 1 with the stack
```

Run: `timeout 120 node /tmp/verify.mjs`

## Core methods

| Task | Call |
|---|---|
| Run JS in page | `Runtime.evaluate` with `{ expression, returnByValue: true, awaitPromise: true }` |
| Navigate | `Page.navigate { url }` |
| Observe requests (URL/body/status) | enable `Network.enable`, listen for `Network.requestWillBeSent` |
| Response bodies | `Network.getResponseBody { requestId }` (after `Network.loadingFinished`) |
| Console errors | enable `Runtime.enable`, listen for `Runtime.exceptionThrown` / `consoleAPICalled` (type `error`) |
| Screenshot (viewport) | `Page.captureScreenshot { format: 'png' }` (base64; decode to file if needed) |
| Screenshot (full page) | `Page.captureScreenshot { captureBeyondViewport: true }` |
| Emulate viewport / dark mode | `Emulation.setDeviceMetricsOverride { width, height, deviceScaleFactor: 0, mobile: false }` / `Emulation.setEmulatedMedia { features: [{ name: 'prefers-color-scheme', value: 'dark' }] }` |
| A11y tree | `Accessibility.getFullAXTree` (no enable needed) — snapshot without screenshots |

## Gotchas learned the hard way

- **Async waits**: after navigation or actions that trigger fetches, poll inside one `Runtime.evaluate` (`while (busy) await sleep(...)`) rather than many separate evaluates — separate calls race each other.
- **One evaluate per scenario**: an entire multi-step flow (submit form → wait → inspect DOM → submit again) fits in a single `(async () => {...})()` expression. Splitting steps across evaluate calls caused false "the second click didn't fire" readings.
- **`returnByValue: true`** or you get back unserializable remote object handles. For big results, build a string in-page and return it.
- **Module-scope variables** of the page's `<script type="module">` are not reachable from evaluate; go through `document.getElementById(...)` etc., or wrap/rebind handlers before triggering them.
- **Always collect `Runtime.exceptionThrown`** — a page can look fine while the handler threw mid-way.

## When raw CDP is not enough

`Runtime.evaluate`-driven interaction can't do trusted clicks, performance tracing, or Lighthouse. For those, the official CLI (`chrome-devtools-mcp`, https://github.com/ChromeDevTools/chrome-devtools-mcp) provides `take_snapshot`, `click`, `performance_start_trace`, `lighthouse_audit`, …

**ALWAYS ask the user for approval before installing or using it** (`npm i chrome-devtools-mcp@latest -g` adds a global package with a Puppeteer dependency tree, and its CLI manages its own Chrome instance). Propose the exact command, wait for explicit yes, and only then proceed. Do not use it as an unattended fallback — raw CDP in this skill stays the default.
