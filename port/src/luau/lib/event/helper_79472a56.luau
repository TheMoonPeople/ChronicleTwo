--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_103da1d8 = require("@lib/event/helper_103da1d8")
local helper_cac2b7e4 = require("@lib/event/helper_cac2b7e4")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_79472a56(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local player_chara: s32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = helper_eb560126(arg0, arg4, arg5)
		end
		if at <= 2 then
			var8 = helper_103da1d8(0, arg1, arg0, player_chara, arg2, arg3)
		end
		if at <= 3 then
			helper_cac2b7e4(arg0, var6, arg4, arg5)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	var6 = helper_eb560126(arg0, arg4, arg5)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	var8 = helper_103da1d8(0, arg1, arg0, player_chara, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
	helper_cac2b7e4(arg0, var6, arg4, arg5)
	if vm.skipping() then
		return skip(4)
	end
	return var8
end

return helper_79472a56
