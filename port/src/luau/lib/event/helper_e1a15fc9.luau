--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")

--- Helper function.
local function helper_e1a15fc9(arg0: s32, arg1: s32)
	local var2: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Sure, I'll give it a try.\nI'm not up to it.")
	var2 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var2 ~= 0 then
		event.open_message_window_2(0, "Okay...<page>Okay, if you wanna try again later,\njust let me know. I'll be waiting.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "Ready, steady,\ngo!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

return helper_e1a15fc9
