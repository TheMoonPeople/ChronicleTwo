--!strict
-- dungeon/eff_script/maseki_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local var4: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.GetValue(0) or value
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetMotion("聖", -1, 6)
	effect.BtlSePlay(11, work_vect1_x, work_vect1_y, work_vect1_z)
	hit_num = 0
	var4 = 0
	if value == 1 then
		effect.ColprimCreate("魔石聖")
	end
	if value == 2 then
		effect.ColprimCreate("聖水")
	end
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 15.0)
	while var4 < 40 do
		if hit_num <= 0 then
			hit_num = effect.ColprimGetHitcnt() or hit_num
			if hit_num > 0 or var4 == 30 then
				hit_num = 1
				effect.ColprimDelete(-1)
			end
		end
		var4 = var4 + 1
		vm.wait()
	end
	helper_8b333653()
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
