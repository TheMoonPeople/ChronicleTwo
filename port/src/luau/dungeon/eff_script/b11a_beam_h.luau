--!strict
-- dungeon/eff_script/b11a_beam_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_2: s32 = 0
	local value_3: s32 = 0
	local check_motion_end: s32 = 0
	value_3 = 0
	value_2 = 0
	value = 0.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value_3 = effect.GetValue(0) or value_3
	value = effect.GetValueFloat(1) or value
	value_2 = effect.GetValue(2) or value_2
	effect.ChrSetScale(value, value, value)
	effect.ChrSetMotion("攻撃２ループ", 0)
	effect.ColprimCreate("吹っ飛び強")
	effect.ColprimSetDamage(value_3)
	while true do
		value = effect.GetValueFloat(1) or value
		effect.ChrSetScale(value, value, value)
		do
			local out1, out2, out3 = effect.GetWorkVect1()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 45.0)
		value_2 = effect.GetValue(2) or value_2
		if value_2 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
	effect.ChrSetMotion("攻撃２戻り", 6)
	while true do
		vm.wait()
		do
			local out1, out2, out3 = effect.GetWorkVect1()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
		check_motion_end = effect.ChrChkMotEnd() or check_motion_end
		if check_motion_end ~= 0 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
