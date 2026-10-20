--!strict
-- dungeon/monster/e211a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_ff34(arg0: any)
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	while true do
		helper_0ba23e4e()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.SetMos("歩き", -1.0, 0)
				helper_890ee63a(vm.f32(5.6))
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_10204()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_ff34(monster_id)
	end
end

--- Helper function.
local function helper_1063c()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	var0 = 0
	var2 = helper_6eaf9360(0, 120.0)
	if var2 == 1 then
		var0 = vm.i32(bit32.bor(var0, 4))
	end
	if var2 == 0 then
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	var1 = monster.GetTargetDist() or var1
	if var1 <= 160.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	end
	if var1 > 160.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
	end
	if helper_6eaf9360(0, 45.0) ~= 0 and var1 <= 135.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	return var0
end

--- Helper function.
local function helper_119e4()
	local pos_y: f32 = 0
	local var3: f32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local attack: s32 = 0
	local var8: s32 = 0
	local var9: f32 = 0
	local argc: s32 = 0
	local monster_id: s32 = 0
	local var12: s32 = 0
	var8 = 1
	var3 = monster.GetTargetDist() or var3
	if var3 < 40.0 then
		monster.SetMos("攻撃１", -1, 2)
		helper_c3e8ae39(helper_9df6409a(24))
		do
			local out1, _, out3 = monster.GetRefanglePos(0.0, 30.0)
			pos_x_2 = out1 or pos_x_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local _, out2, _ = monster.GetPos_3()
			pos_y = out2 or pos_y
		end
		monster.SetNextPos(pos_x_2, pos_y, pos_z_2, 2.0, 2.0)
		helper_56d63eae()
	else
		var9 = monster.GetTargetDist() or var9
		if var9 > 90.0 then
			var12 = 50
			monster_id = monster.GetMonsterIndex() or monster_id
			if monster_id == 600 then
				var12 = 0
			else
				var12 = 15
			end
			argc = monster.GetRnd(100) or argc
			if argc < var12 then
				monster.SetMos("攻撃２", -1, 6)
				helper_c3e8ae39(helper_9df6409a(6))
				do
					local out1, _, out3 = monster.GetRefanglePos(0.0, 6.0)
					pos_x_2 = out1 or pos_x_2
					pos_z_2 = out3 or pos_z_2
				end
				do
					local _, out2, _ = monster.GetPos_3()
					pos_y = out2 or pos_y
				end
				monster.SetNextPos(pos_x_2, pos_y, pos_z_2, 0.6, 0.6)
				helper_48852a90(4.0, vm.f32(0.521), vm.f32(0.02))
				attack = monster.GetBaseAttack_1() or attack
				monster.EsmCreate_1("ピエロ兵ナイフ")
				monster.EsmSetValue(-1, 0, attack)
				helper_c3e8ae39(helper_9df6409a(5))
				monster.ResetMove()
				do
					local out1, _, out3 = monster.GetRefanglePos(0.0, 26.0)
					pos_x_2 = out1 or pos_x_2
					pos_z_2 = out3 or pos_z_2
				end
				do
					local _, out2, _ = monster.GetPos_3()
					pos_y = out2 or pos_y
				end
				monster.SetNextPos(pos_x_2, pos_y, pos_z_2, 1.8, 1.8)
				helper_56d63eae()
			else
				var8 = 0
			end
		else
			var8 = 0
		end
	end
	if var8 ~= 0 then
		monster.ResetMove()
		monster.SetMos("立ち")
		helper_c3e8ae39(3)
	end
end

--- Helper function.
local function helper_1175c()
	local var1: f32 = 0
	local var3: f32 = 0
	while true do
		monster.SetMos("歩き")
		helper_82cb5588(vm.f32(0.09817477))
		do
			local _, out2, _ = monster.GetRot()
			var1 = out2 or var1
		end
		var3 = monster.GetTargetAngle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.09817477)) == 0 then
			helper_442b9962()
			break
		else
			vm.wait()
		end
	end
end

--- Helper function.
local function helper_10a64()
	local var0: f32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		var0 = 50.0
	else
		var0 = 30.0
	end
	while true do
		helper_10204()
		if helper_6eaf9360(0, 120.0) == 0 then
			return 1
		end
		var2 = monster.GetTargetDist() or var2
		if var2 <= var0 then
			helper_442b9962()
			monster.ResetMove()
			return 0
		end
		if var2 > 160.0 then
			helper_442b9962()
			monster.ResetMove()
			return 1
		end
		monster.SetMos("歩き")
		do
			local out1, _, out3 = monster.GetRefanglePos(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.09817477))
		do
			local _, out2, _ = monster.GetPos_3()
			pos_y_2 = out2 or pos_y_2
		end
		monster.SetNextPos(pos_x, pos_y_2, pos_z, 0.8, 1.0)
		vm.wait()
	end
	return 0
end

--- Helper function.
local function helper_11034()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local argc: s32 = 0
	local pos_y_2: f32 = 0
	local var10: s32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 < 80.0 then
		monster.SetMos("ステップ後", -1, 2)
		do
			local out1, out2, out3 = monster.GetRefanglePos(3.1415927, 33.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_c3e8ae39(helper_9df6409a(10))
		var5 = 4.0
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			var4 = -10.0
			monster.SetMos("ステップ右", -1, 2)
		else
			var4 = 10.0
			monster.SetMos("ステップ左", -1, 2)
		end
		pos_x, pos_y, pos_z = helper_125e5305(var4, var0, pos_x, pos_y, pos_z)
		helper_c3e8ae39(helper_9df6409a(8))
		var5 = vm.f32(var0 / 60.0)
	end
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.SetNextPos(pos_x, pos_y_2, pos_z, var5, var5)
	while true do
		helper_82cb5588(vm.f32(0.09817477))
		var10 = monster.CheckMosEnd() or var10
		if var10 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	helper_442b9962()
	monster.SetMos("立ち")
end

--- Helper function.
local function helper_12568(arg0: s32)
	local pos_y: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	if bit32.band(arg0, 16) ~= 0 then
		var4 = monster.GetTargetDist() or var4
		if var4 < 40.0 or var4 > 90.0 then
			helper_119e4()
			return
		else
			arg0 = helper_1063c()
		end
	end
	if bit32.band(arg0, 2) ~= 0 then
		helper_82cb5588(vm.f32(0.09817477))
		monster.SetMos("走り")
		do
			local out1, _, out3 = monster.GetTargetPos()
			var5 = out1 or var5
			var7 = out3 or var7
		end
		do
			local _, out2, _ = monster.GetPos_3()
			pos_y = out2 or pos_y
		end
		monster.SetNextPos(var5, pos_y, var7, 3.0, 160.0)
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 8) else 0) ~= 0 then
		helper_1175c()
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 4) else 0) ~= 0 then
		argc = monster.GetRnd(100) or argc
		if argc < 10 then
			if helper_10a64() ~= 0 then
				return
			else
				helper_1175c()
			end
		else
			helper_11034()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetDmg2("Ｍ連撃２", 4.5, "攻撃１", 0.579, 0.664, 0)
	monster.SetDmg2("Ｍ連撃２", 4.5, "攻撃１", 0.236, 0.321, 1)
	monster.LoadEffectScript("ピエロ兵ナイフ")
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_10204()
		var0 = helper_1063c()
		helper_12568(var0)
		vm.wait()
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
	helper_56d63eae()
	helper_c3e8ae39(16)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 20)
	helper_56d63eae()
	monster.SetActStatus(1)
	helper_c3e8ae39(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.SetMos("ガード", -1, 0)
	monster.BlowStart(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.SetMos("立ち", -1, 0)
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
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
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
	helper_aa93a1aa()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_c3e8ae39(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
