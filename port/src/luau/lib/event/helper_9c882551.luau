--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

--- Helper function.
local function helper_9c882551()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		var0 = helper_94a172bf(4, -1)
		if var0 == 0 then
			event.SetFadeOut(30)
			at = 2
			helper_25abe6d2(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_9c882551
