--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d83f2336()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_camera_position(846.73, 268.48, 883.94)
		event.set_camera_look_at(1289.42, 146.71, 951.29)
		event.set_save_flag(438, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(32)
		event.load_map_sounds(4217)
		var0 = event.load_sound_effect_file_2(4217) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e438/")
		event.load_message_file(0, 5, "e438_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e438_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e438_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e438_paw.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e438_shigu.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_2(4, "p01_battleship")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e438/e438_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e438/e438_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 1580.54, 0.0, 1092.15)
		event.set_object_handle_rotation(0, 0.0, -2.52, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 1501.84, 0.0, 1069.09)
		event.set_object_handle_rotation(1, 0.0, -2.52, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 1577.67, 0.0, 1206.39)
		event.set_object_handle_rotation(2, 0.0, -2.52, 0.0)
		event.set_object_handle_footstep_sound(2, 14)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_position(3, 1651.38, 0.0, 1262.95)
		event.set_object_handle_rotation(3, 0.0, -2.52, 0.0)
		event.set_object_handle_sound_bank(3, var0)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "通常目パチ")
		event.set_object_handle_position(4, 1400.0, 2000.0, 900.0)
		event.set_object_handle_rotation(4, 0.0, -2.52, 0.0)
		event.set_object_handle_scale(4, 1.0, 1.0, 1.0)
		event.move_object_sequence(0, 1416.17, 0.0, 936.56, 46)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 1401.25, 0.0, 947.01, 36)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 36)
		event.set_object_sequence_motion(1, "立ち")
		var2 = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
		var3 = 2000.0
		var4 = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
		event.enable_drama_skip()
		event.play_sound_effect(var0, 11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(846.73, 268.48, 883.94)
		event.set_camera_sequence_look_at(1289.42, 146.71, 951.29)
		event.fade_in_screen(30)
		at = 2
		wait_frames(10)
		event.play_sound_effect(var0, 12)
		at = 3
		wait_objects(0)
		at = 4
		wait_objects(1)
		event.set_camera_sequence_position(1446.78, 902.12, 1000.12)
		event.set_camera_sequence_look_at(1342.3, 1004.84, 851.59)
		event.play_music(0)
		event.move_object_sequence(4, var2, var3, var4, 300)
		event.delay_object_sequence_sound_track(4, 260)
		event.call_command(492, 4, var0, 11) -- retail: command 492 is not registered
		event.set_mouth_texture_animations(1, "大口パク")
		at = 5
		helper_1584c528(4380100, 50)
		event.set_camera_sequence_position(1478.85, 26.8, 1037.73)
		event.set_camera_sequence_look_at(1389.49, 33.55, 913.48)
		event.set_object_sequence_scale(4, 0.0, 0.0, 0.0, 250)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_4116e6bb(4380110)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 7
		helper_4116e6bb(4380120)
		at = 8
		wait_objects(1)
		at = 9
		wait_objects(0)
		event.set_object_sequence_motion(0, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		at = 10
		wait_objects(0)
		event.set_camera_sequence_position(1395.3, 38.89, 921.11)
		event.set_camera_sequence_look_at(1525.4, 51.33, 1091.97)
		event.set_character_active(34)
		event.set_character_active(35)
		event.move_object_sequence(2, 1478.76, 0.0, 1074.97, 50)
		event.set_object_sequence_motion(2, "走り", 4)
		event.delay_object_sequence_motion_track(2, 50)
		event.set_object_sequence_motion(2, "立ち")
		event.move_object_sequence(3, 1556.2, 0.0, 1136.48, 80)
		event.set_object_sequence_motion(3, "歩き", 4)
		event.delay_object_sequence_motion_track(3, 80)
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_motion(0, "立ち", 6)
		event.set_object_sequence_motion(1, "立ち", 6)
		at = 11
		helper_4116e6bb(4380130)
		at = 12
		wait_objects(3)
		event.set_camera_sequence_position(1358.73, 17.36, 907.69)
		event.set_camera_sequence_look_at(1478.91, 37.71, 1028.52)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 13
		helper_4116e6bb(4380140)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "こまり目パチ")
		event.set_object_sequence_motion(2, "ちょっとまって", 2)
		event.queue_object_sequence_next_motion(2, "ちょっとまってL", 4)
		at = 14
		helper_4116e6bb(4380150)
		at = 15
		wait_objects(2)
		event.set_camera_sequence_position(1416.31, 11.25, 988.08)
		event.set_camera_sequence_look_at(1408.14, 20.76, 940.82)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(1, "振り返り静止", 6)
		event.queue_object_sequence_next_motion(1, "振り返り静止L", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 16
		helper_4116e6bb(4380160)
		at = 17
		wait_objects(1)
		event.set_camera_sequence_position(1358.73, 17.36, 907.69)
		event.set_camera_sequence_look_at(1478.91, 37.71, 1028.52)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "ちょっとまって戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 18
		helper_4116e6bb(4380170)
		event.set_camera_sequence_position(1416.31, 11.25, 988.08)
		event.set_camera_sequence_look_at(1408.14, 20.76, 940.82)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		helper_4116e6bb(4380180)
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(1, "戻り", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 20
		helper_4116e6bb(4380190)
		event.fade_out_screen(30)
		at = 21
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var2 = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
			var3 = 2000.0
			var4 = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
			wait_frames_skipping(10)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_52aadc70(4380100, 50)
		end
		if at <= 5 then
			helper_8cd371d7(4380110)
		end
		if at <= 6 then
			helper_8cd371d7(4380120)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_8cd371d7(4380130)
		end
		if at <= 11 then
			helper_238b5abc(3)
		end
		if at <= 12 then
			helper_8cd371d7(4380140)
		end
		if at <= 13 then
			helper_8cd371d7(4380150)
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			helper_8cd371d7(4380160)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_8cd371d7(4380170)
		end
		if at <= 18 then
			helper_8cd371d7(4380180)
		end
		if at <= 19 then
			helper_8cd371d7(4380190)
		end
		if at <= 20 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 11)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

return helper_d83f2336
