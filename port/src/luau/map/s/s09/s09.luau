--!strict
--- Veniccio station script covering the arrival cutscenes, boarding trains and the departure to the next town.

local vm = require("@lib/vm")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local veniccio_station = require("@lib/event/veniccio_station")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Plays the cutscene in which the party arrives at the station and meets the station staff.
local function play_party_arrival_scene()
	local sound_bank: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(400, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(4200) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e400/e400/")
		event.load_message_file(0, 5, "e400.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e400_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e400_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e400/e400_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e400/e400_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_villager_ai_enabled(0, 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(7, 8)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_villager_ai_enabled(0, 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(8, 9)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_villager_ai_enabled(0, 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(9, 10)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_2(2, "p01_train01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m0")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m1")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(7, 1, "通常目パチ")
		event.set_object_handle_position(0, -1494.0, 42.31, -35.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, -1478.0, 42.31, -35.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(7, -1485.0, 45.34, -9.42)
		event.set_object_handle_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(7, "立ち", 4)
		event.set_object_handle_position(2, -2312.1, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1481.05, 64.34, -282.56)
		event.set_camera_sequence_look_at(-1949.42, 59.22, -91.09)
		event.move_camera_sequence_eased(-1481.05, 64.34, -282.56, -1473.02, 59.22, -83.94, 80, 2, 1.0)
		event.move_object_sequence_eased(2, -912.1, 0.0, 0.0, 80, 2, 1.0)
		event.play_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 5)
		event.fade_in_screen(30)
		object.wait_until_done(2)
		wait.for_frame_count(20)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(8)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		wait.for_frame_count(30)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -1493.51, 29.22, -100.0, 60)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -1478.51, 29.22, -90.0, 50)
		wait.for_frame_count(20)
		event.set_object_handle_footstep_sound(0, 3)
		wait.for_frame_count(10)
		event.set_object_handle_footstep_sound(1, 3)
		wait.for_frame_count(20)
		event.clear_effect_manager()
		event.set_camera_sequence_position(-1510.53, 52.11, -162.67)
		event.set_camera_sequence_look_at(-1480.38, 51.06, -136.4)
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.move_object_sequence(1, -1478.51, 29.22, -145.0, 50)
		event.set_object_sequence_motion(1, "潮歩き", 4)
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "潮立ち")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4000010)
		object.wait_until_done(1)
		event.move_object_sequence(0, -1493.51, 29.22, -135.0, 50)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4000020)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "潮立ちから右", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000030)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4000040)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000050)
		event.set_camera_sequence_position(-1482.95, 61.09, -180.61)
		event.set_camera_sequence_look_at(-1483.79, 47.79, -128.26)
		event.set_object_sequence_position(7, -1483.61, 29.22, -91.35)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(1, "ふりかえり", 6)
		event.queue_object_sequence_next_motion(1, "ふりかえりＬ", 4)
		event.set_object_sequence_motion(0, "振り返り", 6)
		event.queue_object_sequence_next_motion(0, "振り返りL", 4)
		event.set_mouth_texture_animations(7, "口パク")
		message.show_voiced(4000060)
		event.set_camera_sequence_position(-1563.93, 73.34, -118.52)
		event.set_camera_sequence_look_at(-1483.1, 54.11, -118.91)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_position(9, -625.34, 29.22, -99.11)
		event.set_character_position(10, -627.43, 29.22, -126.82)
		event.set_object_sequence_position(7, -1489.0, 29.22, -98.62)
		event.set_object_sequence_rotation(7, 0.0, 1.58, 0.0)
		event.set_object_sequence_position(0, -1496.36, 29.22, -129.63)
		event.set_object_sequence_rotation(0, 0.0, 1.46, 0.0)
		event.set_object_sequence_motion(0, "立ち", 6, -1.0, 1)
		event.set_object_sequence_position(1, -1478.51, 29.22, -145.0)
		event.set_object_sequence_rotation(1, 0.0, 0.98, 0.0)
		event.set_object_sequence_motion(1, "立ち", 6, -1.0, 1)
		message.show_voiced(4000070)
		event.set_object_sequence_motion(1, "手振り", 6)
		event.queue_object_sequence_next_motion(1, "手振りＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000080)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-1522.27, 54.57, -147.64)
		event.set_camera_sequence_look_at(-1483.82, 49.34, -134.4)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 8)
		event.set_object_sequence_rotation(0, 0.0, 1.82, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "手振りから左", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4000085)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.for_frame_count(6)
		event.play_sound_effect(sound_bank, 8)
		object.wait_until_done(0)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 5)
	event.set_object_handle_position(2, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	event.set_character_active(8)
	event.set_character_position(8, -2030.0, 30.0, -100.0)
	event.set_character_rotation(8, 0.0, 3.14, 0.0)
	event.set_villager_ai_enabled(1, 8)
	event.set_character_active(9)
	event.set_character_position(9, -1098.0, 29.2, -100.0)
	event.set_character_rotation(9, 0.0, -1.57, 0.0)
	event.set_villager_ai_enabled(1, 9)
	event.set_character_active(10)
	event.set_character_position(10, -707.6, -10.0, -172.5)
	event.set_character_rotation(10, 0.0, 0.0, 0.0)
	event.set_villager_ai_enabled(1, 10)
	event.set_character_active(0)
	event.set_character_position(0, -1880.1, 29.2, -299.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the train pulling into the station and the party stepping onto the platform before the late chapters.
local function play_early_chapter_train_arrival()
	local flag: s32 = 0
	local sound_bank: s32 = 0
	local train_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		flag = event.get_save_flag(448) or flag
		event.set_character_active(0, 8)
		if flag == 0 then
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
		end
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(6, "p01_shadow")
		event.set_object_handle_visible(6, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m0")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m1")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m0")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m1")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-363.94, 121.88, -75.09)
		event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
		event.fade_in_screen(30)
		event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
		object.wait_until_done(1)
		wait.for_frame_count(10)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
		event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
		train_sound_bank = event.get_sound_id(2) or train_sound_bank
		event.play_sound_effect(train_sound_bank, 66)
		event.set_object_handle_position(1, -912.1, 0.0, 0.0)
		event.set_character_active(0)
		event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		wait.for_frame_count(15)
		event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		wait.for_frame_count(10)
		event.set_object_handle_footstep_sound(0, 3)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.for_frame_count(10)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.fade_in_screen(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(1, 8)
	if flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.reset_follow_camera(1, 3.14, 10.0)
end

--- Plays the train pulling into the station and the party stepping onto the platform during the late chapters.
local function play_late_chapter_train_arrival()
	local sound_bank: s32 = 0
	local flag: s32 = 0
	local train_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
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
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.for_frame_count(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
	event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	train_sound_bank = event.get_sound_id(2) or train_sound_bank
	event.play_sound_effect(train_sound_bank, 92)
	wait.for_frame_count(15)
	event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 3)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
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

--- Asks whether to move to Veniccio, running off through the exit when accepted, and returns whether the player left.
local function ask_to_leave_for_veniccio()
	local choice: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local frame_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『ベニーティオ』に移動しますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if choice == 0 then
			event.set_camera_sequence_position(-1925.42, 97.53, -285.93)
			event.set_camera_sequence_look_at(-1921.75, 57.81, -472.01)
			event.set_object_sequence_position(0, -1910.95, 21.58, -466.12)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1910.95, 21.58, -466.12)
			event.add_object_sequence_path_point(0, -1907.45, 17.42, -496.67)
			event.add_object_sequence_path_point(0, -1898.74, 13.2, -528.24)
			event.add_object_sequence_path_point(0, -1878.93, 9.61, -555.9)
			event.add_object_sequence_path_point(0, -1854.68, 5.12, -580.59)
			event.add_object_sequence_path_point(0, -1828.07, 1.46, -591.28)
			event.start_object_sequence_path(0)
			at = 2
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			at = 3
			wait.for_frame_count(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			step_x = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + character_x)
			step_y = 0.0
			step_z = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + character_z)
			event.move_object_sequence(0, step_x, step_y, step_z, 30, 1)
			event.turn_object_sequence_toward(0, step_x, step_y, step_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			frame_index = 0
			while frame_index < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					character_x = out1 or character_x
					character_y = out2 or character_y
					character_z = out3 or character_z
				end
				character_y = vm.f32(character_y + 30.0)
				event.set_camera_look_at(character_x, character_y, character_z)
				frame_index = frame_index + 1
				at = 4
				vm.wait(4)
			end
		end
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
			return 0
		end
		return nil
	end)
end

--- Loads Max, Monica and the station cutscene models in the slots for the active character.
local function load_station_cutscene_party()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "chara/p01_06a.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.load_message_file(0, 5, "event/e400/e448/e448.txt")
end

--- Unloads the cutscene models and places the player at the station.
local function unload_station_cutscene_party()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.set_character_position(0, -1952.44, 29.22, -304.96)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
end

--- Plays the cutscene where Max and Monica meet the station staff.
local function play_station_meeting_cutscene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4220)
		sound_bank = event.load_sound_effect_file_2(4220) or sound_bank
		load_station_cutscene_party()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
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
		event.set_camera_sequence_position(-1979.65, 91.43, -121.02)
		event.set_camera_sequence_look_at(-1941.55, 74.53, -339.62)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_position(1, -1838.01, 8.0, -560.01)
		event.set_object_sequence_rotation(1, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(0, -1904.92, 17.42, -503.6)
		event.set_object_sequence_rotation(0, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(2, -2186.89, 29.22, -198.9)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(3, -2223.98, 29.22, -196.3)
		event.set_object_sequence_rotation(3, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(4, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -1904.92, 17.42, -503.6)
		event.add_object_sequence_path_point(0, -1985.4, 29.22, -393.12)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, -1838.01, 8.0, -560.01)
		event.add_object_sequence_path_point(1, -1922.88, 29.4, -436.71)
		event.start_object_sequence_path(1, 1)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-2052.02, 160.14, -365.82)
		event.set_camera_sequence_look_at(-2179.63, 74.53, -268.32)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -360.0)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -253.55)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -360.0)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -253.55)
		event.start_object_sequence_path(0)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(4481130)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		message.show_voiced(4481140)
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		message.show_voiced(4481150)
		event.set_object_sequence_motion(3, "立ち")
		wait.for_frame_count(30)
		event.set_object_sequence_position(1, -1935.53, 29.22, -301.43)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -1952.44, 29.22, -304.96)
		event.set_object_sequence_rotation(0, 0.0, 1.08, 0.0)
		event.set_camera_sequence_position(-1949.04, 34.26, -256.22)
		event.set_camera_sequence_look_at(-1934.01, 87.78, -397.48)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4481160)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 25)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4481170)
		event.reset_mouth_texture_animations()
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.for_frame_count(35)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_station_cutscene_party()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Handles talking to a station character and tells whether the party leaves.
local function talk_to_station_npc()
	local npc_id: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		if npc_id == 1 then
			resume_step = 1
			return party.talk_to_elder()
		end
		if npc_id == 2 then
			resume_step = 2
			party.talk_to_engineer()
		end
		if npc_id == 13 then
			resume_step = 3
			party.talk_to_blaster()
		end
		if npc_id == 301 then
			resume_step = 4
			party.talk_to_waiting_npc()
		end
		return 0
	end, function(received: { any })
		if resume_step <= 1 then
			return veniccio_station.run_prompt_main_map()
		end
		if resume_step <= 4 then
			if resume_step <= 2 then
				party.skip_talk_to_blaster_primary()
			end
			if resume_step <= 3 then
				party.skip_talk_to_waiting_npc_primary()
			end
			return 0
		end
		return nil
	end)
end

--- Plays Starbre announcing the train departure and fades out.
local function play_starbre_departure_announcement()
	local sound_bank: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(452, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4223)
		sound_bank = event.load_sound_effect_file_2(4223) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.load_message_file(0, 5, "event/e400/e452/e452.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/e200/e283/e283_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 32)
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
		event.set_object_handle_position(0, -1960.0, 29.22, -120.0)
		event.set_object_handle_rotation(0, 0.0, -0.7853982, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -2000.0, 29.22, -120.0)
		event.set_object_handle_rotation(1, 0.0, 0.7853982, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_position(2, -1980.0, 29.22, -100.0)
		event.set_object_handle_rotation(2, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1980.0, 51.24, -291.47)
		event.set_camera_sequence_look_at(-1980.0, 91.37, -49.52)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		event.fade_in_screen(30)
		wait.for_frame_count(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.play_sound_effect(sound_bank, 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4520010)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the steam train leaving the station, optionally fading out the music, and fades out.
local function play_steam_train_departure(fade_music: s32)
	local sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.load_map_sounds(4223)
		sound_bank = event.load_sound_effect_file_2(4223) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 1.5707964, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, -120.0, 0.0, -1690.0)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -120.0, 0.0, -1690.0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_shadow")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-480.06, 58.66, -117.78)
		event.set_camera_sequence_look_at(-569.61, 64.12, -98.79)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_active(11)
		event.set_object_sequence_position(2, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(2, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(12)
		event.set_object_sequence_position(3, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(3, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		wait.for_frame_count(60)
		event.move_object_sequence_eased(0, 4000.0, 0.0, 0.0, 180, 1, 1.0)
		event.move_object_sequence_eased(1, 4500.0, 0.0, 0.0, 180, 1, 1.0)
		event.play_sound_effect(sound_bank, 2)
		object.wait_until_done(0)
		if fade_music ~= 0 then
			event.fade_out_music(30)
		end
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	if fade_music ~= 0 then
		event.stop_music(0)
	end
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.delete_character(11)
	event.delete_character(12)
	event.clear_effect_manager()
	event.set_character_active(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default map setup.
function script.skip_default_setup() end
script[99] = script.skip_default_setup

--- Plays the arrival matching how the player came to the station.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local map_type: s32 = 0
	local train_station_counter: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local chapter: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		print("START_EVENT----------------------------")
		veniccio_station.initialize_station()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -1820.0, 29.2, -335.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			map_type = event.get_map_type() or map_type
			if map_type ~= -1 then
				if old_map_no == 2 or old_map_no == 75 then
					resume_step = 1
					veniccio_station.run_into_station()
				else
					train_station_counter = event.get_save_counter(1) or train_station_counter
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and train_station_counter == 4
					then
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						flag = event.get_save_flag(360) or flag
						flag_2 = event.get_save_flag(400) or flag_2
						if flag == 1 and flag_2 == 0 then
							resume_step = 2
							play_party_arrival_scene()
						else
							event.set_character_active(0, 9)
							chapter = event.get_chapter() or chapter
							if chapter ~= 6 and chapter ~= 7 then
								resume_step = 3
								play_early_chapter_train_arrival()
							else
								resume_step = 4
								play_late_chapter_train_arrival()
							end
							event.set_character_active(1, 9)
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				train.skip_place_player_at_saved_platform()
				resume_step = 2
				play_party_arrival_scene()
				return vm.continue_with(function()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				play_early_chapter_train_arrival()
				return vm.continue_with(function()
					event.set_character_active(1, 9)
					return
				end)
			end
			if resume_step <= 3 then
				wait.skip_short_pause_primary()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_late_chapter_train_arrival

--- Leaves the station for the town exit after confirmation.
function script.leave_station()
	if ask_to_leave_for_veniccio() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end
script[201] = script.leave_station

--- Asks to board a train and starts the matching departure.
function script.board_train()
	local answer: s32 = 0
	local chapter: s32 = 0
	local train_route: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		answer = menu.ask_enter_or_depart()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 4)
		chapter = event.get_chapter() or chapter
		train_route = event.get_triggered_event_data_2(3) or train_route
		if train_route <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				resume_step = 2
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				resume_step = 4
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			resume_step = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			resume_step = 7
			train.board_train_primary(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			resume_step = 8
			train.board_via_gangway_main()
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
		if resume_step <= 8 then
			if resume_step <= 3 then
				map.run_train_interval_waits()
			end
			if resume_step <= 6 then
				map.print_train_debug_info(0)
			end
			if resume_step <= 7 then
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

--- Sets up the station and plays the station meeting cutscene.
function script.cutscene_station_meeting()
	veniccio_station.initialize_station()
	play_station_meeting_cutscene()
end
script[500] = script.cutscene_station_meeting

--- Talks to the station character and sends the party off on the steam train when ready.
function script.talk_to_station_npc_and_depart()
	local departure_requested: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		departure_requested = talk_to_station_npc()
		if departure_requested == 1 then
			resume_step = 2
			play_starbre_departure_announcement()
			resume_step = 3
			play_steam_train_departure(1)
			event.open_event_menu(13, 9)
			resume_step = 4
			vm.wait(4)
			event.skip_next_music_load()
			event.jump_to_map_2(-1, "s10")
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				departure_requested = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				play_starbre_departure_announcement()
				return vm.continue_with(function()
					resume_step = 3
					play_steam_train_departure(1)
					event.open_event_menu(13, 9)
					resume_step = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				play_steam_train_departure(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					resume_step = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc_and_depart

--- Sets up the station and replays the first arrival.
function script.replay_first_arrival()
	veniccio_station.initialize_station()
	play_party_arrival_scene()
end
script[14000] = script.replay_first_arrival

--- Replays the send-off and steam train departure.
function script.replay_departure()
	local resume_step: number = 0
	return vm.guard(function()
		veniccio_station.initialize_station()
		resume_step = 1
		play_starbre_departure_announcement()
		resume_step = 2
		play_steam_train_departure(1)
		event.open_event_menu(13, 9)
		resume_step = 3
		vm.wait(3)
		event.skip_next_music_load()
		event.jump_to_map_2(-1, "s10")
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				play_steam_train_departure(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					resume_step = 3
					vm.wait(3)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14520] = script.replay_departure

return script
