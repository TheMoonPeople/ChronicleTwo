--!strict
-- dungeon/monster/b04a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

local global0: any = 0
local global1: s32 = 0

--- Helper function.
local function helper_3ba0(arg0: any, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	if arg0 == 0 then
		var5 = 250.0
		var6 = 300.0
		var7 = 250.0
		var8 = 0.0
	end
	if arg0 == 1 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.617994)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.617994)) * 150.0) + 250.0)
		var8 = vm.f32(0.5235988)
	end
	if arg0 == 2 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-1.5707964)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-1.5707964)) * 150.0) + 250.0)
		var8 = vm.f32(1.5707964)
	end
	if arg0 == 3 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-0.5235988)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-0.5235988)) * 150.0) + 250.0)
		var8 = vm.f32(2.617994)
	end
	if arg0 == 4 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(0.5235988)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(0.5235988)) * 150.0) + 250.0)
		var8 = vm.f32(-2.617994)
	end
	if arg0 == 5 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(1.5707964)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(1.5707964)) * 150.0) + 250.0)
		var8 = vm.f32(-1.5707964)
	end
	if arg0 == 6 then
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(2.617994)) * 150.0) + 250.0)
		var6 = 100.0
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(2.617994)) * 150.0) + 250.0)
		var8 = vm.f32(-0.5235988)
	end
	arg1 = var5
	arg2 = var6
	arg3 = var7
	arg4 = var8
	return arg1, arg2, arg3, arg4
end

--- Helper function.
local function helper_494c(arg0: any)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	var1, var2, var3, var4 = helper_3ba0(arg0, var1, var2, var3, var4)
	monster.SetPos(var1, var2, var3)
	monster.SetRot(0.0, var4, 0.0)
	global0 = arg0
end

--- Helper function.
local function helper_2244(arg0: any)
	local value: s32 = 0
	value = monster.VPop(vm.wrap(14 + arg0)) or value
	return value
end

--- Helper function.
local function helper_2318(arg0: s32)
	for var1 = 0, 5 do
		if arg0 ~= helper_2244(var1) then
			return 0
		end
	end
	return 1
end

--- Helper function.
local function helper_5ef4(arg0: s32)
	helper_c3e8ae39(arg0)
	while true do
		if helper_2318(0) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	return 2
end

--- Helper function.
local function helper_28e8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_f683d690()
	monster.SetMos("攻撃２", -1, 2)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("サンの竜巻")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	helper_56d63eae()
	monster.SetMos("立ち", -1, 4)
end

--- Helper function.
local function helper_3850()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.SetCameraFollow(0)
	monster.SetPause(6, 1)
	monster.SetCameraSpeed(16.0)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetCameraNextPos(pos_x, pos_y + 25.0, pos_z + 100.0)
	monster.SetCameraNextRef(pos_x, pos_y + 25.0, pos_z)
	helper_28e8()
	monster.SetCameraFollow(1)
	monster.SetCameraSpeed(8.0)
	monster.SetPause(6, 0)
end

--- Helper function.
local function helper_24b8(arg0: s32, arg1: s32)
	monster.VPush(vm.i32(8 + arg0), arg1)
end

--- Helper function.
local function helper_2b50()
	local argc: s32 = 0
	argc = monster.GetRnd(6) or argc
	if argc == 0 then
		helper_24b8(1, 2)
		helper_24b8(3, 2)
		helper_24b8(5, 2)
		helper_c3e8ae39(90)
		helper_24b8(0, 2)
		helper_24b8(2, 2)
		helper_24b8(4, 2)
		helper_c3e8ae39(90)
	end
	if argc == 1 then
		helper_24b8(0, 2)
		helper_24b8(2, 2)
		helper_24b8(4, 2)
		helper_c3e8ae39(90)
		helper_24b8(1, 2)
		helper_24b8(3, 2)
		helper_24b8(5, 2)
		helper_c3e8ae39(90)
	end
	if argc == 2 then
		helper_24b8(3, 2)
		helper_24b8(4, 2)
		helper_24b8(5, 2)
		helper_c3e8ae39(90)
		helper_24b8(0, 2)
		helper_24b8(1, 2)
		helper_24b8(2, 2)
		helper_c3e8ae39(90)
	end
	if argc == 3 then
		helper_24b8(0, 2)
		helper_24b8(1, 2)
		helper_24b8(2, 2)
		helper_c3e8ae39(90)
		helper_24b8(3, 2)
		helper_24b8(4, 2)
		helper_24b8(5, 2)
		helper_c3e8ae39(90)
	end
	if argc == 4 then
		helper_24b8(5, 2)
		helper_c3e8ae39(30)
		helper_24b8(4, 2)
		helper_c3e8ae39(30)
		helper_24b8(3, 2)
		helper_c3e8ae39(30)
		helper_24b8(2, 2)
		helper_c3e8ae39(30)
		helper_24b8(1, 2)
		helper_c3e8ae39(30)
		helper_24b8(0, 2)
		helper_c3e8ae39(90)
	end
	if argc == 5 then
		helper_24b8(0, 2)
		helper_c3e8ae39(30)
		helper_24b8(1, 2)
		helper_c3e8ae39(30)
		helper_24b8(2, 2)
		helper_c3e8ae39(30)
		helper_24b8(3, 2)
		helper_c3e8ae39(30)
		helper_24b8(4, 2)
		helper_c3e8ae39(30)
		helper_24b8(5, 2)
		helper_c3e8ae39(90)
	end
end

--- Helper function.
local function helper_2170(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_4ad4(arg0: any, arg1: s32)
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
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
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
	var8, var9, var10, var11 = helper_3ba0(arg0, var8, var9, var10, var11)
	var12 = vm.f32(var11 - var6)
	if var12 < vm.f32(-3.1415927) then
		var12 = vm.f32(var12 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var12 then
		var12 = vm.f32(var12 - vm.f32(6.2831855))
	end
	var13 = 0.0
	var14 = arg1
	while var13 <= var14 do
		var15 = helper_2170(pos_x, var8, var13, var14)
		var16 = helper_2170(pos_y, var9, var13, var14)
		var17 = helper_2170(pos_z, var10, var13, var14)
		monster.SetPos(var15, var16, var17)
		var18 = helper_2170(0.0, var12, var13, var14)
		var18 = vm.f32(var18 + var6)
		monster.SetRot(0.0, var18, 0.0)
		var13 = vm.f32(var13 + 1.0)
		vm.wait()
	end
	monster.SetPos(var8, var9, var10)
	monster.SetRot(0.0, var11, 0.0)
	global0 = arg0
end

--- Helper function.
local function helper_6010()
	local argc: s32 = 0
	helper_3850()
	helper_2b50()
	while true do
		if helper_2318(2) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	argc = monster.GetRnd(6) or argc
	global0 = vm.i32(argc + 1)
	helper_4ad4(global0, 90)
	return 3
end

--- Helper function.
local function helper_61e0(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	var1 = 0
	while true do
		var2 = 0
		while var2 < arg0 do
			var3 = helper_2244(vm.wrap(global0 - 1))
			if var3 == 3 then
				return 4
			end
			var2 = var2 + 1
			vm.wait()
		end
		if 5 <= var1 then
			break
		else
			argc = monster.GetRnd(2) or argc
			if argc ~= 0 then
				global0 = vm.wrap(global0 + 1)
			else
				global0 = vm.wrap(global0 - 1)
			end
			if global0 < 1 then
				global0 = 6
			end
			if 6 < global0 then
				global0 = 1
			end
			helper_4ad4(global0, 90)
			var1 = var1 + 1
		end
	end
	helper_4ad4(0, 90)
	return 5
end

--- Helper function.
local function helper_26d4(arg0: s32)
	monster.SetMos("吹っ飛び", -1, 2)
	helper_c3e8ae39(150)
	if arg0 ~= 0 then
		monster.SetMos("起き上がり", -1, 6)
		helper_56d63eae()
		monster.SetMos("立ち", -1, 4)
	end
end

--- Helper function.
local function helper_6704()
	global1 = vm.i32(global1 - 1)
	if global1 <= 0 then
		helper_26d4(0)
		return 0
	end
	helper_26d4(1)
	helper_4ad4(0, 90)
	return 5
end

--- Helper function.
local function helper_36d4()
	helper_24b8(0, 1)
	helper_24b8(1, 1)
	helper_24b8(2, 1)
	helper_24b8(3, 1)
	helper_24b8(4, 1)
	helper_24b8(5, 1)
end

--- Helper function.
local function helper_688c()
	helper_3850()
	helper_36d4()
	while true do
		if helper_2318(0) ~= 0 then
			break
		else
			vm.wait()
		end
	end
	return 1
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetAttrib(8, 1)
	monster.SetAttrib(16, 1)
	monster.SetAttrib(1, 1)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetClipDist(999)
	monster.SetAttrib(4, 1)
	monster.SetPos(250.0, 300.0, 250.0)
	monster.LoadEffectScript("バラ")
	monster.LoadEffectScript("バラヒット")
	monster.LoadEffectScript("サンの竜巻")
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	monster.SetMos("立ち")
	global0 = 0
	helper_494c(global0)
	global1 = 3
	var0 = 1
	while true do
		if var0 == 1 then
			var0 = helper_5ef4(90)
		end
		if var0 == 2 then
			var0 = helper_6010()
		end
		if var0 == 3 then
			var0 = helper_61e0(90)
		end
		if var0 == 4 then
			var0 = helper_6704()
		end
		if var0 == 5 then
			var0 = helper_688c()
		end
		if var0 == 0 then
			break
		end
	end
	monster.RunEventScript(501)
	while true do
		vm.wait()
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

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.GetHigh() or height
		if height < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.SetShrowEnd()
			monster.ResetMove()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
