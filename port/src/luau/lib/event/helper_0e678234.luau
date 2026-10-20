--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3fe18432 = require("@lib/event/helper_3fe18432")
local helper_77f8061a = require("@lib/event/helper_77f8061a")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")

--- Helper function.
local function helper_0e678234(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_77f8061a(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_85ab2618(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_3fe18432(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_77f8061a(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_85ab2618(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_3fe18432(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_0e678234
