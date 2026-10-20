--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3dd465f9 = require("@lib/event/helper_3dd465f9")
local helper_fff7b413 = require("@lib/event/helper_fff7b413")

--- Helper function.
local function helper_d1f370f3(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fff7b413(player_chara, arg0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_fff7b413(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_3dd465f9(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_d1f370f3
