--!strict
--- Event script for the Kazarov stonehenge map, covering the night scene with Eina and the cutscenes that lead on to the neighbouring maps.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the player characters, Eina, the extra actors and the map parts used by the night scene and assigns their slots by the playable character.
local function load_night_scene_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_message_file(0, 5, "event/e700/e736/e736.txt")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e736/e736_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/e700/e736/e736_monica.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		max_slot = 33
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e736/e736_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e700/e736/e736_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.set_character_active(0, monica_slot)
	end
	event.assign_memory_stack(6)
	event.clear_memory_stack(6)
	event.load_character(6, "event/e700/e736/e736_c_union.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.load_character(6, "event/e700/e736/e736_eina.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(4, 38)
	event.clear_object_sequence(4, 38)
	event.set_object_sequence_object(4, 4)
	event.load_character(6, "event/e700/e736/p00_05a.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5, 39)
	event.set_object_sequence_object(5, 5)
	event.load_character(6, "event/e700/e736/p00_31a.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(6, 40)
	event.clear_object_sequence(6, 40)
	event.set_object_sequence_object(6, 6)
	event.load_character(6, "event/e700/e736/e736_kieru_hikari.gltf", "info", 45)
	event.set_character_active(0, 45)
	event.copy_character(6, 45, 46)
	event.set_character_active(0, 46)
	event.copy_character(6, 45, 47)
	event.set_character_active(0, 47)
	event.copy_character(6, 45, 48)
	event.set_character_active(0, 48)
	event.attach_object_handle_to_map_part_2(14, "p01_s98")
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.set_object_handle_visible(14, 1)
	event.set_object_sequence_position(14, -2000.0, 9000.0, -9000.0)
	event.set_object_sequence_rotation(14, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_2(15, "p01_gekka")
	event.set_object_handle_visible(15, 0)
end

--- Assigns the Max and Monica character slots as they are when Monica is the playable character.
local function assign_monica_playable_slots()
	max_slot = 0
	monica_slot = 33
	max_slot = 33
	monica_slot = 0
end

--- Restores the playable character, deletes every actor loaded for the night scene and swaps the map parts back.
local function unload_night_scene_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(47)
	event.delete_character(48)
	event.delete_character(49)
	event.delete_character(50)
	event.delete_character(51)
	event.delete_character(52)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_visible(15, 1)
end

--- Plays the skippable night scene where the party grieves with Eina, Eina and her companions vanish in light, and Tom, Vorneo and Starbre appear in the sky.
local function play_night_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local original_time_of_day: f32 = 0
	local resume_point: number = 0
	vm.section(function()
		event.set_save_flag(736, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		resume_point = 1
		vm.wait(1)
		resume_point = 2
		vm.wait(2)
		resume_point = 3
		vm.wait(3)
		resume_point = 4
		vm.wait(4)
		event.load_music(118)
		event.load_map_sounds(6243)
		sound_bank = event.load_sound_effect_file_2(6243) or sound_bank
		event.fade_out_screen(30)
		resume_point = 5
		wait.for_frame_count(45)
		load_night_scene_actors()
		projection = event.get_event_projection() or projection
		original_time_of_day = event.get_scene_time_of_day() or original_time_of_day
		event.enable_drama_skip()
		event.set_time_of_day(21.5)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(4, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "泣き顔")
		event.set_object_sequence_texture_animation(0, 1, "泣き目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "かなし顔")
		event.set_object_sequence_texture_animation(1, 1, "かなし目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(6.53, 80.05, 766.11)
		event.set_camera_sequence_look_at(4.76, 541.47, 211.05)
		resume_point = 6
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(6.53, 80.05, 766.11, 4.76, 64.48, 211.05, 284, 2, 0.5)
		event.set_object_sequence_position(0, 6.03, -7.06, 200.37)
		event.set_object_sequence_rotation(0, 0.0, 2.33, 0.0)
		event.set_object_sequence_position(1, 24.67, -7.06, 178.01)
		event.set_object_sequence_rotation(1, 0.0, -0.67, 0.0)
		event.set_object_sequence_position(4, -39.08, -7.06, 139.45)
		event.set_object_sequence_rotation(4, 0.0, 0.65, 0.0)
		event.set_object_sequence_position(5, -63.71, -7.06, 154.12)
		event.set_object_sequence_rotation(5, 0.0, 1.01, 0.0)
		event.set_object_sequence_position(6, -79.03, -7.06, 188.9)
		event.set_object_sequence_rotation(6, 0.0, 1.01, 0.0)
		event.set_character_position(44, 0.0, 3300.0, 0.0)
		event.set_character_scale(44, 30.0, 30.0, 30.0)
		event.set_character_motion(44, "ループ", 4, -1, 1)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_character_active(1, 40)
		event.set_character_active(1, 44)
		event.play_sound_effect(sound_bank, 2)
		event.fade_in_screen(30)
		event.play_music(0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		resume_point = 7
		wait.for_frame_count(15)
		resume_point = 8
		camera.wait_until_done()
		event.set_camera_sequence_position(23.13, 18.08, 243.15)
		event.set_camera_sequence_look_at(13.28, 16.71, 190.69)
		event.move_camera_sequence_eased(-5.38, 18.08, 240.82, 13.28, 16.71, 190.69, 360, 2, 1.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 9
		message.show_voiced_for_stopping(7360010, -1)
		resume_point = 10
		wait.for_frame_count(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "かなし顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "うつむき", 6)
		event.queue_object_sequence_next_motion(1, "うつむきL", 4)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 11
		message.show_voiced_for_stopping(7360015, -1)
		resume_point = 12
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "かなし顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 13
		message.show_voiced_for_stopping(7360020, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "かなし顔")
		event.set_object_sequence_texture_animation(1, 1, "うる目")
		resume_point = 14
		wait.for_frame_count(15)
		resume_point = 15
		camera.wait_until_done()
		event.set_camera_sequence_position(9.36, 18.08, 134.06)
		event.set_camera_sequence_look_at(18.46, 16.71, 186.15)
		event.start_crossfade(30)
		event.move_camera_sequence_eased(37.9, 18.08, 136.86, 18.46, 16.71, 186.15, 240, 2, 1.0)
		resume_point = 16
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "モニカ見立うなづき", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 17
		message.show_voiced_for_stopping(7360030, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "泣き顔")
		event.set_object_sequence_texture_animation(1, 1, "泣き目パチ")
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 18
		message.show_voiced_for_stopping(7360035, -1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "泣き顔")
		event.set_object_sequence_texture_animation(1, 1, "泣き目あき～目とじ")
		event.set_object_sequence_motion(1, "うなづき", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口わらい")
		resume_point = 19
		message.show_voiced_for_stopping(7360040, 30)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "泣き顔")
		event.set_object_sequence_texture_animation(0, 1, "泣き目～通常目")
		resume_point = 20
		wait.for_frame_count(15)
		resume_point = 21
		camera.wait_until_done()
		event.set_camera_sequence_position(40.36, 16.65, 283.36)
		event.set_camera_sequence_look_at(10.43, 16.71, 186.62)
		event.move_camera_sequence_eased(2.3, 16.65, 295.13, -27.63, 16.71, 198.39, 180, 2, 1.0)
		event.set_object_sequence_motion(0, "左", 6)
		event.queue_object_sequence_next_motion(0, "左L", 4)
		resume_point = 22
		message.show_voiced_for_stopping(7360050, -1)
		resume_point = 23
		message.show_voiced_for_stopping(7360060, -1)
		resume_point = 24
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "泣き顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～かなし目")
		event.set_object_sequence_motion(4, "歩き")
		event.move_object_sequence(4, -8.93, -7.06, 177.8, 120)
		resume_point = 25
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "目あき～目とじ")
		resume_point = 26
		wait.for_frame_count(30)
		resume_point = 27
		camera.wait_until_done()
		event.set_object_sequence_position(1, -118.41, -7.06, 31.17)
		event.set_object_sequence_rotation(1, 0.0, 0.53, 0.0)
		event.set_object_sequence_position(0, -8.93, -7.06, 177.8)
		event.set_object_sequence_rotation(0, 0.0, 0.65, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "かなし目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～目あき")
		event.set_camera_sequence_position(-4.66, 14.22, 222.94)
		event.set_camera_sequence_look_at(-5.05, 19.91, 179.84)
		event.set_object_sequence_motion(0, "エイナ見立ち", 4, -1, 1)
		resume_point = 28
		object.wait_until_done(4)
		event.set_object_sequence_motion(4, "立ち")
		event.set_mouth_texture_animations(4, "わらい口パク")
		resume_point = 29
		message.show_voiced_for_stopping(7360070, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 30
		message.show_voiced_for_stopping(7360080, -1)
		event.reset_mouth_texture_animations()
		resume_point = 31
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(4, "わらい口パク")
		resume_point = 32
		message.show_voiced_for_stopping(7360090, -1)
		event.reset_mouth_texture_animations()
		resume_point = 33
		wait.for_frame_count(15)
		event.set_camera_sequence_position(-45.47, 18.64, 171.07)
		event.set_camera_sequence_look_at(-4.63, 19.91, 182.55)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目～泣き目")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "下見る", 6)
		event.queue_object_sequence_next_motion(0, "下見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 34
		message.show_voiced_for_stopping(7360100, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "泣き目パチ")
		resume_point = 35
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_motion(0, "下見る戻り", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 36
		message.show_voiced_for_stopping(7360110, -1)
		event.reset_mouth_texture_animations()
		resume_point = 37
		object.wait_until_done(0)
		event.set_camera_sequence_position(-4.66, 14.22, 222.94)
		event.set_camera_sequence_look_at(-5.05, 19.91, 179.84)
		event.set_mouth_texture_animations(4, "わらい口パク")
		resume_point = 38
		message.show_voiced_for_stopping(7360120, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "うる目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_mouth_texture_animations(4, "通常口パク")
		resume_point = 39
		message.show_voiced_for_stopping(7360130, -1)
		event.reset_mouth_texture_animations()
		resume_point = 40
		wait.for_frame_count(15)
		event.set_camera_sequence_position(-45.47, 18.64, 171.07)
		event.set_camera_sequence_look_at(-4.63, 19.91, 182.55)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "うる目～目とじ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(0, "涙をふく", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 4)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき２")
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 41
		message.show_voiced_for_stopping(7360140, -1)
		event.reset_mouth_texture_animations()
		resume_point = 42
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "手を広げる", 6)
		event.queue_object_sequence_next_motion(0, "手を広げるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 43
		message.show_voiced_for_stopping(7360145, -1)
		event.reset_mouth_texture_animations()
		resume_point = 44
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～下向き")
		event.set_object_sequence_motion(0, "手を広げる戻り", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 45
		message.show_voiced_for_stopping(7360150, -1)
		event.reset_mouth_texture_animations()
		resume_point = 46
		wait.for_frame_count(15)
		resume_point = 47
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "下向き～目とじ")
		event.set_object_sequence_motion(0, "下見る", 6)
		event.queue_object_sequence_next_motion(0, "下見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 48
		message.show_voiced_for_stopping(7360155, -1)
		event.reset_mouth_texture_animations()
		resume_point = 49
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "下見る戻り", 2)
		resume_point = 50
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-45.34, 17.5, 214.87)
		event.set_camera_sequence_look_at(37.61, 23.19, 150.26)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "泣き目あき～目とじ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき～目とじ")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～半口～口とじ")
		event.set_object_sequence_motion(0, "抱く", 6)
		event.queue_object_sequence_next_motion(0, "抱くL", 4)
		event.set_object_sequence_motion(4, "抱く", 6)
		event.queue_object_sequence_next_motion(4, "抱くL", 4)
		event.play_sound_effect(sound_bank, 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		resume_point = 51
		message.show_voiced_for_stopping(7360160, -1)
		event.reset_mouth_texture_animations()
		resume_point = 52
		object.wait_until_done(0)
		event.set_mouth_texture_animations(4, "わらい口パク")
		resume_point = 53
		message.show_voiced_for_stopping(7360170, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～泣き目あき")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき３")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "抱く戻り", 2)
		event.queue_object_sequence_next_motion(0, "抱く戻りL", 4)
		event.set_object_sequence_motion(4, "抱く戻り", 2)
		event.queue_object_sequence_next_motion(4, "抱く戻りL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		resume_point = 54
		message.show_voiced_for_stopping(7360180, -1)
		event.reset_mouth_texture_animations()
		resume_point = 55
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "うる目")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "うる目２")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(4, "後ずさり", 2)
		event.queue_object_sequence_next_motion(4, "後ずさりL", 4)
		event.move_object_sequence(4, -24.91, -7.06, 157.36, 60)
		resume_point = 56
		object.wait_until_done(4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "泣き顔")
		event.set_object_sequence_texture_animation(1, 1, "泣き目パチ")
		event.set_object_sequence_texture_animation(1, 1, "口わらい")
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(34.99, 37.57, 229.69, -39.55, 3.5, 143.97)
		event.add_camera_sequence_path_point(-14.43, 37.57, 171.71, -89.76, 3.5, 90.67)
		event.start_camera_sequence_path()
		event.set_object_sequence_rotation(0, 0.0, -2.35, 0.0)
		event.set_object_sequence_position(4, -68.67, -7.06, 112.54)
		event.set_object_sequence_rotation(4, 0.0, 0.77, 0.0)
		event.set_object_sequence_position(5, -139.47, -7.06, 60.43)
		event.set_object_sequence_rotation(5, 0.0, 0.65, 0.0)
		event.set_object_sequence_position(6, -144.0, -7.06, 85.39)
		event.set_object_sequence_rotation(6, 0.0, 0.89, 0.0)
		event.set_character_position(45, -118.41, -7.06, 31.17)
		event.set_character_position(46, -68.67, -7.06, 112.54)
		event.set_character_position(47, -139.47, -7.06, 60.43)
		event.set_character_position(48, -144.0, -7.06, 85.39)
		event.set_object_sequence_motion(0, "母さん！！", 6)
		event.queue_object_sequence_next_motion(0, "母さん！！L", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 57
		message.show_voiced_for_stopping(7360190, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 5)
		event.set_character_motion(47, "発動", 6, -1, 1)
		event.set_character_active(1, 47)
		event.set_character_visible(39, 0, 1, 0.025)
		resume_point = 58
		wait.for_frame_count(3)
		event.set_character_motion(48, "発動", 6, -1, 1)
		event.set_character_active(1, 48)
		event.set_character_visible(40, 0, 1, 0.025)
		resume_point = 59
		wait.for_frame_count(5)
		event.set_character_motion(45, "発動", 6, -1, 1)
		event.set_character_active(1, 45)
		event.set_character_visible(monica_slot, 0, 1, 0.025)
		event.set_character_active(0, 37)
		resume_point = 60
		wait.for_frame_count(45)
		event.set_character_motion(46, "発動", 6, -1, 1)
		event.set_character_active(1, 46)
		event.set_character_visible(38, 0, 1, 0.025)
		event.set_character_active(0, monica_slot)
		resume_point = 61
		wait.for_frame_count(120)
		event.set_character_active(0, 38)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_character_active(0, 45)
		event.set_character_active(0, 46)
		event.set_character_active(0, 47)
		event.set_character_active(0, 48)
		event.delete_character(38)
		event.delete_character(39)
		event.delete_character(40)
		event.delete_character(monica_slot)
		event.delete_character(45)
		event.delete_character(46)
		event.delete_character(47)
		event.delete_character(48)
		event.delete_character(44)
		event.clear_memory_stack(6)
		event.load_character(6, "event/e700/e736/e736_tojiru.gltf", "info", 44)
		event.set_character_active(0, 44)
		event.load_character(6, "event/e700/e736/e736_nobori_new.gltf", "info", 49)
		event.set_character_active(0, 49)
		event.attach_object_handle_to_character(10, 49)
		event.clear_object_sequence(10, 49)
		event.set_object_sequence_object(10, 10)
		event.copy_character(6, 49, 50)
		event.set_character_active(0, 50)
		event.attach_object_handle_to_character(11, 50)
		event.clear_object_sequence(11, 50)
		event.set_object_sequence_object(11, 11)
		event.copy_character(6, 49, 51)
		event.set_character_active(0, 51)
		event.attach_object_handle_to_character(12, 51)
		event.clear_object_sequence(12, 51)
		event.set_object_sequence_object(12, 12)
		event.copy_character(6, 49, 52)
		event.set_character_active(0, 52)
		event.attach_object_handle_to_character(13, 52)
		event.clear_object_sequence(13, 52)
		event.set_object_sequence_object(13, 13)
		event.load_character(6, "event/e700/e736/e736_tom.gltf", "info", 41)
		event.set_character_active(0, 41)
		event.attach_object_handle_to_character(7, 41)
		event.clear_object_sequence(7, 41)
		event.set_object_sequence_object(7, 7)
		event.load_character(6, "event/e700/e736/e736_vorneo.gltf", "info", 42)
		event.set_character_active(0, 42)
		event.attach_object_handle_to_character(8, 42)
		event.clear_object_sequence(8, 42)
		event.set_object_sequence_object(8, 8)
		event.load_character(6, "event/e700/e736/e736_starbre.gltf", "info", 43)
		event.set_character_active(0, 43)
		event.attach_object_handle_to_character(9, 43)
		event.clear_object_sequence(9, 43)
		event.set_object_sequence_object(9, 9)
		event.set_character_position(44, 0.0, 2500.0, 0.0)
		event.set_character_scale(44, 10.0, 10.0, 10.0)
		event.set_character_active(1, 44)
		event.set_character_active(1, 49)
		event.set_character_active(1, 50)
		event.set_character_active(1, 51)
		event.set_character_active(1, 52)
		event.set_character_scale(49, 4.0, 4.0, 4.0)
		event.set_character_scale(50, 4.0, 4.0, 4.0)
		event.set_character_scale(51, 4.0, 4.0, 4.0)
		event.set_character_scale(52, 4.0, 4.0, 4.0)
		event.set_character_position(49, -150.0, -7.06, 150.0)
		event.set_character_position(50, -15.0, -7.06, -150.0)
		event.set_character_position(51, 65.0, -7.06, -150.0)
		event.set_character_position(52, 150.0, -7.06, 150.0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 41)
		event.set_character_active(1, 42)
		event.set_character_active(1, 43)
		event.set_object_sequence_position(7, -61.65, -268.37, 2725.79)
		event.set_object_sequence_rotation(7, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(8, -36.27, -268.37, 2730.68)
		event.set_object_sequence_rotation(8, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(9, -11.81, -268.37, 2711.11)
		event.set_object_sequence_rotation(9, 0.0, -3.0, 0.0)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_object_sequence_motion(9, "立ち", 4)
		event.play_sound_effect(sound_bank, 6)
		event.set_camera_sequence_position(-26.29, -233.08, 2912.11)
		event.set_camera_sequence_look_at(-24.95, 6.64, 2652.48)
		event.move_camera_sequence_eased(-26.29, -233.08, 2912.11, -24.95, -215.15, 2652.48, 600, 0, 0.5)
		event.move_object_sequence(10, 0.0, 3000.0, 0.0, 240)
		resume_point = 62
		wait.for_frame_count(10)
		event.move_object_sequence(11, 0.0, 3000.0, 0.0, 240)
		resume_point = 63
		wait.for_frame_count(10)
		event.move_object_sequence(12, 0.0, 3000.0, 0.0, 240)
		resume_point = 64
		wait.for_frame_count(10)
		event.move_object_sequence(13, 0.0, 3000.0, 0.0, 240)
		resume_point = 65
		wait.for_frame_count(210)
		event.set_character_visible(49, 0, 1, 0.025)
		resume_point = 66
		wait.for_frame_count(10)
		event.set_character_visible(50, 0, 1, 0.025)
		resume_point = 67
		wait.for_frame_count(10)
		event.set_character_visible(51, 0, 1, 0.025)
		resume_point = 68
		wait.for_frame_count(10)
		event.set_character_visible(52, 0, 1, 0.025)
		resume_point = 69
		wait.for_frame_count(10)
		event.set_character_visible(44, 0, 1, 0.0125)
		resume_point = 70
		object.wait_until_done(10)
		resume_point = 71
		object.wait_until_done(11)
		resume_point = 72
		object.wait_until_done(12)
		resume_point = 73
		object.wait_until_done(13)
		event.set_character_active(0, 49)
		event.set_character_active(0, 50)
		event.set_character_active(0, 51)
		event.set_character_active(0, 52)
		event.start_crossfade(30)
		event.set_object_handle_visible(14, 0)
		event.set_mouth_texture_animations(9, "通常口パク")
		resume_point = 74
		message.show_voiced_for_stopping(7360200, -1)
		event.reset_mouth_texture_animations()
		resume_point = 75
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(8, "通常口パク")
		resume_point = 76
		message.show_voiced_for_stopping(7360210, -1)
		event.reset_mouth_texture_animations()
		resume_point = 77
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(8, "通常口パク")
		resume_point = 78
		message.show_voiced_for_stopping(7360215, -1)
		event.reset_mouth_texture_animations()
		resume_point = 79
		camera.wait_until_done()
		event.set_character_active(0, 44)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(360)
		event.add_camera_sequence_path_point(-102.41, -105.05, 2573.33, -32.34, -245.11, 2715.49)
		event.add_camera_sequence_path_point(-50.57, -128.25, 2558.78, -32.34, -245.11, 2715.49)
		event.add_camera_sequence_path_point(11.71, -166.6, 2586.87, -32.34, -245.11, 2715.49)
		event.add_camera_sequence_path_point(30.07, -183.67, 2650.65, -32.34, -245.11, 2715.49)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(7, "口パク")
		resume_point = 80
		message.show_voiced_for_stopping(7360220, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(9, "通常口パク")
		resume_point = 81
		message.show_voiced_for_stopping(7360230, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "えっ？", 6)
		event.queue_object_sequence_next_motion(7, "えっ？Ｌ", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		resume_point = 82
		message.show_voiced_for_stopping(7360240, 30)
		event.reset_mouth_texture_animations()
		resume_point = 83
		wait.for_frame_count(15)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-66.1, -251.95, 2901.4)
		event.set_camera_sequence_look_at(-26.73, -211.8, 2660.25)
		event.move_camera_sequence_eased(-66.1, -251.95, 2901.4, -26.73, 95.62, 2660.25, 540, 2, 1.0)
		event.set_mouth_texture_animations(9, "通常口パク")
		resume_point = 84
		message.show_voiced_for_stopping(7360250, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(9, "通常口パク")
		resume_point = 85
		message.show_voiced_for_stopping(7360255, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(7, "通常口パク")
		resume_point = 86
		message.show_voiced_for_stopping(7360260, -1)
		event.reset_mouth_texture_animations()
		resume_point = 87
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_point <= 4 then
			wait.skip_frame_count(45)
		end
		if resume_point <= 5 then
			assign_monica_playable_slots()
			wait.skip_frame_count(60)
		end
		if resume_point <= 6 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 7 then
			wait.background_load_skipping()
		end
		if resume_point <= 8 then
			message.show_voiced_for_stopping_skipping(7360010, -1)
		end
		if resume_point <= 9 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 10 then
			message.show_voiced_for_stopping_skipping(7360015, -1)
		end
		if resume_point <= 11 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 12 then
			message.show_voiced_for_stopping_skipping(7360020, -1)
		end
		if resume_point <= 13 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 14 then
			wait.background_load_skipping()
		end
		if resume_point <= 15 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 16 then
			message.show_voiced_for_stopping_skipping(7360030, -1)
		end
		if resume_point <= 17 then
			message.show_voiced_for_stopping_skipping(7360035, -1)
		end
		if resume_point <= 18 then
			message.show_voiced_for_stopping_skipping(7360040, 30)
		end
		if resume_point <= 19 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 20 then
			wait.background_load_skipping()
		end
		if resume_point <= 21 then
			message.show_voiced_for_stopping_skipping(7360050, -1)
		end
		if resume_point <= 22 then
			message.show_voiced_for_stopping_skipping(7360060, -1)
		end
		if resume_point <= 23 then
			wait.background_load_skipping()
		end
		if resume_point <= 24 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 25 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 26 then
			wait.background_load_skipping()
		end
		if resume_point <= 27 then
			cutscene.skip_command(4)
		end
		if resume_point <= 28 then
			message.show_voiced_for_stopping_skipping(7360070, -1)
		end
		if resume_point <= 29 then
			message.show_voiced_for_stopping_skipping(7360080, -1)
		end
		if resume_point <= 30 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 31 then
			message.show_voiced_for_stopping_skipping(7360090, -1)
		end
		if resume_point <= 32 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 33 then
			message.show_voiced_for_stopping_skipping(7360100, -1)
		end
		if resume_point <= 34 then
			cutscene.skip_command(0)
		end
		if resume_point <= 35 then
			message.show_voiced_for_stopping_skipping(7360110, -1)
		end
		if resume_point <= 36 then
			cutscene.skip_command(0)
		end
		if resume_point <= 37 then
			message.show_voiced_for_stopping_skipping(7360120, -1)
		end
		if resume_point <= 38 then
			message.show_voiced_for_stopping_skipping(7360130, -1)
		end
		if resume_point <= 39 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 40 then
			message.show_voiced_for_stopping_skipping(7360140, -1)
		end
		if resume_point <= 41 then
			cutscene.skip_command(0)
		end
		if resume_point <= 42 then
			message.show_voiced_for_stopping_skipping(7360145, -1)
		end
		if resume_point <= 43 then
			cutscene.skip_command(0)
		end
		if resume_point <= 44 then
			message.show_voiced_for_stopping_skipping(7360150, -1)
		end
		if resume_point <= 45 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 46 then
			cutscene.skip_command(0)
		end
		if resume_point <= 47 then
			message.show_voiced_for_stopping_skipping(7360155, -1)
		end
		if resume_point <= 48 then
			cutscene.skip_command(0)
		end
		if resume_point <= 49 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 50 then
			message.show_voiced_for_stopping_skipping(7360160, -1)
		end
		if resume_point <= 51 then
			cutscene.skip_command(0)
		end
		if resume_point <= 52 then
			message.show_voiced_for_stopping_skipping(7360170, -1)
		end
		if resume_point <= 53 then
			message.show_voiced_for_stopping_skipping(7360180, -1)
		end
		if resume_point <= 54 then
			cutscene.skip_command(0)
		end
		if resume_point <= 55 then
			cutscene.skip_command(4)
		end
		if resume_point <= 56 then
			message.show_voiced_for_stopping_skipping(7360190, -1)
		end
		if resume_point <= 57 then
			wait.skip_frame_count(3)
		end
		if resume_point <= 58 then
			wait.skip_frame_count(5)
		end
		if resume_point <= 59 then
			wait.skip_frame_count(45)
		end
		if resume_point <= 60 then
			wait.skip_frame_count(120)
		end
		if resume_point <= 61 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 62 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 63 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 64 then
			wait.skip_frame_count(210)
		end
		if resume_point <= 65 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 66 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 67 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 68 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 69 then
			cutscene.skip_command(10)
		end
		if resume_point <= 70 then
			cutscene.skip_command(11)
		end
		if resume_point <= 71 then
			cutscene.skip_command(12)
		end
		if resume_point <= 72 then
			cutscene.skip_command(13)
		end
		if resume_point <= 73 then
			message.show_voiced_for_stopping_skipping(7360200, -1)
		end
		if resume_point <= 74 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 75 then
			message.show_voiced_for_stopping_skipping(7360210, -1)
		end
		if resume_point <= 76 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 77 then
			message.show_voiced_for_stopping_skipping(7360215, -1)
		end
		if resume_point <= 78 then
			wait.background_load_skipping()
		end
		if resume_point <= 79 then
			message.show_voiced_for_stopping_skipping(7360220, -1)
		end
		if resume_point <= 80 then
			message.show_voiced_for_stopping_skipping(7360230, -1)
		end
		if resume_point <= 81 then
			message.show_voiced_for_stopping_skipping(7360240, 30)
		end
		if resume_point <= 82 then
			wait.skip_frame_count(15)
		end
		if resume_point <= 83 then
			message.show_voiced_for_stopping_skipping(7360250, -1)
		end
		if resume_point <= 84 then
			message.show_voiced_for_stopping_skipping(7360255, -1)
		end
		if resume_point <= 85 then
			message.show_voiced_for_stopping_skipping(7360260, -1)
		end
		if resume_point <= 86 then
			wait.background_load_skipping()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	resume_point = 88
	wait.for_frame_count(35)
	event.stop_port_sound_effects(4)
	event.set_event_projection(projection)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(4, 0)
	event.set_time_of_day(original_time_of_day)
	resume_point = 89
	vm.wait(89)
	unload_night_scene_actors()
end

--- Plays the scene in which the lapis beam shines, with the party reacting.
local function play_lapis_beam_scene()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(111)
		event.play_music(0)
		event.load_map_sounds(6206)
		sound_bank = event.load_sound_effect_file_2(6206) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e640_paz.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e640_hajike.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e640_hajike1.gltf", "info", 36)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 10.0, -7.1, 300.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -10.0, -7.1, 300.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(3, -2.85, 23.99, 5.49)
		event.set_object_handle_position(4, 491.48, 2937.75, -491.2)
		event.set_object_handle_position(2, -261.21, 2948.26, 263.88)
		event.set_object_handle_rotation(2, 0.0, 2.76, 0.0)
		event.set_object_handle_visible(2, 0)
		event.set_object_sequence_motion(2, "停止", 4)
		event.set_object_sequence_scale(2, 6.0, 6.0, 6.0)
		event.set_time_of_day(0)
		event.enable_drama_skip()
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(0, 35)
		event.set_character_active(0, 36)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(464.69, 792.55, 769.26)
		event.set_camera_sequence_look_at(-8.98, 22.94, 15.83)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 13.62, -7.06, 180.22, 120, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.queue_object_sequence_next_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -17.18, -7.06, 176.73, 120, 1)
		event.delay_object_sequence_motion_track(1, 120)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.fade_in_screen(30)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_camera_sequence_position(-6.27, -6.79, 122.45)
		event.set_camera_sequence_look_at(-6.44, 20.36, 185.12)
		event.set_object_sequence_position(0, 3.4, -7.06, 176.16)
		event.reset_object_sequence_dynamic_animation(0)
		wait.for_frame_count(30)
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.0, -1)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(0, "キョロキョロ")
		event.set_object_sequence_motion(1, "きょろきょろ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400010, -1)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400020, -1)
		wait.for_frame_count(20)
		event.stop_sound_effect(sound_bank, 0)
		wait.for_frame_count(10)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(731.98, 1651.1, -1178.87)
		event.set_camera_sequence_look_at(572.56, 1335.85, -926.68)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_active(35)
		event.set_object_sequence_motion(3, "ラピスビームのみ", 6)
		wait.for_frame_count(45)
		event.set_character_active(0, 35)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(0, 1.12, -7.06, 174.14)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_camera_sequence_position(515.15, 272.77, -565.02)
		event.set_camera_sequence_look_at(479.36, 1520.54, -493.2)
		event.set_motion_blur(100)
		event.set_character_active(36)
		event.set_object_sequence_motion(4, "ビーム収束", 6)
		event.queue_object_sequence_next_motion(4, "ループ", 4)
		event.delay_object_sequence_motion_track(4, 65)
		event.queue_object_sequence_next_motion(4, "はじけ", 6)
		event.wait_object_sequence_motion_end(4)
		wait.for_frame_count(140)
		event.set_camera_sequence_position(3959.58, 1269.87, -3946.94)
		event.set_camera_sequence_look_at(3453.93, 1511.55, -3437.8)
		wait.for_frame_count(140)
		event.start_crossfade(30)
		event.set_character_visible(34, 1, 1, 0.033333335)
		object.wait_until_done(4)
		event.set_object_handle_visible(4, 0)
		wait.for_frame_count(90)
		event.set_motion_blur(0)
		event.set_camera_sequence_position(-19.79, 61.27, 135.82)
		event.set_camera_sequence_look_at(-6.87, 2.39, 183.45)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しL", 4)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400030, -1)
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "やった！！", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced_for_stopping(6400040, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 1)
	event.set_motion_blur(0)
	event.stop_music(0)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
end

--- Plays the scene in which the party looks around and talks.
local function play_look_around_dialogue_scene()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(6212)
		sound_bank = event.load_sound_effect_file_2(6212) or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.stop_sound_effect(sound_bank, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_map_part_2(2, "p01_s98")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 12.52, -7.06, 206.03)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 35.37, -7.06, 202.4)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_visible(2, 0)
		event.set_time_of_day(0)
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 2)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(46.73, 6.1, 159.48)
		event.set_camera_sequence_look_at(23.33, 14.34, 206.91)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400140, -1)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400150, -1)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400160, -1)
		wait.for_frame_count(15)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400170, -1)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "右→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "左から上", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400180, -1)
		wait.for_frame_count(45)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced_for_stopping(6400190, -1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_sound_effect(sound_bank, 2)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
end

--- Plays the scene in which the flying object departs.
local function play_flying_object_departure_scene()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(6215)
		sound_bank = event.load_sound_effect_file_2(6215) or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.stop_sound_effect(sound_bank, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_map_part_2(2, "p01_gekka")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e520_dsmoke.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(3, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 26.1, -13.06, 439.65)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 46.14, -13.05, 435.43)
		event.set_object_handle_rotation(1, 0.0, -2.9, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -1611.8, 5821.6, -10655.5)
		event.set_object_handle_rotation(2, 0.5235988, 0.0, 0.0)
		event.set_object_handle_visible(2, 1)
		event.set_object_sequence_scale(2, 0.5, 0.5, 0.5)
		event.set_object_handle_position(3, -1611.8, 5821.6, -10655.5)
		event.set_object_handle_rotation(3, 0.0, -0.8, 0.0)
		event.set_object_sequence_scale(3, 0.3, 0.3, 0.3)
		event.set_object_handle_visible(3, 1)
		event.set_time_of_day(0)
		event.enable_drama_skip()
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(48.43, -8.6, 485.28)
		event.set_camera_sequence_look_at(27.26, 28.52, 399.92)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.fade_in_screen(30)
		event.move_object_sequence(2, -8095.4, 4770.2, -11356.4, 3000)
		event.rotate_object_sequence(2, 0.5235988, 0.0, 0.17453292, 1200)
		event.move_object_sequence(3, -8095.4, 4770.2, -11356.4, 3000)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(0, "やった！！", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced_for_stopping(6400220, -1)
		wait.for_frame_count(60)
		event.fade_out_music(30)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400230, -1)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(117)
		event.play_music(0)
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目～こまり目")
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400240, -1)
		object.wait_until_done(0)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しL", 4)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400250, -1)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "右→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400253, -1)
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400257, -1)
		object.wait_until_done(1)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400260, -1)
		wait.for_frame_count(60)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_object_handle_visible(2, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
end

--- Plays the scene in which the party looks up in surprise.
local function play_look_up_surprise_scene()
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(33)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_map_part_2(2, "p01_s98")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 12.52, -7.06, 206.03)
		event.set_object_handle_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 35.37, -7.06, 202.4)
		event.set_object_handle_rotation(1, 0.0, -2.9, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_visible(2, 0)
		event.set_time_of_day(0)
		event.enable_drama_skip()
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(21.14, 60.19, 163.18)
		event.set_camera_sequence_look_at(24.82, 14.07, 201.88)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6400420, -1)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(6400430, -1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
end

--- Plays the scene in which the party reacts in amazement.
local function play_amazed_reaction_scene()
	local active_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_map_part_2(2, "p01_s98")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 12.52, -7.06, 206.03)
		event.set_object_handle_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 35.37, -7.06, 202.4)
		event.set_object_handle_rotation(1, 0.0, -2.9, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_visible(2, 0)
		event.set_time_of_day(0)
		event.enable_drama_skip()
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-6.36, 3.35, 161.53)
		event.set_camera_sequence_look_at(27.9, 14.07, 208.34)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目～おこり目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "すごい", 6)
		event.queue_object_sequence_next_motion(0, "すごいL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6400460)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(6400470)
		event.set_object_sequence_motion(0, "すごい戻り", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6400480)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_music(0)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs this instead of its default.
function script.do_nothing() end
script[500] = script.do_nothing

--- Fades out, plays the night scene and then jumps to the map i04h01.
function script.play_night_scene_then_enter_house()
	event.fade_out_screen(0)
	play_night_scene()
	event.jump_to_map_3(-1, "i04h01", 530)
	vm.wait(2)
end
script[520] = script.play_night_scene_then_enter_house

--- Plays the lapis beam scene and then jumps to the map s30.
function script.cutscene_lapis_beam()
	play_lapis_beam_scene()
	event.jump_to_map_3(-1, "s30", 610)
	vm.wait(2)
end
script[600] = script.cutscene_lapis_beam

--- Plays the look-around dialogue scene and then jumps to the map s30.
function script.cutscene_look_around_dialogue()
	play_look_around_dialogue_scene()
	event.jump_to_map_3(-1, "s30", 630)
	vm.wait(2)
end
script[610] = script.cutscene_look_around_dialogue

--- Plays the scene of the flying object departing and then jumps to the map s30.
function script.cutscene_flying_object_departure()
	play_flying_object_departure_scene()
	event.jump_to_map_3(-1, "s30", 640)
	vm.wait(2)
end
script[620] = script.cutscene_flying_object_departure

--- Plays the look-up surprise scene and then jumps to the map s30.
function script.cutscene_look_up_surprise()
	play_look_up_surprise_scene()
	event.jump_to_map_3(-1, "s30", 650)
	vm.wait(2)
end
script[630] = script.cutscene_look_up_surprise

--- Plays the amazed reaction scene and then jumps to the map s11.
function script.cutscene_amazed_reaction()
	play_amazed_reaction_scene()
	event.jump_to_map_3(-1, "s11", 510)
	vm.wait(2)
end
script[650] = script.cutscene_amazed_reaction

--- Plays the lapis beam scene and then jumps to the map s30.
function script.cutscene_lapis_beam_alternate()
	play_lapis_beam_scene()
	event.jump_to_map_3(-1, "s30", 610)
	vm.wait(2)
end
script[16400] = script.cutscene_lapis_beam_alternate

--- Fades out, stores a save data value and reloads this map to run the night scene.
function script.reload_map_for_night_scene()
	event.fade_out_screen(0)
	event.set_save_data_value(0, 10)
	event.jump_to_map_3(-1, "s66", 17370)
	vm.wait(1)
end
script[17360] = script.reload_map_for_night_scene

--- Fades out, plays the night scene and then jumps to the map i04h01.
function script.play_night_scene_after_reload_then_enter_house()
	event.fade_out_screen(0)
	play_night_scene()
	event.jump_to_map_3(-1, "i04h01", 530)
	vm.wait(2)
end
script[17370] = script.play_night_scene_after_reload_then_enter_house

return script
