--!strict
-- dungeon/monster/b12a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_07b5f915 = require("@lib/monster/helper_07b5f915")
local helper_1487c2ae = require("@lib/monster/helper_1487c2ae")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9821a9e1 = require("@lib/monster/helper_9821a9e1")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_dd45b7cf = require("@lib/monster/helper_dd45b7cf")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")

--- Helper function.
local function helper_1bb24(arg0: s32)
	monster.VPush(0, arg0)
end

--- Helper function.
local function helper_1b6dc(arg0: s32)
	monster.VPush(16, arg0)
end

--- Helper function.
local function helper_13830()
	helper_ac26cdde(vm.f32(999.9))
	helper_07b5f915(45.0)
	monster.SetClipDist(600.0)
	helper_317bfc18(1)
end

--- Helper function.
local function helper_1cc8()
	local boss: s32 = 0
	boss = monster.GetBossFlag() or boss
	if boss == 0 then
		monster.GetPos_3()
		monster.SetClipDist(35.0)
	else
		monster.SetClipDist(999999.0)
	end
end

--- Helper function.
local function helper_1ba44(arg0: s32)
	local value: s32 = 0
	value = monster.VPop(0) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_18534(arg0: s32)
	local var1: s32 = 0
	local chara_type: s32 = 0
	if arg0 ~= 0 then
		var1 = 0
		chara_type = monster.GetUserid() or chara_type
		var1 = monster.EsmCreate_2("ポルＪＥＴ") or var1
		monster.EsmSetUserId(var1, chara_type)
		monster.EsmSetValue(var1, 0, 0)
		monster.EsmSetValue(var1, 1, 0)
		monster.VPush(4, var1)
		var1 = 0
		var1 = monster.EsmCreate_2("ポルＪＥＴ") or var1
		monster.EsmSetUserId(var1, chara_type)
		monster.EsmSetValue(var1, 0, 0)
		monster.EsmSetValue(var1, 1, 1)
		monster.VPush(3, var1)
	else
		var1 = 0
		var1 = monster.VPop(4) or var1
		if var1 ~= -99999 then
			monster.EsmSetValue(var1, 0, 1)
		end
		var1 = monster.VPop(3) or var1
		if var1 ~= -99999 then
			monster.EsmSetValue(var1, 0, 1)
		end
		monster.MySeStop(5)
	end
end

--- Helper function.
local function helper_19e0()
	helper_1ef0d4b2()
	vm.wait()
end

--- Helper function.
local function helper_18bbc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
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
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = 10000000.0
	var24 = 0
	while var24 < 4 do
		if var24 == 0 then
			var0 = -101.5
			var1 = 0.0
			var2 = vm.f32(964.72)
		end
		if var24 == 1 then
			var0 = vm.f32(-86.02)
			var1 = 0.0
			var2 = vm.f32(3.4)
		end
		if var24 == 2 then
			var0 = vm.f32(85.15)
			var1 = 0.0
			var2 = vm.f32(958.98)
		end
		if var24 == 3 then
			var0 = vm.f32(128.03)
			var1 = 0.0
			var2 = vm.f32(2.48)
		end
		var6 = monster.GetDistVector2(var3, var4, var5, var0, var1, var2) or var6
		if var6 < var7 then
			var7 = var6
			var23 = var24
		end
		var24 = var24 + 1
	end
	print("pas_no=", var23, "--------------\n")
	if var23 == 0 then
		var8 = -101.5
		var9 = 0.0
		var10 = vm.f32(964.72)
		var11 = vm.f32(-484.28)
		var12 = 40.0
		var13 = vm.f32(978.59)
		var14 = vm.f32(-632.77)
		var15 = 40.0
		var16 = vm.f32(857.39)
		var17 = vm.f32(-635.56)
		var18 = 40.0
		var19 = vm.f32(532.18)
	end
	if var23 == 1 then
		var8 = vm.f32(-86.02)
		var9 = 0.0
		var10 = vm.f32(3.4)
		var11 = vm.f32(-444.91)
		var12 = 40.0
		var13 = vm.f32(-13.92)
		var14 = vm.f32(-640.01)
		var15 = 40.0
		var16 = vm.f32(71.46)
		var17 = vm.f32(-630.83)
		var18 = 40.0
		var19 = vm.f32(532.54)
	end
	if var23 == 2 then
		var8 = vm.f32(85.15)
		var9 = 0.0
		var10 = vm.f32(958.98)
		var11 = vm.f32(481.66)
		var12 = 40.0
		var13 = vm.f32(965.4)
		var14 = vm.f32(635.23)
		var15 = 40.0
		var16 = vm.f32(875.85)
		var17 = vm.f32(634.95)
		var18 = 40.0
		var19 = vm.f32(413.07)
	end
	if var23 == 3 then
		var8 = vm.f32(128.03)
		var9 = 0.0
		var10 = vm.f32(2.48)
		var11 = vm.f32(453.76)
		var12 = 40.0
		var13 = vm.f32(-22.55)
		var14 = vm.f32(619.7)
		var15 = 40.0
		var16 = vm.f32(-79.51)
		var17 = vm.f32(637.02)
		var18 = 40.0
		var19 = vm.f32(426.33)
	end
	monster.SetMos("走り", -1, 0)
	var31 = 8.0
	var24 = 0
	var23 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, _, out3 = monster.CopyVector(var8, var9, var10)
		var20 = out1 or var20
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.CopyVector(var8, var9, var10)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.CopyVector(var8, var9, var10)
		var25 = out1 or var25
		var26 = out2 or var26
		var27 = out3 or var27
	end
	do
		local out1, out2, out3 = monster.SubVector(var25, var26, var27, var0, var1, var2)
		var25 = out1 or var25
		var26 = out2 or var26
		var27 = out3 or var27
	end
	do
		local out1, out2, out3 = monster.NormalVector(var25, var26, var27)
		var25 = out1 or var25
		var26 = out2 or var26
		var27 = out3 or var27
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var25, var26, var27, var31)
		var25 = out1 or var25
		var26 = out2 or var26
		var27 = out3 or var27
	end
	var24 = 0
	while true do
		if var24 > 300 then
			break
		else
			do
				local out1, out2, out3 = monster.AddVector(var0, var1, var2, var25, var26, var27)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			var32 = monster.GetRefAngle(var0, var1, var2) or var32
			do
				local out1, out2, out3 = monster.GetTargetPos()
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			var6 = monster.GetTargetDist() or var6
			if var6 < 120.0 then
				break
			else
				var6 = monster.GetDistVector2(var20, 0.0, var22, var0, 0.0, var2) or var6
				print("dist=", var6, "-----------------------------\n")
				if var6 < vm.f32(var31 + 10.0) then
					var24 = 0
					var23 = var23 + 1
					if var23 > 3 then
						break
					end
					if var23 == 1 then
						do
							local out1, out2, out3 = monster.CopyVector(var11, var12, var13)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = monster.CopyVector(var11, var12, var13)
							var25 = out1 or var25
							var26 = out2 or var26
							var27 = out3 or var27
						end
						do
							local out1, _, out3 = monster.CopyVector(var11, var12, var13)
							var20 = out1 or var20
							var22 = out3 or var22
						end
					end
					if var23 == 2 then
						do
							local out1, out2, out3 = monster.CopyVector(var14, var15, var16)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = monster.CopyVector(var14, var15, var16)
							var25 = out1 or var25
							var26 = out2 or var26
							var27 = out3 or var27
						end
						do
							local out1, _, out3 = monster.CopyVector(var14, var15, var16)
							var20 = out1 or var20
							var22 = out3 or var22
						end
					end
					if var23 == 3 then
						do
							local out1, out2, out3 = monster.CopyVector(var17, var18, var19)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = monster.CopyVector(var17, var18, var19)
							var25 = out1 or var25
							var26 = out2 or var26
							var27 = out3 or var27
						end
						do
							local out1, _, out3 = monster.CopyVector(var17, var18, var19)
							var20 = out1 or var20
							var22 = out3 or var22
						end
					end
					do
						local out1, out2, out3 = monster.SubVector(var25, var26, var27, var0, var1, var2)
						var25 = out1 or var25
						var26 = out2 or var26
						var27 = out3 or var27
					end
					do
						local out1, out2, out3 = monster.NormalVector(var25, var26, var27)
						var25 = out1 or var25
						var26 = out2 or var26
						var27 = out3 or var27
					end
					do
						local out1, out2, out3 = monster.ScaleVector(var25, var26, var27, var31)
						var25 = out1 or var25
						var26 = out2 or var26
						var27 = out3 or var27
					end
				end
				monster.SetNextPos(var0, var1 - 20.0, var2, var31, var31 + 10.0)
				monster.SetNextRot(var32, helper_787df986(4.0))
				helper_19e0()
				var24 = var24 + 1
			end
		end
	end
	monster.ResetMove()
	helper_442b9962()
end

--- Helper function.
local function helper_2b84(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = arg2
	if arg1 < 3.0 then
		var9 = helper_787df986(3.0)
	else
		var9 = arg1
	end
	var7 = 0.0
	while var7 < var8 do
		do
			local _, out2, _ = monster.GetRot()
			var4 = out2 or var4
		end
		if var4 > vm.f32(arg0 - var9) and var4 < vm.f32(arg0 + var9) then
			helper_442b9962()
			break
		elseif helper_8971d3b6(arg0, var4, arg1) == 0 then
			helper_442b9962()
			break
		elseif var7 >= arg2 then
			helper_442b9962()
			break
		else
			helper_19e0()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5aac(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_2b84(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_72a4(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_5aac(arg1)
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	var18 = 0
	while var18 < arg3 do
		var13 = monster.GetTargetDist() or var13
		if var13 < arg2 then
			helper_442b9962()
			monster.ResetMove()
			return -1
		end
		var14 = monster.GetTargetAngle() or var14
		monster.SetNextRot(var14, arg1)
		monster.GetTargetPos()
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.GetRot()
		monster.GetTargetPos()
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.SubVector(var15, var16, var17, pos_x, pos_y, pos_z)
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
			local out1, out2, out3 = monster.ScaleVector(var15, var16, var17, arg0 + arg2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.AddVector(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		monster.SetNextPos(var15, pos_y - 20.0, var17, arg0, arg0)
		helper_19e0()
		var18 = var18 + 1
		monster.ResetMove()
		helper_442b9962()
	end
	return var18
end

--- Helper function.
local function helper_1a60(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_19e0()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_25ec4()
	local var1: f32 = 0
	local var3: s32 = 0
	do
		local _, out2, _ = monster.GetTargetPos()
		var1 = out2 or var1
	end
	if var1 > 1.0 then
		helper_18bbc()
	end
	monster.SetMos("走り", -1, 0)
	var3 = helper_72a4(8.0, 4.0, 45.0, 90)
	monster.SetMos("立ち", -1, 0)
	if var3 > 60 then
		monster.SetMos("息切れ", -1, 0)
		helper_1a60(90)
	end
end

--- Helper function.
local function helper_1c03c(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = monster.GetDistVector2(pos_x, pos_y, pos_z, arg0, arg1, arg2) or var3
	monster.GetRefAngle(arg0, arg1, arg2) -- retail: argument 4 is a value where the handler writes an output; the output is discarded
	var8 = monster.GetHigh() or var8
	if var8 > 20.0 then
		if helper_de1504df(arg0, vm.f32(arg1 + 1.0), arg2, var3, var7) ~= 0 then
			return 0
		end
	end
	var13 = monster.GetDistVector2(pos_x, pos_y, pos_z, arg0, arg1, arg2) or var13
	var12 = monster.SearchArea2(pos_x, pos_y + 1.0, pos_z, arg0, arg1 + 1.0, arg2) or var12
	if var12 < vm.f32(var13 - 1.0) then
		return 0
	end
	if arg1 < 3.0 then
		return 0
	end
	var8 = monster.GetHigh2(arg0, arg1, arg2) or var8
	if var8 < 0.0 or var8 <= -100000000.0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1f888(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.SubVector(var10, var11, var12, var7, var8, var9)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.NormalVector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var20 = monster.GetDistVector2(arg0, arg1, arg2, var7, var8, var9) or var20
	var19 = helper_9821a9e1(var20, arg3, vm.f32(vm.f32(vm.fdiv(vm.f32(var20 + arg4), arg3)) * arg5), var19)
	var21 = arg3
	var22 = 0
	while var22 < arg6 do
		var21 = vm.f32(var21 + var19)
		do
			local out1, out2, out3 = monster.GetPos_3()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local out1, out2, out3 = monster.CopyVector(var10, var11, var12)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var13, var14, var15, var21)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		if helper_1c03c(var7, var8, var9) == 0 then
			return
		end
		if var21 <= 0.0 then
			break
		else
			var20 = monster.GetDistVector2(arg0, arg1, arg2, var7, var8, var9) or var20
			if var20 < var21 then
				break
			elseif var8 < 0.0 then
				monster.SetPos(var7, 0.0, var9)
				break
			else
				monster.SetPos(var7, var8, var9)
				helper_19e0()
				var22 = var22 + 1
			end
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1e644(
	arg0: f32,
	arg1: f32,
	arg2: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: s32,
	arg8: s32
)
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	do
		local out1, out2, out3 = monster.GetPos_3()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.SubVector(var12, var13, var14, var9, var10, var11)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	x = vm.f32(vm.f32(var12 * vm.cos(arg5)) + vm.f32(var14 * vm.sin(arg5)))
	y = var13
	z = vm.f32(vm.f32(var12 * -vm.sin(arg5)) + vm.f32(var14 * vm.cos(arg5)))
	do
		local out1, out2, out3 = monster.NormalVector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	var26 = arg3
	var27 = 0
	while var27 < arg8 do
		if arg7 ~= 0 then
			do
				local out1, out2, out3 = monster.GetTargetPos()
				arg0 = out1 or arg0
				arg1 = out2 or arg1
				arg2 = out3 or arg2
			end
		end
		var12 = vm.f32(arg0 - var9)
		var13 = vm.f32(arg1 - var10)
		var14 = vm.f32(arg2 - var11)
		do
			local out1, out2, out3 = monster.NormalVector(var12, var13, var14)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var12, var13, var14, arg6)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = monster.ScaleVector(x, y, z, 1.0 - arg6)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.AddVector(x, y, z, var12, var13, var14)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.NormalVector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.CopyVector(x, y, z)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var18, var19, var20, var26)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.AddVector(var9, var10, var11, var18, var19, var20)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.GetRefRot_6(var9, var10, var11)
			var21 = out1 or var21
			var22 = out2 or var22
			var23 = out3 or var23
		end
		if var26 <= 0.0 then
			break
		else
			if helper_1c03c(var9, var10, var11) == 0 then
				return
			end
			var25 = monster.GetDistVector2(arg0, arg1, arg2, var9, var10, var11) or var25
			if var25 < arg4 or var25 < var26 then
				break
			elseif var10 <= 0.0 then
				break
			else
				monster.ResetMove()
				monster.SetPos(var9, var10, var11)
				monster.SetRot(var21, var22, var23)
				helper_19e0()
				var27 = var27 + 1
			end
		end
	end
	monster.SetRot(0.0, var22, 0.0)
	helper_442b9962()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_1c844(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
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
	monster.ResetMove()
	do
		local out1, out2, out3 = monster.GetPos_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.SubVector(var10, var11, var12, var7, var8, var9)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.NormalVector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var10, var11, var12, arg3)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	for var17 = 0, arg6 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, var10, var11, var12)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var16 = monster.GetDistVector2(var7, var8, var9, arg0, arg1, arg2) or var16
		if var16 < arg4 then
			return
		end
		do
			local out1, out2, out3 = monster.GetRefRot_6(var7, var8, var9)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		monster.SetPos(var7, var8, var9)
		if arg5 ~= 0 then
			monster.SetRot(var13, var14, var15)
		end
		helper_19e0()
	end
end

--- Helper function.
local function helper_221a0()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local height: f32 = 0
	local var9: f32 = 0
	var0 = helper_e2fdabb9(var0)
	if var0 < 110.0 then
		return
	end
	monster.VPush(15, 1)
	monster.SetAttrib(4, 1)
	monster.SetAttrib(16, 1)
	helper_18534(1)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetAttrib(32, 1)
	monster.SetMos("ドリル攻撃（入り）", -1, 6)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.GetHigh() or height
	height = vm.f32(pos_y - height)
	helper_1f888(pos_x, vm.f32(height + 60.0), pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), 25)
	monster.SetAttrib(32, 0)
	monster.SetMos("ドリル攻撃（ループ）", -1, 0)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	helper_1e644(var4, var5, var6, vm.f32(9.9), 15.0, vm.f32(0.7853982), vm.f32(0.2), 1, 90)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.GetHigh() or height
	height = vm.f32(pos_y - height)
	monster.SetMos("ドリル攻撃（戻り）", -1, 6)
	helper_18534(0)
	helper_1c844(pos_x, height, pos_z, vm.f32(0.6), 0.0, 0, 25)
	do
		local _, out2, _ = monster.GetRot()
		var9 = out2 or var9
	end
	monster.SetRot(0.0, var9, 0.0)
	monster.SetMos("立ち", -1, 0)
	helper_19e0()
	monster.SetAttrib(16, 0)
	monster.SetAttrib(4, 0)
	monster.VPush(15, 0)
end

--- Helper function.
local function helper_25b60()
	local var1: f32 = 0
	local var3: s32 = 0
	do
		local _, out2, _ = monster.GetTargetPos()
		var1 = out2 or var1
	end
	if var1 > 1.0 then
		helper_18bbc()
	else
		helper_221a0()
	end
	monster.SetMos("走り", -1, 0)
	var3 = helper_72a4(8.0, 4.0, 45.0, 150)
	monster.SetMos("立ち", -1, 0)
	if var3 > 60 then
		monster.SetMos("息切れ", -1, 0)
		helper_1a60(90)
	end
end

--- Helper function.
local function helper_bf18(arg0: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	arg0 = helper_787df986(arg0)
	while true do
		var1 = monster.GetTargetAngle() or var1
		monster.SetNextRot(var1, arg0)
		helper_19e0()
		var2 = monster.CheckMosEnd() or var2
		if var2 ~= 0 then
			helper_442b9962()
			break
		end
	end
end

--- Helper function.
local function helper_210b0()
	monster.SetMos("攻撃", -1, 2)
	helper_bf18(4.0)
	monster.SetMos("立ち", -1, 0)
	helper_19e0()
end

--- Helper function.
local function helper_21218()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var6 = vm.f32(-467.95)
	var8 = vm.f32(842.14)
	var5 = monster.GetDistVector2(pos_x, 0.0, pos_z, var6, 0.0, var8) or var5
	if var5 < 100.0 then
		return -2
	end
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetAttrib(32, 1)
	helper_18534(1)
	monster.SetMos("離陸", -1, 6)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.GetHigh() or height
	height = vm.f32(pos_y - height)
	do
		local _, out2, _ = monster.GetTargetPos()
		var10 = out2 or var10
	end
	var4 = 60.0
	if var10 > 2.0 then
		var4 = 80.0
	end
	helper_1f888(pos_x, var4, pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), helper_9df6409a(37))
	monster.SetAttrib(8, 0)
	monster.SetAttrib(32, 0)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	return 0
end

--- Helper function.
local function helper_4edc(arg0: f32, arg1: f32)
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
	local _ = helper_2b84(helper_28452e16(arg0), helper_28452e16(arg1), vm.f32(vm.fdiv(360.0, helper_28452e16(arg1))))
	helper_442b9962()
end

--- Helper function.
local function helper_22d04(arg0: s32)
	local height: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local argc: s32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	height = monster.GetHigh() or height
	if height < 30.0 then
		return
	end
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var6 = out2 or var6
	end
	var8 = monster.GetRndf(6.2831855) or var8
	var9 = monster.GetRndf(50.0) or var9
	var9 = vm.f32(var9 + 350.0)
	var11 = 0.0
	var12 = 0.0
	var13 = 450.0
	pos_x = vm.f32(var11 + vm.f32(vm.sin(var8) * var9))
	pos_y = vm.f32(var12 + pos_y)
	pos_z = vm.f32(var13 + vm.f32(vm.cos(var8) * var9))
	monster.SetMos("飛びループ", -1, 0)
	monster.GetRefAngle(pos_x, pos_y, pos_z)
	helper_4edc(helper_28452e16(var8), 4.0)
	helper_1c844(pos_x, pos_y, pos_z, 5.5, 5.5, 0, 300)
	if var15 >= 299 then
		return
	end
	var10 = var8
	var16 = 0
	var14 = 1.4e-42 -- retail: integer bits read as a float
	monster.ResetMove()
	while var16 < arg0 do
		pos_x = vm.f32(var11 + vm.f32(vm.sin(var10) * var9))
		pos_y = vm.f32(var12 + pos_y)
		pos_z = vm.f32(var13 + vm.f32(vm.cos(var10) * var9))
		var6 = monster.GetRefAngle(pos_x, pos_y, pos_z) or var6
		monster.SetPos(pos_x, pos_y, pos_z)
		monster.SetRot(0.0, var6, 0.0)
		argc = monster.GetMonsterNum() or argc
		if argc < 20 then
			if vm.imod(var16, 60) == 0 then
				monster.SetMos("爆弾攻撃", -1, 6)
				var14 = 0
			end
			if var14 == 35 then
				do
					local out1, out2, out3 = monster.GetFramePos("dco2")
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				monster.CreateMonster(1006, pos_x_2, pos_y_2, pos_z_2, 0.0)
			end
			if var14 == 50 then
				monster.SetMos("飛びループ", -1, 0)
			end
		end
		var10 = vm.f32(var10 + vm.f32(0.032724924))
		helper_19e0()
		var16 = var16 + 1
		var14 = vm.f32(var14 + 1)
	end
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_1da9c(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local pos_y: f32 = 0
	local height: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	var22 = 0.0
	monster.ResetMove()
	monster.SetAttrib(16, 1)
	var23 = 0
	while var23 < arg3 do
		arg0 = vm.f32(arg0 + var22)
		monster.GetTargetAngle()
		do
			local out1, out2, out3 = monster.GetPos_3()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local out1, out2, out3 = monster.CopyVector(var7, var8, var9)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		do
			local out1, out2, out3 = monster.SubVector(var10, var11, var12, var4, var5, var6)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		do
			local out1, out2, out3 = monster.NormalVector(var10, var11, var12)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var10, var11, var12, arg0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		do
			local out1, out2, out3 = monster.AddVector(var4, var5, var6, var10, var11, var12)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = monster.GetRefRot_6(var4, var5, var6)
			var19 = out2 or var19
		end
		if helper_1c03c(var4, var5, var6) == 0 then
			return
		end
		var21 = monster.GetDistVector2(var4, 0.0, var6, var7, 0.0, var9) or var21
		if var21 < 135.0 then
			var22 = vm.f32(-0.4)
		end
		if arg0 <= 0.0 then
			break
		else
			do
				local _, out2, _ = monster.GetPos_3()
				pos_y = out2 or pos_y
			end
			height = monster.GetHigh() or height
			height = vm.f32(pos_y - height)
			monster.SetPos(var4, arg2, var6)
			monster.SetNextRot(var19, helper_787df986(arg1))
			helper_19e0()
			var23 = var23 + 1
		end
	end
	monster.SetAttrib(16, 0)
end

--- Helper function.
local function helper_bd00(arg0: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(arg0)
	for var4 = 0, arg1 - 1 do
		var2 = monster.GetTargetAngle() or var2
		monster.SetNextRot(var2, arg0)
		helper_19e0()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1ba0()
	local var0: s32 = 0
	while true do
		helper_19e0()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_21a34()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local height: f32 = 0
	local argc: s32 = 0
	argc = monster.GetMonsterNum() or argc
	height = monster.GetHigh() or height
	if height > 5.0 and argc < 20 then
		monster.SetMos("爆弾攻撃", -1, 6)
		helper_bd00(4.0, helper_9df6409a(35))
		do
			local out1, out2, out3 = monster.GetFramePos("dco2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.GetRot()
			var4 = out2 or var4
		end
		monster.CreateMonster(1006, pos_x, pos_y, pos_z, var4)
		helper_1ba0()
	end
end

--- Helper function.
local function helper_23dd4(arg0: f32, arg1: any, arg2: s32)
	local height: f32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local argc: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	height = monster.GetHigh() or height
	if height < 20.0 then
		return -2
	end
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("飛びループ", -1, 0)
	monster.ResetMove()
	var16 = 0.0
	var4 = 0
	var5 = 999
	while var4 < arg2 do
		do
			local out1, out2, out3 = monster.GetPos_3()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var17 = helper_e2fdabb9(var17)
		if var17 > 120.0 or var4 < 10 then
			x, y, z = helper_1487c2ae(var16, 120.0, x, y, z)
			do
				local out1, out2, out3 = monster.SubVector(x, y, z, var7, var8, var9)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = monster.NormalVector(x, y, z)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			y = 0.0
			do
				local out1, out2, out3 = monster.ScaleVector(x, y, z, arg0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
		end
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, x, y, z)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local out1, out2, out3 = monster.GetRefRot_6(var7, var8, var9)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		if helper_1c03c(var7, var8, var9) == 0 then
			return -2
		end
		if var9 < 0.0 then
			return -2
		end
		if var8 <= 0.0 then
			break
		else
			do
				local _, out2, _ = monster.GetTargetPos()
				var19 = out2 or var19
			end
			if var19 > 3.0 then
				return -2
			end
			var17 = helper_e2fdabb9(var17)
			if var17 > 120.0 then
				var16 = vm.f32(var16 + 3.0)
			end
			monster.ResetMove()
			monster.SetPos(var7, var8, var9)
			monster.SetRot(var10, var11, var12)
			argc = monster.GetMonsterNum() or argc
			if argc < 20 then
				if vm.imod(var4, 60) == 0 then
					monster.ResetMotion()
					monster.SetMos("爆弾攻撃", -1, 6)
					var5 = 0
				end
				if var5 == 35 then
					var11 = monster.GetTargetAngle() or var11
					do
						local out1, out2, out3 = monster.GetFramePos("dco2")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					monster.CreateMonster(1006, pos_x, pos_y, pos_z, var11)
				end
				if var5 == 50 then
					monster.SetMos("飛びループ", -1, 0)
				end
			end
			helper_19e0()
			var4 = var4 + 1
			var5 = vm.i32(var5 + 1)
		end
	end
	monster.ResetMove()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	return 0
end

--- Helper function.
local function helper_21df4()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	helper_18534(0)
	monster.MySeStop(5)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.SetAttrib(32, 1)
	monster.SetMos("ドリル攻撃（入り）", -1, 6)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.GetHigh()
	helper_1f888(pos_x, 0.0, pos_z, vm.f32(7.7), 0.0, vm.f32(2.3), 37)
	monster.SetAttrib(32, 0)
end

--- Helper function.
local function helper_24f40()
	local life: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	life = 0.0
	do
		local _, out2, out3 = monster.GetTargetPos()
		var5 = out2 or var5
		var3 = out3 or var3
	end
	if var5 > 2.0 then
		helper_18bbc()
	end
	helper_210b0()
	do
		local _, out2, out3 = monster.GetTargetPos()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if var2 < 1.0 then
		argc = monster.GetRnd(100) or argc
		if argc < 85 then
			helper_221a0()
		end
	end
	monster.SetAttrib(4, 1)
	monster.SetAttrib(16, 1)
	monster.MySePlay(5)
	var9 = helper_21218()
	life = 0.0
	life = monster.GetMonsterLife() or life
	if life < vm.f32(0.2) then
		do
			local _, out2, out3 = monster.GetPos_3()
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = monster.GetTargetPos()
			var5 = out2 or var5
		end
		if var5 < 3.0 and var3 >= 0.0 then
			helper_22d04(300)
		end
	end
	monster.SetMos("飛びループ", -1, 0)
	do
		local _, out2, out3 = monster.GetPos_3()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	helper_1da9c(5.5, 4.0, var2, 90)
	helper_21a34()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		var9 = helper_23dd4(5.5, 60, 300)
	else
		var9 = -2
	end
	helper_21df4()
	monster.MySeStop(5)
	monster.SetAttrib(4, 0)
	monster.SetAttrib(16, 0)
	if var9 ~= -2 then
		monster.SetMos("息切れ", -1, 0)
		helper_1a60(90)
	end
	monster.SetMos("走り", -1, 0)
	var9 = helper_72a4(8.0, 4.0, 45.0, 90)
	monster.SetMos("立ち", -1, 0)
	if var9 > 30 then
		monster.SetMos("息切れ", -1, 0)
		helper_1a60(90)
	end
end

--- Helper function.
local function helper_261f8()
	local var0: f32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 > 450.0 then
		helper_25ec4()
	elseif var0 > 250.0 then
		helper_25b60()
	else
		helper_24f40()
	end
end

--- Helper function.
local function helper_cbf0()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_19e0()
	monster.SetActStatus(1)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	monster.SetClipDist(999999.9)
	monster.SetDmg2("中攻撃", 5.0, "攻撃", 0.587, 0.667, 1)
	monster.SetDmg2("通常攻撃", 5.0, "ドリル攻撃（入り）", 0.84, 1.0, 0)
	monster.SetDmg2("弱攻撃", 5.0, "ドリル攻撃（ループ）", 0.0, 0.5, 0)
	monster.SetDmg2("弱攻撃", 5.0, "ドリル攻撃（ループ）", 0.5, 1.0, 0)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("海賊爆弾爆発", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("ポルＪＥＴ", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	monster.SetCameraMode(0)
	helper_1bb24(2)
	helper_dd45b7cf(0.0)
	helper_1b6dc(2)
	helper_13830()
	monster.SetAttrib(256, 0)
	monster.SetAttrib(8, 0)
	monster.VPush(15, 0)
	monster.VPush(3, -99999)
	monster.VPush(4, -99999)
	helper_1cc8()
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, 0.0, pos_z)
	helper_ac26cdde(80.0)
	monster.SetScoop(1024)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var1: f32 = 0
	local var3: s32 = 0
	monster.VPush(15, 0)
	do
		local _, out2, _ = monster.GetRot()
		var1 = out2 or var1
	end
	monster.SetRot(0.0, var1, 0.0)
	var3 = helper_1ba44(var3)
	if var3 == 2 then
		monster.SetIntFlag(1, 0)
		monster.SetIntFlag(2, 0)
		monster.SetActStatus(0)
		monster.SetAttrib(4, 0)
		monster.SetAttrib(16, 0)
		monster.SetAttrib(32, 0)
		helper_18534(0)
	end
	if var3 == 1 then
		monster.SetIntFlag(1, 0)
		monster.SetIntFlag(2, 0)
		monster.SetActStatus(0)
		monster.SetAttrib(4, 1)
		monster.SetAttrib(16, 0)
		monster.SetAttrib(32, 0)
		helper_18534(0)
	end
	while true do
		helper_19e0()
		var3 = helper_1ba44(var3)
		if var3 == 2 then
			helper_261f8()
		else
			helper_1ef0d4b2()
		end
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	value = monster.VPop(15) or value
	if value == 1 then
		helper_5d37e9f4()
		var7 = monster.GetTargetAngle() or var7
		if var7 > vm.f32(3.1415927) then
			var7 = vm.f32(var7 - vm.f32(6.2831855))
		end
		if var7 <= vm.f32(-3.1415927) then
			var7 = vm.f32(var7 + vm.f32(6.2831855))
		end
		monster.SetMos("ダメージ", -1, 6)
		if var7 < vm.f32(0.7853982) and var7 >= vm.f32(-0.7853982) then
			monster.SetMos("ダメージ", -1, 6)
		end
		if var7 < vm.f32(2.3561945) and var7 >= vm.f32(0.7853982) then
			monster.SetMos("ダメージ右", -1, 6)
		end
		if var7 >= vm.f32(-2.3561945) and var7 < vm.f32(0.7853982) then
			monster.SetMos("ダメージ左", -1, 6)
		end
		if var7 >= vm.f32(2.3561945) and var7 < vm.f32(-2.3561945) then
			monster.SetMos("ダメージ後", -1, 6)
		end
		monster.BlowStart(4.0, 0.0, 3)
		helper_1ba0()
		helper_1a60(12)
		monster.SetMos("立ち")
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.GetRot()
			var5 = out2 or var5
		end
		if pos_y > 2.0 then
			helper_210b0()
			monster.SetRot(0.0, var5, 0.0)
		end
		if pos_y < 0.0 then
			monster.SetPos(pos_x, 0.0, pos_z)
			monster.SetRot(0.0, var5, 0.0)
		end
		helper_1ef0d4b2()
	end
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_cbf0()
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	helper_18534(0)
	monster.MySeStop(5)
	monster.SetAttrib(2, 1)
	monster.SetAttrib(64, 1)
	monster.SetAttrib(4, 0)
	monster.SetMos("死に", 6)
	helper_56d63eae()
	monster.SetMos("死に（ループ）", 0)
	monster.RunEventScript(500)
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
