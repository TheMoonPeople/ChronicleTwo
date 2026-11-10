--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_0ca47ddb()
	local var0: any = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		at = 1
		var0 = helper_ed4dc120(5, 0)
		if var0 == 0 then
			event.set_object_sequence_position(0, -936.47, 0.0, -23.84)
			event.set_object_sequence_rotation(0, 0.0, -1.65, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-751.82, 79.08, -27.15)
			event.set_camera_sequence_look_at(-928.2, 36.53, -26.64)
			flag = event.get_save_flag(207) or flag
			flag_2 = event.get_save_flag(208) or flag_2
			if flag == 1 and flag_2 == 0 then
				event.skip_next_music_load()
			end
			event.move_object_sequence(0, -1142.09, 0.0, -28.24, 60)
			event.move_camera_sequence(-751.82, 79.08, -27.15, -921.16, 65.58, -20.12, 60)
			at = 2
			wait_frames(30)
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var3 = vm.f32(var3 + vm.f32(30.0 * vm.sin(vm.f32(1.57))))
		var5 = vm.f32(var5 + vm.f32(30.0 * vm.cos(vm.f32(1.57))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 15)
		event.move_object_sequence(0, var3, var4, var5, 45)
		for var6_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			event.set_camera_sequence_look_at(var3, var4 + 30.0, var5)
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
				wait_frames_skipping(30)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = var6 < 45
			var6 = var6 + 1
			return 0
		end
		return nil
	end)
end

return helper_0ca47ddb
