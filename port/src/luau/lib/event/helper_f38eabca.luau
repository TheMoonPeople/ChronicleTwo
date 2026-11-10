--!strict
-- Shared event helper used by 204 scripts, translated by tools/luau/stb2luau.

local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_f38eabca(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.set_message_item_name(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.set_message_item_name(1, 1, arg0)
		event.set_message_number(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	show_message(1, var2, 8, 0, 0)
end

return helper_f38eabca
