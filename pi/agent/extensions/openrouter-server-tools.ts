/**
 * Injects OpenRouter server tools (datetime / web_search / web_fetch).
 * datetime is always available, using the system timezone.
 *
 * Web tool schemas add prompt tokens even when never called, so web tools
 * are injected per-run only when the prompt looks like it needs the web.
 * An active run keeps them across its turns for prompt cache stability.
 *
 * /webtools cycles web tools only: auto (default) -> on -> off.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Bare URLs, or explicit search/freshness intent in Japanese.
const WEB_INTENT = /https?:\/\/|www\.|(?:検索|調べ|最新|ニュース)/i;

export default function (pi: ExtensionAPI) {
	type Mode = "auto" | "on" | "off";
	let mode: Mode = "auto";
	let armed = false; // web tools active for the current run

	pi.registerCommand("webtools", {
		description: "Cycle OpenRouter web tools: auto -> on -> off (datetime always on)",
		handler: async (_args, ctx) => {
			mode = mode === "auto" ? "on" : mode === "on" ? "off" : "auto";
			armed = mode === "on";
			ctx.ui.notify(`OpenRouter web tools: ${mode} (datetime always on)`, "info");
		},
	});

	pi.on("input", (event) => {
		if (event.source === "extension") return;
		if (mode === "auto") armed = WEB_INTENT.test(event.text);
		else armed = mode === "on";
	});

	// Expanded prompt (skills/templates), so web intent inside an expansion counts too.
	pi.on("before_agent_start", (event) => {
		if (mode === "auto") armed ||= WEB_INTENT.test(event.prompt);
	});

	pi.on("agent_settled", () => {
		armed = mode === "on";
	});

	pi.on("before_provider_request", (event, ctx) => {
		if (ctx.model?.provider !== "openrouter") return;

		const payload = event.payload as Record<string, unknown>;
		if (!Array.isArray(payload.tools)) return;
		// ponytail: default tool params; set engine/max_results etc. here if cost control matters
		const serverTools = [
			{
				type: "openrouter:datetime",
				parameters: { timezone: Intl.DateTimeFormat().resolvedOptions().timeZone },
			},
			...(armed ? [{ type: "openrouter:web_search" }, { type: "openrouter:web_fetch" }] : []),
		];
		for (const t of serverTools) {
			if (!payload.tools.some((x: any) => x?.type === t.type)) {
				payload.tools.push(t);
			}
		}
	});
}