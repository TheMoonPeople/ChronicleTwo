--!strict
-- dungeon/monster/b204a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_27edc45c = require("@lib/monster/helper_27edc45c")
local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d2a0b202 = require("@lib/monster/helper_d2a0b202")

--- Helper function.
local function helper_20c8()
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
local function helper_1af0()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.SetDeadStart()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1d00()
	local value: s32 = 0
	value = monster.VPop(64) or value
	if value ~= 0 then
		helper_1af0()
	end
end

--- Helper function.
local function helper_1de0()
	helper_1d00()
	vm.wait()
end

--- Helper function.
local function helper_2f84(arg0: f32, arg1: f32, arg2: f32)
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
			helper_1de0()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5eac(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_2f84(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_7788(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_5eac(arg1)
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
			return
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
		helper_1de0()
		var18 = var18 + 1
		monster.ResetMove()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_11240()
	local var4: f32 = 0
	local value: s32 = 0
	local attack: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local argc_2: s32 = 0
	if helper_d2a0b202() > 300 then
		monster.ResetMove()
		helper_442b9962()
		monster.SetDeadStart()
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.EsmCreate_1("Ｍ小爆発")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetValue(-1, 0, attack)
		monster.SetMos("死に", -1, 6)
		helper_56d63eae()
		monster.SetDeadOff()
		while true do
			vm.wait()
		end
	end
	attack = monster.GetBaseAttack_1() or attack
	vm.wait()
	value = monster.VPop(0) or value
	if value == 0 then
		helper_442b9962()
		monster.ResetMotion()
		monster.SetMos("歩き", -1, 0)
		helper_5eac(4.5)
		monster.ResetMotion()
		monster.SetMos("攻撃１out", -1, 6)
		helper_56d63eae()
		monster.VPush(0, 1)
	end
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("攻撃１", -1, 0)
		helper_7788(4.5, 4.5, 21.0, 100)
	end
	var4 = monster.GetTargetDist() or var4
	if var4 < 42.0 then
		monster.ResetMove()
		helper_442b9962()
		monster.SetDeadStart()
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.EsmCreate_1("Ｍ小爆発")
		monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
		monster.EsmSetValue(-1, 0, attack)
		monster.SetMos("死に", -1, 6)
		helper_56d63eae()
		argc_2 = monster.GetMonsterNum() or argc_2
		if argc_2 <= 1 then
			monster.RunEventScript(510)
		end
		monster.SetDeadOff()
		while true do
			vm.wait()
		end
	end
	monster.ResetMotion()
	monster.SetMos("攻撃１out", -1, 6)
	helper_56d63eae()
	monster.SetMos("立ち", -1, 0)
	vm.wait()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetDmg2("コトレン攻撃", 4.5, "攻撃１", 0.0, 1.0, 0)
	monster.ResetTimer()
	helper_27edc45c()
	monster.VPush(0, 0)
	monster.VPush(1, 0)
	monster.VPush(2, 0)
	monster.VPush(3, 0)
	helper_20c8()
	monster.SetAttrib(16, 1)
	monster.SetClipDist(10000000.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		vm.wait()
		helper_11240()
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
	helper_c3e8ae39(12)
	monster.SetMos("立ち")
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.SetDeadStart()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
	monster.SetMos("死に", -1, 2)
	helper_56d63eae()
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.SetMos("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_c3e8ae39(10)
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.SetMos("ダメージ", -1, 6)
	helper_c3e8ae39(12)
	monster.SetMos("気絶", -1)
	helper_27f80314()
end

return script
