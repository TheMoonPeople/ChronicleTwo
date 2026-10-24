--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

--- Helper function.
local function helper_cbb3ef78(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		var1 = helper_94a172bf(5, arg0)
		if var1 == 0 then
			event.SetFadeOut(20)
			at = 2
			helper_25abe6d2(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(20)
			end
			return 1
		end
		return nil
	end)
end

return helper_cbb3ef78
