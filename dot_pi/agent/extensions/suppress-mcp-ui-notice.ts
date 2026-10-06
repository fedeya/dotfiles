import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	let restore = () => {};

	pi.on("session_start", (_event, ctx) => {
		restore();
		const notify = ctx.ui.notify;
		const filteredNotify: typeof notify = (message, type) => {
			if (!message.startsWith("MCP UI window suppressed")) notify.call(ctx.ui, message, type);
		};
		ctx.ui.notify = filteredNotify;
		restore = () => {
			if (ctx.ui.notify === filteredNotify) ctx.ui.notify = notify;
		};
	});

	pi.on("session_shutdown", () => restore());
}
