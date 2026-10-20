--!strict
-- dungeon/monster/b14a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5f4a60e2 = require("@lib/monster/helper_5f4a60e2")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a004bd11 = require("@lib/monster/helper_a004bd11")
local helper_af712f29 = require("@lib/monster/helper_af712f29")

--- Runs the monster's death.
local function on_death()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetActStatus(0)
	monster.ResetMove()
	helper_442b9962()
	value = monster.VPop(8) or value
	value_2 = monster.VPop(6) or value_2
	value = helper_af712f29(value, value_2)
	monster.VPush(8, value)
	monster.SetDeadStart()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	monster.SetDeadOff()
	value_3 = 0
	value_4 = 0
	value_3 = monster.VPop(9) or value_3
	value_4 = monster.VPop(10) or value_4
	value_4 = vm.i32(value_4 + 1)
	monster.VPush(10, value_4)
	if value_3 == 0 then
		if value_4 >= 10 then
			monster.VPush(9, 1)
			monster.VPush(10, 0)
			monster.RunEventScript(510)
		end
	elseif value_3 == 1 then
		if value_4 >= 20 then
			monster.VPush(9, 2)
			monster.VPush(10, 0)
			monster.RunEventScript(510)
		end
	end
	monster.CreateMonster(513, 0.0, -100.0, 0.0)
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1984(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local var8: s32 = 0
	local var9: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	var8 = 0
	var9 = 0
	while var8 < arg7 do
		var14 = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(arg4 - arg1) * 2.0) - vm.f32(vm.f32(arg6 * vm.i32(arg7 + 1)) * vm.i32(arg7 + 1))),
				vm.f32(vm.i32(arg7 + 1) * 2.0)
			)
		)
		var12 = arg1
		for var10 = 0, var8 - 1 do
			var14 = vm.f32(var14 + arg6)
			var12 = vm.f32(var12 + var14)
		end
		var11 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg3 - arg0) * var8), arg7)) + arg0)
		var13 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg5 - arg2) * var8), arg7)) + arg2)
		if var9 == 1 then
			if var12 < arg4 then
				var12 = arg4
			end
		elseif var12 > arg4 then
			var9 = 1
		end
		monster.SetPos(var11, var12, var13)
		var8 = var8 + 1
		vm.wait()
	end
end

--- Helper function.
local function helper_296c()
	local var0: s32 = 0
	local var1: f32 = 0
	var0 = 0
	var1 = monster.GetTargetDist() or var1
	if var1 <= 50.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	elseif var1 <= 240.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
	elseif var1 <= 760.0 then
		var0 = vm.i32(bit32.bor(var0, 4))
	else
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	if var1 <= 240.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	if helper_6eaf9360(0, 45.0) ~= 0 then
		var0 = vm.i32(bit32.bor(var0, 32))
	end
	if var1 <= 90.0 then
		var0 = vm.i32(bit32.bor(var0, 64))
	end
	if helper_6eaf9360(0, 80.0) ~= 0 then
		var0 = vm.i32(bit32.bor(var0, 128))
	end
	monster.VPush(0, var0)
end

--- Helper function.
local function helper_2f20()
	local value: s32 = 0
	local value_2: s32 = 0
	local argc: s32 = 0
	value = monster.VPop(2) or value
	if value ~= -1 then
		value_2 = monster.VPop(3) or value_2
		monster.VPush(1, value)
		monster.VPush(2, value_2)
		monster.VPush(3, -1)
		return
	end
	monster.VPop(0)
	monster.VPush(1, 4)
	monster.VPush(2, 3)
	argc = monster.GetRnd(60) or argc
	argc = vm.i32(argc + 60)
	monster.VPush(4, argc)
end

--- Helper function.
local function helper_2354()
	local var0: f32 = 0
	local argc: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local argc_2: s32 = 0
	local arrived: s32 = 0
	argc = vm.bits_float(monster.GetRnd(20.0)) or argc
	argc = vm.f32(argc + 20.0)
	var0 = monster.GetRefAngle(0.0, 0.0, 0.0) or var0
	var2 = vm.f32(vm.f32(vm.sin(var0) * argc) + var2)
	var3 = 0.0
	var4 = vm.f32(vm.f32(vm.cos(var0) * argc) + var4)
	argc_2 = monster.GetRnd(100) or argc_2
	if vm.imod(argc_2, 2) == 0 then
		monster.SetMos("歩き")
		var5 = vm.f32(0.2)
	else
		monster.SetMos("走り")
		var5 = vm.f32(0.4)
	end
	monster.SetNextPos(var2, var3, var4, var5, var5)
	arrived = monster.ChkMoveEnd() or arrived
	while arrived == 0 do
		monster.SetNextRot(var0, 0.034906585)
		vm.wait()
		arrived = monster.ChkMoveEnd() or arrived
	end
	monster.SetMos("立ち")
end

--- Helper function.
local function helper_2244()
	local value: s32 = 0
	value = monster.VPop(4) or value
	helper_5f4a60e2(value)
	monster.VPush(4, 40)
end

--- Helper function.
local function helper_3348()
	local value: s32 = 0
	value = monster.VPop(1) or value
	monster.VPop(0)
	if value == 1 then
		helper_1ef0d4b2()
	end
	if value == 2 then
		helper_1ef0d4b2()
	end
	if value == 4 then
		helper_2354()
	end
	if value == 3 then
		monster.SetMos("立ち")
		helper_2244()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.VPush(0, 0)
	monster.VPush(1, 0)
	monster.VPush(2, 3)
	monster.VPush(3, -1)
	monster.VPush(4, 40)
	monster.VPush(5, 0)
	monster.VPush(6, 0)
	monster.SetClipDist(40.0)
	monster.SetMos("立ち", -1, 4)
	monster.SetAlpha(0.99)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local angle: f32 = 0
	value = monster.VPop(5) or value
	if value == 0 then
		vm.wait()
		monster.VPush(5, 1)
		monster.SetAttrib(12, 1)
		monster.SetMuteki(30)
		value_2 = monster.VPop(8) or value_2
		if bit32.band(value_2, 255) == 255 then
			print("ERRER : ---  NOT_ROOT --- \n")
			on_death()
			return
		end
		while true do
			var2 = 0
			var4 = 1
			argc = monster.GetRnd(8) or argc
			while var2 < argc do
				var4 = vm.i32(var4 * 2)
				var2 = var2 + 1
			end
			if vm.i32(bit32.band(value_2, var4)) == 0 then
				value_2 = vm.i32(bit32.bor(value_2, var4))
				monster.VPush(8, value_2)
				monster.VPush(6, var4)
				break
			end
		end
		angle = vm.f32(vm.f32(-0.08) + vm.f32(vm.f32(0.7853982) * argc))
		angle = monster.AngleLimit(angle) or angle
		var5 = vm.f32(vm.sin(angle) * 400.0)
		var6 = -80.0
		var7 = vm.f32(vm.cos(angle) * 400.0)
		monster.SetPos(var5, var6, var7)
		var11 = monster.GetRefAngle(0.0, 0.0, 0.0) or var11
		do
			local out1, _, out3 = monster.GetRefanglePos(var11, 140.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		monster.SetRot(0.0, var11, 0.0)
		helper_1984(var5, -80.0, var7, pos_x, 0.0, pos_z, vm.f32(-0.6), 30)
		monster.SetAttrib(12, 0)
	end
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetMos("立ち")
	while true do
		helper_296c()
		helper_2f20()
		helper_3348()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_a004bd11()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_5f4a60e2(8)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a004bd11()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.BlowStart(5.0, 0.05, 10)
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetActStatus(1)
	helper_5f4a60e2(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Guards against a hit.
function script.on_guard()
	helper_a004bd11()
	monster.ResetMove()
	helper_93495fdf()
	monster.SetMos("ガード", -1, 6)
	monster.BlowStart(3.0, 0.0, 4)
	helper_56d63eae()
	helper_5f4a60e2(8)
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = helper_a004bd11

--- Dodges the target's second kind of attack.
script.on_dodge_2 = helper_a004bd11

script.on_death = on_death

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
	helper_5f4a60e2(10)
	monster.SetMos("起き上がり", -1, 2)
	helper_56d63eae()
	monster.SetMos("立ち")
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetMos("気絶", -1)
	helper_27f80314()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

return script
