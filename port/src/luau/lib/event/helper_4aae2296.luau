--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_4aae2296()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(528, 1)
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
		event.load_music(190)
		event.load_map_sounds(5817)
		var1 = event.load_sound_effect_file_2(5817) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e528/")
		event.load_message_file(0, 5, "e528_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e528_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e528_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e528_guiltoni.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e528telop01_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e528telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 347)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 5)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e528/e528_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e528/e528_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 0.0, 0.0, 500.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -100.0, 0.0, -200.0)
		event.set_object_handle_rotation(1, 0.0, 2.54, 0.0)
		event.set_object_handle_motion(1, "倒れ", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_position(2, -73.0, 0.0, -190.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "しゃがみ", 4)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "左向き目パチ")
		event.enable_drama_skip()
		event.move_object_sequence(0, 0.0, 0.0, 400.0, 120)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(224.74, 194.1, 112.15)
		event.set_camera_sequence_look_at(119.89, 90.28, 320.08)
		event.fade_in_screen(30)
		at = 3
		wait_frames(90)
		event.set_camera_sequence_position(23.71, 15.41, 365.52)
		event.set_camera_sequence_look_at(0.81, 20.88, 397.45)
		at = 4
		wait_objects(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "半口")
		at = 5
		wait_frames(20)
		event.set_camera_sequence_position(0.0, 27.58, 241.33)
		event.set_camera_sequence_look_at(11.62, 31.84, 143.18)
		event.move_camera_sequence(0.0, 27.58, 241.33, -10.98, 31.84, 142.98, 60)
		at = 6
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-62.71, 22.94, -127.1)
		event.set_camera_sequence_look_at(-79.95, 18.68, -193.59)
		event.queue_object_sequence_next_motion(2, "気がつき", 6)
		event.queue_object_sequence_next_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 7
		wait_frames(46)
		event.play_sound_effect(var1, 2)
		at = 8
		wait_frames(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目左向き～前向き")
		at = 9
		wait_objects(2)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-65.53, 36.67, -170.72)
		event.set_camera_sequence_look_at(-72.23, 31.54, -186.28)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 10
		helper_4116e6bb(5280010)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "左前見る", 6)
		event.queue_object_sequence_next_motion(0, "左前見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 11
		helper_4116e6bb(5280020)
		event.set_camera_sequence_position(-72.45, 23.3, -129.48)
		event.set_camera_sequence_look_at(-72.45, 23.3, -169.9)
		event.play_music(0)
		event.play_sound_effect(var1, 3)
		event.set_object_handle_frame_draw_flag(2, "sword--v0", 1)
		event.set_object_sequence_motion(2, "剣だし", 6)
		event.queue_object_sequence_next_motion(2, "剣だしL", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 12
		helper_4116e6bb(5280030)
		event.set_camera_sequence_position(-51.78, 20.26, -260.52)
		event.set_camera_sequence_look_at(-58.41, 20.26, -190.32)
		event.play_sound_effect(var1, 4)
		event.set_object_sequence_motion(2, "ジャンプ", 6)
		at = 13
		wait_frames(20)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_sequence_motion(0, "上見る", 6)
		event.queue_object_sequence_next_motion(0, "上見るL", 4)
		at = 14
		wait_objects(0)
		event.set_camera_sequence_position(6.12, 32.14, 446.85)
		event.set_camera_sequence_look_at(-0.05, 14.21, 365.23)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "上見る戻り", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.play_sound_effect(var1, 5)
		event.set_object_sequence_position(2, 0.0, 0.0, 260.0)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地L", 4)
		at = 15
		wait_objects(2)
		event.set_camera_sequence_position(9.03, 31.27, 338.8)
		event.set_camera_sequence_look_at(5.32, 18.96, 267.84)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "キメ", 6)
		event.queue_object_sequence_next_motion(2, "キメL", 4)
		event.play_sound_effect(var1, 6)
		at = 16
		wait_frames(30)
		event.play_sound_effect(var1, 7)
		at = 17
		wait_objects(2)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 18
		helper_4116e6bb(5280040)
		event.start_crossfade(30)
		event.set_camera_sequence_position(1.63, 33.52, 291.68)
		event.set_camera_sequence_look_at(1.34, 31.08, 268.48)
		event.move_camera_sequence(5.68, 33.52, 291.63, 5.38, 31.08, 268.43, 120)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(2, 1, "わらい口とじ")
		at = 19
		wait_frames(90)
		event.fade_out_screen(30)
		at = 20
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			active_chr_no = 0
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(90)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			wait_frames_skipping(20)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			wait_frames_skipping(46)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			helper_238b5abc(2)
		end
		if at <= 9 then
			helper_8cd371d7(5280010)
		end
		if at <= 10 then
			helper_8cd371d7(5280020)
		end
		if at <= 11 then
			helper_8cd371d7(5280030)
		end
		if at <= 12 then
			wait_frames_skipping(20)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			helper_238b5abc(2)
		end
		if at <= 17 then
			helper_8cd371d7(5280040)
		end
		if at <= 18 then
			wait_frames_skipping(90)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 21
	vm.entry(21)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

return helper_4aae2296
