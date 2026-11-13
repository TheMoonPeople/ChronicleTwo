--!strict
--- Plays the Moon Flower Palace cutscene in which Osmond's party escapes by train while Toryon throws rocks.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the party, Osmond, Toryon, beam, rock and train assets for the train rock throwing cutscene.
local function load_train_rock_scene_assets()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
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
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
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
	event.attach_object_handle_to_map_part_3(14, "p04_s7101-0", "shadow-m")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_14-m6")
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

--- Releases the characters loaded for the train rock throwing cutscene and ends the event.
local function unload_train_rock_scene_assets()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
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

--- Plays the cutscene in which Toryon throws rocks at the departing train.
local function play_train_rock_scene()
	local sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local path_object_index: s32 = 0
	local train_x: f32 = 0
	local train_velocity_x: f32 = 0
	local train_acceleration_x: f32 = 0
	local train_y: f32 = 0
	local train_velocity_y: f32 = 0
	local train_acceleration_y: f32 = 0
	local train_z: f32 = 0
	local train_velocity_z: f32 = 0
	local train_acceleration_z: f32 = 0
	local frame_counter: s32 = 0
	local step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7202)
		sound_bank = event.load_sound_effect_file_2(7202) or sound_bank
		object.reset_train_car_parts()
		load_train_rock_scene_assets()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.play_sound_effect(sound_bank, 3)
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
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_object_sequence_position(4, 790.0, 20.0, 4500.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(8, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_position(10, 913.78, 1815.71, -1455.71)
		event.set_object_sequence_rotation(10, 0.0, -0.04, 0.0)
		event.set_object_sequence_position(9, 347.12, 200.0, 1407.85)
		event.set_character_active(1, 40)
		event.play_sound_effect(sound_bank, 0)
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
		step = 1
		wait.for_frame_count(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		step = 2
		wait.for_frame_count(30)
		event.set_character_active(1, 42)
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_motion(8, "発射", 6)
		event.set_object_sequence_motion(10, "弾道", 6)
		event.create_effect("Ｅ６１６月花ビームＢ")
		event.set_effect_first_vector(913.78, 1815.71, -1455.71)
		event.set_effect_second_vector(0.0, -0.04, 0.0)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		step = 3
		wait.for_frame_count(10)
		event.move_object_sequence(3, 395.57, 707.08, -157.89, 10)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		step = 4
		wait.for_frame_count(20)
		event.play_sound_effect(sound_bank, 2)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		step = 5
		wait.for_frame_count(30)
		event.set_object_sequence_position(11, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(11, -200.0, 700.0, -1000.0, -1.2, 60)
		step = 6
		wait.for_frame_count(30)
		event.set_object_sequence_position(12, 395.57, 1007.08, -157.89)
		event.jump_object_sequence(12, 200.0, 700.0, -1000.0, -1.2, 60)
		step = 7
		wait.for_frame_count(30)
		event.set_camera_sequence_position(368.47, 270.27002, 3796.05)
		event.set_camera_sequence_look_at(296.74, 129.55, 4410.1)
		event.play_sound_effect(sound_bank, 7)
		do
			local out1, out2, out3 = event.get_object_handle_position(13)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.rotate_object_sequence(5, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(6, 0.0, 0.0, 1.5707964, 30)
		event.rotate_object_sequence(7, 0.0, 0.0, -0.3926991, 30)
		event.rotate_object_sequence(13, 0.0, 0.0, -0.3926991, 30)
		step = 8
		wait.for_frame_count(30)
		event.move_object_sequence(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
		step = 9
		wait.for_frame_count(20)
		path_object_index = 2
		event.clear_object_sequence_path(path_object_index)
		event.set_object_sequence_path_frames(path_object_index, 120)
		event.add_object_sequence_path_point(path_object_index, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(path_object_index, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(path_object_index, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(path_object_index, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(path_object_index)
		step = 10
		wait.for_frame_count(10)
		path_object_index = 0
		event.clear_object_sequence_path(path_object_index)
		event.set_object_sequence_path_frames(path_object_index, 120)
		event.add_object_sequence_path_point(path_object_index, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(path_object_index, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(path_object_index, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(path_object_index, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(path_object_index)
		step = 11
		wait.for_frame_count(10)
		path_object_index = 1
		event.clear_object_sequence_path(path_object_index)
		event.set_object_sequence_path_frames(path_object_index, 120)
		event.add_object_sequence_path_point(path_object_index, 272.66, 20.0, 4119.88)
		event.add_object_sequence_path_point(path_object_index, 249.45, 20.0, 4367.87)
		event.add_object_sequence_path_point(path_object_index, 241.61, 34.02, 4435.0)
		event.add_object_sequence_path_point(path_object_index, 234.87, 48.2, 4492.6)
		event.start_object_sequence_path(path_object_index)
		step = 12
		object.wait_until_done(1)
		event.set_character_active(0, max_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 38)
		step = 13
		wait.for_frame_count(10)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(368.47, 270.27002, 3796.05, 296.74, 129.55, 4410.1)
		event.add_camera_sequence_path_point(368.47, 270.27002, 3796.05, 693.41, 129.55, 4324.2)
		event.start_camera_sequence_path()
		step = 14
		camera.wait_until_done()
		step = 15
		wait.for_frame_count(30)
		event.set_object_handle_visible(14, 0)
		event.set_camera_sequence_position(306.21, 254.45, 6861.67)
		event.set_camera_sequence_look_at(234.87, 316.89, 4492.6)
		event.play_sound_effect(sound_bank, 8)
		step = 16
		wait.for_frame_count(60)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.rotate_object_sequence_eased(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
		event.move_object_sequence(3, 8374.23, 2964.08, 3500.0, 400)
		step = 17
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 9)
		event.move_object_sequence_eased(4, 790.0, 70.0, 4500.0, 60, 0, 1.0)
		event.move_camera_sequence_look_at(790.0, 120.0, 4500.0, 60)
		step = 18
		object.wait_until_done(4)
		event.rotate_object_sequence_eased(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
		train_x = 790.0
		train_velocity_x = 0.0
		train_acceleration_x = vm.f32(0.26666668)
		train_y = 70.0
		train_velocity_y = 0.0
		train_acceleration_y = vm.f32(0.1)
		train_z = 4500.0
		train_velocity_z = 0.0
		train_acceleration_z = 0.0
		frame_counter = 0
		while frame_counter < 240 do
			event.set_object_sequence_position(4, train_x, train_y, train_z)
			event.set_camera_sequence_look_at(train_x, train_y + 50.0, train_z)
			train_x = vm.f32(train_x + train_velocity_x)
			train_velocity_x = vm.f32(train_velocity_x + train_acceleration_x)
			train_y = vm.f32(train_y + train_velocity_y)
			train_velocity_y = vm.f32(train_velocity_y + train_acceleration_y)
			train_z = vm.f32(train_z + train_velocity_z)
			train_velocity_z = vm.f32(train_velocity_z + train_acceleration_z)
			frame_counter = frame_counter + 1
			if frame_counter == 210 then
				event.fade_out_music(30)
				event.fade_out_screen(30)
			end
			step = 19
			vm.wait(19)
		end
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.skip_frame_count(30)
		end
		if step <= 2 then
			wait.skip_frame_count(10)
		end
		if step <= 3 then
			wait.skip_frame_count(20)
		end
		if step <= 4 then
			wait.skip_frame_count(30)
		end
		if step <= 5 then
			wait.skip_frame_count(30)
		end
		if step <= 6 then
			wait.skip_frame_count(30)
		end
		if step <= 7 then
			wait.skip_frame_count(30)
		end
		if step <= 8 then
			wait.skip_frame_count(20)
		end
		if step <= 9 then
			path_object_index = 2
			wait.skip_frame_count(10)
		end
		if step <= 10 then
			path_object_index = 0
			wait.skip_frame_count(10)
		end
		if step <= 11 then
			path_object_index = 1
			cutscene.skip_command(1)
		end
		if step <= 12 then
			wait.skip_frame_count(10)
		end
		if step <= 13 then
			wait.background_load_skipping()
		end
		if step <= 14 then
			wait.skip_frame_count(30)
		end
		if step <= 15 then
			wait.skip_frame_count(60)
		end
		if step <= 16 then
			wait.skip_frame_count(30)
		end
		if step <= 17 then
			cutscene.skip_command(4)
		end
		if step <= 18 then
			train_x = 790.0
			train_velocity_x = 0.0
			train_acceleration_x = vm.f32(0.26666668)
			train_y = 70.0
			train_velocity_y = 0.0
			train_acceleration_y = vm.f32(0.1)
			train_z = 4500.0
			train_velocity_z = 0.0
			train_acceleration_z = 0.0
			frame_counter = 0
			train_x = vm.f32(train_x + train_velocity_x)
			train_velocity_x = vm.f32(train_velocity_x + train_acceleration_x)
			train_y = vm.f32(train_y + train_velocity_y)
			train_velocity_y = vm.f32(train_velocity_y + train_acceleration_y)
			train_z = vm.f32(train_z + train_velocity_z)
			train_velocity_z = vm.f32(train_velocity_z + train_acceleration_z)
			local _ = frame_counter < 240
			frame_counter = frame_counter + 1
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_music(30)
	event.fade_out_screen(0)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_sound_effect(sound_bank, 3)
	event.clear_effect_manager()
	event.skip_next_music_load()
	step = 20
	vm.wait(20)
	step = 21
	unload_train_rock_scene_assets()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Prints a map initialization message.
function script.log_map_init()
	print("map_init-------------------------\n")
end
script[99] = script.log_map_init

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_train_rock_scene

--- Plays the train rock throwing cutscene and jumps to map s11.
function script.cutscene_train_rock_throw_then_go_to_s11()
	play_train_rock_scene()
	event.jump_to_map_3(-1, "s11", 502)
	vm.wait(2)
end
script[590] = script.cutscene_train_rock_throw_then_go_to_s11

return script
