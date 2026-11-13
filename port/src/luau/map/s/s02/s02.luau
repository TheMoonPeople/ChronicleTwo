--!strict
--- Event script for the Sindain station map s02, with arrival handling, train boarding and the Carpenterion forest cutscene.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local sindain_station = require("@lib/event/sindain_station")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the partner characters and the Conda character for the Geostone cutscene according to the active character.
local function load_cutscene_characters()
	local active_character: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 38)
	end
	if active_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 4)
	event.load_message_file(0, 5, "event/e200/e254/e254.txt")
end

--- Assigns the cutscene slots as if Monica were the active character.
local function set_monica_as_player_slots()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Deletes the cutscene characters and restores the party handles.
local function unload_cutscene_characters()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(38)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
end

--- Plays the skippable cutscene in which the party returns with Geostones and is told to rebuild the forest.
local function play_carpenterion_forest_cutscene()
	local stage: number = 0
	vm.section(function()
		event.set_save_flag(254, 1)
		event.initialize_event()
		event.fade_out_screen(30)
		stage = 1
		wait.for_frame_count(30)
		event.stop_music(0)
		stage = 2
		wait.for_frame_count(4)
		event.load_music(49)
		load_cutscene_characters()
		message.set_window_mode(0, 1)
		event.enable_drama_skip()
		event.play_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-585.93, 175.94, -940.12)
		event.set_camera_sequence_look_at(-702.67, 128.67, -892.92)
		event.move_camera_sequence(-565.48, 108.18, -866.56, -690.38, 73.25, -848.03, 165)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_scene_status_flags(1, max_slot, 8, 1)
		event.set_scene_status_flags(1, monica_slot, 8, 1)
		event.set_object_sequence_position(0, -1285.55, 14.1, -942.2)
		event.set_object_sequence_motion(0, "走り", 4)
		event.turn_object_sequence_toward(0, -749.29, 0.0, -826.86, 1)
		event.move_object_sequence(0, -749.29, 0.0, -826.86, 165, 1)
		event.set_object_handle_footstep_sound(0, 1)
		event.fade_in_screen(30)
		stage = 3
		wait.for_frame_count(30)
		event.set_object_sequence_position(1, -1285.55, 14.1, -942.2)
		event.set_object_sequence_motion(1, "走り", 4)
		event.turn_object_sequence_toward(1, -767.89, 0.0, -768.84, 1)
		event.move_object_sequence(1, -767.89, 0.0, -768.84, 135, 1)
		event.set_object_handle_footstep_sound(1, 1)
		stage = 4
		wait.for_frame_count(135)
		event.set_object_handle_footstep_sound(0, -1)
		event.set_object_handle_footstep_sound(1, -1)
		event.set_scene_status_flags(1, max_slot, 8, 0)
		event.set_scene_status_flags(1, monica_slot, 8, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-350.28, 3.09, -880.0)
		event.set_camera_sequence_look_at(-237.75, 35.02, -880.0)
		event.set_object_sequence_position(3, -246.0, 0.0, -880.0)
		event.set_object_sequence_rotation(3, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(3, "おーい", 4)
		event.open_message_window_2(0, "オ～イ")
		stage = 5
		message.show(0, -1, 2, 256, 416)
		event.set_camera_sequence_position(-269.42, 43.82, -641.43)
		event.set_camera_sequence_look_at(-355.67, 8.13, -699.39)
		event.set_object_sequence_position(0, -424.81, 0.0, -640.72)
		event.turn_object_sequence_toward(0, -354.91, 0.0, -694.75, 1)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_sequence_position(1, -399.05, 0.0, -634.81)
		event.turn_object_sequence_toward(1, -359.19, 0.0, -671.7, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_position(3, -321.61, 0.0, -694.6)
		event.set_object_sequence_rotation(3, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.move_object_sequence(0, -354.91, 0.0, -694.75, 45)
		event.delay_object_sequence_rotation_track(0, 45)
		event.rotate_object_sequence(0, 0.0, 1.16, 0.0, 5)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		stage = 6
		wait.for_frame_count(15)
		event.move_object_sequence(1, -359.19, 0.0, -671.7, 60)
		event.delay_object_sequence_rotation_track(1, 60)
		event.rotate_object_sequence(1, 0.0, 1.87, 0.0, 5)
		event.delay_object_sequence_motion_track(1, 65)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(
			0,
			"オオ？ジオストーンを\n見つけたようじゃな。<page>では、カーペントリオンを使って、\n森をつくり変えてみるとするかの。"
		)
		stage = 7
		message.show(0, -1, 7, 341, 208)
		event.open_message_window_2(0, "ついて来なされ。")
		stage = 8
		message.show(0, -1, 8, 341, 208)
		event.set_object_handle_footstep_sound(4, 1)
		event.set_object_sequence_motion(3, "歩き２")
		event.turn_object_sequence_toward(3, -306.48, 0.0, -624.02, 45)
		stage = 9
		wait.for_frame_count(45)
		event.move_object_sequence(3, -306.48, 0.0, -624.02, 90)
		stage = 10
		wait.for_frame_count(45)
		event.set_object_sequence_motion(0, "走り")
		event.turn_object_sequence_toward(0, -305.78, 0.0, -632.54, 8)
		stage = 11
		wait.for_frame_count(8)
		event.move_object_sequence(0, -305.78, 0.0, -632.54, 45)
		stage = 12
		wait.for_frame_count(22)
		event.set_object_sequence_motion(1, "歩き")
		event.turn_object_sequence_toward(1, -351.88, 0.0, -630.2, 30)
		stage = 13
		wait.for_frame_count(30)
		event.move_object_sequence(1, -351.88, 0.0, -630.2, 45)
		stage = 14
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		stage = 15
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if stage <= 1 then
			wait.skip_frame_count(4)
		end
		if stage <= 2 then
			set_monica_as_player_slots()
			message.set_window_mode_skipping(0, 1)
			wait.skip_frame_count(30)
		end
		if stage <= 3 then
			wait.skip_frame_count(135)
		end
		if stage <= 4 then
			message.show_and_wait_skipping(0, -1, 2, 256, 416)
		end
		if stage <= 5 then
			wait.skip_frame_count(15)
		end
		if stage <= 6 then
			message.show_and_wait_skipping(0, -1, 7, 341, 208)
		end
		if stage <= 7 then
			message.show_and_wait_skipping(0, -1, 8, 341, 208)
		end
		if stage <= 8 then
			wait.skip_frame_count(45)
		end
		if stage <= 9 then
			wait.skip_frame_count(45)
		end
		if stage <= 10 then
			wait.skip_frame_count(8)
		end
		if stage <= 11 then
			wait.skip_frame_count(22)
		end
		if stage <= 12 then
			wait.skip_frame_count(30)
		end
		if stage <= 13 then
			wait.skip_frame_count(30)
		end
		if stage <= 14 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, max_slot, 8, 0)
	event.set_scene_status_flags(1, monica_slot, 8, 0)
	unload_cutscene_characters()
	event.finish_event()
	event.skip_next_music_load()
end

--- Fades in and walks the player in from the west before returning control and the follow camera.
local function walk_player_back_from_menu()
	event.initialize_event()
	event.set_camera_sequence_position(-625.66, 104.24, -868.06)
	event.set_camera_sequence_look_at(-903.96, 23.48, -831.72)
	event.set_character_active(1, 0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1023.6, 0.0, -838.96)
	event.set_object_sequence_rotation(0, 0.0, 1.58, 0.0)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, -778.4, 0.0, -836.7, 60)
	event.move_camera_sequence_eased(-625.66, 104.24, -868.06, -778.4, 20.0, -836.7, 48, 2, 0.4)
	wait.for_frame_count(60)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.reset_follow_camera(0)
end

--- Starts the first-visit event script when its save flag has not been set.
local function start_first_visit_event()
	local flag: s32 = 0
	flag = event.get_save_flag(207) or flag
	if flag == 0 then
		vm.wait(1)
		event.load_event_script("s02/s02b.stb", 501)
		return
	end
end

--- Runs the player into the map from the west while the camera fades in.
local function run_player_in_with_fade()
	event.initialize_event()
	event.fade_out_screen(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-971.07, 66.21, -121.97)
	event.set_camera_sequence_look_at(-826.79, 21.3, 58.4)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -949.3, 0.0, 34.7)
	event.set_object_sequence_rotation(0, 0.0, 1.36, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.move_object_sequence(0, -806.69, 0.0, 85.01, 60)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait.for_frame_count(60)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.reset_follow_camera(0)
end

--- Plays the skippable cutscene of the train arriving at the station and the player stepping off.
local function play_train_arrival_cutscene()
	local flag_30: s32 = 0
	local time_of_day: f32 = 0
	local sound_bank: s32 = 0
	local train_sound: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_save_flag(30, 0)
		at = 2
		train.level_cars()
		sindain_station.hide_villagers()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_active(0, 0)
		time_of_day = event.get_scene_time_of_day() or time_of_day
		if time_of_day > 0.0 and time_of_day < 5.5 then
			event.set_object_handle_shadow_enabled(0, 0)
		end
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 1.3, 8.0, 500.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_2(9, "p01_shadow-0")
		event.set_object_handle_visible(9, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m6")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m7")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m18")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m19")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m6")
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train10-m7")
		event.set_object_sequence_object(7, 7)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-185.19, 68.62, 1049.53)
		event.set_camera_sequence_look_at(140.3, 63.52, 109.43)
		event.fade_in_screen(30)
		event.enable_drama_skip()
		event.move_object_sequence_eased(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
		at = 3
		object.wait_until_done(1)
		at = 4
		wait.for_frame_count(10)
		event.start_crossfade(30)
		event.set_object_handle_position(1, 1.3, 8.0, 700.0)
		train.tilt_cars()
		event.set_save_flag(30, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-254.85, 60.24, -455.84)
		event.set_camera_sequence_look_at(-89.19, 67.53, -382.63)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -40.0, 45.6, -366.0)
		event.set_object_sequence_rotation(0, 0.0, -1.56, 0.0)
		at = 5
		wait.for_frame_count(15)
		train_sound = event.get_sound_id(2) or train_sound
		event.play_sound_effect(train_sound, 106)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.5, 0.0, 30)
		at = 6
		wait.for_frame_count(15)
		event.set_object_sequence_motion(0, "走り", 0, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -68.89, 43.64, -366.0, 10)
		event.move_object_sequence(0, -131.89, 0.0, -366.0, 30)
		at = 7
		wait.for_frame_count(40)
		event.fade_out_screen(10)
		at = 8
		wait.for_frame_count(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			sindain_station.log_slope_off()
		end
		if at <= 2 then
			cutscene.noop()
			cutscene.skip_command(1)
		end
		if at <= 3 then
			wait.skip_frame_count(10)
		end
		if at <= 4 then
			sindain_station.skip_crossfade_step()
			wait.skip_frame_count(15)
		end
		if at <= 5 then
			wait.skip_frame_count(15)
		end
		if at <= 6 then
			wait.skip_frame_count(40)
		end
		if at <= 7 then
			wait.skip_frame_count(10)
		end
		return true
	end)
	at = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_camera_sequence()
	event.stop_sound_effect(sound_bank, 0)
	event.clear_effect_manager()
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(9, 1)
	event.set_character_active(1, 0)
	character.place_standing_and_reset_cloth(-130.0, 0.0, -366.0, vm.f32(-1.57))
	event.set_camera_look_at(-130.0, 30.0, -366.0)
	event.set_camera_position(-270.0, 40.0, -366.0)
	flag_30 = event.get_save_flag(30) or flag_30
	if flag_30 == 0 then
		train.tilt_cars()
	end
	sindain_station.show_villagers()
	event.fade_in_screen(15)
end

--- Plays the short train arrival cutscene and places the player on the platform.
local function play_train_arrival_quick()
	local sound_bank: s32 = 0
	local time_of_day: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local train_sound: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	sindain_station.hide_villagers()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	time_of_day = event.get_scene_time_of_day() or time_of_day
	if time_of_day > 0.0 and time_of_day < 5.5 then
		event.set_object_handle_shadow_enabled(0, 0)
	end
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 1.3, 8.0, 500.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_2(6, "p01_shadow-0")
	event.set_object_handle_visible(6, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-185.19, 68.62, 1049.53)
	event.set_camera_sequence_look_at(140.3, 63.52, 109.43)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.for_frame_count(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-254.85, 60.24, -455.84)
	event.set_camera_sequence_look_at(-89.19, 67.53, -382.63)
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -20.0, 40.0, -365.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
	train_sound = event.get_sound_id(2) or train_sound
	event.play_sound_effect(train_sound, 92)
	wait.for_frame_count(30)
	event.move_object_sequence(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	wait.for_frame_count(20)
	event.move_object_sequence(0, -130.0, 0.0, -365.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(-130.0, 0.0, -365.0, vm.f32(-1.57))
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-130.0, 30.0, -366.0)
	event.set_camera_position(-270.0, 40.0, -366.0)
	sindain_station.show_villagers()
	event.fade_in_screen(15)
end

--- Skip-handler counterpart of the train arrival cutscene that replays its waits.
local function skip_train_arrival_quick()
	cutscene.noop()
	cutscene.skip_command(1)
	wait.skip_frame_count(10)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	cutscene.skip_command(0)
	wait.skip_frame_count(10)
	cutscene.ignore_coordinates(-130.0, 0.0, -365.0, vm.f32(-1.57))
	cutscene.noop()
end

--- Asks whether to leave through the exit, then runs the player out and fades out, or steps the player back; returns 1 when leaving.
local function confirm_exit_to_map()
	local choice: any = 0
	local flag_207: s32 = 0
	local flag_208: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local loop_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_message_window_mode(0, 5)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.open_message_window_2(0, "『シャーロット』に移動しますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.set_object_sequence_position(0, -936.47, 0.0, -23.84)
			event.set_object_sequence_rotation(0, 0.0, -1.65, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-751.82, 79.08, -27.15)
			event.set_camera_sequence_look_at(-928.2, 36.53, -26.64)
			flag_207 = event.get_save_flag(207) or flag_207
			flag_208 = event.get_save_flag(208) or flag_208
			if flag_207 == 1 and flag_208 == 0 then
				event.skip_next_music_load()
			end
			event.move_object_sequence(0, -1142.09, 0.0, -28.24, 60)
			event.move_camera_sequence(-751.82, 79.08, -27.15, -921.16, 65.58, -20.12, 60)
			at = 2
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			at = 3
			wait.for_frame_count(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		x = vm.f32(x + vm.f32(30.0 * vm.sin(vm.f32(1.57))))
		z = vm.f32(z + vm.f32(30.0 * vm.cos(vm.f32(1.57))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for var6_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			at = 4
			vm.wait(4)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_message_window_mode(0, 7)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(30)
			end
			if at <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = loop_index < 45
			loop_index = loop_index + 1
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave through the dungeon exit, then runs the player out and fades out, or steps the player back; returns 1 when leaving.
local function confirm_exit_to_dungeon()
	local choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local angle: f32 = 0
	local loop_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_message_window_mode(0, 5)
		event.set_character_motion(0, "立ち", 4)
		event.open_message_window_2(0, "『七色蝶の森』に移動しますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -836.17, 0.0, -823.5)
			event.set_object_sequence_rotation(0, 0.0, -1.66, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-668.11, 97.09, -886.72)
			event.set_camera_sequence_look_at(-839.94, 44.81, -838.79)
			event.move_object_sequence(0, -1044.71, 0.0, -836.63, 60)
			event.move_camera_sequence(-668.11, 97.09, -886.72, -881.32, 61.14, -861.93, 60)
			at = 2
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			at = 3
			wait.for_frame_count(30)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = event.get_character_rotation(0)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		angle = vm.f32(vm.f32(3.1415927) + rotation_y)
		angle = event.wrap_angle(angle) or angle
		angle = vm.f32(1.5707964)
		x = vm.f32(x + vm.f32(30.0 * vm.sin(angle)))
		z = vm.f32(z + vm.f32(30.0 * vm.cos(angle)))
		event.rotate_object_sequence(0, rotation_x, angle, rotation_z, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for var8_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			at = 4
			vm.wait(4)
		end
		event.set_message_window_mode(0, 7)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(30)
			end
			if at <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = loop_index < 45
			loop_index = loop_index + 1
			return 0
		end
		return nil
	end)
end

--- Opens the floor menu of the second dungeon, then resumes play with the player walking back, jumps to map s05 or enters the chosen floor.
local function select_dungeon_floor()
	local selection: s32 = 0
	local flag_212: s32 = 0
	event.set_dungeon_stage_id(1)
	event.open_event_menu(3, 1)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		selection = out3 or selection
	end
	vm.wait(2)
	if selection == 0 then
		walk_player_back_from_menu()
	else
		if selection == 6 then
			event.jump_to_map_3(-1, "s05", 100)
			vm.wait(4)
			return
		end
		flag_212 = event.get_save_flag(212) or flag_212
		if selection == 2 and flag_212 == 0 or selection == 14 then
			event.skip_next_music_load()
		end
		event.go_to_dungeon(1, selection, 1010)
	end
end

--- Plays the cutscene of Starbre announcing the departure with the playable character and partner on the platform.
local function play_departure_announcement()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(283, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2237)
		sound_bank = event.load_sound_effect_file_2(2237) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e200/e283/")
		event.load_message_file(0, 5, "e283.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e283_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e283_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e283_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e200/e283/e283_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e200/e283/e283_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_object_handle_position(0, -160.79, 0.0, -340.48)
		event.set_object_handle_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_position(1, -187.76, 0.0, -348.73)
		event.set_object_handle_rotation(1, 0.0, 2.18, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_handle_position(2, -143.76, 0.0, -369.25)
		event.set_object_handle_rotation(2, 0.0, -1.46, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-254.7, 9.64, -441.04)
		event.set_camera_sequence_look_at(-145.97, 41.38, -347.02)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		event.fade_in_screen(30)
		event.stop_music(0)
		wait.for_frame_count(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.play_sound_effect(sound_bank, 2)
		message.show_voiced(2830010)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 2290.27, 0.0, 1646.13)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the skippable cutscene of the train steaming away from the station and fading out.
local function play_train_departure_cutscene()
	local sound_bank: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		at = 2
		wait.for_frame_count(30)
		event.load_map_sounds(2237)
		sound_bank = event.load_sound_effect_file_2(2237) or sound_bank
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		sindain_station.hide_station_parts()
		at = 3
		train.level_cars()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 400.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(1, "p01_shadow-0")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(2, 32)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(3, 33)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-304.68, 110.91, -288.45)
		event.set_camera_sequence_look_at(-158.49, 89.18, -46.7)
		event.fade_in_screen(30)
		at = 4
		wait.for_frame_count(30)
		event.set_character_active(1, 32)
		event.set_object_sequence_position(2, 30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(3, -30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		event.move_object_sequence_eased(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.play_sound_effect(sound_bank, 3)
		at = 5
		object.wait_until_done(0)
		event.fade_out_screen(30)
		at = 6
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.skip_frame_count(30)
		end
		if at <= 2 then
			cutscene.noop()
			sindain_station.log_slope_off()
		end
		if at <= 3 then
			wait.skip_frame_count(30)
		end
		if at <= 4 then
			cutscene.skip_command(0)
		end
		if at <= 5 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	at = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_effect_manager()
	event.delete_character(32)
	event.delete_character(33)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_character_active(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Initializes the station and places the player at the start position with a fade-in.
function script.place_player_at_station()
	event.initialize_event()
	sindain_station.initialize_map()
	event.set_camera_position(-368.0, 50.0, 62.1)
	event.set_camera_look_at(-368.0, 30.0, -57.9)
	event.set_character_position(0, -368.0, 0.0, -57.9)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.fade_in_screen(15)
end
script[99] = script.place_player_at_station

--- Places the player on entry according to the previous map, playing the arrival cutscene when needed.
function script.default_event()
	local forest_cutscene_ready_flag: s32 = 0
	local forest_cutscene_done_flag: s32 = 0
	local memory_card_loaded: s32 = 0
	local old_map_no: s32 = 0
	local old_map_type: s32 = 0
	local train_state: s32 = 0
	local chapter: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		sindain_station.initialize_map()
		print("start_event--------------------------------------------\n")
		forest_cutscene_ready_flag = event.get_save_flag(31) or forest_cutscene_ready_flag
		forest_cutscene_done_flag = event.get_save_flag(254) or forest_cutscene_done_flag
		if forest_cutscene_ready_flag ~= 0 and forest_cutscene_done_flag == 0 then
			play_carpenterion_forest_cutscene()
			event.jump_to_map_3(-1, "s47", 505)
			return
		end
		memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
		if memory_card_loaded == 1 then
			event.set_character_position(0, -750.0, 0.0, -75.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			old_map_type = event.get_map_type(old_map_no) or old_map_type
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 then
					stage = 2
					walk_player_back_from_menu()
					event.set_character_motion(0, "立ち")
					return
				else
					if old_map_no == 53 then
						stage = 3
						start_first_visit_event()
						return
					end
					if old_map_no == 0 then
						stage = 4
						run_player_in_with_fade()
					else
						train_state = event.get_save_counter(1) or train_state
						if
							(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
							and train_state == 2
						then
							train.place_player_at_saved_platform()
							event.fade_in_screen(15)
							event.reset_follow_camera(1, 0.0)
						else
							chapter = event.get_chapter() or chapter
							if chapter ~= 6 and chapter ~= 7 then
								stage = 5
								play_train_arrival_cutscene()
							else
								stage = 6
								play_train_arrival_quick()
							end
						end
					end
				end
			end
			event.set_character_motion(0, "立ち")
		end
		return
	end, function(received: { any })
		if stage <= 2 then
			return 0
		end
		if stage <= 3 then
			return 0
		end
		if stage <= 6 then
			if stage <= 4 then
				train.skip_place_player_at_saved_platform()
				stage = 5
				play_train_arrival_cutscene()
				return vm.continue_with(function()
					event.set_character_motion(0, "立ち")
					return
				end)
			end
			if stage <= 5 then
				skip_train_arrival_quick()
			end
			return 0
		end
		return nil
	end)
end

--- Shows a debug message window with an inserted string.
function script.key_open()
	event.set_message_inserted_string(0, 16, "なかみ")
	event.open_message_window_2(0, "ここから[文字列１６]ここまで")
	message.show(0, -1, 5, 0, 0)
end

--- Waits for a button press.
function script.wait_for_button()
	vm.wait(1)
	wait.until_button_pressed(32)
end
script[151] = script.wait_for_button

--- Confirms leaving and jumps to map g01.
function script.exit_to_g01()
	local exit_state_flag: s32 = 0
	if confirm_exit_to_map() ~= 0 then
		event.fade_out_screen(0)
		vm.wait(2)
		exit_state_flag = event.get_save_flag(208) or exit_state_flag
		if exit_state_flag == 0 then
			event.skip_next_music_play()
		end
		event.jump_to_map_2(-1, "g01")
		return
	end
end
script[209] = script.exit_to_g01

--- Confirms leaving and opens the dungeon floor selection.
function script.exit_to_dungeon()
	if confirm_exit_to_dungeon() ~= 0 then
		select_dungeon_floor()
	end
end
script[210] = script.exit_to_dungeon

--- Asks whether to board and boards the train for the destination chosen by the trigger.
function script.board_train()
	local answer: s32 = 0
	local chapter: s32 = 0
	local destination_kind: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		answer = menu.ask_enter_or_depart()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 2)
		chapter = event.get_chapter() or chapter
		destination_kind = event.get_triggered_event_data_2(3) or destination_kind
		if destination_kind <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				stage = 2
				train.board_short_train_primary()
				event.stop_music(0)
				stage = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				stage = 4
				train.board_short_train_primary()
				event.stop_music(0)
				stage = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			stage = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			stage = 7
			train.board_train_primary(1)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			stage = 8
			train.board_via_gangway_main()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if stage <= 1 then
			if stage == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if stage <= 8 then
			if stage <= 3 then
				map.run_train_interval_waits()
			end
			if stage <= 6 then
				map.print_train_debug_info(1)
			end
			if stage <= 7 then
				train.skip_board_via_gangway_main()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Event 499, which map data, a script or the engine runs by number.
script.play_train_arrival_cutscene = play_train_arrival_cutscene
script[499] = script.play_train_arrival_cutscene

--- Fades out and loads the companion cutscene that forms the party and gives five of item 352.
function script.cutscene_form_party()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("s02/s02b.stb", 501)
end
script[501] = script.cutscene_form_party

--- Loads the companion cutscene that gives item 370.
function script.cutscene_receive_item_370()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s02/s02b.stb", 502)
end
script[502] = script.cutscene_receive_item_370

--- Loads the companion cutscene that plays the station event 280 scene.
function script.cutscene_station_event_280()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s02/s02b.stb", 503)
end
script[503] = script.cutscene_station_event_280

--- Initializes the station and runs the player in with a fade.
function script.run_player_into_station()
	event.initialize_event()
	sindain_station.initialize_map()
	run_player_in_with_fade()
	event.set_character_motion(0, "立ち")
end
script[504] = script.run_player_into_station

--- Handles the triggered station characters, offering to depart for the train.
function script.talk_to_station_npc()
	local npc_kind: s32 = 0
	local answer: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		npc_kind = event.get_triggered_event_data_2(14) or npc_kind
		if npc_kind == 1 then
			stage = 1
			answer = party.talk_to_elder()
			if answer == 1 then
				stage = 2
				play_departure_announcement()
				stage = 3
				play_train_departure_cutscene()
				event.open_event_menu(13, 4)
				stage = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s04")
			end
		end
		if npc_kind == 2 then
			stage = 5
			party.talk_to_engineer()
		end
		if npc_kind == 13 then
			stage = 6
			party.talk_to_blaster()
		end
		if npc_kind == 301 then
			stage = 7
			party.talk_to_waiting_npc()
		end
		return
	end, function(received: { any })
		if stage <= 7 then
			if stage == 1 then
				answer = received[1] :: number
			end
			if stage <= 1 then
				stage = 2
				play_departure_announcement()
				return vm.continue_with(function()
					stage = 3
					play_train_departure_cutscene()
					event.open_event_menu(13, 4)
					stage = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s04")
					if npc_kind == 2 then
						stage = 5
						party.talk_to_engineer()
					end
					if npc_kind == 13 then
						stage = 6
						party.talk_to_blaster()
					end
					if npc_kind == 301 then
						stage = 7
						party.talk_to_waiting_npc()
					end
					return
				end)
			end
			if stage <= 2 then
				stage = 3
				play_train_departure_cutscene()
				return vm.continue_with(function()
					event.open_event_menu(13, 4)
					stage = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s04")
					if npc_kind == 2 then
						stage = 5
						party.talk_to_engineer()
					end
					if npc_kind == 13 then
						stage = 6
						party.talk_to_blaster()
					end
					if npc_kind == 301 then
						stage = 7
						party.talk_to_waiting_npc()
					end
					return
				end)
			end
			if stage <= 4 then
				party.skip_talk_to_engineer_primary()
			end
			if stage <= 5 then
				party.skip_talk_to_blaster_primary()
			end
			if stage <= 6 then
				party.skip_talk_to_waiting_npc_primary()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc

--- Fades out and loads the companion cutscene that forms the party and gives five of item 352.
function script.replay_form_party()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("s02/s02b.stb", 501)
end
script[12070] = script.replay_form_party

--- Sets the dungeon floor info, plays the forest cutscene and jumps to map s47.
function script.cutscene_carpenterion_then_s47()
	event.set_dungeon_floor_info(1, 7, 5, 256)
	play_carpenterion_forest_cutscene()
	event.jump_to_map_3(-1, "s47", 505)
end
script[12541] = script.cutscene_carpenterion_then_s47

--- Plays the departure announcement and cutscene and jumps to map s04.
function script.cutscene_train_departure()
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		play_departure_announcement()
		stage = 2
		play_train_departure_cutscene()
		event.open_event_menu(13, 4)
		stage = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s04")
		return
	end, function(received: { any })
		if stage <= 3 then
			if stage <= 1 then
				stage = 2
				play_train_departure_cutscene()
				return vm.continue_with(function()
					event.open_event_menu(13, 4)
					stage = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s04")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[12830] = script.cutscene_train_departure

return script
