--!strict
-- Shared event helper used by 514 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_57c93eff(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	var2 = event.get_message_window_frame(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	var4 = event.get_message_window_state(arg0) or var4
	if var4 == 0 then
		return 0, arg1
	end
	if var4 == 1 then
		return 0, arg1
	end
	if var4 == 4 then
		return 0, arg1
	end
	pressed = event.is_event_button_pressed(0) or pressed
	pressed_2 = event.is_event_button_pressed(1) or pressed_2
	if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.play_message_sound(0)
			end
			if pressed ~= 0 then
				event.play_message_sound(1)
			end
		end
		if var4 == 5 then
			event.advance_message_page(arg0)
		end
		if var4 == 3 then
			return 1, arg1
		end
		if var4 ~= 5 and var4 ~= 3 then
			event.set_message_draw_speed(arg0, 0.0)
			event.trigger_mouth_motion(2)
			arg1 = 2
		end
	end
	return 0, arg1
end

return helper_57c93eff
