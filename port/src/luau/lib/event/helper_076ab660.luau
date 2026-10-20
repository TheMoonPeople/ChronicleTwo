--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d8f7622 = require("@lib/event/helper_0d8f7622")
local helper_52118899 = require("@lib/event/helper_52118899")

--- Helper function.
local function helper_076ab660()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d8f7622()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_52118899(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_0d8f7622()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_076ab660
