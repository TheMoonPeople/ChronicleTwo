--!strict
-- dungeon/eff_script/m_hibasira_c.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local get_now_frame_wait: f32 = 0
	local value: s32 = 0
	local var6: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	value = effect.GetValue(0) or value
	effect.ChrSetMotion("モンスター氷柱", -1, 6)
	var6 = 0
	effect.ColprimCreate("吹っ飛び攻撃")
	effect.ColprimSetDamage(value)
	effect.ColprimSetCoord(work_vect1_x, work_vect1_y, work_vect1_z, 25.0)
	while var6 < 56 do
		get_now_frame_wait = effect.ChrGetMotWait() or get_now_frame_wait
		if get_now_frame_wait > vm.f32(0.966) then
			effect.ColprimDelete(-1)
			return
		end
		hit_num = effect.ColprimGetHitcnt() or hit_num
		if hit_num > 0 then
			effect.ColprimDelete(-1)
			break
		else
			if var6 == 48 then
				effect.ColprimDelete(-1)
			end
			vm.wait()
			var6 = var6 + 1
		end
	end
	effect.ColprimDelete(-1)
	while var6 < 56 do
		get_now_frame_wait = effect.ChrGetMotWait() or get_now_frame_wait
		if get_now_frame_wait > vm.f32(0.966) then
			effect.ColprimDelete(-1)
			return
		end
		if var6 == 48 then
			effect.ColprimDelete(-1)
		end
		vm.wait()
		var6 = var6 + 1
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
