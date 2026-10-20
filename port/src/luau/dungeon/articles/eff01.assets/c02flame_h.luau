--!strict
-- dungeon/articles/eff01.assets/c02flame_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local value_5: s32 = 0
	local var13: s32 = 0
	local value_6: f32 = 0
	local value_7: f32 = 0
	local value_8: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.GetValueFloat(0) or value
	effect.SptSetTexname("c02flame")
	effect.SptAssignSprite_1(36)
	effect.SptInitSprite(0, 36)
	effect.SptSetPutSize(0, 10.0, 10.0, 36)
	effect.SptSetDrawFlag(0, 0, 36)
	if value < 1.0 then
		effect.BtlSePlay(70, work_vect1_x, work_vect1_y, work_vect1_z)
	else
		effect.BtlSePlay(76, work_vect1_x, work_vect1_y, work_vect1_z)
	end
	value_5 = 3
	var10 = 6
	var9 = 0
	while var8 < 60 do
		if var9 < 3 and vm.imod(value_5, 3) == 0 then
			value_2 = effect.GetRand(6.0 + vm.f32(6.0 * value)) or value_2
			value_2 = vm.f32(vm.f32(value_2 - vm.f32(vm.f32(6.0 + vm.f32(6.0 * value)) / 2.0)) + work_vect1_x)
			value_3 = effect.GetRand(6.0 + vm.f32(6.0 * value)) or value_3
			value_3 = vm.f32(vm.f32(value_3 - vm.f32(vm.f32(6.0 + vm.f32(6.0 * value)) / 2.0)) + work_vect1_y)
			value_4 = effect.GetRand(6.0 + vm.f32(6.0 * value)) or value_4
			value_4 = vm.f32(vm.f32(value_4 - vm.f32(vm.f32(6.0 + vm.f32(6.0 * value)) / 2.0)) + work_vect1_z)
			var7 = effect.GetRand(6.2831855) or var7
			var7 = vm.f32(var7 - vm.f32(3.1415927))
			var7 = effect.AngleLimit(var7) or var7
			var13 = var9 * 2
			effect.SptSetDrawFlag(var13, 1)
			effect.SptSetAlphab(var13, 3)
			effect.SptSetUvSize(var13, 64.0, 64.0, 64.0, 64.0)
			effect.SptSetPos(var13, value_2, value_3, value_4)
			effect.SptSetRotz(var13, var7)
			effect.SptSetColor(var13, 128.0, 128.0, 128.0, 16.0)
			effect.SptSetVeloCol(var13, 0.0, 0.0, 0.0, 2.56)
			effect.SptSetAccCol(var13, 0.0, 0.0, 0.0, -0.4)
			effect.SptSetScale(
				var13,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * value),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * value)
			)
			effect.SptScaleConv(var13, 6.0 + vm.f32(6.0 * value), 6.0 + vm.f32(6.0 * value), 6.0)
			var13 = var13 + 1
			effect.SptSetDrawFlag(var13, 1)
			effect.SptSetAlphab(var13, 2)
			effect.SptSetUvSize(var13, 0.0, 0.0, 64.0, 64.0)
			effect.SptSetPos(var13, value_2, value_3, value_4)
			effect.SptSetRotz(var13, var7)
			effect.SptSetColor(var13, 128.0, 128.0, 128.0, 92.0)
			effect.SptSetVeloCol(var13, 0.0, 0.0, 0.0, 2.56)
			effect.SptSetAccCol(var13, 0.0, 0.0, 0.0, -0.4)
			effect.SptSetScale(
				var13,
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * value),
				vm.f32(0.1) + vm.f32(vm.f32(0.1) * value)
			)
			effect.SptScaleConv(var13, 6.0 + vm.f32(6.0 * value), 6.0 + vm.f32(6.0 * value), 6.0)
			for var12 = 0, 9 do
				effect.SptSetDrawFlag(var10, 1)
				effect.SptSetAlphab(var10, 2)
				effect.SptSetPutSize(var10, 4.0, 4.0)
				effect.SptSetUvSize(var10, 91.0, 0.0, 18.0, 6.0)
				effect.SptSetPos(var10, value_2, value_3, value_4)
				effect.SptSetColor(var10, 128.0, 128.0, 128.0, 128.0)
				effect.SptSetScale(var10, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value))
				var7 = effect.GetRand(6.2831855) or var7
				var7 = vm.f32(var7 - vm.f32(3.1415927))
				var7 = effect.AngleLimit(var7) or var7
				effect.SptSetRotz(var10, var7)
				value_6 = effect.GetRand(5.0 + vm.f32(5.0 * value)) or value_6
				value_6 = vm.f32(value_6 - vm.f32(vm.f32(5.0 + vm.f32(5.0 * value)) / 2.0))
				value_7 = effect.GetRand(5.0 + vm.f32(5.0 * value)) or value_7
				value_7 = vm.f32(value_7 - vm.f32(vm.f32(5.0 + vm.f32(5.0 * value)) / 2.0))
				value_8 = effect.GetRand(5.0 + vm.f32(5.0 * value)) or value_8
				value_8 = vm.f32(value_8 - vm.f32(vm.f32(5.0 + vm.f32(5.0 * value)) / 2.0))
				effect.SptSetVeloPos(var10, value_6, value_7, value_8)
				effect.SptSetAccPos(var10, -value_6 * vm.f32(0.05), -value_7 * vm.f32(0.05), -value_8 * vm.f32(0.05))
				effect.SptSetVeloCol(var10, 0.0, 0.0, 0.0, 0.0)
				effect.SptSetAccCol(var10, 0.0, 0.0, 0.0, -0.8)
				var10 = vm.i32(var10 + 1)
			end
			var9 = var9 + 1
		end
		value_5 = effect.GetRandInt(100) or value_5
		var8 = var8 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
