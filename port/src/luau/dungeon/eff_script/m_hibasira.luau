--!strict
-- dungeon/eff_script/m_hibasira.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: s32 = 0
	local var7: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	value = effect.GetValue(0) or value
	effect.BtlSePlay(76, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetMotion("火柱", -1, 6)
	var6 = 0
	var7 = 0
	effect.ColprimCreate("火弾")
	effect.ColprimSetDamage(value)
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 20.0)
	while var7 < 20 do
		if var6 == 0 then
			hit_num = effect.ColprimGetHitcnt() or hit_num
			if hit_num > 0 then
				var6 = 1
				effect.ColprimDelete(-1)
				break
			end
		end
		if var7 == 13 then
			var6 = 1
			effect.ColprimDelete(-1)
		end
		vm.wait()
		var7 = var7 + 1
	end
	helper_8b333653()
	if var6 == 0 then
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
