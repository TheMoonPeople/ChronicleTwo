--!strict
-- dungeon/monster/polhana.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_1924(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: f32)
	local var8: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	var8 = 0
	while var8 < arg7 do
		var13 = vm.f32(
			vm.fdiv(vm.f32(vm.f32(vm.f32(arg4 - arg1) * 2.0) - vm.f32(vm.f32(arg6 * arg7) * arg7)), vm.f32(arg7 * 2.0))
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
		var8 = vm.i32(var8 + 1)
		vm.wait()
	end
end

--- Runs the monster's death.
local function on_death()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.ResetMove()
	helper_442b9962()
	monster.SetAttrib(86, 1)
	monster.SetMonsterLifeInt(0)
	monster.SetDeadStart()
	monster.SetDeadOff()
	attack = monster.GetBaseAttack_1() or attack
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("ロボミサイル爆発")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetValue(-1, 0, attack)
	value = monster.VPop(1) or value
	if value == 1 then
		monster.EsmSetUserId(-1, 0)
	end
	monster.MySePlay(8)
	while true do
		vm.wait()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetObj(0, "hana_obj")
	monster.SetClipDist(120.0)
	monster.SetAttrib(1, 1)
	monster.VPush(0, 0)
	monster.VPush(1, 0)
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
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	vm.wait()
	value = monster.VPop(0) or value
	if value == 0 then
		monster.VPush(0, 1)
		monster.VPush(1, 0)
		monster.SetAttrib(4, 1)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = monster.SubVector(var8, var9, var10, pos_x, pos_y, pos_z)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var7 = monster.GetDistVector(var8, 0.0, var10) or var7
		var7 = monster.GetTargetDist() or var7
		if var7 < 80.0 then
			var7 = 80.0
		end
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, var7)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = 0.0
		var11 = vm.f32(vm.f32(-0.8) + vm.f32(var7 * vm.f32(0.0001)))
		var12 = vm.f32(vm.f32(var7 / 16.0) + 6.0)
		helper_1924(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2, var11, var12)
		monster.MySePlay(6)
		monster.SetAttrib(4, 0)
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, 16.0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = vm.f32(3.2)
		monster.SetNextPos(pos_x_2, pos_y_2, pos_z_2, 3.2, 3.2)
	end
	var14 = 0.0
	var15 = 0
	while var15 < 80 do
		if var15 >= 50 then
			if var15 == 50 then
				monster.SetPalletAnim(128, 128, 255, 4, 30)
			end
			var13 = vm.f32(vm.f32(vm.sin(var14) / 10.0) + 1.0)
			var14 = vm.f32(var14 + vm.f32(0.4))
			if var14 >= vm.f32(3.1415927) then
				monster.MySePlay(7)
				var14 = 0.0
			end
			monster.SetScale(var13, var13, var13)
		end
		var15 = var15 + 1
		vm.wait()
	end
	on_death()
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

script.on_death = on_death

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.ResetMove()
	monster.SetAttrib(4, 0)
	monster.SetAttrib(32, 1)
	monster.ResetPalletAnim()
	monster.VPush(1, 1)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.ResetMove()
	monster.SetShrowEnd()
	monster.SetAttrib(32, 0)
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
