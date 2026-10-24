--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_94a172bf = require("@lib/event/helper_94a172bf")

--- Helper function.
local function helper_7511c466()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		at = 1
		var0 = helper_94a172bf(5, 4)
		if var0 == 0 then
			event.SetFadeOut(20)
			at = 2
			helper_888ab2a3(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			return 1
		end
		return nil
	end)
end

return helper_7511c466
