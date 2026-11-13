--!strict
--- System script of the first dungeon: floor entry, treasure boxes, random circles, the geostone, monster talk and the Sphida mini-game.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local dungeon_system_scripts_camera = require("@lib/event/dungeon_system_scripts_camera")
local dungeon_system_scripts_character = require("@lib/event/dungeon_system_scripts_character")
local dungeon_system_scripts_cutscene = require("@lib/event/dungeon_system_scripts_cutscene")
local dungeon_system_scripts_item = require("@lib/event/dungeon_system_scripts_item")
local dungeon_system_scripts_message = require("@lib/event/dungeon_system_scripts_message")
local dungeon_system_scripts_minigame = require("@lib/event/dungeon_system_scripts_minigame")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Opens a message in a window and places its speech bubble on screen.
local function open_bubble_message(window: s32, message_id: any, screen_slot: s32, bubble_x: s32, bubble_y: s32)
	local open_result: s32 = 0
	open_result = event.open_message_window_3(window, message_id) or open_result
	event.set_message_bubble_screen_slot(window, screen_slot)
	event.place_message_bubble(window, bubble_x, bubble_y, bubble_x, bubble_y)
	return open_result
end

--- Polls the message window buttons for one frame, drives the speaker's mouth, and returns 0 for no input, 1 for advance or 2 for cancel.
local function poll_message_input(window: s32, allow_cancel_button: s32)
	local window_frame: s32 = 0
	local button_sound_enabled: s32 = 0
	local voice_playing: s32 = 0
	local window_state: s32 = 0
	local primary_pressed: s32 = 0
	local secondary_pressed: s32 = 0
	local cancel_pressed: s32 = 0
	window_frame = event.get_message_window_frame(window) or window_frame
	button_sound_enabled = 1
	if window_frame == 7 then
		button_sound_enabled = 0
	end
	if window_frame == 0 then
		button_sound_enabled = 0
	end
	voice_playing = event.is_voice_stream_playing() or voice_playing
	window_state = event.get_message_window_state(window) or window_state
	if window_state == 0 then
		return 0
	end
	if window_state == 1 then
		return 0
	end
	if window_state == 3 then
		if voice_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	if window_state == 4 then
		return 0
	end
	if window_state == 5 then
		if voice_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	primary_pressed = event.is_event_button_pressed(0) or primary_pressed
	secondary_pressed = event.is_event_button_pressed(1) or secondary_pressed
	cancel_pressed = event.is_event_button_pressed(2) or cancel_pressed
	if (if (if primary_pressed ~= 0 then 1 else secondary_pressed) ~= 0 then 1 else if allow_cancel_button ~= 0 then cancel_pressed else 0) ~= 0 then
		if button_sound_enabled ~= 0 then
			if secondary_pressed ~= 0 then
				event.play_message_sound(0)
			end
			if primary_pressed ~= 0 then
				event.play_message_sound(1)
			end
			if (if allow_cancel_button ~= 0 then cancel_pressed else 0) ~= 0 then
				event.play_message_sound(0)
			end
		end
		if window_state == 5 then
			event.advance_message_page(window)
			if voice_playing == 0 then
				event.trigger_mouth_texture_animation(1)
				event.trigger_mouth_motion(0)
			end
		end
		if window_state == 3 then
			if voice_playing == 0 then
				event.trigger_mouth_texture_animation(0)
				event.trigger_mouth_motion(2)
			end
			if (if allow_cancel_button ~= 0 then cancel_pressed else 0) ~= 0 then
				return 2
			else
				return 1
			end
		end
		if window_state ~= 5 and window_state ~= 3 then
			event.set_message_draw_speed(window, 0.0)
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
			if voice_playing ~= 0 then
				event.stop_voice_stream(1)
			end
		end
	end
	return 0
end

--- Animates the speaker's mouth and waits until the player dismisses the message, reporting whether it was cancelled.
local function wait_for_message_input(window: s32, allow_cancel_button: s32, cancelled: s32)
	local voice_playing: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local input_result: s32 = 0
	local frames_waited: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		voice_playing = event.is_voice_stream_playing() or voice_playing
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frames_waited = 0
		previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
		while true do
			if voice_playing ~= 0 then
				voice_state = event.get_voice_stream_state(1) or voice_state
				if previous_voice_state ~= 0 and voice_state == 0 then
					event.trigger_mouth_texture_animation(0)
					event.trigger_mouth_motion(2)
				end
				previous_voice_state = voice_state
			end
			input_result = poll_message_input(window, allow_cancel_button)
			if input_result ~= 0 then
				if input_result == 2 then
					cancelled = 1
				else
					cancelled = 0
				end
				frames_waited = vm.i32(frames_waited + 1)
				break
			else
				resume_point = 1
				vm.wait(1)
				frames_waited = vm.i32(frames_waited + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		voice_playing = event.is_voice_stream_playing() or voice_playing
		if voice_playing ~= 0 then
			event.stop_voice_stream(1)
		end
		return frames_waited, cancelled
	end, function(received: { any })
		if resume_point <= 1 then
			frames_waited = frames_waited + 1
			return frames_waited, cancelled
		end
		return nil, cancelled
	end)
end

--- Shows a message the player can dismiss or cancel and returns whether it was cancelled.
local function show_cancellable_message(window: s32, message_id: s32, screen_slot: s32, bubble_x: s32, bubble_y: s32, cancelled: s32)
	local frames_waited: s32 = 0
	local resume_point: number = 0
	local resumed_frames: s32 = 0
	return vm.guard(function()
		local _ = open_bubble_message(window, message_id, screen_slot, bubble_x, bubble_y)
		resume_point = 1
		local frames_result: s32
		frames_result, cancelled = wait_for_message_input(window, 1, cancelled)
		frames_waited = frames_result
		message.close(window)
		return cancelled
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				resumed_frames = received[1] :: number
				cancelled = received[2] :: number
			end
			frames_waited = resumed_frames
			message.close_skipping(window)
			return frames_waited, cancelled
		end
		return nil, cancelled
	end)
end

--- Plays the cutscene of a barrier rising out of the way with a sound effect.
local function play_gate_opening()
	local sound_bank: s32 = 0
	local map_part_group: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_bank
	map_part_group = event.get_triggered_event_data_2(9) or map_part_group
	event.attach_object_handle_to_map_part_3(0, map_part_group, "d01w10_5-m0")
	event.set_object_handle_visible(0, 1)
	map_part_group = event.get_triggered_event_data_2(9) or map_part_group
	event.attach_object_handle_to_map_part_3(0, map_part_group, "d01w10_4-m0")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	event.play_sound_effect(sound_bank, 2)
	wait.for_frame_count(20)
	event.move_object_sequence(0, 0.0, 80.0, 0.0, 60)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(0)
	event.finish_event()
end

--- Shows a message in a window, waits for the player to dismiss it and closes it.
local function show_message(window: s32, message_id: s32, screen_slot: s32, bubble_x: s32, bubble_y: s32)
	local cancelled: s32 = 0
	local _ = open_bubble_message(window, message_id, screen_slot, bubble_x, bubble_y)
	do
		local _: any
		_, cancelled = wait_for_message_input(window, 0, cancelled)
	end
	message.close(window)
end

--- Shows a message with a list of options and returns the option the player selected.
local function show_choice_message(window: s32, message_id: any, screen_slot: s32, bubble_x: s32, bubble_y: s32, option_count: s32, initial_selection: s32)
	local selected_option: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		local _ = open_bubble_message(window, message_id, screen_slot, bubble_x, bubble_y)
		resume_point = 1
		selected_option = dungeon_system_scripts_message.select_option(window, option_count, initial_selection, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return selected_option
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				selected_option = received[1] :: number
			end
			return selected_option
		end
		return nil
	end)
end

--- Plays the short cutscene of the player walking into the exit and fading out.
local function play_walk_into_exit()
	local trigger_x: f32 = 0
	local trigger_y: f32 = 0
	local trigger_z: f32 = 0
	local trigger_angle: f32 = 0
	local map_part_group: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	trigger_x, trigger_y, trigger_z, trigger_angle =
		object.get_trigger_placement(trigger_x, trigger_y, trigger_z, trigger_angle)
	event.set_event_world_coordinate(trigger_x, trigger_y, trigger_z, trigger_angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -20.0, 100.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.move_object_sequence(0, 0.0, -20.0, 37.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, 0.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, -30.0, 40)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_sound_track(0, 1)
	event.reset_object_sequence_dynamic_animation(0)
	event.start_crossfade(30)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(44.65, 9.01, 185.68)
	event.set_camera_sequence_look_at(9.77, 32.28, 31.49)
	wait.for_frame_count(60)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	camera.wait_until_done()
	map_part_group = event.get_triggered_event_data_2(9) or map_part_group
	event.attach_object_handle_to_map_part_3(0, map_part_group, "d01w10_4-m0")
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
end

--- Shows a message that closes by itself after a number of frames or when the player dismisses it.
local function show_timed_message(window: s32, max_frames: s32)
	local voice_playing: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local input_result: s32 = 0
	local frames_elapsed: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(window, 0)
		voice_playing = event.is_voice_stream_playing() or voice_playing
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frames_elapsed = 0
		previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
		while frames_elapsed < max_frames do
			if voice_playing ~= 0 then
				voice_state = event.get_voice_stream_state(1) or voice_state
				if previous_voice_state ~= 0 and voice_state == 0 then
					event.trigger_mouth_texture_animation(0)
					event.trigger_mouth_motion(2)
				end
				previous_voice_state = voice_state
			end
			input_result = poll_message_input(window, 0)
			if input_result ~= 0 then
				frames_elapsed = frames_elapsed + 1
				break
			else
				resume_point = 1
				vm.wait(1)
				frames_elapsed = frames_elapsed + 1
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		voice_playing = event.is_voice_stream_playing() or voice_playing
		if voice_playing ~= 0 then
			event.stop_voice_stream(1)
		end
		event.set_message_button_prompt(window, 1)
		message.close(window)
		return frames_elapsed
	end, function(received: { any })
		if resume_point <= 1 then
			frames_elapsed = frames_elapsed + 1
			message.close_skipping(window)
			return frames_elapsed
		end
		return nil
	end)
end

--- Opens a message and closes it automatically after the given number of frames.
local function show_timed_bubble_message(window: s32, message_id: s32, screen_slot: s32, bubble_x: s32, bubble_y: s32, duration_frames: s32)
	local _ = open_bubble_message(window, message_id, screen_slot, bubble_x, bubble_y)
	local _ = show_timed_message(window, duration_frames)
	event.set_message_bubble_screen_slot(window, 0)
end

--- Plays the opening cutscene of the first visit to the first floor, in which the player character talks on a receiver.
local function cutscene_first_arrival()
	local map_part_group: s32 = 0
	local sound_bank: s32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	local language: s32 = 0
	local texture_block: s32 = 0
	local rotation_y: f32 = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.set_message_window_mode(0, 7)
		map_part_group = event.get_triggered_event_data_2(9) or map_part_group
		event.attach_object_handle_to_map_part_3(31, map_part_group, "d01w09_3-m0")
		event.set_object_handle_position(31, 0.0, 0.0, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_bank
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			point_x = out1 or point_x
			point_y = out2 or point_y
			point_z = out3 or point_z
			point_angle = out4 or point_angle
		end
		point_angle = vm.f32(point_angle + vm.f32(1.5707964))
		if point_angle > vm.f32(3.1415927) then
			point_angle = vm.f32(point_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
		language = event.get_language() or language
		if language == 0 then
			event.load_message_file(0, 5, "event/e100/e100/e100.txt")
		else
			event.load_message_file(0, 5, "event/e100/e100/eng_e100.txt")
		end
		event.load_character_motion_pack(5, "event/e100/e100/e100_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		texture_block = event.load_event_image_4(5, "textures/event/e100/e100/e100_2d.json", 0) or texture_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e100_2d01", texture_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 256, 208)
		event.set_event_sprite_size(0, 256, 208)
		event.set_event_sprite_position(0, 384, 104)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e100_2d02", texture_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 256, 208)
		event.set_event_sprite_position(1, 384, 104)
		event.set_event_sprite_alpha_blend(1, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(5, 1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		map_part_group = event.get_triggered_event_data_2(9) or map_part_group
		event.attach_object_handle_to_map_part_3(1, map_part_group, "d01w09_3-m0")
		event.set_object_handle_visible(1, 1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.play_sound_effect(sound_bank, 1)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		event.set_camera_sequence_position(-58.59, 100.6, -45.13)
		event.set_camera_sequence_look_at(32.99, 106.26, -19.26)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-287.61, 29.51, -60.44, -89.85, 28.2, -4.59, 60, 0, 0.4)
		wait.for_frame_count(30)
		event.move_object_sequence(0, 87.0, 100.0, 0.0, 20)
		event.move_object_sequence(0, -80.0, 0.0, 0.0, 50)
		event.move_object_sequence(0, -130.0, 0.0, 0.0, 20)
		event.set_object_sequence_motion(0, "走り")
		wait.for_frame_count(30)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.4, 5)
		wait.for_frame_count(40)
		event.set_object_handle_footstep_sound(0, 6)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		camera.wait_until_done()
		wait.for_frame_count(20)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rotation_y = out2 or rotation_y
		end
		event.set_camera_sequence_look_at(-175.0, 30.0, 0.0)
		event.set_camera_sequence_angle_height_distance(-rotation_y, 47.61, 160.0)
		event.set_object_sequence_position(0, -130.0, 0.0, 0.0)
		event.move_object_sequence(0, -185.0, 0.0, 0.0, 90)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4)
		event.delay_camera_sequence_angle_track(30)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, -1.07, -4.02, 40.0)
		camera.wait_until_done()
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, 0)
		show_timed_bubble_message(0, -1, 8, 0, 0, 60)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-185.27, 25.12, -3.38)
		event.set_camera_sequence_look_at(-264.26, 21.67, 10.04)
		event.move_camera_sequence_look_at(-264.26, 21.67, -10.04, 60)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-247.99, 26.89, 0.0)
		event.set_camera_sequence_look_at(-182.45, 15.75, 0.0)
		event.set_object_sequence_motion(0, "レシーバーを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		wait.for_frame_count(30)
		event.set_character_active(1, 8)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-212.01, 19.91, -6.56)
		event.set_camera_sequence_look_at(-185.48, 23.15, 0.0)
		event.open_message_window_2(0, 10)
		show_message(0, -1, 8, 0, 0)
		event.set_object_sequence_motion(0, "レシーバーキョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, 20)
		show_message(0, -1, 8, 0, 0)
		object.wait_until_done(0)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-211.71, 19.55, 0.0)
		event.set_camera_sequence_look_at(-182.45, 22.68, 0.0)
		event.open_message_window_2(0, 30)
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(0, 40)
		show_message(0, -1, 8, 0, 0)
		event.move_camera_sequence_eased(-245.04, 24.27, -6.23, -182.11, 26.71, 10.92, 30, 0, 0.4)
		event.set_object_sequence_motion(0, "腰に手(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "腰に手L(レシーバー)", 4)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 128.0, 30)
		event.open_message_window_2(0, 50)
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(0, 60)
		show_message(0, -1, 8, 0, 0)
		event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 0.0, 30)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(5, 128.0, 128.0, 128.0, 128.0, 30)
		event.open_message_window_2(0, 70)
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(0, 80)
		show_message(0, -1, 8, 0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_object_sequence_color(5, 128.0, 128.0, 128.0, 0.0, 30)
		event.set_object_sequence_motion(0, "腰に手戻り(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		wait.for_frame_count(30)
		object.wait_until_done(0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_camera_sequence_position(-207.33, 19.91, 18.9)
		event.set_camera_sequence_look_at(-185.48, 23.15, 0.0)
		event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, 90)
		show_message(0, -1, 8, 0, 0)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "レシーバーをなおす", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーをなおすL", 4)
		wait.for_frame_count(50)
		event.set_character_active(0, 8)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-224.46, 10.19, -2.57)
		event.set_camera_sequence_look_at(-182.45, 16.24, -2.57)
		event.set_object_handle_visible(2, 1)
		event.set_object_handle_visible(3, 1)
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(29)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	map_part_group = event.get_triggered_event_data_2(9) or map_part_group
	event.attach_object_handle_to_map_part_3(31, map_part_group, "d01w09_3-m0")
	event.set_object_handle_position(31, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	event.stop_sound_effect(sound_bank, 1)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_event_image(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.set_dungeon_pause_flags(1, 0)
	sound.load_event_sound_effects()
	event.finish_event()
end

--- Plays the cutscene of the player character running into the floor, showing either the floor map or the dungeon logo.
local function cutscene_arrival(show_floor_map: s32)
	local sound_bank: s32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local map_part_group: s32 = 0
	local rotation_y: f32 = 0
	local resume_point: number = 0
	vm.section(function()
		resume_point = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_bank
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			point_x = out1 or point_x
			point_y = out2 or point_y
			point_z = out3 or point_z
			point_angle = out4 or point_angle
		end
		point_angle = vm.f32(point_angle + vm.f32(1.5707964))
		if point_angle > vm.f32(3.1415927) then
			point_angle = vm.f32(point_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
		if show_floor_map ~= 0 then
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 0, floor, previous_floor)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d00.json", 0)
			event.set_event_image_texture(0, "logo_d00")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_visible(1, 0)
			event.set_event_image_color(0, 128, 128, 128, 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		map_part_group = event.get_triggered_event_data_2(9) or map_part_group
		event.attach_object_handle_to_map_part_3(1, map_part_group, "d01w09_3-m0")
		event.set_object_handle_visible(1, 1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
		event.play_sound_effect(sound_bank, 1)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		event.set_camera_sequence_position(-58.59, 100.6, -45.13)
		event.set_camera_sequence_look_at(32.99, 106.26, -19.26)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-287.61, 29.51, -60.44, -89.85, 28.2, -4.59, 60, 0, 0.4)
		resume_point = 2
		wait.for_frame_count(30)
		if show_floor_map ~= 0 then
			event.fade_dungeon_map(1, 15)
		end
		event.move_object_sequence(0, 87.0, 100.0, 0.0, 20)
		event.move_object_sequence(0, -80.0, 0.0, 0.0, 50)
		event.move_object_sequence(0, -130.0, 0.0, 0.0, 20)
		event.set_object_sequence_motion(0, "走り")
		resume_point = 3
		wait.for_frame_count(20)
		if show_floor_map ~= 0 then
			event.set_dungeon_map_piece_moving(1)
		else
			event.fade_event_image(0, 1, 60)
		end
		resume_point = 4
		wait.for_frame_count(10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.4, 5)
		resume_point = 5
		wait.for_frame_count(40)
		event.set_object_handle_footstep_sound(0, 6)
		resume_point = 6
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		resume_point = 7
		camera.wait_until_done()
		resume_point = 8
		wait.for_frame_count(10)
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rotation_y = out2 or rotation_y
		end
		event.set_camera_sequence_look_at(-175.0, 30.0, 0.0)
		event.set_camera_sequence_angle_height_distance(-rotation_y, 47.61, 160.0)
		event.set_object_sequence_position(0, -130.0, 0.0, 0.0)
		event.move_object_sequence(0, -175.0, 0.0, 0.0, 40)
		event.set_object_sequence_motion(0, "歩き")
		resume_point = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		if show_floor_map ~= 0 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		resume_point = 10
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if resume_point <= 1 then
			point_angle = vm.f32(point_angle + vm.f32(1.5707964))
			local _ = point_angle > vm.f32(3.1415927)
			point_angle = vm.f32(point_angle - vm.f32(6.2831855))
			wait.skip_frame_count(30)
		end
		if resume_point <= 2 then
			wait.skip_frame_count(20)
		end
		if resume_point <= 3 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 4 then
			wait.skip_frame_count(40)
		end
		if resume_point <= 5 then
			cutscene.skip_command(0)
		end
		if resume_point <= 6 then
			wait.background_load_skipping()
		end
		if resume_point <= 7 then
			wait.skip_frame_count(10)
		end
		if resume_point <= 8 then
			cutscene.skip_command(0)
		end
		if resume_point <= 9 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	resume_point = 11
	vm.entry(11)
	event.fade_in_screen(0)
	if show_floor_map ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.delete_event_image(0)
	end
	event.stop_sound_effect(sound_bank, 1)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_map_part_3(1, map_part_group, "d01w09_3-m0")
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(1, 0)
	event.initialize_event()
	sound.load_event_sound_effects()
	event.finish_event()
end

--- Enters the dungeon: loads the floor chosen on the map and plays the matching arrival cutscene.
local function start_floor()
	local current_floor: s32 = 0
	local stage_id: s32 = 0
	local selected_floor: s32 = 0
	local save_flag_value: s32 = 0
	local first_arrival_seen: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		current_floor = event.get_dungeon_floor() or current_floor
		if current_floor == 21 then
			event.fade_out_screen(0)
			resume_point = 1
			vm.wait(1)
			event.skip_next_music_load()
			event.skip_next_map_sound_load()
			event.load_dungeon_map("s43")
			event.load_event_script("s43/s43.stb", 151)
			return
		end
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.open_dungeon_floor_map(0)
		resume_point = 2
		vm.wait(2)
		event.set_event_projection(524.9)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			stage_id = out2 or stage_id
			selected_floor = out3 or selected_floor
		end
		stage_id = 0
		event.set_dungeon_stage_id(stage_id)
		event.set_dungeon_floor(selected_floor)
		dungeon.increment_floor_counter(stage_id, selected_floor)
		if selected_floor == 0 then
			event.stop_music(0)
			resume_point = 3
			wait.for_frame_count(4)
			event.skip_next_music_load()
			event.skip_next_map_sound_load()
			event.load_dungeon_map("s43")
			event.load_event_script("s43/s43.stb", 151)
			return
		end
		if selected_floor == 8 then
			event.go_to_georama_edit(15, 100)
			return
		end
		if selected_floor == 4 then
			event.fade_out_screen(0)
			event.load_dungeon_map("s06")
			event.load_event_script("s06/s06.stb", 500)
			return
		end
		if selected_floor == 7 then
			event.skip_next_music_load()
			event.load_dungeon_map("d01b01")
			event.load_event_script("d01b01/d01b01.stb", 500)
			return
		end
		if selected_floor == 2 then
			save_flag_value = event.get_save_flag(4) or save_flag_value
			if save_flag_value == 0 then
				event.set_save_flag(4, 1)
				event.go_to_georama_edit(41, 500)
				resume_point = 4
				vm.wait(4)
				return
			end
		end
		event.load_dungeon_map("d01f01", "d01f01")
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		if selected_floor == 1 then
			first_arrival_seen = event.get_save_flag(2) or first_arrival_seen
			if first_arrival_seen == 0 then
				event.set_save_flag(2, 1)
				resume_point = 5
				cutscene_first_arrival()
			else
				resume_point = 6
				cutscene_arrival(0)
			end
		else
			resume_point = 7
			cutscene_arrival(1)
		end
		return
	end, function(received: { any })
		if resume_point <= 1 then
			return 0
		end
		if resume_point <= 3 then
			if resume_point <= 2 then
				stage_id = 0
				dungeon.increment_floor_counter_skipping(stage_id, selected_floor)
				wait.skip_frame_count(4)
			end
			return 0
		end
		if resume_point <= 4 then
			return 0
		end
		if resume_point <= 7 then
			if resume_point <= 5 then
				resume_point = 6
				cutscene_arrival(0)
				return vm.continue_with(function()
					return
				end)
			end
			if resume_point <= 6 then
				resume_point = 7
				cutscene_arrival(1)
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Handles the exit door: unlocks it with a key item, then offers to descend to the next floor, or refuses for characters 2 and 3.
local function interact_with_exit_door(door_flag_index: s32)
	local door_unlocked: s32 = 0
	local interaction_mode: s32 = 0
	local chose_use_item: s32 = 0
	local used_item_id: s32 = 0
	local active_character_id: s32 = 0
	local choice: any = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	local save_flag_value: s32 = 0
	event.set_character_motion(0, "立ち")
	door_unlocked = event.get_local_event_flag(door_flag_index) or door_unlocked
	event.set_dungeon_pause_flags(1, 1)
	if door_unlocked == 0 then
		interaction_mode = event.get_triggered_event_data_2(6) or interaction_mode
		if interaction_mode == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_draw_speed(0, 1)
			chose_use_item = show_cancellable_message(0, 0, 5, 256, 208, chose_use_item)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if chose_use_item == 1 then
				interaction_mode = 2
			end
			event.finish_event()
		end
		if interaction_mode == 2 then
			event.open_use_item_menu(337)
			vm.wait(2)
			used_item_id = vmhost.used_item() or used_item_id
			if used_item_id == 337 then
				event.set_local_event_flag(door_flag_index, 1)
				play_gate_opening()
			elseif used_item_id <= 0 then
				event.finish_event()
			else
				dungeon_system_scripts_cutscene.play_miss_gesture()
			end
		end
	else
		active_character_id = event.get_playable_character() or active_character_id
		if active_character_id == 2 or active_character_id == 3 then
			event.initialize_event()
			character.set_idle_motion()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character_id == 2 then
				show_message(0, 20, 5, 256, 208)
			else
				show_message(0, 21, 5, 256, 208)
			end
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		choice = show_choice_message(0, 10, 8, 256, 208, 2, 1)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		if choice == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			play_walk_into_exit()
			if floor == 1 then
				save_flag_value = event.get_save_flag(2) or save_flag_value
				if save_flag_value == 0 then
					event.set_save_flag(2, 1)
					event.go_to_georama_edit(1516, 151)
					vm.wait(9)
					return
				end
			end
			if floor == 5 then
				save_flag_value = event.get_save_flag(9) or save_flag_value
				if save_flag_value == 0 then
					event.set_save_flag(9, 1)
					event.go_to_georama_edit(38, 510)
					vm.wait(10)
					return
				end
			end
			event.finish_event()
			start_floor()
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays the conversation in which the player character takes out a receiver and talks on it.
local function speak_into_receiver()
	event.set_camera_sequence_position(-151.46, 20.36, 7.26)
	event.set_camera_sequence_look_at(-125.08, 23.15, -0.98)
	event.set_object_sequence_position(0, -123.65, -0.41, -1.34)
	event.set_object_sequence_rotation(0, 0.0, -1.53, 0.0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 128.0, 128.0, 128.0)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "我に返る", 6)
	event.open_message_window_2(0, 1020050)
	show_message(0, -1, 8, 0, 0)
	event.set_character_active(1, 8)
	event.set_object_sequence_motion(0, "レシーバーを取り出す", 6)
	event.wait_object_sequence_motion_end(0)
	object.wait_until_done(0)
	event.open_message_window_2(0, 1020060)
	show_message(0, -1, 8, 0, 0)
	event.set_object_sequence_motion(0, "レシーバーキョロキョロ", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.open_message_window_2(0, 1020070)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020080)
	show_message(0, -1, 8, 0, 0)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.open_message_window_2(0, 1020090)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020100)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020110)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020120)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020130)
	show_message(0, -1, 8, 0, 0)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.open_message_window_2(0, 1020140)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 1020150)
	show_message(0, -1, 8, 0, 0)
	wait.for_frame_count(20)
	event.set_object_sequence_motion(0, "レシーバーをなおす", 6)
	event.wait_object_sequence_motion_end(0)
	object.wait_until_done(0)
end

--- Plays the receiver briefing cutscene in the entrance room.
local function cutscene_receiver_briefing()
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			point_x = out1 or point_x
			point_y = out2 or point_y
			point_z = out3 or point_z
			point_angle = out4 or point_angle
		end
		point_angle = vm.f32(point_angle + vm.f32(1.5707964))
		if point_angle > vm.f32(3.1415927) then
			point_angle = vm.f32(point_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
		event.load_character_motion_pack(5, "event/e100/e102/e102_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_message_file(0, 5, "event/e100/e102/e102.txt")
		speak_into_receiver()
	end)
	event.cancel_drama_scene_skip()
	sound.load_event_sound_effects()
	event.fade_in_screen(50)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
end

--- Shows the message announcing an item or a stack of items obtained.
local function show_item_acquired(item_id: any, count: s32)
	local message_id: s32 = 0
	local system_sound_bank: s32 = 0
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	if count <= 0 then
		return
	end
	if count == 1 then
		message_id = 10
		event.set_message_item_name(1, 1, item_id)
	end
	if 1 < count then
		message_id = 11
		event.set_message_item_name(1, 1, item_id)
		event.set_message_number(1, 2, count)
	end
	system_sound_bank = event.get_system_sound_id() or system_sound_bank
	event.play_sound_effect(system_sound_bank, 18)
	show_message(1, message_id, 8, 0, 0)
end

--- Plays the treasure box opening sequence for one item and adds it to the inventory.
local function open_treasure_box_single(item_id: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	local lid_open: f32 = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(23, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
		point_angle = out4 or point_angle
	end
	event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
	vm.wait(1)
	event.add_inventory_item(item_id, 1)
	event.start_background_file_loads_3(item_id, 1, "effect/itemget.gltf")
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "effect/itemget.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "ゲット", 5)
	event.set_object_sequence_motion(1, "ゲット", 2)
	wait.for_frame_count(5)
	lid_open = dungeon_system_scripts_item.open_treasure_lid_fast(lid_open)
	event.load_item_model(5, item_id, "info", 13, 1)
	event.set_character_active(1, 13)
	event.attach_object_handle_to_character(0, 13)
	item_scale = inventory.get_weapon_display_scale(13, item_id, item_scale)
	event.set_object_handle_scale(0, item_scale, item_scale, item_scale)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -5.0, 0.0)
	event.delay_object_sequence_position_track(0, 4)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
	lid_open = inventory.open_treasure_box_lid(lid_open)
	camera.wait_until_done()
	show_item_acquired(item_id, 1)
	event.start_crossfade(10)
	event.set_dungeon_pause_flags(23, 0)
	event.set_character_active(1, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Plays the clown treasure box sequence where the player picks the big or small chest and receives one of two items.
local function open_clown_treasure_box(first_item: any, second_item: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_angle: f32 = 0
	local lid_open: f32 = 0
	local chosen_chest: any = 0
	local random_value: s32 = 0
	local swapped_item: any = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		first_item,
		1,
		second_item,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_27a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
		point_angle = out4 or point_angle
	end
	event.set_event_world_coordinate(point_x, point_y, point_z, point_angle)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(0, 12)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 5)
	event.load_character(5, "event/tbox/p00_27a.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(1, 13)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "出現", 5)
	lid_open = dungeon_system_scripts_item.open_treasure_lid_fast(lid_open)
	event.set_character_active(12)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(13)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	lid_open = inventory.open_treasure_box_lid(lid_open)
	wait.for_frame_count(10)
	event.set_character_active(0, 12)
	event.load_character(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.set_character_active(14)
	event.set_character_position(14, 0.0, 0.0, 0.0)
	event.set_character_rotation(14, 0.0, 0.0, 0.0)
	event.set_character_motion(14, "宝箱発生（右手）", 6)
	event.attach_character_to_frame(13, "s_pre", 14)
	event.load_character(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.set_character_active(15)
	event.set_character_position(15, 0.0, 0.0, 0.0)
	event.set_character_rotation(15, 0.0, 0.0, 0.0)
	event.set_character_motion(15, "宝箱出現（左手）", 6)
	event.attach_character_to_frame(13, "b_pre", 15)
	event.load_character(5, "event/tbox/r_box.gltf", "info", 18)
	event.set_character_active(18)
	event.set_character_position(18, 0.0, 0.0, 0.0)
	event.set_character_rotation(18, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "s_pre", 18)
	event.set_scene_character_type(18, 4)
	event.load_character(5, "event/tbox/l_box.gltf", "info", 19)
	event.set_character_active(19)
	event.set_character_position(19, 0.0, 0.0, 0.0)
	event.set_character_rotation(19, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "b_pre", 19)
	event.set_scene_character_type(19, 4)
	event.set_character_visible(18, 0)
	event.set_character_visible(19, 0)
	wait.for_frame_count(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	wait.for_frame_count(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	show_message(0, 2200, 8, 256, 208)
	show_message(0, 2210, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	local _ = open_bubble_message(0, 2220, 8, 0, 0)
	chosen_chest = dungeon_system_scripts_message.select_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_value = event.get_random_number_int(100) or random_value
	if vm.imod(random_value, 2) == 0 then
		swapped_item = first_item
		first_item = second_item
		second_item = swapped_item
	end
	event.load_item_model(5, first_item, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(16, first_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.load_item_model(5, second_item, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(17, second_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_chest == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.for_frame_count(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	object.wait_until_done(1)
	if chosen_chest == 0 then
		show_item_acquired(second_item, 1)
		event.add_inventory_item(second_item, 1)
	else
		show_item_acquired(first_item, 1)
		event.add_inventory_item(first_item, 1)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(17, 0)
	for index = 0, 7 do
		event.delete_character(12 + index)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Shows the hint that the circle button stops the spinning coin.
local function show_stop_button_hint()
	local language_code: s32 = 0
	event.set_message_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(1, "(O)でストップ")
	else
		event.open_message_window_2(1, "It stops with (O) button.")
	end
	open_bubble_message(1, -1, 15, 0, 0)
end

--- Shows a message bubble between two characters and waits for the player to dismiss it.
local function show_conversation_message(window: s32, message_id: any, speaker: any, listener: s32, unused_argument: any)
	local cancelled: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(window, 0)
	event.open_message_window_2(window, message_id)
	event.place_message_bubble(window, speaker, listener)
	do
		local _: any
		_, cancelled = wait_for_message_input(window, 0, cancelled)
	end
	message.close(window)
end

--- Turns the player and a monster toward each other, shows the monster's message and restores its pose.
local function talk_to_monster(monster_character: s32, message_id: s32, use_talk_camera: s32, restore_rotation: s32)
	local rot_y: f32 = 0
	local player_character: s32 = 0
	if restore_rotation ~= 0 then
		event.attach_object_handle_to_character(0, monster_character)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rot_y = out2 or rot_y
		end
	end
	player_character = event.get_player_character_slot() or player_character
	dungeon_system_scripts_character.face_each_other(player_character, monster_character, message_id, use_talk_camera)
	show_conversation_message(0, message_id, monster_character, player_character, 0)
	if restore_rotation ~= 0 then
		dungeon_system_scripts_character.turn_character_to_rotation(monster_character, rot_y)
	end
	event.set_character_motion(monster_character, "立ち")
	event.finish_event()
	if use_talk_camera ~= 0 then
		event.start_crossfade(10)
	end
end

--- Shows the message for the breakdown of the current playable character.
local function show_character_breakdown_message(character_id: s32)
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	show_message(1, vm.i32(60 + character_id), 8, 0, 0)
end

--- Plays the breakdown effect and music, shows the breakdown message and opens the character change menu for characters 2 and 3.
local function handle_character_breakdown()
	local active_character_id: s32 = 0
	local sound_bank: s32 = 0
	local music_number: s32 = 0
	local music_volume: f32 = 0
	local message_character_id: s32 = 0
	local is_e3_build: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character_id = event.get_playable_character() or active_character_id
	if active_character_id == 2 then
		event.set_character_motion(0, "故障", 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("ロボ故障")
		event.create_effect_work_buffer(5)
	end
	sound_bank = event.get_event_sound_bank(4) or sound_bank
	event.stop_sound_effect(sound_bank, 0)
	event.set_dungeon_pause_flags(17, 1)
	event.create_effect("ロボ故障")
	music_number = event.get_active_music_number() or music_number
	music_volume = vm.bits_float(event.get_music_master_volume()) or music_volume
	event.stop_music(0)
	event.start_background_file_loads_1("snd2/bgm/bg_060.sound.json")
	wait.for_frame_count(4)
	wait.background_load()
	event.load_music_pack(60)
	event.play_music(0)
	message_character_id = event.get_playable_character() or message_character_id
	show_character_breakdown_message(message_character_id)
	if active_character_id == 2 or active_character_id == 3 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.clear_effect_manager()
		event.open_dungeon_character_change_menu(-1)
		vm.wait(5)
	else
		is_e3_build = event.is_e3_version() or is_e3_build
		if is_e3_build == 1 then
			event.fade_out_screen(30)
			wait.for_frame_count(30)
			event.set_scene_exit_flag(1)
			return
		else
			event.run_dungeon_debug_command(0)
		end
	end
	event.stop_music(0)
	event.clear_effect_manager()
	event.set_dungeon_pause_flags(17, 1)
	wait.for_frame_count(4)
	event.load_music(music_number)
	event.play_music(0)
	event.set_music_master_volume(music_volume)
	event.play_sound_effect(sound_bank, 0)
	event.set_dungeon_pause_flags(17, 0)
	event.finish_event()
end

--- Plays the playable character's victory pose and the floor clear messages.
local function play_floor_clear_victory()
	local active_character_id: s32 = 0
	local is_e3_build: s32 = 0
	local stage_id: s32 = 0
	local sphida_camera_x: f32 = 0
	local sphida_camera_y: f32 = 0
	local sphida_camera_z: f32 = 0
	local final_camera_x: f32 = 0
	local final_camera_y: f32 = 0
	local final_camera_z: f32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		active_character_id = event.get_playable_character() or active_character_id
		character.set_idle_motion()
		if active_character_id == 0 then
			resume_point = 1
			dungeon_system_scripts_cutscene.play_max_victory()
		end
		if active_character_id == 1 then
			resume_point = 2
			dungeon_system_scripts_cutscene.play_monica_victory()
		end
		if active_character_id == 2 or active_character_id == 3 then
			resume_point = 3
			dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character_id)
		end
		is_e3_build = event.is_e3_version() or is_e3_build
		if is_e3_build ~= 1 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			event.get_dungeon_floor()
			if stage_id ~= 3 then
				minigame.set_up_sphida_course(0)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					sphida_camera_x = out1 or sphida_camera_x
					sphida_camera_y = out2 or sphida_camera_y
					sphida_camera_z = out3 or sphida_camera_z
				end
				event.set_camera_position(sphida_camera_x, sphida_camera_y, sphida_camera_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					sphida_camera_x = out1 or sphida_camera_x
					sphida_camera_y = out2 or sphida_camera_y
					sphida_camera_z = out3 or sphida_camera_z
				end
				event.set_camera_look_at(sphida_camera_x, sphida_camera_y, sphida_camera_z)
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				resume_point = 4
				show_message(0, 2100, 8, 0, 0)
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 0)
			end
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			final_camera_x = out1 or final_camera_x
			final_camera_y = out2 or final_camera_y
			final_camera_z = out3 or final_camera_z
		end
		event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			final_camera_x = out1 or final_camera_x
			final_camera_y = out2 or final_camera_y
			final_camera_z = out3 or final_camera_z
		end
		event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		resume_point = 5
		show_message(0, 2130, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 5 then
			if resume_point <= 1 then
				resume_point = 2
				dungeon_system_scripts_cutscene.play_monica_victory()
				return vm.continue_with(function()
					if active_character_id == 2 or active_character_id == 3 then
						resume_point = 3
						dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character_id)
					end
					is_e3_build = event.is_e3_version() or is_e3_build
					if is_e3_build ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								sphida_camera_x = out1 or sphida_camera_x
								sphida_camera_y = out2 or sphida_camera_y
								sphida_camera_z = out3 or sphida_camera_z
							end
							event.set_camera_position(sphida_camera_x, sphida_camera_y, sphida_camera_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								sphida_camera_x = out1 or sphida_camera_x
								sphida_camera_y = out2 or sphida_camera_y
								sphida_camera_z = out3 or sphida_camera_z
							end
							event.set_camera_look_at(sphida_camera_x, sphida_camera_y, sphida_camera_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_point = 4
							show_message(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					resume_point = 5
					show_message(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_point <= 2 then
				resume_point = 3
				dungeon_system_scripts_cutscene.play_follow_camera_victory(active_character_id)
				return vm.continue_with(function()
					is_e3_build = event.is_e3_version() or is_e3_build
					if is_e3_build ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								sphida_camera_x = out1 or sphida_camera_x
								sphida_camera_y = out2 or sphida_camera_y
								sphida_camera_z = out3 or sphida_camera_z
							end
							event.set_camera_position(sphida_camera_x, sphida_camera_y, sphida_camera_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								sphida_camera_x = out1 or sphida_camera_x
								sphida_camera_y = out2 or sphida_camera_y
								sphida_camera_z = out3 or sphida_camera_z
							end
							event.set_camera_look_at(sphida_camera_x, sphida_camera_y, sphida_camera_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_point = 4
							show_message(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_position(final_camera_x, final_camera_y, final_camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						final_camera_x = out1 or final_camera_x
						final_camera_y = out2 or final_camera_y
						final_camera_z = out3 or final_camera_z
					end
					event.set_camera_look_at(final_camera_x, final_camera_y, final_camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					resume_point = 5
					show_message(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_point <= 3 then
				dungeon_system_scripts_cutscene.noop(0)
				dungeon_system_scripts_message.finish_on_skip(0, 2100, 8, 0, 0)
			end
			if resume_point <= 4 then
				dungeon_system_scripts_message.finish_on_skip(0, 2130, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Returns 1 when the player cannot start Sphida, showing why, or 0 once a club is set up.
local function is_sphida_blocked()
	local active_character_id: s32 = 0
	local equipped_club: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		active_character_id = event.get_playable_character() or active_character_id
		if active_character_id ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_point = 1
			show_message(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_club = event.get_equipped_item(0, 0) or equipped_club
		if equipped_club ~= 10 and equipped_club ~= 11 and equipped_club ~= 12 and equipped_club ~= 13 and equipped_club ~= 14 then
			event.set_message_window_mode(0, 4)
			resume_point = 2
			show_message(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_club)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if resume_point <= 1 then
			return 1
		end
		if resume_point <= 2 then
			return 1
		end
		return nil
	end)
end

--- Restores the character and camera after a Sphida shot and offers the par message when the shots run out.
local function finish_sphida_shot(pin_hit: s32)
	local par_remaining: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1.0)
	event.start_crossfade(15)
	par_remaining = event.get_sphida_par() or par_remaining
	if pin_hit == 0 and par_remaining <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_look_at(camera_x, camera_y, camera_z)
		event.set_message_window_mode(0, 4)
		show_message(0, 2003, 8, 0, 0)
		event.reset_follow_camera(1)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, overriding the engine's default event.
function script.default_event() end

--- Runs the exit door interaction.
function script.examine_exit_door()
	interact_with_exit_door(0)
end
script[300] = script.examine_exit_door

--- Loads the first floor room and plays the receiver briefing cutscene.
function script.cutscene_receiver_room()
	event.initialize_event()
	event.load_dungeon_map("d01f01", "room_d01")
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	cutscene_receiver_briefing()
end
script[500] = script.cutscene_receiver_room

--- Loads the first floor room and plays the arrival cutscene with the dungeon logo.
function script.cutscene_arrival_in_room()
	event.initialize_event()
	event.load_dungeon_map("d01f01", "room_d01")
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	sound.load_event_sound_effects()
	cutscene_arrival(0)
end
script[510] = script.cutscene_arrival_in_room

--- Fades out and loads the s06 map.
function script.leave_to_s06()
	event.initialize_event()
	event.fade_out_screen(0)
	event.load_dungeon_map("s06")
	event.load_event_script("s06/s06.stb", 500)
	vm.wait(1)
	sound.load_event_sound_effects()
end
script[520] = script.leave_to_s06

--- Event 521, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_521() end
script[521] = script.ignore_event_521

script.start_floor = start_floor
script[1000] = script.start_floor

--- Opens the treasure box, either with one item or as the clown box with two items.
function script.treasure_box()
	local active_character_id: s32 = 0
	local move_type: s32 = 0
	local first_item: s32 = 0
	local second_item: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	event.set_character_active(0, 0)
	active_character_id = event.get_playable_character() or active_character_id
	if active_character_id == 2 then
		move_type = event.get_player_move_type() or move_type
		if move_type == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if move_type == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.get_treasure_box_item()
		first_item = out1 or first_item
		second_item = out2 or second_item
	end
	if second_item <= -1 then
		open_treasure_box_single(first_item)
	else
		open_clown_treasure_box(first_item, second_item)
	end
end

--- Spins a coin over the random circle, stops it on a result and applies a good or bad random effect, or pushes characters 2 and 3 away.
function script.random_circle()
	local active_character_id: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local push_angle: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local sound_bank: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local coin_side: s32 = 0
	local frame_index: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local camera_angle: f32 = 0
	local stop_frame: s32 = 0
	local target_angle: f32 = 0
	local random_value: s32 = 0
	local flip_threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	event.initialize_event()
	active_character_id = event.get_playable_character() or active_character_id
	if active_character_id == 2 or active_character_id == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if active_character_id == 2 then
			show_message(0, 22, 8, 0, 0)
		else
			show_message(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		push_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or push_angle
		player_x = vm.f32(vm.f32(vm.sin(push_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(push_angle) * 25.0) + circle_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		center_x = out1 or center_x
		center_y = out2 or center_y
		center_z = out3 or center_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(center_x, center_y + 30.0, center_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	character.set_idle_motion()
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	wait.background_load()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_bank
	event.start_background_file_loads_2("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "event/dng/ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, center_x, center_y, center_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "event/dng/randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, center_x, center_y - 30.0, center_z)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, center_x, center_y + 40.0, center_z, 30, 2, 0.5)
	frame_index = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if frame_index == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if frame_index == 30 then
			show_stop_button_hint()
		end
		if (if frame_index >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_index > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(7)
			break
		else
			frame_index = frame_index + 1
			vm.wait(8)
		end
	end
	message.close_second_window()
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
	camera_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_angle
	stop_frame = 0
	stop_frame = event.get_random_number_int(10) or stop_frame
	stop_frame = vm.i32(stop_frame + 4)
	frame_index = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if frame_index >= stop_frame then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			target_angle = camera_angle
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				coin_side = 0
				break
			end
			target_angle = vm.f32(camera_angle - vm.f32(3.1415927))
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				coin_side = 1
				break
			end
		end
		frame_index = vm.i32(frame_index + 1)
	end
	wait.for_frame_count(20)
	random_value = event.get_random_number_int(10) or random_value
	if random_value < 6 then
		random_value = event.get_random_number_int(10) or random_value
		if coin_side == 0 then
			flip_threshold = 2
		else
			flip_threshold = 4
		end
		if random_value < flip_threshold then
			camera_angle = vm.f32(camera_angle + vm.f32(3.14))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 8)
			if coin_side == 0 then
				coin_side = 1
			else
				coin_side = 0
			end
			wait.for_frame_count(10)
		else
			random_value = event.get_random_number_int(10) or random_value
			if random_value < 1 then
				camera_angle = vm.f32(camera_angle + vm.f32(3.14))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 6)
				camera_angle = vm.f32(camera_angle + vm.f32(1.57))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 3)
				camera_angle = vm.f32(camera_angle + vm.f32(1.57))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	camera_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, camera_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_index = 0
	effect_id = event.get_random_circle_effect(coin_side) or effect_id
	if coin_side == 0 then
		event.play_sound_effect(sound_bank, 1)
		while frame_index < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			frame_index = frame_index + 1
			vm.wait(13)
		end
		show_message(0, 2310, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
		if effect_id == 1 then
			show_message(0, 2311, 8, 0, 0)
		end
		if effect_id == 2 then
			show_message(0, 2312, 8, 0, 0)
		end
		if effect_id == 3 then
			show_message(0, 2313, 8, 0, 0)
		end
		if effect_id == 4 then
			event.place_treasure_box(center_x, center_y, center_z, camera_angle, 294)
			show_message(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while frame_index < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			frame_index = frame_index + 1
			vm.wait(19)
		end
		show_message(0, 2320, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
		if effect_id == 5 then
			if active_character_id == 0 or active_character_id == 2 then
				show_message(0, 2321, 8, 0, 0)
			end
			if active_character_id == 1 or active_character_id == 3 then
				show_message(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_character_id == 0 then
				show_message(0, 2323, 8, 0, 0)
			end
			if active_character_id == 1 or active_character_id == 3 then
				show_message(0, 2324, 8, 0, 0)
			end
			if active_character_id == 2 then
				show_message(0, 2325, 8, 0, 0)
			end
		end
		if effect_id == 8 then
			show_message(0, 2326, 8, 0, 0)
		end
		if effect_id == 9 then
			show_message(0, 2327, 8, 0, 0)
		end
		if effect_id == 10 then
			show_message(0, 2328, 8, 0, 0)
		end
		if effect_id == 11 then
			show_message(0, 2329, 8, 0, 0)
		end
		if effect_id == 12 then
			show_message(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(center_x, center_y, center_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the sequence of the playable character using the geostone and obtaining its item.
function script.geostone()
	local active_character_id: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local stand_x: f32 = 0
	local stand_y: f32 = 0
	local stand_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	event.initialize_event()
	active_character_id = event.get_playable_character() or active_character_id
	if active_character_id == 2 or active_character_id == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if active_character_id == 2 then
			show_message(0, 22, 8, 0, 0)
		else
			show_message(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	if active_character_id == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_character_id == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
	event.set_dungeon_pause_flags(17, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		stand_x = out1 or stand_x
		stand_y = out2 or stand_y
		stand_z = out3 or stand_z
	end
	event.copy_vector(stand_x, stand_y, stand_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(stand_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_character_id == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_character_id == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	stand_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	stand_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, stand_x, stand_y, stand_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_character_id == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, stand_x, stand_y + 36.0, stand_z)
	end
	if active_character_id == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + stand_x)
		effect_y = vm.f32(stand_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + stand_z)
		event.set_character_position(12, effect_x, effect_y, effect_z)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.for_frame_count(16)
	event.play_sound_effect(sound_bank, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	facing_angle = event.get_direction_angle(stand_x, stand_y, stand_z, camera_x, camera_y, camera_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.for_frame_count(20)
	event.play_sound_effect(sound_bank, 1)
	object.wait_until_done(0)
	show_item_acquired(358, 1)
	event.start_crossfade(10)
	if active_character_id == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, start_x, start_y, start_z)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.finish_event()
end

--- Starts the conversation with a monster that can be talked to.
function script.monster_talk()
	local monster_character: s32 = 0
	local message_index: s32 = 0
	do
		local out1, out2 = event.get_monster_talk_data_2()
		monster_character = out1 or monster_character
		message_index = out2 or message_index
	end
	talk_to_monster(monster_character, vm.i32(message_index + 1000), 1, 1)
end

--- Event 1200, which map data, a script or the engine runs by number.
script.handle_character_breakdown = handle_character_breakdown
script[1200] = script.handle_character_breakdown

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = play_floor_clear_victory

--- Event 2000, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_2000() end
script[2000] = script.ignore_event_2000

--- Runs a Sphida shot: aims, charges the swing, simulates the ball flight and handles the result.
function script.sphida_shot()
	local texture_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local loft_degrees: f32 = 0
	local shot_power: f32 = 0
	local club_control_factor: f32 = 0
	local level: s32 = 0
	local roll_velocity_x: f32 = 0
	local curve_angle: f32 = 0
	local roll_velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local pin_hit: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local free_flight_height: f32 = 0
	local fall_limit_y: f32 = 0
	local ball_lost_counter: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local ahead_x: f32 = 0
	local ahead_y: f32 = 0
	local ahead_z: f32 = 0
	local remaining_distance: f32 = 0
	local length: f32 = 0
	local collision_id: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local frame_count: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local par_remaining: s32 = 0
	local relocate_answer: any = 0
	vm.wait(1)
	event.initialize_event()
	character.set_idle_motion()
	event.set_character_motion(0, "立ち")
	if is_sphida_blocked() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_3(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	ball_x, ball_y, ball_z, aim_angle = dungeon_system_scripts_minigame.place_character_at_ball(ball_x, ball_y, ball_z, aim_angle)
	dungeon_system_scripts_camera.place_camera_behind_character(aim_angle)
	event.set_sphida_status_panel_visible(1)
	loft_degrees = 12.5
	event.set_sphida_carry_angle(vm.f32(loft_degrees * vm.f32(3.1415927)) / 180.0)
	shot_power, club_control_factor, level = minigame.get_equipped_club_definition(shot_power, club_control_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		roll_velocity_x = out1 or roll_velocity_x
		curve_angle = out2 or curve_angle
		roll_velocity_z = out3 or roll_velocity_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local aim_cancelled: s32
		aim_cancelled, aim_angle, loft_degrees = dungeon_system_scripts_minigame.run_aim_phase(aim_angle, loft_degrees, texture_bank)
		if aim_cancelled ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_character_position(0, player_x, player_y, player_z)
			finish_sphida_shot(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local gauge_cancelled: s32
		gauge_cancelled, shot_power, aim_angle, curve_angle, roll_velocity_x, level = dungeon_system_scripts_minigame.run_shot_power_gauge(shot_power, texture_bank, aim_angle, curve_angle, roll_velocity_x, sound_bank, level)
		if gauge_cancelled == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	pin_hit = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait.for_frame_count(10)
	end
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.for_frame_count(25)
		if level ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.for_frame_count(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.for_frame_count(39)
		if level == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if level == 4 then
		wait.for_frame_count(50)
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
		event.set_character_position(0, player_x, player_y, player_z)
		finish_sphida_shot(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	shot_power = minigame.scale_by_club_power(shot_power)
	loft_degrees = vm.f32(vm.f32(loft_degrees * vm.f32(3.1415927)) / 180.0)
	shot_power = vm.f32(shot_power - vm.f32(shot_power * loft_degrees))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(loft_degrees)))
	velocity_y = vm.f32(shot_power * vm.sin(loft_degrees))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(loft_degrees)))
	curve_angle = vm.f32(vm.f32(curve_angle * vm.f32(3.1415927)) / 2.0)
	roll_velocity_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_control_factor) * roll_velocity_x) * vm.f32(0.4))
	roll_velocity_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_control_factor) * roll_velocity_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	free_flight_height = 180.0
	fall_limit_y = -50.0
	ball_lost_counter = 0
	level = 0
	sound_cooldown = 0
	frame_count = 0
	while true do
		if ball_y >= free_flight_height then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_id = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_id
			if level == 1 and collision_id >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + roll_velocity_x)
				velocity_z = vm.f32(velocity_z + roll_velocity_z)
				roll_velocity_x = vm.f32(roll_velocity_x * vm.f32(0.8))
				roll_velocity_z = vm.f32(roll_velocity_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_angle ~= 0.0 then
			loft_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_degrees
			loft_degrees = vm.f32(loft_degrees + curve_angle)
			loft_degrees = event.wrap_angle(loft_degrees) or loft_degrees
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(loft_degrees) / 10.0) * club_control_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(loft_degrees) / 10.0) * club_control_factor))
		end
		length = event.get_vector_length(roll_velocity_x, 0.0, roll_velocity_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(roll_velocity_x, 0.0, roll_velocity_z) or speed
			loft_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + roll_velocity_x, previous_y, previous_z + roll_velocity_z) or loft_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, loft_degrees, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, loft_degrees, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			loft_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, loft_degrees, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, loft_degrees, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		loft_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_degrees
		ahead_x = vm.f32(vm.sin(vm.f32(loft_degrees - vm.f32(1.5707964))) * 3.0)
		ahead_z = vm.f32(vm.cos(vm.f32(loft_degrees - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - ahead_x,
			ball_y,
			ball_z - ahead_z,
			vm.f32(ball_x + ahead_x) + ahead_x,
			ball_y,
			vm.f32(ball_z + ahead_z) + ahead_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(ahead_x, ahead_y, ahead_z)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2, out3 = event.scale_vector(ahead_x, ahead_y, ahead_z, 3.0)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2 =
				event.get_segment_collision_10(0, previous_x, previous_y, previous_z, ball_x + ahead_x, ball_y + ahead_y, ball_z + ahead_z, 0)
			collision_id = out1 or collision_id
			surface_type = out2 or surface_type
		end
		if collision_id >= 0 and surface_type == 1 then
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + ahead_x, ball_y + ahead_y, ball_z + ahead_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
		end
		while collision_id >= 0 do
			curve_angle = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
				sound_cooldown = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			length = event.get_vector_length(previous_x, previous_y, previous_z) or length
			length = vm.f32(remaining_distance - length)
			if length <= 0.0 then
				break
			else
				remaining_distance = length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(roll_velocity_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(roll_velocity_z * 2.0)
					roll_velocity_x = vm.f32(roll_velocity_x * vm.f32(0.2))
					roll_velocity_z = vm.f32(roll_velocity_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						roll_velocity_x = 0.0
						roll_velocity_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9)) + velocity_x)
				velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58)) + velocity_y)
				velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9)) + velocity_z)
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(ahead_x, ahead_y, ahead_z)
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
				end
				do
					local out1, out2, out3 = event.scale_vector(ahead_x, ahead_y, ahead_z, 3.0)
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, length)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, normal_x, normal_y, normal_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + ahead_x,
						ball_y + ahead_y,
						ball_z + ahead_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_id = out7 or collision_id
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
			surface_type = out8 or surface_type
		end
		if collision_id >= 0 then
			curve_angle = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.9))
				velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
				velocity_z = vm.f32(velocity_z * vm.f32(0.9))
				velocity_x = vm.f32(velocity_x + vm.f32(roll_velocity_x * 2.0))
				velocity_z = vm.f32(velocity_z + vm.f32(roll_velocity_z * 2.0))
				roll_velocity_x = vm.f32(roll_velocity_x * vm.f32(0.2))
				roll_velocity_z = vm.f32(roll_velocity_z * vm.f32(0.2))
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 20
				end
			end
			length = event.get_vector_length(roll_velocity_x, 0.0, roll_velocity_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if not (surface_type == 6) then
					break
				end
				ball_lost_counter = 1
				break
			end
		end
		if ball_y < -500.0 then
			ball_lost_counter = 1
			break
		elseif frame_count >= 300 then
			ball_lost_counter = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			x = vm.f32(pin_x - ball_x)
			y = vm.f32(pin_y - ball_y)
			z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					pin_hit = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), pin_distance))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, x, y, z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					pin_hit = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, pin_distance))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, x, y, z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
				end
			end
			event.set_character_position(8, ball_x, ball_y, ball_z)
			event.set_character_position(9, ball_x, ball_y, ball_z)
			do
				local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			if ball_y <= fall_limit_y then
				event.set_follow_camera_following(0)
				if ball_lost_counter >= 30 then
					if ball_lost_counter >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				ball_lost_counter = ball_lost_counter + 1
			elseif frame_count >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				camera_angle = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or camera_angle
				event.set_follow_camera_angle(camera_angle)
				event.set_follow_camera_target_alternate(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			frame_count = frame_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	vm.wait(16)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if ball_lost_counter == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		if pin_hit == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			frame_count = 0
			while frame_count < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
				vm.wait(17)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame_count = 0
			while frame_count < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
				vm.wait(18)
			end
			event.set_character_active(0, 11)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, loft_degrees, 294)
			wait.for_frame_count(54)
			wait.for_frame_count(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_bank
			event.stop_music(0)
			event.play_sound_effect(sound_bank, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
			event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_size(0, 254, 54)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.for_frame_count(90)
			vm.wait(23)
			event.play_music(0)
			event.set_character_position(0, player_x, player_y, player_z)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		else
			par_remaining = event.get_sphida_par() or par_remaining
			if par_remaining >= 2 then
				event.set_message_window_mode(0, 5)
				event.set_message_selection_top_line(0, 0)
				relocate_answer = show_choice_message(0, 2002, 8, 256, 208, 2, 0)
				vm.wait(25)
				if relocate_answer == 0 then
					do
						local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
						collision_id = out1 or collision_id
						player_x = out2 or player_x
						player_y = out3 or player_y
						player_z = out4 or player_z
					end
					if collision_id == 0 then
						do
							local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
							player_x = out1 or player_x
							player_y = out2 or player_y
							player_z = out3 or player_z
						end
					end
					do
						local out1, out2, out3 = event.get_sphida_pin_position()
						pin_x = out1 or pin_x
						pin_y = out2 or pin_y
						pin_z = out3 or pin_z
					end
					speed = event.get_distance_between(player_x, player_y, player_z, pin_x, pin_y, pin_z) or speed
					if speed < 40.0 then
						loft_degrees = event.get_random_number(6.2831855) or loft_degrees
						loft_degrees = vm.f32(loft_degrees - vm.f32(3.1415927))
						player_x = vm.f32(player_x + vm.f32(vm.sin(loft_degrees) * 50.0))
						player_z = vm.f32(player_z + vm.f32(vm.cos(loft_degrees) * 50.0))
					else
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(player_x, player_y, player_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_id = out4 or collision_id
						end
						frame_count = 0
						while collision_id >= 0 do
							do
								local out1, out2, out3 = event.copy_vector(player_x, player_y, player_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 32.0)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
								player_x = out1 or player_x
								player_y = out2 or player_y
								player_z = out3 or player_z
							end
							do
								local out1, out2, out3 = event.add_vectors(player_x, player_y, player_z, previous_x, previous_y, previous_z)
								player_x = out1 or player_x
								player_y = out2 or player_y
								player_z = out3 or player_z
							end
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(player_x, player_y, player_z)
								hit_x = out1 or hit_x
								hit_y = out2 or hit_y
								hit_z = out3 or hit_z
								collision_id = out4 or collision_id
							end
							frame_count = frame_count + 1
							if frame_count > 6 then
								break
							end
						end
					end
					aim_angle = event.get_direction_angle(player_x, player_y, player_z, ball_x, ball_y, ball_z) or aim_angle
					event.set_character_position(0, player_x, player_y, player_z)
					event.set_character_rotation(0, 0.0, aim_angle, 0.0)
					event.set_camera_look_at(player_x, player_y + 30.0, player_z)
					aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
					aim_angle = event.wrap_angle(aim_angle) or aim_angle
					player_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + player_x)
					player_y = vm.f32(player_y + 30.0)
					player_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + player_z)
					event.set_camera_position(player_x, player_y, player_z)
					event.reset_follow_camera(0)
				else
					event.set_character_position(0, player_x, player_y, player_z)
				end
			else
				event.set_character_position(0, player_x, player_y, player_z)
			end
		end
	else
		event.play_sound_effect(sound_bank, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		object.wait_until_done(0)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_sphida_ball_position(ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(8, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(9, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.release_camera_sequence_follow_object()
	end
	if pin_hit == 1 then
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
	else
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
	end
	finish_sphida_shot(pin_hit)
end

--- Asks whether to move the ball to the player's position and does so when confirmed.
function script.sphida_near_ball()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.set_idle_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = show_choice_message(0, 2004, 8, 256, 208, 2, 0)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Fades out, switches to the first playable character and loads the first dungeon's boss floor.
function script.enter_boss_floor()
	event.initialize_event()
	event.fade_out_screen(0)
	event.set_playable_character(0)
	event.skip_next_music_load()
	event.load_dungeon_map("d01b01")
	event.load_event_script("d01b01/d01b01.stb", 500)
	vm.wait(1)
end
script[5000] = script.enter_boss_floor

return script
