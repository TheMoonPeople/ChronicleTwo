--!strict
--- Event script for the Zelmite Mine boss floor, covering the blocking rock, the boss battle setup, the defeat dialogue and the ending scene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local wait = require("@lib/event/wait")

--- Stops the music, loads the map sounds and removes the blocking rock once the boss has been defeated.
local function initialize_boss_room()
	local boss_defeated_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8693)
	boss_defeated_flag = event.get_save_flag(820) or boss_defeated_flag
	if boss_defeated_flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p04")
		event.set_object_handle_visible(0, 0)
		event.set_function_point_enabled("p04", "func", 0)
	end
end

--- Shows the boss arena, plays the battle music and places the player and the boss monster.
local function start_boss_battle()
	event.initialize_event()
	event.fade_out_screen(0)
	event.attach_object_handle_to_map_part_2(0, "p06")
	event.set_object_handle_visible(0, 1)
	event.stop_music(0)
	wait.for_frame_count(6)
	event.load_music(40)
	event.play_music(0)
	event.load_dungeon_monster(629, 1)
	event.load_dungeon_monster(630, 0)
	event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
	character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
	event.set_camera_look_at(438.61, 30.0, 192.19)
	event.set_camera_position(590.29, 39.11, 243.1)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	vm.wait(2)
	event.finish_event()
end

--- Plays the scene in which the buggy blows up the blocking rock.
local function play_buggy_explosion_scene()
	local active_chr_no: s32 = 0
	local sound_effect: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(816, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.stop_music(0)
		wait.for_frame_count(6)
		event.load_music(111)
		event.play_music(0)
		event.load_map_sounds(8809)
		sound_effect = event.load_sound_effect_file_2(8809) or sound_effect
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e816/")
		event.load_message_file(0, 5, "e816.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e816_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e816_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e816_majin.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e816telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e816telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e200/e206/e206_bbaku.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_map_part_2(4, "p04")
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_visible(4, 1)
		event.set_object_handle_position(0, 772.29, -72.1, 1522.76)
		event.set_object_handle_rotation(0, 0.0, -2.64, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, -1000.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_scale(2, 8.0, 8.0, 8.0)
		event.set_character_position(11, 974.5, 0.34, 1616.44)
		event.set_character_rotation(11, 0.0, 1.32, 0.0)
		event.set_character_scale(11, 1.0, 1.0, 1.0)
		if active_chr_no == 0 then
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		else
			event.set_character_active(0, 0)
		end
		event.enable_drama_skip()
		event.delay_object_sequence_position_track(0, 20)
		event.move_object_sequence(0, 850.58, -72.1, 1669.29, 40)
		event.delay_object_sequence_rotation_track(0, 20)
		event.rotate_object_sequence(0, 0.0, 0.52, 0.0, 8)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(988.97, 77.53, 1641.42)
		event.set_camera_sequence_look_at(768.43, -42.14, 1535.48)
		event.fade_in_screen(30)
		wait.for_frame_count(20)
		event.play_sound_effect(sound_effect, 0)
		wait.for_frame_count(50)
		event.stop_sound_effect(sound_effect, 0)
		event.play_sound_effect(sound_effect, 1)
		event.shake_camera_sequence_vertically(0.0, 1.0, 0.0, 50)
		event.set_character_active(11)
		event.set_character_motion(11, "ｴﾌｪｸﾄ_バギー爆発", 6)
		wait.for_frame_count(10)
		event.set_object_handle_visible(4, 0)
		event.set_object_sequence_rotation(0, 0.0, -2.6, 0.0)
		wait.for_frame_count(40)
		event.move_object_sequence(0, 805.68, -72.1, 1578.18, 90)
		event.set_object_sequence_motion(0, "歩き")
		object.wait_until_done(0)
		event.set_camera_sequence_position(526.21, 180.7, 925.23)
		event.set_camera_sequence_look_at(591.71, 28.27, 1249.82)
		if active_chr_no == 0 then
			event.set_character_active(1, 8)
			event.set_character_active(1, 9)
		else
			event.set_character_active(1, 0)
		end
		event.set_object_sequence_position(0, 647.7, -69.42, 1336.0)
		event.set_object_sequence_rotation(0, 0.0, -2.48, 0.0)
		event.move_object_sequence(0, 594.08, -64.59, 1267.87, 90)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, 642.51, -70.56, 1362.06)
		event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
		event.move_object_sequence(1, 586.91, -65.57, 1291.72, 90)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(0)
		event.set_camera_sequence_position(680.66, 6.68, 980.64)
		event.set_camera_sequence_look_at(575.95, -0.27, 930.94)
		event.move_camera_sequence_eased(680.66, 6.68, 980.64, 608.93, 31.74, 882.58, 40, 0, 0.4)
		camera.wait_until_done()
		event.move_camera_sequence_eased(680.66, 6.68, 980.64, 576.22, 34.02, 919.65, 14, 2, 0.2)
		camera.wait_until_done()
		wait.for_frame_count(30)
		event.set_camera_sequence_position(577.41, -36.52, 1231.62)
		event.set_camera_sequence_look_at(593.55, -49.69, 1286.96)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_motion(0, "指さす", 6)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_effect, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160010)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160015)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160020)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-175.42, 20.69, 292.74)
		event.set_camera_sequence_look_at(-130.55, 18.84, 404.37)
		event.fade_out_music(60)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(0, 30.86, -3.88, 469.02)
		event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
		event.move_object_sequence(0, -163.18, 0.0, 334.91, 50)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 6)
		event.set_object_sequence_motion(0, "キョロキョロ", 4)
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(1, 73.45, -7.05, 525.46)
		event.set_object_sequence_rotation(1, 0.0, -2.12, 0.0)
		event.move_object_sequence(1, -116.94, 0.0, 392.73, 60)
		event.delay_object_sequence_rotation_track(1, 50)
		event.rotate_object_sequence(1, 0.0, 2.84, 0.0, 10)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		wait.for_frame_count(20)
		message.show_voiced(8160030)
		message.show_voiced(8160035)
		event.set_camera_sequence_position(57.5, 40.21, 529.52)
		event.set_camera_sequence_look_at(-184.49, 8.41, 336.31)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, -182.92, 0.0, 359.09)
		event.set_object_sequence_rotation(1, 0.0, -2.36, 0.0)
		event.set_object_sequence_position(2, -367.65, 0.0, 193.54)
		event.set_object_sequence_rotation(2, 0.0, 0.9, 0.0)
		event.set_object_sequence_motion(2, "ふってくる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_sound_effect(sound_effect, 3)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "ドスン", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "着地振動", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.shake_camera_sequence(0.0, 8.0, 0.0, 40)
		wait.for_frame_count(20)
		event.move_camera_sequence_eased(57.5, 40.21, 529.52, -184.49, 99.45, 336.31, 60, 0, 0.2)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 20)
		camera.wait_until_done()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		wait.for_frame_count(30)
		event.set_event_sprite_draw_pass(0, 0)
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-201.98, 60.97, 306.62)
		event.set_camera_sequence_look_at(-164.55, 1.55, 356.48)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160040)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160050)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160060)
		event.set_camera_sequence_look_at(-332.71, 270.78, 221.57)
		event.set_camera_sequence_angle_height_distance(0.43, -34.0, 115.0)
		event.move_camera_sequence_angle_height_distance_eased(1.54, -34.0, 115.0, 200, 0, 0.2)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160070)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160080)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160090)
		camera.wait_until_done()
		event.set_camera_sequence_position(-314.29, 515.61, 172.37)
		event.set_camera_sequence_look_at(-286.23, 270.78, 236.95)
		event.play_sound_effect(sound_effect, 4)
		event.set_object_sequence_motion(2, "覗き込み会話", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 4, "覗き込み会話とまり", 0)
		message.show_voiced(8160100)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
		message.show_voiced(8160105)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160110)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
		message.show_voiced(8160120)
		event.play_sound_effect(sound_effect, 5)
		event.set_object_sequence_motion(2, "一歩前へ", 6)
		event.queue_object_sequence_next_motion(2, "一歩前へＬ", 4)
		object.wait_until_done(2)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(39)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.stop_sound_effect(sound_effect, 1)
	event.stop_sound_effect(sound_effect, 2)
	event.stop_sound_effect(sound_effect, 3)
	event.stop_sound_effect(sound_effect, 4)
	event.stop_sound_effect(sound_effect, 5)
	event.set_object_handle_visible(4, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_motion_blur(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.stop_music(0)
	wait.for_frame_count(6)
	event.load_music(40)
	event.play_music(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Plays the scene in which the majin shrinks.
local function play_majin_shrink_scene()
	local active_chr_no: s32 = 0
	local sound_effect: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(820, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.stop_music(0)
		event.load_map_sounds(8811)
		sound_effect = event.load_sound_effect_file_2(8811) or sound_effect
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e820/")
		event.load_message_file(0, 5, "e820.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e820_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e820_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e820_majin.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -125.17, 0.0, -85.85)
		event.set_object_handle_rotation(0, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -128.34, 0.0, -68.5)
		event.set_object_handle_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -352.78, 0.0, -122.42)
		event.set_object_handle_rotation(2, 0.0, 0.72, 0.0)
		event.set_object_handle_scale(2, 8.0, 8.0, 8.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(2, "縮む", 6)
		event.wait_object_sequence_motion_end(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-95.35, 412.01, -39.79)
		event.set_camera_sequence_look_at(-253.9, 198.62, -86.06)
		event.play_sound_effect(sound_effect, 0)
		event.fade_in_screen(30)
		message.show_voiced(8200010)
		object.wait_until_done(2)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-57.24, 82.46, -60.42)
		event.set_camera_sequence_look_at(-126.19, 22.03, -77.1)
		event.move_camera_sequence_eased(-57.24, 4.84, -60.42, -126.19, 22.03, -77.1, 90, 0, 1.0)
		message.show_voiced(8200020)
		message.show_voiced(8200030)
		message.show_voiced(8200040)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向く会話", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		message.show_voiced(8200045)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		message.show_voiced(8200050)
		object.wait_until_done(1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_motion_blur(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Plays the ending movie, shows the closing image and fades out on a button press.
local function play_ending_movie()
	local block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	wait.for_frame_count(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.play_movie(5, "movie/end2.mp4")
	vm.wait(2)
	event.set_pause_enabled(0)
	block = event.load_event_image_4(5, "textures/event/e800/e824/e82401.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e82401", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	wait.for_frame_count(90)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait.for_frame_count(30)
end

--- Skips the waits that follow the ending movie.
local function wait_after_ending()
	wait.skip_frame_count(6)
	wait.skip_frame_count(90)
	local _ = party.get_change_state_skipping(0)
	wait.skip_frame_count(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded; nothing needs preparing.
function script.setup() end

script.initialize_boss_room = initialize_boss_room
script[99] = script.initialize_boss_room

--- Places the player at the floor entrance and fades in.
function script.default_event()
	initialize_boss_room()
	character.place_standing(vm.f32(972.08), vm.f32(-72.14), vm.f32(1770.23), vm.f32(-2.36))
	event.set_camera_look_at(972.08, -42.14, 1770.23)
	event.set_camera_position(1061.01, -40.06, 1860.38)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button event with nothing.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.start_boss_battle = start_boss_battle
script[151] = script.start_boss_battle

--- Moves the camera look-at to the origin and waits until the button is pressed.
function script.reset_camera_and_wait_for_button()
	event.set_camera_look_at(0.0, 0.0, 0.0)
	vm.wait(1)
	wait.until_button_pressed(32)
end
script[152] = script.reset_camera_and_wait_for_button

--- Asks whether to return to the dungeon floors and loads them on a yes.
function script.ask_leave_boss_floor()
	local active_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_leave_boss_floor

--- Examines the rock in the way, lets the player use the buggy item on it and starts the boss battle when it works.
function script.examine_blocking_rock()
	local active_character: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local used_item: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				resume_point = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				resume_point = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.reset_action_character_motion(0)
		interaction_state = event.get_triggered_event_data_2(6) or interaction_state
		if interaction_state == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "大きな岩が道をふさいでいる。\n（(#)ボタンでメニューを開く）")
			resume_point = 3
			confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if confirmed == 1 then
				interaction_state = 2
			end
		end
		if interaction_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			resume_point = 4
			wait.for_frame_count(6)
			event.open_use_item_menu(173)
			resume_point = 5
			vm.wait(5)
			used_item = vmhost.used_item() or used_item
			if used_item == 173 then
				event.fade_out_music(20)
				event.fade_out_screen(20)
				resume_point = 6
				wait.for_frame_count(20)
				event.set_function_point_enabled("p04", "func", 0)
				resume_point = 7
				play_buggy_explosion_scene()
				resume_point = 8
				vm.wait(8)
				event.initialize_event()
				event.attach_object_handle_to_map_part_2(0, "p05")
				event.set_object_handle_visible(0, 1)
				event.attach_object_handle_to_map_part_2(1, "p06")
				event.set_object_handle_visible(1, 1)
				event.set_save_control_bits(1, 1)
				event.load_dungeon_monster(629, 1)
				event.load_dungeon_monster(630, 0)
				event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
				character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				event.set_camera_look_at(438.61, 30.0, 192.19)
				event.set_camera_position(590.29, 39.11, 243.1)
				event.reset_follow_camera(0)
				event.fade_in_screen(30)
				event.finish_event()
			elseif used_item <= 0 then
			else
				resume_point = 9
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			resume_point = 10
			wait.for_frame_count(6)
		end
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_point <= 10 then
			if resume_point == 3 then
				confirmed = received[2] :: number
			end
			if resume_point <= 3 then
				local _ = interaction_state == 1
				interaction_state = 2
				wait.skip_frame_count(6)
			end
			if resume_point <= 5 then
				wait.skip_frame_count(20)
			end
			if resume_point <= 6 then
				resume_point = 7
				play_buggy_explosion_scene()
				return vm.continue_with(function()
					resume_point = 8
					vm.wait(8)
					event.initialize_event()
					event.attach_object_handle_to_map_part_2(0, "p05")
					event.set_object_handle_visible(0, 1)
					event.attach_object_handle_to_map_part_2(1, "p06")
					event.set_object_handle_visible(1, 1)
					event.set_save_control_bits(1, 1)
					event.load_dungeon_monster(629, 1)
					event.load_dungeon_monster(630, 0)
					event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
					character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
					event.set_camera_look_at(438.61, 30.0, 192.19)
					event.set_camera_position(590.29, 39.11, 243.1)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					event.show_dungeon_status_bar(1, 0.16666667)
					resume_point = 10
					wait.for_frame_count(6)
					event.set_dungeon_pause_flags(1, 0)
					event.finish_event()
					return
				end)
			end
			if resume_point <= 8 then
				cutscene.ignore_coordinates(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				character.resume_shake_head()
			end
			if resume_point <= 9 then
				wait.skip_frame_count(6)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.examine_blocking_rock

--- Clears the battle, hides the arena and plays the boss defeat, shrink and ending scenes.
function script.cutscene_boss_defeated_ending()
	local active_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		resume_point = 1
		wait.for_frame_count(20)
		event.clear_event_battle_monsters(-1)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.attach_object_handle_to_map_part_2(0, "p05")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p06")
		event.set_object_handle_visible(1, 0)
		event.set_save_control_bits(1, 0)
		resume_point = 2
		play_majin_shrink_scene()
		resume_point = 3
		play_ending_movie()
		event.set_scene_exit_flag(1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				resume_point = 2
				play_majin_shrink_scene()
				return vm.continue_with(function()
					resume_point = 3
					play_ending_movie()
					event.set_scene_exit_flag(1)
					return
				end)
			end
			if resume_point <= 2 then
				wait_after_ending()
			end
			return 0
		end
		return nil
	end)
end
script[510] = script.cutscene_boss_defeated_ending

--- Picks the defeat dialogue by progress flags and a random roll.
function script.on_defeat_dialogue()
	local progress_flag: s32 = 0
	local boss_defeated_flag: s32 = 0
	local random_roll: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		progress_flag = event.get_save_flag(816) or progress_flag
		boss_defeated_flag = event.get_save_flag(820) or boss_defeated_flag
		if progress_flag ~= 0 and boss_defeated_flag == 0 then
			random_roll = 0
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				resume_point = 1
				dungeon.handle_defeat_voiced(0, 8600060)
			else
				resume_point = 2
				dungeon.handle_defeat_voiced(0, 8600070)
			end
			return
		end
		resume_point = 3
		dungeon.handle_defeat_silent(0)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				dungeon.skip_defeat_sequence_voiced(0, 8600070)
			end
			return 0
		end
		if resume_point <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_defeat_dialogue

--- Event 18160, which map data, a script or the engine runs by number.
script.play_buggy_explosion_scene = play_buggy_explosion_scene
script[18160] = script.play_buggy_explosion_scene

--- Plays the majin shrink scene, the ending movie and then ends the scene.
function script.cutscene_majin_shrink_and_ending()
	play_majin_shrink_scene()
	play_ending_movie()
	event.set_scene_exit_flag(1)
end
script[18200] = script.cutscene_majin_shrink_and_ending

script[28020] = script.start_boss_battle

return script
