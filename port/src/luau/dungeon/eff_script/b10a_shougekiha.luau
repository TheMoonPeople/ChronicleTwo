--!strict
-- dungeon/eff_script/b10a_shougekiha.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: s32 = 0
	local value: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.GetValue(0) or value
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.ChrSetMotion("攻撃１", -1, 6)
	effect.ColprimCreate("吹っ飛び強")
	effect.ColprimSetDamage(value)
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 15.0)
	var6 = 0
	while var6 < 62 do
		if var6 == 3 then
			effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 40.0)
		end
		if var6 == 7 then
			effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 70.0)
		end
		if var6 == 17 then
			effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 50.0)
		end
		if var6 == 26 then
			break
		else
			vm.wait()
			var6 = var6 + 1
		end
	end
	effect.ColprimDelete(-1)
	helper_8b333653()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
