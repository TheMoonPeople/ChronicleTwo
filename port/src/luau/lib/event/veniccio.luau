--!strict
--- Helpers specific to the Veniccio map.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local georama = vm.module("@lib/event/georama")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local veniccio = {}

--- Asks leave prompt 64 and returns 1 after running the character out with a fade when confirmed, otherwise walks a few steps and returns 0.
function veniccio.confirm_leave_area_64()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		progress = 1
		exit_choice = message.ask_yes_no(5, 64)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.set_camera_sequence_position(1800.16, 21.11, -758.98)
			event.set_camera_sequence_look_at(1958.18, 16.39, -784.17)
			event.set_object_sequence_motion(0, "走り", 4)
			event.set_object_sequence_position(0, 1899.56, -14.0, -773.11)
			event.set_object_sequence_rotation(0, 0.0, 1.73, 0.0)
			event.move_object_sequence(0, 2107.33, -14.0, -805.09, 40)
			progress = 2
			wait.frames(10)
			event.fade_out_screen(30)
			progress = 3
			wait.frames(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + x)
			target_y = y
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + z)
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
				progress = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(10)
			end
			if progress <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks leave prompt 75 and returns 1 after running the character out along a path with a fade when confirmed, otherwise walks a few steps and returns 0.
function veniccio.confirm_leave_area_75()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		progress = 1
		exit_choice = message.ask_yes_no(5, 75)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.set_camera_sequence_position(1635.73, 32.56, 1292.96)
			event.set_camera_sequence_look_at(1754.78, 30.0, 1358.67)
			event.set_object_sequence_position(0, 1782.12, 0.0, 1373.78)
			event.set_object_sequence_rotation(0, 0.0, 1.0, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 50)
			event.add_object_sequence_path_point(0, 1782.12, 0.0, 1373.78)
			event.add_object_sequence_path_point(0, 1825.81, 0.0, 1397.9)
			event.add_object_sequence_path_point(0, 1906.73, 0.0, 1437.54)
			event.add_object_sequence_path_point(0, 1986.2, 0.0, 1465.28)
			event.start_object_sequence_path(0)
			progress = 2
			wait.frames(20)
			event.fade_out_screen(30)
			progress = 3
			wait.frames(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.15)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.15)) * 30.0) + z)
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
				progress = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(20)
			end
			if progress <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks leave prompt 83 and returns 1 after running the character out with a fade when confirmed, otherwise walks a few steps and returns 0.
function veniccio.confirm_leave_area_83()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		progress = 1
		exit_choice = message.ask_yes_no(5, 83)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.set_camera_sequence_position(-454.66, 376.79, 2105.55)
			event.set_camera_sequence_look_at(-706.43, 390.04, 2258.31)
			event.set_object_sequence_position(0, -667.76, 328.93, 2241.58)
			event.set_object_sequence_rotation(0, 0.0, -1.25, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1, 1)
			event.move_object_sequence(0, -838.07, 378.91, 2297.28, 50)
			progress = 2
			wait.frames(20)
			event.fade_out_screen(30)
			progress = 3
			wait.frames(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(1.88)) * 30.0) + x)
			target_y = 326.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(1.88)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
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
				progress = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(20)
			end
			if progress <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Returns 1 when any of the four hint events tied to save flags 456, 460, 448 and 468 is still pending.
function veniccio.has_pending_hint()
	if georama.can_start_event_456() ~= 0 then
		return 1
	end
	if georama.can_start_event_460() ~= 0 then
		return 1
	end
	if veniccio.is_hint_pending_448() ~= 0 then
		return 1
	end
	if georama.can_start_event_468() ~= 0 then
		return 1
	end
	return 0
end

--- Returns 1 when georama analysis flag 305 is set, save flag 448 is clear and the character change state is nonzero.
function veniccio.is_hint_pending_448()
	local hint_done_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_flag_305_set() == 0 then
		return 0
	end
	hint_done_flag = event.get_save_flag(448) or hint_done_flag
	if hint_done_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Plays event 402 in which Mints and Monica walk and run through the map, then starts chapter 4 back on the map.
function veniccio.play_scene_e402()
	local sound_effect_file: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(402, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_effect_file = event.load_sound_effect_file_2(4203) or sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e402/")
		event.load_message_file(0, 5, "e402_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e402_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e402_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e402/e402_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e402/e402_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 471.25, 20.66, 1748.34)
		event.set_object_handle_rotation(0, 0.0, 2.42, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_position(1, 465.2, 21.66, 1714.07)
		event.set_object_handle_rotation(1, 0.0, 2.06, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(626.04, 342.91, 851.54, 601.54, 423.33, 982.17)
		event.add_camera_sequence_path_point(626.04, 302.51, 851.54, 601.54, 268.91, 982.17)
		event.add_camera_sequence_path_point(626.04, 292.84, 851.54, 631.34, 235.24, 1036.0)
		event.start_camera_sequence_path()
		event.move_object_sequence(0, 658.38, 0.0, 1645.68, 200, 1)
		event.move_object_sequence(1, 634.81, 0.0, 1650.64, 200, 1)
		event.fade_in_screen(30)
		wait.frames(120)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_footstep_sound(1, 14)
		camera.wait_until_done()
		event.set_camera_sequence_position(715.95, 6.25, 1348.09)
		event.set_camera_sequence_look_at(737.6, 21.29, 1394.21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(0, 742.24, 0.0, 1390.21)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, 726.5, 0.0, 1393.6)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4020010)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～うれし目")
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 698.97, -14.0, 868.0, 180)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced_for(4020015, 40)
		event.move_camera_sequence_angle_height_distance_eased(0.07, 6.33, 54.89, 40, 0, 1.0)
		object.wait_until_done(0)
		event.play_sound_effect(sound_effect_file, 0)
		event.set_object_sequence_motion(0, "はしゃぐ", 2)
		event.queue_object_sequence_next_motion(0, "はしゃぐL", 4)
		message.show_voiced(4020020)
		event.set_camera_sequence_position(713.67, 19.27, 1363.81)
		event.set_camera_sequence_look_at(727.45, 21.29, 1389.89)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "うれし顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4020030)
		event.set_camera_sequence_position(677.49, 2.27, 847.33)
		event.set_camera_sequence_look_at(696.2, 6.92, 872.39)
		event.stop_sound_effect(sound_effect_file, 0)
		event.play_sound_effect(sound_effect_file, 1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目パチ")
		event.set_object_sequence_motion(0, "うん！", 6)
		event.queue_object_sequence_next_motion(0, "うん！L", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4020040)
		event.set_camera_sequence_position(713.67, 19.27, 1363.81)
		event.set_camera_sequence_look_at(727.45, 21.29, 1389.89)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4020050)
		event.set_camera_sequence_position(758.44, 28.22, 1458.62)
		event.set_camera_sequence_look_at(743.05, 21.29, 1388.25)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "手をふる", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 716.1, 0.0, 1297.83, 90)
		event.open_voice_stream_wave(1, 4020055)
		sound.wait_voice_stream_ready(1)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(1, "はっ？！", 6)
		event.queue_object_sequence_next_motion(1, "はっ？！Ｌ", 4)
		wait.frames(40)
		event.close_voice_stream(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4020060)
		event.set_camera_sequence_follow_object(0, 4.0, 22.0, 0.0, -2.2, 0.5, 50.0)
		event.set_object_sequence_position(0, 561.8, -14.0, 1018.56)
		event.set_object_sequence_rotation(0, 0.0, 0.48, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4020070)
		object.wait_until_done(1)
		event.fade_out_music(30)
		event.set_object_handle_footstep_sound(0, -1)
		event.set_object_handle_footstep_sound(1, -1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.delay_object_sequence_position_track(0, 60)
		event.move_object_sequence(0, 1065.83, 0.0, 1080.26, 230, 1)
		event.delay_object_sequence_rotation_track(0, 60)
		event.rotate_object_sequence(0, 0.0, 1.44, 0.0, 10)
		event.delay_object_sequence_motion_track(0, 59)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 230)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 60)
		event.move_object_sequence(1, 903.05, 0.0, 1267.1, 180)
		event.delay_object_sequence_rotation_track(1, 60)
		event.rotate_object_sequence(1, 0.0, 2.06, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 180)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_camera_sequence_angle_track(60)
		event.move_camera_sequence_angle_height_distance_eased(0.76, -1.0, 32.0, 30, 0, 1.0)
		message.show_voiced_for(4020080, 200)
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(898.96, 88.81, 1079.93, 876.98, 128.35, 1056.64, 360, 1, 1.0)
		message.show_voiced_for(4020090, 160)
		message.show_voiced_for(4020100, 120)
		message.show_voiced_for(4020110, 240)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(22)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect_file, 0)
	event.clear_camera_sequence()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	event.set_save_data_value(0, 6)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(4)
	vm.wait(23)
	event.set_sound_reverb_enabled(1)
	event.load_map_sounds(4000)
	event.load_music(3)
	event.play_music(0)
	event.set_character_active(0)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 1333.8, 0.0, 1013.9)
	event.set_character_rotation(0, 0.0, 1.02, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays event 404 in which Mints and Monica talk and run off while Shigu walks along a path, then returns to the map.
function veniccio.play_scene_e404()
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(404, 1)
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e400/e404/")
		event.load_message_file(0, 5, "e404_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e404_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e404_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e404_shigu.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e404/e404_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e404/e404_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 1580.54, 0.0, 1092.15)
		event.set_object_handle_rotation(0, 0.0, -2.4, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 1501.84, 0.0, 1069.09)
		event.set_object_handle_rotation(1, 0.0, -2.64, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 1891.0, -14.0, -716.0)
		event.set_object_handle_rotation(2, 0.0, 2.16, 0.0)
		event.move_object_sequence(0, 1424.62, 0.0, 938.48, 46)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 1401.25, 0.0, 947.01, 36)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 36)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, -0.96, 0.0, 8)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(846.73, 268.48, 883.94)
		event.set_camera_sequence_look_at(1289.42, 146.71, 951.29)
		event.fade_in_screen(30)
		object.wait_until_done(0)
		object.wait_until_done(1)
		wait.frames(10)
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 6)
		event.delay_object_sequence_rotation_track(1, 4)
		event.rotate_object_sequence(1, 0.0, 2.2, 0.0, 10)
		event.move_camera_sequence_eased(1059.22, 268.48, 1339.51, 1289.42, 146.71, 951.29, 30, 0, 1.0)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "立ち")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, 1787.63, -14.0, -561.29)
		event.add_object_sequence_path_point(2, 1891.0, -14.0, -716.0)
		event.add_object_sequence_path_point(2, 2049.12, -14.0, -873.59)
		event.add_object_sequence_path_point(2, 2149.2, -14.0, -954.9)
		event.add_object_sequence_path_point(2, 2250.94, -14.0, -1018.67)
		event.start_object_sequence_path(2)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040350)
		camera.wait_until_done()
		event.set_camera_sequence_position(1404.09, 22.36, 896.46)
		event.set_camera_sequence_look_at(1422.53, 17.33, 974.51)
		event.set_object_sequence_rotation(0, 0.0, 2.8, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4040360)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4040370)
		event.move_object_sequence(0, 1530.85, 0.0, 826.72, 60)
		event.set_object_sequence_motion(0, "走り")
		wait.frames(10)
		event.move_object_sequence(1, 1507.06, 0.0, 850.62, 70)
		event.set_object_sequence_motion(1, "走り")
		wait.frames(20)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.load_map_sounds(4000)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(3)
	event.play_music(0)
	event.set_character_active(0)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 1733.3, 0.0, -301.5)
	event.set_character_rotation(0, 0.0, 2.76, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Fades in with the character running in from the first entrance while the camera looks at them.
function veniccio.run_in_entrance_a()
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 18)
	event.set_character_position(0, 2065.33, -14.0, -806.24)
	event.set_character_rotation(0, 0.0, -1.42, 0.0)
	event.set_character_motion(0, "走り", 4)
	event.set_camera_position(1962.84, 25.0, -888.26)
	event.fade_in_screen(30)
	event.move_object_sequence(0, 1899.56, -14.0, -773.11, 40)
	i = 0
	while i < 40 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		look_at_y = vm.f32(look_at_y + 30.0)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		i = i + 1
		vm.wait(1)
	end
end

--- Fades in with the character running in from the second entrance while the camera looks at them.
function veniccio.run_in_entrance_b()
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 14)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_position(0, 1886.59, 0.0, 1431.76)
	event.set_character_rotation(0, 0.0, -2.06, 0.0)
	event.set_character_motion(0, "走り", 4)
	event.set_camera_position(1597.0, 30.85, 1279.41)
	event.fade_in_screen(30)
	event.move_object_sequence(0, 1727.66, 0.0, 1341.11, 40)
	i = 0
	while i < 40 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		look_at_y = vm.f32(look_at_y + 30.0)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		i = i + 1
		vm.wait(1)
	end
	event.set_object_handle_footstep_sound(0, 0)
end

--- Fades in with the character running in from the third entrance while the camera looks at them.
function veniccio.run_in_entrance_c()
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 3)
	event.set_character_position(0, -691.6, 339.04, 2249.38)
	event.set_character_rotation(0, 0.0, 1.91, 0.0)
	event.set_character_motion(0, "走り", 4)
	event.set_camera_position(-454.66, 376.79, 2105.55)
	event.fade_in_screen(30)
	event.move_object_sequence(0, -584.92, 320.0, 2221.56, 30, 1)
	i = 0
	while i < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		look_at_y = vm.f32(look_at_y + 30.0)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		i = i + 1
		vm.wait(1)
	end
end

--- Holds an unused 40-iteration loop that raises a look-at height and has no observable effect.
function veniccio.run_unused_look_at_loop()
	local look_at_height: f32 = 0
	local i: s32 = 0
	i = 0
	look_at_height = vm.f32(look_at_height + 30.0)
	local _ = i < 40
	i = i + 1
end

--- Holds an unused 30-iteration loop that raises a look-at height and has no observable effect.
function veniccio.run_unused_look_at_loop_short()
	local look_at_height: f32 = 0
	local i: s32 = 0
	i = 0
	look_at_height = vm.f32(look_at_height + 30.0)
	local _ = i < 30
	i = i + 1
end

--- Shows the chapter hint message with the default text, skipping it when require_pending is set and no hint event is pending.
function veniccio.show_default_hint_message(require_pending: s32)
	veniccio.show_hint_message(require_pending, 0)
end

--- Shows the chapter hint message while the chapter is below 8, using text 1051 when a hint event is pending and 1050 otherwise, adding 10 when use_alternate_text is set; skipped when require_pending is set and no hint is pending.
function veniccio.show_hint_message(require_pending: s32, use_alternate_text: s32)
	local chapter: s32 = 0
	local message_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter >= 8 then
		return
	end
	event.set_message_window_mode(1, 8)
	event.set_character_motion(0, "立ち")
	message_id = 1050
	if veniccio.has_pending_hint() ~= 0 then
		message_id = 1051
	elseif require_pending ~= 0 then
		return
	end
	if use_alternate_text ~= 0 then
		message_id = message_id + 10
	end
	event.open_message_window_2(1, message_id)
	message.show(1, -1, 8, 0, 0)
end

--- Hides map part p11_g0301 and shows p12_g0301 once save flag 448 is set.
function veniccio.swap_map_parts()
	local map_change_flag: s32 = 0
	map_change_flag = event.get_save_flag(448) or map_change_flag
	if map_change_flag ~= 0 then
		event.attach_object_handle_to_map_part_2(1, "p11_g0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p12_g0301")
		event.set_object_handle_visible(1, 1)
	end
end

--- Activates characters 120 and 121 unless save flag 404 is 1 or the debug flag is set, then refreshes the map parts.
function veniccio.update_map_state()
	local event_flag: s32 = 0
	local debug_flag: s32 = 0
	event_flag = event.get_save_flag(404) or event_flag
	if event_flag ~= 1 then
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			event.set_character_active(0, 120)
			event.set_character_active(0, 121)
		end
	end
	veniccio.swap_map_parts()
end

return veniccio
