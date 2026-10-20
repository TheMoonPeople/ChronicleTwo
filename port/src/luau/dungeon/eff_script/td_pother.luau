--!strict
-- dungeon/eff_script/td_pother.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("base_eff2")
	effect.SptAssignSprite_1(3)
	effect.SptInitSprite(0, 3)
	effect.SptSetAlphab(0, 1, 3)
	effect.SptSetDrawFlag(0, 1, 3)
	effect.SptSetPutSize(0, 14.0, 14.0, 3)
	effect.SptSetUvSize(0, 1.0, 1.0, 62.0, 62.0, 3)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 3)
	var3 = 0
	while var3 < 3 do
		value = effect.GetRand(16.0) or value
		value = vm.f32(vm.f32(value - 8.0) + work_vect1_x)
		value_2 = effect.GetRand(8.0) or value_2
		value_2 = vm.f32(value_2 + work_vect1_y)
		value_3 = effect.GetRand(16.0) or value_3
		value_3 = vm.f32(vm.f32(value_3 - 8.0) + work_vect1_z)
		effect.SptSetPos(var3, value, value_2, value_3)
		effect.SptSetVeloPos(var3, 0.0, 0.2, 0.0)
		effect.SptSetAccPos(var3, 0.0, -0.01, 0.0)
		value_4 = effect.GetRand(6.2831855) or value_4
		value_4 = vm.f32(value_4 - vm.f32(3.1415927))
		effect.SptSetRotz(var3, value_4)
		value_4 = effect.GetRand(0.06544985) or value_4
		value_4 = vm.f32(value_4 - vm.f32(0.034147747))
		effect.SptSetVeloRotz(var3, value_4)
		var3 = var3 + 1
	end
	var9 = 0
	var8 = 0.0
	var10 = 1.0
	var3 = 0
	while var3 < 30 do
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var8, 3)
		if var8 >= 128.0 then
			var9 = 1
		end
		if var9 == 0 then
			var8 = vm.f32(var8 + vm.f32(25.6))
		else
			var8 = vm.f32(var8 - vm.f32(6.4))
		end
		effect.SptSetScale(0, var10, var10, 3)
		var10 = vm.f32(var10 + vm.f32(0.06))
		var3 = var3 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
