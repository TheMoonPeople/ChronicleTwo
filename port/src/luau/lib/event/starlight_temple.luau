--!strict
--- Helpers for the Starlight Temple: crystal worshippers, door flags and a cutscene.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local georama = vm.module("@lib/event/georama")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local starlight_temple = {}

--- Forwards a stubbed gate flag and its dependent analysis flags to empty handlers in place of the character activation update.
function starlight_temple.forward_analysis_flags()
	local unused_value: s32 = 0
	local gate_flag: s32 = 0
	gate_flag = georama.is_placeholder_condition_met()
	starlight_temple.ignore_gated_flag(gate_flag, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(203, unused_value)
	starlight_temple.ignore_character_activation(214, unused_value)
	starlight_temple.ignore_character_activation(205, georama.is_placeholder_condition_met())
	starlight_temple.ignore_gated_flag(gate_flag, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(206, unused_value)
	starlight_temple.ignore_gated_flag(gate_flag, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(213, unused_value)
end

--- Returns georama analysis flag 200.
function starlight_temple.get_analysis_flag_200()
	local flag_value: s32 = 0
	flag_value = event.get_georama_analysis_flag(200) or flag_value
	return flag_value
end

--- Returns georama analysis flag 202.
function starlight_temple.get_analysis_flag_202()
	local flag_value: s32 = 0
	flag_value = event.get_georama_analysis_flag(202) or flag_value
	return flag_value
end

--- Returns georama analysis flag 204.
function starlight_temple.get_analysis_flag_204()
	local flag_value: s32 = 0
	flag_value = event.get_georama_analysis_flag(204) or flag_value
	return flag_value
end

--- Accepts a character number and an enable value and discards both.
function starlight_temple.ignore_character_activation(character_number: s32, enable: s32) end

--- Accepts a gate flag and a flag value and discards both.
function starlight_temple.ignore_gated_flag(gate_flag: any, flag_value: s32) end

--- Plays the e368 cutscene in which the two party members talk while an image fades in over the scene.
function starlight_temple.play_event_e368()
	local sound_effect: s32 = 0
	local playable_character: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_flag(368, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		sound_effect = event.load_sound_effect_file_2(3509) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e300/e368/")
		event.load_message_file(0, 5, "e368_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e368_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e368_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		image_block = event.load_event_image_4(5, "e368.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e36801", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e368/e368_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e368/e368_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/e300/e368/e368_mints.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 889.1, 150.0, 598.51)
		event.set_object_handle_rotation(0, 0.0, 0.24, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 907.3, 150.0, 585.9)
		event.set_object_handle_rotation(1, 0.0, 0.36, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(822.94, 292.09, 464.14)
		event.set_camera_sequence_look_at(888.01, 411.5, 627.94)
		event.move_camera_sequence_eased(822.94, 179.49, 464.14, 888.01, 192.78, 627.94, 80, 2, 1.0)
		event.fade_in_screen(30)
		camera.wait_until_done()
		wait.frames(30)
		event.set_camera_sequence_position(935.24, 171.98, 594.15)
		event.set_camera_sequence_look_at(856.4, 172.24, 590.98)
		event.play_sound_effect(sound_effect, 0)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3680010)
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect, 1)
		event.set_object_sequence_motion(0, "左向く会話", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3680020)
		object.wait_until_done(0)
		event.set_object_sequence_color(2, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3680030)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3680040)
		event.set_object_sequence_color(2, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(935.94, 158.93, 616.81)
		event.set_camera_sequence_look_at(889.62, 174.25, 585.75)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "右向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3680050)
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect, 2)
		event.set_object_sequence_motion(0, "そういうことか", 6)
		event.queue_object_sequence_next_motion(0, "そういうことかL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3680060)
		object.wait_until_done(0)
		event.set_camera_sequence_position(822.94, 179.49, 464.14)
		event.set_camera_sequence_look_at(888.01, 192.78, 627.94)
		event.set_object_sequence_motion(1, "右向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3680070)
		event.set_object_sequence_motion(0, "左向くうなづき", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		object.wait_until_done(0)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(18)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_position(0, 889.1, 150.0, 598.51)
	event.set_character_rotation(0, 0.0, 0.24, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Enables the door02 and door03 function points from analysis flags 206 and 207 and then updates the temple characters' activation.
function starlight_temple.refresh_door_function_points()
	local flag_value: s32 = 0
	flag_value = event.get_georama_analysis_flag(206) or flag_value
	event.set_function_point_enabled("", "door02", flag_value)
	flag_value = event.get_georama_analysis_flag(207) or flag_value
	event.set_function_point_enabled("", "door03", flag_value)
	starlight_temple.update_character_activation()
end

--- Shows ten worshippers bowing to the crystal, or hides them.
function starlight_temple.set_worshippers_active(enable: s32)
	local index: s32 = 0
	if enable ~= 0 then
		index = 0
		while index < 10 do
			event.set_character_active(1, 42 + index)
			event.set_character_motion(42 + index, "水晶にお辞儀", 4)
			index = index + 1
		end
		event.set_character_position(42, 112.7, 453.82, 410.32)
		event.set_character_rotation(42, 0.0, -2.4, 0.0)
		event.set_character_position(43, -128.56, 453.82, 417.45)
		event.set_character_rotation(43, 0.0, 2.37, 0.0)
		event.set_character_position(44, -316.94, 453.82, 298.96)
		event.set_character_rotation(44, 0.0, 2.4, 0.0)
		event.set_character_position(45, -415.03, 453.82, 114.12)
		event.set_character_rotation(45, 0.0, 1.68, 0.0)
		event.set_character_position(46, -428.97, 453.82, -76.2)
		event.set_character_rotation(46, 0.0, 1.32, 0.0)
		event.set_character_position(47, 421.58, 453.82, 122.95)
		event.set_character_rotation(47, 0.0, -1.8, 0.0)
		event.set_character_position(48, 422.72, 453.82, -107.04)
		event.set_character_rotation(48, 0.0, -1.32, 0.0)
		event.set_character_position(49, -303.33, 453.82, -301.24)
		event.set_character_rotation(49, 0.0, 0.72, 0.0)
		event.set_character_position(50, 123.16, 453.82, -418.07)
		event.set_character_rotation(50, 0.0, -0.24, 0.0)
		event.set_character_position(51, -108.32, 453.82, -423.81)
		event.set_character_rotation(51, 0.0, 0.24, 0.0)
	else
		index = 0
		while index < 10 do
			event.set_character_active(0, 42 + index)
			index = index + 1
		end
	end
end

--- Activates the temple characters numbered 203, 205, 206, 213 and 214 from the georama analysis flags, gating most of them on analysis flag 202.
function starlight_temple.update_character_activation()
	local flag_value: s32 = 0
	local gate_flag: s32 = 0
	gate_flag = starlight_temple.get_analysis_flag_202()
	flag_value = if gate_flag ~= 0 then starlight_temple.get_analysis_flag_200() else 0
	character.set_active_by_number(203, flag_value)
	character.set_active_by_number(214, flag_value)
	character.set_active_by_number(205, georama.is_analysis_flag_209_set())
	flag_value = if gate_flag ~= 0 then starlight_temple.get_analysis_flag_204() else 0
	character.set_active_by_number(206, flag_value)
	flag_value = if gate_flag ~= 0 then georama.is_analysis_flag_207_set() else 0
	character.set_active_by_number(213, flag_value)
end

return starlight_temple
