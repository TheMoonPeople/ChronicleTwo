--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_9b516ef5(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(arg1, "立ち")
	event.open_message_window_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

return helper_9b516ef5
