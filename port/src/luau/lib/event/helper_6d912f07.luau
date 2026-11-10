--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")

--- Helper function.
local function helper_6d912f07()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var0 = helper_ed4dc120(4, -1)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_6d912f07
