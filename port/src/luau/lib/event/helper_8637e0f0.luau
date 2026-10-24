--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00ff664c = require("@lib/event/helper_00ff664c")
local helper_0b85c723 = require("@lib/event/helper_0b85c723")
local helper_ad9a81f4 = require("@lib/event/helper_ad9a81f4")

--- Helper function.
local function helper_8637e0f0()
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
			helper_ad9a81f4(var1, player_chara)
		else
			at = 2
			helper_0b85c723()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_00ff664c()
			end
			return 0
		end
		return nil
	end)
end

return helper_8637e0f0
