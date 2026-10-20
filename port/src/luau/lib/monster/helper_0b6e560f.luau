--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_0b6e560f(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var19 = helper_57b569a8(var19)
	arg1 = vm.f32(var19 + arg5)
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.SubVector(var13, var14, var15, var7, var8, var9)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.NormalVector(var13, var14, var15)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var13, var14, var15, arg3)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	monster.CopyVector(arg0, arg1, arg2)
	var11 = monster.GetRefAngle(var7 + var13, var8 + var14, var9 + var15) or var11
	for var23 = 0, arg6 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.GetHigh2(var7, var8, var9) or var22
		if var22 >= 30.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.GetDistVector2(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(arg3 + arg4) then
			return 1
		end
		var24 = helper_de1504df(var7, var8, var9, arg3, var11)
		if var24 ~= 0 then
			return var24
		end
		monster.SetPos(var7, var8, var9)
		monster.CopyVector(var7, var8, var9)
		helper_461f64ff()
	end
	return 0
end

return helper_0b6e560f
