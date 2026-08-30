---
name: cdp
description: Drive a headless Chrome via the Chrome DevTools Protocol (CDP) with zero dependencies — plain Node WebSocket, no puppeteer/playwright. Use when verifying web app behavior in a real browser from the agent (form submit, DOM inspection, network requests, console exceptions, computed styles, screenshots), testing streaming/DOM APIs, or when asked to "check in the browser" / "verify with CDP".
---

# CDP Browser Verification

Drive headless Chrome over CDP using only Node built-ins (WebSocket is global since Node 22). No libraries.

## 1. Launch Chrome

```bash
google-chrome-stable --headless=new \
  --remote-debugging-port=9333 \
  --user-data-dir=/tmp/cdp-profile-$$ \
  --enable-experimental-web-platform-features \
  --no-first-run about:blank >/tmp/chrome.log 2>&1 &
sleep 3
```

- **NEVER point `--user-data-dir` at the user's real profile** (`~/.config/google-chrome` etc.) — CDP exposes every cookie and login session to any local process.
- Clean up when done: `kill %1 && rm -rf /tmp/cdp-profile-*` (or launch inside a subshell with `trap 'rm -rf "$d"' EXIT`).
- Drop `--enable-experimental-web-platform-features` unless the page needs experimental APIs.
- Chromium also works (`chromium` binary). Pick whichever exists (`command -v`).
- Endpoint check: `curl -s http://localhost:9333/json/version`.

## 2. Connect and drive

Write a throwaway `.mjs` script (pattern below), run it, read its output, delete nothing until done — keep it in `/tmp`, never commit.

```js
// /tmp/verify.mjs
const pages = await fetch('http://localhost:9333/json/list').then(r => r.json());
const page = pages.find(p => p.url.includes('localhost:3000')) ?? pages[0];
const ws = new WebSocket(page.webSocketDebuggerUrl);

let id = 0;
const pending = new Map();
const exceptions = [], consoleErrors = [], requests = [];
ws.onmessage = (e) => {
  const m = JSON.parse(e.data);
  if (m.id && pending.has(m.id)) { pending.get(m.id)(m.result); pending.delete(m.id); return; }
  if (m.method === 'Runtime.exceptionThrown')
    exceptions.push((m.params.exceptionDetails.exception?.description || m.params.exceptionDetails.text).split('\n')[0]);
  if (m.method === 'consoleAPICalled' && m.params.type === 'error')
    consoleErrors.push(m.params.args?.map(a => a.value ?? a.description).join(' '));
  if (m.method === 'Network.requestWillBeSent')
    requests.push(`${m.params.request.method} ${m.params.request.url}`);
};
await new Promise(r => ws.onopen = r);
const send = (method, params = {}) =>
  new Promise(res => { pending.set(++id, res); ws.send(JSON.stringify({ id, method, params })); });

await send('Page.enable');
await send('Runtime.enable');
await send('Network.enable');
await send('Page.navigate', { url: 'http://localhost:3000/' });
await new Promise(r => setTimeout(r, 1500)); // let scripts settle

const evaluate = async (expression) =>
  (await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })).result?.value;

console.log(await evaluate(`document.title`));
console.log('exceptions:', exceptions.join(' | ') || 'none');
console.log('console errors:', consoleErrors.join(' | ') || 'none');
console.log('requests:', requests.join(', ') || 'none');
process.exit(0);
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
