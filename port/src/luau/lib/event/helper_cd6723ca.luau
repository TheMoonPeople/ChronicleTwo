--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_ab5bcd36 = require("@lib/event/helper_ab5bcd36")

--- Helper function.
local function helper_cd6723ca(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ab5bcd36(player_chara, arg0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_ab5bcd36(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_403f0e66(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_cd6723ca
