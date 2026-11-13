--!strict
--- Event script for Balance Valley Station covering arrivals, boarding trains and station conversations.

local vm = require("@lib/vm")
local balance_valley_station = require("@lib/event/balance_valley_station")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local mints_character: s32 = 0
local monica_character: s32 = 0

--- Plays the cutscene in which the party arrives at the station and meets the villagers.
local function play_party_arrival_scene()
	local sound_bank: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(300, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(3200)
		sound_bank = event.load_sound_effect_file_2(3200) or sound_bank
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e300/")
		event.load_message_file(0, 5, "e300.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e300_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e300_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(0, 24)
		event.attach_object_handle_to_character(2, 24)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.change_directory("event/e200/e207/")
		event.load_character(5, "e207_vorneo.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e207_tom.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e300/e300_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e300/e300/e300_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 33)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_map_part_2(5, "p01_train01")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train08-m2")
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train08-m3")
		event.set_object_sequence_object(7, 7)
		event.attach_object_handle_to_map_part_3(8, "p01_train01", "train10-m14")
		event.set_object_sequence_object(8, 8)
		event.attach_object_handle_to_map_part_3(9, "p01_train01", "train10-m15")
		event.set_object_sequence_object(9, 9)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 5)
		event.set_object_handle_position(0, -51.32, 36.0, -146.5)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -44.65, 36.0, -161.3)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -60.0, 36.0, -154.54)
		event.set_object_handle_rotation(2, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_footstep_sound(2, 6)
		event.set_object_handle_position(3, -175.26, 36.0, 107.7)
		event.set_object_handle_rotation(3, 0.0, 2.8, 0.0)
		event.set_object_handle_position(4, -133.94, 36.0, 163.59)
		event.set_object_handle_rotation(4, 0.0, -3.12, 0.0)
		event.set_object_handle_position(5, 0.0, 0.0, -4200.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-305.89, 188.66, -811.58)
		event.set_camera_sequence_look_at(-260.09, 165.4, -1011.0)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 8)
		event.move_object_sequence(5, 0.0, 0.0, -1000.0, 90)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(-748.03, 60.33, -205.79)
		event.set_camera_sequence_look_at(-473.11, 63.96, -161.07)
		event.set_object_sequence_position(5, 0.0, 0.0, 200.0)
		event.move_object_sequence_eased(5, 0.0, 0.0, 400.0, 40, 2, 1.0)
		wait.for_frame_count(80)
		event.play_sound_effect(sound_bank, 9)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(8, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(9, 0.0, -1.5, 0.0, 30)
		object.wait_until_done(6)
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-256.14, 103.33, -318.65)
		event.set_camera_sequence_look_at(-109.39, 73.39, -128.41)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -104.57, 36.0, -146.0, 64)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -91.13, 36.0, -165.21, 60)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-4.55, 266.85, -23.64)
		event.set_camera_sequence_look_at(-51.16, 197.71, -66.4)
		event.move_camera_sequence_eased(102.69, 266.85, -24.93, -51.16, 197.71, -66.4, 60, 0, 1.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.move_object_sequence(0, -170.81, 36.0, -146.0, 80)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -161.13, 36.0, -165.21, 90)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		message.show_voiced(3000010)
		message.show_voiced(3000020)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-205.34, 64.3, -154.56)
		event.set_camera_sequence_look_at(-144.49, 53.0, -154.43)
		event.set_character_active(24)
		event.move_object_sequence(2, -114.8, 36.0, -154.66, 40)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		wait.for_frame_count(10)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(3000030)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-210.94, 73.59, -232.54)
		event.set_camera_sequence_look_at(-148.67, 56.48, -130.25)
		event.move_camera_sequence_eased(-210.94, 73.59, -232.54, -180.15, 61.97, -107.65, 20, 2, 1.0)
		event.set_character_active(35)
		event.set_character_active(36)
		event.set_object_sequence_motion(0, "右向く戻り", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "左向く", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(3, "会話2", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "スコップ会話2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 10)
		event.rotate_object_sequence(1, 0.0, 0.35, 0.0, 10)
		event.move_object_sequence(1, -193.42, 36.0, -145.41, 20)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, -1.93, 0.0, 10)
		event.move_object_sequence(2, -183.47, 36.0, -185.25, 60)
		event.delay_object_sequence_rotation_track(2, 30)
		event.rotate_object_sequence(2, 0.0, -0.01, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち")
		message.show_voiced(3000040)
		message.show_voiced(3000045)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-181.22, 61.67, -107.35)
		event.set_camera_sequence_look_at(-185.03, 54.04, -201.62)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_rotation(0, 0.0, 0.2, 0.0)
		event.set_object_sequence_motion(0, "手を振る", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(3000050)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(1, "回転左180度ＰＧ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 2.87, 0.0, 40)
		wait.for_frame_count(40)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(3000060)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-180.14, 58.52, -189.12)
		event.set_camera_sequence_look_at(-181.13, 55.77, -139.14)
		event.set_character_active(0, 24)
		event.set_character_active(0, 35)
		event.set_character_active(0, 36)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_rotation(0, 0.0, -2.91, 0.0)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(3000070)
		event.set_camera_sequence_position(-117.6, 87.58, -155.8)
		event.set_camera_sequence_look_at(-248.36, 57.62, -155.82)
		event.set_character_active(24)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, -1.09, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.rotate_object_sequence(1, 0.0, -1.61, 0.0, 10)
		event.move_object_sequence(1, -315.35, 0.0, -143.13, 52, 1)
		wait.for_frame_count(2)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 20)
		event.rotate_object_sequence(0, 0.0, -1.71, 0.0, 10)
		event.move_object_sequence(0, -303.46, 0.0, -165.04, 50, 1)
		wait.for_frame_count(30)
		event.fade_out_screen(20)
		wait.for_frame_count(20)
	end)
	vm.entry(29)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(sound_bank, 8)
	event.set_object_handle_position(5, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
	event.set_object_handle_texture_animation(2, 0)
	event.set_object_handle_texture_animation(2, 1, "通常目パチ")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -382.56, 0.0, -156.89)
	event.set_character_rotation(0, 0.0, -1.59, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 20.0)
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
		flag = event.get_save_flag(372) or flag
		event.set_character_active(0, 24)
		if flag == 0 then
			event.set_character_active(0, 25)
			event.set_character_active(0, 26)
		end
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 200.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m2")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m3")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m14")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m15")
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
		event.set_object_handle_footstep_sound(0, 6)
		event.play_sound_effect(sound_bank, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-266.11, 272.22, 848.56)
		event.set_camera_sequence_look_at(124.54, -133.73, -212.03)
		event.fade_in_screen(30)
		event.move_object_sequence_eased(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
		object.wait_until_done(1)
		wait.for_frame_count(10)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-211.1, 66.53, -316.91)
		event.set_camera_sequence_look_at(-87.12, 61.79, -127.67)
		train_sound_bank = event.get_sound_id(2) or train_sound_bank
		event.play_sound_effect(train_sound_bank, 66)
		event.set_character_active(0)
		event.set_object_sequence_position(0, -41.0, 36.0, -154.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		wait.for_frame_count(15)
		event.move_object_sequence(0, -130.0, 36.0, -154.0, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		wait.for_frame_count(10)
		event.set_object_handle_footstep_sound(0, 2)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.for_frame_count(10)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.fade_in_screen(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -130.0, 36.0, -154.0)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(1, 24)
	if flag == 0 then
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
	end
	event.set_camera_position(-79.74, 70.2, -154.0)
	event.set_camera_look_at(-130.0, 66.0, -154.0)
end

--- Plays the train pulling into the station and the party stepping onto the platform during the late chapters.
local function play_late_chapter_train_arrival()
	local sound_bank: s32 = 0
	local flag: s32 = 0
	local train_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	flag = event.get_save_flag(372) or flag
	event.set_character_active(0, 24)
	if flag == 0 then
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, 0.0, 0.0, 200.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.move_object_sequence_eased(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-266.11, 272.22, 848.56)
	event.set_camera_sequence_look_at(124.54, -133.73, -212.03)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.for_frame_count(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-211.1, 66.53, -316.91)
	event.set_camera_sequence_look_at(-87.12, 61.79, -127.67)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -41.0, 36.0, -154.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	train_sound_bank = event.get_sound_id(2) or train_sound_bank
	event.play_sound_effect(train_sound_bank, 92)
	wait.for_frame_count(15)
	event.move_object_sequence(0, -130.0, 36.0, -154.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_character_active(1, 24)
	if flag == 0 then
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
	end
	event.set_character_active(0)
	event.set_character_position(0, -130.0, 36.0, -154.0)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_position(-79.74, 70.2, -154.0)
	event.set_camera_look_at(-130.0, 66.0, -154.0)
	event.fade_in_screen(15)
end

--- Asks whether to move to Balance Valley, running off through the exit when accepted, and returns whether the player left.
local function ask_to_leave_for_balance_valley()
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
		event.open_message_window_2(0, "『てんびん谷』に移動しますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if choice == 0 then
			event.set_camera_sequence_position(-1159.24, 92.09, 269.02)
			event.set_camera_sequence_look_at(-1327.31, 55.37, 161.26)
			event.set_object_sequence_position(0, -1386.18, 24.63, 115.22)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1386.18, 29.63, 115.22)
			event.add_object_sequence_path_point(0, -1421.37, 37.04, 89.07)
			event.add_object_sequence_path_point(0, -1441.04, 44.13, 68.02)
			event.add_object_sequence_path_point(0, -1454.41, 52.15, 47.35)
			event.add_object_sequence_path_point(0, -1465.6, 61.13, 26.8)
			event.add_object_sequence_path_point(0, -1475.99, 68.270004, 2.68)
			event.add_object_sequence_path_point(0, -1483.7, 77.97, -24.81)
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
			step_x = vm.f32(vm.f32(vm.sin(vm.f32(1.44)) * 30.0) + character_x)
			step_y = 0.0
			step_z = vm.f32(vm.f32(vm.cos(vm.f32(1.44)) * 30.0) + character_z)
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
		event.set_object_handle_footstep_sound(0, 0)
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

--- Loads the party, the p01_03a character, motions and messages used by the station conversation cutscene.
local function load_station_chat_scene()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_character = 0
		monica_character = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_character)
		event.load_equipment_model(5, 1, 4, "info", monica_character)
		event.load_equipment_model(5, 1, 3, "info", monica_character)
		event.load_equipment_model(5, 1, 2, "info", monica_character, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_character = 32
		monica_character = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_character)
		event.load_equipment_model(5, 0, 4, "info", mints_character)
		event.load_equipment_model(5, 0, 3, "info", mints_character)
		event.load_equipment_model(5, 0, 2, "info", mints_character, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e300/e372/e372.txt")
	event.set_scene_status_flags(1, mints_character, 256, 1)
	event.set_scene_status_flags(1, monica_character, 256, 1)
end

--- Deletes the characters loaded for the station conversation cutscene and restores the party.
local function unload_station_chat_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_character)
		event.set_character_active(0, monica_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character(monica_character)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_character)
		event.set_character_active(0, mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character(mints_character)
		event.delete_character(37)
	end
	event.delete_character(35)
end

--- Plays the cutscene in which the party runs to the platform and talks with the p01_03a character, then restores control.
local function play_station_chat_scene()
	vm.section(function()
		event.set_character_active(0, 24)
		event.set_save_flag(372, 1)
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(20, "p01_train01")
		event.set_object_handle_position(20, 0.0, 0.0, 400.0)
		load_station_chat_scene()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(49)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, mints_character)
		event.set_character_active(1, monica_character)
		event.set_character_active(1, 35)
		event.set_camera_sequence_position(-940.17, 88.71, -222.08)
		event.set_camera_sequence_look_at(-788.53, 51.39, -202.38)
		event.set_object_sequence_position(0, -802.48, 0.0, -185.61)
		event.set_object_sequence_rotation(0, 0.0, 1.5, 0.0)
		event.set_object_sequence_position(1, -799.79, 0.0, -228.07)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(2, -126.08, 36.0, -149.46)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(15)
		event.set_object_sequence_motion(0, "走り", 0)
		event.set_object_sequence_motion(1, "走り", 0)
		event.move_object_sequence(0, -647.07, 0.0, -165.42, 60)
		event.move_object_sequence(1, -636.31, 0.0, -204.74, 60)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-243.89, 55.02, -207.96)
		event.set_camera_sequence_look_at(-152.87, 61.42, -156.97)
		event.set_object_sequence_position(0, -207.98, 36.0, -142.65)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -209.43, 36.0, -161.14)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.move_object_sequence(0, -155.54, 36.0, -140.71, 75)
		event.move_object_sequence(1, -153.89, 36.0, -159.09, 75)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced_for_stopping(3720500, 60)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-196.14, 62.27, -152.87)
		event.set_camera_sequence_look_at(-156.04, 61.42, -151.29)
		event.set_object_sequence_position(0, -155.54, 36.0, -140.71)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -153.89, 36.0, -159.09)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "会話2", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(3720505)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	if mints_character == 0 then
		event.set_character_position(0, -155.54, 36.0, -140.71)
	else
		event.set_character_position(0, -153.89, 36.0, -159.09)
	end
	unload_station_chat_scene()
	event.set_character_active(1, 24)
	event.fade_in_screen(30)
end

--- Plays Starbre announcing the train departure and fades out.
local function play_starbre_departure_announcement()
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(360, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.change_directory("event/e300/e360/")
		event.load_message_file(0, 5, "e360.txt")
		event.load_character(5, "e360_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.set_character_active(0, 0)
		event.set_character_active(0, 24)
		event.set_object_handle_position(2, -145.89, 36.0, -6.26)
		event.set_object_handle_rotation(2, 0.0, -1.58, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-189.99, 47.8, 29.79)
		event.set_camera_sequence_look_at(-106.32, 74.01, -26.32)
		event.set_character_active(34)
		event.fade_in_screen(30)
		event.stop_music(0)
		wait.for_frame_count(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(3600010)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the train steaming out of the station and fades out.
local function play_train_departure()
	local sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.load_map_sounds(3223)
		sound_bank = event.load_sound_effect_file_2(3223) or sound_bank
		event.set_character_active(0, 0)
		event.set_character_active(0, 24)
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
		balance_valley_station.hide_station_map_part()
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
		event.set_camera_sequence_position(-251.99, 110.91, -251.89)
		event.set_camera_sequence_look_at(-151.44, 89.18, -3.01)
		event.fade_in_screen(30)
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
		event.play_sound_effect(sound_bank, 0)
		object.wait_until_done(0)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_effect_manager()
	event.delete_character(32)
	event.delete_character(33)
	event.set_character_active(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.do_nothing() end
script[99] = script.do_nothing

--- Positions the party on entering the station: restores the player after a memory card load, runs in from the first map, plays the arrival cutscene or walks off the train, depending on the previous map and story flags.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map: s32 = 0
	local map_type: s32 = 0
	local save_flag_283: s32 = 0
	local save_flag_300: s32 = 0
	local chapter_on_arrival: s32 = 0
	local save_counter: s32 = 0
	local chapter_on_return: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		balance_valley_station.initialize_station_characters()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			event.set_character_position(0, -357.0, 0.0, -206.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			previous_map = event.get_previous_map() or previous_map
			map_type = event.get_map_type(previous_map) or map_type
			if map_type ~= -1 then
				if previous_map == 1 then
					checkpoint = 1
					balance_valley_station.run_in_from_map_entrance()
				elseif previous_map ~= 18 and previous_map ~= 23 and previous_map ~= 120 and previous_map ~= 108 then
					save_flag_283 = event.get_save_flag(283) or save_flag_283
					save_flag_300 = event.get_save_flag(300) or save_flag_300
					if save_flag_283 == 1 and save_flag_300 == 0 then
						event.set_villager_ai_enabled(0, 24)
						event.set_villager_ai_enabled(0, 25)
						event.set_villager_ai_enabled(0, 26)
						checkpoint = 2
						play_party_arrival_scene()
						balance_valley_station.place_villagers()
						event.set_villager_ai_enabled(1, 24)
						event.set_villager_ai_enabled(1, 25)
						event.set_villager_ai_enabled(1, 26)
					else
						event.set_character_active(0, 25)
						chapter_on_arrival = event.get_chapter() or chapter_on_arrival
						if chapter_on_arrival ~= 6 and chapter_on_arrival ~= 7 then
							checkpoint = 3
							play_early_chapter_train_arrival()
						else
							checkpoint = 4
							play_late_chapter_train_arrival()
						end
						event.set_character_active(25)
					end
				else
					save_counter = event.get_save_counter(1) or save_counter
					if
						(previous_map == 18 or previous_map == 23 or previous_map == 120 or previous_map == 108)
						and save_counter == 3
					then
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						chapter_on_return = event.get_chapter() or chapter_on_return
						if chapter_on_return ~= 6 and chapter_on_return ~= 7 then
							checkpoint = 5
							play_early_chapter_train_arrival()
						else
							checkpoint = 6
							play_late_chapter_train_arrival()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if checkpoint <= 6 then
			if checkpoint <= 1 then
				checkpoint = 2
				play_party_arrival_scene()
				return vm.continue_with(function()
					balance_valley_station.place_villagers()
					event.set_villager_ai_enabled(1, 24)
					event.set_villager_ai_enabled(1, 25)
					event.set_villager_ai_enabled(1, 26)
					return
				end)
			end
			if checkpoint <= 2 then
				cutscene.noop()
				checkpoint = 3
				play_early_chapter_train_arrival()
				return vm.continue_with(function()
					event.set_character_active(25)
					return
				end)
			end
			if checkpoint <= 3 then
				wait.skip_short_pause_primary()
			end
			if checkpoint <= 4 then
				train.skip_place_player_at_saved_platform()
				checkpoint = 5
				play_early_chapter_train_arrival()
				return vm.continue_with(function()
					return
				end)
			end
			if checkpoint <= 5 then
				wait.skip_short_pause_primary()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- Waits for the square button, plays a sound effect, then waits for the button again.
function script.key_open()
	local sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_2(3200) or sound_bank
	vm.wait(1)
	wait.until_button_pressed(32)
	event.play_sound_effect(sound_bank, 8)
	vm.wait(3)
	wait.until_button_pressed(32)
end

--- Asks whether to leave and boards a short train to s08 or s37, or a full train to s07 or s38, depending on the chapter and trigger data.
function script.board_train()
	local choice: s32 = 0
	local chapter: s32 = 0
	local train_kind: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		choice = menu.ask_enter_or_depart()
		if choice ~= 1 then
			return
		end
		event.set_save_counter(1, 3)
		chapter = event.get_chapter() or chapter
		train_kind = event.get_triggered_event_data_2(3) or train_kind
		if train_kind <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				checkpoint = 2
				train.board_short_train_primary()
				event.stop_music(0)
				checkpoint = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				checkpoint = 4
				train.board_short_train_primary()
				event.stop_music(0)
				checkpoint = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			checkpoint = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			checkpoint = 7
			train.board_train_primary(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			checkpoint = 8
			train.board_via_gangway_main()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if checkpoint <= 1 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			return 0
		end
		if checkpoint <= 8 then
			if checkpoint <= 3 then
				map.run_train_interval_waits()
			end
			if checkpoint <= 6 then
				map.print_train_debug_info(0)
			end
			if checkpoint <= 7 then
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

--- Asks whether to leave through the map exit and jumps to map g02 when the player does.
function script.leave_station_to_g02()
	if ask_to_leave_for_balance_valley() ~= 0 then
		event.jump_to_map_3(-1, "g02", 100)
	end
end
script[500] = script.leave_station_to_g02

--- Plays the cutscene in which the party runs to the platform and talks.
function script.cutscene_station_chat()
	balance_valley_station.initialize_station_characters()
	play_station_chat_scene()
end
script[501] = script.cutscene_station_chat

--- Grants the stage supplies and plays the party arrival cutscene with the villagers.
function script.cutscene_arrival_with_supplies()
	inventory.grant_stage_supplies(3)
	balance_valley_station.initialize_station_characters()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	play_party_arrival_scene()
	balance_valley_station.place_villagers()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end
script[502] = script.cutscene_arrival_with_supplies

--- Handles conversation with the station character chosen by the trigger data, including departing by train.
function script.talk_to_station_npc()
	local npc_id: s32 = 0
	local choice: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		if npc_id == 1 then
			checkpoint = 1
			choice = party.talk_to_elder()
			if choice == 1 then
				checkpoint = 2
				play_starbre_departure_announcement()
				checkpoint = 3
				play_train_departure()
				event.open_event_menu(13, 8)
				checkpoint = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s09")
			end
		end
		if npc_id == 2 then
			checkpoint = 5
			party.talk_to_engineer()
		end
		if npc_id == 13 then
			checkpoint = 6
			party.talk_to_blaster()
		end
		if npc_id == 301 then
			checkpoint = 7
			party.talk_to_waiting_npc()
		end
		return
	end, function(received: { any })
		if checkpoint <= 7 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				checkpoint = 2
				play_starbre_departure_announcement()
				return vm.continue_with(function()
					checkpoint = 3
					play_train_departure()
					event.open_event_menu(13, 8)
					checkpoint = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if npc_id == 2 then
						checkpoint = 5
						party.talk_to_engineer()
					end
					if npc_id == 13 then
						checkpoint = 6
						party.talk_to_blaster()
					end
					if npc_id == 301 then
						checkpoint = 7
						party.talk_to_waiting_npc()
					end
					return
				end)
			end
			if checkpoint <= 2 then
				checkpoint = 3
				play_train_departure()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					checkpoint = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if npc_id == 2 then
						checkpoint = 5
						party.talk_to_engineer()
					end
					if npc_id == 13 then
						checkpoint = 6
						party.talk_to_blaster()
					end
					if npc_id == 301 then
						checkpoint = 7
						party.talk_to_waiting_npc()
					end
					return
				end)
			end
			if checkpoint <= 4 then
				party.skip_talk_to_engineer_primary()
			end
			if checkpoint <= 5 then
				party.skip_talk_to_blaster_primary()
			end
			if checkpoint <= 6 then
				party.skip_talk_to_waiting_npc_primary()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc

--- Plays the party arrival cutscene with the villagers.
function script.cutscene_party_arrival()
	balance_valley_station.initialize_station_characters()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	play_party_arrival_scene()
	balance_valley_station.place_villagers()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end
script[13000] = script.cutscene_party_arrival

--- Plays Starbre's departure announcement and the train leaving, then jumps to map s09.
function script.cutscene_train_departure()
	local checkpoint: number = 0
	return vm.guard(function()
		balance_valley_station.initialize_station_characters()
		checkpoint = 1
		play_starbre_departure_announcement()
		checkpoint = 2
		play_train_departure()
		event.open_event_menu(13, 8)
		checkpoint = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s09")
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				checkpoint = 2
				play_train_departure()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					checkpoint = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s09")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[13600] = script.cutscene_train_departure

return script
