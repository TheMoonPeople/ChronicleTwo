--!strict
-- dungeon/eff_script/m_smoke.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local check_motion_end: s32 = 0
	value = 0.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.GetValueFloat(0) or value
	if value == 0.0 then
		value = 1.0
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetMotion("煙", -1, 6)
	effect.ChrSetScale(value, value, value)
	effect.ChrSetShow(1, 1, 0.1)
	check_motion_end = 0
	while check_motion_end == 0 do
		vm.wait()
		check_motion_end = effect.ChrChkMotEnd() or check_motion_end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
