--!strict
-- dungeon/eff_script/kotore_explosion.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local get_now_frame_wait: f32 = 0
	local user_id: s32 = 0
	local value: s32 = 0
	local var7: s32 = 0
	local hit_num: s32 = 0
	user_id = effect.GetUserId() or user_id
	do
		local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "eff1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	effect.ChrSetPos(pos_x, pos_y, pos_z)
	value = effect.GetValue(0) or value
	effect.ChrSetScale(0.65, 0.65, 0.65)
	effect.ChrSetMotion("火柱", -1, 6)
	effect.GetUserId()
	var7 = 0
	effect.ColprimCreate("吹っ飛び攻撃")
	effect.ColprimSetDamage(value)
	effect.ColprimSetCoord(pos_x, pos_y, pos_z, 25.0)
	while var7 < 56 do
		hit_num = effect.ColprimGetHitcnt() or hit_num
		if hit_num > 0 then
			effect.ColprimDelete(-1)
			break
		end
		if var7 == 48 then
			effect.ColprimDelete(-1)
		end
		vm.wait()
		var7 = var7 + 1
	end
	while var7 < 56 do
		get_now_frame_wait = effect.ChrGetMotWait() or get_now_frame_wait
		if get_now_frame_wait > vm.f32(0.966) then
			effect.ColprimDelete(-1)
			return
		end
		if var7 == 48 then
			effect.ColprimDelete(-1)
		end
		vm.wait()
		var7 = var7 + 1
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
