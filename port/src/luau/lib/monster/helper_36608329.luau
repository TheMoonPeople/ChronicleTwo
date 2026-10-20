--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_36608329(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var21: f32 = 0
	local var23: s32 = 0
	var18 = monster.GetTargetDist() or var18
	helper_890ee63a(arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var9 = out3 or var9
	end
	var17 = helper_57b569a8(var17)
	var6 = vm.f32(var17 + arg3)
	do
		local out1, out2, out3 = monster.CopyVector(var5, var6, var7)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.SubVector(var14, var15, var16, var8, var9, var10)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.NormalVector(var14, var15, var16)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var14, var15, var16, arg0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local _, out2, _ = monster.GetRot()
		var12 = out2 or var12
	end
	for var22 = 0, arg4 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var8, var9, var10, var14, var15, var16)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var21 = monster.GetHigh2(var8, var9, var10) or var21
		if var21 >= 25.0 or var21 <= 0.0 then
			var9 = vm.f32(var9 - var15)
			var15 = 0.0
		end
		var18 = monster.GetDistVector2(var8, var9, var10, var5, var6, var7) or var18
		if var18 < vm.f32(arg0 + arg2) then
			return
		end
		var23 = helper_de1504df(var8, var9, var10, arg0, var12)
		if var23 ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.SetPos(var8, var9, var10)
		helper_0ba23e4e()
	end
end

return helper_36608329
