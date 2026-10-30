--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_6a61b74b(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.set_message_item_name(1, 1, arg0)
	event.set_message_item_name(1, 2, arg2)
	event.set_message_item_name(1, 3, arg4)
	event.set_message_number(1, 1, arg1)
	event.set_message_number(1, 2, arg3)
	event.set_message_number(1, 3, arg5)
	show_message(1, 9, 8, 0, 0)
end

return helper_6a61b74b
