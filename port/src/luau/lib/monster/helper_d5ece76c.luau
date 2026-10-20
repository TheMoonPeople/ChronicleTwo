--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_d5ece76c(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	for var21 = 0, arg5 - 1 do
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var19 = helper_57b569a8(var19)
		var7 = vm.f32(var19 + arg3)
		do
			local out1, out2, out3 = monster.CopyVector(var6, var7, var8)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.SubVector(var15, var16, var17, var9, var10, var11)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.NormalVector(var15, var16, var17)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var15, var16, var17, arg0)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.AddVector(var9, var10, var11, var15, var16, var17)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.GetRefRot_6(var9, var10, var11)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		var20 = monster.GetHigh2(var9, var10, var11) or var20
		if var20 >= 25.0 or var20 <= 0.0 then
			var10 = vm.f32(var10 - var16)
			var16 = 0.0
		end
		var18 = monster.GetDistVector2(var9, var10, var11, var6, var7, var8) or var18
		if var18 < vm.f32(arg0 + arg2) then
			return
		end
		var22 = helper_de1504df(var9, var10, var11, arg0, var13)
		if var22 ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.SetPos(var9, var10, var11)
		if arg4 ~= 0 then
			monster.SetRot(var12, var13, var14)
		else
			monster.SetRot(0.0, var13, 0.0)
		end
		helper_0ba23e4e()
	end
end

return helper_d5ece76c
