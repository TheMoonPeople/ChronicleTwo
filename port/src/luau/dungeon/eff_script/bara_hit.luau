--!strict
-- dungeon/eff_script/bara_hit.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8b333653 = require("@lib/effect/helper_8b333653")

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
	local value_2: s32 = 0
	effect.GetValue(0)
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(0.0, 0.0, 0.0)
	effect.ChrSetMotion("薔薇ヒット", -1, 6)
	value_2 = effect.GetValue(1) or value_2
	effect.MonSePlay2(value_2, 8)
	vm.wait()
	helper_8b333653()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
