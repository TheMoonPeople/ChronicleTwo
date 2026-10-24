--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3488ae95 = require("@lib/event/helper_3488ae95")
local helper_582d0402 = require("@lib/event/helper_582d0402")
local helper_a22c9355 = require("@lib/event/helper_a22c9355")

--- Helper function.
local function helper_cce4ecf1()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.GetEventData_2(14) or var0
		var1 = event.GetEventData_2(13) or var1
		player_chara = event.GetControlChrid() or player_chara
		if var0 <= 34 then
			at = 1
			helper_582d0402(var1, player_chara)
		else
			at = 2
			helper_a22c9355()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_3488ae95()
			end
			return 0
		end
		return nil
	end)
end

return helper_cce4ecf1
