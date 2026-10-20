--!strict
-- dungeon/eff_script/m_shockwave.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	local value_2: s32 = 0
	value_2 = 0
	effect.GetUserId()
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(0.0, 0.0, 0.0)
	effect.ChrSetShow(1, 1, 0.1)
	effect.ChrSetMotion("発動", -1, 6)
	if value_2 == 0 then
		effect.ColprimCreate("吹っ飛び弱")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 30.0)
		effect.ColprimSetDamage(value)
	end
	if value_2 == 1 then
		effect.ColprimCreate("通常ＢＧＣ")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 30.0)
		effect.ColprimSetDamage(value)
	end
	for var8 = 0, 19 do
		if var8 == 16 then
			effect.ColprimDelete(-1)
		end
		vm.wait()
	end
	helper_8b333653()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
