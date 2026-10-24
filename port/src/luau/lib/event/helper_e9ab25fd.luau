--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_e9ab25fd()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMotion(0, "立ち")
		event.Initialize()
		helper_125385ee(0, 4)
		event.MesMake_2(0, "中に入る\n出発する")
		at = 1
		var0 = helper_c190f878(0, -1, 5, 256, 208, 2, 0)
		if var0 == -1 then
			helper_125385ee(0, 1)
			return 0
		end
		if var0 == 1 then
			event.SetFadeOut(15)
			at = 2
			helper_888ab2a3(15)
			event.GotoMenu(19, 0)
			at = 3
			vm.wait(3)
			event.SetFadeIn(15)
			at = 4
			helper_888ab2a3(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			helper_fbd9683d(0, 1)
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_038a2e4d(15)
			end
			return 0
		end
		return nil
	end)
end

return helper_e9ab25fd
