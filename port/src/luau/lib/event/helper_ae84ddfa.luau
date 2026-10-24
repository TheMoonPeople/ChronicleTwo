--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a6119e46 = require("@lib/event/helper_a6119e46")

--- Helper function.
local function helper_ae84ddfa(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a6119e46(player_chara, arg0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_a6119e46(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_635ee3fd(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_ae84ddfa
