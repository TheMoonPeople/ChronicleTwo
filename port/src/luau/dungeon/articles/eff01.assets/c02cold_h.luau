--!strict
-- dungeon/articles/eff01.assets/c02cold_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	work_vect1_y = vm.f32(work_vect1_y + 2.0)
	var1 = vm.f32(var1 - 30.0)
	value = effect.GetValueFloat(0) or value
	value_2 = effect.GetRand(6.2831855) or value_2
	value_2 = vm.f32(value_2 - vm.f32(3.1415927))
	effect.ChrSetRot(0.0, value_2, 0.0)
	effect.ChrSetScale(4.0 + vm.f32(4.0 * value), 4.0 + vm.f32(4.0 * value), 4.0 + vm.f32(4.0 * value))
	effect.ChrSetShow(1, 1, 0.0625)
	effect.SptAssignSprite_1(10)
	effect.SptSetTexname("c02cold")
	effect.SptInitSprite(0, 10)
	effect.SptSetDrawFlag(0, 1, 10)
	effect.SptSetAlphab(0, 2, 10)
	effect.SptSetPutSize(0, 6.0, 6.0, 10)
	effect.SptSetUvSize(0, 0.0, 64.0, 64.0, 64.0, 10)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 10)
	if value < 1.0 then
		effect.BtlSePlay(71, var0, var1, var2)
	else
		effect.BtlSePlay(77, var0, var1, var2)
	end
	var11 = 0
	while var11 < 10 do
		do
			local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = effect.SubVector(var8, var9, var10, var0, var1, var2)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = effect.DivVector(var8, var9, var10, 2.0)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var8, var9, var10)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.ChrSetPos(var0, var1, var2)
		value_3 = effect.GetRand(6.2831855) or value_3
		value_3 = vm.f32(value_3 - vm.f32(3.1415927))
		value_4 = effect.GetRand(2.0) or value_4
		value_4 = vm.f32(value_4 + vm.f32(6.0 + vm.f32(6.0 * value)))
		value_5 = effect.GetRand(10.0 + vm.f32(10.0 * value)) or value_5
		value_5 = vm.f32(value_5 - vm.f32(vm.f32(10.0 + vm.f32(10.0 * value)) / 2.0))
		var15 = vm.f32(vm.f32(vm.sin(value_3) * value_4) + var0)
		var16 = vm.f32(value_5 + var1)
		var17 = vm.f32(vm.f32(vm.cos(value_3) * value_4) + var2)
		effect.SptSetPos(var11, var15, var16, var17)
		effect.SptSetColor(var11, 128.0, 128.0, 128.0, 92.0)
		effect.SptColorConv(var11, 128.0, 128.0, 128.0, 0.0, 8.0)
		effect.SptSetScale(var11, 2.0 + vm.f32(2.0 * value), 2.0 + vm.f32(2.0 * value))
		effect.SptScaleConv(var11, 4.0 + vm.f32(4.0 * value), 4.0 + vm.f32(4.0 * value), 6.0)
		value_3 = effect.GetRand(6.2831855) or value_3
		value_3 = vm.f32(value_3 - vm.f32(3.1415927))
		effect.SptSetRotz(var11, value_3)
		var11 = var11 + 1
		vm.wait()
	end
	var11 = 0
	while var11 < 10 do
		var11 = var11 + 1
		vm.wait()
	end
	effect.ChrSetShow(0, 1, 0.2)
	var11 = 0
	while var11 < 5 do
		var11 = var11 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
