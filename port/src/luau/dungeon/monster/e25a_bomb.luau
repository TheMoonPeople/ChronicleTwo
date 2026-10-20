--!strict
-- dungeon/monster/e25a_bomb.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Runs the monster's death.
local function on_death()
	local attack: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	monster.SetShrowEnd()
	monster.ResetMove()
	helper_442b9962()
	monster.SetAttrib(86, 1)
	monster.SetMonsterLifeInt(0)
	monster.SetDeadStart()
	monster.SetDeadOff()
	attack = monster.GetBaseAttack_1() or attack
	do
		local out1, out2, out3 = monster.GetPos_3()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	if var2 == 0.0 and var3 == -2.0 and var4 == 0.0 then
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var3 = vm.f32(var3 + 25.0)
	end
	attack = monster.GetBaseAttack_1() or attack
	monster.EsmCreate_1("海賊爆弾爆発")
	monster.EsmSetVect1(-1, var2, var3, var4)
	monster.EsmSetValue(-1, 0, attack)
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
	monster.SetAttrib(1, 1)
	monster.VPush(0, 0)
	monster.VPush(1, 0)
	monster.VPush(2, 0)
	monster.SetClipDist(10000000.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
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
	local var21: f32 = 0
	local var22: s32 = 0
	local var24: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local value: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	vm.wait()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var12 = monster.GetTargetDist() or var12
	do
		local out1, out2, out3 = monster.CopyVector(var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.SubVector(var9, var10, var11, var3, var4, var5)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local _, out2, _ = monster.GetRot()
		var24 = out2 or var24
	end
	do
		local out1, out2, out3 = monster.CopyVector(vm.sin(var24), 0.0, vm.cos(var24))
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	monster.SetAttrib(4, 1)
	var15 = 2.5
	var17 = vm.f32(0.3926991)
	var21 = vm.f32(0.27)
	monster.ResetMove()
	var22 = 0
	while var22 < 120 do
		var12 = monster.GetTargetDist() or var12
		if var12 < 30.0 then
			on_death()
		end
		var16 = var22
		var15 = vm.f32(var15 - vm.f32(0.04))
		var13 = vm.f32(vm.f32(var15 * vm.cos(var17)) * var16)
		var14 =
			vm.f32(vm.f32(vm.f32(var15 * vm.sin(var17)) * var16) - vm.f32(vm.f32(vm.f32(var21 * var16) * var16) / 2.0))
		do
			local out1, out2, out3 = monster.CopyVector(var9, var10, var11)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var6, var7, var8, var13)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var7 = vm.f32(1.0 * var14)
		do
			local out1, out2, out3 = monster.AddVector(var3, var4, var5, var6, var7, var8)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		if var15 < 0.0 then
			break
		elseif var4 < var1 then
			break
		else
			if var22 == 5 then
				monster.SetAttrib(16, 0)
			end
			do
				local out1, out2, out3 = monster.GetPos_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var29 = monster.GetDistVector2(pos_x, pos_y, pos_z, var3, var4, var5) or var29
			if var29 < 100.0 then
				var30 = monster.SearchArea2(pos_x, pos_y, pos_z, var3, var4, var5) or var30
				if var30 < vm.f32(var29 - 0.5) then
					break
				end
			end
			monster.SetPos(var3, var4, var5)
			vm.wait()
			var22 = var22 + 1
		end
	end
	monster.SetAttrib(4, 0)
	var32 = 0.0
	value = 0
	while value < 195 do
		if value >= 165 then
			if value == 165 then
				monster.SetPalletAnim(128, 128, 255, 4, 30)
			end
			var31 = vm.f32(vm.f32(vm.sin(var32) / 10.0) + 1.0)
			var32 = vm.f32(var32 + vm.f32(0.4))
			if var32 >= vm.f32(3.1415927) then
				monster.MySePlay(7)
				var32 = 0.0
			end
			monster.SetScale(var31, var31, var31)
		end
		value = monster.VPop(2) or value
		value = vm.i32(value + 1)
		monster.VPush(2, value)
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
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local value: s32 = 0
	monster.ResetMove()
	monster.SetAttrib(4, 0)
	monster.ResetPalletAnim()
	monster.VPush(1, 1)
	var5 = 0.0
	value = 0
	var0 = 128.0
	var1 = 8.0
	var2 = 8.0
	var3 = 128.0
	value = monster.VPop(2) or value
	while value < 195 do
		if value >= 165 then
			if value == 165 then
				monster.SetModelLightSwitch(0)
			end
			var0 = 128.0
			var1 = 128.0
			var2 = 128.0
			if vm.imod(value, 6) == 0 then
				var0 = 196.0
				var1 = 128.0
			end
			if vm.imod(value, 6) == 2 then
				var0 = 172.0
				var1 = 172.0
			end
			if vm.imod(value, 6) == 4 then
				var0 = 168.0
				var1 = 168.0
			end
			monster.SetModelLightColor(var0, var1, var2, var3)
			var5 = vm.f32(var5 + vm.f32(0.4))
			if var5 >= vm.f32(3.1415927) then
				monster.MySePlay(7)
				var5 = 0.0
			end
		end
		value = monster.VPop(2) or value
		value = vm.i32(value + 1)
		monster.VPush(2, value)
		vm.wait()
	end
	on_death()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.ResetMove()
	monster.SetShrowEnd()
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
