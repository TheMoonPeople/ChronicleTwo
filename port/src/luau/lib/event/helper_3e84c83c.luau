--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e1d4eb31 = require("@lib/event/helper_e1d4eb31")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_3e84c83c(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		if arg0 == 1 then
			at = 1
			var1 = helper_ed4dc120(1, -1)
		else
			at = 2
			var1 = helper_ed4dc120(2, -1)
		end
		if var1 == 0 then
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		else
			event.finish_event()
			return 0
		end
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at == 2 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				var1 = helper_e1d4eb31(2, -1)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_3e84c83c
