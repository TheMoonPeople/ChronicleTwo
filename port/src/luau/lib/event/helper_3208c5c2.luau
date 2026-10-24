--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ca75494 = require("@lib/event/helper_0ca75494")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_3208c5c2(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0ca75494(player_chara, arg0)
		end
		if at <= 2 then
			helper_fb6fbabc(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_0ca75494(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_fb6fbabc(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_3208c5c2
