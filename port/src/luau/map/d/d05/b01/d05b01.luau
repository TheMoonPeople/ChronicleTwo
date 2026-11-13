--!strict
--- Event script for the Gundor boss room, covering the horn gate, the Guiltoni awakening, growth, sword fight and explosion cutscenes, and the boss battle setup and defeat dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Stops the music and shows or hides the gate, tower parts and function points according to the story save flags.
local function refresh_boss_room_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5683)
	flag = event.get_save_flag(526) or flag
	if flag == 1 then
		event.set_function_point_enabled("d05", "func", 0)
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.set_function_point_enabled("p01", "invent_2023-1", 1)
	end
	flag_2 = event.get_save_flag(528) or flag_2
	if flag_2 == 0 then
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("", "e528", 0)
	end
end

--- Plays the short event where Mints and Monica stand side by side and say they cannot forgive.
local function play_party_anger_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(536, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		if playable_character == 3 then
			event.switch_dungeon_main_character(1)
			playable_character = 1
		end
		event.stop_music(0)
		event.load_map_sounds(5825)
		sound_bank = event.load_sound_effect_file_2(5825) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e536_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e536_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -9.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 9.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.65, 43.37)
		event.set_camera_sequence_look_at(0.0, 15.13, 108.54)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(1, "許せない", 6)
		event.queue_object_sequence_next_motion(1, "許せないL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5360100)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5360110)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 2)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
end

--- Plays the event where Mints blows the horn, then places the player at the room entrance and returns control.
local function play_horn_blowing_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	event.set_save_flag(526, 1)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 0 then
		event.switch_dungeon_main_character(0)
		playable_character = 0
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	sound_bank = event.load_sound_effect_file_2(5814) or sound_bank
	event.set_scene_status_flags(1, 0, 256, 1)
	event.change_directory("event/e500/e526/")
	event.load_message_file(0, 5, "e526.txt")
	event.load_character_motion_pack(5, "e526_mints.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "phorn.gltf", "info", 8)
	event.set_character_active(8)
	event.attach_character_to_frame(0, "item", 8)
	event.change_directory("")
	event.attach_object_handle_to_character(1, 1)
	event.attach_object_handle_to_character(2, 2)
	event.set_object_handle_visible(1, 0)
	event.set_object_handle_visible(2, 0)
	event.set_object_handle_position(0, 0.0, -30.0, 1500.0)
	event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_handle_motion(0, "ホーン吹く", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "ふき顔")
	event.set_object_handle_texture_animation(0, 1, "下向き目パチ")
	event.set_function_point_enabled("d05", "takil", 1)
	event.set_function_point_enabled("d05", "takir", 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(16.1, -10.46, 1474.52)
	event.set_camera_sequence_look_at(0.26, -9.87, 1496.35)
	event.move_camera_sequence_eased(30.06, -19.27, 1455.3, 2.31, -16.91, 1493.52, 60, 0, 1.0)
	event.play_sound_effect(sound_bank, 0)
	event.fade_in_screen(30)
	camera.wait_until_done()
	wait.for_frame_count(30)
	event.set_camera_sequence_position(0.0, 30.39, 1561.77)
	event.set_camera_sequence_look_at(0.0, -19.94, 1493.75)
	event.move_camera_sequence_eased(0.0, 30.39, 1561.77, 0.0, 11.85, 1493.75, 80, 0, 1.0)
	event.play_sound_effect(sound_bank, 1)
	event.set_object_sequence_motion(0, "ホーン持ち立ち", 4)
	camera.wait_until_done()
	wait.for_frame_count(30)
	event.set_camera_sequence_position(14.64, -10.25, 1472.02)
	event.set_camera_sequence_look_at(0.03, -10.34, 1496.41)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "おどろき顔")
	event.set_object_handle_texture_animation(0, 1, "おどろき目パチ")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced_for_stopping(5260010, 120)
	event.set_camera_sequence_position(0.0, 0.69, 877.16)
	event.set_camera_sequence_look_at(0.0, -9.03, 949.98)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
	event.set_object_handle_texture_animation(0, 1, "通常目パチ")
	wait.for_frame_count(90)
	event.stop_sound_effect(sound_bank, 1)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(2, 1)
	character.place_standing_and_reset_cloth(0.0, -30.0, 1500.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1500.0)
	event.set_camera_position(0.0, 10.0, 1600.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays the event where Guiltoni wakes up and draws his sword before the boss fight.
local function play_guiltoni_awakening_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local event_image: s32 = 0
	local section_step: number = 0
	vm.section(function()
		section_step = 1
		vm.entry(1)
		event.set_save_flag(528, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		event.stop_music(0)
		section_step = 2
		wait.for_frame_count(4)
		event.load_music(190)
		event.load_map_sounds(5817)
		sound_bank = event.load_sound_effect_file_2(5817) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e528/")
		event.load_message_file(0, 5, "e528.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e528_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
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
		event_image = event.load_event_image_4(5, "e528telop01.json", 0) or event_image
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e528telop01", event_image)
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
		if playable_character == 1 then
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
		event.set_object_handle_sound_bank(2, sound_bank)
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
		section_step = 3
		wait.for_frame_count(90)
		event.set_camera_sequence_position(23.71, 15.41, 365.52)
		event.set_camera_sequence_look_at(0.81, 20.88, 397.45)
		section_step = 4
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "半口")
		section_step = 5
		wait.for_frame_count(20)
		event.set_camera_sequence_position(0.0, 27.58, 241.33)
		event.set_camera_sequence_look_at(11.62, 31.84, 143.18)
		event.move_camera_sequence(0.0, 27.58, 241.33, -10.98, 31.84, 142.98, 60)
		section_step = 6
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-62.71, 22.94, -127.1)
		event.set_camera_sequence_look_at(-79.95, 18.68, -193.59)
		event.queue_object_sequence_next_motion(2, "気がつき", 6)
		event.queue_object_sequence_next_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		section_step = 7
		wait.for_frame_count(46)
		event.play_sound_effect(sound_bank, 2)
		section_step = 8
		wait.for_frame_count(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目左向き～前向き")
		section_step = 9
		object.wait_until_done(2)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-65.53, 36.67, -170.72)
		event.set_camera_sequence_look_at(-72.23, 31.54, -186.28)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 10
		message.show_voiced(5280010)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "左前見る", 6)
		event.queue_object_sequence_next_motion(0, "左前見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_step = 11
		message.show_voiced(5280020)
		event.set_camera_sequence_position(-72.45, 23.3, -129.48)
		event.set_camera_sequence_look_at(-72.45, 23.3, -169.9)
		event.play_music(0)
		event.play_sound_effect(sound_bank, 3)
		event.set_object_handle_frame_draw_flag(2, "sword--v0", 1)
		event.set_object_sequence_motion(2, "剣だし", 6)
		event.queue_object_sequence_next_motion(2, "剣だしL", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 12
		message.show_voiced(5280030)
		event.set_camera_sequence_position(-51.78, 20.26, -260.52)
		event.set_camera_sequence_look_at(-58.41, 20.26, -190.32)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_motion(2, "ジャンプ", 6)
		section_step = 13
		wait.for_frame_count(20)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_sequence_motion(0, "上見る", 6)
		event.queue_object_sequence_next_motion(0, "上見るL", 4)
		section_step = 14
		object.wait_until_done(0)
		event.set_camera_sequence_position(6.12, 32.14, 446.85)
		event.set_camera_sequence_look_at(-0.05, 14.21, 365.23)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "上見る戻り", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(2, 0.0, 0.0, 260.0)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地L", 4)
		section_step = 15
		object.wait_until_done(2)
		event.set_camera_sequence_position(9.03, 31.27, 338.8)
		event.set_camera_sequence_look_at(5.32, 18.96, 267.84)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "キメ", 6)
		event.queue_object_sequence_next_motion(2, "キメL", 4)
		event.play_sound_effect(sound_bank, 6)
		section_step = 16
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 7)
		section_step = 17
		object.wait_until_done(2)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 18
		message.show_voiced(5280040)
		event.start_crossfade(30)
		event.set_camera_sequence_position(1.63, 33.52, 291.68)
		event.set_camera_sequence_look_at(1.34, 31.08, 268.48)
		event.move_camera_sequence(5.68, 33.52, 291.63, 5.38, 31.08, 268.43, 120)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(2, 1, "わらい口とじ")
		section_step = 19
		wait.for_frame_count(90)
		event.fade_out_screen(30)
		section_step = 20
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if section_step <= 1 then
			local _ = playable_character ~= 0
			playable_character = 0
			wait.skip_frame_count(4)
		end
		if section_step <= 2 then
			wait.skip_frame_count(90)
		end
		if section_step <= 3 then
			cutscene.skip_command(0)
		end
		if section_step <= 4 then
			wait.skip_frame_count(20)
		end
		if section_step <= 5 then
			wait.background_load_skipping()
		end
		if section_step <= 6 then
			wait.skip_frame_count(46)
		end
		if section_step <= 7 then
			wait.skip_frame_count(30)
		end
		if section_step <= 8 then
			cutscene.skip_command(2)
		end
		if section_step <= 9 then
			message.show_voiced_skipping(5280010)
		end
		if section_step <= 10 then
			message.show_voiced_skipping(5280020)
		end
		if section_step <= 11 then
			message.show_voiced_skipping(5280030)
		end
		if section_step <= 12 then
			wait.skip_frame_count(20)
		end
		if section_step <= 13 then
			cutscene.skip_command(0)
		end
		if section_step <= 14 then
			cutscene.skip_command(2)
		end
		if section_step <= 15 then
			wait.skip_frame_count(30)
		end
		if section_step <= 16 then
			cutscene.skip_command(2)
		end
		if section_step <= 17 then
			message.show_voiced_skipping(5280040)
		end
		if section_step <= 18 then
			wait.skip_frame_count(90)
		end
		if section_step <= 19 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	section_step = 21
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

--- Plays the event where Guiltoni fights the party with his sword and knocks them back.
local function play_guiltoni_sword_fight_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local event_image: s32 = 0
	local section_step: number = 0
	vm.section(function()
		section_step = 1
		vm.entry(1)
		event.set_save_flag(532, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		event.stop_music(0)
		section_step = 2
		wait.for_frame_count(4)
		event.load_music(113)
		event.load_map_sounds(5820)
		sound_bank = event.load_sound_effect_file_2(5820) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e532_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
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
		event_image = event.load_event_image_4(5, "e532.json", 0) or event_image
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e53201", event_image)
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
		event.set_event_sprite_texture(1, "e53202", event_image)
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
		event.set_event_sprite_texture(2, "e53203", event_image)
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
		event.set_event_sprite_texture(3, "e53204", event_image)
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
		event.set_event_sprite_texture(4, "e53205", event_image)
		event.set_event_sprite_color(4, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(4, 0, 0, 512, 448)
		event.set_event_sprite_size(4, 512, 448)
		event.set_event_sprite_position(4, 256, 224)
		event.set_event_sprite_draw_pass(4, 1)
		event.attach_object_handle_to_sprite(9, 4)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 9)
		event.change_directory("")
		if playable_character == 1 then
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
		event.set_object_handle_sound_bank(2, sound_bank)
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
		section_step = 3
		message.show_voiced(5320010)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		section_step = 4
		wait.for_frame_count(40)
		event.set_camera_sequence_position(-3.92, 12.48, 46.35)
		event.set_camera_sequence_look_at(0.46, 18.98, 16.47)
		event.set_object_sequence_motion(2, "顔上げ", 6)
		event.queue_object_sequence_next_motion(2, "顔上げL", 4)
		section_step = 5
		object.wait_until_done(2)
		event.set_mouth_texture_animations(2, "苦し口パク")
		section_step = 6
		message.show_voiced(5320020)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_step = 7
		message.show_voiced(5320030)
		event.set_camera_sequence_look_at(0.0, 20.0, 50.0)
		event.set_camera_sequence_angle_height_distance(-0.36, 0.0, 100.0)
		event.move_camera_sequence_angle_height_distance_eased(2.64, 0.0, 100.0, 280, 2, 1.0)
		event.set_mouth_texture_animations(2, "苦し口パク")
		section_step = 8
		message.show_voiced(5320040)
		event.set_mouth_texture_animations(2, "苦し口パク")
		section_step = 9
		message.show_voiced(5320045)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_step = 10
		message.show_voiced(5320050)
		section_step = 11
		camera.wait_until_done()
		event.set_camera_sequence_position(16.36, 17.95, 32.78)
		event.set_camera_sequence_look_at(0.93, 19.2, 17.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目あき～目とじ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		section_step = 12
		message.show_voiced(5320060)
		event.set_mouth_texture_animations(2, "わらい口パク")
		section_step = 13
		message.show_voiced(5320065)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～苦し目あき")
		event.set_mouth_texture_animations(2, "わらい口パク")
		section_step = 14
		message.show_voiced(5320070)
		event.set_camera_sequence_position(16.15, 37.27, 153.71)
		event.set_camera_sequence_look_at(3.58, 24.38, 96.09)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_step = 15
		message.show_voiced(5320080)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "起きあがりL", 4)
		section_step = 16
		wait.for_frame_count(30)
		event.set_object_sequence_motion(1, "起きあがり", 6)
		event.queue_object_sequence_next_motion(1, "起きあがりL", 4)
		section_step = 17
		wait.for_frame_count(15)
		event.set_camera_sequence_position(-84.02, 9.18, -188.66)
		event.set_camera_sequence_look_at(-99.08, 9.86, -193.29)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.play_sound_effect(sound_bank, 3)
		section_step = 18
		object.wait_until_done(1)
		section_step = 19
		wait.for_frame_count(20)
		event.set_camera_sequence_position(-23.98, 12.62, 43.97)
		event.set_camera_sequence_look_at(-1.29, 22.54, 7.67)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 20
		message.show_voiced(5320090)
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
		section_step = 21
		message.show_voiced_for_stopping(5320100, 40)
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
		event.play_object_sequence_sound(1, sound_bank, 4)
		event.delay_object_sequence_sound_track(1, 50)
		event.play_object_sequence_sound(1, sound_bank, 6)
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
		event.play_object_sequence_sound(9, sound_bank, 5)
		section_step = 22
		wait.for_frame_count(5)
		section_step = 23
		message.show_voiced_for_stopping(5320110, 20)
		section_step = 24
		wait.for_frame_count(5)
		section_step = 25
		message.show_voiced_for_stopping(5320120, 40)
		section_step = 26
		object.wait_until_done(1)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_sequence_motion(0, "モニカ！！", 6)
		event.queue_object_sequence_next_motion(0, "モニカ！！L", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		section_step = 27
		message.show_voiced(5320130)
		section_step = 28
		object.wait_until_done(0)
		event.set_camera_sequence_position(-18.95, 19.99, -37.66)
		event.set_camera_sequence_look_at(-30.66, 14.75, -65.72)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(1, "しゃがみにらみ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "しゃがみにらみL", 4)
		section_step = 29
		object.wait_until_done(1)
		section_step = 30
		wait.for_frame_count(20)
		event.set_camera_sequence_position(-57.1, 14.78, -90.75)
		event.set_camera_sequence_look_at(-21.25, 17.36, -33.53)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "後ろ見", 6)
		event.queue_object_sequence_next_motion(2, "後ろ見L", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 31
		message.show_voiced(5320140)
		section_step = 32
		object.wait_until_done(2)
		event.set_camera_sequence_position(0.0, 27.09, 35.56)
		event.set_camera_sequence_look_at(0.0, 29.67, -20.86)
		event.play_music(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "笑う", 4)
		event.delay_object_sequence_motion_track(2, 140)
		event.set_object_sequence_motion(2, "笑う2")
		event.delay_object_sequence_texture_animation_track(2, 140)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目～大わらい目")
		event.set_object_sequence_texture_animation(2, 1, "大わらい口パク")
		section_step = 33
		message.show_voiced_for_stopping(5320150, -1)
		section_step = 34
		wait.for_frame_count(10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "大わらい目～通常目")
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_motion(2, "戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		section_step = 35
		message.show_voiced(5320155)
		section_step = 36
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "前向き～右向き")
		event.set_object_sequence_motion(1, "立つ", 2)
		event.queue_object_sequence_next_motion(1, "立つL", 4)
		event.delay_object_sequence_sound_track(1, 4)
		event.play_object_sequence_sound(1, sound_bank, 10)
		event.set_mouth_texture_animations(1, "通常口パク")
		section_step = 37
		message.show_voiced(5320160)
		section_step = 38
		object.wait_until_done(1)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり")
		event.set_object_sequence_motion(0, "バトル立ち2", 4)
		section_step = 39
		wait.for_frame_count(40)
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
		section_step = 40
		message.show_voiced(5320170)
		section_step = 41
		camera.wait_until_done()
		event.set_environment_music_volume(0.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 42
		message.show_voiced(5320180)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 43
		message.show_voiced(5320190)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 44
		message.show_voiced(5320200)
		section_step = 45
		object.wait_until_done(3)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 46
		message.show_voiced(5320210)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 47
		message.show_voiced(5320220)
		section_step = 48
		object.wait_until_done(4)
		event.set_object_sequence_color(3, 128, 128, 128, 0)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 49
		message.show_voiced(5320225)
		section_step = 50
		object.wait_until_done(5)
		event.set_object_sequence_color(4, 128, 128, 128, 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 51
		message.show_voiced(5320230)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 52
		message.show_voiced(5320240)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 53
		message.show_voiced(5320245)
		section_step = 54
		object.wait_until_done(6)
		event.set_object_sequence_color(5, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 55
		message.show_voiced(5320250)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 56
		message.show_voiced(5320260)
		section_step = 57
		object.wait_until_done(7)
		event.set_object_sequence_color(6, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 0, 30)
		event.set_environment_music_volume(1.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 58
		message.show_voiced(5320270)
		section_step = 59
		object.wait_until_done(7)
		event.set_mouth_texture_animations(2, "通常口パク")
		section_step = 60
		message.show_voiced(5320275)
		section_step = 61
		vm.wait(61)
		section_step = 62
		vm.wait(62)
	end, function(received: { any }): boolean
		if section_step <= 1 then
			local _ = playable_character ~= 0
			playable_character = 0
			wait.skip_frame_count(4)
		end
		if section_step <= 2 then
			message.show_voiced_skipping(5320010)
		end
		if section_step <= 3 then
			wait.skip_frame_count(40)
		end
		if section_step <= 4 then
			cutscene.skip_command(2)
		end
		if section_step <= 5 then
			message.show_voiced_skipping(5320020)
		end
		if section_step <= 6 then
			message.show_voiced_skipping(5320030)
		end
		if section_step <= 7 then
			message.show_voiced_skipping(5320040)
		end
		if section_step <= 8 then
			message.show_voiced_skipping(5320045)
		end
		if section_step <= 9 then
			message.show_voiced_skipping(5320050)
		end
		if section_step <= 10 then
			wait.background_load_skipping()
		end
		if section_step <= 11 then
			message.show_voiced_skipping(5320060)
		end
		if section_step <= 12 then
			message.show_voiced_skipping(5320065)
		end
		if section_step <= 13 then
			message.show_voiced_skipping(5320070)
		end
		if section_step <= 14 then
			message.show_voiced_skipping(5320080)
		end
		if section_step <= 15 then
			wait.skip_frame_count(30)
		end
		if section_step <= 16 then
			wait.skip_frame_count(15)
		end
		if section_step <= 17 then
			cutscene.skip_command(1)
		end
		if section_step <= 18 then
			wait.skip_frame_count(20)
		end
		if section_step <= 19 then
			message.show_voiced_skipping(5320090)
		end
		if section_step <= 20 then
			message.show_voiced_for_stopping_skipping(5320100, 40)
		end
		if section_step <= 21 then
			wait.skip_frame_count(5)
		end
		if section_step <= 22 then
			message.show_voiced_for_stopping_skipping(5320110, 20)
		end
		if section_step <= 23 then
			wait.skip_frame_count(5)
		end
		if section_step <= 24 then
			message.show_voiced_for_stopping_skipping(5320120, 40)
		end
		if section_step <= 25 then
			cutscene.skip_command(1)
		end
		if section_step <= 26 then
			message.show_voiced_skipping(5320130)
		end
		if section_step <= 27 then
			cutscene.skip_command(0)
		end
		if section_step <= 28 then
			cutscene.skip_command(1)
		end
		if section_step <= 29 then
			wait.skip_frame_count(20)
		end
		if section_step <= 30 then
			message.show_voiced_skipping(5320140)
		end
		if section_step <= 31 then
			cutscene.skip_command(2)
		end
		if section_step <= 32 then
			message.show_voiced_for_stopping_skipping(5320150, -1)
		end
		if section_step <= 33 then
			wait.skip_frame_count(10)
		end
		if section_step <= 34 then
			message.show_voiced_skipping(5320155)
		end
		if section_step <= 35 then
			cutscene.skip_command(2)
		end
		if section_step <= 36 then
			message.show_voiced_skipping(5320160)
		end
		if section_step <= 37 then
			cutscene.skip_command(1)
		end
		if section_step <= 38 then
			wait.skip_frame_count(40)
		end
		if section_step <= 39 then
			message.show_voiced_skipping(5320170)
		end
		if section_step <= 40 then
			wait.background_load_skipping()
		end
		if section_step <= 41 then
			message.show_voiced_skipping(5320180)
		end
		if section_step <= 42 then
			message.show_voiced_skipping(5320190)
		end
		if section_step <= 43 then
			message.show_voiced_skipping(5320200)
		end
		if section_step <= 44 then
			cutscene.skip_command(3)
		end
		if section_step <= 45 then
			message.show_voiced_skipping(5320210)
		end
		if section_step <= 46 then
			message.show_voiced_skipping(5320220)
		end
		if section_step <= 47 then
			cutscene.skip_command(4)
		end
		if section_step <= 48 then
			message.show_voiced_skipping(5320225)
		end
		if section_step <= 49 then
			cutscene.skip_command(5)
		end
		if section_step <= 50 then
			message.show_voiced_skipping(5320230)
		end
		if section_step <= 51 then
			message.show_voiced_skipping(5320240)
		end
		if section_step <= 52 then
			message.show_voiced_skipping(5320245)
		end
		if section_step <= 53 then
			cutscene.skip_command(6)
		end
		if section_step <= 54 then
			message.show_voiced_skipping(5320250)
		end
		if section_step <= 55 then
			message.show_voiced_skipping(5320260)
		end
		if section_step <= 56 then
			cutscene.skip_command(7)
		end
		if section_step <= 57 then
			message.show_voiced_skipping(5320270)
		end
		if section_step <= 58 then
			cutscene.skip_command(7)
		end
		if section_step <= 59 then
			message.show_voiced_skipping(5320275)
		end
		return true
	end)
	section_step = 63
	vm.entry(63)
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

--- Plays the event where Guiltoni laughs, casts a spell and grows into a giant, and the party decides to fight.
local function play_guiltoni_growth_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local event_image: s32 = 0
	local music_number: s32 = 0
	vm.section(function()
		event.set_save_flag(532, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		event.load_map_sounds(5822)
		sound_bank = event.load_sound_effect_file_2(5822) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e532_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
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
		event.load_character(5, "e532_m_guil.gltf", "p00_23a", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(10, 13)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 10)
		event.load_character(5, "e532_kawaru_hikari.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e532_guil_kage.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.load_character(5, "e532_tgate_f.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.load_character(5, "e532_tgate_h.gltf", "info", 18)
		event.set_character_active(0, 18)
		event_image = event.load_event_image_4(5, "e532telop01.json", 0) or event_image
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e532telop01", event_image)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 347)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(12, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 12)
		event.change_directory("")
		event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 19)
		event.set_character_active(0, 19)
		if playable_character == 1 then
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e532/e532_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
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
		event.set_object_handle_position(0, 0.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_position(1, -34.13, 0.0, -72.15)
		event.set_object_handle_rotation(1, 0.0, 0.46, 0.0)
		event.set_object_handle_motion(1, "立つL", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "下向き立ち", 4)
		event.step_object_handle_motion(2)
		event.reset_object_handle_dynamic_animation(2)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ")
		event.set_object_handle_position(10, 48.15, 0.0, -39.92)
		event.set_object_handle_rotation(10, 0.0, -0.96, 0.0)
		event.set_object_handle_motion(10, "立ち2", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1.0, 31.0, 23.46)
		event.set_camera_sequence_look_at(1.0, 31.0, 1.39)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320380)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320390)
		event.set_camera_sequence_position(32.47, 29.12, 7.82)
		event.set_camera_sequence_look_at(-0.08, 29.06, 7.66)
		event.move_camera_sequence_eased(32.49, 29.12, 2.2, -0.05, 29.06, 2.04, 90, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320400)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320410)
		camera.wait_until_done()
		event.set_camera_sequence_position(-11.1, 23.74, 47.57)
		event.set_camera_sequence_look_at(-11.12, 23.68, 10.21)
		event.move_camera_sequence_eased(1.26, 23.74, 47.57, 1.24, 23.68, 10.2, 120, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320420)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(5320430)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(5320435)
		camera.wait_until_done()
		event.set_camera_sequence_position(21.93, 20.24, 29.75)
		event.set_camera_sequence_look_at(0.34, 28.43, 3.64)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あき")
		event.set_object_sequence_motion(2, "普通立ちへ", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(5320440)
		object.wait_until_done(2)
		event.set_camera_sequence_position(21.31, 32.88, -28.93)
		event.set_camera_sequence_look_at(15.92, 30.08, 1.51)
		event.move_camera_sequence_eased(11.89, 32.88, -30.6, 6.5, 30.08, -0.16, 90, 2, 1.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(5320450)
		camera.wait_until_done()
		event.set_camera_sequence_position(21.93, 20.24, 29.75)
		event.set_camera_sequence_look_at(0.34, 28.43, 3.64)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320460)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(5320465)
		event.play_sound_effect(sound_bank, 13)
		event.rotate_object_sequence(2, 0.0, 2.04, 0.0, 12)
		event.move_object_sequence(2, 112.86, 0.0, -57.4, 120)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 120)
		event.set_object_sequence_motion(2, "立ち")
		wait.for_frame_count(12)
		event.set_camera_sequence_position(12.52, 143.33, 237.6)
		event.set_camera_sequence_look_at(19.7, 10.27, 44.27)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		object.wait_until_done(2)
		wait.for_frame_count(5)
		event.set_camera_sequence_position(193.83, 30.9, -96.26)
		event.set_camera_sequence_look_at(115.38, 26.4, -60.1)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, 1.54, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		wait.for_frame_count(5)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_sequence_motion(2, "魔法構え", 2)
		event.queue_object_sequence_next_motion(2, "魔法構えL", 4)
		object.wait_until_done(2)
		event.play_sound_effect(sound_bank, 15)
		event.set_character_active(1, 17)
		event.set_character_position(17, 112.86, 0.0, -57.4)
		event.set_character_rotation(17, 0.0, 2.04, 0.0)
		event.set_character_motion(17, "魔法構えL", 6)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(93.61, 28.03, 33.84)
		event.set_camera_sequence_look_at(141.27, 27.9, -88.39)
		event.move_camera_sequence_eased(139.2, 30.07, -23.94, 196.24, 29.95, -119.09, 60, 2, 0.4)
		event.set_character_active(1, 18)
		event.set_character_position(18, 177.89, 30.0, -88.76)
		event.set_character_rotation(18, 0.0, 0.0, 0.0)
		event.set_character_motion(18, "発生", 6)
		wait.for_frame_count(10)
		event.set_character_active(1, 19)
		event.set_character_position(19, 177.89, 30.0, -88.76)
		event.set_character_rotation(19, 0.0, 0.0, 0.0)
		event.set_character_visible(19, 1, 1, 0.1)
		camera.wait_until_done()
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-83.46, 20.24, 40.29)
		event.set_camera_sequence_look_at(25.57, 18.02, -14.67)
		event.set_object_sequence_position(0, -34.9, 0.0, 31.89)
		event.set_object_sequence_rotation(0, 0.0, 2.18, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -54.15, 0.0, 12.15)
		event.set_object_sequence_rotation(1, 0.0, 2.02, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_object_sequence(2, 149.89, 0.0, -76.07, 40)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 40)
		object.wait_until_done(2)
		event.set_camera_sequence_position(195.01, 15.44, -79.93)
		event.set_camera_sequence_look_at(159.74, 21.63, -83.99)
		event.stop_music(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目～くるし目")
		event.play_sound_effect(sound_bank, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(1, 15)
		event.set_character_visible(15, 1, 1, 0.033333335)
		event.set_character_position(15, 161.48, 0.0, -80.57)
		event.set_character_rotation(15, 0.0, 2.04, 0.0)
		event.set_object_sequence_motion(2, "うぐっ", 6)
		event.queue_object_sequence_next_motion(2, "頭抱え", 6)
		event.queue_object_sequence_next_motion(2, "頭抱えL", 4)
		event.play_object_sequence_sound(2, sound_bank, 17)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, sound_bank, 18)
		event.delay_object_sequence_texture_animation_track(2, 30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目パチ")
		event.set_object_sequence_texture_animation(2, 1, "口とじ～大口")
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(185.9, 26.26, -83.55)
		event.set_camera_sequence_look_at(160.82, 28.01, -82.54)
		event.move_camera_sequence_eased(225.88, 13.42, -85.2, 160.83, 18.04, -82.53, 60, 0, 1.0)
		event.set_mouth_texture_animations(2, "苦し口パク")
		message.show_voiced(5320480)
		object.wait_until_done(2)
		camera.wait_until_done()
		event.set_camera_sequence_position(-153.15, 54.88, 77.9)
		event.set_camera_sequence_look_at(-32.02, 26.4, 15.61)
		event.move_camera_sequence_eased(-153.15, 54.88, 77.9, -32.02, 93.93, 15.61, 60, 0, 1.0)
		message.show_voiced(5320490)
		camera.wait_until_done()
		event.set_camera_sequence_position(-45.58, 18.39, -25.71)
		event.set_camera_sequence_look_at(-44.29, 20.81, 21.82)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320500)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.set_camera_sequence_position(152.29, 17.2, -116.31)
		event.set_camera_sequence_look_at(169.35, 16.15, -86.33)
		event.move_camera_sequence_look_at(163.62, 23.13, -83.64, 120)
		event.move_camera_sequence_angle_height_distance_eased(1.42, -8.07, 36.58, 90, 0, 1.0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目パチ")
		event.set_object_sequence_motion(2, "苦しむ", 6)
		event.queue_object_sequence_next_motion(2, "苦しむL", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, sound_bank, 20)
		message.show_voiced(5320510)
		message.show_voiced(5320515)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目とじ")
		event.set_mouth_texture_animations(2, "苦し口パク")
		message.show_voiced(5320520)
		camera.wait_until_done()
		event.set_camera_sequence_position(-65.76, 1.45, 77.12)
		event.set_camera_sequence_look_at(-31.95, 23.15, 22.39)
		event.set_object_sequence_position(0, -54.15, 0.0, 12.15)
		event.set_object_sequence_rotation(0, 0.0, 2.02, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -34.9, 0.0, 31.89)
		event.set_object_sequence_rotation(1, 0.0, 2.18, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320530)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320540)
		event.set_camera_sequence_position(27.41, 54.66, -24.03)
		event.set_camera_sequence_look_at(-38.65, 16.14, 19.92)
		event.move_camera_sequence_eased(27.41, 88.01, -24.03, -38.65, 16.14, 19.92, 60, 2, 1.0)
		event.play_sound_effect(sound_bank, 21)
		event.set_character_active(0, 15)
		event.set_character_active(0, 11)
		event.set_character_active(1, 16)
		event.set_character_position(16, 98.8, 0.0, -70.68)
		event.set_character_rotation(16, 0.0, 2.16, 0.0)
		event.set_character_motion(16, "伸びる", 6)
		event.set_object_sequence_motion(0, "ギル巨大化", 6)
		event.queue_object_sequence_next_motion(0, "ギル巨大化L", 4)
		event.set_object_sequence_motion(1, "ギル巨大化", 6)
		event.start_background_file_loads_1("snd2/bgm/bg_035.sound.json")
		wait.background_load()
		event.load_music_pack(35)
		camera.wait_until_done()
		event.set_character_active(0, 16)
		event.play_music(0)
		event.set_camera_sequence_position(-201.41, 27.8, 185.21)
		event.set_camera_sequence_look_at(-35.48, 67.52, 28.17)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.stop_sound_effect(sound_bank, 16)
		event.set_character_active(1, 13)
		wait.for_frame_count(10)
		event.play_sound_effect(sound_bank, 22)
		event.set_object_sequence_motion(8, "攻撃１", 6)
		event.queue_object_sequence_next_motion(8, "攻撃１ループ", 4)
		wait.for_frame_count(4)
		event.set_object_sequence_motion(0, "よける", 6)
		event.set_object_sequence_motion(1, "後ろ飛び", 6)
		event.wait_object_sequence_motion_end(1)
		object.wait_until_done(1)
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-36.53, 21.01, 90.55)
		event.set_camera_sequence_look_at(-110.73, 24.73, 53.44)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.play_sound_effect(sound_bank, 23)
		event.set_object_sequence_position(0, -130.27, 0.0, 15.93)
		event.set_object_sequence_motion(0, "バトル立ち2", 4, -1.0, 1)
		event.set_object_sequence_position(1, -64.55, 0.0, 84.34)
		event.set_object_sequence_motion(1, "戦うしか", 4, -1.0, 1)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(1, "戦うしかユリス見", 2)
		event.queue_object_sequence_next_motion(1, "戦うしかユリス見L", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320550)
		event.set_object_sequence_motion(1, "上見へ", 2)
		event.queue_object_sequence_next_motion(1, "上見へL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320560)
		event.set_camera_sequence_position(-247.3, 94.84, 129.46)
		event.set_camera_sequence_look_at(-110.28, 94.53, 54.08)
		event.move_camera_sequence(-217.34, 94.84, 112.98, -110.28, 94.53, 54.08, 120)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(8, "立ち", 4)
		wait.for_frame_count(90)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 16)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 35 then
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(35)
		event.play_music(0)
	end
	event.set_event_sprite_draw_pass(0, 0)
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
	event.delete_character(11)
	event.delete_character(13)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

--- Plays the event where Guiltoni is engulfed in an explosion of light and collapses.
local function play_guiltoni_explosion_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local section_step: number = 0
	vm.section(function()
		section_step = 1
		vm.entry(1)
		event.set_save_flag(536, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		if playable_character == 3 then
			event.switch_dungeon_main_character(1)
			playable_character = 1
		end
		event.stop_music(0)
		section_step = 2
		wait.for_frame_count(4)
		event.load_music(52)
		event.load_map_sounds(5823)
		sound_bank = event.load_sound_effect_file_2(5823) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e536_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e536_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e536_guiltoni.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e536_m_guil.gltf", "p00_23a", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e536_guilbaku.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.load_character(5, "e536_guilbaku1.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.load_character(5, "e536_hikari.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.load_character(5, "e536_hikari1.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e536_guil_hikari.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 6)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -10.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 10.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(2, "倒れ", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目とじ")
		event.set_object_handle_position(3, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "グォオー", 4)
		event.set_character_position(12, 0.0, 50.0, -50.0)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_position(13, 0.0, 50.0, -18.0)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.set_character_active(1, 12)
		event.set_character_motion(12, "グォオー", 6)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "グォオー", 6)
		event.play_sound_effect(sound_bank, 2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 150.0, 65.9)
		event.set_camera_sequence_look_at(0.0, 150.0, -23.0)
		event.move_camera_sequence_eased(0.0, 123.2, 330.45, 0.0, 123.57, -23.0, 90, 0, 0.3)
		event.fade_in_screen(30)
		section_step = 3
		wait.for_frame_count(80)
		event.set_character_visible(11, 0, 1, 0.1)
		section_step = 4
		camera.wait_until_done()
		event.set_character_active(0, 13)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(45.36, 6.79, 49.62)
		event.set_camera_sequence_look_at(-2.61, 16.71, 101.94)
		event.set_wind(10, 0.0, 0.0, 1.0)
		event.set_character_active(1, 14)
		event.set_character_position(14, 19.99, 0.0, 122.09)
		event.set_character_rotation(14, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		section_step = 5
		object.wait_until_done(1)
		section_step = 6
		wait.for_frame_count(20)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(4.04, 16.09, 159.94)
		event.set_camera_sequence_look_at(4.04, 13.4, 71.43)
		event.set_character_active(0, 11)
		event.set_character_active(1, 10)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 15.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		section_step = 7
		wait.for_frame_count(20)
		event.set_character_visible(15, 0, 1, 0.033333335)
		event.set_wind(-1)
		section_step = 8
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "爆発戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		section_step = 9
		object.wait_until_done(1)
		section_step = 10
		wait.for_frame_count(6)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 46)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, 10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(1, 46)
		event.rotate_object_sequence(1, 0.0, -2.78, 0.0, 10)
		section_step = 11
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(0, 46)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		section_step = 12
		wait.for_frame_count(15)
		event.set_camera_sequence_position(13.0, 9.86, -79.62)
		event.set_camera_sequence_look_at(13.0, 12.67, -39.5)
		event.move_camera_sequence_eased(0.0, 9.86, -79.62, 0.0, 12.67, -39.5, 60, 2, 1.0)
		event.play_music(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_position(2, 13.0, 0.0, -50.0)
		event.reset_object_sequence_dynamic_animation(2)
		section_step = 13
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目～こまり目下")
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(1, "しゃがみ", 6)
		event.queue_object_sequence_next_motion(1, "しゃがみL", 4)
		section_step = 14
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "しゃがむ", 6)
		event.queue_object_sequence_next_motion(0, "しゃがむL", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ")
		event.set_mouth_texture_animations(1, "通常口パク")
		section_step = 15
		message.show_voiced(5360010)
		event.set_mouth_texture_animations(2, "くるし口パク")
		section_step = 16
		message.show_voiced(5360020)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ")
		event.set_object_sequence_motion(2, "ぐふっ", 2)
		event.queue_object_sequence_next_motion(2, "倒れ", 4)
		event.set_mouth_texture_animations(2, "くるし口パク")
		section_step = 17
		message.show_voiced(5360025)
		section_step = 18
		sound.play_voice_line_stopping(5360030, -1)
		section_step = 19
		camera.wait_until_done()
		event.set_camera_sequence_position(16.76, 57.33, -49.41)
		event.set_camera_sequence_look_at(4.01, 12.67, -49.87)
		event.move_camera_sequence_eased(11.95, 41.94, -49.58, 4.01, 12.67, -49.87, 150, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目～くるし目２")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_mouth_texture_animations(2, "くるし口パク")
		section_step = 20
		message.show_voiced(5360040)
		event.set_mouth_texture_animations(2, "くるし口パク")
		section_step = 21
		message.show_voiced(5360045)
		section_step = 22
		camera.wait_until_done()
		event.play_sound_effect(sound_bank, 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目２～通常目")
		event.set_object_handle_texture_animation(2, 1, "わらい口")
		event.set_object_sequence_motion(2, "モニカ見", 2)
		event.queue_object_sequence_next_motion(2, "モニカ見L", 4)
		section_step = 23
		object.wait_until_done(2)
		section_step = 24
		wait.for_frame_count(60)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "ゆっくり目とじ")
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_motion(2, "死に", 2)
		event.wait_object_sequence_motion_end(2)
		section_step = 25
		object.wait_until_done(2)
		section_step = 26
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-6.98, 9.03, -75.58)
		event.set_camera_sequence_look_at(0.96, 12.16, -49.21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(1, "通常口パク")
		section_step = 27
		message.show_voiced(5360050)
		event.set_camera_sequence_position(-0.18, 28.97, 146.9)
		event.set_camera_sequence_look_at(9.44, 29.01, 60.59)
		event.move_camera_sequence(-2.36, 28.97, 166.44, 9.44, 29.01, 60.59, 150)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(1, 16)
		event.set_character_position(16, 0.0, 0.0, -50.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "発動・ギル光の粒", 6)
		event.queue_object_sequence_next_motion(4, "ループ・ギル光の粒", 4)
		event.fade_out_music(150)
		section_step = 28
		wait.for_frame_count(30)
		event.fade_out_screen(120, 255, 255, 255)
		section_step = 29
		wait.for_frame_count(120)
	end, function(received: { any }): boolean
		if section_step <= 1 then
			local _ = playable_character == 2
			playable_character = 0
			local _ = playable_character == 3
			playable_character = 1
			wait.skip_frame_count(4)
		end
		if section_step <= 2 then
			wait.skip_frame_count(80)
		end
		if section_step <= 3 then
			wait.background_load_skipping()
		end
		if section_step <= 4 then
			cutscene.skip_command(1)
		end
		if section_step <= 5 then
			wait.skip_frame_count(20)
		end
		if section_step <= 6 then
			wait.skip_frame_count(20)
		end
		if section_step <= 7 then
			wait.skip_frame_count(20)
		end
		if section_step <= 8 then
			cutscene.skip_command(1)
		end
		if section_step <= 9 then
			wait.skip_frame_count(6)
		end
		if section_step <= 10 then
			wait.skip_frame_count(10)
		end
		if section_step <= 11 then
			wait.skip_frame_count(15)
		end
		if section_step <= 12 then
			cutscene.skip_command(1)
		end
		if section_step <= 13 then
			cutscene.skip_command(0)
		end
		if section_step <= 14 then
			message.show_voiced_skipping(5360010)
		end
		if section_step <= 15 then
			message.show_voiced_skipping(5360020)
		end
		if section_step <= 16 then
			message.show_voiced_skipping(5360025)
		end
		if section_step <= 17 then
			sound.play_voice_for_skipping(5360030, -1)
		end
		if section_step <= 18 then
			wait.background_load_skipping()
		end
		if section_step <= 19 then
			message.show_voiced_skipping(5360040)
		end
		if section_step <= 20 then
			message.show_voiced_skipping(5360045)
		end
		if section_step <= 21 then
			wait.background_load_skipping()
		end
		if section_step <= 22 then
			cutscene.skip_command(2)
		end
		if section_step <= 23 then
			wait.skip_frame_count(60)
		end
		if section_step <= 24 then
			cutscene.skip_command(2)
		end
		if section_step <= 25 then
			wait.skip_frame_count(60)
		end
		if section_step <= 26 then
			message.show_voiced_skipping(5360050)
		end
		if section_step <= 27 then
			wait.skip_frame_count(30)
		end
		if section_step <= 28 then
			wait.skip_frame_count(120)
		end
		return true
	end)
	section_step = 30
	vm.entry(30)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.refresh_boss_room_scene = refresh_boss_room_scene
script[99] = script.refresh_boss_room_scene

--- Refreshes the room scene and places the player at the entrance.
function script.default_event()
	event.initialize_event()
	event.fade_out_screen(0)
	refresh_boss_room_scene()
	event.take_memory_card_load_state()
	vm.wait(1)
	character.place_standing_and_reset_cloth(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1600.0)
	event.set_camera_position(0.0, 10.0, 1700.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_party_anger_event

--- Tells a non-fighting character that the gate cannot be used, otherwise asks whether to leave and returns to the overworld.
function script.talk_to_exit_gate()
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
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "前のフロアに戻りますか？")
	answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	event.set_message_draw_speed(0, 0)
	if answer == 0 then
		event.fade_out_screen(15)
		wait.for_frame_count(15)
		event.load_event_script("d05/d05.stb", 1000)
	end
	event.finish_event()
end
script[200] = script.talk_to_exit_gate

--- Opens the menu with a fade.
function script.open_menu()
	menu.open_type_7()
	event.finish_event()
end
script[400] = script.open_menu

--- Lets the player confirm and use the horn item on the gate to start the horn blowing event.
function script.examine_horn_gate()
	local active_character: s32 = 0
	local trigger_state: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end
	trigger_state = event.get_triggered_event_data_2(6) or trigger_state
	if trigger_state == 1 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		confirmed = message.ask_confirmation(0, 2507, 5, 256, 208, confirmed)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			trigger_state = 2
		end
	end
	if trigger_state == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.for_frame_count(6)
		event.open_use_item_menu(354)
		vm.wait(5)
		item = vmhost.used_item() or item
		if item == 354 then
			event.set_function_point_enabled("d05", "func", 0)
			event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
			event.set_object_handle_visible(0, 0)
			event.set_function_point_enabled("p01", "invent_2023-1", 1)
			play_horn_blowing_event()
			return
		elseif item <= 0 then
			event.finish_event()
		else
			character.shake_head()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.for_frame_count(6)
	end
	event.finish_event()
end
script[500] = script.examine_horn_gate

--- Fades out, plays the Guiltoni awakening event, then loads the second-phase boss monster and places the player in front of it.
function script.cutscene_guiltoni_awakening()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.set_save_control_bits(1, 1)
		event.fade_out_screen(15)
		progress = 1
		wait.for_frame_count(15)
		event.set_function_point_enabled("", "e528", 0)
		progress = 2
		play_guiltoni_awakening_event()
		progress = 3
		vm.wait(3)
		event.load_dungeon_monster(512, 1)
		event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		character.place_standing_and_reset_cloth(0.0, 0.0, 300.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 400.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end, function(received: { any })
		if progress <= 3 then
			if progress <= 1 then
				progress = 2
				play_guiltoni_awakening_event()
				return vm.continue_with(function()
					progress = 3
					vm.wait(3)
					event.load_dungeon_monster(512, 1)
					event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					character.place_standing_and_reset_cloth(0.0, 0.0, 300.0, vm.f32(3.14))
					event.set_camera_look_at(0.0, 30.0, 300.0)
					event.set_camera_position(0.0, 40.0, 400.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(15)
					event.finish_event()
					return
				end)
			end
			cutscene.ignore_coordinates(0.0, 0.0, 300.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end
script[550] = script.cutscene_guiltoni_awakening

--- Resets the party, plays the Guiltoni sword fight event and loads the following map.
function script.cutscene_guiltoni_sword_fight()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(15)
		progress = 1
		wait.for_frame_count(15)
		event.clear_event_battle_monsters(-1)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.set_party_member(3, 1)
		event.set_character_change_enabled(3, 1)
		event.set_character_change_unmasked(3, 1)
		progress = 2
		play_guiltoni_sword_fight_event()
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 500)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				progress = 2
				play_guiltoni_sword_fight_event()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[560] = script.cutscene_guiltoni_sword_fight

--- Plays the Guiltoni growth event and sets up the room with the grown boss.
function script.cutscene_guiltoni_growth()
	event.clear_event_running_flag()
	play_guiltoni_growth_event()
	event.set_function_point_enabled("", "e528", 0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("p01", "invent_2023-1", 1)
	event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
	event.set_object_handle_translation(0, -330.0, 0.0, 200.0)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
	event.set_object_handle_translation(0, 330.0, 0.0, 200.0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.set_character_position(0, 0.0, 0.0, 300.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_position(0.0, 40.0, 420.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end
script[561] = script.cutscene_guiltoni_growth

--- Fades out the music and screen, plays the Guiltoni explosion event and loads the following map.
function script.cutscene_guiltoni_explosion()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(0)
		event.fade_out_screen(15)
		progress = 1
		wait.for_frame_count(15)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		progress = 2
		play_guiltoni_explosion_event()
		event.set_dungeon_floor_info(4, 22, 5, 2)
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 510)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				progress = 2
				play_guiltoni_explosion_event()
				return vm.continue_with(function()
					event.set_dungeon_floor_info(4, 22, 5, 2)
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[570] = script.cutscene_guiltoni_explosion

--- Plays the party anger event and opens the georama editor.
function script.cutscene_party_anger_then_georama()
	event.set_save_control_bits(1, 0)
	event.clear_event_running_flag()
	play_party_anger_event()
	event.go_to_georama_edit(3, 500)
end
script[571] = script.cutscene_party_anger_then_georama

--- Starts the battle music and places the first-phase boss monster.
function script.start_first_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(35)
	event.play_music(0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end
script[600] = script.start_first_boss_battle

--- Plays a random defeat dialogue chosen by the story progress flags.
function script.on_party_defeated()
	local roll: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(532) or flag
		flag_2 = event.get_save_flag(536) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			roll = 0
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				progress = 1
				dungeon.handle_defeat_voiced(0, 8540060)
			else
				progress = 2
				dungeon.handle_defeat_voiced(0, 8540070)
			end
			return
		end
		flag_3 = event.get_save_flag(528) or flag_3
		if flag_3 ~= 0 and flag == 0 then
			roll = 0
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				progress = 3
				dungeon.handle_defeat_voiced(0, 8530100)
			else
				progress = 4
				dungeon.handle_defeat_voiced(0, 8530110)
			end
			return
		end
		progress = 5
		dungeon.handle_defeat_silent(0)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				dungeon.skip_defeat_sequence_voiced(0, 8540070)
			end
			return 0
		end
		if progress <= 4 then
			if progress <= 3 then
				dungeon.skip_defeat_sequence_voiced(0, 8530110)
			end
			return 0
		end
		if progress <= 5 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_party_defeated

--- Stops the music and plays the horn blowing event.
function script.skip_horn_blowing()
	event.stop_music(0)
	play_horn_blowing_event()
end
script[15260] = script.skip_horn_blowing

--- Event 15280, which map data, a script or the engine runs by number.
script.play_guiltoni_awakening_event = play_guiltoni_awakening_event
script[15280] = script.play_guiltoni_awakening_event

--- Plays the Guiltoni sword fight event and loads the following map.
function script.skip_guiltoni_sword_fight()
	play_guiltoni_sword_fight_event()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 500)
end
script[15320] = script.skip_guiltoni_sword_fight

--- Plays the Guiltoni explosion event and loads the following map.
function script.skip_guiltoni_explosion()
	play_guiltoni_explosion_event()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 510)
end
script[15360] = script.skip_guiltoni_explosion

--- Starts the second battle music and places the second-phase boss monster.
function script.start_second_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(190)
	event.play_music(0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(512, 1)
	event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end
script[25020] = script.start_second_boss_battle

return script
