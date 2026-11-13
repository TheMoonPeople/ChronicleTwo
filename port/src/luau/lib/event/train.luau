--!strict
--- Holds the station and train cutscenes: platform placement, boarding sequences, their skip-mode stand-ins and the train part visibility setup.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local train = {}

--- Plays the cutscene of the saved train at the platform lowering its gangway and the player stepping off; with no saved train it only places the player at the platform and fades in.
function train.alight()
	local train_id: s32 = 0
	local side_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local platform_x: f32 = 0
	local sound_id: s32 = 0
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
		side_id = event.get_save_counter(15) or side_id
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if side_id == 0 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			if train_id == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			end
			if train_id == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			if train_id == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			end
			if train_id == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
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
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		platform_x = -240.0
		if train_id == 2 then
			platform_x = 270.0
		end
		if train_id == 3 then
			platform_x = 790.0
		end
		event.clear_camera_sequence()
		if side_id == 0 then
			event.set_camera_sequence_position(platform_x + vm.f32(135.23), 32.86, 4778.39)
			event.set_camera_sequence_look_at(platform_x, 31.8, 4650.0)
		else
			event.set_camera_sequence_position(platform_x - vm.f32(135.23), 32.86, 4221.61)
			event.set_camera_sequence_look_at(platform_x, 31.8, 4350.0)
		end
		event.fade_in_screen(30)
		if side_id == 0 then
			event.set_object_sequence_position(0, platform_x, 25.9, 4550.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		else
			event.set_object_sequence_position(0, platform_x, 30.0, 4480.0)
			event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
		end
		if side_id == 0 then
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
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		resume_step = 1
		wait.frames(30)
		event.move_object_sequence(5, gangway_x - 22.5, gangway_y - 9.5, gangway_z, 30)
		resume_step = 2
		wait.frames(20)
		if side_id == 0 then
			event.move_object_sequence(0, platform_x, 0.0, 4600.0, 30)
		else
			event.move_object_sequence(0, platform_x, 0.0, 4400.0, 30)
		end
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 6)
		resume_step = 3
		object.wait_until_done(0)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 4
		wait.frames(10)
		event.fade_in_screen(1)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, gangway_x, gangway_y, gangway_z)
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

--- Plays the cutscene of the saved train at the platform lowering its gangway and the player stepping off, for the main map scripts; with no saved train it only places the player at the platform and fades in.
function train.alight_primary()
	local train_id: s32 = 0
	local side_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local platform_x: f32 = 0
	local sound_id: s32 = 0
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
		side_id = event.get_save_counter(15) or side_id
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if side_id == 0 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			if train_id == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			end
			if train_id == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			if train_id == 2 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
				event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
				event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			end
			if train_id == 3 then
				event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
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
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		platform_x = -240.0
		if train_id == 2 then
			platform_x = 270.0
		end
		if train_id == 3 then
			platform_x = 790.0
		end
		event.clear_camera_sequence()
		if side_id == 0 then
			event.set_camera_sequence_position(platform_x + vm.f32(135.23), 32.86, 4778.39)
			event.set_camera_sequence_look_at(platform_x, 31.8, 4650.0)
		else
			event.set_camera_sequence_position(platform_x - vm.f32(135.23), 32.86, 4221.61)
			event.set_camera_sequence_look_at(platform_x, 31.8, 4350.0)
		end
		event.fade_in_screen(30)
		if side_id == 0 then
			event.set_object_sequence_position(0, platform_x, 25.9, 4550.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		else
			event.set_object_sequence_position(0, platform_x, 30.0, 4480.0)
			event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
		end
		if side_id == 0 then
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
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		resume_step = 1
		wait.for_frame_count(30)
		event.move_object_sequence(5, gangway_x - 22.5, gangway_y - 9.5, gangway_z, 30)
		resume_step = 2
		wait.for_frame_count(20)
		if side_id == 0 then
			event.move_object_sequence(0, platform_x, 0.0, 4600.0, 30)
		else
			event.move_object_sequence(0, platform_x, 0.0, 4400.0, 30)
		end
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 6)
		resume_step = 3
		object.wait_until_done(0)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 4
		wait.for_frame_count(10)
		event.fade_in_screen(1)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, gangway_x, gangway_y, gangway_z)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		train.place_player_at_saved_platform()
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 2 then
				cutscene.skip_command(0)
			end
			if resume_step <= 3 then
				wait.skip_frame_count(10)
			end
			train.skip_place_player_at_saved_platform()
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene of the train pulling into the station, lowering its gangway and the player stepping off.
function train.arrive_at_station()
	local arrival_sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	arrival_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or arrival_sound_id
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, -190.0, 0.0, 4500.0)
	event.set_object_sequence_rotation(1, 0.0, -1.57, 0.0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		gangway_x = out1 or gangway_x
		gangway_y = out2 or gangway_y
		gangway_z = out3 or gangway_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1323.57, 7.45, 4810.3)
	event.set_camera_sequence_look_at(-994.3, 130.62, 4578.42)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, -790.0, 0.0, 4500.0, 40, 2, 1.0)
	event.play_sound_effect(arrival_sound_id, 0)
	object.wait_until_done(1)
	wait.frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-375.22998, 32.86, 4221.61)
	event.set_camera_sequence_look_at(-240.0, 31.8, 4350.0)
	event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -240.0, 30.0, 4480.0)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 92)
	wait.frames(30)
	event.move_object_sequence(5, gangway_x - 22.5, gangway_y - 9.5, gangway_z, 30)
	wait.frames(20)
	event.move_object_sequence(0, -240.0, 0.0, 4405.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
	event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, gangway_x, gangway_y, gangway_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -240.0, 0.0, 4350.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Plays the cutscene of the train pulling into the station, lowering its gangway and the player stepping off, for the main map scripts.
function train.arrive_at_station_primary()
	local arrival_sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	arrival_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or arrival_sound_id
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, -190.0, 0.0, 4500.0)
	event.set_object_sequence_rotation(1, 0.0, -1.57, 0.0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		gangway_x = out1 or gangway_x
		gangway_y = out2 or gangway_y
		gangway_z = out3 or gangway_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1323.57, 7.45, 4810.3)
	event.set_camera_sequence_look_at(-994.3, 130.62, 4578.42)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, -790.0, 0.0, 4500.0, 40, 2, 1.0)
	event.play_sound_effect(arrival_sound_id, 0)
	object.wait_until_done(1)
	wait.for_frame_count(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-375.22998, 32.86, 4221.61)
	event.set_camera_sequence_look_at(-240.0, 31.8, 4350.0)
	event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -240.0, 30.0, 4480.0)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 92)
	wait.for_frame_count(30)
	event.move_object_sequence(5, gangway_x - 22.5, gangway_y - 9.5, gangway_z, 30)
	wait.for_frame_count(20)
	event.move_object_sequence(0, -240.0, 0.0, 4405.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -790.0, 0.0, 4500.0)
	event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, gangway_x, gangway_y, gangway_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -240.0, 0.0, 4350.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Plays the cutscene of the player walking into the three-door train with its doors turning, then fades out and back in.
function train.board_short_train()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local train_id: s32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	sound_id = event.get_sound_id(1) or sound_id
	train_id = event.get_triggered_event_data_2(3) or train_id
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_x, world_y, world_z, world_rotation) -- retail: the handler rejects 5 arguments
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	if vm.imod(train_id, 2) ~= 1 then
		world_rotation = vm.f32(-3.1415927)
	end
	if train_id == 0 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m0")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m2")
		event.set_save_counter(0, 0)
	end
	if train_id == 1 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m1")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m3")
		event.set_save_counter(0, 0)
	end
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 66)
	if vm.imod(train_id, 2) ~= 1 then
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
		wait.frames(10)
		event.rotate_object_sequence(1, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -4.9415927, 0.0, 30)
		wait.frames(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -29.1, 1.38, -0.82, 30)
		event.move_object_sequence(0, -50.41, 1.38, 0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		wait.frames(18)
		event.set_object_handle_footstep_sound(0, 3)
		wait.frames(12)
		event.fade_out_screen(30)
		wait.frames(30)
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
		wait.frames(10)
		event.rotate_object_sequence(1, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.8, 0.0, 30)
		wait.frames(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 29.1, 1.38, 0.82, 30)
		event.move_object_sequence(0, 50.41, 1.38, -0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		wait.frames(18)
		event.set_object_handle_footstep_sound(0, 3)
		wait.frames(12)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_object_handle_motion(0, "歩き", 4)
	end
	event.set_character_motion(0, "立ち", 4)
	if vm.imod(train_id, 2) ~= 1 then
		event.set_character_position(0, 47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(15)
end

--- Plays the cutscene of the player walking into the three-door train with its doors turning, then fades out and back in.
function train.board_short_train_primary()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local train_id: s32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	sound_id = event.get_sound_id(1) or sound_id
	train_id = event.get_triggered_event_data_2(3) or train_id
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_x, world_y, world_z, world_rotation) -- retail: the handler rejects 5 arguments
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	if vm.imod(train_id, 2) ~= 1 then
		world_rotation = vm.f32(-3.1415927)
	end
	if train_id == 0 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m0")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m2")
		event.set_save_counter(0, 0)
	end
	if train_id == 1 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train11-m1")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train12-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train12-m3")
		event.set_save_counter(0, 0)
	end
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 66)
	if vm.imod(train_id, 2) ~= 1 then
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
		wait.for_frame_count(10)
		event.rotate_object_sequence(1, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -4.9415927, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -4.9415927, 0.0, 30)
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -29.1, 1.38, -0.82, 30)
		event.move_object_sequence(0, -50.41, 1.38, 0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		wait.for_frame_count(18)
		event.set_object_handle_footstep_sound(0, 3)
		wait.for_frame_count(12)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
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
		wait.for_frame_count(10)
		event.rotate_object_sequence(1, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.8, 0.0, 30)
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 29.1, 1.38, 0.82, 30)
		event.move_object_sequence(0, 50.41, 1.38, -0.05, 30)
		event.set_object_handle_footstep_sound(0, 6)
		wait.for_frame_count(18)
		event.set_object_handle_footstep_sound(0, 3)
		wait.for_frame_count(12)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_object_handle_motion(0, "歩き", 4)
	end
	event.set_character_motion(0, "立ち", 4)
	if vm.imod(train_id, 2) ~= 1 then
		event.set_character_position(0, 47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -47.2, 25.3, -65.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(15)
end

--- Plays the cutscene of the player walking along the platform into the train with its doors opening, then fades out.
function train.board_train(platform_variant: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local player_y: f32 = 0
	local first_walk_y: f32 = 0
	local second_walk_y: f32 = 0
	local world_rotation: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_id: s32 = 0
	local footstep_sound: s32 = 0
	local map_number: s32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	event.get_sound_id(1)
	train_id = event.get_triggered_event_data_2(3) or train_id
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_x, world_y, world_z, world_rotation) -- retail: the handler rejects 5 arguments
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	print("train_id=", train_id, "---------------\n")
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	if platform_variant ~= 0 then
		player_y = vm.f32(5.51)
		first_walk_y = vm.f32(19.05)
		second_walk_y = vm.f32(19.05)
		footstep_sound = 6
	else
		player_y = 19.75
		first_walk_y = 19.75
		second_walk_y = 19.75
		footstep_sound = 2
		map_number = event.get_current_map() or map_number
		if map_number == 83 then
			player_y = vm.f32(14.049999)
			first_walk_y = vm.f32(17.05)
			second_walk_y = vm.f32(22.05)
			event.set_object_handle_position(0, train_x, train_y - 2.0, train_z)
			footstep_sound = 3
		end
		if map_number == 54 then
			player_y = vm.f32(20.55)
			first_walk_y = vm.f32(20.55)
			second_walk_y = vm.f32(22.05)
			footstep_sound = 2
		end
	end
	if vm.imod(train_id, 2) ~= 1 then
		world_rotation = vm.f32(-3.1415927)
	end
	if train_id == 2 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m0")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m1")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m12")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m13")
		event.set_save_counter(0, 1)
	end
	if train_id == 3 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m2")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m3")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m3")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m2")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m15")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m14")
		event.set_save_counter(0, 1)
	end
	if train_id == 4 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m4")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m5")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m4")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m5")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m16")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m17")
		event.set_save_counter(0, 2)
	end
	if train_id == 5 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m6")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m7")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m6")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m7")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m18")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m19")
		event.set_save_counter(0, 2)
	end
	if train_id == 6 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m8")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m9")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m8")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m9")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m20")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m21")
		event.set_save_counter(0, 3)
	end
	if train_id == 7 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m10")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m11")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m10")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m11")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m22")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m23")
		event.set_save_counter(0, 3)
	end
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 66)
	if vm.imod(train_id, 2) ~= 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 12.08, player_y, 0.42)
		event.set_object_sequence_rotation(0, 0.0, -1.5015928, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(124.87, 46.06, -74.18)
		event.set_camera_sequence_look_at(-3.0, 50.74, 0.18)
		wait.frames(10)
		event.rotate_object_sequence(1, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		wait.frames(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -5.04, first_walk_y, 0.84, 30)
		event.move_object_sequence(0, -33.49, second_walk_y, -0.56, 30)
		event.set_object_handle_footstep_sound(0, footstep_sound)
		wait.frames(18)
		event.set_object_handle_footstep_sound(0, 4)
		wait.frames(12)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_object_handle_motion(0, "立ち", 4)
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -12.08, player_y, -0.42)
		event.set_object_sequence_rotation(0, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-124.87, 46.06, 74.18)
		event.set_camera_sequence_look_at(3.0, 50.74, -0.18)
		wait.frames(10)
		event.rotate_object_sequence(1, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, 1.5, 0.0, 30)
		wait.frames(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 5.04, first_walk_y, -0.84, 30)
		event.move_object_sequence(0, 33.49, second_walk_y, 0.56, 30)
		event.set_object_handle_footstep_sound(0, footstep_sound)
		wait.frames(18)
		event.set_object_handle_footstep_sound(0, 4)
		wait.frames(12)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_object_handle_motion(0, "立ち", 4)
	end
	if vm.imod(train_id, 2) ~= 1 then
		event.set_character_position(0, 65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	event.set_object_handle_position(0, train_x, train_y, train_z)
end

--- Plays the cutscene of the player walking along the platform into the train with its doors opening, then fades out.
function train.board_train_primary(platform_variant: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local player_y: f32 = 0
	local first_walk_y: f32 = 0
	local second_walk_y: f32 = 0
	local world_rotation: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_id: s32 = 0
	local footstep_sound: s32 = 0
	local map_number: s32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	event.get_sound_id(1)
	train_id = event.get_triggered_event_data_2(3) or train_id
	event.get_triggered_event_data_2(4)
	event.call_command(1035, 8, world_x, world_y, world_z, world_rotation) -- retail: the handler rejects 5 arguments
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	print("train_id=", train_id, "---------------\n")
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	if platform_variant ~= 0 then
		player_y = vm.f32(5.51)
		first_walk_y = vm.f32(19.05)
		second_walk_y = vm.f32(19.05)
		footstep_sound = 6
	else
		player_y = 19.75
		first_walk_y = 19.75
		second_walk_y = 19.75
		footstep_sound = 2
		map_number = event.get_current_map() or map_number
		if map_number == 83 then
			player_y = vm.f32(14.049999)
			first_walk_y = vm.f32(17.05)
			second_walk_y = vm.f32(22.05)
			event.set_object_handle_position(0, train_x, train_y - 2.0, train_z)
			footstep_sound = 3
		end
		if map_number == 54 then
			player_y = vm.f32(20.55)
			first_walk_y = vm.f32(20.55)
			second_walk_y = vm.f32(22.05)
			footstep_sound = 2
		end
	end
	if vm.imod(train_id, 2) ~= 1 then
		world_rotation = vm.f32(-3.1415927)
	end
	if train_id == 2 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m0")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m1")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m0")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m1")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m12")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m13")
		event.set_save_counter(0, 1)
	end
	if train_id == 3 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m2")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m3")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m3")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m2")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m15")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m14")
		event.set_save_counter(0, 1)
	end
	if train_id == 4 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m4")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m5")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m4")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m5")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m16")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m17")
		event.set_save_counter(0, 2)
	end
	if train_id == 5 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m6")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m7")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m6")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m7")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m18")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m19")
		event.set_save_counter(0, 2)
	end
	if train_id == 6 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m8")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m9")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m8")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m9")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m20")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m21")
		event.set_save_counter(0, 3)
	end
	if train_id == 7 then
		event.attach_object_handle_to_map_part_3(1, "p01_train01", "train08-m10")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m11")
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train10-m10")
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m11")
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m22")
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m23")
		event.set_save_counter(0, 3)
	end
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 66)
	if vm.imod(train_id, 2) ~= 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 12.08, player_y, 0.42)
		event.set_object_sequence_rotation(0, 0.0, -1.5015928, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(124.87, 46.06, -74.18)
		event.set_camera_sequence_look_at(-3.0, 50.74, 0.18)
		wait.for_frame_count(10)
		event.rotate_object_sequence(1, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -5.04, first_walk_y, 0.84, 30)
		event.move_object_sequence(0, -33.49, second_walk_y, -0.56, 30)
		event.set_object_handle_footstep_sound(0, footstep_sound)
		wait.for_frame_count(18)
		event.set_object_handle_footstep_sound(0, 4)
		wait.for_frame_count(12)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_object_handle_motion(0, "立ち", 4)
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -12.08, player_y, -0.42)
		event.set_object_sequence_rotation(0, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-124.87, 46.06, 74.18)
		event.set_camera_sequence_look_at(3.0, 50.74, -0.18)
		wait.for_frame_count(10)
		event.rotate_object_sequence(1, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, 1.5, 0.0, 30)
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 5.04, first_walk_y, -0.84, 30)
		event.move_object_sequence(0, 33.49, second_walk_y, 0.56, 30)
		event.set_object_handle_footstep_sound(0, footstep_sound)
		wait.for_frame_count(18)
		event.set_object_handle_footstep_sound(0, 4)
		wait.for_frame_count(12)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_object_handle_motion(0, "立ち", 4)
	end
	if vm.imod(train_id, 2) ~= 1 then
		event.set_character_position(0, 65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, -1.57, 0.0)
	else
		event.set_character_position(0, -65.0, 36.0, 0.0)
		event.set_character_rotation(0, 0.0, 1.57, 0.0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_2(0, "p01_train01")
	event.set_object_handle_position(0, train_x, train_y, train_z)
end

--- Waits through the frame counts of the train boarding cutscene without delaying; this stands in for train.board_train when events are skipped.
function train.board_train_skipping()
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(18)
	wait.frames_skipping(12)
	wait.frames_skipping(30)
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(18)
	wait.frames_skipping(12)
	wait.frames_skipping(30)
end

--- Waits through the frame counts of the train boarding cutscene without delaying; this stands in for train.board_train_primary when events are skipped.
function train.board_train_skipping_primary(platform_variant: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	print("train_id=", train_id, "---------------\n")
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(18)
	wait.frames_skipping(12)
	wait.frames_skipping(30)
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(18)
	wait.frames_skipping(12)
	wait.frames_skipping(30)
end

--- Plays the cutscene of the player running along the opened gangway into the train, then fades out, and finishes the sequence on skip.
function train.board_train_via_gangway()
	local map_number: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local event_rotation: f32 = 0
	local train_id: s32 = 0
	local world_rotation: f32 = 0
	local part_variant: s32 = 0
	local sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local player_y: f32 = 0
	local player_x: f32 = 0
	local footstep_sound: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		map_number = event.get_current_map() or map_number
		event.initialize_event()
		event.get_sound_id(1)
		train_id = event.get_triggered_event_data_2(3) or train_id
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_x, world_y, world_z, event_rotation) -- retail: the handler rejects 5 arguments
		print("train_id=", train_id, "----------------\n")
		print("fpos[0]=", vm.float(world_x), "---------------\n")
		print("fpos[1]=", vm.float(world_y), "---------------\n")
		print("fpos[2]=", vm.float(world_z), "---------------\n")
		if world_z < 4500.0 then
			world_rotation = vm.f32(1.5707964)
		else
			world_rotation = vm.f32(-1.5707964)
		end
		if map_number == 76 then
			if world_z < 3600.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 72 then
			if world_z < 4500.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 34 or map_number == 16 or map_number == 54 then
			world_rotation = vm.f32(3.1415927)
		end
		if map_number == 87 then
			world_rotation = vm.f32(2.3561945)
		end
		if map_number == 83 or map_number == 103 then
			world_rotation = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		part_variant = 0
		if map_number == 34 or map_number == 54 or map_number == 87 or map_number == 103 or map_number == 76 then
			part_variant = 1
		end
		if train_id == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			event.set_save_counter(0, 1)
		end
		if train_id == 5 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			event.set_save_counter(0, 1)
		end
		if train_id == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			event.set_save_counter(0, 2)
		end
		if train_id == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			event.set_save_counter(0, 2)
		end
		if train_id == 6 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			event.set_save_counter(0, 3)
		end
		if train_id == 7 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			event.set_save_counter(0, 3)
		end
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		player_y = 0.0
		player_x = 46.0
		if map_number == 34 then
			player_y = vm.f32(35.8)
		end
		if map_number == 16 then
			player_y = vm.f32(-7.86)
		end
		if map_number == 54 then
			player_y = 36.0
		end
		if map_number == 83 then
			player_y = vm.f32(29.22)
		end
		if map_number == 87 then
			player_y = -6.0
		end
		if map_number == 103 then
			player_y = vm.f32(-13.87)
		end
		if map_number == 72 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		if map_number == 76 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		if map_number == 155 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		event.set_object_sequence_position(0, player_x, player_y, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if map_number == 34 or map_number == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if map_number == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		progress_step = 1
		wait.frames(10)
		if vm.imod(train_id, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 2
				wait.frames(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				progress_step = 3
				wait.frames(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x + 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 4
					wait.frames(20)
				else
					event.move_object_sequence(5, gangway_x + 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 5
					wait.frames(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 6
				wait.frames(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				progress_step = 7
				wait.frames(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x - 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 8
					wait.frames(20)
				else
					event.move_object_sequence(5, gangway_x - 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 9
					wait.frames(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		footstep_sound = 0
		if
			map_number == 16
			or map_number == 83
			or map_number == 87
			or map_number == 103
			or map_number == 72
			or map_number == 76
			or map_number == 155
		then
			print("てつのあしおと\n")
			footstep_sound = 6
		end
		if map_number == 34 or map_number == 54 then
			print("いしのあしおと\n")
			footstep_sound = 2
		end
		event.set_object_handle_footstep_sound(0, footstep_sound)
		progress_step = 10
		wait.frames(30)
		event.fade_out_screen(30)
		progress_step = 11
		wait.frames(30)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_motion(0, "立ち", 4)
		if vm.imod(train_id, 2) ~= 1 then
			event.set_character_position(0, 50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
		else
			event.set_character_position(0, -50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if progress_step <= 11 then
			if progress_step <= 1 then
				wait.frames_skipping(20)
			end
			if progress_step <= 2 then
				wait.frames_skipping(30)
			end
			if progress_step <= 3 then
				wait.frames_skipping(20)
			end
			if progress_step <= 4 then
				wait.frames_skipping(10)
			end
			if progress_step <= 5 then
				wait.frames_skipping(20)
			end
			if progress_step <= 6 then
				wait.frames_skipping(30)
			end
			if progress_step <= 7 then
				wait.frames_skipping(20)
			end
			if progress_step <= 8 then
				wait.frames_skipping(10)
			end
			if progress_step <= 9 then
				footstep_sound = 0
				print("てつのあしおと\n")
				footstep_sound = 6
				print("いしのあしおと\n")
				footstep_sound = 2
				wait.frames_skipping(30)
			end
			if progress_step <= 10 then
				wait.frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene of the player running along the opened gangway into the train, then fades out, and finishes the sequence on skip.
function train.board_train_via_gangway_primary()
	local map_number: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local event_rotation: f32 = 0
	local train_id: s32 = 0
	local world_rotation: f32 = 0
	local part_variant: s32 = 0
	local sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local player_y: f32 = 0
	local footstep_sound: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		map_number = event.get_current_map() or map_number
		event.initialize_event()
		event.get_sound_id(1)
		train_id = event.get_triggered_event_data_2(3) or train_id
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_x, world_y, world_z, event_rotation) -- retail: the handler rejects 5 arguments
		print("train_id=", train_id, "----------------\n")
		print("fpos[0]=", vm.float(world_x), "---------------\n")
		print("fpos[1]=", vm.float(world_y), "---------------\n")
		print("fpos[2]=", vm.float(world_z), "---------------\n")
		if world_z < 4500.0 then
			world_rotation = vm.f32(1.5707964)
		else
			world_rotation = vm.f32(-1.5707964)
		end
		if map_number == 76 then
			if world_z < 3600.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 72 then
			if world_z < 4500.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 34 or map_number == 16 or map_number == 54 then
			world_rotation = vm.f32(3.1415927)
		end
		if map_number == 87 then
			world_rotation = vm.f32(2.3561945)
		end
		if map_number == 83 or map_number == 103 then
			world_rotation = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		part_variant = 0
		if map_number == 34 or map_number == 54 or map_number == 87 or map_number == 103 or map_number == 76 then
			part_variant = 1
		end
		if train_id == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			event.set_save_counter(0, 1)
		end
		if train_id == 5 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			event.set_save_counter(0, 1)
		end
		if train_id == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			event.set_save_counter(0, 2)
		end
		if train_id == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			event.set_save_counter(0, 2)
		end
		if train_id == 6 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			event.set_save_counter(0, 3)
		end
		if train_id == 7 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			event.set_save_counter(0, 3)
		end
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		player_y = 0.0
		if map_number == 34 then
			player_y = vm.f32(35.8)
		end
		if map_number == 54 then
			player_y = 36.0
		end
		if map_number == 83 then
			player_y = vm.f32(29.22)
		end
		if map_number == 103 then
			player_y = vm.f32(-13.87)
		end
		event.set_object_sequence_position(0, 46.0, player_y, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if map_number == 34 or map_number == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if map_number == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		progress_step = 1
		wait.for_frame_count(10)
		if vm.imod(train_id, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 2
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				progress_step = 3
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x + 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 4
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x + 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 5
					wait.for_frame_count(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 6
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				progress_step = 7
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x - 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 8
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x - 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 9
					wait.for_frame_count(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		footstep_sound = 0
		if
			map_number == 16
			or map_number == 83
			or map_number == 87
			or map_number == 103
			or map_number == 72
			or map_number == 76
			or map_number == 155
		then
			print("てつのあしおと\n")
			footstep_sound = 6
		end
		if map_number == 34 or map_number == 54 then
			print("いしのあしおと\n")
			footstep_sound = 2
		end
		event.set_object_handle_footstep_sound(0, footstep_sound)
		progress_step = 10
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		progress_step = 11
		wait.for_frame_count(30)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_motion(0, "立ち", 4)
		if vm.imod(train_id, 2) ~= 1 then
			event.set_character_position(0, 50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
		else
			event.set_character_position(0, -50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if progress_step <= 11 then
			if progress_step <= 1 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 2 then
				wait.skip_frame_count(30)
			end
			if progress_step <= 3 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 4 then
				wait.skip_frame_count(10)
			end
			if progress_step <= 5 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 6 then
				wait.skip_frame_count(30)
			end
			if progress_step <= 7 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 8 then
				wait.skip_frame_count(10)
			end
			if progress_step <= 9 then
				footstep_sound = 0
				print("てつのあしおと\n")
				footstep_sound = 6
				print("いしのあしおと\n")
				footstep_sound = 2
				wait.skip_frame_count(30)
			end
			if progress_step <= 10 then
				wait.skip_frame_count(30)
			end
			return 0
		end
		return nil
	end)
end

--- Waits through the frame counts of the gangway boarding cutscene without delaying; this stands in for train.board_train_via_gangway when events are skipped.
function train.board_train_via_gangway_skipping()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(30)
	wait.frames_skipping(20)
	wait.frames_skipping(10)
	wait.frames_skipping(20)
	wait.frames_skipping(30)
	wait.frames_skipping(20)
	wait.frames_skipping(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	wait.frames_skipping(30)
	wait.frames_skipping(30)
end

--- Waits through the frame counts of the gangway boarding cutscene without delaying; this stands in for train.board_train_via_gangway_primary when events are skipped.
function train.board_train_via_gangway_skipping_primary()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	wait.skip_frame_count(30)
	wait.skip_frame_count(30)
end

--- Plays the cutscene of the player running along the opened gangway into the train for the main map scripts, then fades out the screen and places the player inside.
function train.board_via_gangway_main()
	local map_number: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation_input: f32 = 0
	local train_id: s32 = 0
	local world_rotation: f32 = 0
	local part_variant: s32 = 0
	local sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local player_y: f32 = 0
	local player_x: f32 = 0
	local footstep_sound: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		map_number = event.get_current_map() or map_number
		event.initialize_event()
		event.get_sound_id(1)
		train_id = event.get_triggered_event_data_2(3) or train_id
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_x, world_y, world_z, world_rotation_input) -- retail: the handler rejects 5 arguments
		print("train_id=", train_id, "----------------\n")
		print("fpos[0]=", vm.float(world_x), "---------------\n")
		print("fpos[1]=", vm.float(world_y), "---------------\n")
		print("fpos[2]=", vm.float(world_z), "---------------\n")
		if world_z < 4500.0 then
			world_rotation = vm.f32(1.5707964)
		else
			world_rotation = vm.f32(-1.5707964)
		end
		if map_number == 76 then
			if world_z < 3600.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 72 then
			if world_z < 4500.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 34 or map_number == 16 or map_number == 54 then
			world_rotation = vm.f32(3.1415927)
		end
		if map_number == 87 then
			world_rotation = vm.f32(2.3561945)
		end
		if map_number == 83 or map_number == 103 then
			world_rotation = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		part_variant = 0
		if map_number == 34 or map_number == 54 or map_number == 87 or map_number == 103 or map_number == 76 then
			part_variant = 1
		end
		if train_id == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			event.set_save_counter(0, 1)
		end
		if train_id == 5 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			event.set_save_counter(0, 1)
		end
		if train_id == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			event.set_save_counter(0, 2)
		end
		if train_id == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			event.set_save_counter(0, 2)
		end
		if train_id == 6 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			event.set_save_counter(0, 3)
		end
		if train_id == 7 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			event.set_save_counter(0, 3)
		end
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		player_y = 0.0
		player_x = 46.0
		if map_number == 34 then
			player_y = vm.f32(35.8)
		end
		if map_number == 16 then
			player_y = vm.f32(-7.86)
		end
		if map_number == 54 then
			player_y = 36.0
		end
		if map_number == 83 then
			player_y = vm.f32(29.22)
		end
		if map_number == 87 then
			player_y = -6.0
		end
		if map_number == 103 then
			player_y = vm.f32(-13.87)
		end
		if map_number == 72 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		if map_number == 76 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		if map_number == 155 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		event.set_object_sequence_position(0, player_x, player_y, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if map_number == 34 or map_number == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if map_number == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		resume_step = 1
		wait.for_frame_count(10)
		if vm.imod(train_id, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				resume_step = 2
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				resume_step = 3
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x + 45.0, gangway_y - 19.0, gangway_z, 30)
					resume_step = 4
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x + 20.0, gangway_y - 8.0, gangway_z, 20)
					resume_step = 5
					wait.for_frame_count(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				resume_step = 6
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				resume_step = 7
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x - 45.0, gangway_y - 19.0, gangway_z, 30)
					resume_step = 8
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x - 20.0, gangway_y - 8.0, gangway_z, 20)
					resume_step = 9
					wait.for_frame_count(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		footstep_sound = 0
		if
			map_number == 16
			or map_number == 83
			or map_number == 87
			or map_number == 103
			or map_number == 72
			or map_number == 76
			or map_number == 155
		then
			print("てつのあしおと\n")
			footstep_sound = 6
		end
		if map_number == 34 or map_number == 54 then
			print("いしのあしおと\n")
			footstep_sound = 2
		end
		event.set_object_handle_footstep_sound(0, footstep_sound)
		resume_step = 10
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		resume_step = 11
		wait.for_frame_count(30)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_motion(0, "立ち", 4)
		if vm.imod(train_id, 2) ~= 1 then
			event.set_character_position(0, 50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
		else
			event.set_character_position(0, -50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if resume_step <= 11 then
			if resume_step <= 1 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 2 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 3 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 4 then
				wait.skip_frame_count(10)
			end
			if resume_step <= 5 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 6 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 7 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 8 then
				wait.skip_frame_count(10)
			end
			if resume_step <= 9 then
				footstep_sound = 0
				print("てつのあしおと\n")
				footstep_sound = 6
				print("いしのあしおと\n")
				footstep_sound = 2
				wait.skip_frame_count(30)
			end
			if resume_step <= 10 then
				wait.skip_frame_count(30)
			end
			return 0
		end
		return nil
	end)
end

--- Hides the six model parts of the train02 group.
function train.hide_train02_parts()
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a3")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a4")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a5")
	event.set_object_handle_visible(0, 0)
end

--- Returns 1 when the train door on the given side opens at the saved station, or 0 when story flags 203 set and 204 clear close every door.
function train.is_door_usable(side_id: s32)
	local flag_203: s32 = 0
	local flag_204: s32 = 0
	local station_id: s32 = 0
	flag_203 = event.get_save_flag(203) or flag_203
	flag_204 = event.get_save_flag(204) or flag_204
	if flag_203 ~= 0 and flag_204 == 0 then
		return 0
	end
	station_id = event.get_save_counter(1) or station_id
	print("CheckTrainDoor,station_id=", station_id, ",lr=", side_id, "-----------------------------\n")
	if station_id == 2 then
		if side_id ~= 0 then
			return 1
		else
			return 0
		end
	end
	if station_id == 3 then
		if side_id ~= 0 then
			return 1
		else
			return 0
		end
	end
	if station_id == 4 then
		if side_id ~= 0 then
			return 0
		else
			return 1
		end
	end
	if station_id == 5 then
		if side_id ~= 0 then
			return 0
		else
			return 1
		end
	end
	if station_id == 6 then
		if side_id ~= 0 then
			return 0
		else
			return 1
		end
	end
	if station_id == 7 then
		if side_id ~= 0 then
			return 1
		else
			return 0
		end
	end
	if station_id == 8 then
		if side_id ~= 0 then
			return 0
		else
			return 1
		end
	end
	if station_id == 9 then
		if side_id ~= 0 then
			return 1
		else
			return 0
		end
	end
	if side_id ~= 0 then
		return 0
	else
		return 1
	end
end

--- Levels the six train07 parts by shifting each three-part half 56 units along x and clearing their rotation, then hides the train02 parts.
function train.level_cars()
	local part_x: f32 = 0
	local part_y: f32 = 0
	local part_z: f32 = 0
	print("slope-------------------off\t\n")
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(1)
	train.hide_train02_parts()
end

--- Places the player at the platform position and facing that match the given station and train.
function train.place_player_at_platform(station_id: s32, train_id: s32, side_id: s32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local yaw: f32 = 0
	print("station_id=", station_id, ",train_id=", train_id, ",lr_id=", side_id, "\n")
	x = -220.0
	y = vm.f32(35.8)
	z = vm.f32(-1570.4)
	yaw = vm.f32(-1.57)
	if train_id == 1 then
		z = vm.f32(-1251.8)
	end
	if train_id == 2 then
		z = vm.f32(-737.4)
	end
	if train_id == 3 then
		z = vm.f32(-219.7)
	end
	if station_id == 2 then
		y = 0.0
		x = -120.0
		yaw = vm.f32(-1.57)
		z = 445.0
		if train_id == 1 then
			z = 150.0
		end
		if train_id == 2 then
			z = -365.0
		end
		if train_id == 3 then
			z = -880.0
		end
	end
	if station_id == 3 then
		x = -100.0
		y = 36.0
		yaw = vm.f32(-1.57)
		z = 303.5
		if train_id == 1 then
			z = vm.f32(-9.6)
		end
		if train_id == 2 then
			z = -526.5
		end
		if train_id == 3 then
			z = vm.f32(-1042.8)
		end
	end
	if station_id == 4 then
		y = vm.f32(29.2)
		z = -100.0
		yaw = vm.f32(3.1415927)
		x = vm.f32(-1173.2)
		if train_id == 1 then
			x = vm.f32(-1472.9)
		end
		if train_id == 2 then
			x = vm.f32(-1993.4)
		end
		if train_id == 3 then
			x = -2506.0
		end
	end
	if station_id == 5 then
		y = 0.0
		yaw = vm.f32(-2.355)
		x = 2586.0
		z = 1378.0
		if train_id == 1 then
			x = 2370.0
			z = 1610.0
		end
		if train_id == 2 then
			x = 2037.0
			z = 2000.0
		end
		if train_id == 3 then
			x = 1694.0
			z = 2389.0
		end
	end
	if station_id == 6 then
		x = 690.0
		if train_id == 2 then
			x = vm.f32(347.8)
		end
		if train_id == 2 then
			x = vm.f32(-168.4)
		end
		if train_id == 3 then
			x = -687.5
		end
		y = vm.f32(-268.4)
		z = 3240.0
		yaw = vm.f32(3.1415927)
	end
	if station_id == 7 then
		x = -590.0
		if train_id == 1 then
			x = vm.f32(-245.2)
		end
		if train_id == 2 then
			x = vm.f32(273.3)
		end
		if train_id == 3 then
			x = vm.f32(790.2)
		end
		y = 0.0
		z = 4400.0
		yaw = vm.f32(3.1415927)
	end
	if station_id == 8 then
		x = 590.0
		if train_id == 1 then
			x = 240.0
		end
		if train_id == 2 then
			x = -270.0
		end
		if train_id == 3 then
			x = -790.0
		end
		y = 0.0
		z = 3450.0
		yaw = vm.f32(3.1415927)
	end
	if station_id == 9 then
		x = -590.0
		if train_id == 1 then
			x = vm.f32(-245.2)
		end
		if train_id == 2 then
			x = vm.f32(273.3)
		end
		if train_id == 3 then
			x = vm.f32(790.2)
		end
		y = 0.0
		z = 4400.0
		yaw = vm.f32(3.1415927)
	end
	event.set_character_position(0, x, y, z)
	event.set_character_rotation(0, 0.0, yaw, 0.0)
end

--- Places the player at the platform spot given by the saved station, train and side counters.
function train.place_player_at_saved_platform()
	local station_id: s32 = 0
	local train_id: s32 = 0
	local side_id: s32 = 0
	station_id = event.get_save_counter(1) or station_id
	train_id = event.get_save_counter(0) or train_id
	side_id = event.get_save_counter(15) or side_id
	print("station_id=", station_id, ",train_id=", train_id, ",lr_id=", side_id, "\n")
	train.place_player_at_platform(station_id, train_id, side_id)
end

--- Stands in for board_via_gangway_main when events are skipped, printing the boarding state and counting down its frame waits without waiting.
function train.skip_board_via_gangway_main()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	wait.skip_frame_count(30)
	wait.skip_frame_count(30)
end

--- Prints the station, train and side identifiers; this stands in for place_player_at_platform when events are skipped.
function train.skip_place_player_at_platform(station_id: s32, train_id: s32, side_id: s32)
	print("station_id=", station_id, ",train_id=", train_id, ",lr_id=", side_id, "\n")
end

--- Prints the station, train and side identifiers and passes them to skip_place_player_at_platform; this stands in for place_player_at_saved_platform when events are skipped.
function train.skip_place_player_at_saved_platform()
	local station_id: s32 = 0
	local train_id: s32 = 0
	local side_id: s32 = 0
	print("station_id=", station_id, ",train_id=", train_id, ",lr_id=", side_id, "\n")
	train.skip_place_player_at_platform(station_id, train_id, side_id)
end

--- Hides the first set of train09, train10, train12, train14 and train15 model parts and shows the second set.
function train.switch_train_parts()
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m3")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m4")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m5")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m6")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m7")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m8")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m9")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m10")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m11")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train12-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train12-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train14-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train15-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m3")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m4")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train09-m5")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m12")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m13")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m14")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m15")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m16")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m17")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m18")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m19")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m20")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m21")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m22")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train10-m23")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train12-m2")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train12-m3")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train14-m1")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train15-m1")
	event.set_object_handle_visible(0, 1)
end

--- Tilts the six train07 parts to a 0.56 radian slope by shifting each three-part half 56 units along x, and shows the train02 parts.
function train.tilt_cars()
	local part_x: f32 = 0
	local part_y: f32 = 0
	local part_z: f32 = 0
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x - 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_x = out1 or part_x
		part_y = out2 or part_y
		part_z = out3 or part_z
	end
	event.set_object_handle_position(0, part_x + 56.0, part_y, part_z)
	event.set_object_handle_rotation(0, 0.0, 3.1415927, -0.56)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a1")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a2")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a3")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a4")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "train02-a5")
	event.set_object_handle_visible(0, 1)
end

return train
