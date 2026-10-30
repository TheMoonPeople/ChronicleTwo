--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_c8c8b790 = require("@lib/event/helper_c8c8b790")

--- Helper function.
local function helper_271a78ae(arg0: any, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
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
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	helper_c8c8b790(1, var2, 8, 0, 0)
end

return helper_271a78ae
