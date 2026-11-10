--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_5217d4e0(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_5217d4e0
