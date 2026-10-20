--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_187f0d3d = require("@lib/event/helper_187f0d3d")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")

--- Helper function.
local function helper_2056b079(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_187f0d3d(player_chara, arg0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_187f0d3d(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_85ab2618(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_2056b079
