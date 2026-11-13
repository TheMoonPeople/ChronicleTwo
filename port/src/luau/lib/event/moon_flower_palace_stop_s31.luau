--!strict
--- Cutscenes and train-stop staging for the Moon Flower Palace stop (s31).

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local moon_flower_palace_stop_s31 = {}

--- Plays the train pulling into the stop, its doors opening and the player stepping out onto the platform.
function moon_flower_palace_stop_s31.arrive_by_train()
	local sound_bank: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_sound_id: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
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
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1080.93, 20.56, 4488.23)
	event.set_camera_sequence_look_at(1048.27, 47.31, 4411.07)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, 790.0, 0.0, 3600.0, 40, 2, 1.0)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.frames(10)
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
	door_sound_id = event.get_sound_id(2) or door_sound_id
	event.play_sound_effect(door_sound_id, 92)
	wait.frames(30)
	event.move_object_sequence(5, door_x + 22.5, door_y - 9.5, door_z, 30)
	wait.frames(20)
	event.move_object_sequence(0, -270.0, 0.0, 3505.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 790.0, 0.0, 3600.0)
	event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, door_x, door_y, door_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -270.0, 0.0, 3450.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Asks the player whether to leave and fades out the screen on a yes, returning 1 for yes and 0 otherwise.
function moon_flower_palace_stop_s31.ask_to_depart()
	local answer: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		at = 1
		answer = message.ask_yes_no(3, -1)
		if answer == 0 then
			event.fade_out_screen(20)
			at = 2
			wait.frames(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				answer = received[1] :: number
			end
			if at <= 1 then
				wait.frames_skipping(20)
			end
			return 1
		end
		return nil
	end)
end

--- Plays the player stepping off the train at the current stop, on the side given by the travel direction.
function moon_flower_palace_stop_s31.exit_train()
	local stop_index: s32 = 0
	local direction: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local exit_x: f32 = 0
	local door_sound_id: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.set_object_handle_position(1, 790.0, 0.0, 3600.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		stop_index = event.get_save_counter(0) or stop_index
		if stop_index == 0 then
			train.place_player_at_saved_platform()
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0)
			event.fade_in_screen(30)
			return
		end
		direction = event.get_save_counter(15) or direction
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if direction == 0 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			if stop_index == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			end
			if stop_index == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			if stop_index == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			end
			if stop_index == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			end
		end
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			door_x = out1 or door_x
			door_y = out2 or door_y
			door_z = out3 or door_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		exit_x = 240.0
		if stop_index == 2 then
			exit_x = -270.0
		end
		if stop_index == 3 then
			exit_x = -790.0
		end
		event.clear_camera_sequence()
		if direction == 0 then
			event.set_camera_sequence_position(exit_x - vm.f32(135.23), 32.86, 3321.61)
			event.set_camera_sequence_look_at(exit_x, 31.8, 3450.0)
		else
			event.set_camera_sequence_position(exit_x + vm.f32(135.23), 32.86, 3878.39)
			event.set_camera_sequence_look_at(exit_x, 31.8, 3750.0)
		end
		event.fade_in_screen(30)
		if direction == 0 then
			event.set_object_sequence_position(0, exit_x, 30.0, 3580.0)
			event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
		else
			event.set_object_sequence_position(0, exit_x, 25.9, 3650.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		end
		if direction == 0 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
			event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
			event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
		end
		door_sound_id = event.get_sound_id(2) or door_sound_id
		event.play_sound_effect(door_sound_id, 92)
		at = 1
		wait.frames(30)
		event.move_object_sequence(5, door_x + 22.5, door_y - 9.5, door_z, 30)
		at = 2
		wait.frames(20)
		if direction == 0 then
			event.move_object_sequence(0, exit_x, 0.0, 3500.0, 30)
		else
			event.move_object_sequence(0, exit_x, 0.0, 3700.0, 30)
		end
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 6)
		at = 3
		object.wait_until_done(0)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_sequence_motion(0, "立ち")
		at = 4
		wait.frames(10)
		event.fade_in_screen(1)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, door_x, door_y, door_z)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		train.place_player_at_saved_platform()
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				wait.frames_skipping(20)
			end
			if at <= 2 then
				cutscene.skip_command(0)
			end
			if at <= 3 then
				wait.frames_skipping(10)
			end
			train.skip_place_player_at_saved_platform()
			return 0
		end
		return nil
	end)
end

--- Loads the stage character into slot 8 and places it at its starting position.
function moon_flower_palace_stop_s31.load_stage_character()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/p00_31a.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, -300.0, 0.0, 3490.0)
	event.set_character_rotation(8, 0.0, 3.1415927, 0.0)
	event.set_scene_character_number(8, 301)
end

--- Plays the cutscene in which the train arrives at the stop and the party meets Osmond, Hikari and Nagare.
function moon_flower_palace_stop_s31.play_arrival_meeting_scene()
	local sound_bank: s32 = 0
	local player_character: s32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local frame: s32 = 0
	local bounce_amount: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(600, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(7800)
		sound_bank = event.load_sound_effect_file_2(7800) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		player_character = event.get_playable_character() or player_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e600/")
		event.load_message_file(0, 5, "e600_1.txt")
		if player_character == 0 then
			event.load_character_motion_pack(5, "e600_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if player_character == 1 then
			event.load_character_motion_pack(5, "e600_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e600_osmond.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e600_hikari.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "e600_nagare.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.attach_object_handle_to_character(6, 36)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.change_directory("")
		if player_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e600/e600_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e600/e600_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_map_part_2(3, "p01_train01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_13-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_15-m2")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_2(7, "p01_shadow-0")
		event.set_object_handle_position(0, 593.01, 30.8, 3553.84)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 583.22, 30.8, 3557.92)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 588.09, 30.8, 3562.57)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_position(3, -6000.0, 2400.0, 1600.0)
		event.set_object_handle_rotation(3, 0.2, 1.2, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_position(6, -6000.0, 2480.0, 1600.0)
		event.set_object_handle_rotation(6, 0.2, 1.2, 0.0)
		event.set_object_handle_motion(6, "ループ", 4)
		event.set_character_position(35, -6000.0, 2400.0, 1600.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1067.88, 491.78, 4477.15)
		event.set_camera_sequence_look_at(432.94, 580.78, 4182.04)
		event.move_camera_sequence_eased(1067.88, 491.78, 4477.15, 858.72, 267.72, 3985.84, 90, 2, 1.0)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 3)
		event.fade_in_screen(30)
		event.rotate_object_sequence_eased(3, 0.0, 1.57, 0.0, 60, 2, 1.0)
		event.rotate_object_sequence_eased(6, 0.0, 1.57, 0.0, 60, 2, 1.0)
		frame = 0
		while frame < 90 do
			if frame == 20 then
				event.set_character_visible(35, 0, 1, 0.033333335)
				event.set_character_visible(36, 0, 1, 0.033333335)
			end
			at = 1
			vm.wait(1)
			do
				local out1, out2, out3 = event.get_object_handle_position(3)
				train_x = out1 or train_x
				train_y = out2 or train_y
				train_z = out3 or train_z
			end
			train_x = vm.f32(train_x + vm.f32(vm.f32(790.0 - train_x) / 24.0))
			train_y = vm.f32(train_y + vm.f32(vm.f32(0.0 - train_y) / 16.0))
			train_z = vm.f32(train_z + vm.f32(vm.f32(3600.0 - train_z) / 16.0))
			event.set_object_handle_position(3, train_x, train_y, train_z)
			event.set_object_handle_position(6, train_x, train_y + 80.0, train_z)
			frame = frame + 1
		end
		event.move_object_sequence_eased(3, 790.0, 0.0, 3600.0, 30, 2, 1.0)
		event.rotate_object_sequence(3, 0.0, 1.57, 0.0, 30)
		event.move_object_sequence_eased(6, 790.0, 0.0, 3680.0, 30, 2, 1.0)
		event.rotate_object_sequence(6, 0.0, 1.57, 0.0, 30)
		bounce_amount = 2.0
		frame = 0
		while frame < 30 do
			do
				local out1, out2, out3 = event.get_object_handle_position(3)
				train_x = out1 or train_x
				train_y = out2 or train_y
				train_z = out3 or train_z
			end
			if vm.imod(frame, 2) == 0 then
				train_y = vm.f32(train_y + bounce_amount)
			else
				train_y = vm.f32(train_y - bounce_amount)
			end
			bounce_amount = vm.f32(bounce_amount - vm.f32(bounce_amount / 30.0))
			event.set_object_handle_position(3, train_x, train_y, train_z)
			frame = frame + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		object.wait_until_done(3)
		at = 4
		wait.frames(20)
		event.set_camera_sequence_position(407.12, 258.94, 3255.47)
		event.set_camera_sequence_look_at(609.92, 112.52, 3513.32)
		event.set_object_sequence_position(3, 790.0, 0.0, 3600.0)
		event.set_object_sequence_rotation(3, 0.0, 1.57, 0.0)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		at = 5
		wait.frames(10)
		event.play_sound_effect(sound_bank, 4)
		event.rotate_object_sequence_eased(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
		event.rotate_object_sequence_eased(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
		at = 6
		wait.frames(60)
		event.jump_object_sequence(0, 616.43, 0.0, 3519.44, -0.2, 20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "着地", 1)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "着地", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 7
		wait.frames(10)
		event.jump_object_sequence(1, 590.55, 0.0, 3527.36, -0.2, 20)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "着地", 1)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "着地", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 8
		object.wait_until_done(1)
		event.set_camera_sequence_position(734.79, 34.32, 3415.62)
		event.set_camera_sequence_look_at(645.05, 7.39, 3483.16)
		event.set_object_sequence_position(0, 678.03, 0.0, 3463.04)
		event.set_object_sequence_rotation(0, 0.0, 2.18, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1, 1)
		event.move_object_sequence(0, 732.73, 0.0, 3421.88, 90)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 623.2, 0.0, 3468.36)
		event.set_object_sequence_rotation(1, 0.0, 2.9, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 604.19, 0.0, 3501.3)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		message.show_voiced(6000370)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 10
		message.show_voiced(6000380)
		at = 11
		object.wait_until_done(0)
		event.set_camera_sequence_position(834.25, 32.04, 3503.77)
		event.set_camera_sequence_look_at(728.22, 120.07, 3124.24)
		event.set_object_sequence_position(0, 688.8, 11.3, 3250.37)
		event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
		event.set_object_sequence_motion(0, "指さす", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		message.show_voiced(6000390)
		event.set_camera_sequence_position(616.62, 51.57, 3428.73)
		event.set_camera_sequence_look_at(613.93, 8.94, 3476.66)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_sequence_motion(1, "上向くL", 4, -1, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.9, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(2, "歩き（上見）")
		event.move_object_sequence(2, 603.8, 0.0, 3472.38, 60)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち（上見）")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 13
		message.show_voiced(6000400)
		at = 14
		message.show_voiced(6000410)
		event.set_camera_sequence_position(0.0, 995.95, 3461.49)
		event.set_camera_sequence_look_at(0.0, 846.5, 1987.55)
		event.move_camera_sequence_eased(0.0, 25.08, 3461.49, 0.0, 392.85, 1987.55, 120, 0, 1.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_sequence_position(0, -12.0, 0.0, 3300.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(1, 12.0, 0.0, 3300.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 3320.0)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		at = 15
		wait.frames(200)
		event.move_object_sequence(0, -12.0, 14.0, 3000.0, 160, 1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(1, 12.0, 14.0, 3000.0, 160, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(2, 0.0, 9.0, 3020.0, 160, 1)
		event.set_object_sequence_motion(2, "歩き")
		at = 16
		object.wait_until_done(0)
		event.set_camera_sequence_position(35.49, 35.66, 2985.73)
		event.set_camera_sequence_look_at(5.9, 35.78, 3001.23)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "上向くL", 4, -1, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1, 1)
		event.set_object_sequence_motion(2, "立ち（上見）", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 17
		message.show_voiced(6000420)
		event.set_camera_sequence_position(-25.58, 61.54, 2959.33)
		event.set_camera_sequence_look_at(-12.23, 37.86, 2998.16)
		event.move_camera_sequence_eased(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		message.show_voiced(6000430)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		message.show_voiced(6000435)
		event.set_camera_sequence_position(0.0, 6.31, 3126.74)
		event.set_camera_sequence_look_at(0.0, 59.43, 2999.73)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		message.show_voiced(6000440)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 5)
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "上見から振り返り", 6)
		event.queue_object_sequence_next_motion(1, "上見から振り返りL", 4)
		at = 21
		message.show_voiced(6000450)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 22
		message.show_voiced(6000460)
		event.fade_out_screen(30)
		at = 23
		wait.frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			train_x = vm.f32(train_x + vm.f32(vm.f32(790.0 - train_x) / 24.0))
			train_y = vm.f32(train_y + vm.f32(vm.f32(0.0 - train_y) / 16.0))
			train_z = vm.f32(train_z + vm.f32(vm.f32(3600.0 - train_z) / 16.0))
			local _ = frame < 90
			local _ = frame == 20
			frame = frame + 1
			bounce_amount = 2.0
			frame = 0
			train_y = vm.f32(train_y + bounce_amount)
			train_y = vm.f32(train_y - bounce_amount)
			bounce_amount = vm.f32(bounce_amount - vm.f32(bounce_amount / 30.0))
			local _ = frame < 30
			local _ = vm.imod(frame, 2) == 0
			frame = frame + 1
		end
		if at <= 2 then
			cutscene.skip_command(3)
		end
		if at <= 3 then
			wait.frames_skipping(20)
		end
		if at <= 4 then
			wait.frames_skipping(10)
		end
		if at <= 5 then
			wait.frames_skipping(60)
		end
		if at <= 6 then
			wait.frames_skipping(10)
		end
		if at <= 7 then
			cutscene.skip_command(1)
		end
		if at <= 8 then
			message.show_voiced_skipping(6000370)
		end
		if at <= 9 then
			message.show_voiced_skipping(6000380)
		end
		if at <= 10 then
			cutscene.skip_command(0)
		end
		if at <= 11 then
			message.show_voiced_skipping(6000390)
		end
		if at <= 12 then
			message.show_voiced_skipping(6000400)
		end
		if at <= 13 then
			message.show_voiced_skipping(6000410)
		end
		if at <= 14 then
			wait.frames_skipping(200)
		end
		if at <= 15 then
			cutscene.skip_command(0)
		end
		if at <= 16 then
			message.show_voiced_skipping(6000420)
		end
		if at <= 17 then
			message.show_voiced_skipping(6000430)
		end
		if at <= 18 then
			message.show_voiced_skipping(6000435)
		end
		if at <= 19 then
			message.show_voiced_skipping(6000440)
		end
		if at <= 20 then
			message.show_voiced_skipping(6000450)
		end
		if at <= 21 then
			message.show_voiced_skipping(6000460)
		end
		if at <= 22 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_visible(7, 1)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_position(3, 790.0, 0.0, 3600.0)
	event.set_object_handle_rotation(3, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays the cutscene in which spiked barriers rise from the ground amid dust clouds.
function moon_flower_palace_stop_s31.play_spikes_rising_scene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(166)
		event.play_music(0)
		event.load_map_sounds(7811)
		sound_bank = event.load_sound_effect_file_2(7811) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(4, "p01_toge-0")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(5, "p01_toge-1")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.initialize_effect_manager(5)
		event.load_effect_base("e612砂煙")
		event.create_effect_work_buffer(5)
		event.set_object_handle_position(4, 674.4, -314.4, 2807.93)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(4, 1)
		event.set_object_handle_position(5, -998.0, -343.6, 2925.65)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(5, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1225.24, 296.8, 2174.0)
		event.set_camera_sequence_look_at(1176.18, 319.43, 2038.46)
		event.shake_camera_sequence(0.0, 2.4, 0.2, -1)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		wait.frames(30)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(674.4, 40.0, 2807.93)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(861.02, 134.12, 2949.14)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(643.56, 119.57, 2978.62)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.set_camera_sequence_position(936.44, 592.45, 3336.76)
		event.set_camera_sequence_look_at(714.95, 229.99, 2890.91)
		event.play_sound_effect(sound_bank, 1)
		event.move_object_sequence(4, 674.4, 40.0, 2807.93, 10)
		wait.frames(20)
		event.set_camera_sequence_position(-1432.81, 435.38, 3449.66)
		event.set_camera_sequence_look_at(-1123.85, 241.13, 3144.02)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(-1252.94, 0.8, 3245.52)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(-1008.78, 0.4, 3092.24)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.create_effect("e612砂煙")
		event.set_effect_first_vector(-1174.3, 0.78, 2981.77)
		event.set_effect_second_vector(20.0, 20.0, 20.0)
		event.play_sound_effect(sound_bank, 1)
		event.move_object_sequence(5, -998.0, 9.62, 2925.65, 10)
		wait.frames(15)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.skip_next_music_load()
	event.clear_camera_sequence()
	event.set_character_active(1, 0)
	event.delete_event_image(0)
	event.clear_effect_manager()
end

--- Plays the cutscene in which the Sun character stands dejected and looks up at the sky, then ends the event.
function moon_flower_palace_stop_s31.play_sun_despair_scene()
	vm.section(function()
		event.set_save_flag(724, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		wait.frames(6)
		event.load_music(113)
		event.play_music(0)
		event.load_map_sounds(7829)
		event.change_directory("event/e700/e724/")
		event.load_message_file(0, 5, "e724_1.txt")
		event.load_character(5, "e724_sun.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.attach_object_handle_to_map_part_2(2, "p01_shadow-0")
		event.change_directory("")
		event.load_character(5, "event/e700/e704/kaisou_waku.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.set_object_handle_position(0, 0.0, 0.0, 3500.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "呆然目パチ")
		event.set_object_handle_visible(1, 0)
		event.set_object_handle_visible(2, 0)
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
		event.enable_drama_skip()
		event.move_object_sequence(0, 0.0, 0.0, 3600.0, 120)
		event.set_object_sequence_motion(0, "しょんぼり歩き", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 13.49, 3735.45)
		event.set_camera_sequence_look_at(0.0, 32.22, 3509.35)
		event.keep_character_in_front_of_camera_sequence(9, 610.7, -1)
		event.fade_in_screen(30)
		object.wait_until_done(0)
		event.set_camera_sequence_position(59.11, 9.92, 3492.87)
		event.set_camera_sequence_look_at(0.0, 17.92, 3578.09)
		event.move_object_sequence(0, 0.0, 0.0, 3650.0, 80)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "しょんぼり立ち")
		wait.frames(60)
		event.set_camera_sequence_position(60.0, 16.0, 3650.0)
		event.set_camera_sequence_look_at(0.0, 16.0, 3650.0)
		object.wait_until_done(0)
		wait.frames(10)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 60.0, 800, 0, 0.1)
		event.set_object_sequence_motion(0, "顔を上に上げる", 2)
		event.queue_object_sequence_next_motion(0, "顔を上に上げるＬ", 4)
		message.show_voiced_with_button_prompt(7240010, -1, 10)
		message.show_voiced_with_button_prompt(7240020, -1, 10)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "顔を上から下", 2)
		event.queue_object_sequence_next_motion(0, "顔を上から下Ｌ", 4)
		message.show_voiced_with_button_prompt(7240030, -1, 10)
		message.show_voiced_with_button_prompt(7240040, -1, 10)
		message.show_voiced_with_button_prompt(7240050, -1, 10)
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 33.0, 3690.0)
		event.set_camera_sequence_look_at(0.0, 13.5, 3650.0)
		message.show_voiced_with_button_prompt(7240060, -1, 10)
		event.move_camera_sequence_eased(0.0, 433.0, 4490.0, 0.0, 13.5, 3650.0, 150, 1, 0.2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_motion(0, "空を見上げる", 2)
		event.queue_object_sequence_next_motion(0, "空を見上げるＬ", 4)
		message.show_voiced_for(7240070, 120)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.set_character_active(1, 0)
	event.stop_music(0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.skip_next_music_load()
	event.finish_event()
end

return moon_flower_palace_stop_s31
