--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_9d1ba522(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var18: s32 = 0
	target, target_2, target_3 = helper_125e5305(arg2, arg3, target, target_2, target_3)
	arg2 = monster.get_angle_to_position(target, target_2, target_3) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_362382c7(helper_28452e16(arg2), arg1)
	helper_442b9962()
	var18 = helper_0b6e560f(target, target_2, target_3, arg0, arg4, arg5, arg6)
	return var18
end

return helper_9d1ba522
