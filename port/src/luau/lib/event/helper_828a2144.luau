--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_828a2144()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(532, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(113)
		event.load_map_sounds(5820)
		var1 = event.load_sound_effect_file_2(5820) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e532_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e532_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e532_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "shuchusen.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.load_character(5, "e532_syougeki.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(11, 14)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 11)
		block = event.load_event_image_4(5, "e532.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e53201", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 5)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e53202", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(6, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 6)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e53203", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(7, 2)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.reset_event_sprite(3)
		event.set_event_sprite_type(3, 0)
		event.set_event_sprite_texture(3, "e53204", block)
		event.set_event_sprite_color(3, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(3, 0, 0, 512, 448)
		event.set_event_sprite_size(3, 512, 448)
		event.set_event_sprite_position(3, 256, 224)
		event.set_event_sprite_draw_pass(3, 1)
		event.attach_object_handle_to_sprite(8, 3)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 8)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "e53205", block)
		event.set_event_sprite_color(4, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(4, 0, 0, 512, 448)
		event.set_event_sprite_size(4, 512, 448)
		event.set_event_sprite_position(4, 256, 224)
		event.set_event_sprite_draw_pass(4, 1)
		event.attach_object_handle_to_sprite(9, 4)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 9)
		event.change_directory("")
		if active_chr_no == 1 then
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_equipment_model(5, 1, 0, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e500/e532/e532_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_position(0, 0.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "バトル立ち2", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, -100.0, 0.0, -200.0)
		event.set_object_handle_rotation(1, 0.0, 2.54, 0.0)
		event.set_object_handle_motion(1, "起きあがり待ち", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "はぁはぁ", 4)
		event.step_object_handle_motion(2)
		event.reset_object_handle_dynamic_animation(2)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目パチ")
		event.set_character_position(12, 0.0, -1000.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(38.02, 17.95, 16.08)
		event.set_camera_sequence_look_at(5.45, 17.89, 15.92)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 3
		helper_4116e6bb(5320010)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		at = 4
		wait_frames(40)
		event.set_camera_sequence_position(-3.92, 12.48, 46.35)
		event.set_camera_sequence_look_at(0.46, 18.98, 16.47)
		event.set_object_sequence_motion(2, "顔上げ", 6)
		event.queue_object_sequence_next_motion(2, "顔上げL", 4)
		at = 5
		wait_objects(2)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 6
		helper_4116e6bb(5320020)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 7
		helper_4116e6bb(5320030)
		event.set_camera_sequence_look_at(0.0, 20.0, 50.0)
		event.set_camera_sequence_angle_height_distance(-0.36, 0.0, 100.0)
		event.move_camera_sequence_angle_height_distance_eased(2.64, 0.0, 100.0, 280, 2, 1.0)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 8
		helper_4116e6bb(5320040)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 9
		helper_4116e6bb(5320045)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(5320050)
		at = 11
		wait_camera()
		event.set_camera_sequence_position(16.36, 17.95, 32.78)
		event.set_camera_sequence_look_at(0.93, 19.2, 17.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目あき～目とじ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 12
		helper_4116e6bb(5320060)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 13
		helper_4116e6bb(5320065)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～苦し目あき")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 14
		helper_4116e6bb(5320070)
		event.set_camera_sequence_position(16.15, 37.27, 153.71)
		event.set_camera_sequence_look_at(3.58, 24.38, 96.09)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 15
		helper_4116e6bb(5320080)
		event.play_sound_effect(var1, 2)
		event.set_object_sequence_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "起きあがりL", 4)
		at = 16
		wait_frames(30)
		event.set_object_sequence_motion(1, "起きあがり", 6)
		event.queue_object_sequence_next_motion(1, "起きあがりL", 4)
		at = 17
		wait_frames(15)
		event.set_camera_sequence_position(-84.02, 9.18, -188.66)
		event.set_camera_sequence_look_at(-99.08, 9.86, -193.29)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.play_sound_effect(var1, 3)
		at = 18
		wait_objects(1)
		at = 19
		wait_frames(20)
		event.set_camera_sequence_position(-23.98, 12.62, 43.97)
		event.set_camera_sequence_look_at(-1.29, 22.54, 7.67)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 20
		helper_4116e6bb(5320090)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_character_active(12)
		event.set_camera_sequence_follow_object(1, 0.0, 20.0, 7.0, -1.0, 0.0, 40.0)
		event.delay_camera_sequence_angle_track(19)
		event.release_camera_sequence_follow_object()
		event.delay_camera_sequence_position_track(20)
		event.set_camera_sequence_position(-26.37, 17.77, -50.44)
		event.set_camera_sequence_look_at(-51.96, 20.0, -102.44)
		event.delay_camera_sequence_character_track(20)
		event.keep_character_in_front_of_camera_sequence(12, 60.0, 20)
		event.set_character_active(1, 10)
		event.set_object_sequence_rotation(1, 0.0, 0.46, 0.0)
		event.set_object_sequence_motion(1, "剣走り", 4, -1.0, 1)
		event.move_object_sequence(1, -11.76, 0.0, -20.14, 60)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "歯くいしばり")
		at = 21
		helper_1584c528(5320100, 40)
		event.set_character_active(0, 12)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_camera_sequence_position(-69.98, 14.49, -24.99)
		event.set_camera_sequence_look_at(-2.25, 17.76, -8.93)
		event.delay_camera_sequence_position_track(45)
		event.set_camera_sequence_position(-52.69, 22.4, 13.43)
		event.set_camera_sequence_look_at(-30.89, 6.61, -41.34)
		event.set_object_sequence_rotation(2, 0.0, -2.4, 0.0)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "よけ", 6)
		event.queue_object_sequence_next_motion(2, "ふっとばし", 6)
		event.delay_object_sequence_texture_animation_track(2, 40)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 1, "口ふっ")
		event.set_object_sequence_motion(1, "斬り", 6)
		event.queue_object_sequence_next_motion(1, "吹っ飛び", 6)
		event.delay_object_sequence_position_track(1, 20)
		event.move_object_sequence_eased(1, -34.13, 0.0, -72.15, 26, 2, 1.0)
		event.play_object_sequence_sound(1, var1, 4)
		event.delay_object_sequence_sound_track(1, 50)
		event.play_object_sequence_sound(1, var1, 6)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_character_active(1, 14)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, -2.4, 0.0)
		event.set_object_sequence_motion(9, "ふっとばし", 5)
		event.delay_object_sequence_motion_track(9, 26)
		event.set_object_sequence_motion(9, "ふっとばし", 6)
		event.delay_object_sequence_sound_track(9, 34)
		event.play_object_sequence_sound(9, var1, 5)
		at = 22
		wait_frames(5)
		at = 23
		helper_1584c528(5320110, 20)
		at = 24
		wait_frames(5)
		at = 25
		helper_1584c528(5320120, 40)
		at = 26
		wait_objects(1)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_sequence_motion(0, "モニカ！！", 6)
		event.queue_object_sequence_next_motion(0, "モニカ！！L", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 27
		helper_4116e6bb(5320130)
		at = 28
		wait_objects(0)
		event.set_camera_sequence_position(-18.95, 19.99, -37.66)
		event.set_camera_sequence_look_at(-30.66, 14.75, -65.72)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var1, 7)
		event.set_object_sequence_motion(1, "しゃがみにらみ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "しゃがみにらみL", 4)
		at = 29
		wait_objects(1)
		at = 30
		wait_frames(20)
		event.set_camera_sequence_position(-57.1, 14.78, -90.75)
		event.set_camera_sequence_look_at(-21.25, 17.36, -33.53)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "後ろ見", 6)
		event.queue_object_sequence_next_motion(2, "後ろ見L", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 31
		helper_4116e6bb(5320140)
		at = 32
		wait_objects(2)
		event.set_camera_sequence_position(0.0, 27.09, 35.56)
		event.set_camera_sequence_look_at(0.0, 29.67, -20.86)
		event.play_music(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "笑う", 4)
		event.delay_object_sequence_motion_track(2, 100)
		event.set_object_sequence_motion(2, "笑う2")
		event.delay_object_sequence_texture_animation_track(2, 100)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目～大わらい目")
		event.set_object_sequence_texture_animation(2, 1, "大わらい口パク")
		at = 33
		helper_0e75aa9e(5320150, -1, 10)
		event.set_message_button_prompt(0, 1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "大わらい目～通常目")
		event.play_sound_effect(var1, 9)
		event.set_object_sequence_motion(2, "戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 34
		helper_4116e6bb(5320155)
		at = 35
		wait_objects(2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "前向き～右向き")
		event.set_object_sequence_motion(1, "立つ", 2)
		event.queue_object_sequence_next_motion(1, "立つL", 4)
		event.delay_object_sequence_sound_track(1, 4)
		event.play_object_sequence_sound(1, var1, 10)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 36
		helper_4116e6bb(5320160)
		at = 37
		wait_objects(1)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり")
		event.set_object_sequence_motion(0, "バトル立ち2", 4)
		at = 38
		wait_frames(40)
		event.set_camera_sequence_position(1.0, 31.0, 29.43)
		event.set_camera_sequence_look_at(1.0, 31.0, 1.39)
		event.move_camera_sequence_eased(1.0, 31.0, 23.46, 1.0, 31.0, 1.39, 90, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 39
		helper_4116e6bb(5320170)
		at = 40
		wait_camera()
		event.set_environment_music_volume(0.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 41
		helper_4116e6bb(5320180)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 42
		helper_4116e6bb(5320190)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 43
		helper_4116e6bb(5320200)
		at = 44
		wait_objects(3)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 45
		helper_4116e6bb(5320210)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 46
		helper_4116e6bb(5320220)
		at = 47
		wait_objects(4)
		event.set_object_sequence_color(3, 128, 128, 128, 0)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 48
		helper_4116e6bb(5320225)
		at = 49
		wait_objects(5)
		event.set_object_sequence_color(4, 128, 128, 128, 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 50
		helper_4116e6bb(5320230)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 51
		helper_4116e6bb(5320240)
		at = 52
		wait_objects(6)
		event.set_object_sequence_color(5, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 53
		helper_4116e6bb(5320250)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 54
		helper_4116e6bb(5320260)
		at = 55
		wait_objects(7)
		event.set_object_sequence_color(6, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 0, 30)
		event.set_environment_music_volume(1.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 56
		helper_4116e6bb(5320270)
		at = 57
		wait_objects(7)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 58
		helper_4116e6bb(5320275)
		at = 59
		vm.wait(59)
		at = 60
		vm.wait(60)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			active_chr_no = 0
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_8cd371d7(5320010)
		end
		if at <= 3 then
			wait_frames_skipping(40)
		end
		if at <= 4 then
			helper_238b5abc(2)
		end
		if at <= 5 then
			helper_8cd371d7(5320020)
		end
		if at <= 6 then
			helper_8cd371d7(5320030)
		end
		if at <= 7 then
			helper_8cd371d7(5320040)
		end
		if at <= 8 then
			helper_8cd371d7(5320045)
		end
		if at <= 9 then
			helper_8cd371d7(5320050)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_8cd371d7(5320060)
		end
		if at <= 12 then
			helper_8cd371d7(5320065)
		end
		if at <= 13 then
			helper_8cd371d7(5320070)
		end
		if at <= 14 then
			helper_8cd371d7(5320080)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(15)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			wait_frames_skipping(20)
		end
		if at <= 19 then
			helper_8cd371d7(5320090)
		end
		if at <= 20 then
			helper_52aadc70(5320100, 40)
		end
		if at <= 21 then
			wait_frames_skipping(5)
		end
		if at <= 22 then
			helper_52aadc70(5320110, 20)
		end
		if at <= 23 then
			wait_frames_skipping(5)
		end
		if at <= 24 then
			helper_52aadc70(5320120, 40)
		end
		if at <= 25 then
			helper_238b5abc(1)
		end
		if at <= 26 then
			helper_8cd371d7(5320130)
		end
		if at <= 27 then
			helper_238b5abc(0)
		end
		if at <= 28 then
			helper_238b5abc(1)
		end
		if at <= 29 then
			wait_frames_skipping(20)
		end
		if at <= 30 then
			helper_8cd371d7(5320140)
		end
		if at <= 31 then
			helper_238b5abc(2)
		end
		if at <= 32 then
			helper_2f8c501c(5320150, -1, 10)
		end
		if at <= 33 then
			helper_8cd371d7(5320155)
		end
		if at <= 34 then
			helper_238b5abc(2)
		end
		if at <= 35 then
			helper_8cd371d7(5320160)
		end
		if at <= 36 then
			helper_238b5abc(1)
		end
		if at <= 37 then
			wait_frames_skipping(40)
		end
		if at <= 38 then
			helper_8cd371d7(5320170)
		end
		if at <= 39 then
			helper_344d6cd8()
		end
		if at <= 40 then
			helper_8cd371d7(5320180)
		end
		if at <= 41 then
			helper_8cd371d7(5320190)
		end
		if at <= 42 then
			helper_8cd371d7(5320200)
		end
		if at <= 43 then
			helper_238b5abc(3)
		end
		if at <= 44 then
			helper_8cd371d7(5320210)
		end
		if at <= 45 then
			helper_8cd371d7(5320220)
		end
		if at <= 46 then
			helper_238b5abc(4)
		end
		if at <= 47 then
			helper_8cd371d7(5320225)
		end
		if at <= 48 then
			helper_238b5abc(5)
		end
		if at <= 49 then
			helper_8cd371d7(5320230)
		end
		if at <= 50 then
			helper_8cd371d7(5320240)
		end
		if at <= 51 then
			helper_238b5abc(6)
		end
		if at <= 52 then
			helper_8cd371d7(5320250)
		end
		if at <= 53 then
			helper_8cd371d7(5320260)
		end
		if at <= 54 then
			helper_238b5abc(7)
		end
		if at <= 55 then
			helper_8cd371d7(5320270)
		end
		if at <= 56 then
			helper_238b5abc(7)
		end
		if at <= 57 then
			helper_8cd371d7(5320275)
		end
		return true
	end)
	at = 61
	vm.entry(61)
	event.cancel_drama_scene_skip()
	event.start_crossfade(60)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

return helper_828a2144
