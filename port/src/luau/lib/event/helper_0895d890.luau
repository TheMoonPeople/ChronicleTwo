--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0af72ab0 = require("@lib/event/helper_0af72ab0")
local helper_ddec8bc4 = require("@lib/event/helper_ddec8bc4")

--- Helper function.
local function helper_0895d890()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ddec8bc4()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_0af72ab0(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_ddec8bc4()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_0895d890
