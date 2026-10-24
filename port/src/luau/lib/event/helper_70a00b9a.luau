--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b6f914b = require("@lib/event/helper_2b6f914b")
local helper_761ea976 = require("@lib/event/helper_761ea976")

--- Helper function.
local function helper_70a00b9a(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2b6f914b(player_chara, arg0)
		end
		if at <= 2 then
			helper_761ea976(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_2b6f914b(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_761ea976(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_70a00b9a
