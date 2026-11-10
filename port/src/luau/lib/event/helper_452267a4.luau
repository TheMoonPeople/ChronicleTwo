--!strict
-- Shared event helper used by 36 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local helper_684bf7e6 = require("@lib/event/helper_684bf7e6")

--- Helper function.
local function helper_452267a4(index: s32, arg1: s32)
	local argc: s32 = 0
	event.set_eye_view_map_parts(0)
	event.set_message_window_option(1, 4, -1, -1, -1, -1)
	event.set_message_window_option(1, 9, -1, -1)
	if arg1 ~= 0 then
		close_message(1)
	else
		event.apply_message_window_preset(1, 3)
	end
	event.finish_event()
	if arg1 == 0 then
		argc = event.get_local_event_counter(index) or argc
		helper_684bf7e6(index, argc)
	end
end

return helper_452267a4
