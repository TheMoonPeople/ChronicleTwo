--!strict
--- Map script for the Halloween boss room of the first dungeon: intro cutscene, floor exit prompt and battle hints.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local underground_water_channel_boss = require("@lib/event/underground_water_channel_boss")
local wait = require("@lib/event/wait")

--- Plays the skippable cutscene where Mints meets Halloween and Polcurse before the boss fight, then loads the monsters and explains how to grab RoBombs.
local function play_halloween_boss_intro()
	local intro_sound_id: s32 = 0
	local halloween_sound_id: s32 = 0
	local language_code: s32 = 0
	local texture_block: s32 = 0
	local polcurse_x: f32 = 0
	local polcurse_y: f32 = 0
	local polcurse_z: f32 = 0
	local i: s32 = 0
	local rise_speed: f32 = 0
	local rise_x: f32 = 0
	local rise_y: f32 = 0
	local rise_z: f32 = 0
	local slow_x: f32 = 0
	local slow_y: f32 = 0
	local slow_z: f32 = 0
	local cruise_x: f32 = 0
	local cruise_y: f32 = 0
	local cruise_z: f32 = 0
	local ascend_x: f32 = 0
	local ascend_y: f32 = 0
	local ascend_z: f32 = 0
	local is_e3_version: s32 = 0
	local progress_step: number = 0
	vm.section(function()
		event.set_save_flag(110, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		progress_step = 1
		wait.for_frame_count(4)
		event.load_music(107)
		message.set_window_mode(0, 7)
		event.set_message_window_option(0, 2, 0.6)
		intro_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or intro_sound_id
		halloween_sound_id = event.load_sound_effect_file_2(1828) or halloween_sound_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e100/e110/")
		event.load_event_pack_file("e110_data.pak")
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.load_message_file(0, 5, "e110.txt")
		else
			event.load_message_file(0, 5, "eng_e110.txt")
		end
		event.load_character_motion_pack(5, "e110_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1006.26, -27.71, -200.0)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		event.load_character(5, "e110_Halloween.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.set_object_handle_sound_bank(1, halloween_sound_id)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 37.26, 564.09, 929.35)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.load_character(5, "e110_polcurse.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "手乗りL", 4)
		event.attach_character_to_frame(8, "polcurse", 9)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.attach_object_handle_to_map_part_3(3, "p02_d01b01", "d01b01_9-m0")
		event.set_object_handle_visible(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.load_character(5, "shuchusen.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character_frame(4, 8, "cube39")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.rotate_object_sequence(4, 0.0, -0.02, 0.0, -1)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.attach_object_handle_to_map_part_3(7, "p04_d01b01-0", "d01b01_10-m0")
		event.set_object_handle_visible(7, 1)
		event.attach_object_handle_to_map_part_3(8, "p04_d01b01-1", "d01b01_10-m0")
		event.set_object_handle_visible(8, 1)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			texture_block = event.load_event_image_4(5, "e110telop01.json", 0) or texture_block
		else
			texture_block = event.load_event_image_4(5, "eng_e110telop01.json", 0) or texture_block
		end
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e110telop01", texture_block)
		event.set_event_sprite_position(0, 320, 334)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e110telop01", texture_block)
		event.set_event_sprite_position(1, 320, 334)
		event.set_event_sprite_size(1, 512, 128)
		event.set_event_sprite_texture_rect(1, 0, 128, 512, 128)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 1.0, 1.0)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(11, 1)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_current_directory("")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("e110ポル回転キラ")
		event.create_effect_work_buffer(5)
		event.play_sound_effect(intro_sound_id, 1)
		event.move_object_sequence(3, 0.0, 80.0, 0.0, 60)
		event.jump_object_sequence(3, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(3, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(3, 0.0, 0.0, 0.0, -0.4, 5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(800.55, 83.98, -20.2)
		event.set_camera_sequence_look_at(868.65, 40.42, -105.22)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		progress_step = 2
		camera.wait_until_done()
		progress_step = 3
		wait.for_frame_count(4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 962.88, -27.71, -191.57, 14)
		event.move_object_sequence(0, 928.6, -49.72, -185.79, 14)
		event.move_object_sequence(0, 904.87, -49.72, -180.71, 10)
		progress_step = 4
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "振り返る", 2)
		event.wait_object_sequence_motion_end(0)
		progress_step = 5
		object.wait_until_done(0)
		progress_step = 6
		object.wait_until_done(3)
		event.set_camera_sequence_position(943.36, -35.09, -186.58)
		event.set_camera_sequence_look_at(821.59, -23.08, -155.24)
		event.set_object_handle_position(0, 879.76, -49.72, -169.55)
		event.set_object_handle_rotation(0, 0.0, -1.32, 0.0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 817.46, -49.72, -153.11, 50)
		event.move_object_sequence(0, 794.24, -39.66, -147.28, 20)
		progress_step = 7
		object.wait_until_done(0)
		event.set_object_handle_position(0, 686.37, 0.0, -120.12)
		event.reset_object_handle_dynamic_animation(0)
		event.set_camera_sequence_follow_object(0, 0.0, 23.0, 0.0, -0.72, -4.02, 31.37)
		event.delay_camera_sequence_angle_track(60)
		event.move_camera_sequence_angle_height_distance_eased(1.86, -8.02, 63.25, 60, 0, 0.2)
		event.release_camera_sequence_follow_object()
		event.move_object_sequence(0, 507.6, 0.0, -66.93, 120)
		event.set_object_sequence_motion(0, "見上げる", 6)
		event.queue_object_sequence_next_motion(0, "見上げ歩き", 4)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "見上げ立ち")
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_texture_animation_track(0, 40)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目・見上げ")
		event.set_object_sequence_texture_animation(0, 1, "口・見上げ止")
		progress_step = 8
		vm.wait(8)
		event.reset_object_handle_dynamic_animation(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_mouth_texture_animations(0, "通常口パク", "口・見上げ")
		progress_step = 9
		message.show_voiced(1100010)
		event.reset_mouth_texture_animations()
		progress_step = 10
		object.wait_until_done(0)
		progress_step = 11
		camera.wait_until_done()
		event.move_camera_sequence_eased(647.19, 16.82, -107.92, 573.94, 30.81, -86.41, 60, 1, 0.4)
		progress_step = 12
		camera.wait_until_done()
		event.set_camera_sequence_position(481.56, 21.0, -62.02)
		event.set_camera_sequence_look_at(508.07, 23.54, -68.14)
		event.set_object_sequence_motion(0, "見上げ立ち戻り", 6)
		event.queue_object_sequence_next_motion(0, "キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目・見上げ戻り")
		event.delay_object_sequence_texture_animation_track(0, 15)
		event.set_object_sequence_texture_animation(0, 1, "目・きょろきょろ")
		progress_step = 13
		wait.for_frame_count(20)
		event.set_mouth_texture_animations(0, "通常口パク", "口・半開き")
		progress_step = 14
		message.show_voiced_for_stopping(1100020, 80)
		event.set_object_sequence_position(1, 794.24, 1010.34, -147.28)
		event.set_object_sequence_motion(1, "歩き", 4)
		progress_step = 15
		object.wait_until_done(0)
		event.set_camera_sequence_position(667.59, 48.44, -95.85)
		event.set_camera_sequence_look_at(507.87, 18.94, -68.32)
		event.set_object_sequence_motion(0, "音に反応", 5)
		event.set_object_sequence_motion(0, "音に反応", 6)
		event.wait_object_sequence_motion_end(0)
		progress_step = 16
		object.wait_until_done(0)
		event.set_camera_sequence_position(467.51, 13.06, -57.87)
		event.set_camera_sequence_look_at(508.01, 21.39, -67.82)
		event.set_object_sequence_motion(0, "速・キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目・真剣")
		event.set_object_sequence_texture_animation(0, 1, "口・半開き")
		progress_step = 17
		message.show_voiced_for_stopping(1100030, 57)
		progress_step = 18
		object.wait_until_done(0)
		event.set_camera_sequence_position(732.17, 114.43, -122.58)
		event.set_camera_sequence_look_at(508.62, 22.98, -66.95)
		event.set_object_handle_motion(0, "真上見立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.move_camera_sequence_eased(732.17, 105.07, -122.58, 508.62, 223.27, -66.95, 60, 0, 0.2)
		progress_step = 19
		camera.wait_until_done()
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_visible(8, 0)
		event.set_object_sequence_position(1, 37.26, 564.09, 929.35)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(210)
		event.add_camera_sequence_path_point(479.06, 94.59, -66.26, 507.46, 23.18, -69.39)
		event.add_camera_sequence_path_point(386.56, 312.04, -56.08, 414.96, 240.64, -59.21)
		event.add_camera_sequence_path_point(304.67, 472.78, -47.07, 342.21, 399.0, -51.2)
		event.add_camera_sequence_path_point(274.9, 515.04, -43.79, 318.44, 449.77, -48.58)
		event.add_camera_sequence_path_point(229.74, 556.03, -38.82, 283.49, 497.89, -44.74)
		event.add_camera_sequence_path_point(197.84, 575.12, -35.31, 257.48, 523.46, -41.88)
		event.add_camera_sequence_path_point(148.59, 605.53, -29.04, 215.14, 556.58, -36.37)
		event.add_camera_sequence_path_point(114.51, 623.85, -27.82, 185.31, 580.9, -32.72)
		event.add_camera_sequence_path_point(89.5, 630.58, -38.99, 159.38, 594.13, -26.12)
		event.add_camera_sequence_path_point(25.47, 631.37, -83.55, 125.36, 605.75, -13.42)
		event.add_camera_sequence_path_point(-8.91, 642.36, -136.52, 76.49, 616.11, 3.65)
		event.add_camera_sequence_path_point(-27.48, 657.3, -231.71, 33.05, 631.05, 47.82)
		event.add_camera_sequence_path_point(-11.9, 657.3, -307.18, 8.38, 643.05, 97.42)
		event.start_camera_sequence_path()
		progress_step = 20
		wait.for_frame_count(130)
		event.move_object_sequence(1, 0.0, 564.09, 0.0, 140)
		progress_step = 21
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		event.play_sound_effect(halloween_sound_id, 24)
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 22
		message.show_voiced(1100040)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 23
		message.show_voiced(1100045)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-27.14, 839.27, 80.43)
		event.set_camera_sequence_look_at(94.75, 655.45, 2.7)
		event.play_sound_effect(halloween_sound_id, 25)
		event.set_object_sequence_motion(1, "歩き", 6)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.rotate_object_sequence(1, 0.0, 1.57, 0.0, 34)
		progress_step = 24
		object.wait_until_done(1)
		progress_step = 25
		wait.for_frame_count(10)
		event.set_camera_sequence_position(58.08, 736.51, -2.54)
		event.set_camera_sequence_look_at(97.6, 643.79, -21.39)
		event.set_object_sequence_motion(2, "見下ろす", 6)
		event.queue_object_sequence_next_motion(2, "見下ろすL", 4)
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 26
		message.show_voiced(1100050)
		event.reset_mouth_texture_animations()
		progress_step = 27
		object.wait_until_done(2)
		event.set_camera_sequence_position(131.78, 706.5, -11.98)
		event.set_camera_sequence_look_at(68.94, 674.86, -18.39)
		event.set_object_sequence_motion(2, "行くわよL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目・右")
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 28
		vm.wait(28)
		progress_step = 29
		message.show_voiced(1100060)
		event.reset_mouth_texture_animations()
		event.play_music(0)
		event.set_object_sequence_motion(2, "ショータイム", 6)
		event.queue_object_sequence_next_motion(2, "ショータイムL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目・怒り")
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 30
		vm.wait(30)
		progress_step = 31
		message.show_voiced(1100070)
		event.reset_mouth_texture_animations()
		progress_step = 32
		object.wait_until_done(2)
		event.set_camera_sequence_position(451.72, 232.27, 240.77)
		event.set_camera_sequence_look_at(427.53, 269.36, 227.22)
		event.stop_sound_effect(halloween_sound_id, 24)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "polcurse")
			polcurse_x = out1 or polcurse_x
			polcurse_y = out2 or polcurse_y
			polcurse_z = out3 or polcurse_z
		end
		event.detach_character_from_frame(9)
		event.set_character_position(9, polcurse_x, polcurse_y, polcurse_z)
		event.set_character_rotation(9, 0.0, 1.0, 0.0)
		event.set_object_sequence_motion(2, "飛び降り", 6)
		event.queue_object_sequence_next_motion(2, "浮遊１", 4)
		progress_step = 33
		wait.for_frame_count(30)
		event.rotate_object_sequence(2, 0.84, 1.0, 0.0, 20)
		event.jump_object_sequence(2, 419.2, 234.6, 220.13, -0.4, 60)
		event.play_sound_effect(halloween_sound_id, 26)
		progress_step = 34
		wait.for_frame_count(60)
		event.set_camera_sequence_position(165.25, 132.61, -30.82)
		event.set_camera_sequence_look_at(217.3, 22.85, -38.71)
		event.move_camera_sequence_eased(206.22, 50.23, -37.03, 217.3, 22.85, -38.71, 20, 1, 1.0)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_visible(8, 1)
		event.set_character_active(10)
		event.keep_character_in_front_of_camera_sequence(10, 60.0, 30)
		event.play_sound_effect(halloween_sound_id, 27)
		event.set_object_sequence_position(0, 213.76, 0.0, -35.13)
		event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		progress_step = 35
		message.show_voiced_for_stopping(1100080, 30)
		progress_step = 36
		camera.wait_until_done()
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(321.15, 19.21, -54.94)
		event.set_camera_sequence_look_at(217.12, 28.4, -36.14)
		event.set_object_sequence_position(1, 0.0, 250.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 1.81, 0.0)
		event.set_object_sequence_position(2, 91.22, 150.0, -45.48)
		event.set_object_sequence_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(2, "浮遊２", 4)
		event.move_object_sequence_eased(2, 91.22, 3.0, -45.48, 20, 2, 1.0)
		event.delay_object_sequence_position_track(2, 10)
		event.move_object_sequence_eased(2, 91.22, 50.0, -45.48, 30, 0, 0.5)
		event.delay_object_sequence_sound_track(2, 20)
		event.play_object_sequence_sound(2, halloween_sound_id, 28)
		progress_step = 37
		wait.for_frame_count(30)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.2, 20)
		event.set_object_sequence_motion(1, "ジャンプ下降", 4)
		event.delay_object_sequence_motion_track(1, 8)
		event.set_object_sequence_motion(1, "着地", 2)
		event.queue_object_sequence_next_motion(1, "立ち2")
		progress_step = 38
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "真上見立ち戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		progress_step = 39
		wait.for_frame_count(10)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 20)
		progress_step = 40
		camera.wait_until_done()
		progress_step = 41
		wait.for_frame_count(25)
		event.set_camera_sequence_follow_object(1, 0.0, 80.0, 0.0, 1.97, -70.0, 253.0)
		event.move_camera_sequence_angle_height_distance(0.97, -70.0, 253.0, 120)
		event.release_camera_sequence_follow_object()
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
		progress_step = 42
		wait.for_frame_count(60)
		progress_step = 43
		camera.wait_until_done()
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(171.04, 24.22, -17.77)
		event.set_camera_sequence_look_at(211.57, 16.11, -36.07)
		event.set_object_sequence_position(1, -20.0, 0.0, 4.0)
		event.set_object_sequence_rotation(1, 0.0, 1.81, 0.0)
		event.set_character_active(0)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 1)
		event.play_sound_effect(halloween_sound_id, 29)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目・真剣")
		event.set_object_sequence_texture_animation(0, 1, "口・真剣")
		event.set_object_sequence_motion(0, "戦闘ポーズ", 6)
		event.queue_object_sequence_next_motion(0, "戦闘ポーズL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		progress_step = 44
		object.wait_until_done(0)
		progress_step = 45
		wait.for_frame_count(10)
		event.set_camera_sequence_position(113.39, 78.66, -47.55)
		event.set_camera_sequence_look_at(92.06, 84.16, -45.15)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目・下")
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 46
		vm.wait(46)
		progress_step = 47
		message.show_voiced(1100090)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 48
		message.show_voiced(1100095)
		event.reset_mouth_texture_animations()
		event.move_camera_sequence_eased(174.94, 68.68, -35.59, 91.81, 72.25, -43.36, 60, 0, 0.2)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.create_effect_2("e110ポル回転キラ", 9)
		event.set_effect_first_vector(60.0, 40.0, 60.0)
		event.set_object_sequence_motion(2, "くるくる", 6)
		event.queue_object_sequence_next_motion(2, "くるくるL", 6)
		event.queue_object_sequence_next_motion(2, "決めポーズ", 6)
		event.queue_object_sequence_next_motion(2, "決めポーズL", 4)
		progress_step = 49
		wait.for_frame_count(20)
		event.play_sound_effect(halloween_sound_id, 30)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 30)
		progress_step = 50
		object.wait_until_done(2)
		progress_step = 51
		wait.for_frame_count(30)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_camera_sequence_position(182.28, 10.76, -60.08)
		event.set_camera_sequence_look_at(217.66, 18.65, -32.62)
		event.set_object_handle_motion(0, "しつこいよ", 4)
		event.reset_object_handle_dynamic_animation(0)
		progress_step = 52
		vm.wait(52)
		event.reset_object_handle_dynamic_animation(0)
		event.set_mouth_texture_animations(0, "通常口パク", "口・真剣")
		progress_step = 53
		message.show_voiced(1100100)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク", "口・真剣")
		progress_step = 54
		message.show_voiced(1100105)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(169.83, 62.01, -47.58)
		event.set_camera_sequence_look_at(91.17, 73.27, -42.67)
		event.set_object_sequence_motion(2, "ウッキー", 6)
		event.queue_object_sequence_next_motion(2, "ウッキーL", 4)
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 55
		message.show_voiced(1100110)
		event.reset_mouth_texture_animations()
		progress_step = 56
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "ウッキー会話", 6)
		event.queue_object_sequence_next_motion(2, "ウッキーL", 4)
		event.set_mouth_texture_animations(2, "口パク")
		progress_step = 57
		message.show_voiced(1100115)
		event.reset_mouth_texture_animations()
		progress_step = 58
		object.wait_until_done(2)
		event.set_camera_sequence_position(255.11, 67.29, -41.86)
		event.set_camera_sequence_look_at(-34.43, 83.69, 6.75)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "浮遊１")
		event.delay_object_sequence_position_track(2, 10)
		event.move_object_sequence_eased(2, 135.3, 50.0, 64.0, 60, 1, 0.4)
		event.delay_object_sequence_rotation_track(2, 10)
		event.rotate_object_sequence(2, 0.0, 1.33, 0.0, 20)
		event.create_effect_2("e110ポル回転キラ", 9)
		event.set_effect_first_vector(40.0, 20.0, 40.0)
		i = 0
		rise_speed = 0.0
		while i < 20 do
			progress_step = 59
			vm.wait(59)
			do
				local out1, out2, out3 = event.get_character_position(9)
				rise_x = out1 or rise_x
				rise_y = out2 or rise_y
				rise_z = out3 or rise_z
			end
			rise_speed = vm.f32(rise_speed + vm.f32(0.06))
			rise_y = vm.f32(rise_y + rise_speed)
			event.set_character_position(9, rise_x, rise_y, rise_z)
			i = i + 1
		end
		i = 0
		while i < 14 do
			progress_step = 60
			vm.wait(60)
			do
				local out1, out2, out3 = event.get_character_position(9)
				slow_x = out1 or slow_x
				slow_y = out2 or slow_y
				slow_z = out3 or slow_z
			end
			rise_speed = vm.f32(rise_speed - vm.f32(0.06))
			slow_y = vm.f32(slow_y + rise_speed)
			event.set_character_position(9, slow_x, slow_y, slow_z)
			i = i + 1
		end
		i = 0
		while i < 16 do
			progress_step = 61
			vm.wait(61)
			do
				local out1, out2, out3 = event.get_character_position(9)
				cruise_x = out1 or cruise_x
				cruise_y = out2 or cruise_y
				cruise_z = out3 or cruise_z
			end
			cruise_y = vm.f32(cruise_y + rise_speed)
			event.set_character_position(9, cruise_x, cruise_y, cruise_z)
			i = i + 1
		end
		i = 0
		while i < 30 do
			progress_step = 62
			vm.wait(62)
			do
				local out1, out2, out3 = event.get_character_position(9)
				ascend_x = out1 or ascend_x
				ascend_y = out2 or ascend_y
				ascend_z = out3 or ascend_z
			end
			rise_speed = vm.f32(rise_speed + vm.f32(0.08))
			ascend_y = vm.f32(ascend_y + rise_speed)
			event.set_character_position(9, ascend_x, ascend_y, ascend_z)
			i = i + 1
		end
		event.move_object_sequence(1, 109.46, 0.0, -18.38, 40)
		event.set_object_sequence_motion(1, "歩き2")
		event.delay_object_sequence_motion_track(1, 44)
		event.set_object_sequence_motion(1, "立ち2")
		progress_step = 63
		object.wait_until_done(1)
		progress_step = 64
		wait.for_frame_count(10)
		event.set_camera_sequence_position(440.6, 50.8, -73.0)
		event.set_camera_sequence_look_at(213.31, 59.72, -34.84)
		event.set_character_active(0, 9)
		progress_step = 65
		wait.for_frame_count(30)
		event.fade_out_music(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		progress_step = 66
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if progress_step <= 1 then
			message.set_window_mode_skipping(0, 7)
			wait.background_load_skipping()
		end
		if progress_step <= 2 then
			wait.skip_frame_count(4)
		end
		if progress_step <= 3 then
			cutscene.skip_command(0)
		end
		if progress_step <= 4 then
			cutscene.skip_command(0)
		end
		if progress_step <= 5 then
			cutscene.skip_command(3)
		end
		if progress_step <= 6 then
			cutscene.skip_command(0)
		end
		if progress_step <= 8 then
			message.show_voiced_skipping(1100010)
		end
		if progress_step <= 9 then
			cutscene.skip_command(0)
		end
		if progress_step <= 10 then
			wait.background_load_skipping()
		end
		if progress_step <= 11 then
			wait.background_load_skipping()
		end
		if progress_step <= 12 then
			wait.skip_frame_count(20)
		end
		if progress_step <= 13 then
			message.show_voiced_for_stopping_skipping(1100020, 80)
		end
		if progress_step <= 14 then
			cutscene.skip_command(0)
		end
		if progress_step <= 15 then
			cutscene.skip_command(0)
		end
		if progress_step <= 16 then
			message.show_voiced_for_stopping_skipping(1100030, 57)
		end
		if progress_step <= 17 then
			cutscene.skip_command(0)
		end
		if progress_step <= 18 then
			wait.background_load_skipping()
		end
		if progress_step <= 19 then
			wait.skip_frame_count(130)
		end
		if progress_step <= 20 then
			cutscene.skip_command(1)
		end
		if progress_step <= 21 then
			message.show_voiced_skipping(1100040)
		end
		if progress_step <= 22 then
			message.show_voiced_skipping(1100045)
		end
		if progress_step <= 23 then
			cutscene.skip_command(1)
		end
		if progress_step <= 24 then
			wait.skip_frame_count(10)
		end
		if progress_step <= 25 then
			message.show_voiced_skipping(1100050)
		end
		if progress_step <= 26 then
			cutscene.skip_command(2)
		end
		if progress_step <= 28 then
			message.show_voiced_skipping(1100060)
		end
		if progress_step <= 30 then
			message.show_voiced_skipping(1100070)
		end
		if progress_step <= 31 then
			cutscene.skip_command(2)
		end
		if progress_step <= 32 then
			wait.skip_frame_count(30)
		end
		if progress_step <= 33 then
			wait.skip_frame_count(60)
		end
		if progress_step <= 34 then
			message.show_voiced_for_stopping_skipping(1100080, 30)
		end
		if progress_step <= 35 then
			wait.background_load_skipping()
		end
		if progress_step <= 36 then
			wait.skip_frame_count(30)
		end
		if progress_step <= 37 then
			wait.skip_frame_count(10)
		end
		if progress_step <= 38 then
			wait.skip_frame_count(10)
		end
		if progress_step <= 39 then
			wait.background_load_skipping()
		end
		if progress_step <= 40 then
			wait.skip_frame_count(25)
		end
		if progress_step <= 41 then
			wait.skip_frame_count(60)
		end
		if progress_step <= 42 then
			wait.background_load_skipping()
		end
		if progress_step <= 43 then
			cutscene.skip_command(0)
		end
		if progress_step <= 44 then
			wait.skip_frame_count(10)
		end
		if progress_step <= 46 then
			message.show_voiced_skipping(1100090)
		end
		if progress_step <= 47 then
			message.show_voiced_skipping(1100095)
		end
		if progress_step <= 48 then
			wait.skip_frame_count(20)
		end
		if progress_step <= 49 then
			cutscene.skip_command(2)
		end
		if progress_step <= 50 then
			wait.skip_frame_count(30)
		end
		if progress_step <= 52 then
			message.show_voiced_skipping(1100100)
		end
		if progress_step <= 53 then
			message.show_voiced_skipping(1100105)
		end
		if progress_step <= 54 then
			message.show_voiced_skipping(1100110)
		end
		if progress_step <= 55 then
			cutscene.skip_command(2)
		end
		if progress_step <= 56 then
			message.show_voiced_skipping(1100115)
		end
		if progress_step <= 57 then
			cutscene.skip_command(2)
		end
		if progress_step <= 58 then
			i = 0
			rise_speed = 0.0
		end
		if progress_step <= 59 then
			rise_speed = vm.f32(rise_speed + vm.f32(0.06))
			rise_y = vm.f32(rise_y + rise_speed)
			local _ = i < 20
			i = i + 1
			i = 0
		end
		if progress_step <= 60 then
			rise_speed = vm.f32(rise_speed - vm.f32(0.06))
			slow_y = vm.f32(slow_y + rise_speed)
			local _ = i < 14
			i = i + 1
			i = 0
		end
		if progress_step <= 61 then
			cruise_y = vm.f32(cruise_y + rise_speed)
			local _ = i < 16
			i = i + 1
			i = 0
		end
		if progress_step <= 62 then
			rise_speed = vm.f32(rise_speed + vm.f32(0.08))
			ascend_y = vm.f32(ascend_y + rise_speed)
			local _ = i < 30
			i = i + 1
			cutscene.skip_command(1)
		end
		if progress_step <= 63 then
			wait.skip_frame_count(10)
		end
		if progress_step <= 64 then
			wait.skip_frame_count(30)
		end
		if progress_step <= 65 then
			wait.background_load_skipping()
		end
		return true
	end)
	progress_step = 67
	vm.entry(67)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.stop_sound_effect(intro_sound_id, 0)
	event.stop_sound_effect(halloween_sound_id, 24)
	event.stop_music(0)
	progress_step = 68
	wait.for_frame_count(4)
	event.load_music(30)
	event.play_music(0)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.set_object_handle_visible(7, 1)
	event.set_object_handle_visible(8, 1)
	event.clear_camera_sequence()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.clear_object_sequence(2)
	event.clear_object_sequence(3)
	event.clear_object_sequence(4)
	event.attach_object_handle_to_map_part_3(3, "p02_d01b01", "d01b01_9-m0")
	event.set_object_handle_position(3, 0.0, 0.0, 0.0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	event.set_character_active(0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.set_character_position(0, 213.76, 0.0, -35.13)
	event.set_character_rotation(0, 0.0, -1.36, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(213.76, 30.0, -35.13)
	event.set_camera_position(340.88, 35.0, -62.33)
	event.reset_follow_camera(0)
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	progress_step = 69
	vm.wait(69)
	is_e3_version = event.is_e3_version() or is_e3_version
	if is_e3_version == 1 then
		event.load_dungeon_monster(1000, 1)
		event.load_dungeon_monster(500, 0)
	else
		event.load_dungeon_monster(25, 1)
		event.load_dungeon_monster(1000, 0)
		event.load_dungeon_monster(500, 0)
	end
	event.place_dungeon_monster(500, 0, 0, 0, 0.0, 1.71, 0.0)
	progress_step = 70
	vm.wait(70)
	event.set_dungeon_pause_flags(1, 1)
	event.fade_in_screen(20)
	progress_step = 71
	wait.for_frame_count(20)
	event.apply_message_window_preset(0, 4)
	message.set_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	if language_code == 0 then
		event.open_message_window_2(
			0,
			"[(!)]敵の出す「鼻爆弾」をつかんで、\nタイミングよく敵にぶつけよう。<page>「鼻爆弾」をつかむには、\n近くによって[r1]＋(O)ボタンでＯＫだ。<page>つかんだ状態で(O)ボタンを押すと投げることができる。\nうまくぶつけて、敵にダメージを与えるのだ！"
		)
	else
		event.open_message_window_2(
			0,
			"[(!)]Grab the enemy's 'RoBomb'\n   and throw it toward him.<page>To grab the 'RoBomb',\nhold down [r1] button & press (O) button\nnear the bomb.<page>To throw, press (O) button.\nLet him have it!"
		)
	end
	progress_step = 72
	message.show_and_wait(0, -1, 8, 0, 0)
	message.set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_message_window_option(0, 2, -1.0)
	event.set_dungeon_pause_flags(1, 0)
	event.show_dungeon_status_bar(1)
	event.finish_event()
end

--- Plays the cutscene where Mints walks into the boss room on later visits.
local function play_entrance_cutscene()
	local footstep_sound_id: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		footstep_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or footstep_sound_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1006.26, -27.71, -200.0)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.attach_object_handle_to_map_part_3(2, "p02_d01b01", "d01b01_9-m0")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_d01b01", "d01b01_2-a")
		event.set_object_handle_visible(3, 0)
		event.move_object_sequence(2, 0.0, 80.0, 0.0, 60)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(2, 0.0, 0.0, 0.0, -0.4, 5)
		event.play_sound_effect(footstep_sound_id, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(800.55, 83.98, -20.2)
		event.set_camera_sequence_look_at(868.65, 40.42, -105.22)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		camera.wait_until_done()
		wait.for_frame_count(4)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 962.88, -27.71, -191.57, 15)
		event.move_object_sequence(0, 928.6, -49.72, -185.79, 15)
		event.move_object_sequence(0, 904.87, -49.72, -180.71, 10)
		object.wait_until_done(2)
		object.wait_until_done(0)
		event.show_dungeon_status_bar(1)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(969.7, -14.72, -202.32)
		event.set_camera_sequence_look_at(817.46, -19.72, -153.11)
		event.set_object_sequence_position(0, 880.95, -49.72, -173.03)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 840.81, -49.72, -161.41, 30)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.for_frame_count(4)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(footstep_sound_id, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 840.81, -49.72, -161.41)
	event.set_character_rotation(0, 0.0, -1.32, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_map_part_3(2, "p02_d01b01", "d01b01_9-m0")
	event.set_object_handle_position(2, 0.0, 0.0, 0.0)
	event.set_camera_position(969.7, -14.72, -202.32)
	event.set_camera_look_at(817.46, -19.72, -153.11)
	event.reset_follow_camera(0)
	event.fade_in_screen(0)
	event.finish_event()
end

--- Plays the cutscene where Halloween and Polcurse confront Mints, or ends the scene early in the trial version.
local function play_halloween_cutscene()
	local active_chr_no: s32 = 0
	local move_type: s32 = 0
	local is_trial_for_music: s32 = 0
	local cutscene_sound_id: s32 = 0
	local is_trial_for_scene: s32 = 0
	local language_code: s32 = 0
	local voice_wait_frames: s32 = 0
	local at: number = 0
	do
		local ret = vm.section(function()
			event.set_save_flag(111, 1)
			event.initialize_event()
			event.show_dungeon_status_bar(0, 0.033333335)
			active_chr_no = event.get_playable_character() or active_chr_no
			if active_chr_no == 2 then
				move_type = event.get_player_move_type() or move_type
				if move_type == 1 then
					event.set_character_motion(0, "立ち-足")
				end
				if move_type == 2 then
					event.set_character_motion(0, "立ち-キャタピラ")
				end
			else
				event.set_character_motion(0, "バトル立ち")
			end
			is_trial_for_music = event.is_trial_version() or is_trial_for_music
			if is_trial_for_music == 1 then
				event.fade_out_music(30)
			end
			event.fade_out_screen(30)
			at = 1
			wait.for_frame_count(30)
			if active_chr_no == 2 then
				event.switch_dungeon_main_character(0)
				event.set_playable_character(0)
			end
			event.change_directory("event/e100/e111/")
			event.start_background_file_loads_9(
				"e111_mints.gltf",
				"e111_Halloween.gltf",
				"e111_polcurse.gltf",
				"e111_pierrot.gltf",
				"e111baku.gltf",
				"e111pikipiki.gltf",
				"e111_hahen01.gltf",
				"e111_hahen02.gltf",
				"e111.txt"
			)
			event.stop_port_sound_effects(7)
			event.set_dungeon_pause_flags(17, 1)
			is_trial_for_scene = event.is_trial_version() or is_trial_for_scene
			if is_trial_for_scene == 1 then
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.set_character_active(0, 0)
				at = 2
				wait.background_load()
				event.load_character(5, "e111_Halloween.gltf", "info", 9)
				event.set_character_active(9)
				event.attach_object_handle_to_character(1, 9)
				event.clear_object_sequence(1)
				event.set_object_sequence_object(1, 1)
				event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
				event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
				event.set_object_sequence_motion(1, "立ち", 4)
				event.load_character(5, "e111pikipiki.gltf", "info", 13)
				event.set_character_active(0, 13)
				event.set_character_position(13, 0.0, 0.0, 0.0)
				event.set_character_rotation(13, 0.0, 1.8, 0.0)
				event.load_character(5, "e111baku.gltf", "info", 14)
				event.set_character_active(0, 14)
				event.set_character_position(14, 0.0, 0.0, 0.0)
				event.set_character_rotation(14, 0.0, 1.8, 0.0)
				event.set_character_motion(14, "爆発", 5)
				event.set_current_directory("")
				cutscene_sound_id = event.load_sound_effect_file_2(1831) or cutscene_sound_id
				event.set_object_sequence_motion(1, "倒れ", 6)
				event.wait_object_sequence_motion_end(1)
				event.clear_camera_sequence()
				event.set_camera_sequence_position(229.93, 23.29, -84.91)
				event.set_camera_sequence_look_at(-23.55, 60.99, 1.2)
				event.mark_camera_sequence_fade_track()
				event.fade_in_camera_sequence(30)
				at = 3
				camera.wait_until_done()
				at = 4
				wait.for_frame_count(12)
				event.play_sound_effect(cutscene_sound_id, 18)
				at = 5
				object.wait_until_done(1)
				event.set_character_active(13)
				event.play_object_sequence_sound(1, cutscene_sound_id, 31)
				event.delay_object_sequence_sound_track(1, 20)
				event.play_object_sequence_sound(1, cutscene_sound_id, 32)
				event.delay_object_sequence_sound_track(1, 8)
				event.play_object_sequence_sound(1, cutscene_sound_id, 31)
				at = 6
				wait.for_frame_count(30)
				event.set_character_active(14)
				event.set_character_motion(14, "爆発", 6)
				at = 7
				wait.for_frame_count(10)
				event.play_sound_effect(cutscene_sound_id, 33)
				at = 8
				wait.for_frame_count(45)
				event.fade_out_music(90)
				event.fade_out_screen(30)
				at = 9
				wait.for_frame_count(30)
				at = 10
				wait.for_frame_count(60)
				event.stop_sound_effect(cutscene_sound_id, 31)
				event.stop_sound_effect(cutscene_sound_id, 32)
				event.stop_sound_effect(cutscene_sound_id, 33)
				event.set_character_active(0)
				event.set_scene_exit_flag(1)
				return table.pack()
			end
			event.stop_music(0)
			message.set_window_mode(0, 7)
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			at = 11
			wait.background_load()
			language_code = event.get_language() or language_code
			if language_code == 0 then
				event.load_message_file(0, 5, "e111.txt")
			else
				event.load_message_file(0, 5, "eng_e111.txt")
			end
			event.load_character_motion_pack(5, "e111_mints.gltf", "info", 0)
			event.set_character_position(0, 202.87, 0.0, -74.61)
			event.set_character_rotation(0, 0.0, -1.2, 0.0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 2)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 202.87, 0.0, -74.61)
			event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
			event.set_object_sequence_motion(0, "旧・立ち", 4, -1, 1)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.load_character(5, "e111_Halloween.gltf", "info", 9)
			event.set_character_active(9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(1, "立ち", 4)
			event.load_character(5, "e111_polcurse.gltf", "info", 10)
			event.set_character_active(10)
			event.attach_object_handle_to_character(2, 10)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_position(2, 0.0, 170.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "浮遊２", 4)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・こまり")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.load_character(5, "e111_pierrot.gltf", "info", 11)
			event.set_character_active(0, 11)
			event.attach_object_handle_to_character(3, 11)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(3, "立ち", 4)
			event.copy_character(5, 11, 12)
			event.set_character_active(0, 12)
			event.attach_object_handle_to_character(4, 12)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(4, "立ち", 4)
			event.load_character(5, "e111pikipiki.gltf", "info", 13)
			event.set_character_active(0, 13)
			event.set_character_position(13, 0.0, 0.0, 0.0)
			event.set_character_rotation(13, 0.0, 1.8, 0.0)
			event.load_character(5, "e111baku.gltf", "info", 14)
			event.set_character_active(0, 14)
			event.set_character_position(14, 0.0, 0.0, 0.0)
			event.set_character_rotation(14, 0.0, 1.8, 0.0)
			event.set_character_motion(14, "爆発", 5)
			event.load_character(5, "e111_hahen01.gltf", "info", 15)
			event.set_character_active(0, 15)
			event.set_character_position(15, 0.0, 0.0, 0.0)
			event.set_character_rotation(15, 0.0, 1.0, 0.0)
			event.attach_object_handle_to_character(7, 15)
			event.clear_object_sequence(7)
			event.set_object_sequence_object(7, 7)
			event.copy_character(5, 15, 16)
			event.set_character_active(0, 16)
			event.set_character_position(16, 0.0, 0.0, 0.0)
			event.set_character_rotation(16, 0.0, 3.0, 0.0)
			event.attach_object_handle_to_character(8, 16)
			event.clear_object_sequence(8)
			event.set_object_sequence_object(8, 8)
			event.load_character(5, "e111_hahen02.gltf", "info", 17)
			event.set_character_active(0, 17)
			event.set_character_position(17, 0.0, 0.0, 0.0)
			event.set_character_rotation(17, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_character(9, 17)
			event.clear_object_sequence(9)
			event.set_object_sequence_object(9, 9)
			event.set_current_directory("")
			cutscene_sound_id = event.load_sound_effect_file_2(1831) or cutscene_sound_id
			event.set_object_handle_sound_bank(2, cutscene_sound_id)
			event.set_object_handle_sound_bank(3, cutscene_sound_id)
			event.set_object_handle_sound_bank(4, cutscene_sound_id)
			event.set_object_handle_sound_bank(7, -1)
			event.set_object_handle_sound_bank(8, -1)
			event.set_object_handle_sound_bank(9, -1)
			event.attach_object_handle_to_character(5, 1)
			event.set_object_handle_visible(5, 0)
			event.attach_object_handle_to_character(6, 2)
			event.set_object_handle_visible(6, 0)
			event.set_object_sequence_motion(1, "倒れ", 6)
			event.wait_object_sequence_motion_end(1)
			event.enable_drama_skip()
			event.clear_camera_sequence()
			event.set_camera_sequence_position(315.53, 60.49, -68.59)
			event.set_camera_sequence_look_at(-19.71, 69.17, 0.25)
			event.mark_camera_sequence_fade_track()
			event.fade_in_camera_sequence(30)
			at = 12
			camera.wait_until_done()
			at = 13
			wait.for_frame_count(12)
			event.play_sound_effect(cutscene_sound_id, 18)
			at = 14
			object.wait_until_done(1)
			event.set_character_active(13)
			event.play_object_sequence_sound(1, cutscene_sound_id, 31)
			event.delay_object_sequence_sound_track(1, 20)
			event.play_object_sequence_sound(1, cutscene_sound_id, 32)
			event.delay_object_sequence_sound_track(1, 8)
			event.play_object_sequence_sound(1, cutscene_sound_id, 31)
			at = 15
			wait.for_frame_count(30)
			event.set_camera_sequence_position(44.03, 197.99, -10.5)
			event.set_camera_sequence_look_at(0.02, 199.41, -0.53)
			event.set_object_sequence_motion(2, "両手広げる", 6)
			event.queue_object_sequence_next_motion(2, "両手広げるL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			at = 16
			message.show_voiced(1110010)
			event.reset_mouth_texture_animations()
			at = 17
			object.wait_until_done(2)
			event.set_camera_sequence_position(238.32, 116.37, -106.27)
			event.set_camera_sequence_look_at(-6.37, 50.07, -17.02)
			event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
			event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
			event.set_object_sequence_motion(2, "抱き着き", 6)
			event.queue_object_sequence_next_motion(2, "抱き着きL", 4)
			event.set_object_handle_texture_animation(2, 0, "口・こまり")
			event.set_mouth_texture_animations(2, "口パク２", "口・こまり")
			at = 18
			message.show_voiced(1110020)
			event.reset_mouth_texture_animations()
			at = 19
			object.wait_until_done(2)
			event.set_camera_sequence_position(230.72, 15.98, -98.52)
			event.set_camera_sequence_look_at(28.12, 61.49, 12.32)
			event.set_character_active(0)
			event.set_character_active(14)
			event.set_character_motion(14, "爆発", 6)
			event.open_voice_stream_wave(1, 1110025)
			at = 20
			wait.for_frame_count(4)
			event.play_sound_effect(cutscene_sound_id, 33)
			at = 21
			voice_wait_frames = sound.wait_voice_stream_ready_counting(1)
			event.play_voice_stream(1)
			at = 22
			wait.for_frame_count(vm.i32(16 - voice_wait_frames))
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・フクザツ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(0, "爆発", 6)
			event.queue_object_sequence_next_motion(0, "爆発L", 4)
			at = 23
			wait.for_frame_count(60)
			event.close_voice_stream(1)
			event.set_camera_sequence_position(224.0, 20.06, -43.69)
			event.set_camera_sequence_look_at(253.55, 21.35, -49.32)
			event.set_object_sequence_position(0, 250.0, 0.0, -50.0)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "爆発L", 4, -1.0, 1)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
			event.set_character_active(0, 13)
			event.set_character_active(0, 14)
			event.set_character_active(1, 15)
			event.set_character_active(1, 16)
			event.set_character_active(1, 17)
			at = 24
			wait.for_frame_count(40)
			event.reset_object_sequence_motion(7)
			event.set_object_sequence_motion(7, "破片", 6)
			at = 25
			wait.for_frame_count(5)
			event.reset_object_sequence_motion(8)
			event.set_object_sequence_motion(8, "破片", 6)
			event.reset_object_sequence_motion(9)
			event.set_object_sequence_motion(9, "破片", 6)
			at = 26
			wait.for_frame_count(15)
			event.set_camera_sequence_position(47.2, 92.89, -142.19)
			event.set_camera_sequence_look_at(85.43, 16.34, 45.38)
			event.set_object_sequence_position(7, -22.38, 0.0, -1.68)
			event.set_object_sequence_position(8, -5.05, 0.0, -21.05)
			event.set_object_sequence_position(9, -0.08, 0.0, -45.14)
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "目・閉じ")
			event.set_object_sequence_texture_animation(2, 1, "口・こまり")
			event.set_character_active(10)
			event.set_character_visible(10, 1)
			event.set_object_sequence_rotation(2, 0.0, -2.08, 0.0)
			event.move_object_sequence_eased(2, 84.29, 0.0, 53.13, 40, 2, 0.2)
			event.set_object_sequence_motion(2, "倒れる", 6)
			event.queue_object_sequence_next_motion(2, "倒れるL", 4)
			event.move_object_sequence(7, 221.23, 0.0, 41.5, 80)
			at = 27
			wait.for_frame_count(5)
			event.move_object_sequence(8, 31.26, 0.0, 224.79, 68)
			event.move_object_sequence(9, 85.17, 0.0, 135.16, 60)
			at = 28
			wait.for_frame_count(2)
			event.play_sound_effect(cutscene_sound_id, 37)
			at = 29
			object.wait_until_done(2)
			at = 30
			wait.for_frame_count(30)
			event.set_camera_sequence_position(198.72, 10.01, -8.33)
			event.set_camera_sequence_look_at(245.11, 19.47, -50.58)
			event.set_object_sequence_motion(0, "ポルカスに近づく")
			event.set_object_sequence_motion_blend_step(0, 0.04)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			at = 31
			wait.for_frame_count(20)
			event.move_object_sequence_eased(0, 218.58, 0.0, -35.53, 40, 1, 0.4)
			at = 32
			wait.for_frame_count(47)
			event.set_camera_sequence_position(109.18, 34.69, -86.0)
			event.set_camera_sequence_look_at(83.61, 7.22, 47.83)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
			event.move_object_sequence(0, 77.52, 0.0, 8.58, 50)
			event.reset_object_sequence_motion(0)
			event.set_object_sequence_motion(0, "ポルカスに近づく", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "振り向く", 6)
			event.queue_object_sequence_next_motion(0, "振り向くL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 30)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・振り向き")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			at = 33
			wait.for_frame_count(40)
			at = 34
			message.show_voiced(1110038)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 35
			message.show_voiced(1110040)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(204.37, 31.72, 9.99)
			event.set_camera_sequence_look_at(264.2, 27.01, -5.8)
			event.set_character_active(11)
			event.set_character_active(12)
			event.set_object_sequence_position(3, 375.73, 0.0, -22.37)
			event.set_object_sequence_rotation(3, 0.0, -1.32, 0.0)
			event.move_object_sequence(3, 224.72, 0.0, 9.78, 30)
			event.set_object_sequence_motion(3, "走り", 4)
			event.set_object_sequence_position(4, 436.56, 0.0, -64.46)
			event.set_object_sequence_rotation(4, 0.0, -1.32, 0.0)
			event.move_object_sequence(4, 268.47, 0.0, -20.1, 30)
			event.set_object_sequence_motion(4, "走り", 4)
			event.set_object_sequence_motion_time(4, 5.7)
			at = 36
			object.wait_until_done(3)
			event.set_camera_sequence_position(80.24, 21.69, -11.79)
			event.set_camera_sequence_look_at(80.02, 22.6, 6.87)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 37
			message.show_voiced_for_stopping(1110050, -1)
			event.reset_mouth_texture_animations()
			event.set_camera_sequence_position(169.2, 49.46, -43.53)
			event.set_camera_sequence_look_at(78.35, 3.24, 42.02)
			event.set_object_sequence_motion(0, "こける", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "こけるL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・ビックリ")
			event.set_object_sequence_texture_animation(0, 1, "口・ビックリ")
			event.set_object_sequence_position(3, 139.55, 0.0, -50.54)
			event.set_object_sequence_rotation(3, 0.0, -0.24, 0.0)
			event.move_object_sequence(3, 112.86, 0.0, 70.42, 30)
			event.delay_object_sequence_rotation_track(3, 20)
			event.rotate_object_sequence(3, 0.0, -2.16, 0.0, 10)
			event.delay_object_sequence_motion_track(3, 30)
			event.set_object_sequence_motion(3, "立ち")
			event.set_object_sequence_position(4, 41.41, 0.0, -20.18)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(4, 68.8, 0.0, 44.59, 30)
			event.delay_object_sequence_rotation_track(4, 20)
			event.rotate_object_sequence(4, 0.0, 1.08, 0.0, 10)
			event.delay_object_sequence_motion_track(4, 30)
			event.set_object_sequence_motion(4, "立ち")
			event.open_voice_stream_wave(1, 1110055)
			at = 38
			sound.wait_voice_stream_ready(1)
			event.play_voice_stream(1)
			at = 39
			object.wait_until_done(3)
			at = 40
			object.wait_until_done(4)
			at = 41
			wait.for_frame_count(2)
			event.set_object_sequence_motion(2, "持ち上げ", 6)
			event.set_object_sequence_motion(3, "頭持ち上げ", 6)
			event.set_object_sequence_motion(4, "足持ち上げ", 6)
			at = 42
			wait.for_frame_count(78)
			event.close_voice_stream(1)
			event.set_object_sequence_motion(0, "見送る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "見送るL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・フクザツ")
			event.set_object_sequence_motion(2, "運ばれる")
			event.set_object_sequence_motion(3, "頭持ち歩きL")
			event.set_object_sequence_motion(4, "足持ち歩き")
			event.move_object_sequence_eased(2, 140.22, 0.0, -53.49, 60, 1, 0.1)
			event.move_object_sequence_eased(3, 174.0, 0.0, -35.88, 60, 1, 0.1)
			event.move_object_sequence_eased(4, 128.99, 0.0, -59.89, 60, 1, 0.1)
			at = 43
			message.show_voiced_for_stopping(1110075, 60)
			at = 44
			object.wait_until_done(2)
			event.set_camera_sequence_position(12.04, 19.34, -2.84)
			event.set_camera_sequence_look_at(163.83, 7.62, -48.59)
			event.set_object_sequence_position(0, 71.02, 0.0, -22.65)
			event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_position(2, 233.65, 0.0, -50.46)
			event.set_object_sequence_rotation(2, 0.0, -2.92, 0.0)
			event.set_object_sequence_position(3, 241.55, 0.0, -12.36)
			event.set_object_sequence_rotation(3, 0.0, -3.0, 0.0)
			event.set_object_sequence_position(4, 230.89, 0.0, -63.54)
			event.set_object_sequence_rotation(4, 0.0, 0.24, 0.0)
			event.move_object_sequence(2, 671.22, 0.0, -131.94, 160)
			event.move_object_sequence(3, 678.84, 0.0, -94.13, 160)
			event.move_object_sequence(4, 668.34, 0.0, -144.99, 160)
			at = 45
			message.show_voiced_for_stopping(1110075, 60)
			event.set_object_handle_texture_animation(0, 0, "口・フクザツ")
			event.set_mouth_texture_animations(0, "通常口パク", "口・フクザツ")
			at = 46
			message.show_voiced_for_stopping(1110080, 90)
			event.reset_mouth_texture_animations()
			at = 47
			object.wait_until_done(2)
			event.set_character_active(0, 10)
			event.set_character_active(0, 11)
			event.set_character_active(0, 12)
			event.set_camera_sequence_position(115.02, 23.5, 34.8)
			event.set_camera_sequence_look_at(83.65, 15.41, -18.49)
			event.set_object_sequence_position(0, 83.74, 0.0, -19.9)
			event.set_object_sequence_rotation(0, 0.0, 0.84, 0.0)
			event.set_object_sequence_motion(0, "立ちあがる", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "ため息", 6)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.delay_object_sequence_texture_animation_track(0, 34)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目パチ")
			event.set_object_sequence_texture_animation(0, 1, "口・ため息")
			event.open_voice_stream_wave(1, 1110085)
			at = 48
			sound.wait_voice_stream_ready(1)
			event.play_voice_stream(1)
			at = 49
			wait.for_frame_count(34)
			event.close_voice_stream(1)
			at = 50
			message.show_voiced(1110090)
			at = 51
			object.wait_until_done(0)
			event.set_camera_sequence_position(157.76, 23.5, -3.06)
			event.set_camera_sequence_look_at(61.27, 16.36, -2.61)
			event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
			event.set_object_sequence_motion(0, "振り返る", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "目・真剣")
			event.set_object_sequence_texture_animation(0, 1, "口・真剣")
			at = 52
			object.wait_until_done(0)
			at = 53
			wait.for_frame_count(30)
			event.set_camera_sequence_position(-430.32, 64.84, 57.91)
			event.set_camera_sequence_look_at(-921.56, 67.83, 181.76)
			event.move_camera_sequence(-526.57, 64.84, 82.17, -921.56, 67.83, 181.76, 120)
			at = 54
			camera.wait_until_done()
			event.set_camera_sequence_position(58.55, 16.4, 0.48)
			event.set_camera_sequence_look_at(82.64, 21.24, -20.55)
			event.set_object_handle_texture_animation(0, 0, "口・真剣")
			event.set_mouth_texture_animations(0, "通常口パク", "口・真剣")
			at = 55
			message.show_voiced(1110100)
			event.reset_mouth_texture_animations()
			event.start_crossfade(60)
			event.set_camera_sequence_position(69.71, 21.68, -9.26)
			event.set_camera_sequence_look_at(82.64, 24.57, -20.55)
			at = 56
			wait.for_frame_count(120)
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(30)
			at = 57
			camera.wait_until_done()
			return nil
		end, function(received: { any }): boolean
			if at <= 10 then
				return false
			end
			if at == 21 then
				voice_wait_frames = received[1] :: number
			end
			if at <= 11 then
				wait.background_load_skipping()
			end
			if at <= 12 then
				wait.skip_frame_count(12)
			end
			if at <= 13 then
				cutscene.skip_command(1)
			end
			if at <= 14 then
				wait.skip_frame_count(30)
			end
			if at <= 15 then
				message.show_voiced_skipping(1110010)
			end
			if at <= 16 then
				cutscene.skip_command(2)
			end
			if at <= 17 then
				message.show_voiced_skipping(1110020)
			end
			if at <= 18 then
				cutscene.skip_command(2)
			end
			if at <= 19 then
				wait.skip_frame_count(4)
			end
			if at <= 20 then
				voice_wait_frames = sound.wait_voice_stream_ready_counting_skipping(1)
			end
			if at <= 21 then
				wait.skip_frame_count(vm.i32(16 - voice_wait_frames))
			end
			if at <= 22 then
				wait.skip_frame_count(60)
			end
			if at <= 23 then
				wait.skip_frame_count(40)
			end
			if at <= 24 then
				wait.skip_frame_count(5)
			end
			if at <= 25 then
				wait.skip_frame_count(15)
			end
			if at <= 26 then
				wait.skip_frame_count(5)
			end
			if at <= 27 then
				wait.skip_frame_count(2)
			end
			if at <= 28 then
				cutscene.skip_command(2)
			end
			if at <= 29 then
				wait.skip_frame_count(30)
			end
			if at <= 30 then
				wait.skip_frame_count(20)
			end
			if at <= 31 then
				wait.skip_frame_count(47)
			end
			if at <= 32 then
				wait.skip_frame_count(40)
			end
			if at <= 33 then
				message.show_voiced_skipping(1110038)
			end
			if at <= 34 then
				message.show_voiced_skipping(1110040)
			end
			if at <= 35 then
				cutscene.skip_command(3)
			end
			if at <= 36 then
				message.show_voiced_for_stopping_skipping(1110050, -1)
			end
			if at <= 37 then
				cutscene.skip_command(1)
			end
			if at <= 38 then
				cutscene.skip_command(3)
			end
			if at <= 39 then
				cutscene.skip_command(4)
			end
			if at <= 40 then
				wait.skip_frame_count(2)
			end
			if at <= 41 then
				wait.skip_frame_count(78)
			end
			if at <= 42 then
				message.show_voiced_for_stopping_skipping(1110075, 60)
			end
			if at <= 43 then
				cutscene.skip_command(2)
			end
			if at <= 44 then
				message.show_voiced_for_stopping_skipping(1110075, 60)
			end
			if at <= 45 then
				message.show_voiced_for_stopping_skipping(1110080, 90)
			end
			if at <= 46 then
				cutscene.skip_command(2)
			end
			if at <= 47 then
				cutscene.skip_command(1)
			end
			if at <= 48 then
				wait.skip_frame_count(34)
			end
			if at <= 49 then
				message.show_voiced_skipping(1110090)
			end
			if at <= 50 then
				cutscene.skip_command(0)
			end
			if at <= 51 then
				cutscene.skip_command(0)
			end
			if at <= 52 then
				wait.skip_frame_count(30)
			end
			if at <= 53 then
				wait.background_load_skipping()
			end
			if at <= 54 then
				message.show_voiced_skipping(1110100)
			end
			if at <= 55 then
				wait.skip_frame_count(120)
			end
			if at <= 56 then
				wait.background_load_skipping()
			end
			return true
		end)
		if ret ~= nil then
			return
		end
	end
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.clear_event_battle_monsters(-1)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, -1)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.set_character_active(0)
	event.set_character_position(0, 83.74, 0.0, -19.9)
	event.set_character_rotation(0, 0.0, -1.32, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_action_character_motion(0)
	event.set_camera_position(209.67, 35.0, -52.16)
	event.set_camera_look_at(83.74, 30.0, -19.9)
	event.reset_follow_camera(0)
	event.load_map_sounds(1683)
	event.show_dungeon_status_bar(1)
	event.fade_in_screen(30)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_halloween_boss_intro

--- Starts the boss intro the first time the room is entered and the entrance cutscene afterwards.
function script.enter_boss_room()
	local intro_seen_flag: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		underground_water_channel_boss.load_sounds()
		intro_seen_flag = event.get_save_flag(10) or intro_seen_flag
		if intro_seen_flag == 0 then
			event.set_save_flag(10, 1)
			event.set_function_point_enabled("", "door01", 0)
			event.attach_object_handle_to_map_part_3(0, "p01_d01b01", "d01b01_2-a")
			event.set_object_handle_visible(0, 1)
			event.set_save_control_bits(1, 1)
			progress_step = 1
			play_halloween_boss_intro()
		else
			progress_step = 2
			play_entrance_cutscene()
		end
		return
	end, function(received: { any })
		if progress_step <= 2 then
			if progress_step <= 1 then
				progress_step = 2
				play_entrance_cutscene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.enter_boss_room

--- Asks whether to leave and moves on to the next floor if the player agrees.
function script.confirm_leave_boss_room()
	local choice: any = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	local is_trial_version: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_selection_top_line(0, 0)
	message.set_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	choice = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
	message.set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if choice == 0 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		stage_id = event.get_dungeon_stage_id() or stage_id
		current_floor = event.get_dungeon_floor() or current_floor
		next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		is_trial_version = event.is_trial_version() or is_trial_version
		if is_trial_version == 1 then
			event.set_scene_exit_flag(1)
			return
		else
			event.load_event_script("d01/d01.stb", 1000)
		end
	else
		choice = 1
	end
	event.finish_event()
end
script[510] = script.confirm_leave_boss_room

--- Reopens the door unless this is the trial version and plays the Halloween cutscene.
function script.start_halloween_cutscene()
	local is_trial_version: s32 = 0
	is_trial_version = event.is_trial_version() or is_trial_version
	if is_trial_version ~= 1 then
		event.set_function_point_enabled("", "door01", 1)
		event.attach_object_handle_to_map_part_3(0, "p01_d01b01", "d01b01_2-a")
		event.set_object_handle_visible(0, 0)
	end
	event.set_save_control_bits(1, 0)
	play_halloween_cutscene()
end
script[520] = script.start_halloween_cutscene

--- Shows the hint to aim for the boss's head.
function script.show_aim_for_head_hint()
	local language_code: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	message.set_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(0, "今だ！　頭をねらえ！")
	else
		event.open_message_window_2(0, "Hit his head now!")
	end
	message.show_and_wait(0, -1, 5, 0, 0)
	message.set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[530] = script.show_aim_for_head_hint

--- Shows how to lift a RoBomb with the shoulder and action buttons.
function script.show_robomb_lift_hint()
	local language_code: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	message.set_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(0, "[r1]と(O)ボタンで、鼻爆弾を持ち上げろ。")
	else
		event.open_message_window_2(0, "Lift the 'RoBomb' by\nholding down [r1] button & pressing (O) button.")
	end
	message.show_and_wait(0, -1, 5, 0, 0)
	message.set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[540] = script.show_robomb_lift_hint

--- Event 600, which map data, a script or the engine runs by number.
script.play_halloween_cutscene = play_halloween_cutscene
script[600] = script.play_halloween_cutscene

--- Runs the defeat sequence with its message.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_player_defeated

--- Resets the player and monsters at the start of the boss battle.
function script.restart_boss_battle()
	event.initialize_event()
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(30)
	event.set_character_active(0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.set_character_position(0, 213.76, 0.0, -35.13)
	event.set_character_rotation(0, 0.0, -1.36, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_dungeon_monster(25, 1)
	event.load_dungeon_monster(1000, 0)
	event.load_dungeon_monster(500, 0)
	event.place_dungeon_monster(500, 0, 0, 0, 0.0, 1.71, 0.0)
	event.fade_in_screen(30)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end
script[21020] = script.restart_boss_battle

return script
