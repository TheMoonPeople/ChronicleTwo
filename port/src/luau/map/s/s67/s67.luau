--!strict
--- Event script for the map where the moon breaks, covering the scene with the sun, Dedeath and Andrea before the jump to the next map.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the player characters, the sun, the dark genie, Andrea, Dedeath and the moon-break effects and assigns the character slots by the playable character.
local function load_moon_break_scene_actors()
	local playable_character: s32 = 0
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
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 1, "info", monica_slot, 41)
		event.load_equipment_model(5, 1, 0, "info", monica_slot, 42)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 1, "info", max_slot, 41)
		event.load_equipment_model(5, 0, 0, "info", max_slot, 42)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(2, 35)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e700/e732/e732_dark.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(5, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 5)
	event.load_character(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
	event.set_object_sequence_object(4, 6)
	event.set_object_sequence_position(4, 0.0, 20065.8, 9390.18)
	event.set_object_handle_scale(6, 6.0, 6.0, 6.0)
	event.load_character(5, "event/e700/e732/e732_dedeath.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e700/e732/e732_moonbreak_f1.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.load_character(5, "event/e700/e732/e732_moonbreak_f2.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.load_character(5, "event/e700/e732/e732_moonbreak_h.gltf", "info", 45)
	event.set_character_active(0, 45)
	event.load_character(5, "event/e700/e732/e732_moonbreak_light.gltf", "info", 46)
	event.set_character_active(0, 46)
	event.attach_object_handle_to_character(7, 46)
	event.clear_object_sequence(5, 46)
	event.set_object_sequence_object(5, 7)
	event.load_character(5, "event/e700/e732/e700_a_hikari.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ７３２光雨")
	event.create_effect_work_buffer(5)
	event.set_character_active(1, 41)
	event.set_character_active(1, 42)
	event.load_message_file(0, 5, "event/e700/e732/e732.txt")
end

--- Assigns the Max and Monica character slots as they are when Monica is the playable character.
local function assign_monica_playable_slots()
	local playable_character: s32 = 0
	local _ = playable_character == 2
	playable_character = 0
	local _ = playable_character == 3
	playable_character = 1
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Restores the playable character, deletes every actor loaded for the moon-break scene and shows the status bar again.
local function unload_moon_break_scene_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
		event.delete_character(41)
		event.delete_character(42)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
		event.delete_character(41)
		event.delete_character(42)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(33)
	event.delete_character(39)
	event.set_object_handle_scale(6, 1.0, 1.0, 1.0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Plays the skippable moon-break scene with the dialogue, camera moves and effects, then unloads its actors.
local function play_moon_break_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local resume_point: number = 0
	vm.section(function()
		event.set_save_flag(732, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.fade_out_screen(30)
		resume_point = 1
		wait.for_frame_count(35)
		event.load_music(113)
		event.load_map_sounds(7839)
		sound_bank = event.load_sound_effect_file_2(7839) or sound_bank
		load_moon_break_scene_actors()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(1.74, 7.93, -125.36)
		event.set_camera_sequence_look_at(0.0, 45.32, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, -355.97)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(0, -11.44, 0.0, -59.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(1, 15.8, 0.0, -56.73)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(3, "ぐふう", 4)
		event.set_object_sequence_motion(0, "上見構え", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上見構え", 4, -1.0, 1)
		event.set_character_active(1, 41)
		event.set_character_active(1, 42)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 1)
		event.fade_in_screen(30)
		resume_point = 2
		wait.for_frame_count(15)
		event.set_object_sequence_motion(2, "倒れ", 4)
		resume_point = 3
		message.show_voiced_for_stopping(7320010, -1)
		resume_point = 4
		wait.for_frame_count(15)
		event.set_object_handle_frame_visible(5, "skin4", 0)
		event.set_character_position(38, 0.0, 0.0, 0.0)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_motion(38, "立ち")
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(20.77, 31.1, -40.75)
		event.set_camera_sequence_look_at(-2.9, 53.83, -8.05)
		event.move_camera_sequence_eased(88.65, 1.66, -134.55, -2.9, 53.83, -8.05, 150, 2, 1.0)
		resume_point = 5
		message.show_voiced_for_stopping(7320020, -1)
		resume_point = 6
		camera.wait_until_done()
		resume_point = 7
		message.show_voiced_for_stopping(7320030, -1)
		event.set_character_motion(38, "笑い", 2, -1, 1)
		event.set_character_visible(36, 0, 1, 0.025)
		event.play_sound_effect(sound_bank, 0)
		resume_point = 8
		wait.for_frame_count(270)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.play_sound_effect(sound_bank, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(27.9, 77.1, 17.22, 55.5, -0.18, -47.34)
		event.add_camera_sequence_path_point(-22.28, 77.1, -4.23, 5.32, -0.18, -68.79)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		resume_point = 9
		camera.wait_until_done()
		event.set_camera_sequence_position(2.09, 7.26, -118.61)
		event.set_camera_sequence_look_at(1.46, 36.09, -47.77)
		event.start_crossfade(30)
		resume_point = 10
		wait.for_frame_count(60)
		event.set_object_sequence_motion(0, "左・振り返り", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返りL")
		resume_point = 11
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.set_camera_sequence_position(-159.57, 241.29, -121.7)
		event.set_camera_sequence_look_at(-16.11, 35.13, -290.72)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -30.95, 0.0, -223.57)
		event.add_object_sequence_path_point(0, -29.63, 0.0, -334.52)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, 25.19, 0.0, -188.89)
		event.add_object_sequence_path_point(1, 12.96, 0.0, -294.16)
		event.start_object_sequence_path(1)
		resume_point = 12
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "心配顔")
		event.set_object_sequence_texture_animation(0, 1, "心配目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "心配顔")
		event.set_object_sequence_texture_animation(1, 1, "心配目パチ")
		event.play_music(0)
		event.set_object_sequence_position(0, -16.72, 0.0, -361.54)
		event.set_object_sequence_rotation(0, 0.0, 2.17, 0.0)
		event.set_object_sequence_position(1, 21.91, 0.0, -350.53)
		event.set_object_sequence_rotation(1, 0.0, -2.19, 0.0)
		event.set_object_sequence_motion(0, "しゃがむL", 4)
		event.set_object_sequence_motion(1, "しゃがみL", 4)
		event.set_camera_sequence_position(-34.54, 58.66, -391.76)
		event.set_camera_sequence_look_at(-3.33, 7.63, -413.95)
		event.move_camera_sequence_eased(-33.16, 58.66, -340.34, -1.95, 7.63, -362.53, 150, 2, 1.0)
		resume_point = 13
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "ユリス見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見る会話", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見るL", 4)
		resume_point = 14
		message.show_voiced_for_stopping(7320040, -1)
		resume_point = 15
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "ユリス見る会話", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見るL", 4)
		resume_point = 16
		message.show_voiced_for_stopping(7320050, -1)
		resume_point = 17
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "首ふる", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見る会話", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見るL", 4)
		resume_point = 18
		message.show_voiced_for_stopping(7320055, -1)
		resume_point = 19
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-16.35, 40.86, -345.71)
		event.set_camera_sequence_look_at(-1.17, 7.63, -374.58)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目あき～目とじ")
		event.set_object_sequence_motion(2, "ユリス見る戻り", 2)
		event.queue_object_sequence_next_motion(2, "倒れ会話", 2)
		event.queue_object_sequence_next_motion(2, "倒れ", 4)
		resume_point = 20
		message.show_voiced_for_stopping(7320060, -1)
		resume_point = 21
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "起きる", 2)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		resume_point = 22
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "心配顔")
		event.set_object_sequence_texture_animation(0, 1, "心配目～通常目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "心配顔")
		event.set_object_sequence_texture_animation(1, 1, "心配目～通常目")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(0, "サン・起きあがる", 6)
		event.queue_object_sequence_next_motion(0, "サン・起きあがるL")
		event.set_object_sequence_motion(1, "サン立つ", 6)
		event.queue_object_sequence_next_motion(1, "サン立つL")
		event.set_camera_sequence_position(-0.48, 7.35, -418.26)
		event.set_camera_sequence_look_at(-0.27, 7.63, -374.61)
		resume_point = 23
		message.show_voiced_for_stopping(7320062, -1)
		resume_point = 24
		wait.for_frame_count(30)
		resume_point = 25
		object.wait_until_done(2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "上向き歩き", 4)
		event.set_object_sequence_motion(0, "右見る", 4)
		event.set_object_sequence_motion(1, "しゃがみ左見る", 4)
		event.set_camera_sequence_position(0.81, 64.97, -80.15)
		event.set_camera_sequence_look_at(0.0, 8.4, -355.97)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 540)
		event.add_object_sequence_path_point(2, 0.0, 0.0, -300.97)
		event.add_object_sequence_path_point(2, 0.0, 0.0, -132.95)
		event.start_object_sequence_path(2)
		event.move_camera_sequence_look_at(0.0, 8.4, -182.95, 540)
		resume_point = 26
		message.show_voiced_for_stopping(7320070, -1)
		resume_point = 27
		wait.for_frame_count(15)
		resume_point = 28
		message.show_voiced_for_stopping(7320080, -1)
		resume_point = 29
		wait.for_frame_count(15)
		resume_point = 30
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "上向くL", 4)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_event_projection(200.0)
		event.set_camera_sequence_position(-2.12, 16.61, -87.09)
		event.set_camera_sequence_look_at(-0.05, 86.09, 255.81)
		event.set_object_sequence_motion(2, "上向く会話", 2)
		resume_point = 31
		message.show_voiced_for_stopping(7320085, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 32
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ")
		event.set_event_projection(projection)
		event.set_camera_sequence_position(30.59, 14.36, 15.74)
		event.set_camera_sequence_look_at(0.0, 18.7, 0.0)
		event.start_crossfade(30)
		event.set_object_sequence_motion(2, "上向く会話")
		resume_point = 33
		message.show_voiced_for_stopping(7320090, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 34
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "上向く会話")
		resume_point = 35
		message.show_voiced_for_stopping(7320100, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 36
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ～目とじ")
		event.set_object_sequence_motion(2, "下向く", 2)
		event.queue_object_sequence_next_motion(2, "下向く会話")
		resume_point = 37
		message.show_voiced_for_stopping(7320110, -1)
		event.set_object_sequence_motion(2, "下向くL")
		resume_point = 38
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.set_object_sequence_motion(2, "下向く会話", 2)
		event.queue_object_sequence_next_motion(2, "下→上", 2)
		event.queue_object_sequence_next_motion(2, "上向く会話", 4)
		resume_point = 39
		message.show_voiced_for_stopping(7320120, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 40
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_camera_sequence_position(34.66, 78.5, 33.42)
		event.set_camera_sequence_look_at(0.62, 18.7, -0.62)
		event.start_crossfade(30)
		event.set_object_sequence_motion(2, "下→上", 6)
		event.queue_object_sequence_next_motion(2, "上向く会話", 4)
		event.move_camera_sequence_eased(6.93, 54.08, 29.68, 0.62, 18.7, -0.62, 200, 2, 1.0)
		resume_point = 41
		message.show_voiced_for_stopping(7320125, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 42
		wait.for_frame_count(15)
		event.set_object_sequence_motion(2, "上向く会話")
		resume_point = 43
		message.show_voiced_for_stopping(7320130, -1)
		event.set_object_sequence_motion(2, "上向くL")
		resume_point = 44
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "手をかざす", 6)
		event.queue_object_sequence_next_motion(2, "手をかざす会話", 4)
		resume_point = 45
		message.show_voiced_for_stopping(7320140, -1)
		event.set_object_sequence_motion(2, "手をかざすL")
		event.clear_camera_sequence()
		event.fade_out_music(30)
		event.set_motion_blur(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(30)
		event.add_camera_sequence_path_point(7.14, 54.26, 29.71, 0.62, 18.7, -0.62)
		event.add_camera_sequence_path_point(116.13, 382.36, 166.44, 0.62, 18.7, -0.62)
		event.start_camera_sequence_path()
		resume_point = 46
		camera.wait_until_done()
		event.set_motion_blur(0)
		event.set_character_position(43, 0.0, 0.0, 0.0)
		event.set_character_rotation(43, 0.0, 0.0, 0.0)
		event.set_character_position(44, 0.0, 0.0, 0.0)
		event.set_character_rotation(44, -0.9, 0.0, 0.0)
		event.set_character_position(45, 0.0, 120.78, -8.63)
		event.set_character_rotation(45, 0.0, 0.0, 0.0)
		event.set_character_position(46, 16.0, 7.55, -303.55)
		event.set_character_rotation(46, 0.0, 0.0, 0.0)
		event.set_character_active(1, 43)
		event.play_sound_effect(sound_bank, 4)
		event.set_character_motion(43, "手をかざすL")
		event.set_character_visible(43, 1, 1, 0.025)
		event.set_event_projection(200.0)
		event.stop_sound_effect(sound_bank, 1)
		event.play_sound_effect(sound_bank, 3)
		event.set_camera_sequence_position(-0.18, 16.61, -42.1)
		event.set_camera_sequence_look_at(-0.05, 86.09, 255.81)
		event.move_camera_sequence_eased(-0.18, 16.61, -42.1, -0.05, 235.45, 255.81, 100, 2, 1.0)
		event.stop_music(0)
		event.play_sound_effect(sound_bank, 5)
		event.set_character_motion(44, "手をかざすL", 2, -1, 1)
		event.set_character_active(1, 44)
		resume_point = 47
		wait.for_frame_count(100)
		event.set_character_visible(43, 0, 1, 0.025)
		resume_point = 48
		wait.for_frame_count(100)
		event.set_character_motion(45, "月破壊（ヒット）", 2, -1, 1)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(1, 45)
		resume_point = 49
		wait.for_frame_count(60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(0, 17.39, 0.0, -347.79)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 2.28, 0.0, -342.63)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(49.31, 17.33, -336.13)
		event.set_camera_sequence_look_at(-69.21, 27.55, -358.14)
		event.set_object_sequence_motion(5, "発動", 6)
		event.queue_object_sequence_next_motion(5, "ループ", 4)
		event.set_character_active(1, 46)
		resume_point = 50
		wait.for_frame_count(60)
		resume_point = 51
		wait.for_frame_count(120)
		event.set_character_active(0, 46)
		event.create_effect("Ｅ７３２光雨")
		event.set_effect_first_vector(0.0, 140.0, 0.0)
		event.set_effect_second_vector(500.0, 0.0, 500.0)
		event.set_effect_value(0, 700)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_position(0, 13.0, 0.0, -159.19)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, -13.0, 0.0, -156.73)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "上向くL", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(2.81, 138.78, 11.72, -3.06, -51.06, -141.04)
		event.add_camera_sequence_path_point(7.79, 138.78, 141.19, 1.89, -51.06, -12.32)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		event.load_music(112)
		resume_point = 52
		wait.for_frame_count(90)
		event.play_music(0)
		resume_point = 53
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目とじ")
		event.set_camera_sequence_position(24.93, 17.0, 8.96)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		event.start_crossfade(30)
		resume_point = 54
		wait.for_frame_count(90)
		resume_point = 55
		message.show_voiced_for_stopping(7320150, -1)
		resume_point = 56
		wait.for_frame_count(30)
		event.set_character_position(39, 0.0, 42.78, 36.3)
		event.set_character_rotation(39, 0.0, -3.12, 0.0)
		event.set_character_active(1, 39)
		event.set_character_motion(39, "後光", 4, -1, 1)
		event.set_character_motion(33, "浮遊立ち")
		event.set_character_position(33, 0.0, 42.78, 36.3)
		event.set_character_rotation(33, 0.0, -3.12, 0.0)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-0.65, 13.67, -139.44)
		event.set_camera_sequence_look_at(-1.11, 30.17, -1.22)
		resume_point = 57
		message.show_voiced_for_stopping(7320155, -1)
		resume_point = 58
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(-0.96, 53.08, -45.59, -1.11, 64.72, -1.22, 200, 2, 1.0)
		event.set_character_motion(33, "浮遊会話")
		resume_point = 59
		message.show_voiced_for_stopping(7320160, -1)
		resume_point = 60
		camera.wait_until_done()
		event.set_character_active(0, 33)
		event.set_character_active(0, 39)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "泣き目")
		event.set_camera_sequence_position(24.93, 17.0, 8.96)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		resume_point = 61
		message.show_voiced_for_stopping(7320170, -1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "泣き目あき～目とじ")
		resume_point = 62
		wait.for_frame_count(60)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ～泣き目あき")
		event.set_object_sequence_motion(2, "振り返る", 2)
		resume_point = 63
		wait.for_frame_count(20)
		event.rotate_object_sequence(2, 0.0, 3.1, 0.0, 30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_camera_sequence_position(1.99, 35.18, -222.99)
		event.set_camera_sequence_look_at(-1.11, 8.64, -1.22)
		resume_point = 64
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち2")
		resume_point = 65
		wait.for_frame_count(20)
		event.set_object_sequence_motion(2, "会話2")
		resume_point = 66
		message.show_voiced_for_stopping(7320180, -1)
		event.set_object_sequence_motion(2, "立ち2")
		resume_point = 67
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "会話2")
		resume_point = 68
		message.show_voiced_for_stopping(7320185, -1)
		event.set_object_sequence_motion(2, "立ち2")
		resume_point = 69
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-0.17, 20.98, -62.1)
		event.set_camera_sequence_look_at(0.0, 8.4, 0.0)
		event.set_object_sequence_motion(2, "会話2")
		resume_point = 70
		message.show_voiced_for_stopping(7320190, -1)
		event.set_object_sequence_motion(2, "立ち2")
		resume_point = 71
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "会話2")
		resume_point = 72
		message.show_voiced_for_stopping(7320200, -1)
		event.set_object_sequence_motion(2, "立ち2")
		resume_point = 73
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目～目とじ")
		event.set_camera_sequence_position(-30.4, 17.0, -5.26)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		event.set_object_sequence_motion(2, "上向く", 2)
		event.queue_object_sequence_next_motion(2, "死", 2)
		event.queue_object_sequence_next_motion(2, "死L", 4)
		event.play_sound_effect(sound_bank, 7)
		resume_point = 74
		wait.for_frame_count(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-1.15, 259.68, -39.55, -0.39, 8.4, -13.48)
		event.add_camera_sequence_path_point(-1.15, 117.74, -39.55, -0.39, 8.4, -13.48)
		event.start_camera_sequence_path()
		resume_point = 75
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_point <= 1 then
			assign_monica_playable_slots()
			wait.skip_frame_count(15)
		end
		if resume_point <= 2 then
			message.show_voiced_for_stopping_skipping(7320010, -1)
		end
		if resume_point <= 3 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 4 then
			message.show_voiced_for_stopping_skipping(7320020, -1)
		end
		if resume_point <= 5 then
			wait.background_load_skipping()
		end
		if resume_point <= 6 then
			message.show_voiced_for_stopping_skipping(7320030, -1)
		end
		if resume_point <= 7 then
			wait.skip_frame_count(270)
		end
		if resume_point <= 8 then
			wait.background_load_skipping()
		end
		if resume_point <= 9 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 10 then
			cutscene.skip_command(0)
		end
		if resume_point <= 11 then
			cutscene.skip_command(0)
		end
		if resume_point <= 12 then
			wait.background_load_skipping()
		end
		if resume_point <= 13 then
			message.show_voiced_for_stopping_skipping(7320040, -1)
		end
		if resume_point <= 14 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 15 then
			message.show_voiced_for_stopping_skipping(7320050, -1)
		end
		if resume_point <= 16 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 17 then
			message.show_voiced_for_stopping_skipping(7320055, -1)
		end
		if resume_point <= 18 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 19 then
			message.show_voiced_for_stopping_skipping(7320060, -1)
		end
		if resume_point <= 20 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 21 then
			wait.skip_frame_count(20)
		end
		if resume_point <= 22 then
			message.show_voiced_for_stopping_skipping(7320062, -1)
		end
		if resume_point <= 23 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 24 then
			cutscene.skip_command(2)
		end
		if resume_point <= 25 then
			message.show_voiced_for_stopping_skipping(7320070, -1)
		end
		if resume_point <= 26 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 27 then
			message.show_voiced_for_stopping_skipping(7320080, -1)
		end
		if resume_point <= 28 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 29 then
			wait.background_load_skipping()
		end
		if resume_point <= 30 then
			message.show_voiced_for_stopping_skipping(7320085, -1)
		end
		if resume_point <= 31 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 32 then
			message.show_voiced_for_stopping_skipping(7320090, -1)
		end
		if resume_point <= 33 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 34 then
			message.show_voiced_for_stopping_skipping(7320100, -1)
		end
		if resume_point <= 35 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 36 then
			message.show_voiced_for_stopping_skipping(7320110, -1)
		end
		if resume_point <= 37 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 38 then
			message.show_voiced_for_stopping_skipping(7320120, -1)
		end
		if resume_point <= 39 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 40 then
			message.show_voiced_for_stopping_skipping(7320125, -1)
		end
		if resume_point <= 41 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 42 then
			message.show_voiced_for_stopping_skipping(7320130, -1)
		end
		if resume_point <= 43 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 44 then
			message.show_voiced_for_stopping_skipping(7320140, -1)
		end
		if resume_point <= 45 then
			wait.background_load_skipping()
		end
		if resume_point <= 46 then
			wait.skip_frame_count(100)
		end
		if resume_point <= 47 then
			wait.skip_frame_count(100)
		end
		if resume_point <= 48 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 49 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 50 then
			wait.skip_frame_count(120)
		end
		if resume_point <= 51 then
			wait.skip_frame_count(90)
		end
		if resume_point <= 52 then
			wait.background_load_skipping()
		end
		if resume_point <= 53 then
			wait.skip_frame_count(90)
		end
		if resume_point <= 54 then
			message.show_voiced_for_stopping_skipping(7320150, -1)
		end
		if resume_point <= 55 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 56 then
			message.show_voiced_for_stopping_skipping(7320155, -1)
		end
		if resume_point <= 57 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 58 then
			message.show_voiced_for_stopping_skipping(7320160, -1)
		end
		if resume_point <= 59 then
			wait.background_load_skipping()
		end
		if resume_point <= 60 then
			message.show_voiced_for_stopping_skipping(7320170, -1)
		end
		if resume_point <= 61 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 62 then
			wait.skip_frame_count(20)
		end
		if resume_point <= 63 then
			cutscene.skip_command(2)
		end
		if resume_point <= 64 then
			wait.skip_frame_count(20)
		end
		if resume_point <= 65 then
			message.show_voiced_for_stopping_skipping(7320180, -1)
		end
		if resume_point <= 66 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 67 then
			message.show_voiced_for_stopping_skipping(7320185, -1)
		end
		if resume_point <= 68 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 69 then
			message.show_voiced_for_stopping_skipping(7320190, -1)
		end
		if resume_point <= 70 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 71 then
			message.show_voiced_for_stopping_skipping(7320200, -1)
		end
		if resume_point <= 72 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 73 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 74 then
			wait.background_load_skipping()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_music(60)
	event.fade_out_camera_sequence(60, 255.0, 255.0, 255.0)
	resume_point = 76
	wait.for_frame_count(60)
	event.stop_music(0)
	event.set_event_projection(projection)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	resume_point = 77
	vm.wait(77)
	event.clear_effect_manager()
	resume_point = 78
	vm.wait(78)
	unload_moon_break_scene_actors()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the map needs no setup before it is entered.
function script.initialize_map() end
script[99] = script.initialize_map

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs this instead of its default.
function script.key_open() end

--- Plays the moon-break scene and then jumps to the map s44.
function script.play_moon_break_scene_then_leave_for_s44()
	play_moon_break_scene()
	event.jump_to_map_3(-1, "s44", 500)
end
script[500] = script.play_moon_break_scene_then_leave_for_s44

--- Plays the moon-break scene and then jumps to the map s44.
function script.play_moon_break_scene_alternate_then_leave_for_s44()
	play_moon_break_scene()
	event.jump_to_map_3(-1, "s44", 500)
end
script[17320] = script.play_moon_break_scene_alternate_then_leave_for_s44

return script
