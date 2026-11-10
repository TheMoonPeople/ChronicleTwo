--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_cf15df04()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	event.initialize_event()
	var8 = event.get_sound_id(1) or var8
	var7 = event.get_triggered_event_data_2(3) or var7
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot) -- retail: the handler rejects 5 arguments
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	if vm.imod(var7, 2) ~= 1 then
		world_coord_rot = vm.f32(-3.1415927)
	end
	if var7 == 0 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m0")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m2")
		event.set_save_counter(0, 0)
	end
	if var7 == 1 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m1")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m3")
		event.set_save_counter(0, 0)
	end
	var8 = event.get_sound_id(2) or var8
	event.play_sound_effect(var8, 66)
	if vm.imod(var7, 2) ~= 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -14.25, 1.38, 0.55)
		event.set_object_sequence_rotation(0, 0.0, -1.5, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(124.87, 22.53, -74.18)
		event.set_camera_sequence_look_at(-3.0, 27.21, 0.18)
		helper_888ab2a3(10)
		event.rotate_object_sequence(1, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -4.9415927, 0.0, 30)
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -29.1, 1.38, -0.82, 30)
		event.move_object_sequence(0, -50.41, 1.38, 0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		helper_888ab2a3(18)
		event.set_object_handle_footstep_sound(0, 3)
		helper_888ab2a3(12)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_object_handle_motion(0, "歩き", 4)
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 14.25, 1.38, -0.55)
		event.set_object_sequence_rotation(0, 0.0, -4.641593, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-124.87, 22.53, 74.18)
		event.set_camera_sequence_look_at(3.0, 27.21, -0.18)
		helper_888ab2a3(10)
		event.rotate_object_sequence(1, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.8, 0.0, 30)
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 29.1, 1.38, 0.82, 30)
		event.move_object_sequence(0, 50.41, 1.38, -0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		helper_888ab2a3(18)
		event.set_object_handle_footstep_sound(0, 3)
		helper_888ab2a3(12)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_object_handle_motion(0, "歩き", 4)
	end
	event.set_character_motion(0, "立ち", 4)
	if vm.imod(var7, 2) ~= 1 then
		event.set_character_position(0, 47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(15)
end

return helper_cf15df04
