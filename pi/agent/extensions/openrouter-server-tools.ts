/**
 * Injects OpenRouter server tools (web_search / web_fetch) into requests
 * sent to the openrouter provider, so any model can search the web and
 * fetch URLs mid-request (executed server-side by OpenRouter).
 *
 * Toggle with /webtools (default: on).
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	let enabled = true;

	pi.registerCommand("webtools", {
		description: "Toggle OpenRouter server tools (web_search/web_fetch)",
		handler: async (_args, ctx) => {
			enabled = !enabled;
			ctx.ui.notify(
				`OpenRouter server tools ${enabled ? "enabled" : "disabled"}`,
				"info",
			);
		},
	});

	pi.on("before_provider_request", (event, ctx) => {
		if (!enabled) return;
		if (ctx.model?.provider !== "openrouter") return;
		if (ctx.mode === "print") return;

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
