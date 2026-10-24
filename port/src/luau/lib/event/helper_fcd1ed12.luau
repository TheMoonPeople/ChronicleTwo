--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_68685f02 = require("@lib/event/helper_68685f02")
local helper_fe5a2f04 = require("@lib/event/helper_fe5a2f04")

--- Helper function.
local function helper_fcd1ed12(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fe5a2f04(player_chara, arg0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_fe5a2f04(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_68685f02(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_fcd1ed12
