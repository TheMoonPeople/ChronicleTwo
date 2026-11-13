--!strict
--- Event script for the Veniccio map covering entries, exits to dungeons and scene triggers.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local georama = require("@lib/event/georama")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local veniccio = require("@lib/event/veniccio")
local wait = require("@lib/event/wait")

--- Plays event 402 in which Mints and Monica walk and run through the map, then starts chapter 4 back on the map.
local function play_scene_e402()
	local sound_effect_file: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(402, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_effect_file = event.load_sound_effect_file_2(4203) or sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e402/")
		event.load_message_file(0, 5, "e402.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e402_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e402_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
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
		wait.for_frame_count(120)
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
		message.show_voiced_for_stopping(4020015, 40)
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
		wait.for_frame_count(40)
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
		message.show_voiced_for_stopping(4020080, 200)
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(898.96, 88.81, 1079.93, 876.98, 128.35, 1056.64, 360, 1, 1.0)
		message.show_voiced_for_stopping(4020090, 160)
		message.show_voiced_for_stopping(4020100, 120)
		message.show_voiced_for_stopping(4020110, 240)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
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

--- Walks the player ahead and shows a hint about searching the cave first.
local function walk_ahead_and_hint_at_cave()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	target_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + x)
	target_y = y
	target_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + z)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	event.set_object_sequence_motion(0, "歩き")
	frame = 0
	while frame < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		y = vm.f32(y + 30.0)
		event.set_camera_look_at(x, y, z)
		frame = frame + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(
		0,
		"さっきの鳴き声は、なんだったんだろう？\n先にあの洞窟から行ってみよう。"
	)
	message.show(0, -1, 5, 256, 208)
end

--- Asks leave prompt 64 and returns 1 after running the character out with a fade when confirmed, otherwise walks a few steps and returns 0.
local function confirm_leave_area_64()
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
		event.open_message_window_2(0, "『潮騒の洞窟』に移動しますか？")
		progress = 1
		exit_choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
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
			wait.for_frame_count(10)
			event.fade_out_screen(30)
			progress = 3
			wait.for_frame_count(30)
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
				wait.skip_frame_count(10)
			end
			if progress <= 2 then
				wait.skip_frame_count(30)
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
local function confirm_leave_area_75()
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
		event.open_message_window_2(0, "『パウの家』に移動しますか？")
		progress = 1
		exit_choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
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
			wait.for_frame_count(20)
			event.fade_out_screen(30)
			progress = 3
			wait.for_frame_count(30)
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
				wait.skip_frame_count(20)
			end
			if progress <= 2 then
				wait.skip_frame_count(30)
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
local function confirm_leave_area_83()
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
		event.open_message_window_2(0, "『ベニーティオ停車場』に移動しますか？")
		progress = 1
		exit_choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
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
			wait.for_frame_count(20)
			event.fade_out_screen(30)
			progress = 3
			wait.for_frame_count(30)
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
				wait.skip_frame_count(20)
			end
			if progress <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Plays event 404 in which Mints and Monica talk and run off while Shigu walks along a path, then returns to the map.
local function play_scene_e404()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(404, 1)
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e400/e404/")
		event.load_message_file(0, 5, "e404.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e404_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
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
		if active_chr_no == 1 then
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
		wait.for_frame_count(10)
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
		wait.for_frame_count(10)
		event.move_object_sequence(1, 1507.06, 0.0, 850.62, 70)
		event.set_object_sequence_motion(1, "走り")
		wait.for_frame_count(20)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
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
	wait.for_frame_count(4)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = veniccio.update_map_state

--- Plays the entry sequence matching the map the player came from.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	local entry_handled: s32 = 0
	local previous_submap_number: s32 = 0
	local old_sub_map_type: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local previous_interior_map_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		veniccio.update_map_state()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			character.place_standing_and_reset_cloth(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
			event.reset_follow_camera(1, 0.0, 10.0)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			old_map_type = event.get_map_type(previous_map_number) or old_map_type
			print("old_map = ", previous_map_number, "\n")
			print("old_map_type = ", old_map_type, "\n")
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 or previous_map_number == 84 then
					resume_step = 1
					veniccio.run_in_entrance_a()
				else
					entry_handled = 0
					if previous_map_number == 82 then
						character.place_standing_and_reset_cloth(-140.0, 165.0, 1865.0, vm.f32(2.28))
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(30)
						entry_handled = 1
					end
					if previous_map_number == 75 then
						resume_step = 2
						veniccio.run_in_entrance_b()
						entry_handled = 1
					end
					previous_submap_number = event.get_previous_submap() or previous_submap_number
					old_sub_map_type = event.get_map_type(previous_submap_number) or old_sub_map_type
					if entry_handled == 0 and not (previous_map_number == 2 and old_sub_map_type == 2) then
						flag = event.get_save_flag(402) or flag
						flag_2 = event.get_save_flag(360) or flag_2
						if flag == 0 and flag_2 == 1 then
							resume_step = 3
							play_scene_e402()
						else
							resume_step = 4
							veniccio.run_in_entrance_c()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				previous_interior_map_number = event.get_previous_interior_map() or previous_interior_map_number
				if 0 <= previous_interior_map_number then
				else
					resume_step = 5
					veniccio.run_in_entrance_c()
				end
			end
		end
		resume_step = 6
		veniccio.show_default_hint_message(1)
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step <= 1 then
				entry_handled = 0
				cutscene.ignore_coordinates(-140.0, 165.0, 1865.0, vm.f32(2.28))
				entry_handled = 1
				veniccio.run_unused_look_at_loop()
			end
			if resume_step <= 2 then
				entry_handled = 1
				resume_step = 3
				play_scene_e402()
				return vm.continue_with(function()
					resume_step = 6
					veniccio.show_default_hint_message(1)
					return
				end)
			end
			if resume_step <= 3 then
				veniccio.run_unused_look_at_loop_short()
			end
			if resume_step <= 4 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				veniccio.run_unused_look_at_loop_short()
			end
			if resume_step <= 5 then
				message.clear_window_option(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = veniccio.run_in_entrance_c

--- Shows the blocked path hint or lets the player choose a dungeon floor and enter it.
function script.choose_dungeon_floor()
	local flag: s32 = 0
	local dungeon_stage: s32 = 0
	local selected_floor: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local floor_info_value: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(404) or flag
	if flag == 0 then
		walk_ahead_and_hint_at_cave()
	elseif confirm_leave_area_64() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			dungeon_stage = out2 or dungeon_stage
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			veniccio.run_in_entrance_a()
			return
		end
		if selected_floor == 20 then
			flag_2 = event.get_save_flag(438) or flag_2
			flag_3 = event.get_save_flag(444) or flag_3
			if flag_2 == 1 and flag_3 == 0 then
				event.go_to_dungeon(3, selected_floor, 1010)
			else
				dungeon_stage = 3
				selected_floor = 20
				floor_info_value = event.get_dungeon_floor_info(dungeon_stage, selected_floor, 7) or floor_info_value
				floor_info_value = vm.i32(floor_info_value + 1)
				event.set_dungeon_floor_info(dungeon_stage, selected_floor, 7, floor_info_value)
				event.jump_to_map_3(-1, "d04b01", 100)
			end
		else
			flag_4 = event.get_save_flag(406) or flag_4
			flag_5 = event.get_save_flag(424) or flag_5
			if selected_floor == 2 and flag_4 == 0 or selected_floor == 17 and flag_5 == 0 or selected_floor == 19 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(3, selected_floor, 1010)
		end
	end
end
script[201] = script.choose_dungeon_floor

--- Asks to leave and jumps to the s27 map when confirmed.
function script.exit_to_s27()
	local flag: s32 = 0
	if confirm_leave_area_75() ~= 0 then
		flag = event.get_save_flag(404) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "s27")
	end
end
script[202] = script.exit_to_s27

--- Asks to leave and jumps to the s09 map when confirmed.
function script.exit_to_s09()
	if confirm_leave_area_83() ~= 0 then
		event.jump_to_map_2(-1, "s09")
	end
end
script[203] = script.exit_to_s09

--- Plays the red time gate effect and jumps to the f03 map.
function script.use_time_gate()
	cutscene.play_time_gate_travel(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end
script[300] = script.use_time_gate

--- Shows the default hint message after a georama change.
function script.edit_analyze_changed()
	veniccio.show_default_hint_message(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Updates the map state and plays scene e404.
function script.play_scene_e404()
	veniccio.update_map_state()
	play_scene_e404()
end
script[500] = script.play_scene_e404

--- Places the player at the dungeon exit and fades in.
function script.enter_from_dungeon()
	veniccio.update_map_state()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 1425.7, 0.0, 1034.8)
	event.set_character_rotation(0, 0.0, -2.37, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end
script[510] = script.enter_from_dungeon

--- Places the player at the time gate and explains the georama requirement when it is unmet.
function script.enter_from_time_gate()
	local is_condition_met: s32 = 0
	veniccio.update_map_state()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -140.0, 165.0, 1800.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	is_condition_met = georama.is_analysis_flag_305_set()
	if is_condition_met == 0 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]ジオラマの条件を満たして、ルナ研の\n   センターラボを復活させると、物語が\n   進行します。"
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end
	veniccio.show_default_hint_message(1)
end
script[520] = script.enter_from_time_gate

--- Updates the map state and plays scene e402.
function script.play_scene_e402()
	veniccio.update_map_state()
	play_scene_e402()
end
script[14020] = script.play_scene_e402

return script
