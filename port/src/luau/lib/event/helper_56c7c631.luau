--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00ff664c = require("@lib/event/helper_00ff664c")
local helper_9bb21c29 = require("@lib/event/helper_9bb21c29")
local helper_a88eeb3c = require("@lib/event/helper_a88eeb3c")

--- Helper function.
local function helper_56c7c631()
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
			helper_9bb21c29(var1, player_chara)
		else
			at = 2
			helper_a88eeb3c()
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

return helper_56c7c631
