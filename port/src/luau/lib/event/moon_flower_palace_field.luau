--!strict
--- Event scenes and motion helpers for the Moon Flower Palace field map.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local moon_flower_palace_field = {}

--- Returns the constant per-frame acceleration that covers a distance in a number of frames from a given start velocity.
function moon_flower_palace_field.compute_acceleration(distance: f32, start_velocity: f32, frames: f32)
	return vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(distance - vm.f32(start_velocity * frames)) * 2.0), frames)), frames))
end

--- Asks a yes or no question and, on a yes, walks the player character forward while the camera tracks them, returning 1 when declined.
function moon_flower_palace_field.confirm_and_walk_forward()
	local choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		checkpoint = 1
		choice = message.ask_yes_no(7, 97)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if choice == 0 then
			event.fade_out_screen(30)
			checkpoint = 2
			wait.frames(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + x)
			target_y = y
			target_z = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				checkpoint = 3
				vm.wait(3)
			end
		end
		return 0
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if checkpoint <= 3 then
			return 0
		end
		return nil
	end)
end

--- Plays event 372, a camera sweep with narration that may switch the music first.
function moon_flower_palace_field.play_e372_cutscene()
	local music_change_flag: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_message_file(0, 5, "event/e300/e372/e372_1.txt")
		music_change_flag = event.get_save_flag(43) or music_change_flag
		if music_change_flag ~= 0 then
			event.stop_music(0)
			wait.frames(4)
			event.load_music(59)
			event.play_music(0)
			event.set_save_flag(43, 0)
		end
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.start_crossfade(0, 0, 90)
		event.set_camera_sequence_position(-178.53, 128.12, 2185.49)
		event.set_camera_sequence_look_at(-546.76, 268.24, 1697.27)
		event.set_object_sequence_position(0, -546.76, 268.24, 1697.27)
		event.keep_character_in_front_of_camera_sequence(32, 608.78, 99999999)
		event.move_camera_sequence_eased(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
		message.show_voiced(3720190)
		message.show_voiced(3720200)
		message.show_voiced(3720210)
		message.show_voiced(3720220)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(32)
end

--- Plays event 604, in which the party walks in and talks before the screen fades out.
function moon_flower_palace_field.play_e604_cutscene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(604, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(51)
		event.play_music(0)
		event.load_map_sounds(7803)
		sound_bank = event.load_sound_effect_file_2(7803) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e600/e604/")
		event.load_message_file(0, 5, "e604_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e604_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e604_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e604/e604_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e600/e604/e604_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.attach_object_handle_to_map_part_3(2, "p01_s3302-0", "s330208-m0")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_s3302-0", "s330208-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_handle_position(0, 14.06, 0.0, -283.76)
		event.set_object_handle_rotation(0, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -22.57, 0.0, -283.73)
		event.set_object_handle_rotation(1, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1409.3, 33.17, 699.45)
		event.set_camera_sequence_look_at(-1317.3, 207.26, 35.03)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 14.06, 0.0, -588.5, 540, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -22.57, 0.0, -588.26, 540, 1)
		event.fade_in_screen(30)
		event.move_camera_sequence(1340.45, 33.17, 781.09, 1266.94, 207.26, 116.17, 450)
		wait.frames(60)
		message.show_voiced_for(6040010, 150)
		message.show_voiced_for(6040020, 240)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -13.05, 82.65, -581.69)
		event.set_object_sequence_rotation(1, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 10.82, 82.79, -581.79)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.05, 107.16, -512.55)
		event.set_camera_sequence_look_at(-0.34, 115.06, -632.94)
		event.move_object_sequence(1, -11.66, 140.66, -709.98, 260, 1)
		event.move_object_sequence(0, 11.57, 140.66, -707.0, 260, 1)
		message.show_voiced_for(6040030, 240)
		wait.frames(20)
		object.wait_until_done(1)
		event.set_camera_sequence_position(1.24, 142.22, -872.19)
		event.set_camera_sequence_look_at(1.67, 177.22, -765.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -8.87, 140.66, -739.81)
		event.set_object_sequence_rotation(1, 0.0, 3.07, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 12.17, 140.66, -739.07)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(1, -9.09, 140.66, -794.9, 120, 1)
		event.move_object_sequence(0, 11.95, 140.66, -793.78, 120, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(6040040, -1)
		wait.frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(6040050)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-0.36, 446.02, 122.03)
		event.set_camera_sequence_look_at(3.18, 151.42, -826.58)
		event.set_object_sequence_position(1, -22.1, 140.66, -908.82)
		event.set_object_sequence_rotation(1, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 13.59, 140.66, -906.11)
		event.set_object_sequence_rotation(0, 0.0, -2.97, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 0)
		event.rotate_object_sequence(2, 0.0, 0.61, 0.0, 60)
		event.rotate_object_sequence(3, 0.0, -0.61, 0.0, 60)
		wait.frames(120)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向く会話", 4)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(6040060)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6040070)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_rotation(2, 0.0, 0.61, 0.0)
	event.set_object_handle_rotation(3, 0.0, -0.61, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the red time gate departure scene, turning the camera around the gate at dusk and then pulling it back as the party walks away.
function moon_flower_palace_field.play_red_time_gate_departure()
	local frame: s32 = 0
	local start_angle: f32 = 0
	local end_angle: f32 = 0
	local radius: f32 = 0
	local angle: f32 = 0
	local offset_x: f32 = 0
	local offset_z: f32 = 0
	local camera_z: f32 = 0
	local camera_z_velocity: f32 = 0
	local camera_z_acceleration: f32 = 0
	local look_y: f32 = 0
	local look_y_velocity: f32 = 0
	local look_y_acceleration: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -15.0, 0.0, -25.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 15.0, 0.0, -25.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.reset_object_handle_dynamic_animation(1)
	event.set_time_of_day(18.0)
	event.set_time_of_day_advancing(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1989.26, 42.52, 580.43)
	event.set_camera_sequence_look_at(-1909.39, 98.92, 395.66)
	wait.frames(60)
	start_angle = event.get_arc_tangent(79.869995, -184.76999) or start_angle
	end_angle = event.get_arc_tangent(379.87, -334.77) or end_angle
	radius = event.get_distance_between(-1909.39, 0.0, 395.66, -1989.26, 0.0, 580.43) or radius
	frame = 0
	while frame < 180 do
		angle = calc.interpolate(start_angle, end_angle, frame, 180)
		offset_x = vm.f32(vm.sin(angle) * radius)
		offset_z = vm.f32(vm.cos(angle) * radius)
		event.set_camera_sequence_look_at(offset_x - vm.f32(1989.26), 98.92, offset_z + vm.f32(580.43))
		frame = frame + 1
		vm.wait(2)
	end
	event.set_time_of_day(0.0)
	event.set_time_of_day_advancing(0)
	event.set_object_sequence_position(0, -15.0, 0.0, -25.0)
	event.set_object_sequence_position(1, 15.0, 0.0, -25.0)
	event.move_object_sequence(1, 15.0, 0.0, -225.0, 360)
	event.move_object_sequence(0, -15.0, 0.0, -225.0, 360)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 18.37, 42.25)
	event.set_camera_sequence_look_at(0.0, 213.16, -316.49)
	camera_z = 42.25
	camera_z_velocity = 0.0
	camera_z_acceleration = moon_flower_palace_field.compute_acceleration(vm.f32(1164.86), 0.0, 360)
	look_y = vm.f32(213.16)
	look_y_acceleration, look_y_velocity = moon_flower_palace_field.solve_ease_in_motion(vm.f32(vm.f32(330.93) - look_y), 1.8359375, 360, look_y_acceleration, look_y_velocity)
	frame = 0
	while frame < 360 do
		camera_z = vm.f32(camera_z + camera_z_velocity)
		camera_z_velocity = vm.f32(camera_z_velocity + camera_z_acceleration)
		event.set_camera_sequence_position(0.0, 18.37, camera_z)
		look_y = vm.f32(look_y + look_y_velocity)
		look_y_velocity = vm.f32(look_y_velocity + look_y_acceleration)
		event.set_camera_sequence_look_at(0.0, look_y, -316.49)
		frame = frame + 1
		vm.wait(3)
	end
	wait.frames(300)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.finish_event()
end

--- Computes the acceleration and starting velocity that cover a distance in a number of frames and end at a given per-frame velocity.
function moon_flower_palace_field.solve_ease_in_motion(distance: f32, end_velocity: f32, frames: f32, out_acceleration: f32, out_start_velocity: f32)
	local acceleration: f32 = 0
	local start_velocity: f32 = 0
	acceleration = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(vm.f32(end_velocity * frames) - distance) * 2.0), frames)), frames))
	start_velocity = vm.f32(vm.fdiv(vm.f32(vm.f32(2.0 * distance) - vm.f32(end_velocity * frames)), frames))
	out_acceleration = acceleration
	out_start_velocity = start_velocity
	return out_acceleration, out_start_velocity
end

return moon_flower_palace_field
