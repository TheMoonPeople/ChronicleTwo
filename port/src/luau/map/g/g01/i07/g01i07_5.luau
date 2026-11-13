--!strict
--- Interior of the dwarves' house in Sindain with the dwarf introduction scene and the forest beauty story scenes.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sindain_dwarves_house = require("@lib/event/sindain_dwarves_house")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the playable characters and the dwarves for the introduction scene.
local function load_dwarves_scene_characters()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot = 0
		monica_slot = 32
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e250/e250_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e250/e250_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_character(5, "event/e200/e250/e250_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e250/e250_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e250/e250_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e250/e250_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Deletes the characters loaded for the dwarf introduction scene.
local function unload_dwarves_scene_characters()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(39)
	event.delete_character(34)
	event.delete_character(41)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(40)
end

--- Plays the scene in which the party meets the dwarves in their house.
local function play_dwarves_introduction_scene()
	local sound_bank: s32 = 0
	local active_music_number: s32 = 0
	vm.section(function()
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(2226) or sound_bank
		load_dwarves_scene_characters()
		event.set_object_handle_footstep_sound(5, 3)
		event.set_object_handle_footstep_sound(7, 3)
		event.set_object_handle_footstep_sound(8, 3)
		event.set_object_handle_footstep_sound(2, 3)
		event.set_object_handle_footstep_sound(4, 3)
		event.set_object_handle_footstep_sound(3, 3)
		event.set_object_handle_footstep_sound(6, 3)
		active_music_number = event.get_active_music_number() or active_music_number
		if active_music_number ~= 57 then
			event.stop_music(0)
			wait.frames(4)
			event.load_music(57)
			event.play_music(0)
		end
		event.set_camera_position(61.02, 50.01, -21.23)
		event.set_camera_look_at(38.72, 33.02, 92.47)
		event.set_character_position(0, 36.74, 11.68, 80.62)
		event.set_character_rotation(0, 0.0, 3.08, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_position(mints_slot, 36.74, 11.68, 80.62)
		event.set_character_rotation(mints_slot, 0.0, 3.08, 0.0)
		event.set_character_position(monica_slot, 36.74, 11.68, 80.62)
		event.set_character_rotation(monica_slot, 0.0, 3.08, 0.0)
		event.set_character_position(39, 36.74, 11.68, 80.62)
		event.set_character_rotation(39, 0.0, 3.08, 0.0)
		event.set_character_position(34, 36.74, 11.68, 80.62)
		event.set_character_rotation(34, 0.0, 3.08, 0.0)
		event.set_character_position(35, 36.74, 11.68, 80.62)
		event.set_character_rotation(35, 0.0, 3.08, 0.0)
		event.set_character_position(40, 36.74, 11.68, 80.62)
		event.set_character_rotation(40, 0.0, 3.08, 0.0)
		event.set_character_position(36, 36.74, 11.68, 80.62)
		event.set_character_rotation(36, 0.0, 3.08, 0.0)
		event.set_character_position(41, 36.74, 11.68, 80.62)
		event.set_character_rotation(41, 0.0, 3.08, 0.0)
		event.set_character_position(38, 36.74, 11.68, 80.62)
		event.set_character_rotation(38, 0.0, 3.08, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(91.91, 40.58, -22.22)
		event.set_camera_sequence_look_at(60.35, 28.33, -88.23)
		event.set_object_sequence_position(5, 61.73, 0.0, -98.0)
		event.set_object_sequence_rotation(5, 0.0, -0.16, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_motion(5, "うたたね", 4)
		wait.frames(30)
		wait.frames(30)
		wait.frames(60)
		event.play_sound_effect(sound_bank, 9)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(5, "目を覚ます", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		wait.frames(56)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500010)
		event.set_object_sequence_motion(5, "歩き", 0)
		event.move_object_sequence(5, 14.66, 0.0, -93.65, 90)
		event.rotate_object_sequence(5, 0.0, -1.36, 0.0, 15)
		wait.frames(60)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 41)
		event.set_character_active(1, 34)
		event.set_character_active(1, 40)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(114.27, 52.14, 5.16)
		event.set_camera_sequence_look_at(75.96, 38.4, 31.19)
		event.set_object_sequence_position(0, 41.21, 12.34, 89.84)
		event.set_object_sequence_rotation(0, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(1, 59.24, 12.34, 90.02)
		event.set_object_sequence_rotation(1, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(2, 50.17, 12.34, 41.54)
		event.set_object_sequence_rotation(2, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(7, -47.75, 0.0, -33.99)
		event.set_object_sequence_rotation(7, 0.0, 1.28, 0.0)
		event.set_object_sequence_position(3, 65.47, 12.34, 70.09)
		event.set_object_sequence_rotation(3, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(4, 48.11, 12.34, 62.89)
		event.set_object_sequence_rotation(4, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(8, -40.99, 0.0, -53.0)
		event.set_object_sequence_rotation(8, 0.0, 0.68, 0.0)
		event.set_object_sequence_position(6, 26.04, 12.34, 58.13)
		event.set_object_sequence_rotation(6, 0.0, 3.08, 0.0)
		event.set_object_sequence_position(5, -3.45, 0.0, -90.22)
		event.set_object_sequence_rotation(5, 0.0, -0.16, 0.0)
		event.move_camera_sequence_eased(71.46, 34.6, 10.91, -11.65, 23.24, -37.81, 48, 2, 0.4)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 75)
		event.add_object_sequence_path_point(2, 50.17, 12.34, 41.54)
		event.add_object_sequence_path_point(2, 34.93, 4.87, 15.29)
		event.add_object_sequence_path_point(2, 8.97, 0.0, -10.99)
		event.add_object_sequence_path_point(2, -11.35, 0.0, -43.14)
		event.add_object_sequence_path_point(2, -20.73, 0.0, -44.48)
		event.add_object_sequence_path_point(2, -25.84, 0.0, -41.54)
		event.start_object_sequence_path(2)
		event.rotate_object_sequence(2, 0.0, -1.06, 0.0, 60)
		event.delay_object_sequence_position_track(4, 5)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 60)
		event.add_object_sequence_path_point(4, 47.83, 12.34, 60.96)
		event.add_object_sequence_path_point(4, 35.91, 12.34, 38.26)
		event.add_object_sequence_path_point(4, 26.63, 1.97, 7.16)
		event.add_object_sequence_path_point(4, -3.9, 0.0, -27.19)
		event.add_object_sequence_path_point(4, -17.06, 0.0, -28.08)
		event.add_object_sequence_path_point(4, -22.59, 0.0, -27.4)
		event.start_object_sequence_path(4)
		event.rotate_object_sequence(4, 0.0, -1.87, 0.0, 65)
		event.delay_object_sequence_position_track(3, 15)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 60)
		event.add_object_sequence_path_point(3, 65.47, 12.34, 70.09)
		event.add_object_sequence_path_point(3, 48.07, 12.34, 41.25)
		event.add_object_sequence_path_point(3, 17.35, 0.0, 4.4)
		event.add_object_sequence_path_point(3, -6.48, 0.0, -13.51)
		event.add_object_sequence_path_point(3, -21.65, 0.0, -14.06)
		event.start_object_sequence_path(3)
		event.rotate_object_sequence(3, 0.0, -2.12, 0.0, 75)
		event.delay_object_sequence_position_track(6, 10)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 60)
		event.add_object_sequence_path_point(6, 26.04, 12.34, 58.13)
		event.add_object_sequence_path_point(6, 16.54, 12.34, 39.83)
		event.add_object_sequence_path_point(6, 15.0, 1.75, 6.54)
		event.add_object_sequence_path_point(6, -18.95, 0.07, -5.53)
		event.add_object_sequence_path_point(6, -36.21, 0.07, -6.68)
		event.start_object_sequence_path(6)
		event.rotate_object_sequence(6, 0.0, -2.94, 0.0, 70)
		event.move_object_sequence(7, -48.33, 0.0, -19.5, 15)
		event.rotate_object_sequence(7, 0.0, 1.76, 0.0, 15)
		event.move_object_sequence(8, -47.4, 0.0, -39.83, 15)
		event.rotate_object_sequence(8, 0.0, 1.04, 0.0, 15)
		event.move_object_sequence(5, -41.32, 0.0, -54.14, 15)
		event.rotate_object_sequence(5, 0.0, 0.68, 0.0, 15)
		event.set_object_sequence_motion(2, "走り", 0)
		event.delay_object_sequence_motion_track(2, 75)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.delay_object_sequence_motion_track(5)
		event.set_object_sequence_motion(4, "走り2", 0)
		event.delay_object_sequence_motion_track(4, 60)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.delay_object_sequence_motion_track(3, 15)
		event.set_object_sequence_motion(3, "走り", 0)
		event.delay_object_sequence_motion_track(3, 60)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.delay_object_sequence_motion_track(6, 10)
		event.set_object_sequence_motion(6, "走り", 0)
		event.delay_object_sequence_motion_track(6, 60)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.set_object_sequence_motion(7, "走り", 0)
		event.delay_object_sequence_motion_track(7, 15)
		event.set_object_sequence_motion(7, "立ち", 0)
		event.set_object_sequence_motion(8, "走り", 0)
		event.delay_object_sequence_motion_track(8, 15)
		event.set_object_sequence_motion(8, "立ち", 0)
		event.set_object_sequence_motion(5, "走り", 0)
		event.delay_object_sequence_motion_track(5, 15)
		event.set_object_sequence_motion(5, "立ち", 0)
		sindain_dwarves_house.play_voiced_message(2500020, 90)
		event.set_object_sequence_motion(7, "会話", 0)
		event.delay_object_sequence_motion_track(3, 15)
		event.set_object_sequence_motion(3, "会話", 0)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "会話", 0)
		event.delay_object_sequence_motion_track(8, 30)
		event.set_object_sequence_motion(8, "会話", 0)
		event.delay_object_sequence_motion_track(4, 20)
		event.set_object_sequence_motion(4, "会話", 0)
		event.delay_object_sequence_motion_track(6, 30)
		event.set_object_sequence_motion(6, "会話", 0)
		event.set_mouth_texture_animations(7, "口パク")
		message.show_voiced(2500040)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		message.show_voiced(2500050)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(8, "口パク")
		message.show_voiced(2500060)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "口パク")
		message.show_voiced(2500070)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		event.delay_object_sequence_motion_track(2, 68)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.delay_object_sequence_motion_track(3, 73)
		event.set_object_sequence_motion(3, "立ち", 0)
		event.delay_object_sequence_motion_track(4, 68)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.delay_object_sequence_motion_track(6, 78)
		event.set_object_sequence_motion(6, "立ち", 0)
		event.delay_object_sequence_motion_track(7, 68)
		event.set_object_sequence_motion(7, "立ち", 0)
		event.delay_object_sequence_motion_track(8, 73)
		event.set_object_sequence_motion(8, "立ち", 0)
		message.show_voiced(2500080)
		object.wait_until_done(5)
		event.set_object_sequence_motion(5, "歩き", 0)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 120)
		event.add_object_sequence_path_point(5, -40.55, 0.0, -53.27)
		event.add_object_sequence_path_point(5, -21.22, 0.0, -65.68)
		event.add_object_sequence_path_point(5, -5.35, 0.0, -60.71)
		event.add_object_sequence_path_point(5, -3.11, 0.0, -43.59)
		event.add_object_sequence_path_point(5, 5.06, 0.0, -14.63)
		event.add_object_sequence_path_point(5, 20.49, 0.0, 8.1)
		event.start_object_sequence_path(5)
		wait.frames(120)
		event.set_camera_sequence_position(7.29, 16.04, -33.96)
		event.set_camera_sequence_look_at(10.55, 19.12, 1.79)
		event.set_object_sequence_position(0, 41.21, 12.34, 89.84)
		event.set_object_sequence_rotation(0, 0.0, -2.72, 0.0)
		event.set_object_sequence_position(1, 59.24, 12.34, 90.02)
		event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
		event.set_object_sequence_position(5, 9.1, 0.0, 9.43)
		event.set_object_sequence_rotation(5, 0.0, 0.45, 0.0)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500090)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500100)
		event.set_object_sequence_motion(5, "会話2", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500110)
		message.show_voiced(2500115)
		message.show_voiced(2500120)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(2500130)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話2", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500140)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(2500150)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(70.03, 70.11, 56.44)
		event.set_camera_sequence_look_at(5.23, 27.72, -0.73)
		event.set_object_sequence_position(5, 4.81, 0.0, 5.51)
		event.set_object_sequence_rotation(5, 0.0, 0.93, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.74, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 1.04, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.69, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 1.42, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 1.16, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.92, 0.0)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(5, "振り返り", 6)
		event.queue_object_sequence_next_motion(5, "振り返り会話", 0)
		sindain_dwarves_house.play_voiced_message(2500160, 130)
		object.wait_until_done(5)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_motion(2, "おー", 6)
		event.set_object_sequence_motion(3, "おー", 6)
		event.set_object_sequence_motion(4, "おー", 6)
		event.set_object_sequence_motion(6, "おー", 6)
		event.set_object_sequence_motion(7, "おー", 6)
		event.set_object_sequence_motion(8, "おー", 6)
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(5, "振り返り2", 6)
		event.delay_object_sequence_motion_track(5, 52)
		event.set_object_sequence_motion(5, "走り", 0)
		event.delay_object_sequence_motion_track(2, 62)
		event.set_object_sequence_motion(2, "走り2", 0)
		event.delay_object_sequence_motion_track(3, 72)
		event.set_object_sequence_motion(3, "走り", 0)
		event.delay_object_sequence_motion_track(4, 82)
		event.set_object_sequence_motion(4, "走り", 0)
		event.delay_object_sequence_motion_track(6, 92)
		event.set_object_sequence_motion(6, "走り", 0)
		event.delay_object_sequence_motion_track(7, 102)
		event.set_object_sequence_motion(7, "走り", 0)
		event.delay_object_sequence_motion_track(8, 92)
		event.set_object_sequence_motion(8, "走り", 0)
		event.delay_object_sequence_position_track(5, 52)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 45)
		event.add_object_sequence_path_point(5, 4.81, 0.0, 5.51)
		event.add_object_sequence_path_point(5, 15.09, 7.98, 24.0)
		event.add_object_sequence_path_point(5, 25.36, 12.34, 52.49)
		event.add_object_sequence_path_point(5, 39.32, 12.34, 82.98)
		event.start_object_sequence_path(5)
		event.delay_object_sequence_position_track(2, 62)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 45)
		event.add_object_sequence_path_point(2, -25.84, 0.0, -41.54)
		event.add_object_sequence_path_point(2, -20.06, 0.0, -45.69)
		event.add_object_sequence_path_point(2, 3.7, 0.0, -10.84)
		event.add_object_sequence_path_point(2, 39.39, 12.34, 77.06)
		event.start_object_sequence_path(2)
		event.delay_object_sequence_position_track(3, 72)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 45)
		event.add_object_sequence_path_point(3, -21.96, 0.0, -12.25)
		event.add_object_sequence_path_point(3, 14.28, 0.0, -4.5)
		event.add_object_sequence_path_point(3, 71.46, 12.34, 38.42)
		event.start_object_sequence_path(3)
		event.delay_object_sequence_position_track(4, 82)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 45)
		event.add_object_sequence_path_point(4, -22.59, 0.0, -27.4)
		event.add_object_sequence_path_point(4, -17.06, 0.0, -28.08)
		event.add_object_sequence_path_point(4, 15.38, 0.0, -0.94)
		event.add_object_sequence_path_point(4, 46.35, 12.34, 60.68)
		event.start_object_sequence_path(4)
		event.delay_object_sequence_position_track(6, 92)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 45)
		event.add_object_sequence_path_point(6, -36.21, 0.0, -6.68)
		event.add_object_sequence_path_point(6, 11.35, 0.0, -7.15)
		event.add_object_sequence_path_point(6, 56.62, 12.34, 55.65)
		event.start_object_sequence_path(6)
		event.delay_object_sequence_position_track(7, 102)
		event.clear_object_sequence_path(7)
		event.set_object_sequence_path_frames(7, 45)
		event.add_object_sequence_path_point(7, -47.74, 0.0, -19.5)
		event.add_object_sequence_path_point(7, 8.7, 0.0, -6.82)
		event.add_object_sequence_path_point(7, 34.63, 12.34, 67.71)
		event.start_object_sequence_path(7)
		event.delay_object_sequence_position_track(8, 92)
		event.clear_object_sequence_path(8)
		event.set_object_sequence_path_frames(8, 45)
		event.add_object_sequence_path_point(8, -47.4, 0.0, -39.83)
		event.add_object_sequence_path_point(8, 15.0, 0.0, 5.12)
		event.add_object_sequence_path_point(8, 16.13, 21.34, 75.28)
		event.start_object_sequence_path(8)
		event.delay_object_sequence_sound_track(5, 150)
		event.play_object_sequence_sound(5, sound_bank, 14)
		event.delay_object_sequence_motion_track(5, 88)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.delay_object_sequence_motion_track(2, 93)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.delay_object_sequence_motion_track(3, 98)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.delay_object_sequence_motion_track(4, 103)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.delay_object_sequence_motion_track(6, 108)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.delay_object_sequence_motion_track(7, 113)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.delay_object_sequence_motion_track(8, 118)
		event.set_object_sequence_motion(8, "立ち", 4)
		sindain_dwarves_house.play_voiced_message_closing_at(2500170, 240, 30)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(1)
	event.stop_music(0)
	unload_dwarves_scene_characters()
	event.reset_follow_camera(0)
end

--- Loads the characters, storybook sprites and message file for the forest beauty story.
local function load_forest_beauty_story_scene()
	local playable_character: s32 = 0
	local image_block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e209/e209_rococo.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e209/e209_tobo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	image_block = event.load_event_image_4(5, "textures/event/e200/e209/cap_e209.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "森の美女", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "美女と七人", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(11, 1)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "森に入っていく美女", image_block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
	event.set_event_sprite_size(2, 512, 448)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(12, 2)
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "悲しむ七人", image_block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 448.0)
	event.set_event_sprite_size(3, 512, 448)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "捜索隊結成！", image_block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 448.0)
	event.set_event_sprite_size(4, 512, 448)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.load_event_script_arguments(5, "event/e200/e209/e209_arg.stb")
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
	event.set_object_handle_frame_visible(4, "tue", 0)
	event.set_scene_status_flags(1, mints_slot, 256, 1)
	event.set_scene_status_flags(1, monica_slot, 256, 1)
end

--- Swaps the Mints and Monica character slots when the story scene is skipped.
local function swap_character_slots()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Deletes the characters and sprites of the forest beauty story.
local function unload_forest_beauty_story_scene()
	local playable_character: s32 = 0
	event.set_scene_status_flags(1, mints_slot, 256, 0)
	event.set_scene_status_flags(1, monica_slot, 256, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_event_image(0)
end

--- Plays the full forest beauty story told by the dwarves.
local function play_forest_beauty_story_scene()
	local sound_bank: s32 = 0
	local active_music_number: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		event.load_map_sounds(2220)
		sound_bank = event.load_sound_effect_file_2(2220) or sound_bank
		active_music_number = event.get_active_music_number() or active_music_number
		if active_music_number ~= 57 then
			event.stop_music(0)
			resume_step = 1
			wait.frames(4)
			event.load_music(57)
			event.play_music(0)
		end
		load_forest_beauty_story_scene()
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_frame_visible(4, "tue", 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_sound_bank(2, sound_bank)
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(47.0, 34.37, -20.4)
		event.set_camera_sequence_look_at(48.77, 33.02, 92.31)
		event.set_object_sequence_position(0, 37.73, 12.34, 48.71)
		event.set_object_sequence_rotation(0, 0.0, -3.13, 0.0)
		event.set_object_sequence_position(1, 59.47, 12.34, 50.85)
		event.set_object_sequence_rotation(1, 0.0, -3.09, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, 14.08, 22.46, 76.1)
		event.add_object_sequence_path_point(0, 29.1, 16.19, 75.87)
		event.add_object_sequence_path_point(0, 38.77, 12.34, 66.82)
		event.add_object_sequence_path_point(0, 40.57, 12.24, 54.03)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, 15.0, 21.86, 97.09)
		event.add_object_sequence_path_point(1, 34.81, 12.34, 96.25)
		event.add_object_sequence_path_point(1, 56.96, 12.34, 86.7)
		event.add_object_sequence_path_point(1, 59.47, 12.34, 50.85)
		event.start_object_sequence_path(1)
		resume_step = 2
		wait.frames(90)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_object_handle_frame_visible(4, "cube37", 0)
		event.set_object_handle_frame_visible(4, "cube38", 0)
		event.set_camera_sequence_position(61.85, 30.75, 55.74)
		event.set_camera_sequence_look_at(57.45, 21.42, -9.43)
		event.set_object_sequence_position(2, 58.4, 0.0, 1.06)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 28.34, 0.57, -39.22)
		event.set_object_sequence_rotation(3, 0.0, 1.96, 0.0)
		event.set_object_sequence_position(4, 68.15, 0.0, -98.49)
		event.set_object_sequence_rotation(4, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "右向き座り", 4)
		event.set_object_sequence_motion(4, "座り", 4)
		resume_step = 3
		wait.frames(60)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(55.75, 34.46, -7.05)
		event.set_camera_sequence_look_at(57.08, 35.01, 47.34)
		event.set_object_sequence_position(0, 47.38, 12.34, 47.12)
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_sequence_position(1, 66.48, 12.34, 44.88)
		event.set_object_sequence_rotation(1, 0.0, -3.05, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 4
		message.show_voiced(2090070)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(101.12, 31.73, 32.84)
		event.set_camera_sequence_look_at(86.47, 31.09, 33.6)
		event.set_object_sequence_position(0, 32.8, 12.34, 47.06)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.set_object_sequence_position(1, 54.18, 12.34, 45.41)
		event.set_object_sequence_rotation(1, 0.0, -3.05, 0.0)
		event.set_object_sequence_position(2, 58.74, 0.0, -1.86)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.move_object_sequence(2, 48.3, 7.12, 21.59, 45)
		resume_step = 5
		wait.frames(45)
		event.set_object_sequence_motion(2, "立ち", 0)
		resume_step = 6
		wait.frames(30)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_motion(2, "手を出す", 6)
		event.queue_object_sequence_next_motion(2, "手を出すL", 0)
		resume_step = 7
		wait.frames(20)
		resume_step = 8
		wait.frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 9
		message.show_voiced(2090080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "よこせ", 6)
		event.queue_object_sequence_next_motion(2, "よこせ戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		resume_step = 10
		wait.frames(53)
		resume_step = 11
		wait.frames(15)
		event.set_object_sequence_motion(1, "腕組み", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "腕組みL", 0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 12
		message.show_voiced(2090090)
		event.reset_mouth_texture_animations()
		resume_step = 13
		object.wait_until_done(1)
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		resume_step = 14
		wait.frames(37)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 15
		message.show_voiced(2090100)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(2, "うぬぬぬ", 6)
		event.queue_object_sequence_next_motion(2, "うぬぬぬL", 0)
		resume_step = 16
		wait.frames(20)
		event.set_mouth_texture_animations(2, "口くいしばり")
		resume_step = 17
		message.show_voiced(2090110)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "腕組み戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		resume_step = 18
		wait.frames(36)
		resume_step = 19
		wait.frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 20
		message.show_voiced(2090120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "左向き～前向き")
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 21
		message.show_voiced(2090125)
		event.reset_mouth_texture_animations()
		resume_step = 22
		object.wait_until_done(1)
		resume_step = 23
		wait.frames(15)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(2, "うぬぬぬ戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		resume_step = 24
		wait.frames(13)
		event.set_mouth_texture_animations(2, "口パク")
		resume_step = 25
		message.show_voiced(2090130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 26
		message.show_voiced(2090140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク")
		resume_step = 27
		message.show_voiced(2090150)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 34)
		event.set_camera_sequence_position(47.37, 32.06, 15.25)
		event.set_camera_sequence_look_at(54.66, 33.2, 46.95)
		event.set_object_sequence_rotation(1, 0.0, -2.93, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 28
		message.show_voiced(2090160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 29
		message.show_voiced(2090170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 30
		message.show_voiced(2090180)
		event.reset_mouth_texture_animations()
		if mints_slot ~= 0 then
			event.set_character_active(0, 37)
		end
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(23.05, 41.22, 65.24)
		event.set_camera_sequence_look_at(38.44, 35.55, 49.41)
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 31
		message.show_voiced(2090190)
		event.reset_mouth_texture_animations()
		resume_step = 32
		object.wait_until_done(1)
		event.set_object_sequence_motion(2, "やだよ", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.set_mouth_texture_animations(2, "口パク")
		resume_step = 33
		message.show_voiced(2090200)
		event.reset_mouth_texture_animations()
		resume_step = 34
		object.wait_until_done(2)
		if mints_slot ~= 0 then
			event.set_character_active(1, 37)
		end
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, 34)
		event.set_camera_sequence_position(73.08, 33.52, 20.51)
		event.set_camera_sequence_look_at(34.32, 34.8, 47.0)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.set_object_sequence_motion(0, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "小人見立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 35
		message.show_voiced(2090210)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(88.63, 47.47, 55.5)
		event.set_camera_sequence_look_at(45.2, 27.56, 32.66)
		event.set_object_sequence_position(2, 49.44, 6.02, 28.31)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_motion(2, "腕組み", 6)
		event.queue_object_sequence_next_motion(2, "腕組みL", 0)
		resume_step = 36
		wait.frames(13)
		event.set_mouth_texture_animations(2, "口パク")
		resume_step = 37
		message.show_voiced(2090220)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "腕組み戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "前を見る", 6)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "前を見る", 6)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くL", 0)
		resume_step = 38
		message.show_voiced(2090230)
		resume_step = 39
		message.show_voiced(2090235)
		event.set_camera_sequence_position(33.22, 50.72, 90.25)
		event.set_camera_sequence_look_at(67.33, 16.97, -92.82)
		event.set_object_sequence_position(4, 65.22, 0.0, -99.04)
		event.set_object_sequence_rotation(4, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "座り", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		resume_step = 40
		message.show_voiced(2090240)
		event.delay_object_sequence_motion_track(4, 30)
		event.set_object_sequence_motion(4, "手まねき", 6)
		event.queue_object_sequence_next_motion(4, "座り", 0)
		resume_step = 41
		message.show_voiced(2090245)
		resume_step = 42
		object.wait_until_done(4)
		event.mark_camera_sequence_fade_track()
		event.fade_out_music(30)
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		resume_step = 43
		wait.frames(30)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-44.56, 40.35, -82.32)
		event.set_camera_sequence_look_at(30.18, 23.34, -95.14)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(2, 29.51, 0.0, -37.25)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.set_object_sequence_position(3, 21.3, 0.0, -61.73)
		event.set_object_sequence_rotation(3, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(4, 59.82, 0.0, -98.58)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "座り", 4)
		event.set_object_sequence_motion(1, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "座り", 4)
		event.set_object_sequence_motion(4, "座り2", 4)
		event.stop_music(0)
		resume_step = 44
		wait.frames(4)
		event.load_music(101)
		event.play_music(0)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		event.move_camera_sequence_eased(-38.67, 40.35, -48.0, 36.07, 23.34, -60.82, 60, 2, 0.4)
		resume_step = 45
		camera.wait_until_done()
		event.set_object_sequence_motion(4, "座り会話", 6)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		resume_step = 46
		message.show_voiced(2090250)
		event.set_object_sequence_motion(4, "トボを指す", 6)
		event.queue_object_sequence_next_motion(4, "トボを指すL", 0)
		resume_step = 47
		message.show_voiced(2090253)
		event.set_object_sequence_motion(4, "ロココを指す", 6)
		event.queue_object_sequence_next_motion(4, "ロココを差すL", 0)
		resume_step = 48
		message.show_voiced(2090255)
		event.queue_object_sequence_next_motion(4, "ロココを指す戻り", 2)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		resume_step = 49
		message.show_voiced(2090257)
		event.set_object_sequence_motion(1, "座り会話", 2)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 50
		message.show_voiced(2090260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 51
		message.show_voiced(2090270)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "座り会話", 2)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 52
		message.show_voiced(2090280)
		event.reset_mouth_texture_animations()
		resume_step = 53
		object.wait_until_done(1)
		resume_step = 54
		message.show_voiced(2090290)
		event.set_object_sequence_motion(4, "座り会話", 2)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		resume_step = 55
		message.show_voiced(2090300)
		resume_step = 56
		message.show_voiced(2090305)
		resume_step = 57
		object.wait_until_done(4)
		event.set_camera_sequence_position(78.46, 25.97, -62.11)
		event.set_camera_sequence_look_at(60.62, 21.41, -99.2)
		event.set_object_sequence_motion(4, "座り2", 4)
		resume_step = 58
		message.show_voiced(2090310)
		event.set_camera_sequence_position(71.99, 24.65, -75.78)
		event.set_camera_sequence_look_at(95.96, 21.41, -49.6)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 59
		message.show_voiced(2090320)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(78.46, 25.97, -62.11)
		event.set_camera_sequence_look_at(60.62, 21.41, -99.2)
		event.set_object_sequence_motion(4, "座り会話", 6)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		resume_step = 60
		message.show_voiced(2090330)
		resume_step = 61
		message.show_voiced(2090335)
		resume_step = 62
		object.wait_until_done(4)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
		resume_step = 63
		message.show_voiced(2090340)
		resume_step = 64
		message.show_voiced(2090345)
		resume_step = 65
		message.show_voiced(2090350)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 15)
		resume_step = 66
		wait.frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		resume_step = 67
		message.show_voiced(2090360)
		resume_step = 68
		message.show_voiced(2090370)
		resume_step = 69
		message.show_voiced(2090375)
		resume_step = 70
		message.show_voiced(2090380)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128.0, 128.0, 128.0, 128.0, 15)
		resume_step = 71
		wait.frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		resume_step = 72
		message.show_voiced(2090390)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(13, 128.0, 128.0, 128.0, 128.0, 15)
		resume_step = 73
		wait.frames(15)
		event.set_event_sprite_draw_pass(2, 0)
		resume_step = 74
		message.show_voiced(2090400)
		resume_step = 75
		message.show_voiced(2090410)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 128.0, 128.0, 128.0, 128.0, 15)
		resume_step = 76
		wait.frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		resume_step = 77
		message.show_voiced(2090420)
		resume_step = 78
		message.show_voiced(2090430)
		event.set_camera_sequence_position(90.58, 30.29, -39.36)
		event.set_camera_sequence_look_at(66.74, 28.6, -43.56)
		event.set_object_sequence_motion(4, "ぽりぽり", 4)
		event.move_camera_sequence_eased(90.58, 30.29, -39.36, 78.8, 28.6, -60.82, 120, 2, 0.4)
		event.set_object_sequence_color(14, 128.0, 128.0, 128.0, 0.0, 15)
		resume_step = 79
		wait.frames(15)
		event.set_event_sprite_draw_pass(4, 0)
		resume_step = 80
		message.show_voiced(2090440)
		resume_step = 81
		message.show_voiced(2090445)
		resume_step = 82
		message.show_voiced(2090450)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		resume_step = 83
		message.show_voiced(2090460)
		resume_step = 84
		message.show_voiced(2090470)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 85
		message.show_voiced(2090480)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(82.07, 24.94, -61.63)
		event.set_camera_sequence_look_at(61.24, 20.49, -98.09)
		event.set_object_sequence_motion(4, "座り2", 4)
		resume_step = 86
		message.show_voiced(2090490)
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(1, 45)
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "右を見る", 6)
		event.queue_object_sequence_next_motion(0, "右を見るL", 0)
		event.set_object_sequence_motion(1, "座り会話", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 87
		message.show_voiced(2090500)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 88
		message.show_voiced(2090505)
		event.reset_mouth_texture_animations()
		resume_step = 89
		object.wait_until_done(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(117.78, 25.28, -19.32)
		event.set_camera_sequence_look_at(91.26, 22.12, -49.27)
		event.set_object_sequence_motion(0, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "座り会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(4, "座り2", 0)
		resume_step = 90
		message.show_voiced(2090510)
		event.set_camera_sequence_position(83.43, 24.94, -81.73)
		event.set_camera_sequence_look_at(100.36, 18.47, -43.72)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 91
		message.show_voiced(2090520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 92
		message.show_voiced(2090525)
		event.reset_mouth_texture_animations()
		resume_step = 93
		object.wait_until_done(1)
		event.set_camera_sequence_position(84.67, 30.18, -70.24)
		event.set_camera_sequence_look_at(51.19, 19.0, -102.93)
		event.set_object_sequence_motion(4, "ぽりぽり", 4)
		resume_step = 94
		message.show_voiced(2090530)
		resume_step = 95
		message.show_voiced(2090535)
		resume_step = 96
		wait.frames(60)
		event.delay_object_sequence_motion_track(4, 30)
		event.set_object_sequence_motion(4, "そうじゃ", 6)
		event.queue_object_sequence_next_motion(4, "そうじゃL", 0)
		resume_step = 97
		message.show_voiced(2090540)
		event.set_camera_sequence_position(76.8, 23.38, -37.04)
		event.set_camera_sequence_look_at(35.31, 22.33, -45.08)
		event.set_object_sequence_position(3, 22.62, 0.0, -61.38)
		event.set_mouth_texture_animations(2, "口パク")
		resume_step = 98
		message.show_voiced(2090550)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		resume_step = 99
		message.show_voiced(2090560)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(81.93, 21.24, -74.02)
		event.set_camera_sequence_look_at(90.52, 21.61, -60.68)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目あきれ")
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(1, "あきれる", 6)
		event.queue_object_sequence_next_motion(1, "座り", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 100
		message.show_voiced(2090570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.play_sound_effect(sound_bank, 14)
		event.set_object_sequence_motion(0, "衝撃", 6)
		event.set_object_sequence_motion(0, "衝撃L", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 101
		message.show_voiced(2090580)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 102
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			swap_character_slots()
			wait.frames_skipping(90)
		end
		if resume_step <= 2 then
			wait.frames_skipping(60)
		end
		if resume_step <= 3 then
			message.show_voiced_skipping(2090070)
		end
		if resume_step <= 4 then
			wait.frames_skipping(45)
		end
		if resume_step <= 5 then
			wait.frames_skipping(30)
		end
		if resume_step <= 6 then
			wait.frames_skipping(20)
		end
		if resume_step <= 7 then
			wait.frames_skipping(15)
		end
		if resume_step <= 8 then
			message.show_voiced_skipping(2090080)
		end
		if resume_step <= 9 then
			wait.frames_skipping(53)
		end
		if resume_step <= 10 then
			wait.frames_skipping(15)
		end
		if resume_step <= 11 then
			message.show_voiced_skipping(2090090)
		end
		if resume_step <= 12 then
			cutscene.skip_command(1)
		end
		if resume_step <= 13 then
			wait.frames_skipping(37)
		end
		if resume_step <= 14 then
			message.show_voiced_skipping(2090100)
		end
		if resume_step <= 15 then
			wait.frames_skipping(20)
		end
		if resume_step <= 16 then
			message.show_voiced_skipping(2090110)
		end
		if resume_step <= 17 then
			wait.frames_skipping(36)
		end
		if resume_step <= 18 then
			wait.frames_skipping(15)
		end
		if resume_step <= 19 then
			message.show_voiced_skipping(2090120)
		end
		if resume_step <= 20 then
			message.show_voiced_skipping(2090125)
		end
		if resume_step <= 21 then
			cutscene.skip_command(1)
		end
		if resume_step <= 22 then
			wait.frames_skipping(15)
		end
		if resume_step <= 23 then
			wait.frames_skipping(13)
		end
		if resume_step <= 24 then
			message.show_voiced_skipping(2090130)
		end
		if resume_step <= 25 then
			message.show_voiced_skipping(2090140)
		end
		if resume_step <= 26 then
			message.show_voiced_skipping(2090150)
		end
		if resume_step <= 27 then
			message.show_voiced_skipping(2090160)
		end
		if resume_step <= 28 then
			message.show_voiced_skipping(2090170)
		end
		if resume_step <= 29 then
			message.show_voiced_skipping(2090180)
		end
		if resume_step <= 30 then
			message.show_voiced_skipping(2090190)
		end
		if resume_step <= 31 then
			local _ = mints_slot ~= 0
			cutscene.skip_command(1)
		end
		if resume_step <= 32 then
			message.show_voiced_skipping(2090200)
		end
		if resume_step <= 33 then
			cutscene.skip_command(2)
		end
		if resume_step <= 34 then
			message.show_voiced_skipping(2090210)
		end
		if resume_step <= 35 then
			local _ = mints_slot ~= 0
			wait.frames_skipping(13)
		end
		if resume_step <= 36 then
			message.show_voiced_skipping(2090220)
		end
		if resume_step <= 37 then
			message.show_voiced_skipping(2090230)
		end
		if resume_step <= 38 then
			message.show_voiced_skipping(2090235)
		end
		if resume_step <= 39 then
			message.show_voiced_skipping(2090240)
		end
		if resume_step <= 40 then
			message.show_voiced_skipping(2090245)
		end
		if resume_step <= 41 then
			cutscene.skip_command(4)
		end
		if resume_step <= 42 then
			wait.frames_skipping(30)
		end
		if resume_step <= 43 then
			wait.frames_skipping(4)
		end
		if resume_step <= 44 then
			wait.background_load_skipping()
		end
		if resume_step <= 45 then
			message.show_voiced_skipping(2090250)
		end
		if resume_step <= 46 then
			message.show_voiced_skipping(2090253)
		end
		if resume_step <= 47 then
			message.show_voiced_skipping(2090255)
		end
		if resume_step <= 48 then
			message.show_voiced_skipping(2090257)
		end
		if resume_step <= 49 then
			message.show_voiced_skipping(2090260)
		end
		if resume_step <= 50 then
			message.show_voiced_skipping(2090270)
		end
		if resume_step <= 51 then
			message.show_voiced_skipping(2090280)
		end
		if resume_step <= 52 then
			cutscene.skip_command(1)
		end
		if resume_step <= 53 then
			message.show_voiced_skipping(2090290)
		end
		if resume_step <= 54 then
			message.show_voiced_skipping(2090300)
		end
		if resume_step <= 55 then
			message.show_voiced_skipping(2090305)
		end
		if resume_step <= 56 then
			cutscene.skip_command(4)
		end
		if resume_step <= 57 then
			message.show_voiced_skipping(2090310)
		end
		if resume_step <= 58 then
			message.show_voiced_skipping(2090320)
		end
		if resume_step <= 59 then
			message.show_voiced_skipping(2090330)
		end
		if resume_step <= 60 then
			message.show_voiced_skipping(2090335)
		end
		if resume_step <= 61 then
			cutscene.skip_command(4)
		end
		if resume_step <= 62 then
			message.show_voiced_skipping(2090340)
		end
		if resume_step <= 63 then
			message.show_voiced_skipping(2090345)
		end
		if resume_step <= 64 then
			message.show_voiced_skipping(2090350)
		end
		if resume_step <= 65 then
			wait.frames_skipping(15)
		end
		if resume_step <= 66 then
			message.show_voiced_skipping(2090360)
		end
		if resume_step <= 67 then
			message.show_voiced_skipping(2090370)
		end
		if resume_step <= 68 then
			message.show_voiced_skipping(2090375)
		end
		if resume_step <= 69 then
			message.show_voiced_skipping(2090380)
		end
		if resume_step <= 70 then
			wait.frames_skipping(15)
		end
		if resume_step <= 71 then
			message.show_voiced_skipping(2090390)
		end
		if resume_step <= 72 then
			wait.frames_skipping(15)
		end
		if resume_step <= 73 then
			message.show_voiced_skipping(2090400)
		end
		if resume_step <= 74 then
			message.show_voiced_skipping(2090410)
		end
		if resume_step <= 75 then
			wait.frames_skipping(15)
		end
		if resume_step <= 76 then
			message.show_voiced_skipping(2090420)
		end
		if resume_step <= 77 then
			message.show_voiced_skipping(2090430)
		end
		if resume_step <= 78 then
			wait.frames_skipping(15)
		end
		if resume_step <= 79 then
			message.show_voiced_skipping(2090440)
		end
		if resume_step <= 80 then
			message.show_voiced_skipping(2090445)
		end
		if resume_step <= 81 then
			message.show_voiced_skipping(2090450)
		end
		if resume_step <= 82 then
			message.show_voiced_skipping(2090460)
		end
		if resume_step <= 83 then
			message.show_voiced_skipping(2090470)
		end
		if resume_step <= 84 then
			message.show_voiced_skipping(2090480)
		end
		if resume_step <= 85 then
			message.show_voiced_skipping(2090490)
		end
		if resume_step <= 86 then
			message.show_voiced_skipping(2090500)
		end
		if resume_step <= 87 then
			message.show_voiced_skipping(2090505)
		end
		if resume_step <= 88 then
			cutscene.skip_command(1)
		end
		if resume_step <= 89 then
			message.show_voiced_skipping(2090510)
		end
		if resume_step <= 90 then
			message.show_voiced_skipping(2090520)
		end
		if resume_step <= 91 then
			message.show_voiced_skipping(2090525)
		end
		if resume_step <= 92 then
			cutscene.skip_command(1)
		end
		if resume_step <= 93 then
			message.show_voiced_skipping(2090530)
		end
		if resume_step <= 94 then
			message.show_voiced_skipping(2090535)
		end
		if resume_step <= 95 then
			wait.frames_skipping(60)
		end
		if resume_step <= 96 then
			message.show_voiced_skipping(2090540)
		end
		if resume_step <= 97 then
			message.show_voiced_skipping(2090550)
		end
		if resume_step <= 98 then
			message.show_voiced_skipping(2090560)
		end
		if resume_step <= 99 then
			message.show_voiced_skipping(2090570)
		end
		if resume_step <= 100 then
			message.show_voiced_skipping(2090580)
		end
		if resume_step <= 101 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_forest_beauty_story_scene()
end

--- Plays the short recap of the forest beauty story with the dwarves seated.
local function play_forest_beauty_story_recap_scene()
	vm.section(function()
		event.initialize_event()
		load_forest_beauty_story_scene()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_object_handle_frame_visible(4, "cube37", 0)
		event.set_object_handle_frame_visible(4, "cube38", 0)
		event.set_camera_sequence_position(48.97, 32.89, 40.91)
		event.set_camera_sequence_look_at(61.89, 18.47, -74.73)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(0, 90.21, 0.0, -36.12)
		event.set_object_sequence_rotation(0, 0.0, -2.18, 0.0)
		event.set_object_sequence_position(1, 98.27, 0.0, -52.72)
		event.set_object_sequence_rotation(1, 0.0, -1.61, 0.0)
		event.set_object_sequence_position(2, 29.51, 0.0, -37.25)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.set_object_sequence_position(3, 21.3, 0.0, -61.73)
		event.set_object_sequence_rotation(3, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(4, 59.82, 0.0, -98.58)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "衝撃L", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "座り", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "座り", 4)
		event.set_object_sequence_motion(4, "座り会話2", 4)
		event.move_camera_sequence_eased(46.34, 32.89, 64.43, 61.89, 18.47, -74.73, 90, 2, 0.4)
		message.show_voiced(2090600)
		camera.wait_until_done()
		event.set_camera_sequence_position(82.72, 22.53, -61.3)
		event.set_camera_sequence_look_at(93.83, 21.33, -34.43)
		event.move_camera_sequence_eased(83.31, 22.53, -59.88, 92.29, 21.33, -38.16, 90, 2, 0.4)
		message.show_voiced(2090610)
		message.show_voiced(2090615)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, mints_slot, 256, 0)
	event.set_scene_status_flags(1, monica_slot, 256, 0)
	unload_forest_beauty_story_scene()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Spawns the seated dwarves, plays the introduction when due and places the player at the entrance.
function script.default_event()
	local flag: s32 = 0
	sindain_dwarves_house.spawn_seated_dwarves_if_flags_clear()
	flag = event.get_save_flag(247) or flag
	if flag == 1 then
		flag = event.get_save_flag(250) or flag
		if flag == 0 then
			play_dwarves_introduction_scene()
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "s47", 501)
			vm.wait(2)
			return
		end
	end
	event.set_character_position(0, 20.0, 19.5, 89.5)
	event.set_character_rotation(0, 0.0, 1.8, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1)
end

--- Waits for the menu button press instead of the default handler.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
end

--- Leaves the house to the Sindain map, jumping when the introduction has not played.
function script.exit_to_sindain()
	local flag: s32 = 0
	print("-----event200--------------------------------------\n")
	flag = event.get_save_flag(250) or flag
	if flag == 0 then
		event.jump_to_map_3(-1, "g01", 100)
		vm.wait(1)
		return
	end
	vm.wait(2)
	event.go_to_outside_map(-1, "g01", 100)
	vm.wait(3)
end
script[200] = script.exit_to_sindain

--- Asks with a choice prompt whether to enter the interior i01h01 and goes there when confirmed.
function script.ask_enter_i01h01()
	local choice: any = 0
	message.open_indexed_message(0)
	choice = message.ask_numbered_choice(0)
	message.close_third_window()
	if choice == 0 then
		event.go_to_interior_map(-1, "i01h01")
		vm.wait(2)
	end
end
script[500] = script.ask_enter_i01h01

--- Plays the forest beauty story and then jumps to the next map.
function script.play_story_scene_then_leave()
	play_forest_beauty_story_scene()
	event.fade_out_screen(30)
	wait.frames(30)
	event.skip_next_music_play()
	event.jump_to_map_3(-1, "s46", 501)
	vm.wait(3)
end
script[501] = script.play_story_scene_then_leave

--- Plays the story recap and then jumps to the next map.
function script.play_story_recap_then_leave()
	play_forest_beauty_story_recap_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s02", 502)
	vm.wait(2)
end
script[502] = script.play_story_recap_then_leave

--- Event 610, which map data, a script or the engine runs by number.
script.play_forest_beauty_story_scene = play_forest_beauty_story_scene
script[610] = script.play_forest_beauty_story_scene

--- Event 611, which map data, a script or the engine runs by number.
script.play_forest_beauty_story_recap_scene = play_forest_beauty_story_recap_scene
script[611] = script.play_forest_beauty_story_recap_scene

--- Plays the dwarf introduction and fades the screen in.
function script.play_introduction_scene_then_fade_in()
	play_dwarves_introduction_scene()
	event.fade_in_screen(30)
end
script[620] = script.play_introduction_scene_then_fade_in

--- Turns the player toward a dwarf and shows that dwarf's line of dialogue.
function script.talk_to_dwarf()
	local dwarf_slot: s32 = 0
	local player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local dwarf_x: f32 = 0
	local dwarf_z: f32 = 0
	local target_angle: f32 = 0
	dwarf_slot = event.get_triggered_event_data_2(13) or dwarf_slot
	player_slot = event.get_player_character_slot() or player_slot
	do
		local out1, _, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_position(dwarf_slot)
		dwarf_x = out1 or dwarf_x
		dwarf_z = out3 or dwarf_z
	end
	target_angle = event.get_look_angle(dwarf_x - player_x, dwarf_z - player_z) or target_angle
	character.turn_to_angle(player_slot, target_angle)
	event.set_character_rotation(player_slot, 0.0, target_angle, 0.0)
	event.set_character_motion(player_slot, "立ち")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	if dwarf_slot == 8 then
		event.open_message_window_2(
			0,
			"Esc[UNI00fa]chame: ten precauci[UNI00f3]n\ny no te tropieces con la\nmaldita Mariposa Arco Iris, [UNI00bf]entendido?<page>Y si la ves,\nhaz como si no estuviera all[UNI00ed]."
		)
		message.say_bubble(0, -1, dwarf_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Incluso si la vieras un instante de nada\n, todo deber[UNI00ed]a ir bien\nsi haces como que no la ves.<page>A lo mejor..."
		)
	end
	if dwarf_slot == 9 then
		event.open_message_window_2(
			0,
			"C[UNI00f3]mo me gustar[UNI00ed]a darle un\nbuen bocado al pastel de patata de Holly y tomarme\nun vaso de zumo de uva, s[UNI00ed] se[UNI00f1]or."
		)
	end
	if dwarf_slot == 10 then
		event.open_message_window_2(
			0,
			"Holly se fue y nos dej[UNI00f3] \ny mis cuatro amigos a[UNI00fa]n no han vuelto.<page>No puedo soportar la idea de\nperder a nadie m[UNI00e1]s."
		)
	end
	message.say_bubble(0, -1, dwarf_slot, player_slot, 0)
end
script[1000] = script.talk_to_dwarf

--- Plays the dwarf introduction and jumps to the follow-up map.
function script.play_introduction_scene_then_jump()
	play_dwarves_introduction_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s47", 501)
	vm.wait(2)
end
script[12500] = script.play_introduction_scene_then_jump

return script
