--!strict
--- Event script for the Moon Flower Palace train stop, covering arrival by train, the Toryon train attack cutscene and boarding the train.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Prints a marker when the map is initialised.
local function init_map()
	print("map_init-------------------------\n")
end

--- Plays the cutscene where Osmond greets the party beside the arriving train, then restores the party and the music.
local function cutscene_osmond_arrival_at_station()
	local sound_bank: s32 = 0
	local character_slot: s32 = 0
	local active_chr_no: s32 = 0
	local music_number: s32 = 0
	vm.section(function()
		event.set_save_flag(648, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7815)
		sound_bank = event.load_sound_effect_file_2(7815) or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.stop_sound_effect(sound_bank, 0)
		character_slot = event.find_scene_character_slot(301) or character_slot
		event.set_character_active(0, character_slot)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e648/")
		event.load_message_file(0, 5, "e648.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e648_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_12-m")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_14-m")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_16-m")
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_17-m1")
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.change_directory("")
		if active_chr_no == 1 then
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
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, 19.72, -9.6, -146.14)
		event.set_object_handle_rotation(1, 0.0, -0.81, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(2, 0.11, -2.82, -96.44)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_handle_position(3, 10497.4, 4263.4, 16022.1)
		event.set_object_handle_rotation(3, 0.17453292, -2.268928, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(8906.16, 4062.09, 15480.96)
		event.set_camera_sequence_look_at(9213.43, 4103.76, 15508.46)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_character_active(35)
		event.fade_in_screen(30)
		event.move_object_sequence(3, -738.8, 0.0, 4490.7, 300)
		event.rotate_object_sequence(3, 0.0, -2.286, 0.3, 300)
		event.play_sound_effect(sound_bank, 4)
		event.move_camera_sequence(8070.99, 3228.35, 15847.63, 7999.18, 3244.28, 15637.48, 90)
		wait.for_frame_count(120)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_camera_sequence_position(-1639.57, 7.86, 5016.61)
		event.set_camera_sequence_look_at(-1218.91, 101.0, 4719.94)
		event.set_object_sequence_position(3, 1200.0, 237.6, 4500)
		event.set_object_sequence_rotation(3, 0.0, -1.57, 0.0)
		event.move_object_sequence(3, -400, 0.0, 4500, 60)
		event.move_object_sequence_eased(3, -990, 0.0, 4500, 90, 2, 0.8)
		wait.for_frame_count(210)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_object_sequence_position(3, -790, 0.0, 4500)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_position(0, -266.3, 0.0, 4342.88)
		event.set_object_sequence_rotation(0, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(1, -263.45, 0.0, 4372.15)
		event.set_object_sequence_rotation(1, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(2, -241.85, 11.82, 4430.23)
		event.set_object_sequence_rotation(2, 0.0, 3.03, 0.0)
		event.set_camera_sequence_position(-336.6, 39.36, 4198.84)
		event.set_camera_sequence_look_at(-239.26, 60.64, 4423.35)
		event.set_object_sequence_rotation(4, 0.0, 0.0, -1.5707964)
		event.set_object_sequence_rotation(5, 0.0, 0.0, -1.5707964)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.3926991)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.3926991)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -249.34, 0.0, 4318.43, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -277.96, 0.0, 4332.42, 60)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -253.46, 0.0, 4397.34, 30)
		event.move_object_sequence(2, -252.88, 0.0, 4367.79, 30)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち")
		object.wait_until_done(2)
		event.set_camera_sequence_position(-130.69, 136.99, 4468.57)
		event.set_camera_sequence_look_at(-261.31, 3.53, 4336.64)
		event.set_object_sequence_position(0, -235.2, 0.0, 4329.41)
		event.set_object_sequence_rotation(0, 0.0, -0.09, 0.0)
		event.set_object_sequence_position(1, -276.84, 0.0, 4326.87)
		event.set_object_sequence_rotation(1, 0.0, 0.39, 0.0)
		event.set_object_sequence_position(2, -254.29, 0.0, 4359.67)
		event.set_object_sequence_rotation(2, 0.0, 3.03, 0.0)
		event.set_object_sequence_motion(0, "オズ見立ち", 4)
		event.set_object_sequence_motion(1, "オズ見", 4)
		event.set_object_sequence_motion(2, "立ち（上見）", 6)
		event.queue_object_sequence_next_motion(2, "会話（上見）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（上見）", 4)
		message.show_voiced(6480100)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "オズ見うなづき", 6)
		event.queue_object_sequence_next_motion(0, "オズ見立ち", 6)
		event.set_object_sequence_motion(1, "オズ見うなずき", 6)
		event.queue_object_sequence_next_motion(1, "オズ見", 6)
		message.show_voiced(6480110)
		object.wait_until_done(1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 4)
	event.stop_music(0)
	wait.for_frame_count(4)
	music_number = event.get_default_music_number(72) or music_number
	event.load_music(music_number)
	event.play_music(0)
	event.set_character_active(1, character_slot)
	event.set_object_handle_position(3, -790, 0.0, 4500)
	event.set_object_handle_rotation(3, 0.0, -1.57, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_footstep_sound(2, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

--- Attaches the train parts for the boarded train, shows the player running aboard, and fades out.
local function play_train_departure()
	local now_map_no: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_unused: f32 = 0
	local train_id: s32 = 0
	local world_coord_rot: f32 = 0
	local is_special_track: s32 = 0
	local sound_id: s32 = 0
	local part_x: f32 = 0
	local part_y: f32 = 0
	local part_z: f32 = 0
	local player_y: f32 = 0
	local player_x: f32 = 0
	local footstep_sound: s32 = 0
	local at: number = 0
	return vm.guard(function()
		now_map_no = event.get_current_map() or now_map_no
		event.initialize_event()
		event.get_sound_id(1)
		train_id = event.get_triggered_event_data_2(3) or train_id
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_unused) -- retail: the handler rejects 5 arguments
		print("train_id=", train_id, "----------------\n")
		print("fpos[0]=", vm.float(world_coord_pos), "---------------\n")
		print("fpos[1]=", vm.float(world_coord_pos_2), "---------------\n")
		print("fpos[2]=", vm.float(world_coord_pos_3), "---------------\n")
		if world_coord_pos_3 < 4500.0 then
			world_coord_rot = vm.f32(1.5707964)
		else
			world_coord_rot = vm.f32(-1.5707964)
		end
		if now_map_no == 76 then
			if world_coord_pos_3 < 3600.0 then
				world_coord_rot = vm.f32(1.5707964)
			else
				world_coord_rot = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 72 then
			if world_coord_pos_3 < 4500.0 then
				world_coord_rot = vm.f32(1.5707964)
			else
				world_coord_rot = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
			world_coord_rot = vm.f32(3.1415927)
		end
		if now_map_no == 87 then
			world_coord_rot = vm.f32(2.3561945)
		end
		if now_map_no == 83 or now_map_no == 103 then
			world_coord_rot = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		is_special_track = 0
		if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
			is_special_track = 1
		end
		if train_id == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if is_special_track == 0 then
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
			if is_special_track == 0 then
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
			if is_special_track == 0 then
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
			if is_special_track == 0 then
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
			if is_special_track == 0 then
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
			if is_special_track == 0 then
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
			part_x = out1 or part_x
			part_y = out2 or part_y
			part_z = out3 or part_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		player_y = 0.0
		player_x = 46.0
		if now_map_no == 34 then
			player_y = vm.f32(35.8)
		end
		if now_map_no == 16 then
			player_y = vm.f32(-7.86)
		end
		if now_map_no == 54 then
			player_y = 36.0
		end
		if now_map_no == 83 then
			player_y = vm.f32(29.22)
		end
		if now_map_no == 87 then
			player_y = -6.0
		end
		if now_map_no == 103 then
			player_y = vm.f32(-13.87)
		end
		if now_map_no == 72 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		event.set_object_sequence_position(0, player_x, player_y, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if now_map_no == 34 or now_map_no == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if now_map_no == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		at = 1
		wait.for_frame_count(10)
		if vm.imod(train_id, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 2
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				at = 3
				wait.for_frame_count(30)
				if now_map_no == 103 then
					event.move_object_sequence(5, part_x + 45.0, part_y - 19.0, part_z, 30)
					at = 4
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, part_x + 20.0, part_y - 8.0, part_z, 20)
					at = 5
					wait.for_frame_count(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 6
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				at = 7
				wait.for_frame_count(30)
				if now_map_no == 103 then
					event.move_object_sequence(5, part_x - 45.0, part_y - 19.0, part_z, 30)
					at = 8
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, part_x - 20.0, part_y - 8.0, part_z, 20)
					at = 9
					wait.for_frame_count(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		footstep_sound = 0
		if
			now_map_no == 16
			or now_map_no == 83
			or now_map_no == 87
			or now_map_no == 103
			or now_map_no == 72
			or now_map_no == 76
			or now_map_no == 155
		then
			print("てつのあしおと\n")
			footstep_sound = 6
		end
		if now_map_no == 34 or now_map_no == 54 then
			print("いしのあしおと\n")
			footstep_sound = 2
		end
		event.set_object_handle_footstep_sound(0, footstep_sound)
		at = 10
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		at = 11
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
		if at <= 11 then
			if at <= 1 then
				wait.skip_frame_count(20)
			end
			if at <= 2 then
				wait.skip_frame_count(30)
			end
			if at <= 3 then
				wait.skip_frame_count(20)
			end
			if at <= 4 then
				wait.skip_frame_count(10)
			end
			if at <= 5 then
				wait.skip_frame_count(20)
			end
			if at <= 6 then
				wait.skip_frame_count(30)
			end
			if at <= 7 then
				wait.skip_frame_count(20)
			end
			if at <= 8 then
				wait.skip_frame_count(10)
			end
			if at <= 9 then
				footstep_sound = 0
				print("てつのあしおと\n")
				footstep_sound = 6
				print("いしのあしおと\n")
				footstep_sound = 2
				wait.skip_frame_count(30)
			end
			if at <= 10 then
				wait.skip_frame_count(30)
			end
			return 0
		end
		return nil
	end)
end

--- Replays the waits of the train departure so a skipped departure ends in the same state.
local function skip_train_departure()
	local world_coord_x: f32 = 0
	local world_coord_y: f32 = 0
	local world_coord_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_coord_x), "---------------\n")
	print("fpos[1]=", vm.float(world_coord_y), "---------------\n")
	print("fpos[2]=", vm.float(world_coord_z), "---------------\n")
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

--- Loads the characters, effects, train parts and messages that the train attack cutscene needs.
local function load_train_attack_assets()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_character == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(8, 40)
	event.clear_object_sequence(8, 40)
	event.set_object_sequence_object(8, 8)
	event.load_character(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(9, 41)
	event.clear_object_sequence(9, 41)
	event.set_object_sequence_object(9, 9)
	event.load_character(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(10, 42)
	event.clear_object_sequence(10, 42)
	event.set_object_sequence_object(10, 10)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ６１６月花ビームＢ")
	event.create_effect_work_buffer(5)
	event.load_character(5, "event/e600/e616/e616_iwa.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_character(11, 43)
	event.clear_object_sequence(11, 43)
	event.set_object_sequence_object(11, 11)
	event.copy_character(5, 43, 44)
	event.set_character_active(0, 44)
	event.attach_object_handle_to_character(12, 44)
	event.clear_object_sequence(12, 44)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_2(14, "p01_shadow-0")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_14-m1")
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_16-m1")
	event.set_object_sequence_object(7, 7)
	event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "s3601_17-m")
	event.set_object_sequence_object(13, 13)
	event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
	event.load_message_file(0, 5, "event/e600/e616/e616.txt")
end

--- Unloads the characters of the train attack cutscene and ends the event.
local function unload_train_attack_assets()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.finish_event()
	vm.wait(1)
end

--- Plays the cutscene where Toryon throws rocks and fires beams at the train while the party runs along it, then the train is pushed away.
local function cutscene_toryon_attacks_train()
	local sound_bank: s32 = 0
	local car_x: f32 = 0
	local car_y: f32 = 0
	local car_z: f32 = 0
	local sequence_index: s32 = 0
	local train_x: f32 = 0
	local train_velocity_x: f32 = 0
	local train_acceleration_x: f32 = 0
	local train_y: f32 = 0
	local train_velocity_y: f32 = 0
	local train_acceleration_y: f32 = 0
	local train_z: f32 = 0
	local train_velocity_z: f32 = 0
	local train_acceleration_z: f32 = 0
	local frame: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(7202) or sound_bank
		load_train_attack_assets()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_object_sequence_position(4, 790.0, 0.0, 4500.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(8, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_position(10, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_rotation(10, 0.0, -0.04, 0.0)
		event.set_object_sequence_position(9, 347.12, 200.0, 1407.85)
		event.set_character_active(1, 40)
		event.set_object_sequence_motion(8, "入り", 6)
		event.queue_object_sequence_next_motion(8, "溜めループ", 4)
		event.set_camera_sequence_position(740.39, 361.22, 3768.25)
		event.set_camera_sequence_look_at(58.72, 398.27, 1944.66)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "走り")
		event.set_object_sequence_position(3, 607.53, 453.56, -239.32)
		event.set_object_sequence_rotation(3, 0.0, -2.56, 0.0)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 120)
		event.add_object_sequence_path_point(2, 0.0, 173.54, 2717.0)
		event.add_object_sequence_path_point(2, 0.0, 59.11, 3144.44)
		event.start_object_sequence_path(2, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 140)
		event.add_object_sequence_path_point(1, 25.0, 189.22, 2617.0)
		event.add_object_sequence_path_point(1, 25.0, 49.45, 3179.82)
		event.start_object_sequence_path(1, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 130)
		event.add_object_sequence_path_point(0, -25.0, 184.27, 2667.0)
		event.add_object_sequence_path_point(0, -25.75, 51.4, 3172.67)
		event.start_object_sequence_path(0, 1)
		event.set_object_sequence_motion(3, "岩を投げる", 4)
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.fade_in_screen(30)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 1
		wait.for_frame_count(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 2
		wait.for_frame_count(30)
		event.set_character_active(1, 42)
		event.set_object_sequence_motion(8, "発射", 6)
		event.set_object_sequence_motion(10, "弾道", 6)
		event.create_effect("Ｅ６１６月花ビームＢ")
		event.set_effect_first_vector(913.78, 1815.71, -1455.71)
		event.set_effect_second_vector(0.0, -0.04, 0.0)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 3
		wait.for_frame_count(10)
		event.move_object_sequence(3, 395.57, 707.08, -157.89, 10)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 4
		wait.for_frame_count(20)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		resume_step = 5
		wait.for_frame_count(30)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 6
		wait.for_frame_count(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		resume_step = 7
		wait.for_frame_count(30)
		event.set_camera_sequence_position(368.47, 250.27, 3796.05)
		event.set_camera_sequence_look_at(296.74, 109.55, 4410.1)
		event.play_sound_effect(sound_bank, 7)
		do
			local out1, out2, out3 = event.get_object_handle_position(13)
			car_x = out1 or car_x
			car_y = out2 or car_y
			car_z = out3 or car_z
		end
		event.rotate_object_sequence(5, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(6, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(7, 0.0, 0.0, -0.3926991, 30)
		event.rotate_object_sequence(13, 0.0, 0.0, -0.3926991, 30)
		resume_step = 8
		wait.for_frame_count(30)
		event.move_object_sequence(13, car_x + 45.0, car_y - 19.0, car_z, 30)
		resume_step = 9
		wait.for_frame_count(20)
		sequence_index = 2
		event.clear_object_sequence_path(sequence_index)
		event.set_object_sequence_path_frames(sequence_index, 120)
		event.add_object_sequence_path_point(sequence_index, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(sequence_index, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(sequence_index, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(sequence_index, 234.87, 28.2, 4492.6)
		event.start_object_sequence_path(sequence_index)
		resume_step = 10
		wait.for_frame_count(10)
		sequence_index = 0
		event.clear_object_sequence_path(sequence_index)
		event.set_object_sequence_path_frames(sequence_index, 120)
		event.add_object_sequence_path_point(sequence_index, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(sequence_index, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(sequence_index, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(sequence_index, 234.87, 28.2, 4492.6)
		event.start_object_sequence_path(sequence_index)
		resume_step = 11
		wait.for_frame_count(10)
		sequence_index = 1
		event.clear_object_sequence_path(sequence_index)
		event.set_object_sequence_path_frames(sequence_index, 120)
		event.add_object_sequence_path_point(sequence_index, 272.66, 0.0, 4119.88)
		event.add_object_sequence_path_point(sequence_index, 249.45, 0.0, 4367.87)
		event.add_object_sequence_path_point(sequence_index, 241.61, 14.02, 4435.0)
		event.add_object_sequence_path_point(sequence_index, 234.87, 28.2, 4492.6)
		event.start_object_sequence_path(sequence_index)
		resume_step = 12
		object.wait_until_done(1)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 38)
		resume_step = 13
		wait.for_frame_count(10)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(368.47, 250.27, 3796.05, 296.74, 109.55, 4410.1)
		event.add_camera_sequence_path_point(368.47, 250.27, 3796.05, 693.41, 109.55, 4324.2)
		event.start_camera_sequence_path()
		resume_step = 14
		camera.wait_until_done()
		resume_step = 15
		wait.for_frame_count(30)
		event.set_object_handle_visible(14, 0)
		event.set_camera_sequence_position(306.21, 234.45, 6861.67)
		event.set_camera_sequence_look_at(234.87, 296.89, 4492.6)
		event.play_sound_effect(sound_bank, 8)
		resume_step = 16
		wait.for_frame_count(60)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.rotate_object_sequence_eased(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
		event.move_object_sequence(3, 8374.23, 2944.08, 3500.0, 360)
		resume_step = 17
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 9)
		event.move_object_sequence_eased(4, 790.0, 50.0, 4500.0, 60, 0, 1.0)
		event.move_camera_sequence_look_at(790.0, 100.0, 4500.0, 60)
		resume_step = 18
		object.wait_until_done(4)
		event.rotate_object_sequence_eased(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
		train_x = 790.0
		train_velocity_x = 0.0
		train_acceleration_x = vm.f32(0.26666668)
		train_y = 50.0
		train_velocity_y = 0.0
		train_acceleration_y = vm.f32(0.1)
		train_z = 4500.0
		train_velocity_z = 0.0
		train_acceleration_z = 0.0
		frame = 0
		while frame < 240 do
			event.set_object_sequence_position(4, train_x, train_y, train_z)
			event.set_camera_sequence_look_at(train_x, train_y + 50.0, train_z)
			train_x = vm.f32(train_x + train_velocity_x)
			train_velocity_x = vm.f32(train_velocity_x + train_acceleration_x)
			train_y = vm.f32(train_y + train_velocity_y)
			train_velocity_y = vm.f32(train_velocity_y + train_acceleration_y)
			train_z = vm.f32(train_z + train_velocity_z)
			train_velocity_z = vm.f32(train_velocity_z + train_acceleration_z)
			frame = frame + 1
			resume_step = 19
			vm.wait(19)
		end
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 2 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 3 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 4 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 5 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 7 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 8 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 9 then
			sequence_index = 2
			wait.skip_frame_count(10)
		end
		if resume_step <= 10 then
			sequence_index = 0
			wait.skip_frame_count(10)
		end
		if resume_step <= 11 then
			sequence_index = 1
			cutscene.skip_command(1)
		end
		if resume_step <= 12 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 13 then
			wait.background_load_skipping()
		end
		if resume_step <= 14 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 15 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 16 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 17 then
			cutscene.skip_command(4)
		end
		if resume_step <= 18 then
			train_x = 790.0
			train_velocity_x = 0.0
			train_acceleration_x = vm.f32(0.26666668)
			train_y = 50.0
			train_velocity_y = 0.0
			train_acceleration_y = vm.f32(0.1)
			train_z = 4500.0
			train_velocity_z = 0.0
			train_acceleration_z = 0.0
			frame = 0
			train_x = vm.f32(train_x + train_velocity_x)
			train_velocity_x = vm.f32(train_velocity_x + train_acceleration_x)
			train_y = vm.f32(train_y + train_velocity_y)
			train_velocity_y = vm.f32(train_velocity_y + train_acceleration_y)
			train_z = vm.f32(train_z + train_velocity_z)
			train_velocity_z = vm.f32(train_velocity_z + train_acceleration_z)
			local _ = frame < 240
			frame = frame + 1
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_music(30)
	event.fade_out_screen(30)
	resume_step = 20
	wait.for_frame_count(35)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_port_sound_effects(4)
	event.clear_effect_manager()
	resume_step = 21
	vm.wait(21)
	resume_step = 22
	unload_train_attack_assets()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

--- Places the player at the station on entry, arriving by train, alighting from a train ride or restoring a loaded save.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_id: s32 = 0
	local previous_map_type: s32 = 0
	local save_counter: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		init_map()
		print("start_event--------------------------------------------\n")
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			character.load_station_npc()
			character.place_standing_and_reset_cloth(70.0, vm.f32(0.6), 3440.0, vm.f32(3.14))
			event.reset_follow_camera(1, 3.14, 10.0)
			event.fade_in_screen(30)
		else
			print("000--------------------------------------------\n")
			previous_map_id = event.get_previous_map() or previous_map_id
			previous_map_type = event.get_map_type(previous_map_id) or previous_map_type
			if previous_map_type ~= -1 then
				print("111--------------------------------------------\n")
				save_counter = event.get_save_counter(1) or save_counter
				if (previous_map_id == 18 or previous_map_id == 23 or previous_map_id == 120 or previous_map_id == 108) and save_counter == 7 then
					print("222--------------------------------------------\n")
					character.load_station_npc()
					resume_step = 1
					train.alight_primary()
					train.place_player_at_saved_platform()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					print("333--------------------------------------------\n")
					resume_step = 2
					train.arrive_at_station_primary()
					character.load_station_npc()
				end
				print("444--------------------------------------------\n")
			end
			print("555--------------------------------------------\n")
			event.set_character_motion(0, "立ち")
		end
		print("999--------------------------------------------\n")
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				train.skip_place_player_at_saved_platform()
				print("333--------------------------------------------\n")
				wait.skip_long_pause_primary()
			end
			cutscene.noop()
			print("444--------------------------------------------\n")
			print("555--------------------------------------------\n")
			print("999--------------------------------------------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cutscene_osmond_arrival_at_station

--- Asks whether to leave the town and jumps to the next story map or to the world map.
function script.exit_town()
	local flag: s32 = 0
	if menu.confirm_leave_primary() ~= 0 then
		flag = event.get_save_flag(700) or flag
		if flag == 0 then
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "s68", 550)
			vm.wait(2)
		else
			event.jump_to_map_2(-1, "g05")
			vm.wait(3)
		end
	end
end
script[200] = script.exit_town

--- Asks whether to board and rides the train to the destination map.
function script.board_train()
	local answer: s32 = 0
	local trigger_data: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		answer = menu.ask_enter_or_depart()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 7)
		trigger_data = event.get_triggered_event_data_2(3) or trigger_data
		if trigger_data <= 1 then
			resume_step = 2
			train.board_short_train_primary()
			event.stop_music(0)
			resume_step = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			resume_step = 4
			vm.wait(4)
		else
			resume_step = 5
			play_train_departure()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 4 then
				skip_train_departure()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Plays the cutscene of Osmond's train arriving and places the player at the station.
function script.cutscene_osmond_arrival()
	cutscene_osmond_arrival_at_station()
	character.load_station_npc()
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end
script[500] = script.cutscene_osmond_arrival

--- Plays the train attack cutscene and jumps to the neighbouring map.
function script.cutscene_train_attack_then_leave()
	cutscene_toryon_attacks_train()
	event.jump_to_map_3(-1, "s11", 502)
	vm.wait(2)
end
script[590] = script.cutscene_train_attack_then_leave

--- Has the character who waits outside speak when the player talks to them.
function script.talk_to_waiting_character()
	local character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	if character_slot == 8 then
		party.talk_to_waiting_npc()
	end
end
script[1000] = script.talk_to_waiting_character

return script
