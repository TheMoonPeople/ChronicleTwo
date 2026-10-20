--!strict
-- dungeon/monster/b17a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")

--- Helper function.
local function helper_2138(arg0: f32)
	monster.VPushFloat(0, arg0)
end

--- Helper function.
local function helper_18d0(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.GetAttType() or att_type
	monster.VPush(6, att_type)
	monster.VPush(7, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_32d0()
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
local function helper_1ba4()
	local life: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.VPop(9) or value
	life = monster.GetActiveMonsLifei(-1) or life
	if life <= 0 then
		monster.VPush(9, life)
		return
	end
	if vm.i32(life - value) < 0 then
		monster.VPush(9, life)
		helper_18d0(life, value)
		value_2 = monster.VPop(8) or value_2
		monster.VPush(8, vm.i32(value_2 + 1))
		print("dmg_cnt = ", vm.i32(value_2 + 1), "--------------------\n")
		return
	end
	monster.VPush(9, life)
end

--- Helper function.
local function helper_2058(arg0: f32)
	local value: f32 = 0
	value = monster.VPopFloat(0) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_21dc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var12: f32 = 0
	monster.GetActiveMonsLifef(-1)
	var0 = 250.0
	var1 = 0.0
	var2 = 250.0
	var7 = monster.GetRefAngle(var0, var1, var2) or var7
	var6 = helper_2058(var6)
	var3 = vm.f32(var0 + vm.f32(vm.sin(var6) * 180.0))
	var4 = vm.f32(var1 + 105.0)
	var5 = vm.f32(var2 + vm.f32(vm.cos(var6) * 180.0))
	monster.SetPos(var3, var4, var5)
	monster.SetRot(0.0, var7, 0.0)
	value_2 = monster.VPopFloat(1) or value_2
	value = monster.VPopFloat(2) or value
	var12 = monster.VPopFloat(3) or var12
	if value > var12 or value < -var12 then
		var12 = monster.GetRndf(0.011635529) or var12
		if value > vm.f32(0.023271058) then
			var12 = vm.f32(-var12 + vm.f32(0.023271058))
			value = var12
		else
			var12 = vm.f32(var12 + vm.f32(0.023271058))
			value = -var12
		end
		value_2 = vm.f32(value_2 * -1.0)
		monster.VPushFloat(1, value_2)
		monster.VPushFloat(3, var12)
	end
	value = vm.f32(value + value_2)
	monster.VPushFloat(2, value)
	helper_2138(vm.f32(var6 + value))
end

--- Helper function.
local function helper_2b2c()
	local value: s32 = 0
	helper_1ba4()
	value = monster.VPop(8) or value
	if value >= 3 then
		if value == 3 then
			monster.VPushFloat(10, 0.004363323)
			monster.VPushFloat(1, 9.3499795e-05)
			print("3\n")
		end
		if value == 4 then
			monster.VPushFloat(10, 0.0058177644)
			monster.VPushFloat(1, 0.00012466639)
		end
		if value == 5 then
			monster.VPushFloat(10, 0.008726646)
			monster.VPushFloat(1, 0.00018699959)
		end
	end
	helper_21dc()
end

--- Helper function.
local function helper_2fe8()
	helper_2b2c()
	vm.wait()
end

--- Helper function.
local function helper_31a8()
	local var0: s32 = 0
	while true do
		helper_2fe8()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_1f9c(arg0: s32)
	monster.VPush(vm.i32(arg0 + 20), 1)
end

--- Helper function.
local function helper_121a4()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.MySePlay(4)
	else
		monster.MySePlay(5)
	end
	monster.SetMos("攻撃１", -1, 6)
	helper_31a8()
	argc = monster.GetRnd(120) or argc
	var1 = vm.imod(argc, 6)
	var2 = 0
	while var2 < vm.i32(var1 + 1) do
		argc = monster.GetRnd(120) or argc
		helper_1f9c(vm.imod(argc, 6))
		var2 = var2 + 1
	end
end

--- Helper function.
local function helper_3068(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_2fe8()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_d290()
	monster.SetDeadOff()
	while true do
		helper_2fe8()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local life: s32 = 0
	monster.SetAttrib(1, 1)
	monster.SetAttrib(4, 1)
	monster.SetCameraMode(4)
	chara_type = monster.GetUserid() or chara_type
	monster.VPush(30, chara_type)
	monster.VPush(5, 0)
	helper_2138(0.0)
	monster.VPushFloat(1, 6.2333194e-05)
	monster.VPushFloat(2, 0.011635529)
	monster.VPushFloat(3, 0.034906585)
	life = monster.GetActiveMonsLifei(-1) or life
	monster.VPush(9, life)
	monster.VPush(8, 0)
	monster.VPushFloat(10, 0.0)
	helper_18d0(life, life)
	monster.SetMapobjShow("p01_boss", "boss02-a0", 1)
	monster.SetMapobjShow("p01_boss", "boss02-a1", 1)
	monster.SetMapobjShow("p01_boss", "boss02-a2", 1)
	monster.SetMapobjShow("p01_boss", "boss02-a3", 1)
	monster.SetMapobjShow("p01_boss", "boss02-a4", 1)
	monster.SetMapobjShow("p01_boss", "boss02-a5", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c0", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c1", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c2", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c3", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c4", 1)
	monster.SetMapobjShow("p01_boss", "boss02-c5", 1)
	monster.SetScoop(1027)
	helper_32d0()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var1: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetActStatus(0)
	value = monster.VPop(5) or value
	if value == 0 then
		monster.MySePlay(2)
		monster.VPush(5, 1)
	end
	monster.ResetMotion()
	while true do
		monster.SetMos("あそび", -1, 0)
		if vm.imod(var1, 90) == 0 then
			helper_121a4()
		end
		helper_2fe8()
		var1 = vm.i32(var1 + 1)
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
	print("damage action-----------\n")
	monster.ResetMotion()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_31a8()
	helper_3068(12)
	monster.SetMos("あそび")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	print("blow damage----------\n")
end

--- Guards against a hit.
function script.on_guard()
	print("guard-----------\n")
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	print("sword escape-----------\n")
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	print("shot escape------------\n")
end

--- Runs the monster's death.
function script.on_death()
	monster.SetMapobjShow("p01_boss", "boss02-a0", 0)
	monster.SetMapobjShow("p01_boss", "boss02-a1", 0)
	monster.SetMapobjShow("p01_boss", "boss02-a2", 0)
	monster.SetMapobjShow("p01_boss", "boss02-a3", 0)
	monster.SetMapobjShow("p01_boss", "boss02-a4", 0)
	monster.SetMapobjShow("p01_boss", "boss02-a5", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c0", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c1", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c2", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c3", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c4", 0)
	monster.SetMapobjShow("p01_boss", "boss02-c5", 0)
	vm.wait()
	helper_02ce7891()
	monster.MySePlay(23)
	monster.MySeStop(2)
	monster.RunEventScript(501)
	monster.SetMos("死に", -1, 2)
	helper_31a8()
	monster.SetDeadOff()
	while true do
		helper_2fe8()
	end
	helper_d290()
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
