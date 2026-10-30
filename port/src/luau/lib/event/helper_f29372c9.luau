--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_788e145d = require("@lib/event/helper_788e145d")
local helper_8af09d2f = require("@lib/event/helper_8af09d2f")
local helper_9cfbda89 = require("@lib/event/helper_9cfbda89")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")

--- Helper function.
local function helper_f29372c9(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	var4 = 60
	var5 = 76
	local _ = helper_9cfbda89(
		var16,
		var17,
		var18,
		vm.f32(var11 + vm.f32(1.5707964)),
		vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
	) == 1
	var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
	local _ = var14 ~= 0.0
	var14 = 0.0
	var5 = 76
	local _ = var4 <= 0
	var4 = 400
	var4 = 200
	var5 = 0
	local _ = var5 <= 0
	var5 = var5 - 1
	var4 = var4 - 1
	var13 = arg1
	var13 = vm.f32(var13 + var15)
	local _ = var13 <= 5.0
	var13 = 5.0
	local _ = var13 >= 30.0
	var13 = 30.0
	arg0 = var11
	arg1 = var13
	helper_8af09d2f(arg0, arg1, arg2)
	local _ = helper_dbff9fb6(0)
	var3 = 0
	local _ = helper_dbff9fb6(1)
	var3 = 1
	helper_788e145d()
	return var3, arg0, arg1
end

return helper_f29372c9
