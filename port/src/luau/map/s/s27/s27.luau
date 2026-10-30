--!strict
-- map/s/s27/s27.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_024677a1 = require("@lib/event/helper_024677a1")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_31bb617a = require("@lib/event/helper_31bb617a")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5ac4b36d = require("@lib/event/helper_5ac4b36d")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_790d496b = require("@lib/event/helper_790d496b")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_dfed0a42 = require("@lib/event/helper_dfed0a42")
local open_message = require("@lib/event/open_message")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	helper_31bb617a()
end

--- Helper function.
local function helper_156a0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(404, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(30)
		var0 = event.load_sound_effect_file_2(4206) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e404/")
		event.load_message_file(0, 5, "e404.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e404_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		if active_chr_no == 1 then
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
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_position(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(3, "座り", 4)
		event.set_object_handle_sound_bank(3, var0)
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
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(1, 7)
		helper_4116e6bb(4040010)
		wait_objects(0)
		wait_objects(1)
		event.set_camera_sequence_position(-329.01, 58.36, 79.54)
		event.set_camera_sequence_look_at(-219.96, 42.3, 48.35)
		event.set_object_sequence_motion(2, "だめだよ", 4)
		event.set_object_sequence_motion(3, "だめだよ", 4)
		helper_4116e6bb(4040020)
		event.queue_object_sequence_next_motion(2, "だめだよ戻り", 6)
		event.queue_object_sequence_next_motion(2, "左見るL", 4)
		event.queue_object_sequence_next_motion(3, "だめだよ戻り", 6)
		event.queue_object_sequence_next_motion(3, "座り", 6)
		event.delay_object_sequence_sound_track(3, 50)
		event.play_object_sequence_sound(3, var0, 5)
		helper_4116e6bb(4040030)
		wait_objects(2)
		wait_objects(3)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～通常目")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ")
		wait_objects(2)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		helper_4116e6bb(4040040)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		helper_4116e6bb(4040045)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040050)
		wait_objects(1)
		event.set_camera_sequence_position(-62.1, 19.31, -10.25)
		event.set_camera_sequence_look_at(-54.35, 19.0, 10.63)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		helper_4116e6bb(4040060)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		helper_4116e6bb(4040065)
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
		helper_4116e6bb(4040070)
		helper_4116e6bb(4040080)
		helper_4116e6bb(4040090)
		event.set_camera_sequence_position(-73.88, 22.38, 10.51)
		event.set_camera_sequence_look_at(-51.05, 17.89, 9.61)
		event.set_object_sequence_motion(2, "左見る", 6)
		event.queue_object_sequence_next_motion(2, "左見るL", 4)
		vm.wait(20)
		event.stop_sound_effect(var0, 6)
		event.play_sound_effect(var0, 7)
		wait_objects(2)
		event.set_mouth_motions(2, "左見る会話", 0, "左見るL", 0)
		helper_4116e6bb(4040100)
		event.set_camera_sequence_position(-99.1, 24.86, 20.27)
		event.set_camera_sequence_look_at(-131.88, 21.69, 23.96)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4040110)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4040120)
		event.set_camera_sequence_position(-220.74, 65.68, 88.82)
		event.set_camera_sequence_look_at(-108.87, 28.0, 27.84)
		event.set_object_sequence_motion(2, "手当て", 4)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040130)
		wait_objects(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目～おこり目")
		helper_4116e6bb(4040140)
		event.set_camera_sequence_position(-85.39, 16.63, -5.51)
		event.set_camera_sequence_look_at(-55.98, 16.38, 14.8)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_position(2, -62.67, 0.0, 11.85)
		event.set_object_sequence_rotation(2, 0.0, -0.6, 0.0)
		event.set_object_sequence_motion(2, "だめだ", 4)
		vm.wait(28)
		event.stop_sound_effect(var0, 6)
		helper_4116e6bb(4040150)
		event.wait_object_sequence_motion_end(2)
		wait_objects(2)
		event.set_object_sequence_motion(2, "投げる", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, var0, 8)
		helper_0382f327(4040155, 30)
		event.set_camera_sequence_position(-214.38, 6.96, 210.05)
		event.set_camera_sequence_look_at(-61.08, 16.38, 10.57)
		event.detach_character_from_frame(36)
		event.set_object_sequence_position(4, -109.71, 0.0, 72.24)
		event.set_object_sequence_rotation(4, 0.0, -2.24, 0.0)
		event.move_object_sequence_eased(4, -190.78, 0.0, 177.73, 60, 2, 1.0)
		event.set_object_sequence_motion(4, "投げる", 6)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 9)
		helper_888ab2a3(60)
		event.move_camera_sequence_eased(-214.38, 6.96, 210.05, 19.36, 16.38, 100.01, 60, 0, 1.0)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "ごそごそ", 2)
		event.queue_object_sequence_next_motion(2, "ごそごそL", 4)
		event.delay_object_sequence_sound_track(2, 90)
		event.play_object_sequence_sound(2, var0, 10)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, -62.67, 0.0, 11.85)
		event.add_object_sequence_path_point(2, -88.51, 0.0, 42.69)
		event.add_object_sequence_path_point(2, -96.04, 0.0, 62.71)
		event.add_object_sequence_path_point(2, -79.41, 0.0, 79.32)
		event.add_object_sequence_path_point(2, -29.23, 0.0, 84.34)
		event.add_object_sequence_path_point(2, 97.87, 0.0, 63.75)
		event.start_object_sequence_path(2)
		helper_4116e6bb(4040160)
		helper_4116e6bb(4040170)
		helper_4116e6bb(4040180)
		event.set_camera_sequence_position(-97.12, 17.91, 38.03)
		event.set_camera_sequence_look_at(-126.19, 20.37, 27.25)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040190)
		event.set_camera_sequence_position(-214.38, 6.96, 210.05)
		event.set_camera_sequence_look_at(19.36, 16.38, 100.01)
		event.stop_sound_effect(var0, 10)
		event.set_object_sequence_rotation(2, 0.0, -1.25, 0.0)
		event.set_object_sequence_motion(2, "振り返る", 6)
		helper_4116e6bb(4040200)
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
		helper_0382f327(4040210, 90)
		wait_camera()
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
		helper_4116e6bb(4040220)
		wait_objects(2)
		event.set_camera_sequence_position(-185.55, 23.34, 29.31)
		event.set_camera_sequence_look_at(-131.23, 20.46, 21.37)
		event.set_object_sequence_position(1, -153.02, 0.0, 18.36)
		event.set_object_sequence_motion(1, "握りこぶし", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040230)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.play_sound_effect(var0, 11)
		event.rotate_object_sequence(1, 0.0, 0.91, 0.0, 20)
		event.set_object_sequence_motion(1, "回転（左）", 2)
		event.queue_object_sequence_next_motion(1, "回転後立ち", 4)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.81, 0.0, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "びっくり", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040240)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040245)
		wait_objects(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "おどろき目～通常目")
		event.set_object_sequence_motion(0, "いいじゃん", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4040250)
		wait_objects(0)
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
		wait_objects(0)
		helper_4116e6bb(4040260)
		event.set_camera_sequence_position(-66.33, 22.7, 57.65)
		event.set_camera_sequence_look_at(-105.12, 16.7, 28.4)
		event.set_object_sequence_rotation(1, 0.0, 1.51, 0.0)
		event.set_object_sequence_motion(1, "立ち戻り（・・・）", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		helper_4116e6bb(4040270)
		wait_objects(1)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ～目あき")
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 13)
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
		helper_888ab2a3(60)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(93.23, 30.28, 173.24)
		event.set_camera_sequence_look_at(7.23, 52.48, 83.14)
		event.set_object_sequence_rotation(3, 0.0, -1.08, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040280)
		event.play_sound_effect(var0, 14)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目あき～目とじ")
		event.set_object_sequence_motion(3, "パオオオオ", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		helper_4116e6bb(4040290)
		wait_objects(3)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(3, 20)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040300)
		event.play_music(0)
		event.set_mouth_texture_animations(0, "大口パク")
		helper_4116e6bb(4040310)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040320)
		event.set_object_sequence_motion(0, "ためらう", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		helper_4116e6bb(4040330)
		wait_objects(0)
		event.move_object_sequence(0, -50.3, 0.0, 26.14, 30)
		event.delay_object_sequence_rotation_track(0, 20)
		event.rotate_object_sequence(0, 0.0, 2.11, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "しがみつく", 6)
		event.queue_object_sequence_next_motion(0, "しがみつくL", 4)
		wait_objects(0)
		event.play_sound_effect(var0, 15)
		event.set_object_sequence_motion(0, "振り払う", 6)
		event.set_object_sequence_motion(3, "振り払う", 6)
		event.set_mouth_texture_animations(0, "大口パク")
		helper_0382f327(4040340, 30)
		wait_objects(0)
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
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 16)
		wait_objects(0)
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
		wait_objects(1)
		helper_888ab2a3(30)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "片目あき～目あき")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり～大口")
		event.set_object_sequence_motion(0, "前見る", 2)
		event.queue_object_sequence_next_motion(0, "前見るL", 2)
		event.set_object_sequence_motion(1, "シグー見る", 2)
		event.queue_object_sequence_next_motion(1, "シグー見るＬ", 2)
		helper_888ab2a3(60)
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
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(73)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 8)
	event.stop_sound_effect(var0, 10)
	event.stop_sound_effect(var0, 13)
	event.stop_sound_effect(var0, 15)
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

--- Helper function.
local function helper_1d1a0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(408, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_music(54)
		event.play_music(0)
		event.load_map_sounds(4209)
		var0 = event.load_sound_effect_file_2(4209) or var0
		event.set_character_active(0, 8)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e408/")
		event.load_message_file(0, 5, "e408.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e408_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		if active_chr_no == 1 then
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
		wait_camera()
		event.set_camera_sequence_position(-55.5, 41.28, 39.65)
		event.set_camera_sequence_look_at(5.52, 12.59, -4.27)
		event.open_voice_stream_wave(1, 4080240)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		helper_888ab2a3(30)
		event.open_message_window_2(0, 4080240)
		open_message(0, -1, 8, 0, 0)
		helper_5ac4b36d(0)
		close_message(0)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4080250)
		wait_objects(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4080260)
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
		event.play_object_sequence_sound(2, var0, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4080270)
		wait_objects(0)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4080280)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4080285)
		wait_objects(1)
		wait_objects(2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おこり目")
		event.set_object_sequence_motion(0, "パウを見る", 6)
		event.queue_object_sequence_next_motion(0, "パウを見るL", 4)
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "右からパウ見", 6)
		event.queue_object_sequence_next_motion(1, "パウ見Ｌ", 4)
		wait_objects(1)
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
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
	helper_9dafbc83(0.0, 0.0, 0.0, -1.0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1f580()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
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
		var0 = event.load_sound_effect_file_2(4211) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e420/")
		event.load_message_file(0, 5, "e420.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e420_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		if active_chr_no == 1 then
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
		helper_888ab2a3(30)
		helper_4116e6bb(4200110)
		helper_4116e6bb(4200120)
		event.set_camera_sequence_position(-131.31, 16.23, 18.94)
		event.set_camera_sequence_look_at(-76.17, 12.03, 25.35)
		event.set_object_sequence_motion(2, "座り会話", 6)
		event.queue_object_sequence_next_motion(2, "座り", 4)
		helper_4116e6bb(4200130)
		wait_objects(2)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "通常目～うれし目とじ")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～通常目")
		event.set_object_sequence_motion(2, "スリスリ", 2)
		event.queue_object_sequence_next_motion(2, "スリスリL", 4)
		event.set_object_sequence_motion(3, "スリスリ", 2)
		event.queue_object_sequence_next_motion(3, "スリスリL", 4)
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 7)
		helper_4116e6bb(4200140)
		helper_4116e6bb(4200150)
		event.set_camera_sequence_position(-194.43, 53.46, 8.35)
		event.set_camera_sequence_look_at(-82.97, 2.39, 18.9)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(2, -93.68, 0.0, 36.61)
		event.set_object_sequence_rotation(2, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(3, "座り", 4)
		helper_4116e6bb(4200160)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(4200165)
		wait_objects(2)
		event.set_object_sequence_motion(2, "右見る", 2)
		event.queue_object_sequence_next_motion(2, "右見る会話", 6)
		event.queue_object_sequence_next_motion(2, "右見るL", 4)
		helper_4116e6bb(4200170)
		wait_objects(2)
		event.set_object_sequence_motion(0, "右向く", 4)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 4)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.open_voice_stream_wave(1, 4200175)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.play_sound_effect(var0, 8)
		wait_objects(0)
		helper_888ab2a3(40)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(0, "右向く戻り", 4)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "左向く戻り", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		wait_objects(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4200180)
		event.set_camera_sequence_position(-119.73, 14.12, 38.72)
		event.set_camera_sequence_look_at(-127.05, 22.94, -8.58)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_motion(1, "考え", 6)
		event.queue_object_sequence_next_motion(1, "考え会話", 6)
		event.queue_object_sequence_next_motion(1, "考えＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4200190)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "こまり目～通常目")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4200200)
		wait_objects(1)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4200210)
		wait_objects(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_sequence_motion(1, "え？", 6)
		event.queue_object_sequence_next_motion(1, "え？Ｌ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4200220)
		helper_888ab2a3(60)
		event.set_object_sequence_motion(1, "左立ちへもどる", 2)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 10)
		event.open_voice_stream_wave(1, 4200225)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		wait_objects(1)
		helper_888ab2a3(10)
		event.close_voice_stream(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "おどろき目～通常目")
		event.set_mouth_texture_animations(1, "大口パク")
		helper_4116e6bb(4200230)
		event.set_object_sequence_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4200240)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4200250)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
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
	helper_888ab2a3(6)
	event.load_music(46)
	event.play_music(0)
	event.set_character_active(1, 8)
	event.set_character_active(1, 9)
	helper_9dafbc83(-109.0, 0.0, 109.0, vm.f32(2.11))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_228e8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(438, 1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(6)
		event.load_music(112)
		event.load_map_sounds(4216)
		var0 = event.load_sound_effect_file_2(4216) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e438/")
		event.load_message_file(0, 5, "e438.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e438_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		if active_chr_no == 1 then
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
		event.set_object_handle_sound_bank(3, var0)
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
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 7)
		wait_objects(0)
		event.play_sound_effect(var0, 8)
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
		helper_4116e6bb(4380020)
		wait_objects(3)
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-64.04, 30.26, 9.08)
		event.set_camera_sequence_look_at(-47.99, 19.58, -16.84)
		event.set_object_sequence_position(4, -49.84, 20.72, -13.74)
		event.set_object_handle_frame_visible(3, "grid1", 0)
		if active_chr_no == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 32)
			event.set_character_active(0, 33)
		end
		helper_888ab2a3(60)
		event.set_object_sequence_motion(4, "消える", 6)
		helper_888ab2a3(20)
		event.stop_sound_effect(var0, 8)
		helper_888ab2a3(40)
		if active_chr_no == 0 then
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
		helper_4116e6bb(4380030)
		event.set_camera_sequence_position(-90.28, 17.88, 54.16)
		event.set_camera_sequence_look_at(-71.61, 19.12, 65.19)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "うれし目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(4380040)
		wait_objects(2)
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
		helper_4116e6bb(4380050)
		wait_objects(2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目あき～片目とじ")
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_motion(2, "じゃれる", 2)
		event.queue_object_sequence_next_motion(2, "じゃれるL", 4)
		event.set_object_sequence_motion(3, "じゃれる", 2)
		event.queue_object_sequence_next_motion(3, "じゃれるL", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(3, 20)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		helper_4116e6bb(4380060)
		event.set_camera_sequence_position(-89.72, 19.18, 86.36)
		event.set_camera_sequence_look_at(-80.87, 15.3, 34.37)
		event.move_camera_sequence_eased(-72.81, 19.18, 144.4, -66.72, 15.3, 40.94, 60, 0, 0.5)
		wait_camera()
		event.set_camera_sequence_position(-79.35, 19.18, 53.22)
		event.set_camera_sequence_look_at(-57.33, 20.23, 86.81)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4380070)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4380080)
		helper_888ab2a3(30)
		event.stop_music(0)
		event.play_sound_effect(var0, 10)
		helper_888ab2a3(30)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目～おこり目")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_handle_texture_animation(1, 1, "半口")
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-123.84, 19.13, 19.64)
		event.set_camera_sequence_look_at(-79.06, 15.3, 28.29)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "うれし目～おこり目")
		event.set_object_sequence_motion(2, "はっとする", 2)
		event.queue_object_sequence_next_motion(2, "はっとするL", 4)
		event.set_object_sequence_motion(3, "はっとする", 2)
		event.queue_object_sequence_next_motion(3, "はっとするL", 4)
		wait_objects(2)
		event.set_camera_sequence_position(-79.35, 19.18, 53.22)
		event.set_camera_sequence_look_at(-57.33, 20.23, 86.81)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4380090)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -108.19, 0.0, 75.73, 30)
		event.rotate_object_sequence(1, 0.0, -1.92, 0.0, 6)
		helper_888ab2a3(6)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -89.43, 0.0, 73.06, 24)
		event.rotate_object_sequence(0, 0.0, -1.71, 0.0, 6)
		helper_888ab2a3(24)
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
		helper_888ab2a3(8)
		event.set_object_handle_footstep_sound(1, 16)
		helper_888ab2a3(4)
		event.set_object_handle_footstep_sound(0, 16)
		helper_888ab2a3(47)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(32)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var0, 8)
	event.stop_sound_effect(var0, 10)
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

--- Helper function.
local function helper_146f0()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『ベニーティオ』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.start_crossfade(10)
			event.set_camera_sequence_position(-165.74, 34.03, 218.78)
			event.set_camera_sequence_look_at(-253.92, 30.71, 96.73)
			event.set_object_sequence_position(0, -268.17, 20.61, 70.01)
			event.set_object_sequence_rotation(0, 0.0, -2.51, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.move_object_sequence(0, -403.16, 20.61, -110.47, 50)
			at = 2
			helper_888ab2a3(30)
			event.fade_out_screen(20)
			at = 3
			helper_888ab2a3(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(1.33)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(1.33)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			if at <= 2 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_13524(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var12: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var16: s32 = 0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, arg0)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var9 = out2 or var9
	end
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var12 = out2 or var12
	end
	yaw = event.get_direction_angle(var2, var3, var4, var5, var6, var7) or yaw
	yaw_2 = event.get_direction_angle(var5, var6, var7, var2, var3, var4) or yaw_2
	var16 = event.compare_angles(var9, yaw, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	var16 = event.compare_angles(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(20)
	if arg1 == 0 then
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
	end
	if arg1 == 1 then
		event.set_mouth_motions(1, "慌て会話", 0, "立ち", 0)
	end
	helper_0ffc2526(0, -1, arg0, 0, 0)
	var16 = event.compare_angles(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var12, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	helper_888ab2a3(11)
end

--- Helper function.
local function helper_14010(arg0: s32)
	local flag: s32 = 0
	local var2: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local argc: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	flag = event.get_save_flag(444) or flag
	if flag == 0 then
		var2 = 0
		flag_2 = event.get_save_flag(420) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"その「ルナ研」の人に、シグーの\n頭についてた装置のこと聞いてくれないか？"
			)
		else
			flag_3 = event.get_save_flag(438) or flag_3
			if flag_3 == 0 then
				argc = event.get_owned_item_count(375) or argc
				if argc >= 1 then
					event.open_message_window_2(0, "早く、そのクスリをシグーに！")
					var2 = 1
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
		helper_13524(arg0, var2)
	else
		event.open_message_window_2(
			0,
			"シグーがいなくなって寂しいけど\n来年、成長したシグーに会うのが楽しみなんだ。"
		)
		helper_13524(arg0, 0)
	end
end

--- Helper function.
local function helper_145bc()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	if var0 == 9 then
		helper_14010(var1)
	end
end

--- Helper function.
local function helper_10c48()
	local var0: s32 = 0
	local player_chara: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	helper_4e93f9fc(var0, 0, 0)
	player_chara = event.get_player_character_slot() or player_chara
	event.open_message_window_2(
		0,
		"なんだ、おまえらか。\nシグーの時には世話になったな。\nで、何の用だい？"
	)
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "はぁ？いっしょに\nついて来いって？")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(
		0,
		"ダメだ、ダメダメ。<page>オレはここでシグーを\n待ってなきゃなんないからな。"
	)
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "でも、まぁ、\nシーグラ達が戻ってくるのは\n早くて半年後か・・・")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "それまでにカタがつくってんなら、\n付き合ってやっても良いぜ。")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "ここに居てもしようがないし、\nまぁ、ヒマつぶしかな。")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "そうだ！おい、\n人間のおまえたちなら\n知ってるよな？")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "あのスッゲーうまい食い物、\nありゃなんなんだ？")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(
		0,
		"なんだよ、とぼけんなよ。\n大きさは魚くらいでさ、\n赤いんだ。<page>とにかく赤くて、\nべらぼうにうまいんだ。"
	)
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "アレをもう一度\n食わせてくれよ。\nな、たのむぜ。")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.set_character_motion(var0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]パウって、耳が長くて前歯が大きくて、\n   ある動物にそっくりですよね。\n   その動物が好きな赤い食べ物と言えば・・・"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 5, 1)
end

--- Helper function.
local function helper_11788()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(var1, 0, 0)
	player_chara = event.get_player_character_slot() or player_chara
	event.open_message_window_2(0, "おっ、持って来て\nくれたのかい？\nあの赤い食べ物・・・")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_use_item_menu(315)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(var1, "立ち")
		event.finish_event()
		return
	end
	if item ~= 315 then
		event.open_message_window_2(0, "おい、ふざけてんのか。\nこんなんじゃねぇよ！")
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"あぁ・・・\nこ、これだぁ！<page>この赤さ、この匂い、\nこの歯ざわり・・・"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"人間と付き合うってのも、\n悪い事ばっかりじゃねえな。<page>よし、約束だ。\nいっしょに行ってやる。"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"実はな、世界がヤバい事に\nなってるってのは、ちょっと\n前から勘付いていたんだ。"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"グリフォンって奴が\n良からぬ事をしてるってのも、\nシグーの時に分かった。"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "奴をなんとかしようってんだろう。\nなら、喜んで協力するぜ。")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"言っとくけど、ニンジンもらったから\n言う事聞いてるわけじゃないからな！\nそこんとこをまちがえるなよ。"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.set_character_motion(var1, "立ち")
	event.set_npc_party_status(var0, 130)
	helper_024677a1(var0)
	event.finish_event()
	event.set_quest_request(1, 5, 1)
end

--- Helper function.
local function helper_12238()
	local var0: s32 = 0
	local var1: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_chapter() or var1
	if var1 ~= 8 then
		event.open_message_window_2(
			0,
			"なぁ、またニンジンが\n手に入ったら、オレに\nくれよな。たのんだぜ。"
		)
	else
		event.open_message_window_2(0, "よっ！元気か。オレも元気だぜ。")
	end
	helper_1c04a0eb(var0, -1, 0, 0)
end

--- Helper function.
local function helper_12480()
	local var0: s32 = 0
	var0 = event.get_quest_request_status(0, 5) or var0
	if var0 == 0 then
		helper_10c48()
		return
	end
	if var0 == 1 then
		helper_11788()
		return
	end
	if var0 == 2 then
		helper_12238()
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		old_map_no = event.get_previous_map() or old_map_no
		if old_map_no == 2 then
			flag = event.get_save_flag(404) or flag
			if flag == 0 then
				at = 1
				helper_156a0()
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g03", 500)
			else
				at = 2
				helper_790d496b()
			end
		elseif old_map_no == 84 then
			flag_2 = event.get_save_flag(408) or flag_2
			if flag_2 == 0 then
				at = 3
				helper_1d1a0()
			else
				at = 4
				helper_1f580()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_dfed0a42()
			end
			if at <= 2 then
				at = 3
				helper_1d1a0()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_1f580()
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
script.key_open = helper_228e8

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_146f0() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local argc: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local yaw: f32 = 0
	local var11: s32 = 0
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		argc = event.get_owned_item_count(375) or argc
		if argc >= 1 then
			event.set_character_motion(0, "立ち")
			var1 = event.get_triggered_event_data_2(6) or var1
			if var1 == 1 then
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(
					0,
					"傷を負ったシグーが苦しんでいる。\n（(#)ボタンでメニューを開く）"
				)
				at = 1
				var3 = helper_c292fa16(0, -1, 5, 256, 208, var3)
				if var3 == 1 then
					var1 = 2
				end
			end
			if var1 == 2 then
				event.open_use_item_menu(375)
				at = 2
				vm.wait(2)
				item = vmhost.used_item() or item
				if item > 0 then
					if item == 375 then
						at = 3
						helper_228e8()
						event.jump_to_map_3(-1, "s40", 500)
						at = 4
						vm.wait(4)
						return
					else
						at = 5
						helper_5fb66cb1()
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
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			do
				local _, out2, _ = event.get_character_rotation(0)
				var8 = out2 or var8
			end
			yaw = event.get_direction_angle(var4, var5, var6, -76.0, 0.0, 23.0) or yaw
			var11 = event.compare_angles(var8, yaw, 0.1) or var11
			if var11 ~= 0 then
				event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
				event.set_object_sequence_motion(0, "歩き")
				event.delay_object_sequence_motion_track(0, 10)
			end
			event.set_object_sequence_motion(0, "立ち")
			at = 6
			helper_888ab2a3(20)
			event.set_message_window_mode(0, 1)
			event.set_mouth_motions(1, "鳴く", 0, "座り", 0)
			flag = event.get_save_flag(438) or flag
			if flag == 0 then
				event.open_message_window_2(0, "ピィイイイ！")
			else
				event.open_message_window_2(0, "パオオオー！")
			end
			at = 7
			helper_0ffc2526(0, -1, 9, 0, 0)
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var3 = received[2] :: number
			end
			if at <= 1 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 2 then
				at = 3
				helper_228e8()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s40", 500)
					at = 4
					vm.wait(4)
					return
				end)
			end
			return 0
		end
		if at <= 7 then
			if at <= 5 then
				helper_038a2e4d(20)
			end
			if at <= 6 then
				helper_249b75d1(0, -1, 9, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event_99()
	helper_1d1a0()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local flag: s32 = 0
	local var1: s32 = 0
	flag = event.get_save_flag(500) or flag
	if flag == 0 then
		helper_145bc()
	else
		var1 = event.get_triggered_event_data_2(13) or var1
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, var1)
		helper_12480()
		event.set_villager_ai_enabled(1, var1)
	end
end

--- Event 14040, which map data, a script or the engine runs by number.
function script.event_14040()
	event.set_save_flag(408, 0)
	event.set_save_flag(420, 0)
	event.set_save_flag(444, 0)
	event_99()
	helper_156a0()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g03", 500)
end

--- Event 14380, which map data, a script or the engine runs by number.
function script.event_14380()
	event.set_save_flag(408, 1)
	event.set_save_flag(420, 1)
	event.set_save_flag(444, 0)
	event_99()
	helper_228e8()
	event.jump_to_map_3(-1, "s40", 500)
	vm.wait(2)
end

return script
