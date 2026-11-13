--!strict
--- Palm Brinks workshop script that runs the Steve and Flotsam rematch scenes and the workshop owner's conversation.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local palm_brinks_shop_house = require("@lib/event/palm_brinks_shop_house")
local wait = require("@lib/event/wait")

--- Plays the Mints and Starbre exchange and asks whether to continue, returning 1 when the player agrees.
local function ask_to_begin_introduction(se_id: s32)
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		resume_step = 1
		camera.wait_until_done()
		event.set_camera_sequence_position(-26.93, 26.72, -145.82)
		event.set_camera_sequence_look_at(27.6, 22.54, -159.02)
		event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
		event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4)
		event.set_object_sequence_position(2, 38.77, -0.02, -147.68)
		event.set_object_sequence_rotation(2, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		resume_step = 2
		wait.frames(30)
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		resume_step = 3
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		resume_step = 4
		wait.frames(10)
		event.set_mouth_texture_animations(2, "大口パク")
		resume_step = 5
		message.show_voiced(1060010)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Gut!\nWarte einen Moment.")
		resume_step = 6
		choice = message.open_and_ask_choice(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if choice == 0 then
			resume_step = 7
			message.show_voiced(1060040)
			event.play_sound_effect(se_id, 2)
			event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			event.set_object_sequence_motion(2, "ガッツポーズ", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			event.set_mouth_texture_animations(2, "大口パク")
			resume_step = 8
			message.show_voiced(1060050)
			event.reset_mouth_texture_animations()
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 9
			wait.frames(30)
			return 1
		else
			event.set_object_sequence_motion(0, "上見会話", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			resume_step = 10
			wait.frames(9)
			resume_step = 11
			message.show_voiced(1060020)
			event.set_object_sequence_motion(2, "会話2", 6)
			resume_step = 12
			wait.frames(9)
			event.set_mouth_texture_animations(2, "大口パク")
			resume_step = 13
			message.show_voiced(1060030)
			event.reset_mouth_texture_animations()
			return 0
		end
	end, function(received: { any })
		if resume_step <= 9 then
			if resume_step == 6 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			if resume_step <= 3 then
				wait.frames_skipping(10)
			end
			if resume_step <= 4 then
				message.show_voiced_skipping(1060010)
			end
			if resume_step <= 5 then
				choice = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
			end
			if resume_step <= 6 then
				message.show_voiced_skipping(1060040)
			end
			if resume_step <= 7 then
				message.show_voiced_skipping(1060050)
			end
			if resume_step <= 8 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 13 then
			if resume_step <= 10 then
				message.show_voiced_skipping(1060020)
			end
			if resume_step <= 11 then
				wait.frames_skipping(9)
			end
			if resume_step <= 12 then
				message.show_voiced_skipping(1060030)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the Steve introduction scene in the workshop and returns 1 when the player went through it.
local function play_steve_introduction_scene()
	local accepted: s32 = 0
	local light_visible: s32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local projection: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		vm.section(function()
			resume_step = 1
			vm.entry(1)
			event.set_save_flag(106, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			sound_bank = event.load_sound_effect_file_2(1231) or sound_bank
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
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
			event.load_character_motion_pack(5, "event/e100/e106/e106_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character(5, "event/e100/e106/e106_starbre.gltf", "info", 34)
			event.attach_object_handle_to_character(2, 34)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_character_active(1, 34)
			event.load_character(5, "event/e100/e106/e106_steve.gltf", "info", 35)
			event.set_character_active(1, 35)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_handle_sound_bank(3, sound_bank)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.load_message_file(0, 5, "event/e100/e106/e106_1.txt")
			event.stop_music(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
			resume_step = 2
			accepted = ask_to_begin_introduction(sound_bank)
			if accepted == 1 then
				event.delete_character_extension_packs(0)
				event.load_character_motion_pack(5, "event/e100/e106/e106_mints2.gltf", "info", 0)
				light_visible = event.is_object_handle_frame_visible(3, "light") or light_visible
				event.set_object_handle_frame_visible(3, "light", 0)
				projection = event.get_event_projection() or projection
				event.enable_drama_skip()
				resume_step = 3
				palm_brinks_shop_house.play_lights_on_scene(light_visible, sound_bank)
				resume_step = 4
				palm_brinks_shop_house.play_first_speech_scene(sound_bank)
				resume_step = 5
				palm_brinks_shop_house.play_promise_scene(sound_bank)
				event.set_object_handle_sound_bank(3, sound_bank)
				resume_step = 6
				palm_brinks_shop_house.play_corridor_departure_scene(sound_bank)
			end
			event.fade_out_screen(30)
			resume_step = 7
			wait.frames(30)
		end, function(received: { any }): boolean
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				accepted = palm_brinks_shop_house.skip_dialogue_scene_with_choice(sound_bank)
			end
			if resume_step <= 2 then
				palm_brinks_shop_house.skip_lights_on_scene(light_visible, sound_bank)
			end
			if resume_step <= 3 then
				palm_brinks_shop_house.skip_first_speech_scene(sound_bank)
			end
			if resume_step <= 4 then
				palm_brinks_shop_house.skip_promise_scene(sound_bank)
			end
			if resume_step <= 5 then
				palm_brinks_shop_house.skip_corridor_departure_scene(sound_bank)
			end
			if resume_step <= 6 then
				wait.frames_skipping(30)
			end
			return true
		end)
		resume_step = 8
		vm.entry(8)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(sound_bank, 6)
		event.set_event_projection(projection)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_active(1, 0)
		event.delete_character_extension_packs(0)
		event.delete_character(34)
		event.delete_character(35)
		if accepted ~= 1 then
			event.play_music(0)
		end
		event.fade_in_screen(30)
		return accepted
	end, function(received: { any })
		if resume_step <= 8 then
			return accepted
		end
		return nil
	end)
end

--- Plays the corridor shots that end with the hint that Steve starts the Flotsam rematch.
local function show_steve_rematch_hint(se_id: s32)
	event.set_camera_sequence_position(-119.36, 26.55, -129.41)
	event.set_camera_sequence_look_at(-121.06, 12.13, -226.83)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	wait.frames(50)
	event.stop_sound_effect(se_id, 0)
	event.play_sound_effect(se_id, 5)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	wait.frames(30)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_camera_sequence_position(-107.26, 10.75, -131.0)
	event.set_camera_sequence_look_at(-110.45, 11.92, -193.48)
	event.set_character_position(0, -91.97, -12.53, -211.57)
	event.set_character_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_position(33, -119.53, -12.53, -229.18)
	event.set_character_rotation(33, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_handle_frame_visible(1, "light--c0appz0n1", 0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(100, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "[(!)]Um Flotsam wieder zu\n   bek[UNI00e4]mpfen, aktiviere Steve\nmit (O).")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
end

--- Sets up the corridor scene with Steve, plays it through the rematch hint and restores the camera, characters and map parts.
local function play_steve_corridor_scene()
	local sound_bank: s32 = 0
	local steve_sound_bank: s32 = 0
	local projection: f32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(1822) or sound_bank
		steve_sound_bank = event.load_sound_effect_file_3(7, "snd2/chara/ch_040.sound.json") or steve_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		event.get_camera_position()
		event.get_camera_look_at()
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, 0.0, 50.0, 0.0)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, steve_sound_bank)
		event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
		event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
		event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		palm_brinks_shop_house.play_corridor_entry_scene(sound_bank)
		show_steve_rematch_hint(sound_bank)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(12)
	event.clear_object_sequence(13)
	event.set_save_flag(56, 0)
	event.set_event_projection(projection)
	event.set_camera_position(-119.36, 26.55, -129.41)
	event.set_camera_look_at(-121.06, 12.13, -226.83)
	event.set_character_position(0, -98.38, -12.53, -200.14)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_object_handle_rotation(12, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(13, 0.0, 0.0, 0.0)
	vm.wait(4)
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_visible(11, 1)
	event.set_object_handle_visible(14, 1)
	event.set_object_handle_visible(15, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Asks whether Mints is ready to face Flotsam again and returns 1 when the player confirms.
local function ask_ready_for_rematch(sound_bank: any)
	local choice: any = 0
	local previous_window_mode: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_camera_sequence_position(-138.16, 13.17, -131.29)
		event.set_camera_sequence_look_at(-115.98, 11.22, -208.05)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -98.38, -12.53, -200.14)
		event.set_object_sequence_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_motion(1)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Ja! Lass mich noch mal ran!\nIch bin noch nicht bereit.")
		resume_step = 1
		choice = message.open_and_ask_choice(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, previous_window_mode)
		if choice == 0 then
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
			resume_step = 2
			wait.frames(30)
			resume_step = 3
			camera.wait_until_done()
			resume_step = 4
			vm.wait(4)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			return 1
		end
		return nil
	end)
end

--- Asks for confirmation and plays the Flotsam rematch scene, returning 1 when it was played.
local function play_rematch_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local confirmed: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		vm.section(function()
			event.set_character_active(0, 24)
			event.set_save_flag(108, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.load_map_sounds(1237)
			sound_bank = event.load_sound_effect_file_2(1237) or sound_bank
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			projection = event.get_event_projection() or projection
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
			event.clear_camera_sequence()
			event.set_camera_position(6.02, 94.24, 399.23)
			event.set_camera_look_at(-4.96, 118.28, 117.71)
			event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_character_position(0, 0.0, 50.0, 0.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
			event.set_character_active(1, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_character_position(33, 0.0, 50.0, 0.0)
			event.set_character_rotation(33, 0.0, 0.0, 0.0)
			event.set_object_handle_sound_bank(1, sound_bank)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
			event.clear_object_sequence(14)
			event.set_object_sequence_object(14, 14)
			event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
			event.clear_object_sequence(15)
			event.set_object_sequence_object(15, 15)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "おこり顔")
			event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
			resume_step = 1
			confirmed = ask_ready_for_rematch(sound_bank)
			if confirmed == 1 then
				event.enable_drama_skip()
				resume_step = 2
				palm_brinks_shop_house.play_corridor_arrival_scene(sound_bank)
				resume_step = 3
				palm_brinks_shop_house.play_corridor_exit_scene(sound_bank)
				event.set_save_flag(56, 1)
			else
				event.set_save_flag(56, 0)
			end
			event.fade_out_screen(30)
			resume_step = 4
			wait.frames(30)
		end, function(received: { any }): boolean
			if resume_step == 1 then
				confirmed = received[1] :: number
			end
			if resume_step <= 1 then
				palm_brinks_shop_house.skip_corridor_arrival_scene(sound_bank)
			end
			if resume_step <= 2 then
				palm_brinks_shop_house.skip_corridor_exit_scene(sound_bank)
			end
			if resume_step <= 3 then
				wait.frames_skipping(30)
			end
			return true
		end)
		resume_step = 5
		vm.entry(5)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(sound_bank, 1)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.get_event_projection(projection)
		event.get_camera_position(camera_x, camera_y, camera_z)
		event.get_camera_look_at(look_at_x, look_at_y, look_at_z)
		resume_step = 6
		vm.wait(6)
		event.delete_character_extension_packs(0)
		event.delete_character(33)
		event.fade_in_screen(30)
		return confirmed
	end, function(received: { any })
		if resume_step <= 6 then
			return confirmed
		end
		return nil
	end)
end

--- Runs the workshop owner's conversation, choosing the line or follow-up scene from the story flags and the player's items.
local function talk_to_house_owner(owner_slot: s32, owner_id: any)
	local save_flag: s32 = 0
	local lookup_result: s32 = 0
	local player_character: s32 = 0
	local menu_choice: any = 0
	local scrap_count: s32 = 0
	local hide_count: s32 = 0
	local copper_count: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait.frames(9)
	save_flag = event.get_save_flag(7) or save_flag
	if save_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		message.set_window_mode(0, 1)
		cutscene.begin_talk(owner_slot, 0, 0)
		player_character = event.get_player_character_slot() or player_character
		event.open_message_window_2(0, "Und, wie geht's Steve?")
		message.say_bubble(0, -1, owner_slot, player_character, 0)
		event.set_character_motion(owner_slot, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Aufladen\nKern verbessern")
		menu_choice = message.open_and_ask_choice(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if menu_choice == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "So! Alles fertig!")
			message.say_bubble(0, -1, owner_slot, player_character, 0)
		end
		if menu_choice == 1 then
			event.fade_out_screen(25)
			wait.frames(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	save_flag = event.get_save_flag(107) or save_flag
	if save_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(0, "Du gibst bei so etwas\nschon auf? Nie aufgeben, sag ich!")
		cutscene.talk(owner_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	save_flag = event.get_save_flag(20) or save_flag
	if save_flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c_1.stb", 500)
		return
	end
	lookup_result = event.get_item_count(165) or lookup_result
	if lookup_result > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	scrap_count = event.get_item_count(224) or scrap_count
	hide_count = event.get_item_count(245) or hide_count
	copper_count = event.get_item_count(227) or copper_count
	lookup_result = event.is_invention_created(165) or lookup_result
	if scrap_count >= 20 and hide_count >= 1 and copper_count >= 2 and lookup_result ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	save_flag = event.get_save_flag(19) or save_flag
	if save_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"Geh nach drau[UNI00df]en. Der Laden direkt\ngegen[UNI00fc]ber mit dem K[UNI00fc]rbis-Schild ist\nder Gegenst[UNI00e4]ndeladen.<page>Du brauchst 20 St[UNI00fc]ck Metall,\n2 Kupferklumpen und 1 Tierhaut.\nGeh r[UNI00fc]ber und kauf das!"
		)
		cutscene.talk(owner_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	lookup_result = event.is_invention_created(165) or lookup_result
	if lookup_result ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	lookup_result = event.has_invention_ideas(165) or lookup_result
	if lookup_result == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	save_flag = event.get_save_flag(17) or save_flag
	if save_flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b_1.stb", 510)
		return
	end
	save_flag = event.get_save_flag(105) or save_flag
	if save_flag == 0 then
		event.open_message_window_2(0, "Max, du kannst nicht einfach\nblaumachen, verstanden?")
		cutscene.talk(owner_slot, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "Du musst es erst alleine\nversuchen, Junge.")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.open_message_window_2(0, "Wenn du nicht weiterkommst,\ngeb ich dir einen Tipp, ja?")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.open_message_window_2(0, "Jetzt mach dich ran!")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Dispatches a talk event to the owner conversation, or starts the Flotsam rematch event when no character was targeted and the rematch flags are set.
local function handle_talk_target()
	local character_slot: s32 = 0
	local character_id: s32 = 0
	local save_flag: s32 = 0
	local second_save_flag: s32 = 0
	event.set_message_window_mode(0, 1)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	character_id = event.get_triggered_event_data_2(14) or character_id
	print("[talk_chara]", character_id, "\n")
	print("[talk_chara_id]", character_id, "\n")
	if character_id == 1 then
		talk_to_house_owner(character_slot, character_id)
	end
	if character_id == -1 then
		save_flag = event.get_save_flag(6) or save_flag
		second_save_flag = event.get_save_flag(7) or second_save_flag
		if save_flag == 1 and second_save_flag == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c_1.stb", 520)
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Plays the Steve introduction scene and grants the starting inventions and party member when it completes.
function script.cutscene_steve_introduction()
	local accepted: s32 = 0
	local item_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		resume_step = 1
		wait.frames(10)
		palm_brinks_shop_house.hide_house_owner()
		resume_step = 2
		accepted = play_steve_introduction_scene()
		if accepted == 1 then
			event.add_inventory_item(135, 1)
			event.add_inventory_item(145, 1)
			event.add_inventory_item(155, 1)
			event.add_inventory_item(165, 1)
			resume_step = 3
			vm.wait(3)
			item_count = event.get_item_count(246) or item_count
			if item_count == 0 then
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			resume_step = 4
			wait.frames(30)
			event.fade_in_screen(30)
		else
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 5
			vm.wait(5)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
		end
		return
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				accepted = play_steve_introduction_scene()
				return vm.continue_with(function()
					if accepted == 1 then
						event.add_inventory_item(135, 1)
						event.add_inventory_item(145, 1)
						event.add_inventory_item(155, 1)
						event.add_inventory_item(165, 1)
						resume_step = 3
						vm.wait(3)
						item_count = event.get_item_count(246) or item_count
						if item_count == 0 then
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						resume_step = 4
						wait.frames(30)
						event.fade_in_screen(30)
					else
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 5
						vm.wait(5)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
					end
					return
				end)
			end
			if resume_step <= 3 then
				wait.frames_skipping(30)
			end
			if resume_step <= 4 then
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_steve_introduction

--- Event 200, which map data, a script or the engine runs by number.
script[200] = palm_brinks_shop_house.exit_to_town

--- Plays the Steve introduction scene, grants the starting items and party member and enters the dungeon.
function script.cutscene_steve_introduction_then_enter_dungeon()
	local accepted: s32 = 0
	local item_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		resume_step = 1
		wait.frames(10)
		palm_brinks_shop_house.hide_house_owner()
		resume_step = 2
		accepted = play_steve_introduction_scene()
		if accepted == 1 then
			item_count = event.get_item_count(246) or item_count
			if item_count <= 0 then
				event.add_inventory_item(135, 1)
				event.add_inventory_item(145, 1)
				event.add_inventory_item(155, 1)
				event.add_inventory_item(165, 1)
				resume_step = 3
				vm.wait(3)
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			resume_step = 4
			wait.frames(30)
			resume_step = 5
			inventory.open_overflow_menu()
			event.skip_next_music_load()
			event.go_to_dungeon(0, 4, 520)
			resume_step = 6
			vm.wait(6)
			return
		else
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
		end
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				accepted = play_steve_introduction_scene()
				return vm.continue_with(function()
					if accepted == 1 then
						item_count = event.get_item_count(246) or item_count
						if item_count <= 0 then
							event.add_inventory_item(135, 1)
							event.add_inventory_item(145, 1)
							event.add_inventory_item(155, 1)
							event.add_inventory_item(165, 1)
							resume_step = 3
							vm.wait(3)
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						resume_step = 4
						wait.frames(30)
						resume_step = 5
						inventory.open_overflow_menu()
						event.skip_next_music_load()
						event.go_to_dungeon(0, 4, 520)
						resume_step = 6
						vm.wait(6)
						return
					else
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 7
						vm.wait(7)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
					end
					return
				end)
			end
			if resume_step <= 3 then
				wait.frames_skipping(30)
			end
			if resume_step <= 4 then
				cutscene.skip_step()
			end
			return 0
		end
		if resume_step <= 7 then
			return 0
		end
		return nil
	end)
end
script[500] = script.cutscene_steve_introduction_then_enter_dungeon

--- Plays the corridor scene with Steve and returns the player to the workshop with Steve out of the party.
function script.cutscene_steve_corridor()
	palm_brinks_shop_house.hide_house_owner()
	event.set_character_active(0, 26)
	event.set_character_active(0, 25)
	play_steve_corridor_scene()
	event.set_character_active(1, 25)
	event.initialize_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.set_character_active(1, 25)
	event.set_character_active(1, 26)
	event.attach_character_to_frame(25, "back", 26)
	event.set_party_member(2, 0)
	event.set_function_point_enabled("", "fc_event_e108c", 1)
	wait.frames(30)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end
script[510] = script.cutscene_steve_corridor

--- Plays the Flotsam rematch scene and enters the dungeon or returns to the workshop depending on the player's choice.
function script.cutscene_flotsam_rematch()
	local confirmed: s32 = 0
	palm_brinks_shop_house.hide_house_owner()
	event.set_character_active(0, 25)
	event.set_character_active(0, 26)
	confirmed = play_rematch_scene()
	if confirmed == 1 then
		event.set_save_flag(25, 1)
		event.set_party_member(2, 1)
		event.skip_next_music_load()
		event.go_to_dungeon(0, 4, 520)
	else
		event.set_save_flag(29, 1)
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
		event.set_function_point_enabled("", "fc_event_e108c", 1)
		vm.wait(2)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end
end
script[520] = script.cutscene_flotsam_rematch

--- Handles the player talking to a character in the workshop.
function script.on_talk()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		handle_talk_target()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				palm_brinks_shop_house.handle_talk_event_skippable()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.on_talk

return script
