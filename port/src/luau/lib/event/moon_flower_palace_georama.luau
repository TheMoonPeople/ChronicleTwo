--!strict
--- Helpers specific to the Moon Flower Palace georama map.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local moon_flower_palace_georama = {}

--- Asks the exit prompt with the given id and returns 1 after fading out when the player confirms, otherwise returns 0.
function moon_flower_palace_georama.confirm_leave_scene(prompt_id: s32)
	local exit_choice: any = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, prompt_id)
		if exit_choice == 0 then
			event.fade_out_screen(20)
			progress = 2
			wait.frames(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if progress <= 2 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(20)
			end
			return 1
		end
		return nil
	end)
end

--- Returns 1 when the georama analysis percentage for map 4 has reached 100.
function moon_flower_palace_georama.is_analysis_complete()
	local percent: s32 = 0
	percent = event.get_georama_analysis_percent(4) or percent
	if percent < 100 then
		return 0
	end
	return 1
end

--- Returns georama analysis flag 505.
function moon_flower_palace_georama.is_analysis_flag_505_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(505) or analysis_flag
	return analysis_flag
end

--- Returns 1 when georama analysis flag 505 is set and save flag 744 is clear.
function moon_flower_palace_georama.is_hint_pending_744()
	local hint_done_flag: s32 = 0
	if moon_flower_palace_georama.is_analysis_flag_505_set() == 0 then
		return 0
	end
	hint_done_flag = event.get_save_flag(744) or hint_done_flag
	if hint_done_flag ~= 0 then
		return 0
	end
	return 1
end

--- Returns 1 when the map 4 georama analysis is complete and save flag 748 is clear.
function moon_flower_palace_georama.is_hint_pending_748()
	local hint_done_flag: s32 = 0
	if moon_flower_palace_georama.is_analysis_complete() == 0 then
		return 0
	end
	hint_done_flag = event.get_save_flag(748) or hint_done_flag
	if hint_done_flag ~= 0 then
		return 0
	end
	return 1
end

--- Plays event 700 with Andrea, Mints and Monica at noon, then restores the time of day and fades out.
function moon_flower_palace_georama.play_scene_e700()
	local playable_character: s32 = 0
	local sound_effect_file: s32 = 0
	local time_of_day: f32 = 0
	vm.section(function()
		event.set_save_flag(700, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.load_map_sounds(7204)
		sound_effect_file = event.load_sound_effect_file_2(7204) or sound_effect_file
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e700/")
		event.load_message_file(0, 5, "e700_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e700_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e700_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e700_andrea.gltf", "info", 34)
		event.set_scene_status_flags(1, 34, 8, 1)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e700_a_hikari.gltf", "info", 35)
		event.set_scene_character_type(35, 4)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e700/e700_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e700/e700/e700_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 7.0, 0.0, 200.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 7)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -7.0, 0.0, 198.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 7)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 20.0, 160.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_motion(2, "両手開くＬ", 4)
		event.set_object_handle_position(3, 11.0, 40.0, 160.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "後光", 4)
		event.enable_drama_skip()
		time_of_day = event.get_scene_time_of_day() or time_of_day
		event.set_time_of_day(12.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(24.65, 49.97, 163.5)
		event.set_camera_sequence_look_at(-24.72, 49.99, 159.92)
		wait.frames(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ２")
		event.set_object_sequence_motion(2, "両手開いて深呼吸", 2)
		event.queue_object_sequence_next_motion(2, "両手開いて深呼吸Ｌ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(7000140)
		event.set_camera_sequence_position(0.0, 17.98, 252.41)
		event.set_camera_sequence_look_at(0.0, 26.48, 201.7)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ３")
		event.set_object_sequence_position(3, 0.0, 40.0, 160.0)
		event.set_object_sequence_motion(2, "両手開く戻り", 6)
		event.queue_object_sequence_next_motion(2, "浮遊立ち", 4)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000150)
		object.wait_until_done(2)
		event.set_camera_sequence_position(0.0, 48.71, 192.39)
		event.set_camera_sequence_look_at(0.0, 48.68, 135.78)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000160)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000165)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あき～さみし目とじ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		message.show_voiced(7000170)
		event.set_camera_sequence_position(0.0, 39.02, 371.19)
		event.set_camera_sequence_look_at(0.0, 38.99, 314.58)
		event.play_sound_effect(sound_effect_file, 2)
		event.set_character_visible(34, 0, 1, 0.033333335)
		event.set_object_sequence_motion(3, "消失", 2)
		wait.frames(30)
		event.move_camera_sequence_eased(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
		camera.wait_until_done()
		wait.frames(20)
		event.set_time_of_day(time_of_day)
		event.start_crossfade(60)
		wait.frames(90)
		event.set_camera_sequence_position(23.26, 26.93, 164.88)
		event.set_camera_sequence_look_at(-0.0, 18.34, 203.74)
		wait.frames(40)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_effect_file, 3)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, sound_effect_file, 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7000180)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7000190)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_effect_file, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_effect_file, 5)
		wait.frames(10)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		wait.frames(10)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おこり目")
		wait.frames(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

return moon_flower_palace_georama
