--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_801fd4d7 = require("@lib/event/helper_801fd4d7")
local helper_e385fedf = require("@lib/event/helper_e385fedf")

--- Helper function.
local function helper_c026e6fb()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_801fd4d7()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_e385fedf(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_801fd4d7()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_c026e6fb
