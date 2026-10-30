--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_e1a15fc9 = require("@lib/event/helper_e1a15fc9")

--- Helper function.
local function helper_d2512598(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Hey Max, have you come looking for me?<page>I've been waiting.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Thanks to the castle walls,\nthis town is pretty safe.<page>It's time for us to go outside.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "It's good that you're always\ntinkering about with machines,\nbut I wonder how strong you are?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Fighting's all about\nspeed and footwork.<page>If you're any slower than me,\nit's no good.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Why don't we give you a test.\nRun to the boat at the lake and back.<page>My record is 2 minutes 1 second.\nIf you're any slower than that,\nit's no good."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "How about it, you want to try?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_e1a15fc9(arg0, arg1)
end

return helper_d2512598
