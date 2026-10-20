--!strict
-- dungeon/monster/e215a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_e300(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local var8: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	var8 = 0
	while var8 < arg7 do
		var13 = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(arg4 - arg1) * 2.0) - vm.f32(vm.f32(arg6 * vm.i32(arg7 + 1)) * vm.i32(arg7 + 1))),
				vm.f32(vm.i32(arg7 + 1) * 2.0)
			)
		)
		var11 = arg1
		for var9 = 0, var8 - 1 do
			var13 = vm.f32(var13 + arg6)
			var11 = vm.f32(var11 + var13)
		end
		var10 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg3 - arg0) * var8), arg7)) + arg0)
		var12 = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg5 - arg2) * var8), arg7)) + arg2)
		if var11 < arg4 then
			var11 = arg4
		end
		monster.SetPos(var10, var11, var12)
		var8 = var8 + 1
		vm.wait()
	end
end

--- Helper function.
local function helper_c6d8()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	var0 = 0
	var2 = helper_6eaf9360(0, 180.0)
	if var2 == 1 then
		var0 = vm.i32(bit32.bor(var0, 4))
	end
	if var2 == 0 then
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	var1 = monster.GetTargetDist() or var1
	if var1 <= 2400.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	end
	if var1 > 2400.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
	end
	if helper_6eaf9360(0, 60.0) ~= 0 and var1 <= 40.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	priority = monster.GetPriority() or priority
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if priority <= 2 or gekirin == 0 then
		var0 = vm.i32(bit32.bor(var0, 32))
	end
	return var0
end

--- Helper function.
local function helper_d748()
	local var0: f32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 < 30.0 then
		monster.SetMos("攻撃１", -1, 2)
	else
		monster.SetMos("攻撃２", -1, 2)
	end
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_c3e8ae39(8)
end

--- Helper function.
local function helper_d0d0()
	local argc: s32 = 0
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	argc = monster.GetRnd(90) or argc
	argc = vm.i32(argc + 150)
	while true do
		var1 = monster.GetTargetDist() or var1
		if var1 <= 2400.0 then
			break
		else
			monster.SetMos("歩き")
			do
				local out1, out2, out3 = monster.GetRefanglePos(0.0, 3.0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			helper_82cb5588(vm.f32(0.024543693))
			monster.SetNextPos(pos_x, pos_y, pos_z, 0.9, 1.0)
			argc = vm.i32(argc - 1)
			if argc < 0 then
				break
			else
				vm.wait()
			end
		end
	end
end

--- Helper function.
local function helper_d9a4(arg0: any)
	local var1: f32 = 0
	while true do
		var1 = monster.GetTargetDist() or var1
		if var1 <= 2400.0 then
			break
		else
			arg0 = vm.wrap(arg0 - 1)
			if arg0 < 0 then
				break
			else
				vm.wait()
			end
		end
	end
end

--- Helper function.
local function helper_d4c0()
	local var1: f32 = 0
	local var3: f32 = 0
	monster.SetMos("歩き")
	while true do
		helper_82cb5588(vm.f32(0.049087387))
		do
			local _, out2, _ = monster.GetRot()
			var1 = out2 or var1
		end
		var3 = monster.GetTargetAngle() or var3
		if helper_8971d3b6(var3, var1, vm.f32(0.049087387)) == 0 then
			helper_442b9962()
			break
		else
			vm.wait()
		end
	end
end

--- Helper function.
local function helper_cc50(arg0: s32)
	local var1: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	while true do
		if helper_6eaf9360(0, 180.0) == 0 then
			return 1
		end
		var1 = monster.GetTargetDist() or var1
		if bit32.band(arg0, 32) ~= 0 then
			if var1 <= 40.0 then
				return 0
			end
		elseif var1 <= 160.0 then
			return 0
		end
		if var1 > 2400.0 then
			return 1
		end
		monster.SetMos("走り")
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.049087387))
		monster.SetNextPos(pos_x, pos_y, pos_z, 1.8, 1.0)
		vm.wait()
	end
	return 0
end

--- Helper function.
local function helper_db74(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	if (if bit32.band(arg0, 16) ~= 0 then bit32.band(arg0, 32) else 0) ~= 0 then
		helper_d748()
		argc = monster.GetRnd(60) or argc
		argc = vm.i32(argc + 10)
		helper_c3e8ae39(argc)
		return
	end
	if bit32.band(arg0, 2) ~= 0 then
		if helper_6eaf9360(0, 60.0) ~= 0 then
			argc_2 = monster.GetRnd(400) or argc_2
			if argc_2 < 1 then
				helper_d0d0()
				argc_2 = monster.GetRnd(60) or argc_2
				argc_2 = vm.i32(argc_2 + 60)
				monster.SetMos("立ち")
				helper_d9a4(argc_2)
			end
		else
			argc_3 = monster.GetRnd(100) or argc_3
			if argc_3 < 2 then
				helper_d4c0()
				argc_3 = monster.GetRnd(60) or argc_3
				argc_3 = vm.i32(argc_3 + 60)
				monster.SetMos("立ち")
				helper_d9a4(argc_3)
			end
		end
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 8) else 0) ~= 0 then
		helper_d4c0()
		return
	end
	if (if bit32.band(arg0, 1) ~= 0 then bit32.band(arg0, 4) else 0) ~= 0 then
		if helper_cc50(arg0) ~= 0 then
			return
		else
			helper_d4c0()
		end
		if bit32.band(arg0, 32) == 0 then
			argc_4 = monster.GetRnd(100) or argc_4
			if argc_4 < 2 then
				helper_d4c0()
			end
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetObj(0, "bcol00")
	monster.SetObj(1, "dcol00")
	monster.SetObj(2, "dcol00")
	monster.SetObj(3, "dcol01")
	monster.SetDmg2("通常攻撃", 4.5, "攻撃２", 0.2, 0.8, 0)
	monster.SetDmg2("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 1)
	monster.SetDmg2("通常攻撃", 4.5, "攻撃１", 0.4, 0.8, 2)
	monster.SetDmg2("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 1)
	monster.SetDmg2("吹っ飛び攻撃", 6.0, "避け攻撃", 0.25, 0.5, 2)
	monster.SetBody(0, 8.0)
	monster.SetClipDist(120.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	value = monster.VPop(0) or value
	if value == 0 then
		monster.SetAttrib(4, 1)
		monster.SetMuteki(30)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var7 = monster.GetRndf(6.2831855) or var7
		var7 = vm.f32(var7 - vm.f32(3.1415927))
		var7 = monster.AngleLimit(var7) or var7
		pos_x_2 = vm.f32(pos_x_2 + vm.f32(vm.sin(var7) * 140.0))
		pos_y_2 = 0.0
		pos_z_2 = vm.f32(pos_z_2 + vm.f32(vm.cos(var7) * 140.0))
		var8 = monster.GetRefAngle(pos_x_2, pos_y_2, pos_z_2) or var8
		monster.SetRot(0.0, var8, 0.0)
		helper_e300(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2, -1.0, 30)
		monster.SetAttrib(4, 0)
		monster.VPush(0, 1)
	end
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		monster.SetMos("立ち")
		var9 = helper_c6d8()
		helper_db74(var9)
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 30)
	helper_56d63eae()
	monster.SetActStatus(1)
	helper_c3e8ae39(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
end

--- Guards against a hit.
function script.on_guard()
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("ガード", -1, 6)
	monster.BlowStart(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local gekirin: s32 = 0
	local var5: s32 = 0
	local argc: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("避け", -1, 2)
	var0 = monster.GetTargetAngle() or var0
	monster.SetRot(0.0, var0, 0.0)
	vm.wait()
	monster.SetMuteki(6)
	helper_c3e8ae39(6)
	do
		local out1, out2, out3 = monster.GetRefanglePos(3.1415927, 35.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetNextPos(pos_x, pos_y, pos_z, 5.0, 5.0)
	helper_56d63eae()
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin == 0 then
		var5 = 80
	else
		var5 = 30
	end
	argc = monster.GetRnd(100) or argc
	if argc < var5 then
		monster.SetMos("避け攻撃", -1, 6)
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, 30.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.SetNextPos(pos_x, pos_y, pos_z, 5.0, 5.0)
		helper_56d63eae()
	else
		monster.SetMos("避け戻り", -1, 6)
		helper_56d63eae()
	end
	monster.SetIntFlag(1, 0)
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
	helper_d30a9fa2()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
