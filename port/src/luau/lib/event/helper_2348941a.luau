--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2348941a()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 18)
	event.set_character_position(0, 2065.33, -14.0, -806.24)
	event.set_character_rotation(0, 0.0, -1.42, 0.0)
	event.set_character_motion(0, "走り", 4)
	event.set_camera_position(1962.84, 25.0, -888.26)
	event.fade_in_screen(30)
	event.move_object_sequence(0, 1899.56, -14.0, -773.11, 40)
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
end

return helper_2348941a
