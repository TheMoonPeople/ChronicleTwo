--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_e3808540(
	target: f32,
	target_2: f32,
	target_3: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: f32,
	arg8: f32,
	arg9: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	var17 = vm.f32(arg6 * vm.f32(0.017453292))
	var18 = monster.get_angle_to_position(target, target_2, target_3) or var18
	var18 = vm.f32(var18 - vm.f32(3.1415927))
	var18 = vm.f32(var18 + var17)
	if var18 > vm.f32(3.1415927) then
		var18 = vm.f32(var18 - vm.f32(6.2831855))
	end
	if var18 <= vm.f32(-3.1415927) then
		var18 = vm.f32(var18 + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(arg5 * vm.sin(var18)))
	target_2_2 = 0.0
	target_3_2 = vm.f32(target_3 + vm.f32(arg5 * vm.cos(var18)))
	arg6 = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or arg6
	helper_362382c7(helper_28452e16(arg6), arg4)
	helper_442b9962()
	local _ = helper_0b6e560f(target_4, target_2_2, target_3_2, arg3, arg7, arg8, arg9)
end

return helper_e3808540
