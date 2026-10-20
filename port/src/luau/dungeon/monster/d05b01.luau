--!strict
-- dungeon/monster/d05b01.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31139918 = require("@lib/monster/helper_31139918")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_661d392d = require("@lib/monster/helper_661d392d")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8566bb6e = require("@lib/monster/helper_8566bb6e")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_3380()
	local var0: s32 = 0
	monster.SetMos("2連続攻撃", -1, 2)
	var0 = 0
	while var0 < 18 do
		helper_82cb5588(vm.f32(0.19634955))
		var0 = var0 + 1
		vm.wait()
	end
	helper_56d63eae()
	monster.ResetMove()
	monster.SetMos("立ち")
	helper_c3e8ae39(3)
end

--- Helper function.
local function helper_3620()
	local var0: f32 = 0
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	monster.SetMos("中距離攻撃", -1, 2)
	helper_c3e8ae39(14)
	var5 = 0
	while var5 < 6 do
		var0 = monster.GetTargetDist() or var0
		var0 = vm.f32(var0 - 12.0)
		if var0 > 60.0 then
			var0 = 60.0
		end
		var1 = vm.f32(var0 / 10.0)
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, var0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.SetNextPos(pos_x, pos_y, pos_z, var1, var1)
		helper_82cb5588(vm.f32(0.19634955))
		var0 = vm.f32(var0 - var1)
		var5 = var5 + 1
		vm.wait()
	end
	helper_c3e8ae39(4)
	monster.ResetMove()
	helper_442b9962()
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_c3e8ae39(3)
end

--- Helper function.
local function helper_191c()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local argc: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	attack = monster.GetBaseAttack_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.2)))
	monster.SetMos("魔法", -1, 2)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetRot()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	print("magic---------------------\n")
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		var5 = vm.f32(var5 - vm.f32(0.62831855))
		monster.EsmCreate_1("ギル魔法２")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetVect2(-1, var4, var5, var6)
		monster.EsmSetValue(-1, 0, attack)
		monster.EsmSetTargetId(-1, 0)
		var5 = vm.f32(var5 + vm.f32(1.2566371))
		monster.EsmCreate_1("ギル魔法２")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetVect2(-1, var4, var5, var6)
		monster.EsmSetValue(-1, 0, attack)
		monster.EsmSetTargetId(-1, 0)
	else
		monster.EsmCreate_1("ギル魔法２")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetVect2(-1, var4, var5, var6)
		monster.EsmSetValue(-1, 0, attack)
		monster.EsmSetTargetId(-1, 0)
	end
	monster.SetAttrib(32, 1)
	helper_c3e8ae39(48)
	monster.SetAttrib(32, 0)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("立ち")
	helper_c3e8ae39(3)
end

--- Helper function.
local function helper_25bc()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local attack: s32 = 0
	local var9: s32 = 0
	local argc: s32 = 0
	var6 = monster.GetTargetDist() or var6
	if var6 < 90.0 then
		helper_191c()
		return
	end
	monster.SetMos("魔法2", -1, 6)
	helper_56d63eae()
	argc = monster.GetRnd(2) or argc
	var9 = 0
	while var9 < vm.i32(argc + 3) do
		monster.SetMos("魔法2発動", -1, 6)
		monster.EsmCreate_1("ギル２魔法Ｌ")
		do
			local out1, out2, out3 = monster.GetFramePos("magic")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetRot()
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		attack = monster.GetBaseAttack_1() or attack
		attack = vm.ftoi(vm.f32(attack * vm.f32(1.1)))
		var7 = monster.GetUserid(-1) or var7
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetVect2(-1, var3, var4, var5)
		monster.EsmSetUserId(-1, var7)
		monster.EsmSetTargetId(-1, 0)
		monster.EsmSetValue(-1, 0, 1)
		monster.EsmSetValue(-1, 1, attack)
		helper_56d63eae()
		monster.SetMos("魔法2L", -1, 0)
		helper_c3e8ae39(9)
		var9 = var9 + 1
	end
	monster.SetMos("魔法2戻り", -1, 6)
	helper_56d63eae()
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_3b78()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local angle: f32 = 0
	local argc: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.ResetMove()
	helper_442b9962()
	vm.wait()
	var0 = monster.GetTargetDist() or var0
	if var0 < 40.0 then
		monster.ResetMotion()
		monster.SetMos("ムーンサルト", -1, 2)
		helper_c3e8ae39(8)
		monster.SetAttrib(49, 1)
		var7 = monster.GetTargetAngle() or var7
		angle = vm.f32(var7 - vm.f32(3.1415927))
		angle = monster.AngleLimit(angle) or angle
		monster.SetNextRot(angle, 0.1308997)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var0 = vm.f32(var0 * 2.5)
		var4 = vm.f32(vm.f32(vm.sin(var7) * var0) + pos_x)
		var5 = vm.f32(0.0 + pos_y)
		var6 = vm.f32(vm.f32(vm.cos(var7) * var0) + pos_z)
		var0 = vm.f32(var0 / 24.0)
		monster.SetNextPos(var4, var5, var6, var0, var0)
		helper_c3e8ae39(28)
		monster.SetAttrib(49, 0)
		if helper_661d392d(0, 45.0) ~= 0 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					helper_191c()
				else
					helper_25bc()
				end
			end
		end
		helper_c3e8ae39(10)
		monster.SetMos("立ち", -1, 4)
		vm.wait()
		var0 = monster.GetTargetDist() or var0
		if (if var0 < 80.0 then helper_661d392d(0, 45.0) else 0) ~= 0 then
			if var0 < 50.0 then
				helper_3380()
			else
				helper_3620()
			end
			helper_c3e8ae39(3)
		end
	end
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
end

--- Helper function.
local function helper_46f8()
	local var0: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local arrived: s32 = 0
	local argc: s32 = 0
	local var10: f32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 > 80.0 then
		monster.SetMos("走り")
		while true do
			do
				local out1, out2, out3 = monster.GetTargetPos()
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			monster.SetNextPos(var4, var5, var6, 6.8, 40.0)
			helper_82cb5588(vm.f32(0.19634955))
			arrived = monster.ChkMoveEnd() or arrived
			if arrived ~= 0 then
				monster.SetMos("立ち")
				break
			end
			vm.wait()
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc > 95 then
		var10 = monster.GetTargetDist() or var10
		if var10 < 50.0 then
			helper_3380()
		else
			helper_3620()
		end
	else
		helper_3b78()
	end
	helper_c3e8ae39(3)
end

--- Helper function.
local function helper_4bfc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: s32 = 0
	local argc: s32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 < 180.0 then
		var1 = monster.GetTargetAngle() or var1
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var1 = vm.f32(var1 - vm.f32(3.1415927))
		var1 = monster.AngleLimit(var1) or var1
		var2 = vm.f32(vm.f32(vm.sin(var1) * 80.0) + pos_x)
		var3 = vm.f32(0.0 + pos_y)
		var4 = vm.f32(vm.f32(vm.cos(var1) * 80.0) + pos_z)
		monster.SetMos("ステップ後", -1, 2)
		helper_c3e8ae39(10)
		monster.SetNextPos(var2, var3, var4, 8.0, 8.0)
		var8 = 0
		while var8 < 20 do
			helper_82cb5588(vm.f32(0.19634955))
			var8 = var8 + 1
			vm.wait()
		end
		monster.ResetMove()
		helper_442b9962()
	elseif helper_661d392d(0, 90) == 0 then
		helper_46f8()
		return
	end
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		helper_191c()
	else
		helper_25bc()
	end
end

--- Helper function.
local function helper_534c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local yaw: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local life: f32 = 0
	local angle: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local yaw_2: f32 = 0
	local argc: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = monster.GetDistVector2(var4, var5, var6, -2195.0, 488.0, -475.0) or var7
	var3 = monster.GetDistVector2(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or var3
	var9 = monster.GetPosrefAngle(-2195.0, 488.0, -475.0, pos_x, pos_y, pos_z) or var9
	yaw = monster.GetPosrefAngle(-2195.0, 488.0, -475.0, var4, var5, var6) or yaw
	life = 1.0
	life = monster.GetMonsterLife() or life
	if life < vm.f32(0.4) then
		angle = vm.f32(var9 - vm.f32(3.1415927))
		angle = monster.AngleLimit(angle) or angle
		var16 = vm.f32(340.0 - var3)
		if var16 > 270.0 then
			var16 = 270.0
		end
		var11 = vm.f32(vm.f32(vm.sin(angle) * var16) + -2195.0)
		var12 = 488.0
		var13 = vm.f32(vm.f32(vm.cos(angle) * var16) + -475.0)
		var18 = 0
		monster.ResetMotion()
		monster.SetMos("ムーンサルト", -1, 2)
		helper_c3e8ae39(8)
		monster.SetAttrib(53, 1)
		monster.SetNextRot(var9, 0.19634955)
		while var18 < 24 do
			var22 = vm.f32(vm.f32(vm.f32(vm.f32(var12 - pos_y) * 2.0) - -62.5) / 50.0)
			var20 = pos_y
			var17 = 0
			while var17 < var18 do
				var22 = vm.f32(var22 + vm.f32(-0.1))
				var20 = vm.f32(var20 + var22)
				var17 = vm.f32(var17 + 1)
			end
			if var20 < var12 then
				var20 = var12
			end
			var19 = vm.f32(vm.f32(vm.f32(var11 - pos_x) * vm.f32(var18 / 24.0)) + pos_x)
			var21 = vm.f32(vm.f32(vm.f32(var13 - pos_z) * vm.f32(var18 / 24.0)) + pos_z)
			monster.SetPos(var19, var20, var21)
			var18 = var18 + 1
			vm.wait()
		end
		helper_c3e8ae39(28)
		monster.SetAttrib(53, 0)
		helper_c3e8ae39(10)
		monster.SetMos("立ち", -1, 4)
		vm.wait()
	else
		monster.SetMos("走り")
		if var7 < var3 then
			var8 = vm.f32(vm.f32(300.0 - var3) / 60.0)
			yaw = vm.f32(yaw - var9)
			var23 = 0
			while var23 < 60 do
				if yaw >= 0.0 then
					var9 = vm.f32(var9 - vm.f32(0.05235988))
				else
					var9 = vm.f32(var9 + vm.f32(0.05235988))
				end
				var9 = monster.AngleLimit(var9) or var9
				var3 = vm.f32(var3 + var8)
				var11 = vm.f32(vm.f32(vm.sin(var9) * var3) + -2195.0)
				var12 = 488.0
				var13 = vm.f32(vm.f32(vm.cos(var9) * var3) + -475.0)
				do
					local out1, out2, out3 = monster.GetPos_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				yaw_2 = monster.GetPosrefAngle(pos_x, pos_y, pos_z, var11, var12, var13) or yaw_2
				if var23 < 56 then
					monster.SetNextRot(yaw_2, 0.19634955)
				else
					helper_82cb5588(vm.f32(0.19634955))
				end
				monster.SetNextPos(var11, var12, var13, 6.8, 6.8)
				var23 = var23 + 1
				vm.wait()
			end
			helper_c3e8ae39(6)
			monster.ResetMove()
		else
			if helper_8971d3b6(var9, yaw, vm.f32(1.5707964)) == 0 then
				var9 = vm.f32(var9 - vm.f32(3.1415927))
			end
			var9 = monster.AngleLimit(var9) or var9
			var11 = vm.f32(vm.f32(vm.sin(var9) * 300.0) + -2195.0)
			var12 = 488.0
			var13 = vm.f32(vm.f32(vm.cos(var9) * 300.0) + -475.0)
			var3 = monster.GetDistVector2(pos_x, pos_y, pos_z, var11, var12, var13) or var3
			var9 = monster.GetPosrefAngle(pos_x, pos_y, pos_z, var11, var12, var13) or var9
			monster.SetNextRot(var9, 0.19634955)
			monster.SetNextPos(var11, var12, var13, 6.8, 6.8)
			helper_8566bb6e(vm.f32(vm.f32(var3 / vm.f32(6.8)) - 10.0))
			helper_82cb5588(vm.f32(0.19634955))
			helper_c3e8ae39(16)
			monster.ResetMove()
		end
	end
	helper_442b9962()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		helper_191c()
	else
		helper_25bc()
	end
end

--- Helper function.
local function helper_8270()
	local var0: f32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local argc_2: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	var0 = monster.GetTargetDist() or var0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc_2 = monster.GetRnd(100) or argc_2
		if argc_2 < 50 then
			var7 = 90
			monster.ResetMotion()
			monster.SetMos("ステップ右", -1, 2)
		else
			var7 = -90
			monster.ResetMotion()
			monster.SetMos("ステップ左", -1, 2)
		end
		if var0 < 30.0 then
			var0 = 30.0
		end
		var2, var3, var4 = helper_31139918(var7, var0, var2, var3, var4)
		helper_c3e8ae39(8)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var5 = monster.GetDistVector2(var2, var3, var4, pos_x, pos_y, pos_z) or var5
		var5 = vm.f32(var5 / 10.0)
		monster.SetNextPos(var2, var3, var4, var5, var5)
		var8 = 0
		while var8 < 13 do
			helper_82cb5588(vm.f32(0.19634955))
			var8 = var8 + 1
			vm.wait()
		end
		monster.ResetMove()
		helper_442b9962()
	end
	if var0 < 60.0 then
		if helper_661d392d(0, 45.0) ~= 0 then
			if var0 < 50.0 then
				helper_3380()
			else
				helper_3620()
			end
			helper_c3e8ae39(16)
		else
			helper_3b78()
		end
	end
end

--- Helper function.
local function helper_72b8()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local yaw: f32 = 0
	local arrived: s32 = 0
	local var17: f32 = 0
	while true do
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.GetRot()
			var11 = out2 or var11
		end
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var13 = monster.GetPosrefAngle(var7, var8, var9, -2195.0, 488.0, -475.0) or var13
		yaw = monster.GetPosrefAngle(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or yaw
		if helper_8971d3b6(var13, yaw, vm.f32(0.3926991)) == 0 then
			monster.ResetMove()
			helper_442b9962()
			return 0
		end
		var14 = monster.GetTargetDist() or var14
		if var14 > 120.0 then
			return 1
		end
		var4 = vm.f32(vm.f32(vm.sin(var13) * 140.0) + var7)
		var5 = vm.f32(0.0 + var8)
		var6 = vm.f32(vm.f32(vm.cos(var13) * 140.0) + var9)
		var14 = monster.GetDistVector2(pos_x, pos_y, pos_z, var4, var5, var6) or var14
		if var14 <= 22.0 then
			arrived = monster.ChkMoveEnd() or arrived
			if arrived ~= 0 then
				monster.SetMos("立ち")
			end
			if var0 > 90 then
				return 0
			end
			var0 = var0 + 1
			vm.wait()
			continue
		end
		var0 = 0
		var17 = vm.f32(var14 / 30.0)
		if var17 > 1.5 then
			var17 = 1.5
		end
		monster.SetNextPos(var4, var5, var6, var17, var17)
		helper_82cb5588(vm.f32(0.19634955))
		var13 = monster.GetPosrefAngle(pos_x, pos_y, pos_z, var4, var5, var6) or var13
		var13 = monster.AngleLimit(var13) or var13
		if helper_8971d3b6(vm.f32(var11 + vm.f32(1.5707964)), var13, vm.f32(0.7853982)) == 0 then
			monster.SetMos("バトル歩き(左)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(vm.f32(var11 - vm.f32(1.5707964)), var13, vm.f32(0.7853982)) == 0 then
			monster.SetMos("バトル歩き(右)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(var11, var13, vm.f32(1.5707964)) == 0 then
			monster.SetMos("バトル歩き(前)")
			vm.wait()
			continue
		end
		if helper_8971d3b6(vm.f32(var11 + vm.f32(3.1415927)), var13, vm.f32(1.5707964)) == 0 then
			monster.SetMos("バトル歩き(後)")
			vm.wait()
			continue
		end
	end
	return 0
end

--- Helper function.
local function helper_8aa8(arg0: any)
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local life: f32 = 0
	local var8: s32 = 0
	var2 = monster.GetTargetDist() or var2
	var3 = monster.GetActiveMonsLifef(-1) or var3
	if var3 < 0.5 then
		var4 = 45.0
	else
		var4 = 60.0
	end
	if var2 > var4 then
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			helper_4bfc()
		end
	end
	if var2 < 60.0 then
		life = 1.0
		life = monster.GetMonsterLife() or life
		monster.GetRndf(100.0)
		if life < vm.f32(0.4) then
		else
		end
		if false then
			helper_534c()
		else
			helper_8270()
		end
		return
	end
	var8 = helper_72b8()
	if var8 == 0 then
		helper_46f8()
	end
	if var8 == 1 then
		helper_4bfc()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetObj(1, "ken")
	monster.SetObj(2, "obj86")
	monster.SetDmg2("Ｍ連撃２", 6.0, "2連続攻撃", 0.283, 0.391, 0)
	monster.SetDmg2("Ｍ連撃２", 6.0, "2連続攻撃", 0.609, 0.696, 0)
	monster.SetDmg2("通常攻撃", 6.0, "中距離攻撃", 0.5, 0.611, 0)
	monster.SwEffect(0, "2連続攻撃", 0.2, 0.26, "ken01", "ken00", 77, 20, 20)
	monster.SwEffect(0, "2連続攻撃", 0.58, 0.6, "ken01", "ken00", 77, 20, 20)
	monster.SwEffect(0, "中距離攻撃", 0.41, 0.45, "ken01", "ken00", 77, 20, 20)
	monster.SwEffect(0, "ムーンサルト", 0.1, 0.3, "ken01", "ken00", 77, 40, 20)
	monster.SetCameraMode(0)
	monster.LoadEffectScript("ギルトーニシールド")
	monster.LoadEffectScript("ギル魔法２")
	monster.LoadEffectScript("ギル魔法サブ２")
	monster.LoadEffectScript("ギル２魔法Ｌ")
	monster.LoadEffectScript("ギル２魔法Ｈ")
	monster.SetClipDist(9999.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_8aa8(var0)
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_c3e8ae39(16)
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(5.0, 0.05, 20)
	helper_56d63eae()
	monster.SetActStatus(1)
	helper_c3e8ae39(30)
	monster.SetActStatus(0)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetAttrib(32, 1)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetAttrib(32, 0)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
end

--- Guards against a hit.
function script.on_guard()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetRot()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.EsmCreate_1("ギルトーニシールド")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.SetMos("ガード", -1, 6)
	monster.BlowStart(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = helper_3b78

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.ResetMove()
	helper_442b9962()
	monster.SetAttrib(2, 1)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetDeadStart()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(30)
	monster.RunEventScript(560)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

return script
