--!strict
-- dungeon/articles/eff01.assets/foot_splatter.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local var3: s32 = 0
	local value: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local value_2: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var12: f32 = 0
	local value_5: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local value_6: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("base_eff2")
	effect.SptAssignSprite_1(12)
	effect.SptInitSprite(0, 12)
	effect.SptSetAlphab(0, 2, 12)
	effect.SptSetDrawFlag(0, 1, 12)
	effect.SptSetPutSize(0, 8.0, 16.0, 4)
	effect.SptSetUvSize(0, 129.0, 65.0, 30.0, 62.0, 4)
	effect.SptSetPutSize(4, 15.0, 15.0, 8)
	effect.SptSetUvSize(4, 129.0, 1.0, 62.0, 62.0, 8)
	var3 = 0
	while var3 < 4 do
		if var3 < 2 then
			effect.SptSetUvSize(var3, 129.0, 65.0, 30.0, 62.0)
		else
			effect.SptSetUvSize(var3, 161.0, 65.0, 30.0, 62.0)
		end
		value_2 = effect.GetRand(2.0) or value_2
		value_2 = vm.f32(value_2 + 2.0)
		var8 = effect.GetRand(6.2831855) or var8
		var8 = vm.f32(var8 - vm.f32(3.1415927))
		var8 = effect.AngleLimit(var8) or var8
		value = vm.f32(vm.f32(vm.sin(var8) * value_2) + work_vect1_x)
		var5 = work_vect1_y
		var6 = vm.f32(vm.f32(vm.cos(var8) * value_2) + work_vect1_z)
		effect.SptSetPos(var3, value, var5, var6)
		value = effect.GetRand(0.2) or value
		value = vm.f32(value + vm.f32(0.92))
		effect.SptSetVeloPos(var3, 0.0, value, 0.0)
		value = effect.GetRand(-0.02) or value
		value = vm.f32(value - vm.f32(0.05))
		effect.SptSetAccPos(var3, 0.0, value, 0.0)
		value = effect.GetRand(-30.0) or value
		effect.SptSetColor(var3, 128.0, 128.0, 128.0, value)
		value = effect.GetRand(6.0) or value
		value = vm.f32(value + 12.0)
		effect.SptSetVeloCol(var3, 0.0, 0.0, 0.0, value)
		value = effect.GetRand(-0.8) or value
		value = vm.f32(value - vm.f32(1.2))
		effect.SptSetAccCol(var3, 0.0, 0.0, 0.0, value)
		effect.SptSetVeloScl(var3, 0.03, 0.03)
		effect.SptSetAccScl(var3, -0.003, -0.003)
		var9 = effect.GetRand(0.3) or var9
		var9 = vm.f32(var9 - vm.f32(0.15))
		var9 = effect.AngleLimit(var9) or var9
		effect.SptSetRotz(var3, var9)
		var3 = var3 + 1
	end
	while var3 < 12 do
		value_5 = effect.GetRand(1.0) or value_5
		value_5 = vm.f32(value_5 + 2.0)
		var14 = effect.GetRand(6.2831855) or var14
		var14 = vm.f32(var14 - vm.f32(3.1415927))
		var14 = effect.AngleLimit(var14) or var14
		value_3 = vm.f32(vm.f32(vm.sin(var14) * value_5) + work_vect1_x)
		value_4 = vm.f32(work_vect1_y + 2.0)
		var12 = vm.f32(vm.f32(vm.cos(var14) * value_5) + work_vect1_z)
		effect.SptSetPos(var3, value_3, value_4, var12)
		do
			local out1, out2, out3 = effect.CopyVector(value_3, value_4, var12)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = effect.SubVector(var15, var16, var17, work_vect1_x, work_vect1_y, work_vect1_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = effect.NormalVector(var15, var16, var17)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		value_4 = effect.GetRand(0.1) or value_4
		value_4 = vm.f32(value_4 + vm.f32(0.4))
		effect.SptSetVeloPos(var3, var15 / 2.5, value_4, var17 / 2.5)
		value_4 = effect.GetRand(-0.01) or value_4
		value_4 = vm.f32(value_4 - vm.f32(0.03))
		effect.SptSetAccPos(var3, -var15 / 100.0, value_4, -var17 / 100.0)
		value_3 = effect.GetRand(-30.0) or value_3
		value_3 = vm.f32(value_3 - 10.0)
		effect.SptSetColor(var3, 128.0, 128.0, 128.0, value_3)
		value_3 = effect.GetRand(6.0) or value_3
		value_3 = vm.f32(value_3 + 16.0)
		effect.SptSetVeloCol(var3, 0.0, 0.0, 0.0, value_3)
		value_3 = effect.GetRand(-0.8) or value_3
		value_3 = vm.f32(value_3 - vm.f32(1.6))
		effect.SptSetAccCol(var3, 0.0, 0.0, 0.0, value_3)
		value_6 = effect.GetRand(6.2831855) or value_6
		value_6 = vm.f32(value_6 - vm.f32(3.1415927))
		effect.SptSetRotz(var3, value_6)
		effect.SptSetVeloScl(var3, 0.04, 0.04)
		var3 = var3 + 1
	end
	var3 = 0
	while var3 < 30 do
		var3 = var3 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
