--!strict
-- dungeon/eff_script/guard_eff_a.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = 0
	effect.CopyVector(0.0, 0.0, 0.0)
	value = effect.GetValue(0) or value
	effect.GetWorkVect2()
	effect.CopyVector(96.0, 128.0, 96.0)
	value = 0
	if value == 0 then
		effect.SptSetTexname("effect01")
		effect.SptAssignSprite_1(2)
		effect.SptInitSprite(0)
		effect.SptSetAlphab(0, 2)
		effect.SptSetDrawFlag(0, 1)
		effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(0, 30.0, 30.0)
		effect.SptSetUvSize(0, 0, 0, 128.0, 128.0)
		effect.SptSetColor(0, 96.0, 128.0, 96.0, 128.0)
		effect.SptInitSprite(1)
		effect.SptSetAlphab(1, 2)
		effect.SptSetDrawFlag(1, 0)
		effect.SptSetPos(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(1, 25.0, 25.0)
		effect.SptSetUvSize(1, 0, 0, 128.0, 128.0)
		effect.SptSetColor(1, 96.0, 128.0, 96.0, 64.0)
		effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -8.0)
		effect.SptSetVeloCol(1, 0.0, 0.0, 0.0, -2.0)
		var9 = 1.0
		var10 = 1.0
		var11 = 0
		while var11 <= 36 do
			effect.SptSetScale(0, var9, var9)
			effect.SptSetScale(1, var10, var10)
			var9 = vm.f32(var9 + vm.f32(0.03))
			if var11 == 4 then
				effect.SptSetDrawFlag(1, 1)
			end
			if var11 > 4 then
				var10 = vm.f32(var10 + vm.f32(0.02))
			end
			var11 = var11 + 1
			vm.wait()
		end
	end
	if value == 1 then
		effect.SptSetTexname("effect01")
		effect.SptAssignSprite_1(3)
		effect.SptInitSprite(0)
		effect.SptSetAlphab(0, 2)
		effect.SptSetDrawFlag(0, 1)
		effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(0, 60.0, 60.0)
		effect.SptSetUvSize(0, 128.0, 0.0, 128.0, 128.0)
		effect.SptSetColor(0, 96.0, 128.0, 96.0, 128.0)
		effect.SptInitSprite(1)
		effect.SptSetAlphab(1, 2)
		effect.SptSetDrawFlag(1, 0)
		effect.SptSetPos(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(1, 42.0, 42.0)
		effect.SptSetUvSize(1, 128.0, 0.0, 128.0, 128.0)
		effect.SptSetColor(1, 96.0, 128.0, 96.0, 128.0)
		effect.SptInitSprite(2)
		effect.SptSetAlphab(2, 2)
		effect.SptSetDrawFlag(2, 0)
		effect.SptSetPos(2, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(2, 32.0, 32.0)
		effect.SptSetUvSize(2, 128.0, 0.0, 128.0, 128.0)
		effect.SptSetColor(2, 96.0, 128.0, 96.0, 32.0)
		effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -8.0)
		effect.SptSetVeloCol(1, 0.0, 0.0, 0.0, -8.0)
		effect.SptSetVeloCol(2, 0.0, 0.0, 0.0, -2.0)
		var12 = 1.0
		var13 = 1.0
		var14 = 1.0
		var15 = 0
		effect.SptSetDrawFlag(0, 0)
		effect.SptSetVeloRotz(1, 0.03)
		effect.SptSetAccRotz(1, 0.015, 0.015, 0.015)
		while var15 <= 36 do
			effect.SptSetScale(0, var12, var12)
			effect.SptSetScale(1, var13, var13)
			effect.SptSetScale(2, var14, var14)
			var12 = vm.f32(var12 - vm.f32(0.02))
			if var15 == 0 then
				effect.SptSetDrawFlag(1, 1)
			end
			if var15 > 0 then
				var13 = vm.f32(var13 - vm.f32(0.04))
			end
			if var13 <= vm.f32(0.6) then
				break
			end
			var15 = vm.i32(var15 + 1)
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
