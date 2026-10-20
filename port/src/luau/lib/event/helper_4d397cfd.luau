--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_55dda2bc = require("@lib/event/helper_55dda2bc")
local helper_d86d567b = require("@lib/event/helper_d86d567b")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_4d397cfd(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local player_chara: s32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = helper_dae2ac4c(arg0, arg4, arg5)
		end
		if at <= 2 then
			var8 = helper_d86d567b(0, arg1, arg0, player_chara, arg2, arg3)
		end
		if at <= 3 then
			helper_55dda2bc(arg0, var6, arg4, arg5)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	var6 = helper_dae2ac4c(arg0, arg4, arg5)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	var8 = helper_d86d567b(0, arg1, arg0, player_chara, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
	helper_55dda2bc(arg0, var6, arg4, arg5)
	if vm.skipping() then
		return skip(4)
	end
	return var8
end

return helper_4d397cfd
