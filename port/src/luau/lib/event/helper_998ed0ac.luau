--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_66feb157 = require("@lib/event/helper_66feb157")
local helper_fe3bc604 = require("@lib/event/helper_fe3bc604")

--- Helper function.
local function helper_998ed0ac()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_66feb157()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_fe3bc604(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_66feb157()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_998ed0ac
