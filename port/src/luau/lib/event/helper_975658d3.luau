--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d70bce8 = require("@lib/event/helper_0d70bce8")
local helper_767eaa75 = require("@lib/event/helper_767eaa75")
local helper_7e1df063 = require("@lib/event/helper_7e1df063")

--- Helper function.
local function helper_975658d3(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local player_chara: s32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = helper_0d70bce8(arg0, arg4, arg5)
		end
		if at <= 2 then
			var8 = helper_7e1df063(0, arg1, arg0, player_chara, arg2, arg3)
		end
		if at <= 3 then
			helper_767eaa75(arg0, var6, arg4, arg5)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	var6 = helper_0d70bce8(arg0, arg4, arg5)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	var8 = helper_7e1df063(0, arg1, arg0, player_chara, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
	helper_767eaa75(arg0, var6, arg4, arg5)
	if vm.skipping() then
		return skip(4)
	end
	return var8
end

return helper_975658d3
