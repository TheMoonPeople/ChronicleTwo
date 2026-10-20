--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1187f90e = require("@lib/event/helper_1187f90e")
local helper_91082b0b = require("@lib/event/helper_91082b0b")
local helper_92392c83 = require("@lib/event/helper_92392c83")

--- Helper function.
local function helper_79efbdd2(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_91082b0b(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_92392c83(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_1187f90e(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_91082b0b(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_92392c83(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_79efbdd2
