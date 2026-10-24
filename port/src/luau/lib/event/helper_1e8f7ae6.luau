--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_007c5a3d = require("@lib/event/helper_007c5a3d")
local helper_fe03cbd6 = require("@lib/event/helper_fe03cbd6")

--- Helper function.
local function helper_1e8f7ae6()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fe03cbd6()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_007c5a3d(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_fe03cbd6()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_1e8f7ae6
