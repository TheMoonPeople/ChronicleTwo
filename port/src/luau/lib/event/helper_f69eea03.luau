--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_881e2712 = require("@lib/event/helper_881e2712")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_f69eea03(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_881e2712(player_chara, arg0)
		end
		if at <= 2 then
			helper_dbd14b96(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_881e2712(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_dbd14b96(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_f69eea03
