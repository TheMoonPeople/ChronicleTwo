--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_ffd118ae()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		at = 1
		var0 = helper_ed4dc120(1, -1)
		if var0 == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-2144.16, 79.66, 654.8)
			event.set_camera_sequence_look_at(-2382.06, 11.3, 623.75)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -2363.64, 0.4, 625.83)
			event.set_object_sequence_rotation(0, 0.0, -1.52, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.move_object_sequence(0, -2489.67, 0.4, 624.1, 60)
			event.move_camera_sequence_eased(-2144.16, 79.66, 654.8, -2388.46, 36.03, 632.32, 48, 60, 2.5)
			event.mark_camera_sequence_fade_track()
			event.delay_camera_sequence_fade_track(30)
			event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
			at = 2
			wait_frames(60)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(vm.f32(1.59))))
		var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(vm.f32(1.59))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.59, 0.0, 15)
		event.move_object_sequence(0, var1, var2, var3, 45)
		for var4_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			event.set_camera_sequence_look_at(var1, var2 + 30.0, var3)
			at = 3
			vm.wait(3)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(60)
			end
			return 1
		end
		if at <= 3 then
			local _ = var4 < 45
			var4 = var4 + 1
			return 0
		end
		return nil
	end)
end

return helper_ffd118ae
