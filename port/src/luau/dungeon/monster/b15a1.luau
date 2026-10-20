--!strict
-- dungeon/monster/b15a1.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8700c9e2 = require("@lib/monster/helper_8700c9e2")

local global3: s32 = 0

--- Helper function.
local function helper_24b4()
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
local function helper_eb2c()
	local rot_y: f32 = 0
	local var4: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var4 = out2 or var4
	end
	do
		local _, out2, _ = monster.GetRot(0)
		rot_y = out2 or rot_y
	end
	var4 = monster.GetTargetAngle() or var4
	var4 = vm.f32(var4 - rot_y)
	if var4 > vm.f32(3.1415927) then
		var4 = vm.f32(var4 - vm.f32(6.2831855))
	end
	if var4 < vm.f32(-3.1415927) then
		var4 = vm.f32(var4 + vm.f32(6.2831855))
	end
	if global3 == 25 then
		if var4 < 0.0 then
			monster.SetNextRot(1.5707964, 0.049087387)
			return
		end
	end
	if global3 == 26 then
		if var4 > 0.0 then
			monster.SetNextRot(-1.5707964, 0.049087387)
			return
		end
	end
	monster.SetNextRot(var4, 0.09817477)
end

--- Runs the monster's death.
local function on_death()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.SetDeadStart()
	chara_type = monster.GetUserid() or chara_type
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
	monster.EsmCreate_1("軍艦ダメージ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.EsmCreate_1("Ｍ汎用煙")
	monster.EsmSetUserId(-1, chara_type)
	monster.SetAttrib(1, 1)
	monster.SetAttrib(32, 1)
	value = monster.VPop(67) or value
	monster.SetActiveMonsLifei(value, -900)
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1dd8()
	local value: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local life: s32 = 0
	value = monster.VPop(4) or value
	var1 = monster.GetActiveMonsLifei(-1) or var1
	monster.VPush(4, var1)
	var2 = vm.i32(value - var1)
	var1 = monster.VPop(64) or var1
	var1 = vm.i32(var1 - var2)
	monster.VPush(64, var1)
	if var1 <= 6000 then
		monster.VPop(66)
	end
	life = monster.GetActiveMonsLifei(-1) or life
	if life <= 0 then
		print("dead---------------\n")
		on_death()
	end
end

--- Helper function.
local function helper_21cc()
	helper_1dd8()
	vm.wait()
end

--- Helper function.
local function helper_f0b0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local value: s32 = 0
	local attack: s32 = 0
	local var8: s32 = 0
	local value_2: s32 = 0
	do
		local out1, out2, out3 = monster.GetMapobjPos("shot")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	value = monster.VPop(67) or value
	monster.MonsSePlay(value, 6)
	monster.MonsSePlay(value, 8)
	monster.EsmCreate_1("マズルフラッシュ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	attack = monster.GetBaseAttack_1() or attack
	monster.EsmCreate_1("砲弾")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValue(-1, 1, value)
	value_2 = monster.VPop(8) or value_2
	if value_2 ~= 1 then
		var8 = 60
	else
		var8 = 30
	end
	while var8 > 0 do
		helper_eb2c()
		var8 = var8 - 1
		helper_21cc()
	end
end

--- Helper function.
local function helper_224c(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_21cc()
		var1 = vm.i32(var1 + 1)
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local life: s32 = 0
	local value: s32 = 0
	monster.SetAttrib(4, 1)
	global3 = 0
	global3 = monster.GetUserid() or global3
	if global3 == 25 then
		monster.LinkObjectToPiece("p01_battleship", "tbig-m0")
	end
	if global3 == 26 then
		monster.LinkObjectToPiece("p01_battleship", "tbig-m1")
	end
	monster.SetPos(0, 0, 0)
	monster.SetRot(0, 0, 0)
	value = monster.VPop(64) or value
	life = monster.GetActiveMonsLifei(-1) or life
	monster.VPush(4, life)
	monster.VPush(64, vm.i32(value + life))
	monster.VPush(65, vm.i32(value + life))
	helper_24b4()
	monster.SetClipDist(999999.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	local argc_2: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetRot(-0.3926991, 0.0, 0.0)
	while true do
		helper_eb2c()
		if global3 == 25 then
			var1 = helper_8700c9e2()
			if var1 < vm.f32(-0.98) then
				argc = monster.GetRnd(100) or argc
				if argc < 30 then
					helper_f0b0()
				end
			end
		end
		if global3 == 26 then
			var3 = helper_8700c9e2()
			if var3 < vm.f32(-0.98) then
				argc_2 = monster.GetRnd(100) or argc_2
				if argc_2 < 30 then
					helper_f0b0()
				end
			end
		end
		value = monster.VPop(8) or value
		if value ~= 1 then
			helper_224c(5)
		end
		helper_224c(10)
		helper_21cc()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

script.on_death = on_death

return script
