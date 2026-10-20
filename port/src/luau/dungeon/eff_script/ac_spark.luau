--!strict
-- dungeon/eff_script/ac_spark.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("effect00")
	effect.SptSetAlphab(2)
	effect.SptAssignSprite_1(1)
	effect.SptInitSprite(0)
	effect.SptSetDrawFlag(0, 1)
	effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.SptSetPutSize(0, 24.0, 24.0)
	effect.SptSetUvSize(0, 193.0, 1.0, 62.0, 62.0)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0)
	var3 = 0.0
	while true do
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var3)
		var3 = vm.f32(var3 + vm.f32(25.6))
		if var3 >= 128.0 then
			var3 = 1.8e-43 -- retail: integer bits read as a float
			break
		end
		vm.wait()
	end
	while true do
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var3)
		var3 = vm.f32(var3 - vm.f32(12.8))
		if var3 <= 0.0 then
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
