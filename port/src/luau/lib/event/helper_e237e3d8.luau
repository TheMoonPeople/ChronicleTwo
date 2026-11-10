--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")

--- Helper function.
local function helper_e237e3d8(arg0: s32, arg1: s32, arg2: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	if arg0 == 1 or arg0 == 2 then
		helper_75684dd8(0, 2750, 8, 0, 0)
	end
	if arg0 == 1 and arg1 ~= 2 then
		argc = event.get_system_sound_id() or argc
		event.play_sound_effect(argc, 18)
		helper_75684dd8(0, 2760, 8, 0, 0)
	end
	if arg1 == 2 or arg1 == 3 then
		helper_75684dd8(0, vm.i32(2700 + arg2), 8, 0, 0)
	end
	if arg0 == 1 and arg1 == 2 then
		argc_2 = event.get_system_sound_id() or argc_2
		event.play_sound_effect(argc_2, 18)
		event.open_message_window_2(0, "[UNI00a1]Tienes dos Medallas!")
		helper_75684dd8(0, -1, 8, 0, 0)
	elseif arg1 == 2 then
		argc_3 = event.get_system_sound_id() or argc_3
		event.play_sound_effect(argc_3, 18)
		helper_75684dd8(0, 2760, 8, 0, 0)
	end
end

return helper_e237e3d8
