--!strict
--- Message window helpers for the dungeon system scripts: showing text, waiting for input and picking options.

local vm = require("@lib/vm")
local dungeon_system_scripts = vm.module("@lib/event/dungeon_system_scripts")
local dungeon_system_scripts_camera = vm.module("@lib/event/dungeon_system_scripts_camera")
local message = vm.module("@lib/event/message")

local dungeon_system_scripts_message = {}

--- Opens a message and returns the option the player selects from it.
function dungeon_system_scripts_message.ask_option(window: s32, message_id: any, open_mode: s32, position_x: s32, position_y: s32, option_count: s32, initial_selection: s32)
	local selection: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		local _ = message.open(window, message_id, open_mode, position_x, position_y)
		resume_step = 1
		selection = dungeon_system_scripts_message.select_option(window, option_count, initial_selection, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return selection
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				selection = received[1] :: number
			end
			return selection
		end
		return nil
	end)
end

--- Finishes a message that was interrupted by a scene skip by reopening it and waiting for its input.
function dungeon_system_scripts_message.finish_on_skip(window: s32, message_id: s32, open_mode: s32, position_x: s32, position_y: s32)
	local was_confirmed: s32 = 0
	local _ = message.open_skipping(window, message_id, open_mode, position_x, position_y)
	do
		local _: any
		_, was_confirmed = dungeon_system_scripts_message.skip_wait_for_advance(window, 0, was_confirmed)
	end
	message.close_skipping(window)
end

--- Opens the hint window saying the shot stops with the circle button in the current language.
function dungeon_system_scripts_message.open_stop_hint()
	local language_code: s32 = 0
	event.set_message_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(1, "(O)でストップ")
	else
		event.open_message_window_2(1, "It stops with (O) button.")
	end
	message.open(1, -1, 15, 0, 0)
end

--- Opens the Japanese hint window saying the shot stops with the circle button.
function dungeon_system_scripts_message.open_stop_hint_japanese()
	event.set_message_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	event.open_message_window_2(1, "(O)でストップ")
	message.open(1, -1, 15, 0, 0)
end

--- Returns -1, 0 or 1 for the analog stick direction along the option axis of a message window.
function dungeon_system_scripts_message.read_stick_direction(window: any)
	local window_frame: s32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	window_frame = event.get_message_window_frame(window) or window_frame
	do
		local out1, out2, _, _ = event.get_analog_sticks_4()
		stick_x = out1 or stick_x
		stick_y = out2 or stick_y
	end
	if window_frame == 5 then
		if stick_x < -0.5 then
			return -1
		end
		if 0.5 < stick_x then
			return 1
		end
	else
		if stick_y < -0.5 then
			return -1
		end
		if 0.5 < stick_y then
			return 1
		end
	end
	return 0
end

--- Runs the option selection loop of a message window and returns the chosen index or -1 when cancelled.
function dungeon_system_scripts_message.select_option(window: any, option_count: any, selection: any, allow_cancel: s32)
	local top_line: s32 = 0
	local buttons_pressed: s32 = 0
	local previous_direction: s32 = 0
	local stick_direction: s32 = 0
	local step: s32 = 0
	local cancel_pressed: s32 = 0
	local confirm_pressed: s32 = 0
	local window_frame: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		top_line = event.get_message_selection_top_line(window) or top_line
		event.set_message_draw_speed(window, 0.0)
		step = 0
		stick_direction = 0
		previous_direction = 0
		event.set_message_selection(window, -1)
		event.set_message_selection(window, selection)
		resume_step = 1
		dungeon_system_scripts_message.wait_until_window_ready(window)
		while true do
			step = 0
			stick_direction = dungeon_system_scripts_message.read_stick_direction(window)
			if previous_direction == 0 and stick_direction == -1 then
				event.play_message_sound(2)
				step = -1
			end
			if previous_direction == 0 and stick_direction == 1 then
				event.play_message_sound(2)
				step = 1
			end
			previous_direction = stick_direction
			cancel_pressed = event.is_event_button_pressed(0) or cancel_pressed
			confirm_pressed = event.is_event_button_pressed(1) or confirm_pressed
			buttons_pressed = event.get_buttons_pressed() or buttons_pressed
			window_frame = event.get_message_window_frame(window) or window_frame
			if window_frame == 5 then
				if bit32.band(buttons_pressed, 32768) ~= 0 then
					event.play_message_sound(2)
					step = -1
				end
				if bit32.band(buttons_pressed, 8192) ~= 0 then
					event.play_message_sound(2)
					step = 1
				end
			else
				if bit32.band(buttons_pressed, 4096) ~= 0 then
					event.play_message_sound(2)
					step = -1
				end
				if bit32.band(buttons_pressed, 16384) ~= 0 then
					event.play_message_sound(2)
					step = 1
				end
			end
			if confirm_pressed ~= 0 then
				event.play_message_sound(0)
				resume_step = 2
				vm.wait(2)
				break
			else
				if cancel_pressed ~= 0 then
					event.play_message_sound(1)
					resume_step = 3
					vm.wait(3)
					if allow_cancel == 0 then
						message.close(window)
						return -1
					end
				end
				if step == 1 then
					if selection < vm.wrap(vm.wrap(option_count - 1) + top_line) then
						selection = vm.wrap(selection + 1)
					else
						selection = vm.wrap(vm.wrap(option_count - 1) + top_line)
					end
				end
				if step == -1 then
					if top_line < selection then
						selection = selection - 1
					else
						selection = top_line
					end
				end
				event.set_message_selection(window, selection)
				resume_step = 4
				vm.wait(4)
			end
		end
		message.close(window)
		return selection
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				step = 0
				stick_direction = message.get_stick_direction_skipping(window)
				step = -1
				step = 1
				local _ = previous_direction == 0
				local _ = previous_direction == 0
				previous_direction = stick_direction
				step = -1
				step = 1
				step = -1
				step = 1
			end
			message.close_skipping(window)
			return -1
		end
		if resume_step <= 4 then
			message.close_skipping(window)
			return selection
		end
		return nil
	end)
end

--- Opens a message, waits until the player dismisses it and returns the frames waited and the confirmation flag.
function dungeon_system_scripts_message.show_and_count_frames(window: s32, message_id: s32, open_mode: s32, position_x: s32, position_y: s32, was_confirmed: s32)
	local frames_waited: s32 = 0
	local resume_step: number = 0
	local resumed_frames: s32 = 0
	return vm.guard(function()
		local _ = message.open(window, message_id, open_mode, position_x, position_y)
		resume_step = 1
		local waited_frames: s32
		waited_frames, was_confirmed = dungeon_system_scripts_message.wait_for_advance(window, 1, was_confirmed)
		frames_waited = waited_frames
		message.close(window)
		return was_confirmed
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				resumed_frames = received[1] :: number
				was_confirmed = received[2] :: number
			end
			frames_waited = resumed_frames
			message.close_skipping(window)
			return frames_waited, was_confirmed
		end
		return nil, was_confirmed
	end)
end

--- Opens a message, waits until the player dismisses it and closes the window.
function dungeon_system_scripts_message.show_and_wait(window: s32, message_id: s32, open_mode: s32, position_x: s32, position_y: s32)
	local was_confirmed: s32 = 0
	local _ = message.open(window, message_id, open_mode, position_x, position_y)
	do
		local _: any
		_, was_confirmed = dungeon_system_scripts_message.wait_for_advance(window, 0, was_confirmed)
	end
	message.close(window)
end

--- Opens a speech bubble message over a character and waits until it is dismissed.
function dungeon_system_scripts_message.show_bubble(window: s32, text: any, speaker_character: any, listener_character: s32, unused_value: any)
	local was_confirmed: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(window, 0)
	event.open_message_window_2(window, text)
	event.place_message_bubble(window, speaker_character, listener_character)
	do
		local _: any
		_, was_confirmed = dungeon_system_scripts_message.wait_for_advance(window, 0, was_confirmed)
	end
	message.close(window)
end

--- Shows the system message that belongs to the playable character.
function dungeon_system_scripts_message.show_character_text(playable_character: s32)
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	dungeon_system_scripts_message.show_and_wait(1, vm.i32(60 + playable_character), 8, 0, 0)
end

--- Plays the system sound and shows the message announcing an obtained item and its quantity.
function dungeon_system_scripts_message.show_item_obtained(item: any, quantity: s32)
	local message_id: s32 = 0
	local sound_id: s32 = 0
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	if quantity <= 0 then
		return
	end
	if quantity == 1 then
		message_id = 10
		event.set_message_item_name(1, 1, item)
	end
	if 1 < quantity then
		message_id = 11
		event.set_message_item_name(1, 1, item)
		event.set_message_number(1, 2, quantity)
	end
	sound_id = event.get_system_sound_id() or sound_id
	event.play_sound_effect(sound_id, 18)
	dungeon_system_scripts_message.show_and_wait(1, message_id, 8, 0, 0)
end

--- Frames the player and a character with the talk camera, shows a speech bubble message and ends the event.
function dungeon_system_scripts_message.show_talk_bubble(npc_character: s32, text: s32)
	local player_slot: s32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	dungeon_system_scripts_camera.set_up_talk_camera(player_slot, npc_character, text)
	event.start_crossfade(10)
	dungeon_system_scripts_message.show_bubble(0, text, npc_character, player_slot, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
	event.start_crossfade(10)
end

--- Finishes a message wait that was interrupted by a scene skip and returns the frames waited and the confirmation flag.
function dungeon_system_scripts_message.skip_wait_for_advance(window: any, mode: s32, was_confirmed: s32)
	local stream_state: s32 = 0
	local previous_stream_state: s32 = 0
	local frames_waited: s32 = 0
	frames_waited = 0
	local _ = previous_stream_state ~= 0
	previous_stream_state = stream_state
	local _ = dungeon_system_scripts.ignore_arguments(window, mode)
	was_confirmed = 1
	was_confirmed = 0
	frames_waited = frames_waited + 1
	frames_waited = frames_waited + 1
	return frames_waited, was_confirmed
end

--- Waits for the player to dismiss a message while animating the mouth with the voice stream and returns the frames waited and the confirmation flag.
function dungeon_system_scripts_message.wait_for_advance(window: s32, mode: s32, was_confirmed: s32)
	local stream_playing: s32 = 0
	local stream_state: s32 = 0
	local previous_stream_state: s32 = 0
	local advance_result: s32 = 0
	local frames_waited: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frames_waited = 0
		previous_stream_state = event.get_voice_stream_state(1) or previous_stream_state
		while true do
			if stream_playing ~= 0 then
				stream_state = event.get_voice_stream_state(1) or stream_state
				if previous_stream_state ~= 0 and stream_state == 0 then
					event.trigger_mouth_texture_animation(0)
					event.trigger_mouth_motion(2)
				end
				previous_stream_state = stream_state
			end
			advance_result = dungeon_system_scripts.poll_message_input(window, mode)
			if advance_result ~= 0 then
				if advance_result == 2 then
					was_confirmed = 1
				else
					was_confirmed = 0
				end
				frames_waited = vm.i32(frames_waited + 1)
				break
			else
				resume_step = 1
				vm.wait(1)
				frames_waited = vm.i32(frames_waited + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		if stream_playing ~= 0 then
			event.stop_voice_stream(1)
		end
		return frames_waited, was_confirmed
	end, function(received: { any })
		if resume_step <= 1 then
			frames_waited = frames_waited + 1
			return frames_waited, was_confirmed
		end
		return nil, was_confirmed
	end)
end

--- Waits while a message window is still opening.
function dungeon_system_scripts_message.wait_until_window_ready(window: any)
	local window_state: s32 = 0
	window_state = event.get_message_window_state(window) or window_state
	while window_state == 0 or window_state == 1 do
		vm.wait(1)
		window_state = event.get_message_window_state(window) or window_state
	end
end

return dungeon_system_scripts_message
