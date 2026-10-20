--!strict
-- Shared monster helper used by 29 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_b823bc2c = require("@lib/monster/helper_b823bc2c")

--- Helper function.
local function helper_595cbf61(arg0: f32, arg1: f32)
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	monster.SetNextRot(arg0, arg1)
	local _ =
		helper_b823bc2c(helper_28452e16(arg0), helper_28452e16(arg1), vm.f32(vm.fdiv(360.0, helper_28452e16(arg1))))
	helper_442b9962()
end

return helper_595cbf61
