--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_3c03bb6f(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"なんでこんなに月が恋しいんだろう。<page>もしかしたら、僕はあそこから\n来たのかも知れない・・・"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_3c03bb6f
