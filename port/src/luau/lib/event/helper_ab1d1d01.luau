--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5c9a46d1 = require("@lib/event/helper_5c9a46d1")
local helper_78ae761c = require("@lib/event/helper_78ae761c")

--- Helper function.
local function helper_ab1d1d01()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5c9a46d1()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_78ae761c(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_5c9a46d1()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_ab1d1d01
