--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

--- Helper function.
local function helper_81922039()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_9e7d1511(0, 20, 5, 256, 208)
			else
				at = 2
				helper_9e7d1511(0, 21, 5, 256, 208)
			end
			event.Finish()
			return 0
		end
		at = 3
		var1 = helper_94a172bf(5, 124)
		if var1 == 0 then
			event.SetFadeOut(30)
			at = 4
			helper_25abe6d2(30)
			event.Finish()
			return 1
		end
		event.Finish()
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 3 then
				var1 = received[1] :: number
			end
			if at <= 3 then
				helper_d3f20302(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_81922039
