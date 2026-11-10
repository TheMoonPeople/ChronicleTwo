--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_3a1afb4d()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local angle: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		at = 1
		var0 = helper_ed4dc120(5, 57)
		if var0 == 0 then
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -836.17, 0.0, -823.5)
			event.set_object_sequence_rotation(0, 0.0, -1.66, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-668.11, 97.09, -886.72)
			event.set_camera_sequence_look_at(-839.94, 44.81, -838.79)
			event.move_object_sequence(0, -1044.71, 0.0, -836.63, 60)
			event.move_camera_sequence(-668.11, 97.09, -886.72, -881.32, 61.14, -861.93, 60)
			at = 2
			wait_frames(30)
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.get_character_rotation(0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		angle = vm.f32(vm.f32(3.1415927) + var5)
		angle = event.wrap_angle(angle) or angle
		angle = vm.f32(1.5707964)
		var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(angle)))
		var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(angle)))
		event.rotate_object_sequence(0, var4, angle, var6, 15)
		event.move_object_sequence(0, var1, var2, var3, 45)
		for var8_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			event.set_camera_sequence_look_at(var1, var2 + 30.0, var3)
			at = 4
			vm.wait(4)
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(30)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = var8 < 45
			var8 = var8 + 1
			return 0
		end
		return nil
	end)
end

return helper_3a1afb4d
