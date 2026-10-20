--!strict
-- dungeon/eff_script/polm_smoke.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("m_kemuri")
	effect.SptAssignSprite_1(8)
	effect.SptInitSprite(0, 8)
	effect.SptSetAlphab(0, 2, 8)
	effect.SptSetDrawFlag(0, 1, 8)
	effect.SptSetPutSize(0, 10.0, 10.0, 8)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 8)
	for var3 = 0, 7 do
		value = effect.GetRand(25.0) or value
		value = vm.f32(value - 12.5)
		value_2 = effect.GetRand(25.0) or value_2
		value_2 = vm.f32(value_2 - 12.5)
		value_3 = effect.GetRand(25.0) or value_3
		value_3 = vm.f32(value_3 - 12.5)
		effect.SptSetPos(var3, work_vect1_x + value, work_vect1_y + value_2, work_vect1_z + value_3)
		value_4 = effect.GetRand(360.0) or value_4
		value_4 = vm.f32(vm.f32(vm.f32(vm.f32(value_4 / 360.0) * vm.f32(3.1415927)) * 2.0) - vm.f32(3.1415927))
		effect.SptSetRotz(var3, value_4)
	end
	var8 = 128.0
	var9 = 1.0
	while true do
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var8, 8)
		effect.SptSetScale(0, var9, var9, 8)
		var8 = vm.f32(var8 - 6.0)
		if var8 <= 0.0 then
			break
		else
			var9 = vm.f32(var9 + vm.f32(0.2))
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
