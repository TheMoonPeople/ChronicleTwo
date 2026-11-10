--!strict
-- Shared event helper used by 771 scripts, translated by tools/luau/stb2luau.

--- Runs one frame of a message window: its mouth animation and its answer; returns 0 until the window gives a result.
local function message_step(window: any, answers: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local stream_playing: s32 = 0
	local var7: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	local pressed_4: s32 = 0
	var2 = 0
	var3 = 0
	if answers == 1 then
		var2 = 1
	end
	if answers == 2 then
		var3 = 1
	end
	var4 = event.get_message_window_frame(window) or var4
	var5 = 1
	if var4 == 7 then
		var5 = 0
	end
	if var4 == 0 then
		var5 = 0
	end
	stream_playing = event.is_voice_stream_playing() or stream_playing
	var7 = event.get_message_window_state(window) or var7
	if var7 == 0 then
		return 0
	end
	if var7 == 1 then
		return 0
	end
	if var7 == 3 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	if var7 == 4 then
		return 0
	end
	if var7 == 5 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	pressed = event.is_event_button_pressed(0) or pressed
	pressed_2 = event.is_event_button_pressed(1) or pressed_2
	pressed_3 = event.is_event_button_pressed(2) or pressed_3
	pressed_4 = event.is_event_button_pressed(3) or pressed_4
	if
		(
			if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if var2 ~= 0 then pressed_3 else 0)
					~= 0
				then 1
				else if var3 ~= 0 then pressed_4 else 0
		) ~= 0
	then
		if var5 ~= 0 then
			if pressed_2 ~= 0 then
				event.play_message_sound(0)
			end
			if pressed ~= 0 then
				event.play_message_sound(1)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				event.play_message_sound(0)
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				event.play_message_sound(0)
			end
		end
		if var7 == 5 then
			event.advance_message_page(window)
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(1)
				event.trigger_mouth_motion(0)
			end
		end
		if var7 == 3 then
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(0)
				event.trigger_mouth_motion(2)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				return 3
			end
			return 1
		end
		if var7 ~= 5 and var7 ~= 3 then
			event.set_message_draw_speed(window, 0.0)
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
			if stream_playing ~= 0 then
				event.stop_voice_stream(1)
			end
		end
	end
	return 0
end

return message_step
