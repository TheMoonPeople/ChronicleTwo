--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3c431e31 = require("@lib/event/helper_3c431e31")
local helper_5d4ac3a0 = require("@lib/event/helper_5d4ac3a0")

--- Helper function.
local function helper_081c6d75()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d4ac3a0()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_3c431e31(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_5d4ac3a0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_081c6d75
