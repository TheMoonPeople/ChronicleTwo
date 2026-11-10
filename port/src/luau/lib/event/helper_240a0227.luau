--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_58df4c7c = require("@lib/event/helper_58df4c7c")
local helper_e1d4eb31 = require("@lib/event/helper_e1d4eb31")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_240a0227()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		vm.wait(1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		at = 2
		var0 = helper_58df4c7c(5, 55)
		event.set_message_window_mode(0, 1)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				var0 = helper_e1d4eb31(5, 55)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_240a0227
