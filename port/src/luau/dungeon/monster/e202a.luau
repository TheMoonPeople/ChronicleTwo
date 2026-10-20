--!strict
-- dungeon/monster/e202a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_661d392d = require("@lib/monster/helper_661d392d")
local helper_72fec261 = require("@lib/monster/helper_72fec261")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8566bb6e = require("@lib/monster/helper_8566bb6e")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f1703059 = require("@lib/monster/helper_f1703059")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

--- Helper function.
local function helper_10570()
	local argument_count: s32 = 0
	local att_type: s32 = 0
	argument_count = monster.GetBitFlag(51) or argument_count
	if argument_count == 0 then
		att_type = monster.GetAttType() or att_type
		if att_type == 0 then
			monster.SetBitFlag(51, 1)
			monster.RunEventScript(2510)
		end
	end
end

--- Helper function.
local function helper_1074c()
	local var0: s32 = 0
	local var1: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local pos_y: f32 = 0
	while true do
		helper_10570()
		if helper_661d392d(0, 180.0) == 0 then
			var0 = 1
			break
		else
			var1 = monster.GetTargetDist() or var1
			if var1 > 360.0 then
				var0 = 0
				break
			else
				priority = monster.GetPriority() or priority
				if priority > 3 and var1 < 120.0 then
					var0 = 4
					break
				else
					if helper_661d392d(0, 60.0) ~= 0 then
						if var1 < 60.0 then
							var0 = 2
							break
						end
						argc = monster.GetRnd(200) or argc
						if argc < 1 then
							var0 = 3
							break
						end
					end
					monster.SetMos("歩き", -1.0, 0)
					do
						local out1, _, out3 = monster.GetTargetPos()
						var4 = out1 or var4
						var6 = out3 or var6
					end
					helper_82cb5588(vm.f32(0.05235988))
					do
						local _, out2, _ = monster.GetPos_3()
						pos_y = out2 or pos_y
					end
					monster.SetNextPos(var4, pos_y - 20.0, var6, 1.5, 1.5)
					vm.wait()
					monster.ResetMove()
				end
			end
		end
	end
	return var0
end

--- Helper function.
local function helper_10e54()
	local var1: f32 = 0
	local var3: f32 = 0
	monster.SetMos("歩き", -1.0, 0)
	while true do
		helper_82cb5588(vm.f32(0.07853982))
		do
			local _, out2, _ = monster.GetRot()
			var1 = out2 or var1
		end
		var3 = monster.GetTargetAngle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.1)) == 0 then
			helper_442b9962()
			break
		else
			vm.wait()
		end
	end
end

--- Helper function.
local function helper_110e8()
	local attack: s32 = 0
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local chara_type: s32 = 0
	var1 = monster.GetTargetDist() or var1
	attack = monster.GetBaseAttack_1() or attack
	if var1 < 40.0 then
		monster.SetMos("攻撃２", -1, 2)
		helper_72fec261(vm.f32(0.711), -1.0)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.EsmCreate_1("ヴァンガード衝撃波")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetValue(-1, 0, attack)
		helper_56d63eae()
		return 30
	end
	if var1 < 60.0 then
		monster.ResetMove()
		monster.SetMos("攻撃１", -1, 2)
		helper_56d63eae()
		return 30
	end
	if var1 < 120.0 then
		helper_93495fdf()
		vm.wait()
		monster.SetMos("攻撃３in", -1, 6)
		helper_56d63eae()
		monster.SetMos("攻撃３", -1, 4)
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		monster.GetPos_3()
		monster.SetNextPos(var5, var6, var7, 3.5, 10.0)
		chara_type = monster.GetUserid() or chara_type
		monster.EsmCreate_1("スピン")
		monster.EsmSetUserId(-1, chara_type)
		monster.EsmSetValue(-1, 1, vm.ftoi(vm.f32(var1 / 3.5)))
		monster.EsmSetValueFloat(-1, 2, 1.0)
		helper_8566bb6e(vm.f32(var1 / 3.5))
		helper_f683d690()
		monster.ResetMove()
		monster.SetMos("攻撃３out", -1, 6)
		helper_56d63eae()
		return 12
	end
	return 0
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local grade: s32 = 0
	monster.SetDmg2("弱攻撃", 4.0, "攻撃１", 0.3, 0.5, 1)
	monster.SetDmg2("弱攻撃", 4.0, "攻撃１", 0.3, 0.5, 2)
	monster.SetDmg2("吹っ飛び攻撃", 4.5, "攻撃３", 0.0, 1.0, 1)
	monster.SetDmg2("吹っ飛び攻撃", 4.5, "攻撃３", 0.0, 1.0, 2)
	monster.SetDmg2("吹っ飛び攻撃", 4.5, "攻撃３out", 0.1, 0.5, 1)
	monster.SetDmg2("吹っ飛び攻撃", 4.5, "攻撃３out", 0.1, 0.5, 2)
	monster.LoadEffectScript("ヴァンガード衝撃波")
	monster.LoadEffectScript("スピン")
	grade = monster.GetMonsGrade_2(-1) or grade
	if grade == 0 then
		monster.SetScoop("攻撃２", 0.267, 0.622, 1018)
	end
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var1: s32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local argc_2: s32 = 0
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.GetGekirin()
	while true do
		helper_f1703059()
		vm.wait()
		helper_10570()
		var3 = monster.GetTargetDist() or var3
		if var3 < 360.0 then
			var1 = helper_1074c()
		end
		if var3 >= 360.0 then
			var1 = 0
		end
		if var1 == 0 then
			monster.SetMos("立ち")
			argc = vm.i32(argc - 1)
			if argc > 0 then
				continue
			end
			argc = monster.GetRnd(60) or argc
			argc = vm.i32(argc + 30)
			do
				local _, out2, _ = monster.GetRot()
				var5 = out2 or var5
			end
			var7 = monster.GetTargetAngle() or var7
			if helper_8971d3b6(var7, var5, vm.f32(0.1)) == 0 then
				continue
			end
			monster.SetMos("歩き")
			while true do
				helper_82cb5588(vm.f32(0.05235988))
				do
					local _, out2, _ = monster.GetRot()
					var5 = out2 or var5
				end
				var7 = monster.GetTargetAngle() or var7
				if helper_8971d3b6(var7, var5, vm.f32(0.1)) == 0 then
					helper_442b9962()
					break
				else
					vm.wait()
				end
			end
			monster.SetMos("立ち")
		end
		if var1 == 1 then
			helper_10e54()
		end
		if var1 == 2 then
			var8 = helper_110e8()
			monster.SetMos("立ち")
			helper_c3e8ae39(var8)
		end
		if var1 == 3 then
			helper_10e54()
			var9 = helper_110e8()
			monster.SetMos("立ち")
			helper_c3e8ae39(var9)
		end
		if var1 == 4 then
			monster.ResetMove()
			helper_442b9962()
			monster.SetMos("立ち")
			if helper_661d392d(0, 60) == 0 then
				argc_2 = monster.GetRnd(100) or argc_2
				if argc_2 < 2 then
					monster.SetMos("歩き")
					helper_10e54()
					monster.SetMos("立ち")
				end
			end
		end
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.GetStsAttr(40) or var0
		vm.wait()
	end
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(8)
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(8)
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	monster.SetIntFlag(2, 1)
	argc = monster.GetRnd(100) or argc
	if argc < 10 then
		monster.SetMuteki(30)
		helper_110e8()
	end
	monster.SetIntFlag(2, 0)
end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
end

--- Stuns the monster.
function script.on_stun()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ダメージ", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.SetMos("気絶", -1)
	helper_27f80314()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

return script
