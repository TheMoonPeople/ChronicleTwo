--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_696732ec = require("@lib/event/helper_696732ec")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_2295c00d()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		at = 1
		var0 = helper_696732ec(5, 16)
		if var0 == 0 then
			event.set_object_sequence_position(0, 435.65, 0.09, 1239.32)
			event.set_object_sequence_rotation(0, 0.0, 0.15, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(509.64, 85.52, 1104.08)
			event.set_camera_sequence_look_at(467.67, 42.86, 1293.7)
			event.move_object_sequence(0, 493.92, 0.01, 1423.13, 60, 1)
			event.move_camera_sequence(509.64, 85.52, 1104.08, 485.07, 46.59, 1340.58, 60)
			print("2")
			at = 2
			wait_frames(30)
			print("3")
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var1 = vm.f32(var1 + vm.f32(45.0 * vm.sin(vm.f32(-3.01))))
		var3 = vm.f32(var3 + vm.f32(45.0 * vm.cos(vm.f32(-3.01))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -3.01, 0.0, 15)
		event.move_object_sequence(0, var1, var2, var3, 45)
		for var4_i = 0, 44 do
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
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				print("2")
				wait_frames_skipping(30)
			end
			if at <= 2 then
				print("3")
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = var4 < 45
			var4 = var4 + 1
			return 0
		end
		return nil
	end)
end

return helper_2295c00d
