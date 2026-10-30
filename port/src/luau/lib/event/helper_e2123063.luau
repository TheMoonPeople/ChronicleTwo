--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e2123063()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_position(-1145.1, 60.0, 267.26)
	event.set_camera_look_at(-1389.9, 59.36, 109.01)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 40)
	event.add_object_sequence_path_point(0, -1389.9, 29.36, 109.01)
	event.add_object_sequence_path_point(0, -1346.17, 17.95, 136.53)
	event.add_object_sequence_path_point(0, -1295.63, 0.0, 159.4)
	event.add_object_sequence_path_point(0, -1263.68, 0.0, 164.7)
	event.start_object_sequence_path(0)
	var3 = 0
	while var3 < 40 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.set_camera_look_at(var0, var1, var2)
		var3 = var3 + 1
		vm.wait(1)
	end
	event.set_object_handle_footstep_sound(0, 0)
end

return helper_e2123063
