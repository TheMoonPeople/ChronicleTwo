--!strict
-- dungeon/eff_script/p00_23a_hibasira.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: s32 = 0
	local value: s32 = 0
	local hit_num: s32 = 0
	local var9: s32 = 0
	local value_2: s32 = 0
	local check_motion_end: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.GetWorkVect2()
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(0.0, 0.0, 0.0)
	effect.ChrSetScale(3.0, 3.0, 3.0)
	effect.ChrSetMotion("火柱", -1, 6)
	effect.ColprimCreate("Ｍギル火柱１")
	effect.ColprimSetDamage(value)
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 25.0)
	effect.MonSePlay2(value_2, 9)
	var9 = 0
	var6 = 0
	while var6 < 25 do
		if var6 >= 10 then
			if var9 == 0 then
				hit_num = effect.ColprimGetHitcnt() or hit_num
				if hit_num > 0 then
					if var9 == 0 then
						var9 = 1
						effect.ColprimDelete(-1)
					end
				end
			end
		end
		if var6 == 10 then
			effect.ColprimDelete(-1)
			effect.ColprimCreate("攻撃弱")
			effect.ColprimSetDamage(value)
			effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 30.0)
		end
		if var6 == 20 then
			if var9 == 0 then
				var9 = 1
				effect.ColprimDelete(-1)
			end
		end
		var6 = var6 + 1
		vm.wait()
	end
	check_motion_end = 0
	while check_motion_end == 0 do
		vm.wait()
		check_motion_end = effect.ChrChkMotEnd() or check_motion_end
	end
	if var9 == 0 then
		var9 = 1
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
