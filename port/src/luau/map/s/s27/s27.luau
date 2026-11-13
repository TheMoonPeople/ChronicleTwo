--!strict
--- Pau's house interior in the Shigura village with the Shingala medicine quest and Pau joining the party.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local paus_house = require("@lib/event/paus_house")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Places the residents of Pau's house.
local function place_residents()
	paus_house.place_residents()
end

--- Plays the e404 cutscene with the long conversation among the party, Pau and the villagers.
local function play_event_e404()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(404, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(30)
		sound_bank = event.load_sound_effect_file_2(4206) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e404/")
		event.load_message_file(0, 5, "e404.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e404_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e404_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e404_paw.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e404_shigu.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e404_karabin.gltf", "info", 36)
		event.set_character_active(36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e404/e404_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e404/e404_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -346.36, 20.61, -3.45)
		event.set_object_handle_rotation(0, 0.0, 1.11, 0.0)
		event.set_object_handle_footstep_sound(0, 7)
		event.set_object_handle_position(1, -296.44, 20.61, -2.15)
		event.set_object_handle_rotation(1, 0.0, 1.11, 0.0)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_object_handle_position(2, -51.9, 0.0, 8.31)
		event.set_object_handle_rotation(2, 0.0, -3.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.is_object_handle_frame_visible(2, "te_r")
		event.set_object_handle_frame_draw_flag(2, "te_r", 0)
		event.set_object_handle_footstep_sound(2, 4)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_position(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(3, "座り", 4)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.set_object_handle_position(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(4, "投げる", 4)
		event.step_object_handle_motion(4)
		event.set_object_handle_motion(4, "原点", 4)
		event.attach_character_to_frame(34, "bin", 36)
		event.move_object_sequence(0, -264.06, 20.61, 48.15, 70)
		event.delay_object_sequence_rotation_track(0, 60)
		event.rotate_object_sequence(0, 0.0, 1.71, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 70)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -249.01, 20.61, 31.75, 60)
		event.delay_object_sequence_rotation_track(1, 50)
		event.rotate_object_sequence(1, 0.0, 1.59, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "苦痛目とじ")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2.67, 50.23, 132.91)
		event.set_camera_sequence_look_at(-175.7, 42.68, 68.42)
		event.fade_in_screen(30)
		wait.for_frame_count(10)
		event.set_object_handle_footstep_sound(1, 7)
		message.show_voiced(4040010)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-329.01, 58.36, 79.54)
		event.set_camera_sequence_look_at(-219.96, 42.3, 48.35)
		event.set_object_sequence_motion(2, "だめだよ", 4)
		event.set_object_sequence_motion(3, "だめだよ", 4)
		message.show_voiced(4040020)
		event.queue_object_sequence_next_motion(2, "だめだよ戻り", 6)
		event.queue_object_sequence_next_motion(2, "左見るL", 4)
		event.queue_object_sequence_next_motion(3, "だめだよ戻り", 6)
		event.queue_object_sequence_next_motion(3, "座り", 6)
		event.delay_object_sequence_sound_track(3, 50)
		event.play_object_sequence_sound(3, sound_bank, 5)
		message.show_voiced(4040030)
		object.wait_until_done(2)
		object.wait_until_done(3)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～通常目")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ")
		object.wait_until_done(2)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		message.show_voiced(4040040)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		message.show_voiced(4040045)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040050)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-62.1, 19.31, -10.25)
		event.set_camera_sequence_look_at(-54.35, 19.0, 10.63)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		message.show_voiced(4040060)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		message.show_voiced(4040065)
		event.set_camera_sequence_position(-220.74, 65.68, 88.82)
		event.set_camera_sequence_look_at(-108.87, 28.0, 27.84)
		event.set_object_sequence_motion(2, "手当て", 4)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_footstep_sound(1, 4)
		event.set_object_sequence_position(0, -185.96, 0.0, 49.8)
		event.set_object_sequence_rotation(0, 0.0, 1.83, 0.0)
		event.move_object_sequence(0, -128.34, 0.0, 29.11, 60)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, -187.4, 0.0, 19.01)
		event.set_object_sequence_rotation(1, 0.0, 1.59, 0.0)
		event.move_object_sequence(1, -138.07, 0.0, 15.04, 60)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		message.show_voiced(4040070)
		message.show_voiced(4040080)
		message.show_voiced(4040090)
		event.set_camera_sequence_position(-73.88, 22.38, 10.51)
		event.set_camera_sequence_look_at(-51.05, 17.89, 9.61)
		event.set_object_sequence_motion(2, "左見る", 6)
		event.queue_object_sequence_next_motion(2, "左見るL", 4)
		vm.wait(20)
		event.stop_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 7)
		object.wait_until_done(2)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		message.show_voiced(4040100)
		event.set_camera_sequence_position(-99.1, 24.86, 20.27)
		event.set_camera_sequence_look_at(-131.88, 21.69, 23.96)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4040110)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4040120)
		event.set_camera_sequence_position(-220.74, 65.68, 88.82)
		event.set_camera_sequence_look_at(-108.87, 28.0, 27.84)
		event.set_object_sequence_motion(2, "手当て", 4)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040130)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目～おこり目")
		message.show_voiced(4040140)
		event.set_camera_sequence_position(-85.39, 16.63, -5.51)
		event.set_camera_sequence_look_at(-55.98, 16.38, 14.8)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_position(2, -62.67, 0.0, 11.85)
		event.set_object_sequence_rotation(2, 0.0, -0.6, 0.0)
		event.set_object_sequence_motion(2, "だめだ", 4)
		vm.wait(28)
		event.stop_sound_effect(sound_bank, 6)
		message.show_voiced(4040150)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "投げる", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, sound_bank, 8)
		message.show_voiced_for_stopping(4040155, 30)
		event.set_camera_sequence_position(-214.38, 6.96, 210.05)
		event.set_camera_sequence_look_at(-61.08, 16.38, 10.57)
		event.detach_character_from_frame(36)
		event.set_object_sequence_position(4, -109.71, 0.0, 72.24)
		event.set_object_sequence_rotation(4, 0.0, -2.24, 0.0)
		event.move_object_sequence_eased(4, -190.78, 0.0, 177.73, 60, 2, 1.0)
		event.set_object_sequence_motion(4, "投げる", 6)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 9)
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(-214.38, 6.96, 210.05, 19.36, 16.38, 100.01, 60, 0, 1.0)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "ごそごそ", 2)
		event.queue_object_sequence_next_motion(2, "ごそごそL", 4)
		event.delay_object_sequence_sound_track(2, 90)
		event.play_object_sequence_sound(2, sound_bank, 10)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, -62.67, 0.0, 11.85)
		event.add_object_sequence_path_point(2, -88.51, 0.0, 42.69)
		event.add_object_sequence_path_point(2, -96.04, 0.0, 62.71)
		event.add_object_sequence_path_point(2, -79.41, 0.0, 79.32)
		event.add_object_sequence_path_point(2, -29.23, 0.0, 84.34)
		event.add_object_sequence_path_point(2, 97.87, 0.0, 63.75)
		event.start_object_sequence_path(2)
		message.show_voiced(4040160)
		message.show_voiced(4040170)
		message.show_voiced(4040180)
		event.set_camera_sequence_position(-97.12, 17.91, 38.03)
		event.set_camera_sequence_look_at(-126.19, 20.37, 27.25)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040190)
		event.set_camera_sequence_position(-214.38, 6.96, 210.05)
		event.set_camera_sequence_look_at(19.36, 16.38, 100.01)
		event.stop_sound_effect(sound_bank, 10)
		event.set_object_sequence_rotation(2, 0.0, -1.25, 0.0)
		event.set_object_sequence_motion(2, "振り返る", 6)
		message.show_voiced(4040200)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-214.38, 6.96, 210.05, -103.55, 16.38, 29.91, 60, 1, 0.5)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 180)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.delay_object_sequence_position_track(2, 30)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 180)
		event.add_object_sequence_path_point(2, 97.87, 0.0, 63.75)
		event.add_object_sequence_path_point(2, 49.57, 0.0, 75.14)
		event.add_object_sequence_path_point(2, -11.95, 0.0, 82.77)
		event.add_object_sequence_path_point(2, -67.61, 0.0, 82.39)
		event.add_object_sequence_path_point(2, -150.58, 0.0, 64.9)
		event.add_object_sequence_path_point(2, -195.33, 2.91, 52.94)
		event.add_object_sequence_path_point(2, -227.84, 20.61, 40.39)
		event.add_object_sequence_path_point(2, -331.01, 20.61, 4.35)
		event.add_object_sequence_path_point(2, -424.72, 20.61, -67.99)
		event.start_object_sequence_path(2)
		message.show_voiced_for_stopping(4040210, 90)
		camera.wait_until_done()
		event.set_camera_sequence_position(-160.1, 24.16, 102.57)
		event.set_camera_sequence_look_at(-132.99, 16.38, -3.38)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(-81.33, 34.07, 23.0)
		event.set_camera_sequence_look_at(-161.65, 26.29, 28.12)
		event.set_object_handle_footstep_sound(2, 7)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.delay_object_sequence_motion_track(1, 29)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.set_object_sequence_rotation(1, 0.0, -1.49, 0.0)
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.delay_object_sequence_motion_track(0, 25)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_mouth_texture_animations(1, "大口パク")
		message.show_voiced(4040220)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-185.55, 23.34, 29.31)
		event.set_camera_sequence_look_at(-131.23, 20.46, 21.37)
		event.set_object_sequence_position(1, -153.02, 0.0, 18.36)
		event.set_object_sequence_motion(1, "握りこぶし", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040230)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.play_sound_effect(sound_bank, 11)
		event.rotate_object_sequence(1, 0.0, 0.91, 0.0, 20)
		event.set_object_sequence_motion(1, "回転（左）", 2)
		event.queue_object_sequence_next_motion(1, "回転後立ち", 4)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.81, 0.0, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "びっくり", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040240)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040245)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "おどろき目～通常目")
		event.set_object_sequence_motion(0, "いいじゃん", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4040250)
		object.wait_until_done(0)
		event.set_character_active(0, 34)
		event.set_camera_sequence_position(-210.65, 82.36, 112.85)
		event.set_camera_sequence_look_at(-94.39, 22.4, 15.46)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "あきれ目パチ")
		event.move_object_sequence(0, -112.13, 0.0, 23.7, 20)
		event.rotate_object_sequence(0, 0.0, 1.83, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "なでる", 6)
		event.queue_object_sequence_next_motion(0, "なでるL", 4)
		object.wait_until_done(0)
		message.show_voiced(4040260)
		event.set_camera_sequence_position(-66.33, 22.7, 57.65)
		event.set_camera_sequence_look_at(-105.12, 16.7, 28.4)
		event.set_object_sequence_rotation(1, 0.0, 1.51, 0.0)
		event.set_object_sequence_motion(1, "立ち戻り（・・・）", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		message.show_voiced(4040270)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ～目あき")
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 13)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "あきれ目～おどろき目")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_motion(0, "起きる", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "びっくり上見", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(3, "起きる", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		wait.for_frame_count(60)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(93.23, 30.28, 173.24)
		event.set_camera_sequence_look_at(7.23, 52.48, 83.14)
		event.set_object_sequence_rotation(3, 0.0, -1.08, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040280)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目あき～目とじ")
		event.set_object_sequence_motion(3, "パオオオオ", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		message.show_voiced(4040290)
		object.wait_until_done(3)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(3, 20)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040300)
		event.play_music(0)
		event.set_mouth_texture_animations(0, "大口パク")
		message.show_voiced(4040310)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040320)
		event.set_object_sequence_motion(0, "ためらう", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		message.show_voiced(4040330)
		object.wait_until_done(0)
		event.move_object_sequence(0, -50.3, 0.0, 26.14, 30)
		event.delay_object_sequence_rotation_track(0, 20)
		event.rotate_object_sequence(0, 0.0, 2.11, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "しがみつく", 6)
		event.queue_object_sequence_next_motion(0, "しがみつくL", 4)
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(0, "振り払う", 6)
		event.set_object_sequence_motion(3, "振り払う", 6)
		event.set_mouth_texture_animations(0, "大口パク")
		message.show_voiced_for_stopping(4040340, 30)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-81.4, 21.66, 80.81)
		event.set_camera_sequence_look_at(-53.09, 13.59, 123.36)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目～目とじ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.move_object_sequence(3, 0.0, -800.0, 0.0, 120)
		event.set_object_sequence_motion(3, "歩き")
		event.set_object_sequence_position(0, -45.02, 0.0, 121.64)
		event.set_object_sequence_rotation(0, 0.0, -2.85, 0.0)
		event.set_object_sequence_motion(0, "しりもち", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "しりもちL", 4)
		event.set_object_sequence_position(1, -86.22, 0.0, 101.62)
		event.set_object_sequence_rotation(1, 0.0, 0.67, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		wait.for_frame_count(10)
		event.play_sound_effect(sound_bank, 16)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "目とじ～片目あき")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり")
		event.move_object_sequence(1, -63.01, 0.0, 124.25, 20)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_rotation_track(1, 10)
		event.rotate_object_sequence(1, 0.0, 2.83, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 1)
		event.set_object_sequence_motion(1, "ユリス見る")
		object.wait_until_done(1)
		wait.for_frame_count(30)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "片目あき～目あき")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり～大口")
		event.set_object_sequence_motion(0, "前見る", 2)
		event.queue_object_sequence_next_motion(0, "前見るL", 2)
		event.set_object_sequence_motion(1, "シグー見る", 2)
		event.queue_object_sequence_next_motion(1, "シグー見るＬ", 2)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(44.06, 30.05, 157.66)
		event.set_camera_sequence_look_at(-53.09, 28.02, 123.36)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_rotation(0, 0.0, -2.01, 0.0)
		event.move_object_sequence(0, -232.35, 0.0, 34.83, 60, 1)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_position(1, -71.29, 0.0, 134.01)
		event.set_object_sequence_rotation(1, 0.0, -2.01, 0.0)
		event.move_object_sequence(1, -262.99, 0.0, 49.48, 60, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(73)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 5)
	event.stop_sound_effect(sound_bank, 6)
	event.stop_sound_effect(sound_bank, 8)
	event.stop_sound_effect(sound_bank, 10)
	event.stop_sound_effect(sound_bank, 13)
	event.stop_sound_effect(sound_bank, 15)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
	event.skip_next_music_load()
end

--- Plays the e408 cutscene in which Pau sulks and the player character approaches.
local function play_event_e408()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(408, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_music(54)
		event.play_music(0)
		event.load_map_sounds(4209)
		sound_bank = event.load_sound_effect_file_2(4209) or sound_bank
		event.set_character_active(0, 8)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e408/")
		event.load_message_file(0, 5, "e408.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e408_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e408_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e408_paw.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e408/e408_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e408/e408_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -15.9, 0.0, 2.41)
		event.set_object_handle_rotation(0, 0.0, 1.44, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -11.75, 0.0, -11.61)
		event.set_object_handle_rotation(1, 0.0, 1.08, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 15.15, 0.0, 0.51)
		event.set_object_handle_rotation(2, 0.0, -1.8, 0.0)
		event.set_object_handle_motion(2, "しょんぼり", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "かなし目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-261.18, 72.86, 131.99)
		event.set_camera_sequence_look_at(-100.43, 40.84, 35.68)
		event.move_camera_sequence(-222.42, 66.31, 108.77, -100.43, 40.84, 35.68, 90)
		event.fade_in_screen(30)
		camera.wait_until_done()
		event.set_camera_sequence_position(-55.5, 41.28, 39.65)
		event.set_camera_sequence_look_at(5.52, 12.59, -4.27)
		event.open_voice_stream_wave(1, 4080240)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		wait.for_frame_count(30)
		event.open_message_window_2(0, 4080240)
		message.open(0, -1, 8, 0, 0)
		message.wait_voice_or_button(0)
		message.close(0)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4080250)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4080260)
		event.set_camera_sequence_position(34.42, 9.92, 24.38)
		event.set_camera_sequence_look_at(-7.37, 18.5, -12.86)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向く会話", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "顔を上げる", 6)
		event.queue_object_sequence_next_motion(2, "顔を上げるL", 4)
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "かなし目～通常目")
		event.delay_object_sequence_sound_track(2, 60)
		event.play_object_sequence_sound(2, sound_bank, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4080270)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4080280)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4080285)
		object.wait_until_done(1)
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おこり目")
		event.set_object_sequence_motion(0, "パウを見る", 6)
		event.queue_object_sequence_next_motion(0, "パウを見るL", 4)
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "右からパウ見", 6)
		event.queue_object_sequence_next_motion(1, "パウ見Ｌ", 4)
		object.wait_until_done(1)
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(18)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(1, 8)
	character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, -1.0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Plays the e420 cutscene in which the player character talks with Pau and Shigu.
local function play_event_e420()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(420, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.load_music(53)
		event.play_music(0)
		event.load_map_sounds(4211)
		sound_bank = event.load_sound_effect_file_2(4211) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e420/")
		event.load_message_file(0, 5, "e420.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e420_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e420_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e420_paw.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e420_shigu.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e420/e420_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e420/e420_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -116.04, 0.0, -10.24)
		event.set_object_handle_rotation(0, 0.0, 0.84, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -131.38, 0.0, 7.25)
		event.set_object_handle_rotation(1, 0.0, 0.96, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -86.0, 0.0, 34.0)
		event.set_object_handle_rotation(2, 0.0, 2.52, 0.0)
		event.set_object_handle_motion(2, "座り", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_position(3, -86.0, 0.0, 34.0)
		event.set_object_handle_rotation(3, 0.0, 2.52, 0.0)
		event.set_object_handle_motion(3, "座り", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-120.02, 80.62, 153.65)
		event.set_camera_sequence_look_at(-59.44, 15.61, -10.27)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		message.show_voiced(4200110)
		message.show_voiced(4200120)
		event.set_camera_sequence_position(-131.31, 16.23, 18.94)
		event.set_camera_sequence_look_at(-76.17, 12.03, 25.35)
		event.set_object_sequence_motion(2, "座り会話", 6)
		event.queue_object_sequence_next_motion(2, "座り", 4)
		message.show_voiced(4200130)
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "通常目～うれし目とじ")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～通常目")
		event.set_object_sequence_motion(2, "スリスリ", 2)
		event.queue_object_sequence_next_motion(2, "スリスリL", 4)
		event.set_object_sequence_motion(3, "スリスリ", 2)
		event.queue_object_sequence_next_motion(3, "スリスリL", 4)
		wait.for_frame_count(10)
		event.play_sound_effect(sound_bank, 7)
		message.show_voiced(4200140)
		message.show_voiced(4200150)
		event.set_camera_sequence_position(-194.43, 53.46, 8.35)
		event.set_camera_sequence_look_at(-82.97, 2.39, 18.9)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(2, -93.68, 0.0, 36.61)
		event.set_object_sequence_rotation(2, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(3, "座り", 4)
		message.show_voiced(4200160)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(4200165)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "右見る", 2)
		event.queue_object_sequence_next_motion(2, "右見る会話", 6)
		event.queue_object_sequence_next_motion(2, "右見るL", 4)
		message.show_voiced(4200170)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "右向く", 4)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 4)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.open_voice_stream_wave(1, 4200175)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.play_sound_effect(sound_bank, 8)
		object.wait_until_done(0)
		wait.for_frame_count(40)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(0, "右向く戻り", 4)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "左向く戻り", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4200180)
		event.set_camera_sequence_position(-119.73, 14.12, 38.72)
		event.set_camera_sequence_look_at(-127.05, 22.94, -8.58)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_motion(1, "考え", 6)
		event.queue_object_sequence_next_motion(1, "考え会話", 6)
		event.queue_object_sequence_next_motion(1, "考えＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4200190)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "こまり目～通常目")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4200200)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4200210)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_sequence_motion(1, "え？", 6)
		event.queue_object_sequence_next_motion(1, "え？Ｌ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4200220)
		wait.for_frame_count(60)
		event.set_object_sequence_motion(1, "左立ちへもどる", 2)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		wait.for_frame_count(10)
		event.play_sound_effect(sound_bank, 10)
		event.open_voice_stream_wave(1, 4200225)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		object.wait_until_done(1)
		wait.for_frame_count(10)
		event.close_voice_stream(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "おどろき目～通常目")
		event.set_mouth_texture_animations(1, "大口パク")
		message.show_voiced(4200230)
		event.set_object_sequence_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4200240)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4200250)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(35)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
	event.stop_music(0)
	wait.for_frame_count(6)
	event.load_music(46)
	event.play_music(0)
	event.set_character_active(1, 8)
	event.set_character_active(1, 9)
	character.place_standing_and_reset_cloth(-109.0, 0.0, 109.0, vm.f32(2.11))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Plays the e438 cutscene in which Pau's wound is treated and the party rushes off.
local function play_event_e438()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(438, 1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(6)
		event.load_music(112)
		event.load_map_sounds(4216)
		sound_bank = event.load_sound_effect_file_2(4216) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e438/")
		event.load_message_file(0, 5, "e438.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e438_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e438_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_villager_ai_enabled(0, 8)
		event.attach_object_handle_to_character(2, 8)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_character(3, 9)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e438_cure.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(4, 34)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e438/e438_mints.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e438/e438_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -51.17, 0.0, -2.68)
		event.set_object_handle_rotation(0, 0.0, 3.13, 0.0)
		event.set_object_handle_footstep_sound(0, 7)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -63.55, 0.0, 89.25)
		event.set_object_handle_rotation(1, 0.0, -3.12, 0.0)
		event.set_object_handle_footstep_sound(1, 7)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -73.43, 0.0, 66.05)
		event.set_object_handle_rotation(2, 0.0, 2.88, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "あわて目パチ")
		event.set_object_handle_position(3, -86.0, 0.0, 34.0)
		event.set_object_handle_rotation(3, 0.0, 2.52, 0.0)
		event.set_object_handle_motion(3, "座り", 4)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ")
		event.set_object_handle_position(4, -48.75, 20.72, -15.49)
		event.set_object_sequence_motion(0, "薬を塗る", 6)
		event.queue_object_sequence_next_motion(0, "薬を塗るL", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-162.93, 50.23, 154.35)
		event.set_camera_sequence_look_at(-36.65, 17.56, -12.64)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 7)
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 8)
		event.set_character_active(1, 34)
		event.set_object_sequence_motion(4, "出現", 6)
		event.queue_object_sequence_next_motion(4, "ループ", 4)
		event.move_camera_sequence_eased(-136.07, 41.62, 98.05, -36.65, 17.56, -12.64, 60, 0, 0.4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "わらい目とじ")
		event.set_object_sequence_motion(3, "鳴く", 4)
		event.queue_object_sequence_next_motion(3, "座り", 4)
		message.show_voiced(4380020)
		object.wait_until_done(3)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-64.04, 30.26, 9.08)
		event.set_camera_sequence_look_at(-47.99, 19.58, -16.84)
		event.set_object_sequence_position(4, -49.84, 20.72, -13.74)
		event.set_object_handle_frame_visible(3, "grid1", 0)
		if active_character == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 32)
			event.set_character_active(0, 33)
		end
		wait.for_frame_count(60)
		event.set_object_sequence_motion(4, "消える", 6)
		wait.for_frame_count(20)
		event.stop_sound_effect(sound_bank, 8)
		wait.for_frame_count(40)
		if active_character == 0 then
			event.set_character_active(1, 0)
		else
			event.set_character_active(1, 32)
			event.set_character_active(1, 33)
		end
		event.set_camera_sequence_position(-62.85, 23.89, 64.39)
		event.set_camera_sequence_look_at(-63.43, 23.48, 86.03)
		event.play_music(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おどろき顔")
		event.set_object_handle_texture_animation(1, 1, "おどろき目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4380030)
		event.set_camera_sequence_position(-90.28, 17.88, 54.16)
		event.set_camera_sequence_look_at(-71.61, 19.12, 65.19)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "うれし目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(4380040)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-107.58, 67.74, 136.37)
		event.set_camera_sequence_look_at(-73.62, 19.12, 33.49)
		event.move_camera_sequence_eased(-123.84, 19.13, 19.64, -79.06, 15.3, 28.29, 30, 0, 1.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.rotate_object_sequence(0, 0.0, -0.15, 0.0, 14)
		event.move_object_sequence(0, -65.4, 0.0, 88.33, 80)
		event.delay_object_sequence_rotation_track(0, 66)
		event.set_object_sequence_position(0, -49.79, 0.0, 85.06)
		event.set_object_sequence_rotation(0, 0.0, -2.79, 0.0)
		event.move_object_sequence(2, -86.0, 0.0, 34.0, 30)
		event.rotate_object_sequence(2, 0.0, -2.92, 0.0, 10)
		event.delay_object_sequence_rotation_track(2, 10)
		event.rotate_object_sequence(2, 0.0, 2.52, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "立ち")
		event.delay_object_sequence_motion_track(2, 4)
		event.set_object_sequence_motion(2, "シグーをさわる", 6)
		event.queue_object_sequence_next_motion(2, "シグーをなでる", 6)
		event.queue_object_sequence_next_motion(2, "シグーをさわるL", 4)
		message.show_voiced(4380050)
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目あき～片目とじ")
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_motion(2, "じゃれる", 2)
		event.queue_object_sequence_next_motion(2, "じゃれるL", 4)
		event.set_object_sequence_motion(3, "じゃれる", 2)
		event.queue_object_sequence_next_motion(3, "じゃれるL", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(3, 20)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		message.show_voiced(4380060)
		event.set_camera_sequence_position(-89.72, 19.18, 86.36)
		event.set_camera_sequence_look_at(-80.87, 15.3, 34.37)
		event.move_camera_sequence_eased(-72.81, 19.18, 144.4, -66.72, 15.3, 40.94, 60, 0, 0.5)
		camera.wait_until_done()
		event.set_camera_sequence_position(-79.35, 19.18, 53.22)
		event.set_camera_sequence_look_at(-57.33, 20.23, 86.81)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4380070)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4380080)
		wait.for_frame_count(30)
		event.stop_music(0)
		event.play_sound_effect(sound_bank, 10)
		wait.for_frame_count(30)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目～おこり目")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_handle_texture_animation(1, 1, "半口")
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-123.84, 19.13, 19.64)
		event.set_camera_sequence_look_at(-79.06, 15.3, 28.29)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "うれし目～おこり目")
		event.set_object_sequence_motion(2, "はっとする", 2)
		event.queue_object_sequence_next_motion(2, "はっとするL", 4)
		event.set_object_sequence_motion(3, "はっとする", 2)
		event.queue_object_sequence_next_motion(3, "はっとするL", 4)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-79.35, 19.18, 53.22)
		event.set_camera_sequence_look_at(-57.33, 20.23, 86.81)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4380090)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -108.19, 0.0, 75.73, 30)
		event.rotate_object_sequence(1, 0.0, -1.92, 0.0, 6)
		wait.for_frame_count(6)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -89.43, 0.0, 73.06, 24)
		event.rotate_object_sequence(0, 0.0, -1.71, 0.0, 6)
		wait.for_frame_count(24)
		event.set_camera_sequence_position(24.96, 51.45, 87.92)
		event.set_camera_sequence_look_at(-116.0, 29.46, 50.87)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "上見立ち", 4)
		event.delay_object_sequence_motion_track(2, 50)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_rotation_track(2, 50)
		event.rotate_object_sequence(2, 0.0, -1.48, 0.0, 12)
		event.delay_object_sequence_position_track(2, 50)
		event.move_object_sequence(2, -183.33, 0.0, 37.62, 40)
		event.set_object_sequence_position(3, 21.53, 0.0, -13.99)
		event.set_object_sequence_rotation(3, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(3, "顔を上げる", 6)
		event.delay_object_sequence_motion_track(3, 50)
		event.set_object_sequence_motion(3, "歩き")
		event.delay_object_sequence_rotation_track(3, 50)
		event.set_object_sequence_rotation(3, 0.0, -1.32, 0.0)
		event.delay_object_sequence_position_track(3, 50)
		event.move_object_sequence(3, -27.85, 0.0, 21.64, 40)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 100)
		event.add_object_sequence_path_point(1, -108.19, 0.0, 75.73)
		event.add_object_sequence_path_point(1, -152.8, 0.0, 62.23)
		event.add_object_sequence_path_point(1, -204.59, 8.8, 46.55)
		event.add_object_sequence_path_point(1, -233.95, 20.61, 35.0)
		event.add_object_sequence_path_point(1, -305.97, 20.61, 4.38)
		event.add_object_sequence_path_point(1, -350.45, 20.61, -24.72)
		event.add_object_sequence_path_point(1, -400.08, 20.61, -64.41)
		event.add_object_sequence_path_point(1, -452.24, 20.61, -109.52)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 100)
		event.add_object_sequence_path_point(0, -89.43, 0.0, 73.06)
		event.add_object_sequence_path_point(0, -138.01, 0.0, 58.83)
		event.add_object_sequence_path_point(0, -190.53, 2.6, 44.18)
		event.add_object_sequence_path_point(0, -208.9, 14.09, 37.83)
		event.add_object_sequence_path_point(0, -234.07, 20.61, 27.92)
		event.add_object_sequence_path_point(0, -279.46, 20.61, 9.52)
		event.add_object_sequence_path_point(0, -326.34, 20.61, -17.08)
		event.add_object_sequence_path_point(0, -376.13, 20.61, -47.33)
		event.add_object_sequence_path_point(0, -423.31, 20.61, -86.85)
		event.start_object_sequence_path(0)
		wait.for_frame_count(8)
		event.set_object_handle_footstep_sound(1, 16)
		wait.for_frame_count(4)
		event.set_object_handle_footstep_sound(0, 16)
		wait.for_frame_count(47)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(32)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(sound_bank, 8)
	event.stop_sound_effect(sound_bank, 10)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_motion(2, "立ち", 4)
	event.set_object_handle_motion(3, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
end

--- Asks a yes-or-no question and either runs out of the house with a fade-out or walks the character a few steps ahead.
local function ask_to_leave_house()
	local answer: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『ベニーティオ』に移動しますか？")
		checkpoint = 1
		answer = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.start_crossfade(10)
			event.set_camera_sequence_position(-165.74, 34.03, 218.78)
			event.set_camera_sequence_look_at(-253.92, 30.71, 96.73)
			event.set_object_sequence_position(0, -268.17, 20.61, 70.01)
			event.set_object_sequence_rotation(0, 0.0, -2.51, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.move_object_sequence(0, -403.16, 20.61, -110.47, 50)
			checkpoint = 2
			wait.for_frame_count(30)
			event.fade_out_screen(20)
			checkpoint = 3
			wait.for_frame_count(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(1.33)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(1.33)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			frame = 0
			while frame < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				frame = frame + 1
				checkpoint = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint == 1 then
				answer = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.skip_frame_count(30)
			end
			if checkpoint <= 2 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if checkpoint <= 4 then
			return 0
		end
		return nil
	end)
end

--- Turns the player character and a partner toward each other and runs their conversation line.
local function face_character_and_talk(partner: s32, talk_style: s32)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local partner_x: f32 = 0
	local partner_y: f32 = 0
	local partner_z: f32 = 0
	local player_yaw: f32 = 0
	local partner_yaw: f32 = 0
	local player_target_yaw: f32 = 0
	local partner_target_yaw: f32 = 0
	local needs_turn: s32 = 0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, partner)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(partner)
		partner_x = out1 or partner_x
		partner_y = out2 or partner_y
		partner_z = out3 or partner_z
	end
	do
		local _, out2, _ = event.get_character_rotation(partner)
		partner_yaw = out2 or partner_yaw
	end
	player_target_yaw = event.get_direction_angle(player_x, player_y, player_z, partner_x, partner_y, partner_z) or player_target_yaw
	partner_target_yaw = event.get_direction_angle(partner_x, partner_y, partner_z, player_x, player_y, player_z) or partner_target_yaw
	needs_turn = event.compare_angles(player_yaw, player_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(0, 0.0, player_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	needs_turn = event.compare_angles(partner_yaw, partner_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, partner_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.for_frame_count(20)
	if talk_style == 0 then
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
	end
	if talk_style == 1 then
		event.set_mouth_motions(1, "慌て会話", 0, "立ち", 0)
	end
	message.say_bubble(0, -1, partner, 0, 0)
	needs_turn = event.compare_angles(partner_yaw, partner_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, partner_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.for_frame_count(11)
end

--- Speaks Pau's line about Shingala for the current quest progress.
local function talk_about_shingala(partner_slot: s32)
	local flag_444: s32 = 0
	local talk_style: s32 = 0
	local flag_420: s32 = 0
	local flag_438: s32 = 0
	local medicine_count: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	flag_444 = event.get_save_flag(444) or flag_444
	if flag_444 == 0 then
		talk_style = 0
		flag_420 = event.get_save_flag(420) or flag_420
		if flag_420 == 0 then
			event.open_message_window_2(
				0,
				"その「ルナ研」の人に、シグーの\n頭についてた装置のこと聞いてくれないか？"
			)
		else
			flag_438 = event.get_save_flag(438) or flag_438
			if flag_438 == 0 then
				medicine_count = event.get_owned_item_count(375) or medicine_count
				if medicine_count >= 1 then
					event.open_message_window_2(0, "早く、そのクスリをシグーに！")
					talk_style = 1
				else
					event.open_message_window_2(
						0,
						"他のシーグラたちのいる浜辺まで行って、\nシグーに効くクスリを取ってきて欲しいんだ。"
					)
				end
			else
				event.open_message_window_2(0, "頼む。\nシーグラたちの村を救ってくれ。")
			end
		end
		face_character_and_talk(partner_slot, talk_style)
	else
		event.open_message_window_2(
			0,
			"シグーがいなくなって寂しいけど\n来年、成長したシグーに会うのが楽しみなんだ。"
		)
		face_character_and_talk(partner_slot, 0)
	end
end

--- Speaks Pau's quest line when the triggering NPC is Pau.
local function talk_to_pau_during_shingala_quest()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	event.initialize_event()
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	if npc_id == 9 then
		talk_about_shingala(character_slot)
	end
end

--- Plays Pau's first conversation in which he asks for a carrot before joining.
local function ask_for_carrot()
	local character_slot: s32 = 0
	local player_character_slot: s32 = 0
	event.apply_message_window_preset(0, 0)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	cutscene.begin_talk(character_slot, 0, 0)
	player_character_slot = event.get_player_character_slot() or player_character_slot
	event.open_message_window_2(
		0,
		"なんだ、おまえらか。\nシグーの時には世話になったな。\nで、何の用だい？"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "はぁ？いっしょに\nついて来いって？")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"ダメだ、ダメダメ。<page>オレはここでシグーを\n待ってなきゃなんないからな。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "でも、まぁ、\nシーグラ達が戻ってくるのは\n早くて半年後か・・・")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "それまでにカタがつくってんなら、\n付き合ってやっても良いぜ。")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "ここに居てもしようがないし、\nまぁ、ヒマつぶしかな。")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "そうだ！おい、\n人間のおまえたちなら\n知ってるよな？")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "あのスッゲーうまい食い物、\nありゃなんなんだ？")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"なんだよ、とぼけんなよ。\n大きさは魚くらいでさ、\n赤いんだ。<page>とにかく赤くて、\nべらぼうにうまいんだ。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "アレをもう一度\n食わせてくれよ。\nな、たのむぜ。")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]パウって、耳が長くて前歯が大きくて、\n   ある動物にそっくりですよね。\n   その動物が好きな赤い食べ物と言えば・・・"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 5, 1)
end

--- Lets the player hand over a carrot and recruits Pau into the party.
local function give_carrot_to_pau()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	local player_character_slot: s32 = 0
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	player_character_slot = event.get_player_character_slot() or player_character_slot
	event.open_message_window_2(0, "おっ、持って来て\nくれたのかい？\nあの赤い食べ物・・・")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_use_item_menu(315)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	if item ~= 315 then
		event.open_message_window_2(0, "おい、ふざけてんのか。\nこんなんじゃねぇよ！")
		message.say_bubble(0, -1, character_slot, player_character_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"あぁ・・・\nこ、これだぁ！<page>この赤さ、この匂い、\nこの歯ざわり・・・"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"人間と付き合うってのも、\n悪い事ばっかりじゃねえな。<page>よし、約束だ。\nいっしょに行ってやる。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"実はな、世界がヤバい事に\nなってるってのは、ちょっと\n前から勘付いていたんだ。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"グリフォンって奴が\n良からぬ事をしてるってのも、\nシグーの時に分かった。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "奴をなんとかしようってんだろう。\nなら、喜んで協力するぜ。")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"言っとくけど、ニンジンもらったから\n言う事聞いてるわけじゃないからな！\nそこんとこをまちがえるなよ。"
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.set_npc_party_status(npc_id, 130)
	party.announce_member_joined(npc_id)
	event.finish_event()
	event.set_quest_request(1, 5, 1)
end

--- Plays Pau's idle line once the carrot request is finished.
local function talk_to_pau_after_joining()
	local character_slot: s32 = 0
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"なぁ、またニンジンが\n手に入ったら、オレに\nくれよな。たのんだぜ。"
		)
	else
		event.open_message_window_2(0, "よっ！元気か。オレも元気だぜ。")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Picks Pau's conversation from the carrot request status.
local function talk_to_pau_by_request_status()
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 5) or request_status
	if request_status == 0 then
		ask_for_carrot()
		return
	end
	if request_status == 1 then
		give_carrot_to_pau()
		return
	end
	if request_status == 2 then
		talk_to_pau_after_joining()
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.place_residents = place_residents
script[99] = script.place_residents

--- Plays the arrival scene that matches the previous map and saved flags.
function script.default_event()
	local previous_map_number: s32 = 0
	local flag_404: s32 = 0
	local flag_408: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		place_residents()
		previous_map_number = event.get_previous_map() or previous_map_number
		if previous_map_number == 2 then
			flag_404 = event.get_save_flag(404) or flag_404
			if flag_404 == 0 then
				resume_step = 1
				play_event_e404()
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g03", 500)
			else
				resume_step = 2
				paus_house.walk_player_in()
			end
		elseif previous_map_number == 84 then
			flag_408 = event.get_save_flag(408) or flag_408
			if flag_408 == 0 then
				resume_step = 3
				play_event_e408()
			else
				resume_step = 4
				play_event_e420()
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				paus_house.advance_look_height_frame()
			end
			if resume_step <= 2 then
				resume_step = 3
				play_event_e408()
				return vm.continue_with(function()
					return
				end)
			end
			if resume_step <= 3 then
				resume_step = 4
				play_event_e420()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_event_e438

--- Asks whether to leave the house and jumps to g03.
function script.leave_house()
	if ask_to_leave_house() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end
script[201] = script.leave_house

--- Lets the player use the medicine on the injured Shingala or hears it call out.
function script.talk_to_shingala()
	local medicine_count: s32 = 0
	local menu_stage: s32 = 0
	local item: s32 = 0
	local confirmed: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_yaw: f32 = 0
	local yaw: f32 = 0
	local angle_check: s32 = 0
	local flag_438: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		medicine_count = event.get_owned_item_count(375) or medicine_count
		if medicine_count >= 1 then
			event.set_character_motion(0, "立ち")
			menu_stage = event.get_triggered_event_data_2(6) or menu_stage
			if menu_stage == 1 then
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(
					0,
					"傷を負ったシグーが苦しんでいる。\n（(#)ボタンでメニューを開く）"
				)
				resume_step = 1
				confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
				if confirmed == 1 then
					menu_stage = 2
				end
			end
			if menu_stage == 2 then
				event.open_use_item_menu(375)
				resume_step = 2
				vm.wait(2)
				item = vmhost.used_item() or item
				if item > 0 then
					if item == 375 then
						resume_step = 3
						play_event_e438()
						event.jump_to_map_3(-1, "s40", 500)
						resume_step = 4
						vm.wait(4)
						return
					else
						resume_step = 5
						character.shake_head()
					end
				end
			end
		else
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			do
				local _, out2, _ = event.get_character_rotation(0)
				player_yaw = out2 or player_yaw
			end
			yaw = event.get_direction_angle(player_x, player_y, player_z, -76.0, 0.0, 23.0) or yaw
			angle_check = event.compare_angles(player_yaw, yaw, 0.1) or angle_check
			if angle_check ~= 0 then
				event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
				event.set_object_sequence_motion(0, "歩き")
				event.delay_object_sequence_motion_track(0, 10)
			end
			event.set_object_sequence_motion(0, "立ち")
			resume_step = 6
			wait.for_frame_count(20)
			event.set_message_window_mode(0, 1)
			event.set_mouth_motions(1, "鳴く", 0, "座り", 0)
			flag_438 = event.get_save_flag(438) or flag_438
			if flag_438 == 0 then
				event.open_message_window_2(0, "ピィイイイ！")
			else
				event.open_message_window_2(0, "パオオオー！")
			end
			resume_step = 7
			message.say_bubble(0, -1, 9, 0, 0)
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				confirmed = received[2] :: number
			end
			if resume_step <= 1 then
				local _ = menu_stage == 1
				menu_stage = 2
			end
			if resume_step <= 2 then
				resume_step = 3
				play_event_e438()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s40", 500)
					resume_step = 4
					vm.wait(4)
					return
				end)
			end
			return 0
		end
		if resume_step <= 7 then
			if resume_step <= 5 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 6 then
				message.show_then_close_variant(0, -1, 9, 0, 0)
			end
			return 0
		end
		return nil
	end)
end
script[400] = script.talk_to_shingala

--- Places the residents and plays the cutscene in which Pau sulks.
function script.cutscene_pau_sulks()
	place_residents()
	play_event_e408()
end
script[500] = script.cutscene_pau_sulks

--- Runs the villager conversation matching the saved flags.
function script.talk_to_villager()
	local flag_500: s32 = 0
	local character_slot: s32 = 0
	flag_500 = event.get_save_flag(500) or flag_500
	if flag_500 == 0 then
		talk_to_pau_during_shingala_quest()
	else
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, character_slot)
		talk_to_pau_by_request_status()
		event.set_villager_ai_enabled(1, character_slot)
	end
end
script[1000] = script.talk_to_villager

--- Resets the Pau flags and replays the arrival with a jump to g03.
function script.restart_from_arrival()
	event.set_save_flag(408, 0)
	event.set_save_flag(420, 0)
	event.set_save_flag(444, 0)
	place_residents()
	play_event_e404()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g03", 500)
end
script[14040] = script.restart_from_arrival

--- Sets the Pau flags and replays the Shingala cure with a jump to s40.
function script.restart_from_medicine_cure()
	event.set_save_flag(408, 1)
	event.set_save_flag(420, 1)
	event.set_save_flag(444, 0)
	place_residents()
	play_event_e438()
	event.jump_to_map_3(-1, "s40", 500)
	vm.wait(2)
end
script[14380] = script.restart_from_medicine_cure

return script
