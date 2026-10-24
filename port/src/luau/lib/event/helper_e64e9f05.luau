--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

--- Helper function.
local function helper_e64e9f05()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		at = 1
		var0 = helper_94a172bf(3, -1)
		if var0 == 0 then
			event.SetFadeOut(20)
			at = 2
			helper_25abe6d2(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(20)
			end
			return 1
		end
		return nil
	end)
end

return helper_e64e9f05
