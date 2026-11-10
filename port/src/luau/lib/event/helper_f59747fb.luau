--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f59747fb()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or var0
	var1 = event.get_triggered_event_data_2(9) or var1
	event.attach_object_handle_to_map_part_2(0, var1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(1, var1, "d01d01_00-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
	event.play_sound_effect(var0, 0)
	var5 = vm.bits_float(event.get_triggered_event_data_2(11)) or var5
	var5 = vm.f32(var5 - vm.f32(3.1415927))
	var5 = event.wrap_angle(var5) or var5
	var6 = 0
	while var6 < 60 do
		event.swing_camera_control_to_angle(var5)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var6 = var6 + 1
		vm.wait(1)
	end
	event.set_function_point_enabled(var1, "key", 0)
	event.attach_object_handle_to_map_part_3(2, var1, "d01da00-a")
	event.set_object_handle_position(2, 0.0, 80.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, var1, "d01dv00-c")
	event.set_object_handle_visible(3, 0)
	event.reset_follow_camera(0)
end

return helper_f59747fb
