--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_979fad86 = require("@lib/event/helper_979fad86")
local helper_e5219064 = require("@lib/event/helper_e5219064")

--- Helper function.
local function helper_81ba7dbe(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_979fad86(player_chara, arg0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_979fad86(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_e5219064(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_81ba7dbe
