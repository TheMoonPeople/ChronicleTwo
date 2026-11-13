--!strict
--- The village scenes in which Mints and Monica meet Jurak, receive a seed, a badge and a gun, and the villagers' dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local field_town_f01 = require("@lib/event/field_town_f01")
local georama = require("@lib/event/georama")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local time_gate = require("@lib/event/spanish/time_gate")
local wait = require("@lib/event/wait")

local mints_slot_events_275_277_285: s32 = 0
local monica_slot_events_275_277_285: s32 = 0
local mints_slot_event_270: s32 = 0
local monica_slot_event_270: s32 = 0
local mints_slot_event_272: s32 = 0
local monica_slot_event_272: s32 = 0
local mints_slot_event_280: s32 = 0
local monica_slot_event_280: s32 = 0
local event_285_sound_file: any = 0
local item_get_sound_file: any = 0

--- Hides the rebuilt map part, refreshes villager visibility and places the player when the map starts.
local function set_up_map()
	local has_georama_progress: s32 = 0
	local analysis_flag: s32 = 0
	event.set_function_point_enabled("", "e277", 0)
	has_georama_progress = 0
	analysis_flag = event.get_georama_analysis_flag(104) or analysis_flag
	if analysis_flag ~= 0 then
		has_georama_progress = 1
	end
	analysis_flag = event.get_georama_analysis_flag(105) or analysis_flag
	if analysis_flag ~= 0 then
		has_georama_progress = 1
	end
	analysis_flag = event.get_georama_analysis_flag(106) or analysis_flag
	if has_georama_progress ~= 0 then
		event.attach_object_handle_to_map_part_2(1, "p11_f0101")
		event.set_object_handle_visible(1, 0)
	end
	field_town_f01.update_resident_visibility()
	event.set_character_position(0, 205.1, -6.0, 894.1)
end

--- Loads Mints, Monica and the message file for the first village scene.
local function load_event_270_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_message_file(0, 5, "event/e200/e270/e270_1.txt")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_event_270 = 0
		monica_slot_event_270 = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_270)
		event.load_character_motion_pack(5, "event/e200/e270/e270_mints.gltf", "info", mints_slot_event_270)
		event.attach_object_handle_to_character(0, mints_slot_event_270)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_270)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_event_270)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_event_270)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_event_270)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_event_270, 37)
		event.load_character_motion_pack(5, "event/e200/e270/e270_monica.gltf", "info", monica_slot_event_270)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_270)
		event.attach_object_handle_to_character(1, monica_slot_event_270)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_event_270)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_event_270 = 33
		monica_slot_event_270 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_event_270)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_event_270)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_event_270)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_event_270, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_270)
		event.load_character_motion_pack(5, "event/e200/e270/e270_mints.gltf", "info", mints_slot_event_270)
		event.attach_object_handle_to_character(0, mints_slot_event_270)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_270)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e270/e270_monica.gltf", "info", monica_slot_event_270)
		event.attach_object_handle_to_character(1, monica_slot_event_270)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_270)
		event.set_character_active(0, monica_slot_event_270)
	end
end

--- Resets the character slots to their post-load values for the skip handler of the departure scene.
local function reset_event_280_character_slots()
	mints_slot_event_270 = 0
	monica_slot_event_270 = 33
	mints_slot_event_270 = 33
	monica_slot_event_270 = 0
end

--- Restores the player and deletes the temporary actors of the village restoration scene.
local function unload_event_275_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_event_270)
		event.set_character_active(0, monica_slot_event_270)
		event.delete_character_extension_packs(mints_slot_event_270)
		event.delete_character_extension_packs(monica_slot_event_270)
		event.delete_character(monica_slot_event_270)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_event_270)
		event.set_character_active(0, mints_slot_event_270)
		event.delete_character_extension_packs(mints_slot_event_270)
		event.delete_character_extension_packs(monica_slot_event_270)
		event.delete_character(mints_slot_event_270)
		event.delete_character(37)
	end
end

--- Plays the cutscene of Mints and Monica arriving at the village and reacting to the wind.
local function play_event_270_cutscene()
	local sound_effect_file: s32 = 0
	local cutscene_step: number = 0
	vm.section(function()
		event.set_save_flag(270, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.fade_out_screen(30)
		cutscene_step = 1
		wait.frames(45)
		event.load_map_sounds(2500)
		sound_effect_file = event.load_sound_effect_file_2(2500) or sound_effect_file
		load_event_270_actors()
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot_event_270)
		event.set_character_active(1, monica_slot_event_270)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(174.76, 389.28, 1785.94)
		event.set_camera_sequence_look_at(34.41, 90.8, 382.81)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_position(0, 68.8, 23.7, 1491.8)
		event.set_object_sequence_rotation(0, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, 93.9, 23.7, 1438.4)
		event.set_object_sequence_rotation(1, 0.0, 3.05, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_effect_file, 2)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		cutscene_step = 2
		wait.frames(15)
		event.move_object_sequence(0, 37.43, 14.75, 561.52, 600, 1)
		event.move_object_sequence(1, 58.59, 15.55, 560.22, 600, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(660)
		event.add_camera_sequence_path_point(174.76, 389.28, 1785.94, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(171.97, 318.75, 1758.0, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(161.43, 215.48, 1652.69, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(142.06, 138.98, 1459.02, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(64.19, 10.12, 750.23, 30.64, 90.8, 392.13)
		event.start_camera_sequence_path()
		cutscene_step = 3
		object.wait_until_done(1)
		event.rotate_object_sequence(1, 0.0, -2.75, 0.0, 5)
		cutscene_step = 4
		wait.frames(5)
		event.set_object_sequence_motion(1, "立ち", 0)
		cutscene_step = 5
		object.wait_until_done(0)
		event.rotate_object_sequence(0, 0.0, 3.05, 0.0, 5)
		cutscene_step = 6
		wait.frames(5)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.stop_sound_effect(sound_effect_file, 2)
		cutscene_step = 7
		wait.frames(60)
		cutscene_step = 8
		message.show_voiced(2700010)
		cutscene_step = 9
		message.show_voiced(2700020)
		cutscene_step = 10
		wait.frames(30)
		event.set_camera_sequence_position(25.23, 45.67, 520.07)
		event.set_camera_sequence_look_at(56.48, 39.42, 567.84)
		event.move_object_sequence(1, 58.3, 15.55, 557.33, 10, 1)
		event.set_object_sequence_motion(1, "歩き", 2)
		cutscene_step = 11
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "上向く", 6)
		cutscene_step = 12
		object.wait_until_done(1)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		cutscene_step = 13
		message.show_voiced(2700030)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 14
		wait.frames(30)
		event.set_camera_sequence_position(64.19, 10.12, 750.23)
		event.set_camera_sequence_look_at(30.64, 90.8, 392.13)
		cutscene_step = 15
		wait.frames(15)
		event.set_object_sequence_motion(0, "右向く戻り")
		event.queue_object_sequence_next_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 16
		message.show_voiced(2700040)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 17
		message.show_voiced(2700050)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 18
		message.show_voiced(2700055)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 19
		wait.frames(60)
		event.set_object_sequence_motion(0, "風", 6)
		event.queue_object_sequence_next_motion(0, "風Ｌ", 4)
		event.set_object_sequence_motion(1, "風", 6)
		event.queue_object_sequence_next_motion(1, "風Ｌ", 4)
		event.play_sound_effect(sound_effect_file, 3)
		event.set_wind(40.0, 34.48, 48.5, 396.61)
		cutscene_step = 20
		message.show_voiced_for(2700060, -1)
		event.set_wind(-1)
		event.set_object_sequence_motion(0, "風戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "風戻り", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 21
		wait.frames(30)
		event.set_camera_sequence_position(25.23, 45.67, 520.07)
		event.set_camera_sequence_look_at(56.48, 39.42, 567.84)
		cutscene_step = 22
		wait.frames(15)
		event.set_object_sequence_motion(1, "あいつは～専用", 6)
		event.queue_object_sequence_next_motion(1, "あいつは～専用Ｌ", 4)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "時の～専用上～見立ちに", 6)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～目あき")
		cutscene_step = 23
		vm.wait(23)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 24
		message.show_voiced(2700070)
		cutscene_step = 25
		object.wait_until_done(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向くL", 6)
		event.queue_object_sequence_next_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 26
		message.show_voiced(2700080)
		cutscene_step = 27
		object.wait_until_done(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 28
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(930)
		event.add_camera_sequence_path_point(132.27, 70.71, 488.53, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(159.15, 70.71, 562.03, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(132.93, 70.71, 625.44, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(77.3, 70.71, 656.87, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(28.82, 70.71, 654.67, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-9.49, 70.71, 633.72, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-37.15, 70.71, 595.03, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-44.53, 70.71, 550.01, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-32.67, 70.71, 507.99, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-6.04, 70.71, 475.89, 58.05, 36.97, 556.81)
		event.start_camera_sequence_path()
		cutscene_step = 29
		wait.frames(15)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 30
		message.show_voiced_for(2700090, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 31
		message.show_voiced_for(2700095, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 32
		message.show_voiced_for(2700100, 230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 33
		message.show_voiced_for(2700110, 200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 34
		message.show_voiced_for(2700120, -1)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(40.68, 60.8, 523.12)
		event.set_camera_sequence_look_at(50.29, 32.81, 569.09)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "上向き会話2", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 35
		message.show_voiced(2700130)
		cutscene_step = 36
		object.wait_until_done(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		cutscene_step = 37
		wait.frames(30)
		event.set_camera_sequence_position(64.19, 10.12, 750.23)
		event.set_camera_sequence_look_at(30.64, 90.8, 392.13)
		cutscene_step = 38
		wait.frames(15)
		cutscene_step = 39
		message.show_voiced(2700140)
		cutscene_step = 40
		message.show_voiced(2700150)
		cutscene_step = 41
		message.show_voiced(2700153)
		cutscene_step = 42
		wait.frames(30)
		event.set_camera_sequence_position(19.5, 49.85, 518.46)
		event.set_camera_sequence_look_at(52.88, 36.97, 566.51)
		cutscene_step = 43
		wait.frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～がっかり目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "力こめ目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口閉じ～口くいしばり")
		event.play_sound_effect(sound_effect_file, 5)
		event.set_object_sequence_motion(1, "悔しがりラスト", 6)
		event.queue_object_sequence_next_motion(1, "悔しがりラストＬ", 4)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.move_camera_sequence_eased(26.54, 49.85, 528.59, 52.88, 36.97, 566.51, 60, 2, 1.0)
		cutscene_step = 44
		message.show_voiced_for(2700155, -1)
		cutscene_step = 45
		wait.frames(30)
		event.fade_out_screen(30)
		cutscene_step = 46
		wait.frames(35)
	end, function(received: { any }): boolean
		if cutscene_step <= 1 then
			reset_event_280_character_slots()
			wait.frames_skipping(15)
		end
		if cutscene_step <= 2 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 3 then
			wait.frames_skipping(5)
		end
		if cutscene_step <= 4 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 5 then
			wait.frames_skipping(5)
		end
		if cutscene_step <= 6 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 7 then
			message.show_voiced_skipping(2700010)
		end
		if cutscene_step <= 8 then
			message.show_voiced_skipping(2700020)
		end
		if cutscene_step <= 9 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 10 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 11 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 12 then
			message.show_voiced_skipping(2700030)
		end
		if cutscene_step <= 13 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 14 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 15 then
			message.show_voiced_skipping(2700040)
		end
		if cutscene_step <= 16 then
			message.show_voiced_skipping(2700050)
		end
		if cutscene_step <= 17 then
			message.show_voiced_skipping(2700055)
		end
		if cutscene_step <= 18 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 19 then
			message.show_voiced_for_skipping(2700060, -1)
		end
		if cutscene_step <= 20 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 21 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 23 then
			message.show_voiced_skipping(2700070)
		end
		if cutscene_step <= 24 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 25 then
			message.show_voiced_skipping(2700080)
		end
		if cutscene_step <= 26 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 27 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 28 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 29 then
			message.show_voiced_for_skipping(2700090, 120)
		end
		if cutscene_step <= 30 then
			message.show_voiced_for_skipping(2700095, 120)
		end
		if cutscene_step <= 31 then
			message.show_voiced_for_skipping(2700100, 230)
		end
		if cutscene_step <= 32 then
			message.show_voiced_for_skipping(2700110, 200)
		end
		if cutscene_step <= 33 then
			message.show_voiced_for_skipping(2700120, -1)
		end
		if cutscene_step <= 34 then
			message.show_voiced_skipping(2700130)
		end
		if cutscene_step <= 35 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 36 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 37 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 38 then
			message.show_voiced_skipping(2700140)
		end
		if cutscene_step <= 39 then
			message.show_voiced_skipping(2700150)
		end
		if cutscene_step <= 40 then
			message.show_voiced_skipping(2700153)
		end
		if cutscene_step <= 41 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 42 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 43 then
			message.show_voiced_for_skipping(2700155, -1)
		end
		if cutscene_step <= 44 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 45 then
			wait.frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_wind(-1)
	event.stop_sound_effect(sound_effect_file, 2)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_event_275_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Mints, Monica, the seed, the nose explosion and the sparkle effects for the seed gift scene.
local function load_event_272_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_event_272 = 0
		monica_slot_event_272 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_272)
		event.load_character_motion_pack(5, "event/e200/e272/e272_mints.gltf", "info", mints_slot_event_272)
		event.attach_object_handle_to_character(0, mints_slot_event_272)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_272)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_event_272)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_event_272)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_event_272)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_event_272, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_272)
		event.load_character_motion_pack(5, "event/e200/e272/e272_monica.gltf", "info", monica_slot_event_272)
		event.attach_object_handle_to_character(1, monica_slot_event_272)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_event_272)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_event_272 = 32
		monica_slot_event_272 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_event_272)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_event_272)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_event_272)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_event_272, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_272)
		event.load_character_motion_pack(5, "event/e200/e272/e272_mints.gltf", "info", mints_slot_event_272)
		event.attach_object_handle_to_character(0, mints_slot_event_272)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_272)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_272)
		event.load_character_motion_pack(5, "event/e200/e272/e272_monica.gltf", "info", monica_slot_event_272)
		event.attach_object_handle_to_character(1, monica_slot_event_272)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_event_272)
	end
	event.load_character(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 2)
	event.load_character(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(4, 39)
	event.clear_object_sequence(5, 39)
	event.set_object_sequence_object(5, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.attach_object_handle_to_character(5, 40)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 5)
	event.set_character_active(0, 40)
	event.load_message_file(0, 5, "event/e200/e272/e272_1.txt")
end

--- Resets the character slots to their post-load values for the skip handler of the badge scene.
local function reset_event_277_character_slots()
	mints_slot_event_272 = 0
	monica_slot_event_272 = 32
	mints_slot_event_272 = 32
	monica_slot_event_272 = 0
end

--- Restores the player and deletes the temporary actors of the seed gift scene.
local function unload_event_272_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_event_272)
		event.set_character_active(0, monica_slot_event_272)
		event.delete_character_extension_packs(mints_slot_event_272)
		event.delete_character_extension_packs(monica_slot_event_272)
		event.delete_character_extension_packs(36)
		event.delete_character(monica_slot_event_272)
		event.delete_character(36)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_event_272)
		event.set_character_active(0, mints_slot_event_272)
		event.delete_character_extension_packs(mints_slot_event_272)
		event.delete_character_extension_packs(monica_slot_event_272)
		event.delete_character_extension_packs(36)
		event.delete_character(mints_slot_event_272)
		event.delete_character(36)
		event.delete_character(37)
	end
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
end

--- Plays the cutscene in which Jurak's nose sneeze releases a seed that Mints receives along with a hint about the Sundrop.
local function play_seed_gift_cutscene()
	local sound_effect_file: s32 = 0
	local item_get_sound_file: s32 = 0
	local cutscene_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		cutscene_step = 1
		wait.frames(45)
		event.set_save_flag(272, 1)
		event.load_map_sounds(2503)
		sound_effect_file = event.load_sound_effect_file_2(2503) or sound_effect_file
		item_get_sound_file = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_get_sound_file
		load_event_272_actors()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot_event_272)
		event.set_character_active(1, monica_slot_event_272)
		event.set_character_active(0, 35)
		event.set_camera_sequence_position(104.47, 46.8, 1479.26)
		event.set_camera_sequence_look_at(86.03, 73.72, 1247.28)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_character_position(38, -96.86, 52.75, 388.46)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_position(39, 37.43, 34.75, 561.52)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, 47.14, -8.67, 849.46)
		event.set_object_sequence_rotation(0, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, 70.25, -10.75, 900.05)
		event.set_object_sequence_rotation(1, 0.0, 3.05, 0.0)
		event.fade_in_screen(30)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		cutscene_step = 2
		wait.frames(15)
		event.move_object_sequence(0, 37.43, 14.75, 561.52, 240, 1)
		event.move_object_sequence(1, 58.59, 15.55, 560.22, 270, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(104.47, 46.8, 1479.26, 86.03, 73.72, 1247.28)
		event.add_camera_sequence_path_point(65.3, 46.8, 986.65, 46.86, 73.72, 754.67)
		event.start_camera_sequence_path()
		cutscene_step = 3
		object.wait_until_done(0)
		event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 5)
		cutscene_step = 4
		wait.frames(5)
		event.set_object_sequence_motion(0, "立ち", 0)
		cutscene_step = 5
		object.wait_until_done(1)
		event.rotate_object_sequence(1, 0.0, -2.87, 0.0, 5)
		cutscene_step = 6
		wait.frames(5)
		event.set_object_sequence_motion(1, "上向くL", 0)
		cutscene_step = 7
		wait.frames(60)
		event.set_object_sequence_motion(0, "上向く", 2)
		event.queue_object_sequence_next_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 8
		message.show_voiced(2720010)
		cutscene_step = 9
		object.wait_until_done(0)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 10
		message.show_voiced(2720020)
		cutscene_step = 11
		message.show_voiced(2720030)
		cutscene_step = 12
		message.show_voiced(2720035)
		cutscene_step = 13
		wait.frames(30)
		event.set_camera_sequence_position(62.05, 41.42, 524.15)
		event.set_camera_sequence_look_at(28.43, 35.31, 613.0)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 14
		message.show_voiced(2720040)
		event.reset_mouth_texture_animations()
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		cutscene_step = 15
		wait.frames(30)
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		cutscene_step = 16
		message.show_voiced(2720050)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 17
		message.show_voiced(2720060)
		cutscene_step = 18
		object.wait_until_done(0)
		cutscene_step = 19
		message.show_voiced(2720070)
		cutscene_step = 20
		wait.frames(30)
		event.set_camera_sequence_position(35.55, 36.73, 529.53)
		event.set_camera_sequence_look_at(46.86, 52.13, 754.67)
		event.set_object_sequence_motion(0, "考える", 4)
		cutscene_step = 21
		wait.frames(15)
		event.move_camera_sequence_eased(35.81, 36.73, 534.67, 46.86, 52.13, 754.67, 30, 2, 1.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 22
		message.show_voiced(2720080)
		event.reset_mouth_texture_animations()
		cutscene_step = 23
		wait.frames(30)
		event.set_camera_sequence_position(283.52, 88.96, 846.8)
		event.set_camera_sequence_look_at(90.35, 78.53, 545.4)
		cutscene_step = 24
		wait.frames(15)
		cutscene_step = 25
		message.show_voiced(2720090)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "もごもご")
		cutscene_step = 26
		wait.frames(30)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "ふんっ")
		cutscene_step = 27
		wait.frames(30)
		event.set_character_active(1, 38)
		event.set_character_motion(38, "鼻爆発", 2, -1, 1)
		event.play_sound_effect(sound_effect_file, 4)
		event.set_wind(40.0, -96.86, 52.75, 388.46)
		cutscene_step = 28
		wait.frames(15)
		event.set_wind(-1)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
		event.set_object_sequence_motion(0, "驚く", 6)
		event.set_object_sequence_motion(1, "おどろき", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.queue_object_sequence_next_motion(1, "おどろきL", 4)
		cutscene_step = 29
		wait.frames(90)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(64.11, 33.73, 495.58)
		event.set_camera_sequence_look_at(35.93, 39.28, 614.27)
		event.set_object_sequence_rotation(1, 0.0, -2.03, 0.0)
		event.set_character_active(1, 39)
		event.set_character_motion(39, "キラキラ（ループ）", 4, -1, 1)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 120)
		event.add_object_sequence_path_point(5, 39.0, 68.91, 553.15)
		event.add_object_sequence_path_point(5, 39.0, 42.39, 553.15)
		event.start_object_sequence_path(5)
		event.play_sound_effect(sound_effect_file, 5)
		event.set_object_sequence_motion(0, "キラキラ見る", 2)
		event.set_object_sequence_motion(1, "おどろきＬから上向き立ち", 2)
		event.queue_object_sequence_next_motion(0, "取る", 6)
		event.queue_object_sequence_next_motion(1, "上向く戻り", 6, 0.025)
		event.queue_object_sequence_next_motion(0, "取るL", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		cutscene_step = 30
		wait.frames(120)
		event.set_character_motion(39, "消える", 2, -1, 1)
		cutscene_step = 31
		wait.frames(30)
		event.set_character_active(0, 39)
		event.set_camera_sequence_position(32.21, 52.0, 529.74)
		event.set_camera_sequence_look_at(38.35, 42.39, 562.99)
		event.set_object_sequence_position(6, 44.55, 45.78, 564.88)
		event.set_object_sequence_rotation(6, 0.0, -3.11, 0.0)
		event.pause_music()
		event.set_character_active(1, 40)
		event.play_sound_effect(sound_effect_file, 6)
		event.play_sound_effect(item_get_sound_file, 0)
		event.set_object_sequence_motion(6, "発動", 6)
		event.attach_character_to_frame(mints_slot_event_272, "item", 35)
		event.set_character_active(1, 35)
		event.set_object_sequence_motion(0, "種ゲット", 4)
		cutscene_step = 32
		inventory.announce_received(361, 1)
		event.play_music(0)
		event.detach_character_from_frame(35)
		event.set_character_active(0, 40)
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 0)
		event.set_object_sequence_motion(1, "上向くL", 0)
		cutscene_step = 33
		message.show_voiced(2720100)
		cutscene_step = 34
		message.show_voiced(2720110)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		cutscene_step = 35
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 36
		message.show_voiced(2720120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		cutscene_step = 37
		wait.frames(15)
		cutscene_step = 38
		message.show_voiced(2720130)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 39
		message.show_voiced(2720140)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 40
		message.show_voiced(2720150)
		cutscene_step = 41
		wait.frames(30)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		event.set_object_sequence_motion(0, "あせり会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		cutscene_step = 42
		message.show_voiced(2720160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "大口パク")
		event.set_object_sequence_motion(0, "あせり会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		cutscene_step = 43
		message.show_voiced(2720165)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		event.set_object_sequence_motion(0, "立ち", 4)
		cutscene_step = 44
		message.show_voiced(2720170)
		cutscene_step = 45
		inventory.announce_received(308, 1)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 6)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "だめだめ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 6)
		cutscene_step = 46
		wait.frames(120)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Para coger una Gota de Sol, antes debes\n   conseguir algo que te permitir[UNI00e1] hablar\n   con la Himarra.<page>   La forma de encontrarlo est[UNI00e1] relacionada\n   en cierta medida con el desarrollo de Georama.\n   Esm[UNI00e9]rate con el Georama y examina\n   el mundo futuro de Jurak."
		)
		cutscene_step = 47
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end, function(received: { any }): boolean
		if cutscene_step <= 1 then
			reset_event_277_character_slots()
			wait.frames_skipping(15)
		end
		if cutscene_step <= 2 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 3 then
			wait.frames_skipping(5)
		end
		if cutscene_step <= 4 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 5 then
			wait.frames_skipping(5)
		end
		if cutscene_step <= 6 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 7 then
			message.show_voiced_skipping(2720010)
		end
		if cutscene_step <= 8 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 9 then
			message.show_voiced_skipping(2720020)
		end
		if cutscene_step <= 10 then
			message.show_voiced_skipping(2720030)
		end
		if cutscene_step <= 11 then
			message.show_voiced_skipping(2720035)
		end
		if cutscene_step <= 12 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 13 then
			message.show_voiced_skipping(2720040)
		end
		if cutscene_step <= 14 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 15 then
			message.show_voiced_skipping(2720050)
		end
		if cutscene_step <= 16 then
			message.show_voiced_skipping(2720060)
		end
		if cutscene_step <= 17 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 18 then
			message.show_voiced_skipping(2720070)
		end
		if cutscene_step <= 19 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 20 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 21 then
			message.show_voiced_skipping(2720080)
		end
		if cutscene_step <= 22 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 23 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 24 then
			message.show_voiced_skipping(2720090)
		end
		if cutscene_step <= 25 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 26 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 27 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 28 then
			wait.frames_skipping(90)
		end
		if cutscene_step <= 29 then
			wait.frames_skipping(120)
		end
		if cutscene_step <= 30 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 31 then
			inventory.resume_obtained_message(361, 1)
		end
		if cutscene_step <= 32 then
			message.show_voiced_skipping(2720100)
		end
		if cutscene_step <= 33 then
			message.show_voiced_skipping(2720110)
		end
		if cutscene_step <= 34 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 35 then
			message.show_voiced_skipping(2720120)
		end
		if cutscene_step <= 36 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 37 then
			message.show_voiced_skipping(2720130)
		end
		if cutscene_step <= 38 then
			message.show_voiced_skipping(2720140)
		end
		if cutscene_step <= 39 then
			message.show_voiced_skipping(2720150)
		end
		if cutscene_step <= 40 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 41 then
			message.show_voiced_skipping(2720160)
		end
		if cutscene_step <= 42 then
			message.show_voiced_skipping(2720165)
		end
		if cutscene_step <= 43 then
			message.show_voiced_skipping(2720170)
		end
		if cutscene_step <= 44 then
			inventory.resume_obtained_message(308, 1)
		end
		if cutscene_step <= 45 then
			wait.frames_skipping(120)
		end
		if cutscene_step <= 46 then
			message.show_and_wait_skipping(0, -1, 8, 0, 0)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	cutscene_step = 48
	wait.frames(30)
	event.set_wind(-1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_event_272_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Mints, Monica and the message file for the village restoration scene.
local function load_event_275_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_events_275_277_285 = 0
		monica_slot_events_275_277_285 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_events_275_277_285, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_events_275_277_285 = 32
		monica_slot_events_275_277_285 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_events_275_277_285, 37)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
	end
	event.load_message_file(0, 5, "event/e200/e275/e275_1.txt")
end

--- Resets the character slots to their post-load values for the skip handler of the village restoration scene.
local function reset_event_275_character_slots()
	mints_slot_events_275_277_285 = 0
	monica_slot_events_275_277_285 = 32
	mints_slot_events_275_277_285 = 32
	monica_slot_events_275_277_285 = 0
end

--- Restores the player and deletes the temporary actors of the first village scene.
local function unload_event_270_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(monica_slot_events_275_277_285)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(mints_slot_events_275_277_285)
		event.delete_character(37)
	end
end

--- Plays the cutscene of Mints and Monica looking over the village with the camera path chosen by the georama progress.
local function play_event_275_cutscene()
	local analysis_flag_106: s32 = 0
	local analysis_flag_105: s32 = 0
	local cutscene_step: number = 0
	vm.section(function()
		event.set_save_flag(275, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		cutscene_step = 1
		wait.frames(45)
		load_event_275_actors()
		event.load_map_sounds(2506)
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_camera_sequence_position(-4.27, 55.7, 754.91)
		event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		analysis_flag_106 = event.get_georama_analysis_flag(106) or analysis_flag_106
		analysis_flag_105 = event.get_georama_analysis_flag(105) or analysis_flag_105
		if analysis_flag_105 ~= 0 then
			event.set_camera_sequence_position(13.7, 24.83, 757.8)
			event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		end
		if analysis_flag_106 ~= 0 then
			event.set_camera_sequence_position(49.24, 24.83, 746.5)
			event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		end
		event.set_object_sequence_position(0, 13.4, 6.52, 613.7)
		event.set_object_sequence_rotation(0, 0.0, -2.92, 0.0)
		event.set_object_sequence_position(1, 47.24, 7.54, 600.38)
		event.set_object_sequence_rotation(1, 0.0, -2.92, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		cutscene_step = 2
		wait.frames(15)
		if (if analysis_flag_106 ~= 0 then 1 else analysis_flag_105) ~= 0 then
			event.clear_camera_sequence_path()
			if (if analysis_flag_106 ~= 0 then analysis_flag_105 else 0) ~= 0 then
				event.set_camera_sequence_path_frames(480)
			end
			if (if analysis_flag_106 ~= 0 then 1 else analysis_flag_105) ~= 0 then
				event.set_camera_sequence_path_frames(240)
			end
			if analysis_flag_106 ~= 0 then
				event.add_camera_sequence_path_point(49.24, 24.83, 746.5, 14.71, 53.79, 698.03)
			end
			if analysis_flag_105 ~= 0 then
				event.add_camera_sequence_path_point(13.7, 24.83, 757.8, 14.71, 53.79, 698.03)
			end
			event.add_camera_sequence_path_point(-4.27, 55.7, 754.91, 14.71, 53.79, 698.03)
			event.start_camera_sequence_path()
		else
			cutscene_step = 3
			wait.frames(60)
		end
		cutscene_step = 4
		message.show_voiced(2750010)
		cutscene_step = 5
		camera.wait_until_done()
		cutscene_step = 6
		wait.frames(30)
		event.set_camera_sequence_position(17.1, 20.28, 879.05)
		event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		cutscene_step = 7
		wait.frames(15)
		cutscene_step = 8
		message.show_voiced(2750020)
		cutscene_step = 9
		message.show_voiced(2750030)
		cutscene_step = 10
		wait.frames(60)
		event.fade_out_screen(30)
		cutscene_step = 11
		wait.frames(35)
	end, function(received: { any }): boolean
		if cutscene_step <= 1 then
			reset_event_275_character_slots()
			wait.frames_skipping(15)
		end
		if cutscene_step <= 2 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 3 then
			message.show_voiced_skipping(2750010)
		end
		if cutscene_step <= 4 then
			wait.background_load_skipping()
		end
		if cutscene_step <= 5 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 6 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 7 then
			message.show_voiced_skipping(2750020)
		end
		if cutscene_step <= 8 then
			message.show_voiced_skipping(2750030)
		end
		if cutscene_step <= 9 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 10 then
			wait.frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	unload_event_270_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Mints, Monica and the message file for the departure scene.
local function load_event_280_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_event_280 = 0
		monica_slot_event_280 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_280)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", mints_slot_event_280)
		event.attach_object_handle_to_character(0, mints_slot_event_280)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_280)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_event_280)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_event_280)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_event_280)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_event_280, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_280)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", monica_slot_event_280)
		event.attach_object_handle_to_character(1, monica_slot_event_280)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_event_280)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_event_280 = 32
		monica_slot_event_280 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_event_280)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_event_280)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_event_280)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_event_280, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_event_280)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", mints_slot_event_280)
		event.attach_object_handle_to_character(0, mints_slot_event_280)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_event_280)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_event_280)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", monica_slot_event_280)
		event.attach_object_handle_to_character(1, monica_slot_event_280)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_event_280)
	end
	event.load_message_file(0, 5, "event/e200/e280/e280a_1.txt")
end

--- Resets the character slots to their post-load values for the skip handler of the seed gift scene.
local function reset_event_272_character_slots()
	mints_slot_event_280 = 0
	monica_slot_event_280 = 32
	mints_slot_event_280 = 32
	monica_slot_event_280 = 0
end

--- Restores the player, deletes the temporary actors and jumps to the next map after the departure scene.
local function unload_event_280_actors_and_leave()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_event_280)
		event.set_character_active(0, monica_slot_event_280)
		event.delete_character_extension_packs(mints_slot_event_280)
		event.delete_character_extension_packs(monica_slot_event_280)
		event.delete_character(monica_slot_event_280)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_event_280)
		event.set_character_active(0, mints_slot_event_280)
		event.delete_character_extension_packs(mints_slot_event_280)
		event.delete_character_extension_packs(monica_slot_event_280)
		event.delete_character(mints_slot_event_280)
		event.delete_character(37)
	end
	event.jump_to_map_3(-1, "s26", 700)
end

--- Plays the cutscene of Mints and Monica discussing their next destination and running out of the village.
local function play_event_280_cutscene()
	local sound_effect_file: s32 = 0
	local cutscene_step: number = 0
	vm.section(function()
		event.set_save_flag(280, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		event.stop_music(0)
		cutscene_step = 1
		wait.frames(45)
		event.load_music(59)
		event.load_map_sounds(2511)
		event.play_music(0, 36)
		sound_effect_file = event.load_sound_effect_file_2(2511) or sound_effect_file
		load_event_280_actors()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot_event_280)
		event.set_character_active(1, monica_slot_event_280)
		event.set_camera_sequence_position(34.43, 5.8, 741.1)
		event.set_camera_sequence_look_at(26.93, 51.37, 586.27)
		event.set_object_sequence_position(1, 38.74, 7.54, 600.65)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.set_object_sequence_position(0, 20.1, 6.52, 613.49)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		cutscene_step = 2
		message.show_voiced(2800010)
		cutscene_step = 3
		message.show_voiced(2800015)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "わらい口ひらき")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-1.53, 38.93, 576.75)
		event.set_camera_sequence_look_at(47.63, 28.44, 622.59)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		cutscene_step = 4
		message.show_voiced(2800020)
		event.reset_mouth_texture_animations()
		cutscene_step = 5
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "上向くL", 4)
		cutscene_step = 6
		wait.frames(30)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		cutscene_step = 7
		wait.frames(15)
		cutscene_step = 8
		message.show_voiced(2800030)
		cutscene_step = 9
		message.show_voiced(2800040)
		cutscene_step = 10
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "不満目パチ")
		event.set_camera_sequence_position(17.72, 36.99, 568.83)
		event.set_camera_sequence_look_at(35.34, 28.44, 619.23)
		cutscene_step = 11
		wait.frames(15)
		event.set_object_sequence_motion(1, "はぁ？", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "あきれ口パク")
		cutscene_step = 12
		message.show_voiced(2800050)
		event.reset_mouth_texture_animations()
		cutscene_step = 13
		object.wait_until_done(1)
		cutscene_step = 14
		wait.frames(30)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		cutscene_step = 15
		wait.frames(15)
		cutscene_step = 16
		message.show_voiced(2800060)
		event.set_camera_sequence_position(54.46, 37.12, 558.59)
		event.set_camera_sequence_look_at(20.97, 30.6, 620.45)
		cutscene_step = 17
		message.show_voiced(2800065)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		cutscene_step = 18
		message.show_voiced(2800070)
		cutscene_step = 19
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "不満顔")
		event.set_object_sequence_texture_animation(1, 1, "不満目パチ")
		event.set_camera_sequence_position(42.96, 39.99, 563.11)
		event.set_camera_sequence_look_at(28.37, 28.44, 607.63)
		event.set_object_sequence_rotation(0, 0.0, -2.56, 0.0)
		cutscene_step = 20
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 21
		message.show_voiced(2800080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上見から右見", 6)
		event.queue_object_sequence_next_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 22
		message.show_voiced(2800085)
		event.reset_mouth_texture_animations()
		cutscene_step = 23
		object.wait_until_done(0)
		cutscene_step = 24
		wait.frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-23.31, 28.11, 596.86)
		event.set_camera_sequence_look_at(26.9, 28.44, 606.75)
		cutscene_step = 25
		wait.frames(15)
		event.set_object_sequence_motion(1, "上向きから左向き", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "左向きから上向き", 6)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "右見から上見", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 26
		message.show_voiced(2800090)
		event.reset_mouth_texture_animations()
		cutscene_step = 27
		object.wait_until_done(1)
		cutscene_step = 28
		wait.frames(30)
		event.set_camera_sequence_position(60.85, 50.28, 994.5)
		event.set_camera_sequence_look_at(37.15, 90.96, 620.83)
		cutscene_step = 29
		wait.frames(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(60.85, 50.28, 994.5, 37.15, 90.96, 620.83)
		event.add_camera_sequence_path_point(53.55, 50.28, 879.42, 29.85, 90.96, 505.75)
		event.start_camera_sequence_path()
		cutscene_step = 30
		message.show_voiced_for(2800100, -1)
		event.play_sound_effect(sound_effect_file, 8)
		cutscene_step = 31
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "うれし目パチ")
		event.set_camera_sequence_position(15.67, 33.06, 545.55)
		event.set_camera_sequence_look_at(37.65, 31.67, 641.15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(15.67, 33.06, 545.55, 37.65, 31.67, 641.15)
		event.add_camera_sequence_path_point(21.77, 33.06, 572.11, 37.65, 31.67, 641.15)
		event.start_camera_sequence_path()
		cutscene_step = 32
		camera.wait_until_done()
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		event.stop_sound_effect(sound_effect_file, 8)
		cutscene_step = 33
		message.show_voiced_for(2800110, 120)
		event.play_sound_effect(sound_effect_file, 9)
		event.set_object_sequence_motion(1, "がっかり肩落とし", 6)
		event.queue_object_sequence_next_motion(1, "がっかり肩落としＬ", 4)
		event.set_object_sequence_motion(0, "がっかり", 6)
		event.queue_object_sequence_next_motion(0, "がっかりＬ", 4)
		cutscene_step = 34
		wait.frames(60)
		event.set_object_sequence_motion(1, "頭抱えるＬ", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "こまり顔")
		event.set_object_sequence_texture_animation(0, 1, "こまり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ")
		event.set_camera_sequence_position(-23.31, 28.11, 596.86)
		event.set_camera_sequence_look_at(26.9, 28.44, 606.75)
		cutscene_step = 35
		wait.frames(15)
		cutscene_step = 36
		message.show_voiced(2800120)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "こまり顔")
		event.set_object_sequence_texture_animation(0, 1, "こまり目～通常目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～おこり目あき")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_effect_file, 10)
		event.set_object_sequence_motion(0, "がっかり→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 37
		message.show_voiced(2800130)
		event.reset_mouth_texture_animations()
		cutscene_step = 38
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "上見から右見", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "手をおろす", 6)
		event.queue_object_sequence_next_motion(1, "下向き立ちＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 39
		message.show_voiced(2800140)
		event.reset_mouth_texture_animations()
		cutscene_step = 40
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 41
		message.show_voiced(2800145)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		cutscene_step = 42
		message.show_voiced(2800150)
		cutscene_step = 43
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "さみし顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "おこり目～さみし目")
		event.set_object_sequence_motion(1, "下向き立ちＬ", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "下向きから左向き", 6)
		event.queue_object_sequence_next_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "さみし口パク")
		cutscene_step = 44
		message.show_voiced(2800160)
		event.reset_mouth_texture_animations()
		cutscene_step = 45
		object.wait_until_done(1)
		cutscene_step = 46
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "さみし顔")
		event.set_object_sequence_texture_animation(1, 1, "さみし目パチ")
		event.set_camera_sequence_position(42.73, 39.99, 562.51)
		event.set_camera_sequence_look_at(25.56, 28.44, 606.38)
		event.set_object_sequence_rotation(0, 0.0, -2.56, 0.0)
		cutscene_step = 47
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		cutscene_step = 48
		message.show_voiced(2800170)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向きから下向き", 6)
		event.queue_object_sequence_next_motion(1, "下向き立ちＬ", 4)
		event.set_mouth_texture_animations(1, "さみし口パク")
		cutscene_step = 49
		message.show_voiced(2800180)
		event.reset_mouth_texture_animations()
		cutscene_step = 50
		wait.frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "さみし目～通常目")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(28.25, 31.54, 674.64)
		event.set_camera_sequence_look_at(28.22, 28.44, 600.45)
		event.set_object_sequence_motion(0, "右回転90度（ＰＧ）", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.rotate_object_sequence(0, 0.0, 2.4, 0.0, 20)
		cutscene_step = 51
		object.wait_until_done(0)
		cutscene_step = 52
		object.wait_until_done(0)
		event.play_sound_effect(sound_effect_file, 11)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		cutscene_step = 53
		message.show_voiced(2800190)
		event.reset_mouth_texture_animations()
		cutscene_step = 54
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "モニカ見立ちうなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		cutscene_step = 55
		message.show_voiced(2800195)
		cutscene_step = 56
		object.wait_until_done(0)
		event.play_sound_effect(sound_effect_file, 12)
		event.rotate_object_sequence(1, 0.0, -1.0, 0.0, 30)
		event.set_object_sequence_motion(1, "左回転90度（ＰＧ）", 6)
		cutscene_step = 57
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 58
		message.show_voiced(2800200)
		event.reset_mouth_texture_animations()
		cutscene_step = 59
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 60
		message.show_voiced(2800205)
		event.reset_mouth_texture_animations()
		cutscene_step = 61
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect_file, 13)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		cutscene_step = 62
		message.show_voiced(2800210)
		event.reset_mouth_texture_animations()
		cutscene_step = 63
		object.wait_until_done(0)
		event.play_sound_effect(sound_effect_file, 14)
		event.play_sound_effect(sound_effect_file, 15)
		event.set_object_sequence_motion(0, "モニカ見立うなづき", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		cutscene_step = 64
		object.wait_until_done(0)
		cutscene_step = 65
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "歩き")
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 20)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 20)
		cutscene_step = 66
		object.wait_until_done(0)
		cutscene_step = 67
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "走り")
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 20.44, 6.52, 1490.12, 390, 1)
		event.move_object_sequence(1, 39.08, 7.54, 1478.94, 390, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(28.25, 31.54, 674.64, 28.22, 28.44, 600.45)
		event.add_camera_sequence_path_point(28.59, 31.54, 1526.51, 28.22, 28.44, 600.45)
		event.start_camera_sequence_path()
		cutscene_step = 68
		wait.frames(15)
		cutscene_step = 69
		wait.frames(200)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		cutscene_step = 70
		wait.frames(35)
	end, function(received: { any }): boolean
		if cutscene_step <= 1 then
			reset_event_272_character_slots()
			message.show_voiced_skipping(2800010)
		end
		if cutscene_step <= 2 then
			message.show_voiced_skipping(2800015)
		end
		if cutscene_step <= 3 then
			message.show_voiced_skipping(2800020)
		end
		if cutscene_step <= 4 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 5 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 6 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 7 then
			message.show_voiced_skipping(2800030)
		end
		if cutscene_step <= 8 then
			message.show_voiced_skipping(2800040)
		end
		if cutscene_step <= 9 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 10 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 11 then
			message.show_voiced_skipping(2800050)
		end
		if cutscene_step <= 12 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 13 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 14 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 15 then
			message.show_voiced_skipping(2800060)
		end
		if cutscene_step <= 16 then
			message.show_voiced_skipping(2800065)
		end
		if cutscene_step <= 17 then
			message.show_voiced_skipping(2800070)
		end
		if cutscene_step <= 18 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 19 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 20 then
			message.show_voiced_skipping(2800080)
		end
		if cutscene_step <= 21 then
			message.show_voiced_skipping(2800085)
		end
		if cutscene_step <= 22 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 23 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 24 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 25 then
			message.show_voiced_skipping(2800090)
		end
		if cutscene_step <= 26 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 27 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 28 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 29 then
			message.show_voiced_for_skipping(2800100, -1)
		end
		if cutscene_step <= 30 then
			wait.background_load_skipping()
		end
		if cutscene_step <= 31 then
			wait.background_load_skipping()
		end
		if cutscene_step <= 32 then
			message.show_voiced_for_skipping(2800110, 120)
		end
		if cutscene_step <= 33 then
			wait.frames_skipping(60)
		end
		if cutscene_step <= 34 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 35 then
			message.show_voiced_skipping(2800120)
		end
		if cutscene_step <= 36 then
			message.show_voiced_skipping(2800130)
		end
		if cutscene_step <= 37 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 38 then
			message.show_voiced_skipping(2800140)
		end
		if cutscene_step <= 39 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 40 then
			message.show_voiced_skipping(2800145)
		end
		if cutscene_step <= 41 then
			message.show_voiced_skipping(2800150)
		end
		if cutscene_step <= 42 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 43 then
			message.show_voiced_skipping(2800160)
		end
		if cutscene_step <= 44 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 45 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 46 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 47 then
			message.show_voiced_skipping(2800170)
		end
		if cutscene_step <= 48 then
			message.show_voiced_skipping(2800180)
		end
		if cutscene_step <= 49 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 50 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 51 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 52 then
			message.show_voiced_skipping(2800190)
		end
		if cutscene_step <= 53 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 54 then
			message.show_voiced_skipping(2800195)
		end
		if cutscene_step <= 55 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 56 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 57 then
			message.show_voiced_skipping(2800200)
		end
		if cutscene_step <= 58 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 59 then
			message.show_voiced_skipping(2800205)
		end
		if cutscene_step <= 60 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 61 then
			message.show_voiced_skipping(2800210)
		end
		if cutscene_step <= 62 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 63 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 64 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 65 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 66 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 67 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 68 then
			wait.frames_skipping(200)
		end
		if cutscene_step <= 69 then
			wait.frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(sound_effect_file, 8)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_event_280_actors_and_leave()
	event.reset_follow_camera(0)
end

--- Loads Mints, Monica, the gun item model and the effects for the gun gift scene.
local function load_event_285_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_events_275_277_285 = 0
		monica_slot_events_275_277_285 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e285/e285_mints.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_events_275_277_285, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e285/e285_monica.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_events_275_277_285 = 32
		monica_slot_events_275_277_285 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_events_275_277_285, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e285/e285_mints.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e285/e285_monica.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
	end
	event.load_item_model(5, 31, "info", 36)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(4, 39)
	event.clear_object_sequence(5, 39)
	event.set_object_sequence_object(5, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.attach_object_handle_to_character(5, 40)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 5)
	event.set_character_active(0, 40)
	event.load_message_file(0, 5, "event/e200/e285/e285_1.txt")
end

--- Fades in and pans the camera over the village while the opening line plays.
local function play_event_285_opening_pan()
	event.fade_in_screen(30)
	event.play_sound_effect(event_285_sound_file, 0)
	event.move_camera_sequence(111.21, 97.1, 1515.22, 354.23, 94.23, 1247.17, 540)
	wait.frames(50)
	message.show_voiced_for(2850010, -1)
	camera.wait_until_done()
	wait.frames(30)
	event.stop_sound_effect(event_285_sound_file, 0)
end

--- Shows the nose sneeze and the sparkle that drops the gift in front of Mints and Monica.
local function play_nose_sneeze_scene()
	event.set_object_sequence_motion(0, "立ち", 0)
	event.set_object_sequence_motion(1, "立ち", 0)
	wait.frames(15)
	message.show_voiced(2850020)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "もごもご")
	wait.frames(30)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "ふんっ")
	wait.frames(30)
	event.set_character_active(1, 38)
	event.set_wind(40.0, -96.86, 52.75, 388.46)
	event.set_character_motion(38, "鼻爆発", 2, -1, 1)
	event.play_sound_effect(event_285_sound_file, 1)
	wait.frames(15)
	event.set_wind(-1)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
	event.set_object_sequence_motion(0, "驚く", 6)
	event.set_object_sequence_motion(1, "おどろき", 6)
	event.queue_object_sequence_next_motion(0, "驚くL", 4)
	event.queue_object_sequence_next_motion(1, "おどろきL", 4)
	wait.frames(90)
	event.set_character_active(1, 39)
	event.set_character_motion(39, "キラキラ（ループ）", 4, -1, 1)
	event.play_sound_effect(event_285_sound_file, 2)
	event.clear_object_sequence_path(5)
	event.set_object_sequence_path_frames(5, 150)
	event.add_object_sequence_path_point(5, 12.99, 142.28, 609.6)
	event.add_object_sequence_path_point(5, 12.99, 35.2, 609.6)
	event.start_object_sequence_path(5)
	event.set_object_sequence_motion(0, "キラキラ見る", 2)
	event.set_object_sequence_motion(1, "おどろきＬから上向き立ち", 2)
	wait.frames(150)
	event.queue_object_sequence_next_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(1, "上向く戻り", 6, 0.025)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	wait.frames(20)
	event.set_character_motion(39, "消える", 2, -1, 1)
	wait.frames(30)
	object.wait_until_done(0)
	event.set_character_active(0, 39)
end

--- Shows Mints picking up the gun and announces the received item.
local function play_gun_pickup_scene()
	event.set_object_sequence_position(6, 5.99, 36.82, 613.24)
	event.set_object_sequence_rotation(6, 0.0, -2.92, 0.0)
	event.set_character_active(1, 36)
	event.set_character_active(1, 40)
	event.play_sound_effect(event_285_sound_file, 3)
	event.play_sound_effect(event_285_sound_file, 4)
	event.pause_music()
	event.play_sound_effect(item_get_sound_file, 0)
	event.set_object_sequence_motion(6, "発動", 6)
	event.attach_character_to_frame(mints_slot_events_275_277_285, "gun_hand", 36)
	event.set_object_sequence_motion(0, "銃ゲット", 4)
	wait.frames(15)
	inventory.announce_received(31, 1)
	event.detach_character_from_frame(36)
	event.set_character_active(0, 40)
	event.stop_sound_effect(item_get_sound_file, 0)
	event.play_music(0)
end

--- Restores the player and deletes the temporary actors of the gun gift scene.
local function unload_event_285_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(monica_slot_events_275_277_285)
		event.delete_character(36)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(mints_slot_events_275_277_285)
		event.delete_character(36)
		event.delete_character(37)
	end
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
end

--- Plays the cutscene in which Mints receives a gun from the sparkle and the party walks away.
local function play_event_285_cutscene()
	vm.section(function()
		event.set_save_flag(285, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2517)
		event_285_sound_file = event.load_sound_effect_file_2(2517) or event_285_sound_file
		item_get_sound_file = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_get_sound_file
		load_event_285_actors()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_character_position(38, -96.86, 52.75, 388.46)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_position(39, 37.43, 34.75, 561.52)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(111.21, 97.1, 1515.22)
		event.set_camera_sequence_look_at(-186.27, 94.23, 1323.31)
		event.set_object_sequence_position(0, 13.4, 6.52, 613.7)
		event.set_object_sequence_rotation(0, 0.0, -2.92, 0.0)
		event.set_object_sequence_position(1, 47.24, 7.54, 600.38)
		event.set_object_sequence_rotation(1, 0.0, -2.2, 0.0)
		play_event_285_opening_pan()
		event.set_camera_sequence_position(46.15, 36.68, 848.41)
		event.set_camera_sequence_look_at(38.64, 44.8, 724.85)
		play_nose_sneeze_scene()
		event.set_camera_sequence_position(3.9, 53.24, 586.95)
		event.set_camera_sequence_look_at(8.68, 32.62, 613.94)
		play_gun_pickup_scene()
		event.set_camera_sequence_position(46.15, 36.68, 848.41)
		event.set_camera_sequence_look_at(38.64, 44.8, 724.85)
		field_town_f01.walk_away_along_paths()
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(event_285_sound_file, 0)
	event.set_wind(-1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_event_285_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Mints, Monica, the Himarra model and the message file for the badge scene.
local function load_event_277_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot_events_275_277_285 = 0
		monica_slot_events_275_277_285 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e277/e277_mints.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 4, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 3, "info", monica_slot_events_275_277_285)
		event.load_equipment_model(5, 1, 2, "info", monica_slot_events_275_277_285, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e277/e277_monica.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot_events_275_277_285 = 32
		monica_slot_events_275_277_285 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 4, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 3, "info", mints_slot_events_275_277_285)
		event.load_equipment_model(5, 0, 2, "info", mints_slot_events_275_277_285, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e277/e277_mints.gltf", "info", mints_slot_events_275_277_285)
		event.attach_object_handle_to_character(0, mints_slot_events_275_277_285)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot_events_275_277_285)
		event.load_character_motion_pack(5, "event/e200/e277/e277_monica.gltf", "info", monica_slot_events_275_277_285)
		event.attach_object_handle_to_character(1, monica_slot_events_275_277_285)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot_events_275_277_285)
	end
	event.load_character(5, "event/e200/e277/e277_hima_b.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2, 35)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e277/e277_1.txt")
end

--- Resets the character slots to their post-load values for the skip handler of the first village scene.
local function reset_event_270_character_slots()
	mints_slot_events_275_277_285 = 0
	monica_slot_events_275_277_285 = 32
	mints_slot_events_275_277_285 = 32
	monica_slot_events_275_277_285 = 0
end

--- Restores the player and deletes the temporary actors of the badge scene.
local function unload_event_277_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(0, monica_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(monica_slot_events_275_277_285)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_character_active(0, mints_slot_events_275_277_285)
		event.delete_character_extension_packs(mints_slot_events_275_277_285)
		event.delete_character_extension_packs(monica_slot_events_275_277_285)
		event.delete_character(mints_slot_events_275_277_285)
		event.delete_character(37)
	end
	event.delete_character(35)
end

--- Plays the cutscene in which Monica receives a transformation badge and the party walks on.
local function play_event_277_cutscene()
	local sound_effect_file: s32 = 0
	local cutscene_step: number = 0
	vm.section(function()
		event.set_save_flag(277, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		cutscene_step = 1
		wait.frames(45)
		event.load_map_sounds(2509)
		sound_effect_file = event.load_sound_effect_file_2(2509) or sound_effect_file
		load_event_277_actors()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot_events_275_277_285)
		event.set_character_active(1, monica_slot_events_275_277_285)
		event.set_camera_sequence_position(-117.43, 40.09, 1220.9)
		event.set_camera_sequence_look_at(-24.54, 60.52, 1410.11)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(0, -130.99, 21.7, 1253.92)
		event.set_object_sequence_rotation(0, 0.0, 0.77, 0.0)
		event.set_object_sequence_position(1, -113.36, 16.04, 1218.2)
		event.set_object_sequence_rotation(1, 0.0, 0.17, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "歩き")
		event.set_object_sequence_motion(1, "歩き")
		cutscene_step = 2
		wait.frames(15)
		event.move_object_sequence(0, -76.57, 22.37, 1326.65, 90, 1)
		event.move_object_sequence(1, -99.28, 16.04, 1239.49, 30, 1)
		cutscene_step = 3
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		cutscene_step = 4
		message.show_voiced_for(2770010, -1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.rotate_object_sequence(0, 0.0, -2.87, 0.0, 20)
		cutscene_step = 5
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		cutscene_step = 6
		message.show_voiced_for(2770020, 60)
		event.set_camera_sequence_position(-88.03, 39.16, 1280.67)
		event.set_camera_sequence_look_at(-98.45, 39.74, 1240.52)
		event.attach_character_to_frame(monica_slot_events_275_277_285, "item", 35)
		event.set_character_active(1, 35)
		event.play_sound_effect(sound_effect_file, 0)
		event.set_object_sequence_motion(1, "バッチ持ち立ち", 4)
		cutscene_step = 7
		wait.frames(15)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 8
		message.show_voiced(2770030)
		event.reset_mouth_texture_animations()
		cutscene_step = 9
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 10
		message.show_voiced(2770040)
		event.reset_mouth_texture_animations()
		cutscene_step = 11
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		cutscene_step = 12
		message.show_voiced(2770050)
		event.reset_mouth_texture_animations()
		cutscene_step = 13
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "バッチ持ち立ち")
		cutscene_step = 14
		wait.frames(30)
		event.set_character_active(0, 35)
		event.detach_character_from_frame(35)
		event.set_camera_sequence_position(-117.43, 40.09, 1220.9)
		event.set_camera_sequence_look_at(-24.54, 60.52, 1410.11)
		event.set_object_sequence_motion(0, "やったね", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		cutscene_step = 15
		message.show_voiced(2770060)
		event.reset_mouth_texture_animations()
		cutscene_step = 16
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		cutscene_step = 17
		message.show_voiced(2770065)
		event.reset_mouth_texture_animations()
		cutscene_step = 18
		object.wait_until_done(0)
		cutscene_step = 19
		message.show_voiced_for(2770070, 150)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -60.53, 20.6, 1300.47, 60, 1)
		event.move_camera_sequence(-133.69, 30.07, 1231.38, -2.07, 60.52, 1392.67, 150)
		event.set_object_sequence_motion(0, "モニカ見立うなづき", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		cutscene_step = 20
		message.show_voiced_for(2770080, -1)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.89, 0.0, 30)
		cutscene_step = 21
		object.wait_until_done(0)
		event.move_object_sequence(0, -42.89, 22.37, 1361.14, 60, 1)
		event.move_object_sequence(1, -28.2, 20.64, 1346.17, 60, 1)
		cutscene_step = 22
		wait.frames(30)
	end, function(received: { any }): boolean
		if cutscene_step <= 1 then
			reset_event_270_character_slots()
			wait.frames_skipping(15)
		end
		if cutscene_step <= 2 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 3 then
			message.show_voiced_for_skipping(2770010, -1)
		end
		if cutscene_step <= 4 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 5 then
			message.show_voiced_for_skipping(2770020, 60)
		end
		if cutscene_step <= 6 then
			wait.frames_skipping(15)
		end
		if cutscene_step <= 7 then
			message.show_voiced_skipping(2770030)
		end
		if cutscene_step <= 8 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 9 then
			message.show_voiced_skipping(2770040)
		end
		if cutscene_step <= 10 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 11 then
			message.show_voiced_skipping(2770050)
		end
		if cutscene_step <= 12 then
			cutscene.skip_command(1)
		end
		if cutscene_step <= 13 then
			wait.frames_skipping(30)
		end
		if cutscene_step <= 14 then
			message.show_voiced_skipping(2770060)
		end
		if cutscene_step <= 15 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 16 then
			message.show_voiced_skipping(2770065)
		end
		if cutscene_step <= 17 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 18 then
			message.show_voiced_for_skipping(2770070, 150)
		end
		if cutscene_step <= 19 then
			message.show_voiced_for_skipping(2770080, -1)
		end
		if cutscene_step <= 20 then
			cutscene.skip_command(0)
		end
		if cutscene_step <= 21 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	cutscene_step = 23
	wait.frames(30)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_event_277_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Opens the dialogue of the villager that was talked to, depending on the story progress, and opens their shop menu when they have one.
local function talk_to_villager()
	local player_slot: s32 = 0
	local villager_slot: s32 = 0
	local villager_type: s32 = 0
	local dialogue_mode: s32 = 0
	local analysis_flag_103: s32 = 0
	local has_seen_event_280_type_100: s32 = 0
	local has_seen_event_280_type_101: s32 = 0
	local has_seen_event_280_type_104: s32 = 0
	local has_seen_event_280_type_102: s32 = 0
	local badge_purchased: s32 = 0
	local has_seen_event_280_type_103: s32 = 0
	local is_save_flag_640_set: s32 = 0
	local has_seen_event_280_type_105: s32 = 0
	local turning_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local target_angle: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_slot, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	dialogue_mode = 0
	if villager_type == 100 then
		analysis_flag_103 = event.get_georama_analysis_flag(103) or analysis_flag_103
		if analysis_flag_103 == 0 then
			event.open_message_window_2(
				0,
				"[UNI00da]ltimamente esto est[UNI00e1] un poco\nsolitario. Es como si\nfaltara algo, [UNI00bf]sabes? Pero bueno..."
			)
		else
			has_seen_event_280_type_100 = event.get_save_flag(280) or has_seen_event_280_type_100
			if has_seen_event_280_type_100 == 0 then
				event.open_message_window_2(
					0,
					"[UNI00a1]Jurak ha revivido!\nAunque no s[UNI00e9] por qu[UNI00e9], me hab[UNI00ed]a\nolvidado de [UNI00e9]l..."
				)
			else
				event.open_message_window_2(
					0,
					"Qu[UNI00e9] bien que este bosque tambi[UNI00e9]n\nhaya vuelto a la normalidad. Jurak est[UNI00e1]\nde buen humor. No nos podemos quejar."
				)
			end
		end
	end
	if villager_type == 101 then
		has_seen_event_280_type_101 = event.get_save_flag(280) or has_seen_event_280_type_101
		if has_seen_event_280_type_101 == 0 then
			event.open_message_window_2(
				0,
				"Pues yo he hecho una\nselecci[UNI00f3]n. Hasta har[UNI00ed]a un trato contigo\npara celebrar la vuelta de Jurak."
			)
		else
			event.open_message_window_2(0, "Gracias a ti, Jurak y el bosque\nhan vuelto a la normalidad. Vuelve\ncuando quieras.")
		end
	end
	if villager_type == 104 then
		has_seen_event_280_type_104 = event.get_save_flag(280) or has_seen_event_280_type_104
		if has_seen_event_280_type_104 == 0 then
			event.open_message_window_2(
				0,
				"Umm... Griffon le dio\nbien. Es dif[UNI00ed]cil imaginarse\nque Jurak se hab[UNI00ed]a ido de verdad..."
			)
		else
			event.open_message_window_2(
				0,
				"Jurak ha revivido: tenemos\nque atacar a Griffon. Estoy convencido de\nque podemos vencerle si colaboramos."
			)
		end
	end
	if villager_type == 102 then
		has_seen_event_280_type_102 = event.get_save_flag(280) or has_seen_event_280_type_102
		if has_seen_event_280_type_102 == 0 then
			badge_purchased = event.get_save_data_value(1, 52) or badge_purchased
			if badge_purchased == 0 then
				event.open_message_window_2(
					0,
					"Nos acaban de llegar unas Insignias de transfomaciones\nmonstruosas. Ll[UNI00e9]vate una\nantes de que se acaben."
				)
			else
				event.open_message_window_2(
					0,
					"Esta es la [UNI00fa]ltima Insignia. Menos mal\nque la has cogido, porque no s[UNI00e9]\ncu[UNI00e1]ndo nos traer[UNI00e1]n m[UNI00e1]s."
				)
			end
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]Est[UNI00e1]s usando la Insignia de transformaciones\nmonstruosas? Las hay de muchos\ntipos, m[UNI00ed]ralas."
			)
			cutscene.face_each_other(player_slot, villager_slot, 0)
			message.say_bubble(0, -1, villager_slot, player_slot, 0)
			dialogue_mode = 1
			event.open_message_window_2(
				0,
				"A veces, si le das lo que quiere\ntres veces a un monstruo, se\nquedar[UNI00e1] muy contento y soltar[UNI00e1] una insignia<page>cuando lo mates. Por supuesto, necesitar[UNI00e1]s\nuna de mis C[UNI00e1]psulas\nRegalo. [UNI00bf]Qu[UNI00e9] dices?"
			)
		end
	end
	if villager_type == 103 then
		has_seen_event_280_type_103 = event.get_save_flag(280) or has_seen_event_280_type_103
		if has_seen_event_280_type_103 == 0 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Hola! [UNI00bf]Est[UNI00e1] todo bueno?\nSi no comes bien, no\ncrecer[UNI00e1]s. Alim[UNI00e9]ntate bien, [UNI00bf]entendido?"
			)
		else
			event.open_message_window_2(0, "Jurak est[UNI00e1] feliz, los negocios van bien...\nEsto es una maravilla.")
		end
	end
	if villager_type == 105 then
		is_save_flag_640_set = event.get_save_flag(640) or is_save_flag_640_set
		if is_save_flag_640_set == 0 then
			has_seen_event_280_type_105 = event.get_save_flag(280) or has_seen_event_280_type_105
			if has_seen_event_280_type_105 == 0 then
				event.open_message_window_2(
					0,
					"[UNI00bf]Qu[UNI00e9] habr[UNI00e9] estado haciendo\ntodo este tiempo? No me\nacuerdo de nada.<page>Oye, pero qu[UNI00e9] vestido\nm[UNI00e1]s chulo llevas,\nsi es que yo digo tales cosas."
				)
			else
				event.open_message_window_2(
					0,
					"As[UNI00ed] que te vas a otro\npa[UNI00ed]s por fin, [UNI00bf]eh? Te deseo suerte\nen tus viajes."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Por favor, derrota al Emperador Griffon y\nacaba con esta\nopresi[UNI00f3]n. Todos depositamos nuestra fe en ti."
			)
		end
	end
	if dialogue_mode == 0 then
		cutscene.talk(villager_slot, -1, 0, 0)
	end
	if dialogue_mode == 1 then
		message.say_bubble(0, -1, villager_slot, player_slot, 0)
		event.set_character_motion(villager_slot, "立ち")
		event.finish_event()
	end
	if dialogue_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		turning_player_slot = event.get_player_character_slot() or turning_player_slot
		do
			local out1, _, out3 = event.get_character_position(turning_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_slot)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		target_angle = event.get_look_angle(villager_x - player_x, villager_z - player_z) or target_angle
		character.turn_to_angle(turning_player_slot, target_angle)
		event.set_character_rotation(turning_player_slot, 0.0, target_angle, 0.0)
		event.set_character_motion(turning_player_slot, "立ち")
		message.say_bubble(0, -1, villager_slot, turning_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_slot)
	if villager_type == 101 then
		menu.open_type_6_alt(25)
	end
	if villager_type == 102 then
		menu.open_type_6_alt(24)
	end
	if villager_type == 103 then
		menu.open_type_6_alt(26)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.set_up_map = set_up_map
script[99] = script.set_up_map

--- Runs the village entry, placing the player and starting the progress cutscene that is due.
function script.default_event()
	local previous_map_number: s32 = 0
	local analysis_flag_103: s32 = 0
	local item_limit_status: s32 = 0
	local overflow_item_count: s32 = 0
	set_up_map()
	previous_map_number = event.get_previous_map() or previous_map_number
	if previous_map_number == 0 then
		event.set_camera_position(39.03, 111.84, 77.64)
		event.set_camera_look_at(36.78, 22.33, 74.62)
		event.fade_out_screen(0, 255, 255, 255)
		vm.wait(1)
		event.set_camera_position(102.4, 73.47, 1368.2)
		event.set_camera_look_at(102.4, 53.47, 1488.2)
		event.set_character_position(0, 110.0, 23.7, 1533.0)
		event.set_character_rotation(0, 0.0, -3.1415927, 0.0)
		event.reset_follow_camera(1, 3.14, 2.0)
	end
	event.fade_in_screen(30)
	event.get_save_flag(250)
	event.get_save_flag(260)
	event.get_save_flag(270)
	event.get_save_flag(272)
	event.get_save_flag(275)
	event.get_save_flag(280)
	event.get_save_flag(285)
	analysis_flag_103 = event.get_georama_analysis_flag(103) or analysis_flag_103
	event.get_georama_analysis_flag(104)
	event.get_georama_analysis_percent(0)
	if analysis_flag_103 == 0 then
		return
	end
	if georama.can_start_event_270() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(270, 1)
		play_event_270_cutscene()
		event.set_character_position(0, 169.8, 23.7, 1378.8)
		return
	end
	if georama.can_start_event_272() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(272, 1)
		play_seed_gift_cutscene()
		event.add_inventory_item(361)
		event.add_inventory_item(308)
		item_limit_status = event.get_item_limit_status() or item_limit_status
		overflow_item_count = event.get_overflow_item_count() or overflow_item_count
		if item_limit_status >= 1 or overflow_item_count >= 1 then
			event.fade_out_screen(10)
			wait.frames(10)
			event.open_event_menu(16)
			vm.wait(5)
			event.fade_in_screen(10)
		end
		return
	end
	if georama.can_start_event_275() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(275, 1)
		field_town_f01.update_resident_visibility()
		play_event_275_cutscene()
		return
	end
	if georama.can_start_event_280() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(280, 1)
		play_event_280_cutscene()
		return
	end
	if georama.can_trigger_full_analysis_event() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(285, 1)
		play_event_285_cutscene()
		event.add_inventory_item(31)
		inventory.resolve_overflow_alt(1)
		return
	end
	event.set_character_position(0, 110.0, 23.7, 1533.0)
	event.set_character_rotation(0, 0.0, -3.1415927, 0.0)
	event.reset_follow_camera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_seed_gift_cutscene

--- Warps through the time gate and jumps to the next map.
function script.enter_time_gate()
	time_gate.warp_through_gate(100.0, vm.f32(23.67), 1500.0, 0.0)
	event.jump_to_map_2(-1, "g01")
end
script[300] = script.enter_time_gate

--- Disables the trigger point and plays the badge scene.
function script.cutscene_receive_badge()
	event.set_function_point_enabled("", "e277", 0)
	event.set_save_flag(277, 1)
	play_event_277_cutscene()
end
script[400] = script.cutscene_receive_badge

--- Shows Jurak's dialogue according to the story progress with a temporary camera.
function script.talk_to_jurak()
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local player_slot: s32 = 0
	local is_save_flag_640_set: s32 = 0
	local has_visited_crest: s32 = 0
	local has_seen_event_280: s32 = 0
	local has_seen_event_275: s32 = 0
	local has_seen_event_272: s32 = 0
	local sundrop_count: s32 = 0
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_active_camera_next_position(-140.41, 35.58, 1026.08)
	event.set_active_camera_next_look_at(23.01, 135.7, 535.77)
	player_slot = event.get_player_character_slot() or player_slot
	field_town_f01.turn_toward_point(player_slot, 0.0, 300.0)
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 0)
	is_save_flag_640_set = event.get_save_flag(640) or is_save_flag_640_set
	if is_save_flag_640_set == 0 then
		has_visited_crest = event.get_save_flag(372) or has_visited_crest
		if has_visited_crest == 0 then
			has_seen_event_280 = event.get_save_flag(280) or has_seen_event_280
			if has_seen_event_280 == 0 then
				has_seen_event_275 = event.get_save_flag(275) or has_seen_event_275
				if has_seen_event_275 == 0 then
					has_seen_event_272 = event.get_save_flag(272) or has_seen_event_272
					if has_seen_event_272 == 0 then
						event.open_message_window_2(
							0,
							"No meeeeeeeeeee acueeeeeeeeerdo de\nnaaaaaaada. Supongo que\ns[UNI00f3]lo necesito un poooooocoooo de tieeeeempo."
						)
					else
						event.open_message_window_2(
							0,
							"[UNI00bf]Hab[UNI00e9][UNI00e9][UNI00e9][UNI00e9][UNI00e9][UNI00e9]is sembraaado?\n[UNI00bf]Creeeecen las plantas?<page>Ha sido un dooon del cieeelo, as[UNI00ed] que nooo\nlo desperdiiiiici[UNI00e9]is por ah[UNI00ed], [UNI00bf]me oooo[UNI00ed]s?"
						)
					end
				else
					sundrop_count = event.get_item_count(356) or sundrop_count
					if sundrop_count <= 0 then
						event.open_message_window_2(
							0,
							"Puedes conseguir una Gota de Sol si\nhablas con un monstruo Himarra del bosque, [UNI00bf]lo\nsab[UNI00ed]as? Usa la Insignia para hablar con [UNI00e9]l."
						)
						message.show(0, -1, 3, 0, 416)
						event.open_message_window_2(
							0,
							"Para convertirte en un Himarraaaa, necesitas\nuna Insignia Himarraaaa.<page>A veces las venden en\ntiendas de ropaaaaa.<page>[UNI00a1]Ah, s[UNI00ed][UNI00ed][UNI00ed][UNI00ed][UNI00ed][UNI00ed]! Hay una tiendaaaaa\nde ropa dentro de mi nariiiiiiiz."
						)
						message.show(0, -1, 3, 0, 416)
						event.open_message_window_2(
							0,
							"Mi fosa nasal derecha sigue vac[UNI00ed][UNI00ed][UNI00ed][UNI00ed][UNI00ed][UNI00ed]a.\nEstoy buscando a un inquilino."
						)
					else
						event.open_message_window_2(
							0,
							"[UNI00a1]Ya has encontrado la Gota de Sol!\nAhora [UNI00fa]sala donde hayas\nplantado la Lafrescia.<page>Espero que encuentres la\nMariposa Arco Iris. Rezar[UNI00e9] por\nti, para que no sucumbas en la batalla."
						)
					end
				end
			else
				event.open_message_window_2(
					0,
					"Pregunta a Crest, el Gran Sabio del\ntemplo del Valle del Equilibrio\nsi quieres m[UNI00e1]s informaci[UNI00f3]n.<page>Sin duda, [UNI00e9]l te dir[UNI00e1] todo lo\nque necesitas\nsaber."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Vaya, vaya, as[UNI00ed] que has\nido a ver a Crest. [UNI00bf]No es verdad?\nEs un largo camino.<page>Pero todav[UNI00ed]a te queda mucho\npor recorrer. No abandones\nahora, [UNI00bf]entendido?"
			)
		end
	else
		event.open_message_window_2(
			0,
			"As[UNI00ed] que te vas para enfrentarte\na Griffon, [UNI00bf]no? Hay algo que\ntodav[UNI00ed]a me preocupa.<page>El esp[UNI00ed]ritu que percibo\ndentro de Griffon est[UNI00e1] mezclado con\notro amable. [UNI00bf]Qu[UNI00e9] extra[UNI00f1]o, no?"
		)
	end
	message.show(0, -1, 3, 0, 416)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.start_crossfade(10)
end
script[401] = script.talk_to_jurak

--- Gives an item the first time and otherwise comments on the egg.
function script.examine_egg()
	local has_taken_item: s32 = 0
	event.set_character_motion(0, "立ち")
	has_taken_item = event.get_save_flag(36) or has_taken_item
	if has_taken_item == 0 then
		event.set_save_flag(36, 1)
		event.add_inventory_item(376)
		inventory.announce_received(376, 1)
		inventory.resolve_overflow_alt(1)
	else
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] habr[UNI00e1] dentro del\nhuevo?")
		message.show(0, -1, 5, 256, 208)
	end
end
script[402] = script.examine_egg

--- Replays the gun gift scene and fades the screen back in.
function script.cutscene_gun_gift()
	play_event_285_cutscene()
	event.fade_in_screen(30)
end
script[501] = script.cutscene_gun_gift

--- Event 1000, which map data, a script or the engine runs by number.
script.talk_to_villager = talk_to_villager
script[1000] = script.talk_to_villager

--- Sets the georama and story flags so the scene numbered 270 plays next and jumps to the map.
function script.jump_to_before_event_270()
	event.set_georama_analyze_flag(0, 4, 0)
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_save_flag(270, 0)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end
script[12700] = script.jump_to_before_event_270

--- Sets the georama and story flags so the scene numbered 272 plays next and jumps to the map.
function script.jump_to_before_event_272()
	event.set_georama_analyze_flag(0, 4, 0)
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 0)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end
script[12720] = script.jump_to_before_event_272

--- Sets the georama and story flags so the scene numbered 275 plays next and jumps to the map.
function script.jump_to_before_event_275()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 0)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end
script[12750] = script.jump_to_before_event_275

--- Sets the georama and story flags so the scene numbered 277 plays next and jumps to the map.
function script.jump_to_before_event_277()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 0)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.set_save_data_value(1, 52, 1)
	event.jump_to_map_3(-1, 25, 400)
	vm.wait(1)
end
script[12770] = script.jump_to_before_event_277

--- Sets the georama and story flags so the scene numbered 280 plays next and jumps to the map.
function script.jump_to_before_event_280()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 0)
	event.set_save_flag(285, 1)
	event.set_save_flag(260, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end
script[12800] = script.jump_to_before_event_280

--- Sets the georama and story flags so the scene numbered 285 plays next and jumps to the map.
function script.jump_to_before_event_285()
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_georama_analyze_flag(0, 5, 1)
	event.set_georama_analyze_flag(0, 6, 1)
	event.set_georama_analyze_flag(0, 7, 1)
	event.set_georama_analyze_flag(0, 8, 1)
	event.set_georama_analyze_flag(0, 9, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 0)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end
script[12850] = script.jump_to_before_event_285

return script
