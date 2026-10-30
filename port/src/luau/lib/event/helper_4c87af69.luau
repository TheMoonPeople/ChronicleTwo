--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_4c87af69()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			wait_frames(10)
			event.set_character_position(0, 1804.36, -189.51, 1279.76)
			event.set_character_rotation(0, 0.0, -2.47, 0.0)
			event.set_camera_position(1889.79, -158.65, 1386.92)
			event.set_camera_look_at(1804.36, -159.51, 1279.76)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		at = 4
		var1 = helper_ed4dc120(2, -1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var1 == 0 then
			event.set_camera_sequence_position(1776.49, -106.69, 1400.79)
			event.set_camera_sequence_look_at(1951.33, -163.61, 1351.42)
			event.set_object_sequence_position(0, 1943.88, -189.72, 1357.17)
			event.set_object_sequence_rotation(0, 0.0, 1.21, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 1943.88, -189.72, 1357.17)
			event.add_object_sequence_path_point(0, 2022.78, -189.88, 1386.95)
			event.add_object_sequence_path_point(0, 2104.45, -195.47, 1399.2)
			event.add_object_sequence_path_point(0, 2155.72, -202.4, 1401.26)
			event.start_object_sequence_path(0)
			at = 5
			wait_frames(30)
			event.fade_out_screen(30)
			at = 6
			wait_frames(30)
			event.set_character_motion(0, "立ち", 4)
			event.set_object_handle_footstep_sound(0, -1)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
			var6 = var3
			var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
			event.move_object_sequence(0, var5, var6, var7, 30, 1)
			event.turn_object_sequence_toward(0, var5, var6, var7, 10)
			event.set_object_sequence_motion(0, "歩き")
			var8 = 0
			while var8 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				var3 = vm.f32(var3 + 30.0)
				event.set_camera_look_at(var2, var3, var4)
				var8 = var8 + 1
				at = 7
				vm.wait(7)
			end
			event.set_object_handle_footstep_sound(0, -1)
			event.reset_follow_camera(0)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				wait_frames_skipping(10)
			end
			return 0
		end
		if at <= 6 then
			if at == 4 then
				var1 = received[1] :: number
			end
			if at <= 4 then
				wait_frames_skipping(30)
			end
			if at <= 5 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 7 then
			return 0
		end
		return nil
	end)
end

return helper_4c87af69
