--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_50ae78e4()
	local var0: f32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local scale: f32 = 0
	local scale_2: f32 = 0
	local scale_3: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	var1 = event.get_triggered_event_data_2(9) or var1
	var0 = vm.bits_float(event.get_triggered_event_data_2(11)) or var0
	event.attach_object_handle_to_map_part_2(0, var1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(0, var1, "d04d00_101-m1")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if helper_f7fba8ce(var0, 0.0, 1.0) == 0 or helper_f7fba8ce(var0, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, var1, "d04d00_11-m")
		event.attach_object_handle_to_map_part_3(2, var1, "d04d00_12-m")
		event.attach_object_handle_to_map_part_3(3, var1, "d04d00_13-m")
		event.attach_object_handle_to_map_part_3(4, var1, "d04d00_14-m")
		event.attach_object_handle_to_map_part_3(5, var1, "d04d00_15-m")
		event.attach_object_handle_to_map_part_3(6, var1, "d04d00_16-m")
		event.attach_object_handle_to_map_part_3(7, var1, "d04d00_17-m")
		event.attach_object_handle_to_map_part_3(8, var1, "d04d00_18-m")
		scale = 1.0
		scale_2 = 1.0
		scale_3 = 0.0
	else
		event.attach_object_handle_to_map_part_3(1, var1, "d04d00_21-m")
		event.attach_object_handle_to_map_part_3(2, var1, "d04d00_22-m")
		event.attach_object_handle_to_map_part_3(3, var1, "d04d00_23-m")
		event.attach_object_handle_to_map_part_3(4, var1, "d04d00_24-m")
		event.attach_object_handle_to_map_part_3(5, var1, "d04d00_25-m")
		event.attach_object_handle_to_map_part_3(6, var1, "d04d00_26-m")
		event.attach_object_handle_to_map_part_3(7, var1, "d04d00_27-m")
		event.attach_object_handle_to_map_part_3(8, var1, "d04d00_28-m")
		scale = 0.0
		scale_2 = 1.0
		scale_3 = 1.0
	end
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, var1, "d04da05_2-a")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, var1, "d04da99-a0")
	event.set_object_handle_visible(10, 1)
	event.set_function_point_enabled(var1, "dkey", 0)
	event.start_background_file_loads_1("snd2/sp/sp_034.sound.json")
	var0 = vm.f32(var0 - vm.f32(3.1415927))
	var0 = event.wrap_angle(var0) or var0
	var11 = 0
	while var11 < 30 do
		event.swing_camera_control_to_angle(var0)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var11 = var11 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	var12 = event.load_sound_effect_file_3(8, "snd2/sp/sp_034.sound.json") or var12
	event.play_sound_effect(var12, 0)
	wait_frames(10)
	event.play_sound_effect(var12, 1)
	event.rotate_object_sequence(0, rot_x - vm.f32(0.52), rot_y, rot_z, 30)
	wait_frames(30)
	event.play_sound_effect(var12, 2)
	event.set_function_point_enabled(var1, "eff_d04f01-50", 0)
	event.set_function_point_enabled(var1, "eff_d04f01-51", 0)
	event.set_object_sequence_scale(1, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(2, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(3, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(4, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(6, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(7, scale, scale_2, scale_3, 60)
	event.set_object_sequence_scale(8, scale, scale_2, scale_3, 60)
	wait_frames(60)
	event.set_object_handle_visible(7, 0)
	event.set_object_handle_visible(8, 0)
	event.set_function_point_enabled(var1, "func", 0)
	event.reset_follow_camera(0)
end

return helper_50ae78e4
