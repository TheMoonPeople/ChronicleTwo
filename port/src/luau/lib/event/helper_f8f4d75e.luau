--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_f8f4d75e(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var1 = helper_ed4dc120(5, arg0)
		if var1 == 0 then
			event.fade_out_screen(20)
			at = 2
			wait_frames(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(20)
			end
			return 1
		end
		return nil
	end)
end

return helper_f8f4d75e
