--!strict
-- dungeon/articles/eff01.assets/explosion.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

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
	effect.ChrSetMotion("爆発", -1, 6)
	effect.BtlSePlay(11, work_vect1_x, work_vect1_y, work_vect1_z)
	hit_num = 0
	var4 = 0
	if value == 1 then
		effect.ColprimCreate("爆発")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 24.0)
		effect.ColprimSetDamage(100)
	end
	if value == 2 then
		effect.ColprimCreate("爆発")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 33.6)
		effect.ColprimSetDamage(400)
		effect.ChrSetScale(1.4, 1.4, 1.4)
	end
	if value == 3 then
		effect.ColprimCreate("爆発")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 43.199997)
		effect.ColprimSetDamage(800)
		effect.ChrSetScale(1.8, 1.8, 1.8)
	end
	if value == 4 then
		effect.ColprimCreate("爆発")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 18.0)
		effect.ColprimSetDamage(40)
	end
	if value == 5 then
		effect.ColprimCreate("宝箱爆発")
		effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 33.6)
		effect.ChrSetScale(1.8, 1.8, 1.8)
	end
	while var4 < 114 do
		if value ~= 0 and hit_num <= 0 then
			hit_num = effect.ColprimGetHitcnt() or hit_num
			if hit_num > 0 or var4 == 30 then
				hit_num = 1
				effect.ColprimDelete(-1)
			end
		end
		var4 = var4 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
