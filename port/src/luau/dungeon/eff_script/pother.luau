--!strict
-- dungeon/eff_script/pother.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_5: s32 = 0
	local value_6: f32 = 0
	local var12: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("base_eff2")
	effect.SptAssignSprite_1(8)
	effect.SptInitSprite(0, 8)
	effect.SptSetAlphab(0, 1, 8)
	effect.SptSetDrawFlag(0, 1, 8)
	effect.SptSetPutSize(0, 14.0, 14.0, 8)
	effect.SptSetUvSize(0, 1.0, 1.0, 62.0, 62.0, 8)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 8)
	var3 = 0
	while var3 < 8 do
		value = effect.GetRand(18.0) or value
		value = vm.f32(vm.f32(value - 9.0) + work_vect1_x)
		value_2 = effect.GetRand(9.0) or value_2
		value_2 = vm.f32(value_2 + work_vect1_y)
		value_3 = effect.GetRand(18.0) or value_3
		value_3 = vm.f32(vm.f32(value_3 - 9.0) + work_vect1_z)
		effect.SptSetPos(var3, value, value_2, value_3)
		effect.SptSetVeloPos(var3, 0.0, 0.2, 0.0)
		effect.SptSetAccPos(var3, 0.0, -0.01, 0.0)
		value_4 = effect.GetRand(6.2831855) or value_4
		value_4 = vm.f32(value_4 - vm.f32(3.1415927))
		effect.SptSetRotz(var3, value_4)
		value_5 = effect.GetRandInt(100) or value_5
		if value_5 < 50 then
			value_4 = vm.f32(0.06)
		else
			value_4 = vm.f32(-0.06)
		end
		effect.SptSetVeloRotz(var3, value_4)
		effect.SptSetAccRotz(var3, -vm.f32(value_4 * vm.f32(0.02)))
		value_6 = effect.GetRand(10.0) or value_6
		value_6 = vm.f32(value_6 + vm.f32(15.6))
		effect.SptSetVeloCol(var3, 0.0, 0.0, 0.0, value_6)
		value_6 = effect.GetRand(2.0) or value_6
		value_6 = vm.f32(value_6 + 2.0)
		effect.SptSetAccCol(var3, 0.0, 0.0, 0.0, -value_6)
		var3 = var3 + 1
	end
	var12 = 1.0
	var3 = 0
	while var3 < 30 do
		effect.SptSetScale(0, var12, var12, 8)
		var12 = vm.f32(var12 + vm.f32(0.06))
		var3 = var3 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
