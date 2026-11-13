--!strict
--- Event scenes of the Veniccio demo maps in which the battleship appears.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local veniccio_demo = {}

--- Plays the dialogue scene in which the battleship swoops over the party and two companions run up to meet them.
function veniccio_demo.play_battleship_arrival_scene()
	local sound_bank: s32 = 0
	local player_character: s32 = 0
	local ship_target_x: f32 = 0
	local ship_target_y: f32 = 0
	local ship_target_z: f32 = 0
	local progress: number = 0
	vm.section(function()
		event.set_camera_position(846.73, 268.48, 883.94)
		event.set_camera_look_at(1289.42, 146.71, 951.29)
		event.set_save_flag(438, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		progress = 1
		wait.frames(4)
		event.load_music(32)
		event.load_map_sounds(4217)
		sound_bank = event.load_sound_effect_file_2(4217) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		player_character = event.get_playable_character() or player_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e438/")
		event.load_message_file(0, 5, "e438_1.txt")
		if player_character == 0 then
			event.load_character_motion_pack(5, "e438_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if player_character == 1 then
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
		if player_character == 1 then
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
		event.set_object_handle_sound_bank(3, sound_bank)
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
		ship_target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
		ship_target_y = 2000.0
		ship_target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(846.73, 268.48, 883.94)
		event.set_camera_sequence_look_at(1289.42, 146.71, 951.29)
		event.fade_in_screen(30)
		progress = 2
		wait.frames(10)
		event.play_sound_effect(sound_bank, 12)
		progress = 3
		object.wait_until_done(0)
		progress = 4
		object.wait_until_done(1)
		event.set_camera_sequence_position(1446.78, 902.12, 1000.12)
		event.set_camera_sequence_look_at(1342.3, 1004.84, 851.59)
		event.play_music(0)
		event.move_object_sequence(4, ship_target_x, ship_target_y, ship_target_z, 300)
		event.delay_object_sequence_sound_track(4, 260)
		event.call_command(492, 4, sound_bank, 11) -- retail: command 492 is not registered
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 5
		message.show_voiced_for(4380100, 50)
		event.set_camera_sequence_position(1478.85, 26.8, 1037.73)
		event.set_camera_sequence_look_at(1389.49, 33.55, 913.48)
		event.set_object_sequence_scale(4, 0.0, 0.0, 0.0, 250)
		event.set_mouth_texture_animations(0, "通常口パク")
		progress = 6
		message.show_voiced(4380110)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 7
		message.show_voiced(4380120)
		progress = 8
		object.wait_until_done(1)
		progress = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		progress = 10
		object.wait_until_done(0)
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
		progress = 11
		message.show_voiced(4380130)
		progress = 12
		object.wait_until_done(3)
		event.set_camera_sequence_position(1358.73, 17.36, 907.69)
		event.set_camera_sequence_look_at(1478.91, 37.71, 1028.52)
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 13
		message.show_voiced(4380140)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "こまり目パチ")
		event.set_object_sequence_motion(2, "ちょっとまって", 2)
		event.queue_object_sequence_next_motion(2, "ちょっとまってL", 4)
		progress = 14
		message.show_voiced(4380150)
		progress = 15
		object.wait_until_done(2)
		event.set_camera_sequence_position(1416.31, 11.25, 988.08)
		event.set_camera_sequence_look_at(1408.14, 20.76, 940.82)
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(1, "振り返り静止", 6)
		event.queue_object_sequence_next_motion(1, "振り返り静止L", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 16
		message.show_voiced(4380160)
		progress = 17
		object.wait_until_done(1)
		event.set_camera_sequence_position(1358.73, 17.36, 907.69)
		event.set_camera_sequence_look_at(1478.91, 37.71, 1028.52)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "ちょっとまって戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		progress = 18
		message.show_voiced(4380170)
		event.set_camera_sequence_position(1416.31, 11.25, 988.08)
		event.set_camera_sequence_look_at(1408.14, 20.76, 940.82)
		event.set_mouth_texture_animations(0, "通常口パク")
		progress = 19
		message.show_voiced(4380180)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_sequence_motion(1, "戻り", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		progress = 20
		message.show_voiced(4380190)
		event.fade_out_screen(30)
		progress = 21
		wait.frames(30)
	end, function(received: { any }): boolean
		if progress <= 1 then
			ship_target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
			ship_target_y = 2000.0
			ship_target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
			wait.frames_skipping(10)
		end
		if progress <= 2 then
			cutscene.skip_command(0)
		end
		if progress <= 3 then
			cutscene.skip_command(1)
		end
		if progress <= 4 then
			message.show_voiced_for_skipping(4380100, 50)
		end
		if progress <= 5 then
			message.show_voiced_skipping(4380110)
		end
		if progress <= 6 then
			message.show_voiced_skipping(4380120)
		end
		if progress <= 7 then
			cutscene.skip_command(1)
		end
		if progress <= 8 then
			cutscene.skip_command(0)
		end
		if progress <= 9 then
			cutscene.skip_command(0)
		end
		if progress <= 10 then
			message.show_voiced_skipping(4380130)
		end
		if progress <= 11 then
			cutscene.skip_command(3)
		end
		if progress <= 12 then
			message.show_voiced_skipping(4380140)
		end
		if progress <= 13 then
			message.show_voiced_skipping(4380150)
		end
		if progress <= 14 then
			cutscene.skip_command(2)
		end
		if progress <= 15 then
			message.show_voiced_skipping(4380160)
		end
		if progress <= 16 then
			cutscene.skip_command(1)
		end
		if progress <= 17 then
			message.show_voiced_skipping(4380170)
		end
		if progress <= 18 then
			message.show_voiced_skipping(4380180)
		end
		if progress <= 19 then
			message.show_voiced_skipping(4380190)
		end
		if progress <= 20 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 11)
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

--- Plays the night scene in which the party looks up at the battleship from the ground.
function veniccio_demo.play_night_battleship_sighting()
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local facing_angle: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_end_y: f32 = 0
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	character_x = vm.f32(1707.99)
	character_y = vm.f32(-8.19)
	character_z = vm.f32(-424.51)
	facing_angle = vm.f32(-2.3561945)
	event.set_character_motion(0, "立ち")
	event.load_character_motion_pack(5, "event/e400/e438/e438_mints.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, character_x, character_y, character_z)
	event.set_object_sequence_rotation(0, 0.0, facing_angle, 0.0)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.load_character_motion_pack(5, "event/e400/e438/e438_monica.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, vm.f32(character_x - 10.0) + 10.0, -5.03, vm.f32(character_z + 10.0) + 10.0)
	event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
	event.set_object_sequence_motion(1, "上見立ち", 4)
	event.reset_object_handle_dynamic_animation(1)
	event.load_character(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.set_character_active(14)
	event.attach_object_handle_to_character(6, 14)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_position(6, vm.f32(character_x + 10.0) + 10.0, -6.28, vm.f32(character_z - 10.0) + 10.0)
	event.set_object_sequence_rotation(6, 0.0, -2.12, 0.0)
	event.set_object_sequence_motion(6, "見上げるL", 4)
	event.attach_object_handle_to_map_part_2(2, "p01_battleship")
	event.set_object_handle_visible(2, 0)
	camera_x = vm.f32(1682.18)
	camera_y = vm.f32(29.66)
	camera_z = vm.f32(-487.46)
	target_x = vm.f32(1712.17)
	target_y = vm.f32(13.54)
	target_z = vm.f32(-420.33)
	target_end_y = vm.f32(19.26)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(camera_x, camera_y, camera_z)
	event.set_camera_sequence_look_at(target_x, target_y, target_z)
	wait.frames(60)
	event.move_camera_sequence_look_at(target_x, target_end_y, target_z, 210)
	event.move_camera_sequence_angle_height_distance(1.47, -10.82, 76.77, 210)
	wait.frames(210)
	wait.frames(150)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.delete_character(14)
	event.set_object_handle_visible(2, 1)
	event.finish_event()
end

--- Plays the noon scene in which the battleship flies across the sky above the running party.
function veniccio_demo.play_noon_battleship_flyover()
	local start_x: f32 = 0
	local end_x: f32 = 0
	local start_z: f32 = 0
	local end_z: f32 = 0
	local ship_x: f32 = 0
	local ship_y: f32 = 0
	local ship_z: f32 = 0
	local ship_pitch: f32 = 0
	local ship_roll: f32 = 0
	local frame: s32 = 0
	event.set_time_of_day(12.0)
	event.set_time_of_day_advancing(0)
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 663.45, 0.0, 1290.77)
	event.set_object_sequence_rotation(0, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.reset_object_handle_dynamic_animation(1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 699.23, 0.0, 1268.37)
	event.set_object_sequence_rotation(1, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(1, "走り", 4)
	event.load_character(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.set_character_active(14)
	event.attach_object_handle_to_character(6, 14)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_position(6, 699.23, 0.0, 1268.37)
	event.set_object_sequence_rotation(6, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(6, "走り", 4)
	event.attach_object_handle_to_map_part_2(2, "p01_battleship")
	event.get_object_handle_position(2)
	event.set_object_handle_position(2, -6000.0, 1600.0, -8000.0)
	event.set_object_handle_rotation(2, 0.0, 2.3561945, 0.0)
	event.set_camera_sequence_position(575.95, 61.55, 1603.27)
	event.set_camera_sequence_look_at(463.45, 40.0, 1490.77)
	event.move_camera_sequence(950.95, 61.55, 1228.27, 838.45, 40.0, 1115.77, 113)
	event.set_object_sequence_position(0, 463.45, 0.0, 1510.77)
	event.move_object_sequence(0, 1963.45, 0.0, 10.77002, 450)
	event.set_object_sequence_position(1, 483.45, 0.0, 1470.77)
	event.move_object_sequence(1, 1953.45, 0.0, 0.77001953, 450)
	event.set_object_sequence_position(6, 453.45, 0.0, 1500.77)
	event.move_object_sequence(6, 1923.45, 0.0, 30.77002, 450)
	start_x = vm.f32(-2786.55)
	end_x = vm.f32(-786.55005)
	start_z = vm.f32(-1259.23)
	end_z = vm.f32(-3259.23)
	frame = 0
	while frame < 450 do
		if frame == 113 then
			event.move_camera_sequence(2075.95, 6.11, 103.27002, 1963.45, 50.0, -9.22998, 337)
		end
		ship_x = calc.interpolate(start_x, end_x, frame, 450)
		ship_z = calc.interpolate(start_z, end_z, frame, 450)
		if frame < 225 then
			ship_y = calc.interpolate(1400.0, 1000.0, frame, 225)
		else
			ship_y = calc.interpolate(1000.0, 1400.0, frame - 225, 225)
		end
		if frame < 150 then
			ship_pitch = calc.interpolate(-0.25, 0.25, frame, 150)
			ship_roll = 0.0
		else
			ship_pitch = calc.interpolate(0.25, -0.25, frame - 150, 300)
			ship_roll = 0.0
		end
		event.set_object_handle_position(2, ship_x, ship_y, ship_z)
		event.set_object_handle_rotation(2, ship_pitch, 2.3561945, ship_roll)
		frame = frame + 1
		vm.wait(1)
	end
	wait.frames(150)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.delete_character(14)
	event.finish_event()
end

return veniccio_demo
