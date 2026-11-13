--!strict
--- Holds the train-stop cutscenes and setup shared by the Kazarov Stonehenge (s11) maps.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local object = vm.module("@lib/event/object")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local kazarov_stonehenge_s11 = {}

--- Fades out and jumps to map s66.
function kazarov_stonehenge_s11.leave_for_s66()
	event.initialize_event()
	event.fade_out_screen(30)
	wait.frames(30)
	event.jump_to_map_3(-1, "s66", 600)
	vm.wait(2)
end

--- Plays the arrival cutscene of the saved train number, or only places the player when no train is saved.
function kazarov_stonehenge_s11.play_arrival_for_train_id()
	local train_id: s32 = 0
	local carriage_part_x: f32 = 0
	local carriage_part_y: f32 = 0
	local carriage_part_z: f32 = 0
	local player_x: f32 = 0
	local common_sound_bank: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		train_id = event.get_save_counter(0) or train_id
		if train_id == 0 then
			train.place_player_at_saved_platform()
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0)
			event.fade_in_screen(30)
			return
		end
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.set_object_handle_position(1, 895.0, -254.5, 3348.1)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
		if train_id == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
		end
		if train_id == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
		end
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			carriage_part_x = out1 or carriage_part_x
			carriage_part_y = out2 or carriage_part_y
			carriage_part_z = out3 or carriage_part_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		player_x = 350.0
		if train_id == 2 then
			player_x = -170.0
		end
		if train_id == 3 then
			player_x = -690.0
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(player_x - vm.f32(135.23), -235.54, 3098.71)
		event.set_camera_sequence_look_at(player_x, -236.6, 3227.1)
		event.fade_in_screen(30)
		event.set_object_sequence_position(0, player_x, -220.0, 3330.0)
		event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
		event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
		event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
		common_sound_bank = event.get_sound_id(2) or common_sound_bank
		event.play_sound_effect(common_sound_bank, 92)
		resume_step = 1
		wait.frames(30)
		event.move_object_sequence(5, carriage_part_x + 45.0, carriage_part_y - 19.0, carriage_part_z, 30)
		resume_step = 2
		wait.frames(20)
		event.move_object_sequence(0, player_x, -268.4, 3227.1, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		resume_step = 3
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 4
		wait.frames(10)
		event.fade_in_screen(1)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, carriage_part_x, carriage_part_y, carriage_part_z)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		train.place_player_at_saved_platform()
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				wait.frames_skipping(20)
			end
			if resume_step <= 2 then
				cutscene.skip_command(0)
			end
			if resume_step <= 3 then
				wait.frames_skipping(10)
			end
			train.skip_place_player_at_saved_platform()
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene of the party watching Osmond's train depart.
function kazarov_stonehenge_s11.play_osmond_departure()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(648, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(6237)
		sound_bank = event.load_sound_effect_file_2(6237) or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.stop_sound_effect(sound_bank, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e600/e648/")
		event.load_message_file(0, 5, "e648_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e648_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e648_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e648_osmond.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p01_train01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e648/e648_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e648/e648_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 3.38, -9.6, -127.86)
		event.set_object_handle_rotation(0, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 23)
		event.set_object_handle_position(1, 19.72, -9.6, -146.14)
		event.set_object_handle_rotation(1, 0.0, -0.81, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 23)
		event.set_object_handle_position(2, 0.11, -2.82, -96.44)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 23)
		event.set_object_handle_position(3, 1789.1, -254.5, 3348.1)
		event.set_object_handle_rotation(3, 0.0, -1.57, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-4336.34, 1717.11, 4012.69)
		event.set_camera_sequence_look_at(-3273.36, 957.4, 3430.04)
		event.set_character_active(0, 0)
		event.set_character_active(0, 33)
		event.set_character_active(0, 34)
		event.set_character_active(0, 35)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 9)
		event.move_object_sequence_eased(3, -5344.1, 1488.8, 3348.1, 120, 1, 0.7)
		event.delay_object_sequence_rotation_track(3, 30)
		event.rotate_object_sequence_eased(3, 0.0, -1.57, -0.157, 60, 1, 1.0)
		wait.frames(120)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_sound_effect(sound_bank, 9)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_footstep_sound(2, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -2.21, 0.0, 25.73)
	event.set_character_rotation(0, 0.0, 0.03, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene of the train pulling in and the player stepping off.
function kazarov_stonehenge_s11.play_train_arrival()
	local sound_bank: s32 = 0
	local carriage_part_x: f32 = 0
	local carriage_part_y: f32 = 0
	local carriage_part_z: f32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 295.0, -254.5, 3348.1)
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
		carriage_part_x = out1 or carriage_part_x
		carriage_part_y = out2 or carriage_part_y
		carriage_part_z = out3 or carriage_part_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1431.5, 490.41, 2669.18)
	event.set_camera_sequence_look_at(497.59, -338.93, 3460.46)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, 895.0, -254.5, 3348.1, 40, 2, 1.0)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-305.23, -235.54, 3098.71)
	event.set_camera_sequence_look_at(-170.0, -236.6, 3227.1)
	event.set_object_handle_position(1, 895.0, -254.5, 3348.1)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -170.0, -220.0, 3330.0)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 92)
	wait.frames(30)
	event.move_object_sequence(5, carriage_part_x + 45.0, carriage_part_y - 19.0, carriage_part_z, 30)
	wait.frames(20)
	event.move_object_sequence(0, -170.0, -268.4, 3227.1, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 895.0, -254.5, 3348.1)
	event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, carriage_part_x, carriage_part_y, carriage_part_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -170.0, -268.4, 3227.1)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Shows or hides the p10_s48 map part.
function kazarov_stonehenge_s11.set_map_part_visible(visible: s32)
	event.attach_object_handle_to_map_part_2(0, "p10_s48")
	event.set_object_handle_visible(0, visible)
end

--- Spawns scene character 301 on the platform.
function kazarov_stonehenge_s11.spawn_platform_character()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/p00_31a.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, -205.0, -268.4, 3225.0)
	event.set_character_rotation(8, 0.0, 3.1415927, 0.0)
	event.set_scene_character_number(8, 301)
end

return kazarov_stonehenge_s11
