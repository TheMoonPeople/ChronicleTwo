--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f1a67e90()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 190.0, 0.0, 3600.0)
	event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1080.93, 20.56, 4488.23)
	event.set_camera_sequence_look_at(1048.27, 47.31, 4411.07)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, 790.0, 0.0, 3600.0, 40, 2, 1.0)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	wait_frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-405.22998, 32.86, 3321.61)
	event.set_camera_sequence_look_at(-270.0, 31.8, 3450.0)
	event.set_object_handle_position(1, 790.0, 0.0, 3600.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -270.0, 30.0, 3580.0)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	var4 = event.get_sound_id(2) or var4
	event.play_sound_effect(var4, 92)
	wait_frames(30)
	event.move_object_sequence(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	wait_frames(20)
	event.move_object_sequence(0, -270.0, 0.0, 3505.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 790.0, 0.0, 3600.0)
	event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -270.0, 0.0, 3450.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

return helper_f1a67e90
