--!strict
-- dungeon/eff_script/n_heal_sub.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("n_heal")
	effect.SptSetAlphab(2)
	effect.SptAssignSprite_1(1)
	effect.SptInitSprite(0)
	effect.SptSetDrawFlag(0, 1)
	effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.SptSetPutSize(0, 6.0, 6.0)
	effect.SptSetUvSize(0, 0.0, 64.0, 32.0, 32.0)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0)
	var0 = 128.0
	value = effect.GetRand(40.0) or value
	value = vm.f32(value - 20.0)
	value = vm.f32(vm.f32(value / 360.0) * vm.f32(3.1415927))
	var1 = value
	while true do
		effect.SptAddPos(0, 0.0, -0.1, 0.0)
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var0)
		effect.SptAddRotz(0, var1)
		var0 = vm.f32(var0 - 4.0)
		if var0 <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
