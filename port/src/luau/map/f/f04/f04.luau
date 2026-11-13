--!strict
--- Event script for the f04 Gundorada field area, handling its elevators, jump gates and georama analysis event setup.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local gundorada = require("@lib/event/gundorada")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Hides the analysis map part when its flag is set and refreshes the analysis character visibility.
local function hide_analysis_part_and_update_characters()
	if georama.is_analysis_flag_410_set() ~= 0 then
		event.attach_object_handle_to_map_part_2(0, "p10_f0401")
		event.set_object_handle_visible(0, 0)
	end
	gundorada.update_analysis_character_visibility()
end

--- Plays scene 548, the cutscene shown when the matching Georama analysis event starts.
local function play_scene_548()
	local scene_sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(548, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(5519)
		scene_sound_effect = event.load_sound_effect_file_2(5519) or scene_sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e548/")
		event.load_message_file(0, 5, "e548.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e548_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e548_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e500/e548/e548_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e500/e548/e548_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 6.86, 0.0, 78.4)
		event.set_object_handle_rotation(0, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -11.07, 0.0, 79.71)
		event.set_object_handle_rotation(1, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-0.89, 17.4, 23.48)
		event.set_camera_sequence_look_at(-4.13, 26.67, 318.08)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 6.86, 0.0, 134.2, 80)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -16.25, 0.0, 134.11, 90)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		object.wait_until_done(1)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(17.79, 9.71, 164.37)
		event.set_camera_sequence_look_at(-8.32, 25.41, 125.32)
		event.set_object_sequence_position(1, -9.86, 0.0, 136.53)
		event.set_object_sequence_rotation(1, 0.0, 0.03, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5480010)
		event.set_camera_sequence_position(365.14, 3489.04, 547.36)
		event.set_camera_sequence_look_at(1061.18, 2794.56, 1334.73)
		event.move_camera_sequence(-1008.44, 3489.04, 1761.6, -311.9, 2794.56, 2548.54, 120)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5480020)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(462.3, 74.35, 2186.93)
		event.set_camera_sequence_look_at(265.85, 104.22, 2195.54)
		event.move_camera_sequence_angle_height_distance(2.9, -74.33, 524.9, 240)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5480030)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-601.26, 2565.32, 2318.97)
		event.set_camera_sequence_look_at(-558.59, 2522.74, 2438.67)
		event.move_camera_sequence(-1019.04, 2565.32, 1129.79, -967.92, 2522.74, 1273.21, 180)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5480040)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(83.14, 76.3, 216.76)
		event.set_camera_sequence_look_at(6.83, 24.83, 142.53)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		message.show_voiced(5480050)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く会話", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "左向くL")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5480060)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, scene_sound_effect, 0)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5480070)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(14)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, 0.0, 50.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Plays scene 552, the cutscene shown when the matching Georama analysis event starts.
local function play_scene_552()
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(552, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e552/")
		event.load_message_file(0, 5, "e552.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e552_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e500/e548/e548_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 6.86, 0.0, 78.4)
		event.set_object_handle_rotation(0, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-48.86, 89.93, 248.19)
		event.set_camera_sequence_look_at(12.07, 9.71, 74.55)
		event.set_character_active(0)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 3.32, 0.0, 116.62, 80)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		object.wait_until_done(0)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(22.04, 8.19, 149.45)
		event.set_camera_sequence_look_at(-1.58, 23.89, 108.84)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5520010)
		event.set_camera_sequence_position(142.67, 815.3, 537.72)
		event.set_camera_sequence_look_at(130.25, 993.61, 1012.41)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.move_camera_sequence(81.88, 1714.97, 1427.25, 69.16, 1893.28, 1913.55, 90)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(-48.86, 89.93, 248.19)
		event.set_camera_sequence_look_at(12.07, 9.71, 74.55)
		wait.for_frame_count(20)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5520020)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "走り", 4)
		wait.for_frame_count(10)
		event.rotate_object_sequence(0, 0.0, 1.47, 0.0, 5)
		event.move_object_sequence(0, 255.2, 0.0, 125.39, 120)
		event.move_camera_sequence(-51.8, 89.93, 247.2, 139.01, 3.51, 77.46, 90)
		wait.for_frame_count(90)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(11)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(vm.f32(255.2), 0.0, vm.f32(125.39), vm.f32(1.47))
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Plays scene 556 and restores the field music when it ends.
local function play_scene_556()
	local scene_sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	local default_music_number: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(556, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(5524)
		scene_sound_effect = event.load_sound_effect_file_2(5524) or scene_sound_effect
		event.play_sound_effect(scene_sound_effect, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e556/")
		event.load_message_file(0, 5, "e556.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e556_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e556_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e500/e548/e548_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e500/e548/e548_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, -193.68, 0.0, 73.48)
		event.set_object_handle_rotation(0, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -216.19, 0.0, 74.79)
		event.set_object_handle_rotation(1, 0.0, 0.03, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1887.71, 3927.56, 1055.04)
		event.set_camera_sequence_look_at(-1156.25, 3675.26, 2209.98)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.move_camera_sequence(-1527.79, 3854.3, 1598.26, -829.22, 3554.42, 2756.88, 60)
		event.fade_in_screen(30)
		event.play_sound_effect(scene_sound_effect, 1)
		wait.for_frame_count(60)
		event.start_crossfade(30)
		event.set_camera_sequence_position(695.29, 4027.12, 592.97)
		event.set_camera_sequence_look_at(1043.56, 2105.14, 2169.9)
		event.stop_sound_effect(scene_sound_effect, 1)
		event.play_sound_effect(scene_sound_effect, 2)
		event.move_camera_sequence(792.52, 3840.41, 1112.82, 1023.76, 2204.87, 2154.46, 90)
		wait.for_frame_count(90)
		event.start_crossfade(30)
		event.set_camera_sequence_position(390.04, 1913.65, 1546.59)
		event.set_camera_sequence_look_at(-3.71, 2508.25, 2769.81)
		event.stop_sound_effect(scene_sound_effect, 2)
		event.play_sound_effect(scene_sound_effect, 3)
		event.move_camera_sequence(311.55, 2000.73, 1796.37, -36.66, 2508.25, 2871.9, 90)
		wait.for_frame_count(90)
		event.start_crossfade(30)
		event.set_camera_sequence_position(77.11, 1977.53, 568.47)
		event.set_camera_sequence_look_at(-6.16, 2923.06, 2851.89)
		event.stop_sound_effect(scene_sound_effect, 3)
		event.play_sound_effect(scene_sound_effect, 4)
		event.move_camera_sequence(-8.75, 1736.89, 256.13, -3.94, 2828.04, 2790.99, 120)
		wait.for_frame_count(120)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-168.35, 63.68, 137.42)
		event.set_camera_sequence_look_at(-203.33, 14.92, 72.64)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5560010)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5560020)
		event.set_camera_sequence_position(-208.74, 0.55, 25.47)
		event.set_camera_sequence_look_at(-204.56, 33.98, 76.86)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.delay_object_sequence_motion_track(1, 120)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "右向く", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "右向くL")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5560025)
		event.set_object_sequence_position(1, -9.86, 0.0, 136.53)
		event.set_object_sequence_rotation(1, 0.0, 0.03, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(-181.0, 10.89, 97.27)
		event.set_camera_sequence_look_at(-195.22, 24.21, 69.35)
		event.set_object_sequence_motion(0, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向く", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(0, "上向くL")
		wait.for_frame_count(75)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5560030)
		event.set_camera_sequence_position(-2993.05, 3147.07, -1117.3)
		event.set_camera_sequence_look_at(-2885.8, 3145.8, -973.91)
		wait.for_frame_count(60)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(scene_sound_effect, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	default_music_number = event.get_default_music_number(102) or default_music_number
	event.load_music(default_music_number)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, 0.0, 50.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Plays scene 508, the cutscene shown when the matching Georama analysis event starts.
local function play_scene_508()
	local character_slot: s32 = 0
	local scene_sound_effect: s32 = 0
	local cue_sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(508, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		character_slot = event.find_scene_character_slot(401) or character_slot
		event.set_character_active(0, character_slot)
		event.load_map_sounds(5500)
		scene_sound_effect = event.load_sound_effect_file_2(5500) or scene_sound_effect
		cue_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or cue_sound_effect
		event.set_scene_status_flags(1, 0, 256, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e508/")
		event.load_message_file(0, 5, "e508.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e508_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e508_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e508_gisecon.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e508_bom_t.gltf", "info", 36)
		event.set_character_active(36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		block = event.load_event_image_4(5, "e508.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e50801", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e500/e508/e508_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e500/e508/e508_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
		event.set_character_active(37)
		event.attach_object_handle_to_character(5, 37)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_handle_position(0, 29.8, -1160.0, 5918.68)
		event.set_object_handle_rotation(0, 0.0, -2.13, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 116.43, -1160.0, 5909.81)
		event.set_object_handle_rotation(1, 0.0, -2.13, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -95.34, 1160.0, 5824.2)
		event.set_object_handle_rotation(2, 0.0, 3.07, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(5, -67.36, 1194.16, 5795.09)
		event.set_object_handle_rotation(5, 0.0, 1.39, 0.0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(4, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-103.82, 1168.63, 5924.94)
		event.set_camera_sequence_look_at(-95.48, 1187.1, 5825.3)
		event.set_character_active(0)
		event.set_character_active(0, 37)
		event.move_camera_sequence_angle_height_distance_eased(-2.77, -18.15, 77.63, 150, 2, 0.5)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		wait.for_frame_count(180)
		event.set_object_sequence_position(0, 59.27, 1160.0, 5900.71)
		event.set_object_sequence_position(1, 116.43, 1160.0, 5909.81)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -29.62, 1160.0, 5881.12, 120)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -17.95, 1160.0, 5866.09, 120)
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "立ち")
		wait.for_frame_count(150)
		event.play_sound_effect(scene_sound_effect, 2)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くループ", 4)
		wait.for_frame_count(30)
		event.stop_sound_effect(scene_sound_effect, 2)
		event.set_camera_sequence_position(-42.11, 1183.03, 5838.93)
		event.set_camera_sequence_look_at(-92.5, 1187.1, 5823.57)
		event.set_object_sequence_motion(2, "振り向く（会話）", 6)
		event.queue_object_sequence_next_motion(2, "振り向くループ", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080010)
		event.set_object_sequence_rotation(0, 0.0, -2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(-40.15, 1177.76, 5832.3)
		event.set_camera_sequence_look_at(-19.81, 1181.94, 5882.99)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(5080020)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(5080025)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(5080030)
		event.set_camera_sequence_position(-288.23, 1713.07, 1700.32)
		event.set_camera_sequence_look_at(-265.03, 1706.85, 1729.17)
		event.move_camera_sequence(-245.15, 1713.07, 1697.71, -265.03, 1706.85, 1729.17, 600)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced_for_stopping(5080040, 300)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced_for_stopping(5080050, 300)
		camera.wait_until_done()
		event.set_object_sequence_position(0, -43.15, 1160.0, 5855.69)
		event.set_object_sequence_rotation(0, 0.0, -1.89, 0.0)
		event.set_object_sequence_position(1, -36.4, 1160.0, 5827.54)
		event.set_object_sequence_rotation(1, 0.0, -1.65, 0.0)
		event.set_object_sequence_position(2, -95.84, 1160.0, 5822.44)
		event.set_object_sequence_rotation(2, 0.0, 1.11, 0.0)
		event.set_camera_sequence_position(-43.6, 1261.21, 5957.35)
		event.set_camera_sequence_look_at(-64.76, 1175.56, 5833.21)
		event.set_object_sequence_motion(2, "会話２（手腰に）", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080060)
		object.wait_until_done(2)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(5080070)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(5080075)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち")
		event.rotate_object_sequence(2, 0.0, 2.79, 0.0, 12)
		event.move_object_sequence(2, -85.83, 1160.0, 5772.54, 60)
		object.wait_until_done(2)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080080)
		event.set_camera_sequence_position(-54.61, 1199.22, 5675.45)
		event.set_camera_sequence_look_at(-68.38, 1175.56, 5850.15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		event.rotate_object_sequence(1, 0.0, -2.97, 0.0, 12)
		event.move_object_sequence(1, -55.34, 1160.0, 5775.54, 90)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "立ち→グイ見る", 6)
		event.queue_object_sequence_next_motion(1, "グイ見るL", 4)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, -2.97, 0.0, 12)
		event.move_object_sequence(0, -35.96, 1160.0, 5773.94, 90)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "前向き～目下")
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(5080090)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目下～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_motion(2, "会話２（手腰に）")
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "立ち")
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080100)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_sequence_motion(1, "直接？！", 6)
		event.queue_object_sequence_next_motion(1, "グイ見るL", 4)
		event.set_object_sequence_motion(0, "直接！？", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		message.show_voiced(5080110)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080120)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "立ち")
		event.set_camera_sequence_position(-1.14, 2507.89, -1061.57)
		event.set_camera_sequence_look_at(-1.4, 2524.83, -894.87)
		event.move_camera_sequence_eased(-1.25, 516.45, -1054.54, -1.36, 518.76, -917.04, 330, 0, 0.7)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced_for_stopping(5080130, 240)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(5080140, 150)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(5080145, 180)
		camera.wait_until_done()
		event.set_camera_sequence_position(-68.79, 1173.91, 5887.0)
		event.set_camera_sequence_look_at(-63.03, 1177.39, 5762.52)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話２（手腰に）")
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "立ち")
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080150)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向く会話", 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "左向くL")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5080160)
		object.wait_until_done(1)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(2, "モニカ見るループ", 4)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "モニカ見る（会話）", 6)
		event.queue_object_sequence_next_motion(2, "モニカ見るループ", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち→グイ見る", 4)
		event.queue_object_sequence_next_motion(1, "グイ見るL", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080170)
		object.wait_until_done(2)
		event.set_object_handle_visible(4, 1)
		event.attach_character_to_frame(35, "b", 36)
		event.set_object_sequence_motion(0, "爆弾ゲット", 4)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(0, -55.61, 1160.0, 5803.78)
		event.set_object_sequence_rotation(0, 0.0, -1.65, 0.0)
		event.set_object_sequence_position(1, -55.51, 1160.0, 5780.57)
		event.set_object_sequence_rotation(1, 0.0, -1.65, 0.0)
		event.set_object_sequence_position(2, -95.43, 1160.0, 5795.54)
		event.set_object_sequence_rotation(2, 0.0, 1.59, 0.0)
		event.set_camera_sequence_position(-49.1, 1184.63, 5789.27)
		event.set_camera_sequence_look_at(-125.19, 1191.35, 5802.1)
		event.play_sound_effect(scene_sound_effect, 3)
		event.set_object_sequence_motion(2, "だす", 6)
		event.queue_object_sequence_next_motion(2, "だすループ", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080180)
		event.stop_sound_effect(scene_sound_effect, 3)
		object.wait_until_done(2)
		event.set_object_handle_visible(1, 0)
		event.detach_character_from_frame(36)
		if active_chr_no == 0 then
			event.attach_character_to_frame(0, "item", 36)
		else
			event.attach_character_to_frame(33, "item", 36)
		end
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_camera_sequence_position(-94.34, 1203.09, 5799.78)
		event.set_camera_sequence_look_at(-54.1, 1186.29, 5805.08)
		event.pause_music()
		event.set_character_active(37)
		event.set_object_handle_visible(5, 1)
		event.set_object_sequence_motion(5, "発動", 6)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, cue_sound_effect, 0)
		event.play_sound_effect(scene_sound_effect, 4)
		inventory.announce_received(372, 1)
		event.wait_object_sequence_motion_end(5)
		object.wait_until_done(5)
		event.play_music(0)
		event.detach_character_from_frame(36)
		event.set_object_handle_visible(1, 1)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(3.92, 1224.43, 5857.27)
		event.set_camera_sequence_look_at(-77.23, 1174.09, 5794.78)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話２（手腰に）", 6)
		event.delay_object_sequence_motion_track(2, 90)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080190)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(5080195)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(5080200)
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "ぐっ", 6)
		event.queue_object_sequence_next_motion(2, "ぐぅ（会話）", 4)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "ぐっループ", 4)
		event.play_sound_effect(scene_sound_effect, 5)
		event.set_object_sequence_texture_animation(2, 1, "口とじ～くいしばり")
		message.show_voiced(5080210)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(48)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.stop_sound_effect(cue_sound_effect, 0)
	event.stop_sound_effect(scene_sound_effect, 3)
	event.stop_sound_effect(scene_sound_effect, 4)
	event.stop_sound_effect(scene_sound_effect, 5)
	event.set_character_active(1, character_slot)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	inventory.resolve_overflow(0)
	event.play_music(0)
	character.place_standing_and_reset_cloth(vm.f32(-1688.6), 1160.0, 5131.0, vm.f32(2.55))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Asks which floor to ride to and returns the chosen floor or -1 when cancelled.
local function ask_elevator_floor()
	local current_floor: s32 = 0
	local selected_floor: any = 0
	local at: number = 0
	return vm.guard(function()
		current_floor = event.get_save_counter(14) or current_floor
		event.set_message_window_mode(1, 4)
		event.open_message_window_2(1, "エレベーターのボタンがある。")
		message.open(1, -1, 5, 0, 0)
		event.set_message_window_mode(0, 4)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.set_message_window_option(0, 1, 1)
		event.set_message_window_option(0, 5, current_floor, 2)
		event.open_message_window_2(0, "１階\n２階\n３階")
		at = 1
		selected_floor = message.ask_choice(0, -1, 8, 0, 0, 3, current_floor)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 1, 0)
		event.set_message_window_option(0, 5, current_floor, -1)
		message.close(1)
		if selected_floor < 0 or selected_floor == current_floor then
			return -1
		else
			event.set_save_counter(14, selected_floor)
			return selected_floor
		end
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				selected_floor = received[1] :: number
			end
			message.close_skipping(1)
			return -1
		end
		return nil
	end)
end

--- Gives the reward item and plays scene 508 the first time the matching analysis flag is set, returning whether it played.
local function play_scene_508_once()
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		flag = event.get_save_flag(508) or flag
		if georama.is_analysis_flag_403_set() ~= 0 and flag == 0 then
			event.add_inventory_item(372, 1)
			at = 2
			play_scene_508()
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				play_scene_508()
				return vm.continue_with(function()
					return 1
				end)
			end
			local _ = georama.is_placeholder_condition_met()
			return 1
		end
		return nil
	end)
end

--- Offers the jump gate destinations, plays the warp effect and moves the player to the chosen one.
local function use_jump_gate(current_gate: s32)
	local has_bridge_destination: s32 = 0
	local destination_count: s32 = 0
	local choice: any = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local sound_id: s32 = 0
	has_bridge_destination = georama.is_analysis_flag_410_set()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 4)
	event.set_message_selection_top_line(0, 1)
	event.set_message_window_option(0, 0, 1)
	event.set_message_window_option(0, 1, 1)
	if has_bridge_destination ~= 0 then
		event.open_message_window_2(
			0,
			"転送ゲートの行き先を選択\n転送ゲート・北\n転送ゲート・東\n転送ゲート・西\nタイムゲート前\nパズノス・ブリッジ"
		)
		destination_count = 5
	else
		event.open_message_window_2(
			0,
			"転送ゲートの行き先を選択\n転送ゲート・北\n転送ゲート・東\n転送ゲート・西\nタイムゲート前"
		)
		destination_count = 4
	end
	choice = message.ask_choice(0, -1, 8, 0, 0, destination_count, vm.i32(current_gate + 1))
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 1, 0)
	if choice == -1 then
		return
	end
	if vm.wrap(choice - 1) == current_gate then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_effect_first_vector(position_x, position_y, position_z)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 120)
	wait.for_frame_count(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait.for_frame_count(30)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	if vm.wrap(choice - 1) == 1 then
		character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
	end
	if vm.wrap(choice - 1) == 2 then
		character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
	end
	if vm.wrap(choice - 1) == 3 then
		character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
	end
	if vm.wrap(choice - 1) == 0 then
		character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
	end
	if vm.wrap(choice - 1) == 4 then
		event.jump_to_map_2(-1, "s30")
		vm.wait(5)
		return
	end
	event.reset_follow_camera(1, 3.1415927)
	event.fade_in_screen(15)
end

--- Asks to move to Paznos Bridge and, when accepted, plays the warp effect and jumps to map s30.
local function ask_move_to_paznos_bridge()
	local choice: any = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.open_message_window_2(0, "パズノス・ブリッジへ移動しますか？")
	choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
	if choice ~= 0 then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_effect_first_vector(position_x, position_y, position_z)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 120)
	wait.for_frame_count(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait.for_frame_count(30)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	event.jump_to_map_2(-1, "s30")
	vm.wait(5)
end

--- Plays the jet launch scene with the jets rising and the camera shaking until the screen fades out.
local function play_jet_launch_scene()
	local frame_count: s32 = 0
	local amplitude_2: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait.for_frame_count(4)
		event.load_music(116)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e540/")
		event.load_character(5, "e540_jet.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.copy_character(5, 32, 33)
		event.set_character_active(0, 33)
		event.load_character(5, "e540_parm1.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.load_character(5, "e540_parm2.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "e540_parm3.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.load_character(5, "e540_parm4.gltf", "info", 37)
		event.set_character_active(1, 37)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(0, "p10_f0401")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p20_f0401")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_27-m-0")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_27-m-1")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_3(1, "p22_f0401", "f0401_25-m")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm1")
		event.set_character_position(34, -2400.0, 1700.0, 2600.0)
		event.set_character_rotation(34, 0.0, 1.6, 0.0)
		event.set_character_motion(34, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm2")
		event.set_character_position(35, -2100.0, 1700.0, 5300.0)
		event.set_character_rotation(35, 0.0, 2.4, 0.0)
		event.set_character_motion(35, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm3")
		event.set_character_position(36, 2200.0, 1700.0, 5300.0)
		event.set_character_rotation(36, 0.0, -2.4, 0.0)
		event.set_character_motion(36, "射出1", 5)
		event.attach_object_handle_to_map_part_2(1, "p22_f0401")
		event.get_object_handle_frame_position(1, "e540_parm4")
		event.set_character_position(37, 2400.0, 1700.0, 2600.0)
		event.set_character_rotation(37, 0.0, -1.6, 0.0)
		event.set_character_motion(37, "射出1", 5)
		event.set_character_position(32, -930.0, 750.0, 2330.0)
		event.set_character_position(33, 930.0, 750.0, 2330.0)
		event.enable_drama_skip()
		event.set_event_projection(524.9)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 2449.87, -2065.79)
		event.set_camera_sequence_look_at(0.0, 2430.55, -2020.14)
		event.move_camera_sequence_eased(0.0, 2785.4, -2065.79, 0.0, 2787.08, -2020.14, 120, 2, 1.0)
		event.fade_in_screen(10)
		at = 2
		camera.wait_until_done()
		event.set_camera_sequence_position(-2108.31, 1992.04, 1136.27)
		event.set_camera_sequence_look_at(-2039.71, 1945.46, 1320.75)
		at = 3
		wait.for_frame_count(4)
		event.set_character_motion(34, "射出1", 6)
		at = 4
		wait.for_frame_count(10)
		event.set_character_motion(35, "射出1", 6)
		at = 5
		wait.for_frame_count(30)
		event.set_camera_sequence_position(1955.54, 2093.16, 785.71)
		event.set_camera_sequence_look_at(1839.34, 1936.52, 1240.3)
		at = 6
		wait.for_frame_count(4)
		event.set_character_motion(37, "射出1", 6)
		at = 7
		wait.for_frame_count(10)
		event.set_character_motion(36, "射出1", 6)
		at = 8
		wait.for_frame_count(30)
		event.set_camera_sequence_position(1709.28, 50.66, -919.25)
		event.set_camera_sequence_look_at(1370.18, 511.19, 109.87)
		event.set_event_projection(390.0)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_visible(32, 1, 1, 0.016666668)
		event.set_character_visible(33, 1, 1, 0.016666668)
		frame_count = 0
		amplitude_2 = vm.f32(0.02)
		while frame_count < 120 do
			frame_count = frame_count + 1
			at = 9
			vm.wait(9)
			if vm.imod(frame_count, 4) == 0 then
				event.clear_camera_sequence()
				event.shake_camera_sequence(0.0, amplitude_2, 0.0, -1)
				amplitude_2 = vm.f32(amplitude_2 * vm.f32(1.2))
			end
			if frame_count == 110 then
				event.fade_out_screen(10)
			end
		end
		at = 10
		wait.for_frame_count(2)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.background_load_skipping()
		end
		if at <= 2 then
			wait.skip_frame_count(4)
		end
		if at <= 3 then
			wait.skip_frame_count(10)
		end
		if at <= 4 then
			wait.skip_frame_count(30)
		end
		if at <= 5 then
			wait.skip_frame_count(4)
		end
		if at <= 6 then
			wait.skip_frame_count(10)
		end
		if at <= 7 then
			wait.skip_frame_count(30)
		end
		if at <= 8 then
			frame_count = 0
			amplitude_2 = vm.f32(0.02)
			local _ = frame_count < 120
			frame_count = frame_count + 1
		end
		if at <= 9 then
			amplitude_2 = vm.f32(amplitude_2 * vm.f32(1.2))
			wait.skip_frame_count(2)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_character_active(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
end

--- Plays the jet flyover scene with the jets and the lift part rising away while the camera shakes.
local function play_jet_flyover_scene()
	vm.section(function()
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e540/")
		event.load_character(5, "e540_jet.gltf", "info", 32)
		event.set_character_active(32)
		event.set_scene_character_type(32, 4)
		event.attach_object_handle_to_character(3, 32)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.copy_character(5, 32, 33)
		event.set_character_active(33)
		event.set_scene_character_type(33, 4)
		event.attach_object_handle_to_character(4, 33)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(0, "p10_f0401")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p20_f0401")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p11_f0401")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(2, "p22_f0401")
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_position(0, 0.0, 0.0, 3300.0)
		event.set_object_handle_position(3, -930.0, 750.0, 2330.0)
		event.set_object_handle_position(4, 930.0, 750.0, 2330.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1276.52, 7391.95, 1416.71)
		event.set_camera_sequence_look_at(1173.37, 7042.65, 1560.26)
		event.shake_camera_sequence(0.0, 3.0, 0.0, -1)
		event.fade_in_screen(10)
		wait.for_frame_count(10)
		event.move_object_sequence_eased(0, 0.0, 9000.0, 3300.0, 160, 1, 1.0)
		event.move_object_sequence_eased(3, -930.0, 9750.0, 2330.0, 160, 1, 1.0)
		event.move_object_sequence_eased(4, 930.0, 9750.0, 2330.0, 160, 1, 1.0)
		object.wait_until_done(0)
		event.fade_out_screen(10)
		wait.for_frame_count(10)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.delete_character(32)
	event.delete_character(33)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.hide_analysis_part_and_update_characters = hide_analysis_part_and_update_characters
script[99] = script.hide_analysis_part_and_update_characters

--- Runs the pending Gundorada scenes on entry and places the player according to the map they came from.
function script.default_event()
	local previous_map_number: s32 = 0
	local return_gate_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		previous_map_number = event.get_previous_map() or previous_map_number
		event.fade_in_screen(15)
		if previous_map_number == 3 then
			event.set_save_counter(14, 0)
		end
		hide_analysis_part_and_update_characters()
		gundorada.align_lift_parts_to_floor()
		if georama.can_start_event_548() ~= 0 then
			at = 1
			play_scene_548()
		end
		if georama.can_start_event_552() ~= 0 then
			at = 2
			play_scene_552()
		end
		if georama.can_start_event_556() ~= 0 then
			at = 3
			play_scene_556()
		end
		if previous_map_number == 3 then
			character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
		end
		if previous_map_number == 105 then
			return_gate_index = event.get_save_counter(18) or return_gate_index
			event.set_save_counter(14, 0)
			gundorada.align_lift_parts_to_floor()
			if return_gate_index == 1 then
				character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			end
			if return_gate_index == 2 then
				character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			end
			if return_gate_index == 3 then
				character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			end
			if return_gate_index == 0 then
				character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			end
		end
		if previous_map_number == 107 then
			event.set_save_counter(14, 2)
			gundorada.align_lift_parts_to_floor()
			character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
		end
		event.reset_follow_camera(1, 0.0, 10.0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				local _ = georama.can_start_placeholder_event_a()
				at = 2
				play_scene_552()
				return vm.continue_with(function()
					if georama.can_start_event_556() ~= 0 then
						at = 3
						play_scene_556()
					end
					if previous_map_number == 3 then
						character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
					end
					if previous_map_number == 105 then
						return_gate_index = event.get_save_counter(18) or return_gate_index
						event.set_save_counter(14, 0)
						gundorada.align_lift_parts_to_floor()
						if return_gate_index == 1 then
							character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
						end
						if return_gate_index == 2 then
							character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
						end
						if return_gate_index == 3 then
							character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
						end
						if return_gate_index == 0 then
							character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
						end
					end
					if previous_map_number == 107 then
						event.set_save_counter(14, 2)
						gundorada.align_lift_parts_to_floor()
						character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
					end
					event.reset_follow_camera(1, 0.0, 10.0)
					return
				end)
			end
			if at <= 2 then
				local _ = georama.can_start_placeholder_event_a()
				at = 3
				play_scene_556()
				return vm.continue_with(function()
					if previous_map_number == 3 then
						character.place_standing_and_reset_cloth(0.0, 0.0, 0.0, 0.0)
					end
					if previous_map_number == 105 then
						return_gate_index = event.get_save_counter(18) or return_gate_index
						event.set_save_counter(14, 0)
						gundorada.align_lift_parts_to_floor()
						if return_gate_index == 1 then
							character.place_standing_and_reset_cloth(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
						end
						if return_gate_index == 2 then
							character.place_standing_and_reset_cloth(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
						end
						if return_gate_index == 3 then
							character.place_standing_and_reset_cloth(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
						end
						if return_gate_index == 0 then
							character.place_standing_and_reset_cloth(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
						end
					end
					if previous_map_number == 107 then
						event.set_save_counter(14, 2)
						gundorada.align_lift_parts_to_floor()
						character.place_standing_and_reset_cloth(0.0, 2460.0, 6000.0, vm.f32(3.14))
					end
					event.reset_follow_camera(1, 0.0, 10.0)
					return
				end)
			end
			local _ = georama.can_start_placeholder_event_a()
			cutscene.ignore_coordinates(0.0, 0.0, 0.0, 0.0)
			gundorada.do_nothing()
			cutscene.ignore_coordinates(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			cutscene.ignore_coordinates(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			cutscene.ignore_coordinates(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			cutscene.ignore_coordinates(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			gundorada.do_nothing()
			cutscene.ignore_coordinates(0.0, 2460.0, 6000.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_scene_548

--- Event 151, which map data, a script or the engine runs by number.
script.play_scene_508 = play_scene_508
script[151] = script.play_scene_508

--- Warps through the time gate and jumps to map g04.
function script.enter_time_gate()
	cutscene.play_time_gate_warp(0.0, 0.0, 0.0, vm.f32(6.2831855))
	event.jump_to_map_2(-1, "g04")
	vm.wait(2)
end
script[300] = script.enter_time_gate

--- Asks for an elevator floor and places the player on that floor of the first elevator.
function script.ride_elevator_a()
	local sound_id: s32 = 0
	local floor: any = 0
	local at: number = 0
	local played_bomb_gift_scene: s32 = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		sound_id = event.get_sound_id(2) or sound_id
		at = 1
		floor = ask_elevator_floor()
		if floor >= 0 then
			event.play_sound_effect(sound_id, 70)
			event.fade_out_screen(10)
			at = 2
			wait.for_frame_count(10)
			if floor == 0 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
			end
			if floor == 1 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
				at = 3
				if play_scene_508_once() ~= 0 then
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end
			end
			if floor == 2 then
				character.place_standing_and_reset_cloth(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
			end
			event.play_sound_effect(sound_id, 71)
			gundorada.align_lift_parts_to_floor()
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(10)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				floor = received[1] :: number
			end
			if at == 3 then
				played_bomb_gift_scene = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(10)
			end
			if at <= 2 then
				cutscene.ignore_coordinates(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
				cutscene.ignore_coordinates(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
				at = 3
				played_bomb_gift_scene = play_scene_508_once()
				return vm.continue_with(function()
					if played_bomb_gift_scene ~= 0 then
						gundorada.align_lift_parts_to_floor()
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(10)
						return
					end
					if floor == 2 then
						character.place_standing_and_reset_cloth(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
					end
					event.play_sound_effect(sound_id, 71)
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end)
			end
			gundorada.do_nothing()
			return 0
		end
		return nil
	end)
end
script[550] = script.ride_elevator_a

--- Asks for an elevator floor and places the player on that floor of the second elevator.
function script.ride_elevator_b()
	local sound_id: s32 = 0
	local floor: any = 0
	local at: number = 0
	local played_bomb_gift_scene: s32 = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		sound_id = event.get_sound_id(2) or sound_id
		at = 1
		floor = ask_elevator_floor()
		if floor >= 0 then
			event.play_sound_effect(sound_id, 70)
			event.fade_out_screen(10)
			at = 2
			wait.for_frame_count(10)
			if floor == 0 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
			end
			if floor == 1 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
				at = 3
				if play_scene_508_once() ~= 0 then
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end
			end
			if floor == 2 then
				character.place_standing_and_reset_cloth(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
			end
			event.play_sound_effect(sound_id, 71)
			gundorada.align_lift_parts_to_floor()
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(10)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				floor = received[1] :: number
			end
			if at == 3 then
				played_bomb_gift_scene = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(10)
			end
			if at <= 2 then
				cutscene.ignore_coordinates(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
				cutscene.ignore_coordinates(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
				at = 3
				played_bomb_gift_scene = play_scene_508_once()
				return vm.continue_with(function()
					if played_bomb_gift_scene ~= 0 then
						gundorada.align_lift_parts_to_floor()
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(10)
						return
					end
					if floor == 2 then
						character.place_standing_and_reset_cloth(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
					end
					event.play_sound_effect(sound_id, 71)
					gundorada.align_lift_parts_to_floor()
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(10)
					return
				end)
			end
			gundorada.do_nothing()
			return 0
		end
		return nil
	end)
end
script[551] = script.ride_elevator_b

--- Fades out and jumps to map s39.
function script.leave_to_s39()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.jump_to_map_2(-1, "s39")
	vm.wait(2)
end
script[552] = script.leave_to_s39

--- Opens the jump gate menu from gate 1.
function script.use_jump_gate_1()
	use_jump_gate(1)
end
script[560] = script.use_jump_gate_1

--- Opens the jump gate menu from gate 3.
function script.use_jump_gate_3()
	use_jump_gate(3)
end
script[561] = script.use_jump_gate_3

--- Sets counter 13 to 2 and asks to move to Paznos Bridge.
function script.use_paznos_gate_2()
	event.set_save_counter(13, 2)
	ask_move_to_paznos_bridge()
end
script[562] = script.use_paznos_gate_2

--- Sets counter 13 to 3 and asks to move to Paznos Bridge.
function script.use_paznos_gate_3()
	event.set_save_counter(13, 3)
	ask_move_to_paznos_bridge()
end
script[563] = script.use_paznos_gate_3

--- Sets counter 13 to 4 and asks to move to Paznos Bridge.
function script.use_paznos_gate_4()
	event.set_save_counter(13, 4)
	ask_move_to_paznos_bridge()
end
script[564] = script.use_paznos_gate_4

--- Sets counter 13 to 5 and asks to move to Paznos Bridge.
function script.use_paznos_gate_5()
	event.set_save_counter(13, 5)
	ask_move_to_paznos_bridge()
end
script[565] = script.use_paznos_gate_5

--- Opens the jump gate menu from gate 2.
function script.use_jump_gate_2()
	use_jump_gate(2)
end
script[566] = script.use_jump_gate_2

--- Opens the jump gate menu from gate 0.
function script.use_jump_gate_0()
	use_jump_gate(0)
end
script[567] = script.use_jump_gate_0

--- Plays the jet launch scene and jumps to map s30.
function script.launch_jet_to_s30()
	play_jet_launch_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s30", 600)
end
script[600] = script.launch_jet_to_s30

--- Plays the jet flyover scene and jumps to map s55.
function script.fly_jet_to_s55()
	play_jet_flyover_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 600)
end
script[601] = script.fly_jet_to_s55

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = message.talk_to_gundorada_villager

--- Resets the georama analysis flags and jumps to map 102 for event 151.
function script.reset_analysis_for_scene_508()
	event.set_georama_analyze_flag(3, 3, 0)
	event.set_georama_analyze_flag(3, 4, 0)
	event.set_georama_analyze_flag(3, 5, 0)
	event.set_georama_analyze_flag(3, 6, 0)
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_save_flag(508, 0)
	event.jump_to_map_3(-1, 102, 151)
	vm.wait(1)
end
script[15080] = script.reset_analysis_for_scene_508

--- Sets the story flags, clears the party member and warps through the time gate to map g04.
function script.warp_to_g04_after_flag_change()
	event.set_save_flag(520, 1)
	event.set_save_flag(522, 0)
	event.set_party_member(1, 0)
	cutscene.play_time_gate_warp(0.0, 0.0, 0.0, vm.f32(6.2831855))
	event.jump_to_map_2(-1, "g04")
	vm.wait(2)
end
script[15220] = script.warp_to_g04_after_flag_change

--- Resets the analysis flags, plays scene 548 and jumps to map 102.
function script.reset_analysis_and_play_scene_548_then_jump()
	event.set_georama_analyze_flag(3, 3, 0)
	event.set_georama_analyze_flag(3, 4, 0)
	event.set_georama_analyze_flag(3, 5, 0)
	event.set_georama_analyze_flag(3, 6, 0)
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_save_flag(548, 0)
	event.set_save_flag(552, 1)
	event.set_save_flag(556, 1)
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(1)
end
script[15480] = script.reset_analysis_and_play_scene_548_then_jump

--- Sets the analysis flags for scene 552 and jumps to map 102.
function script.set_analysis_for_scene_552()
	event.set_georama_analyze_flag(3, 7, 0)
	event.set_georama_analyze_flag(3, 8, 0)
	event.set_georama_analyze_flag(3, 9, 0)
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_georama_analyze_flag(3, 3, 1)
	event.set_georama_analyze_flag(3, 4, 1)
	event.set_georama_analyze_flag(3, 5, 1)
	event.set_georama_analyze_flag(3, 6, 1)
	event.set_save_flag(548, 1)
	event.set_save_flag(552, 0)
	event.set_save_flag(556, 1)
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(1)
end
script[15520] = script.set_analysis_for_scene_552

--- Sets the analysis flags for scene 556 and jumps to map 102.
function script.set_analysis_for_scene_556()
	event.set_georama_analyze_flag(3, 0, 1)
	event.set_georama_analyze_flag(3, 1, 1)
	event.set_georama_analyze_flag(3, 2, 1)
	event.set_georama_analyze_flag(3, 3, 1)
	event.set_georama_analyze_flag(3, 4, 1)
	event.set_georama_analyze_flag(3, 5, 1)
	event.set_georama_analyze_flag(3, 6, 1)
	event.set_georama_analyze_flag(3, 7, 1)
	event.set_georama_analyze_flag(3, 8, 1)
	event.set_georama_analyze_flag(3, 9, 1)
	event.set_georama_analyze_flag(3, 10, 1)
	event.set_save_flag(548, 1)
	event.set_save_flag(552, 1)
	event.set_save_flag(556, 0)
	event.jump_to_map_3(-1, 102, 100)
	vm.wait(1)
end
script[15560] = script.set_analysis_for_scene_556

return script
