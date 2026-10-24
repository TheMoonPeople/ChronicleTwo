--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_901e0132 = require("@lib/event/helper_901e0132")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e1d4eb31 = require("@lib/event/helper_e1d4eb31")

--- Helper function.
local function helper_be79d02f()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		vm.wait(1)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		at = 2
		var0 = helper_901e0132(5, 55)
		event.SetMesWindowMode(0, 1)
		if var0 == 0 then
			event.SetFadeOut(30)
			at = 3
			helper_25abe6d2(30)
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
				helper_d3f20302(30)
			end
			return 1
		end
		return nil
	end)
end

return helper_be79d02f
