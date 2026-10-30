--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f10d721b()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.get_save_flag(448) or flag
	event.set_character_active(0, 8)
	if flag == 0 then
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
	end
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_2(4, "p01_shadow")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
	event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-363.94, 121.88, -75.09)
	event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
	event.fade_in_screen(30)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	wait_frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
	event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	var2 = event.get_sound_id(2) or var2
	event.play_sound_effect(var2, 92)
	wait_frames(15)
	event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 3)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(4, 1)
	event.set_character_active(1, 8)
	if flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

return helper_f10d721b
