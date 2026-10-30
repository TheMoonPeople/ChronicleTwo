--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_58df4c7c = require("@lib/event/helper_58df4c7c")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_87adbdbf()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		at = 1
		var0 = helper_58df4c7c(5, 55)
		if var0 == 0 then
			event.set_object_sequence_position(0, 0.0, 0.0, 820.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.set_camera_look_at(0.0, 30.0, 820.0)
			event.set_camera_position(0.0, 40.0, 760.0)
			event.move_object_sequence(0, 0.0, 0.0, 1000.0, 40)
			at = 2
			wait_frames(10)
			event.set_object_handle_footstep_sound(0, 2)
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			event.set_object_sequence_motion(0, "立ち")
			at = 4
			wait_frames(2)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30, 1)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 5
				vm.wait(5)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(10)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			if at <= 3 then
				wait_frames_skipping(2)
			end
			return 1
		end
		if at <= 5 then
			return 0
		end
		return nil
	end)
end

return helper_87adbdbf
