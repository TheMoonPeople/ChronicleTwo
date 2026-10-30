--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_84c07dcc = require("@lib/event/helper_84c07dcc")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_c41e8541(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grumble, grumble...")
	helper_84c07dcc(arg0)
	event.open_message_window_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Grumble, grumble...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

return helper_c41e8541
