---
name: cdp
description: Drive a real Chrome (WSL or native Linux) over the Chrome DevTools Protocol. Default to raw CDP (zero deps, plain Node WebSocket) for navigation, DOM inspection, JS evaluation, network/console capture and screenshots. Escalate to the chrome-devtools-mcp tools (via codemode) for trusted input (click/type), accessibility snapshots, performance traces and Lighthouse. Use when verifying web app behavior in a real browser, testing streaming/DOM APIs, or when asked to "check in the browser" / "verify with CDP".
---

# CDP Browser Verification

Two layers, use the cheaper one that works:

- **Raw CDP (default)** — plain Node WebSocket, no dependencies. Best for navigation, `Runtime.evaluate`, network/console capture, computed styles, screenshots.
- **chrome-devtools-mcp (escalate)** — project MCP server `chrome-devtools`, configured in the project's `.pi/mcp.json`. Best for trusted clicks/typing, `take_snapshot`, network request detail, performance traces, Lighthouse. Reach it from a codemode script with `tools.mcp__chrome_devtools__*` (discover with `searchTools('take snapshot click navigate', { namespace: 'chrome-devtools' })`).

## 1. Start the shared Chrome

Both raw CDP and the MCP server talk to the same Chrome on port **9333**. The MCP server config (`--browserUrl http://127.0.0.1:9333`) depends on this Chrome already running; it does not launch its own. If the project already ships its own `.pi/mcp.json` wired to a different browser/port, that config wins. Otherwise the default is this skill's shared Chrome on 9333 (the MCP tools, if present, assume it).

Launch Chrome **headless** with an isolated throwaway profile:

```bash
prof=$(mktemp -d /tmp/cdp-profile-XXXX)
echo "$prof" >/tmp/cdp-profile-path   # cleanup runs in a new shell; remember the dir
if [ -x "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" ]; then
  # WSL: use the Windows binary (do not use the chromium-browser snap on Debian/Ubuntu)
  chrome="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
  userdir=$(wslpath -w "$prof")
else
  # native Linux
  chrome=$(command -v google-chrome-stable || command -v google-chrome || command -v chromium) || {
    echo 'no Chrome found'; exit 1; }
  userdir="$prof"
fi
"$chrome" --headless=new --remote-debugging-port=9333 \
  --user-data-dir="$userdir" --no-first-run --no-default-browser-check \
  about:blank >/tmp/chrome.log 2>&1 &
sleep 5
curl -sf --max-time 5 http://localhost:9333/json/version || { echo 'Chrome not up — see /tmp/chrome.log'; exit 1; }
```

Headless keeps it off the user's screen. If a visible window is needed, drop `--headless=new` (it stays `--remote-debugging-port`; never point `--user-data-dir` at the user's real profile).

- **Binary fallback**: `command -v google-chrome-stable || command -v google-chrome || command -v chromium`; else the puppeteer shell `find ~/.cache -name chrome-headless-shell -type f`. The Windows path above is the default install location only — if Chrome lives elsewhere, pass the real path.
- **Cleanup** — each bash call is a new shell, so re-derive the PID from the port:
  ```bash
  pid=$(ss -lptn 'sport = :9333' 2>/dev/null | grep -oP 'pid=\K[0-9]+' | head -1)
  if [ -n "$pid" ]; then
    kill "$pid" 2>/dev/null
  elif [ -x /mnt/c/Windows/System32/netstat.exe ]; then
    # WSL: Windows Chrome process; kill won't reach it
    wp=$(/mnt/c/Windows/System32/netstat.exe -ano | awk '$2=="127.0.0.1:9333"{gsub(/\r/,"",$5);print $5}')
    [ -n "$wp" ] && taskkill.exe /F /PID "$wp"
  fi
  rm -rf "$(cat /tmp/cdp-profile-path 2>/dev/null)" /tmp/cdp-profile-path
  ```
  Only kill the port you started — a concurrent session may own it.
- Running as root or in Docker? Add `--no-sandbox`.

## 2. Drive with raw CDP

Write a throwaway `.mjs` script, run it, read its output. Keep it in `/tmp` while iterating, delete it when done — never commit it.

```js
// /tmp/verify.mjs
const pages = await fetch('http://localhost:9333/json/list').then(r => r.json());
const page = pages.find(p => p.url.includes('localhost:3000')) ?? pages.find(p => p.type === 'page');
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

## Core methods (raw CDP)

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

## Escalate to chrome-devtools-mcp

Use it when raw `Runtime.evaluate` can't: trusted clicks/typing (raw CDP can't dispatch trusted input), `take_snapshot` (accessibility tree with stable UIDs), detailed network requests, performance traces, Lighthouse. It is wired in the project's `.pi/mcp.json` with `codemode` exposure, so call it from a codemode script:

```js
// discover exact names + signatures
const found = await searchTools('take snapshot click navigate network', { namespace: 'chrome-devtools' });
// tools.mcp__chrome_devtools__list_pages({})
// tools.mcp__chrome_devtools__navigate_page({ url: 'http://localhost:3000/' })
// tools.mcp__chrome_devtools__take_snapshot({})
// tools.mcp__chrome_devtools__click({ pageId, uid })
const snapshot = await tools.mcp__chrome_devtools__take_snapshot({});
return snapshot.content?.[0]?.text;
```

Call `list_pages` first — `pageId` routing is on (`--page-id-routing` default) and selects which page the tools act on. The server connects to the shared Chrome on 9333; if it reports "not connected", start Chrome per step 1 and `/reload`.

If the project has no `chrome-devtools` server configured, this layer is simply unavailable — fall back to raw CDP (trusted input then has no direct solution; say so rather than faking it).

Do **not** install packages globally or let `npx` manage its own Chrome for this skill: the project server connects to the shared 9333 instance, which avoids a second browser and profile.

## Gotchas learned the hard way

- **Async waits**: after navigation or actions that trigger fetches, poll inside one `Runtime.evaluate` (`while (busy) await sleep(...)`) rather than many separate evaluates — separate calls race each other.
- **One evaluate per scenario**: an entire multi-step flow (submit form → wait → inspect DOM → submit again) fits in a single `(async () => {...})()` expression. Splitting steps across evaluate calls caused false "the second click didn't fire" readings.
- **Trusted clicks need the MCP layer**: a JS `.click()` and `Input.dispatchMouseEvent` over a raw WebSocket are not trusted. Use `chrome-devtools` MCP `click`/`fill`/`press_key` for anything a real user gesture must trigger.
- **`returnByValue: true`** or you get back unserializable remote object handles. For big results, build a string in-page and return it.
- **Module-scope variables** of the page's `<script type="module">` are not reachable from evaluate; go through `document.getElementById(...)` etc., or wrap/rebind handlers before triggering them.
- **Always collect `Runtime.exceptionThrown`** — a page can look fine while the handler threw mid-way.
- **WSL networking (WSL only)**: on WSL this skill assumes `networkingMode=mirrored` in `.wslconfig`, so Windows `127.0.0.1` is WSL `localhost`. If `curl http://localhost:9333/json/version` fails after Chrome is up, networking is in NAT mode — the Windows host is not `localhost`; fall back to a Linux headless shell binary. Native Linux needs none of this.
