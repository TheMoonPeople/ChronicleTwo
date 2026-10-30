--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c08bdcd7(arg0: s32)
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local rot_x_2: f32 = 0
	local rot_y_2: f32 = 0
	local rot_z_2: f32 = 0
	local rot_x_3: f32 = 0
	local rot_y_3: f32 = 0
	local rot_z_3: f32 = 0
	local rot_x_4: f32 = 0
	local rot_y_4: f32 = 0
	local rot_z_4: f32 = 0
	local rot_x_5: f32 = 0
	local rot_y_5: f32 = 0
	local rot_z_5: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local angle: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: s32 = 0
	event.initialize_event()
	event.start_background_file_loads_2("event/dng_inout/gekka_out.gltf", "snd2/sp/sp_037.sound.json")
	var1 = event.get_triggered_event_data_2(9) or var1
	if arg0 == 0 then
		event.attach_object_handle_to_map_part_3(0, var1, "d06w09_3-m")
		event.attach_object_handle_to_map_part_3(1, var1, "d06w09_3-m1")
		event.attach_object_handle_to_map_part_3(2, var1, "d06w09_3-m2")
		event.attach_object_handle_to_map_part_3(3, var1, "d06w09_3-m3")
		event.attach_object_handle_to_map_part_3(4, var1, "d06w09_3-m4")
	elseif arg0 == 1 then
		event.attach_object_handle_to_map_part_3(0, var1, "d06w09_4-m")
		event.attach_object_handle_to_map_part_3(1, var1, "d06w09_4-m1")
		event.attach_object_handle_to_map_part_3(2, var1, "d06w09_4-m2")
		event.attach_object_handle_to_map_part_3(3, var1, "d06w09_4-m3")
		event.attach_object_handle_to_map_part_3(4, var1, "d06w09_4-m4")
	else
		event.attach_object_handle_to_map_part_3(0, var1, "d06w09_5-m")
		event.attach_object_handle_to_map_part_3(1, var1, "d06w09_5-m1")
		event.attach_object_handle_to_map_part_3(2, var1, "d06w09_5-m2")
		event.attach_object_handle_to_map_part_3(3, var1, "d06w09_5-m3")
		event.attach_object_handle_to_map_part_3(4, var1, "d06w09_5-m4")
	end
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(1)
		rot_x_2 = out1 or rot_x_2
		rot_y_2 = out2 or rot_y_2
		rot_z_2 = out3 or rot_z_2
	end
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(2)
		rot_x_3 = out1 or rot_x_3
		rot_y_3 = out2 or rot_y_3
		rot_z_3 = out3 or rot_z_3
	end
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(3)
		rot_x_4 = out1 or rot_x_4
		rot_y_4 = out2 or rot_y_4
		rot_z_4 = out3 or rot_z_4
	end
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(4)
		rot_x_5 = out1 or rot_x_5
		rot_y_5 = out2 or rot_y_5
		rot_z_5 = out3 or rot_z_5
	end
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_character(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	var21 = vm.bits_float(event.get_triggered_event_data_2(11)) or var21
	event.call_command(1035, 8, var17, var18, var19, var21) -- retail: the handler rejects 5 arguments
	var17 = vm.f32(vm.f32(vm.sin(var21) * 30.0) + var17)
	var19 = vm.f32(vm.f32(vm.cos(var21) * 30.0) + var19)
	angle = vm.f32(var21 - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	event.move_object_sequence(10, var17, var18, var19, 30)
	event.rotate_object_sequence(10, 0.0, angle, 0.0, 30)
	event.set_object_sequence_motion(10, "歩き")
	event.delay_object_sequence_motion_track(10, 30)
	event.set_object_sequence_motion(10, "立ち")
	var22 = 0
	while var22 < 40 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var23 = out1 or var23
			var24 = out2 or var24
			var25 = out3 or var25
		end
		event.set_follow_camera_target(var23, var24, var25)
		event.swing_camera_control_to_angle(var21)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var22 = var22 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	var17 = vm.f32(vm.f32(vm.sin(angle) * 20.0) + var17)
	var19 = vm.f32(vm.f32(vm.cos(angle) * 20.0) + var19)
	event.load_character(5, "event/dng_inout/gekka_out.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, var17, var18, var19)
	event.set_character_rotation(12, 0.0, var21, 0.0)
	event.set_character_motion(12, "アウト", 6)
	var26 = event.load_sound_effect_file_3(8, "snd2/sp/sp_037.sound.json") or var26
	event.play_sound_effect(var26, 0)
	event.play_sound_effect(var26, 2)
	event.rotate_object_sequence_eased(0, rot_x - 1.0, rot_y, rot_z, 20, 0, 1.0)
	event.rotate_object_sequence_eased(1, rot_x_2 - 1.0, rot_y_2, rot_z_2, 20, 0, 1.0)
	event.rotate_object_sequence_eased(2, rot_x_3 - 1.0, rot_y_3, rot_z_3, 20, 0, 1.0)
	event.rotate_object_sequence_eased(3, rot_x_4 - 1.0, rot_y_4, rot_z_4, 20, 0, 1.0)
	event.rotate_object_sequence_eased(4, rot_x_5 - 1.0, rot_y_5, rot_z_5, 20, 0, 1.0)
	wait_objects(0)
	event.attach_object_handle_to_map_part_2(0, var1)
	event.get_object_handle_position(0)
	event.set_function_point_position(var1, "key1", 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, var1, "d06wa09_2-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, var1, "d06wv09_2-c")
	event.set_object_handle_visible(0, 0)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_c08bdcd7
