--!strict
-- dungeon/articles/eff01.assets/c02lightning_hit.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local var11: f32 = 0
	local value_4: s32 = 0
	local var13: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.GetValueFloat(0) or value
	var5 = vm.f32(16 + vm.f32(16 * value))
	effect.SptSetTexname("c02lightning_hit")
	effect.SptAssignSprite_1(5 + var5)
	effect.SptInitSprite(0, 5 + var5)
	effect.SptSetAlphab(0, 2, 5 + var5)
	effect.SptSetDrawFlag(0, 1, 5 + var5)
	effect.SptSetUvSize(0, 0.0, 0.0, 48.0, 48.0)
	effect.SptSetPutSize(0, 20.0, 20.0)
	effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.SptSetScale(0, vm.f32(0.2) + vm.f32(vm.f32(0.2) * value), vm.f32(0.2) + vm.f32(vm.f32(0.2) * value))
	effect.SptScaleConv(0, 2.0 + vm.f32(2.0 * value), 2.0 + vm.f32(2.0 * value), 4.0)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 255.0)
	effect.SptColorConv(0, 128.0, 128.0, 128.0, 0.0, 6.0)
	effect.SptSetUvSize(1, 16, 96, 32, 32, var5)
	effect.SptSetPutSize(1, 6.0, 6.0, var5)
	effect.SptSetPos(1, work_vect1_x, work_vect1_y, work_vect1_z, var5)
	effect.SptSetColor(1, 128.0, 128.0, 128.0, 128.0, var5)
	effect.SptSetAccCol(1, 0.0, 0.0, 0.0, -1.4, var5)
	effect.SptSetScale(1, vm.f32(0.6) + vm.f32(vm.f32(0.6) * value), vm.f32(0.6) + vm.f32(vm.f32(0.6) * value), var5)
	var4 = 0
	while var4 < var5 do
		value_3 = effect.GetRand(6.2831855) or value_3
		value_3 = vm.f32(value_3 - vm.f32(3.1415927))
		value_2 = effect.GetRand(6.2831855) or value_2
		value_2 = vm.f32(value_2 - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.GetDirVector(value_3, value_2, 0.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, vm.f32(1.6) + vm.f32(vm.f32(1.6) * value))
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.SptSetVeloPos(vm.i32(1 + var4), var6, var7, var8)
		var6 = -vm.f32(var6 * vm.f32(0.05))
		var7 = -vm.f32(var7 * vm.f32(0.05))
		var8 = -vm.f32(var8 * vm.f32(0.05))
		effect.SptSetAccPos(vm.i32(1 + var4), var6, var7, var8)
		var4 = vm.i32(var4 + 1)
	end
	effect.SptSetPutSize(1 + var5, 2.0, 12.8, 4)
	effect.SptSetColor(1 + var5, 128.0, 128.0, 128.0, 255.0, 4)
	effect.SptColorConv(1 + var5, 128.0, 128.0, 128.0, 0.0, 5.0, 4)
	effect.SptSetScale(
		1 + var5,
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
		vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
		4
	)
	effect.SptScaleConv(1 + var5, 2.0 + vm.f32(2.0 * value), 2.0 + vm.f32(2.0 * value), 8.0, 4)
	var11 = effect.GetRand(6.2831855) or var11
	var11 = vm.f32(var11 - vm.f32(3.1415927))
	var4 = 0
	while var4 < 4 do
		var11 = vm.f32(var11 + vm.f32(0.7853982))
		var11 = effect.AngleLimit(var11) or var11
		effect.SptSetRotz(vm.f32(1 + var5) + var4, var11)
		value_3 = effect.GetRand(6.2831855) or value_3
		value_3 = vm.f32(value_3 - vm.f32(3.1415927))
		value_2 = effect.GetRand(6.2831855) or value_2
		value_2 = vm.f32(value_2 - vm.f32(3.1415927))
		do
			local out1, out2, out3 = effect.GetDirVector(value_3, value_2, 0.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, vm.f32(2.8) + vm.f32(vm.f32(2.8) * value))
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.AddVector(var6, var7, var8, work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.SptSetPos(vm.f32(1 + var5) + var4, var6, var7, var8)
		value_4 = effect.GetRandInt(4) or value_4
		effect.SptSetUvSize(vm.f32(1 + var5) + var4, vm.i32(vm.i32(value_4 * 20) + 48), 0, 20, 128)
		var4 = var4 + 1
	end
	if value < 1.0 then
		effect.BtlSePlay(72, work_vect1_x, work_vect1_y, work_vect1_z)
	else
		effect.BtlSePlay(78, work_vect1_x, work_vect1_y, work_vect1_z)
	end
	var13 = 0
	var4 = 0
	while var4 < 32 do
		if var4 < var5 then
			effect.SptSetBlinking(1 + var4, 0.0, 0.0, 0.0, 32.0, 1.5707964)
		end
		value_4 = effect.GetRandInt(4) or value_4
		effect.SptSetUvSize(vm.f32(1 + var5) + var13, vm.i32(vm.i32(value_4 * 20) + 48), 0, 20, 128)
		var13 = var13 + 1
		if var13 >= 4 then
			var13 = 0
		end
		var4 = var4 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
