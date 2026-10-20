--!strict
-- dungeon/eff_script/m_onpa.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	local var12: s32 = 0
	value = 0.0
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
	value_2 = effect.GetValue(0) or value_2
	value = effect.GetValueFloat(1) or value
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.ChrSetMotion("発射")
	var12 = 0
	for var8 = 0, 29 do
		if var8 == 8 then
			effect.ColprimCreate("弱攻撃")
			effect.ColprimSetDamage(value_2)
			work_vect1_x = vm.f32(work_vect1_x + vm.f32(vm.sin(work_vect2_y) * 75.0))
			work_vect1_z = vm.f32(work_vect1_z + vm.f32(vm.cos(work_vect2_y) * 75.0))
			effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, value)
		end
		if var8 == 18 then
			var12 = 1
			effect.ColprimDelete(-1)
		end
		vm.wait()
	end
	if var12 == 0 then
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
