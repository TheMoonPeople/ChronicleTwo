--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26548f5b = require("@lib/event/helper_26548f5b")
local helper_45a326d0 = require("@lib/event/helper_45a326d0")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")

--- Helper function.
local function helper_ee2fed44(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local player_chara: s32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = helper_a45deb91(arg0, arg4, arg5)
		end
		if at <= 2 then
			var8 = helper_45a326d0(0, arg1, arg0, player_chara, arg2, arg3)
		end
		if at <= 3 then
			helper_26548f5b(arg0, var6, arg4, arg5)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	var6 = helper_a45deb91(arg0, arg4, arg5)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	var8 = helper_45a326d0(0, arg1, arg0, player_chara, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
	helper_26548f5b(arg0, var6, arg4, arg5)
	if vm.skipping() then
		return skip(4)
	end
	return var8
end

return helper_ee2fed44
