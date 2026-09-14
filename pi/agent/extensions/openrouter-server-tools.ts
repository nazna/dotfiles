/**
 * Injects OpenRouter server tools (web_search / web_fetch) into requests
 * sent to the openrouter provider, so any model can search the web and
 * fetch URLs mid-request (executed server-side by OpenRouter).
 *
 * Server tool schemas add ~600 prompt tokens per request even when never
 * called, so they are injected per-run only when the prompt looks like it
 * needs the web. An active run keeps them across its turns (stable tool
 * prefix = intact prompt cache).
 *
 * Mode cycles with /webtools: auto (default) -> on -> off.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Bare URLs, or explicit search/freshness intent in Japanese.
const WEB_INTENT = /https?:\/\/|www\.|(?:検索|調べ|最新|ニュース)/i;

export default function (pi: ExtensionAPI) {
	type Mode = "auto" | "on" | "off";
	let mode: Mode = "auto";
	let armed = false; // server tools active for the current run

	pi.registerCommand("webtools", {
		description: "Cycle OpenRouter server tools: auto -> on -> off",
		handler: async (_args, ctx) => {
			mode = mode === "auto" ? "on" : mode === "on" ? "off" : "auto";
			armed = mode === "on";
			ctx.ui.notify(`OpenRouter server tools: ${mode}`, "info");
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
		if (!armed) return;
		if (ctx.model?.provider !== "openrouter") return;

		const payload = event.payload as Record<string, unknown>;
		if (!Array.isArray(payload.tools)) return;
		// ponytail: default tool params; set engine/max_results etc. here if cost control matters
		const serverTools = [
			{ type: "openrouter:web_search" },
			{ type: "openrouter:web_fetch" },
		];
		for (const t of serverTools) {
			if (!payload.tools.some((x: any) => x?.type === t.type)) {
				payload.tools.push(t);
			}
		}
	});
}