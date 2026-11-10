--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_fd9c4774(arg0: any, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local stream_playing: s32 = 0
	local var5: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	var2 = event.get_message_window_frame(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	stream_playing = event.is_voice_stream_playing() or stream_playing
	var5 = event.get_message_window_state(arg0) or var5
	if var5 == 0 then
		return 0
	end
	if var5 == 1 then
		return 0
	end
	if var5 == 3 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	if var5 == 4 then
		return 0
	end
	if var5 == 5 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	pressed = event.is_event_button_pressed(0) or pressed
	pressed_2 = event.is_event_button_pressed(1) or pressed_2
	pressed_3 = event.is_event_button_pressed(2) or pressed_3
	if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.play_message_sound(0)
			end
			if pressed ~= 0 then
				event.play_message_sound(1)
			end
			if (if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
				event.play_message_sound(0)
			end
		end
		if var5 == 5 then
			event.advance_message_page(arg0)
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(1)
				event.trigger_mouth_motion(0)
			end
		end
		if var5 == 3 then
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(0)
				event.trigger_mouth_motion(2)
			end
			if (if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			else
				return 1
			end
		end
		if var5 ~= 5 and var5 ~= 3 then
			event.set_message_draw_speed(arg0, 0.0)
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
			if stream_playing ~= 0 then
				event.stop_voice_stream(1)
			end
		end
	end
	return 0
end

return helper_fd9c4774
