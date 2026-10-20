--!strict
-- dungeon/eff_script/kai_bomb.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var2: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local var6: s32 = 0
	var2 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.GetValue(0) or value
	effect.GetValue(1)
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetMotion("爆発", -1, 6)
	effect.ColprimCreate("海賊爆弾")
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 20.0)
	effect.ColprimSetDamage(value)
	var6 = 0
	while var6 < 40 do
		if var6 == 30 then
			var2 = 1
			effect.ColprimDelete(-1)
		end
		var6 = var6 + 1
		vm.wait()
	end
	helper_8b333653()
	if var2 == 0 then
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
