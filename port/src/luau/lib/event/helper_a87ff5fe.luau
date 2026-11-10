--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_a87ff5fe(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"この町は平和すぎて、\n私のかつやくする場が\n全然ない。<page>もちろん、それが\n良い事なのはわかって\nいるんだが・・・"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_a87ff5fe
