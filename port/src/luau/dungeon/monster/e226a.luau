--!strict
-- dungeon/monster/e226a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01663a12 = require("@lib/monster/helper_01663a12")
local helper_09acbcc2 = require("@lib/monster/helper_09acbcc2")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1be0f106 = require("@lib/monster/helper_1be0f106")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_34e0511a = require("@lib/monster/helper_34e0511a")
local helper_3d0d0c5c = require("@lib/monster/helper_3d0d0c5c")
local helper_3df77102 = require("@lib/monster/helper_3df77102")
local helper_3e764841 = require("@lib/monster/helper_3e764841")
local helper_4077f308 = require("@lib/monster/helper_4077f308")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_4772ab41 = require("@lib/monster/helper_4772ab41")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a5c03b2 = require("@lib/monster/helper_6a5c03b2")
local helper_6fca5c97 = require("@lib/monster/helper_6fca5c97")
local helper_7ea3f35f = require("@lib/monster/helper_7ea3f35f")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_895326d8 = require("@lib/monster/helper_895326d8")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_91b30ebf = require("@lib/monster/helper_91b30ebf")
local helper_9944827a = require("@lib/monster/helper_9944827a")
local helper_9d1ba522 = require("@lib/monster/helper_9d1ba522")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_e31a3310 = require("@lib/monster/helper_e31a3310")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_1cec()
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
local function helper_18f14()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("歩き", -1, 0)
	helper_f5727415(vm.f32(7.2000003))
	monster.SetMos("攻撃２", -1, 6)
	do
		local out1, out2, out3 = monster.GetFramePos("face")
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
	helper_9944827a(vm.f32(4.8), vm.f32(0.592), -1.0)
	monster.EsmCreate_1("風弾Ｆ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var4, var5, var6)
	helper_4077f308(vm.f32(0.608), -1.0)
	monster.EsmCreate_1("風弾Ｌ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var4, var5, var6)
	monster.EsmSetValue(-1, 0, attack)
	helper_895326d8()
	monster.SetMos("立ち", -1, 0)
	helper_45797ccb(9)
end

--- Helper function.
local function helper_1b3d0()
	local argc: s32 = 0
	local var2: f32 = 0
	var2 = helper_e2fdabb9(var2)
	argc = monster.GetRnd(100) or argc
	if argc < 80 then
		argc = monster.GetRnd(100) or argc
		if argc < 20 then
			helper_e31a3310()
		else
			helper_18f14()
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 25 then
			monster.SetMos("歩き", -1, 0)
			helper_6a5c03b2(1.75, vm.f32(4.8), 90.0, 60)
			helper_6fca5c97(1.75, vm.f32(4.8), 30.0, 30.0, 0, 90)
			monster.SetMos("立ち", -1, 0)
		else
			monster.SetMos("立ち", -1, 0)
			helper_3e764841(30.0, 45.0, 75)
		end
	end
end

--- Helper function.
local function helper_1abe8()
	local argc: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	var4 = helper_e2fdabb9(var4)
	argc = monster.GetRnd(100) or argc
	if argc < 60 then
		helper_18f14()
	else
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			helper_e31a3310()
		else
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				argc = monster.GetRnd(100) or argc
				var6 = monster.GetRndf(60.0) or var6
				if argc < 50 then
					var6 = vm.f32(-var6 - 30.0)
				else
					var6 = vm.f32(var6 + 30.0)
				end
				monster.SetMos("歩き", -1, 0)
				helper_9d1ba522(1.75, vm.f32(4.8), var6, 60.0, 1.0, 30.0, 75)
				helper_f5727415(vm.f32(4.8))
				monster.SetMos("立ち", -1, 0)
				helper_45797ccb(9)
			else
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var7 = 1
					monster.SetMos("ステップ右", -1, 0)
				else
					var7 = 0
					monster.SetMos("ステップ左", -1, 0)
				end
				helper_01663a12(1.75, 30.0, 30.0, var7, 60)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_1b850()
	local var0: f32 = 0
	local priority: s32 = 0
	while true do
		helper_461f64ff()
		monster.GetMonsterLife()
		helper_3d0d0c5c()
		var0 = helper_e2fdabb9(var0)
		if var0 > 190.0 then
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 1 then
			helper_34e0511a()
			continue
		end
		if var0 < 190.0 and var0 >= 140.0 then
			helper_1b3d0()
		elseif var0 < 140.0 and var0 >= 90.0 then
			helper_1abe8()
		else
			helper_91b30ebf()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.SetDmg2("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.SetDmg2("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.SetDmg2("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.SetDmg2("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 1)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("風弾Ｆ", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("風弾Ｌ", get_not_used_texb) or var2
		var3 = monster.LoadEffectScript("風弾Ｈ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, pos_y + 20.0, pos_z)
	helper_1be0f106()
	helper_ac26cdde(45.0)
	helper_1cec()
	monster.VPush(0, 0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var2: f32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_461f64ff()
		helper_3d0d0c5c()
		var2 = helper_e2fdabb9(var2)
		if var2 < 190.0 then
			helper_1b850()
		else
			helper_3df77102()
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
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_895326d8()
	helper_45797ccb(12)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_09acbcc2()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 20)
	helper_895326d8()
	monster.SetActStatus(1)
	helper_45797ccb(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_895326d8()
	monster.SetMos("立ち")
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.SetMos("ガード", -1, 0)
	monster.BlowStart(3.0, 0.0, 2)
	helper_45797ccb(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_461f64ff()
	monster.SetMos("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_461f64ff()
	monster.SetMos("歩き", -1, 0)
	helper_f5727415(vm.f32(4.8))
	monster.SetMos("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	monster.SetMos("死に", -1, 2)
	helper_895326d8()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.SetMos("じたばた", -1, 4)
	while true do
		helper_461f64ff()
	end
	helper_7ea3f35f()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_4772ab41()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_45797ccb(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_895326d8()
	helper_2e729f21()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	helper_d30a9fa2()
	monster.SetAttrib(4, 0)
	monster.SetAttrib(8, 0)
	monster.SetMos("吹っ飛び", -1, 6)
	while true do
		height = monster.GetHigh() or height
		if height < 10.0 then
			break
		else
			helper_461f64ff()
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.SetMos("起き上がり", -1, 6)
	while true do
		height = monster.GetHigh() or height
		if height < 10.0 then
			break
		else
			helper_461f64ff()
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.SetAttrib(4, 1)
	monster.SetAttrib(8, 1)
	var5 = helper_57b569a8(var5)
	helper_461f64ff()
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, var5 + 10.0, pos_z)
	helper_461f64ff()
	helper_e05438b5()
end

return script
