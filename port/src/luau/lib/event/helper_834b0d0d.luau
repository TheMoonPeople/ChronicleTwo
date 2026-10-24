--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a58e1455 = require("@lib/event/helper_a58e1455")
local helper_dddb0e38 = require("@lib/event/helper_dddb0e38")

--- Helper function.
local function helper_834b0d0d()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dddb0e38()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_a58e1455(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_dddb0e38()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_834b0d0d
