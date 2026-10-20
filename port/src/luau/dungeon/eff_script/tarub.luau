--!strict
-- dungeon/eff_script/tarub.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_244(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	value_2 = effect.GetRand(arg5) or value_2
	value_3 = effect.GetRand(360.0) or value_3
	value_4 = effect.GetRand(0.02) or value_4
	value_5 = effect.GetRand(0.3) or value_5
	value = effect.GetRand(0.3) or value
	value_4 = vm.f32(value_4 + vm.f32(0.01))
	value_5 = vm.f32(value_5 + vm.f32(0.3))
	value = vm.f32(value + vm.f32(0.8))
	value_3 = vm.f32(vm.f32(value_3 / 180.0) * vm.f32(3.1415927))
	var6 = vm.f32(arg1 + vm.f32(vm.sin(value_3) * value_2))
	var7 = arg2
	var8 = vm.f32(arg3 + vm.f32(vm.cos(value_3) * value_2))
	var12 = vm.f32(vm.f32(0.02) * vm.sin(arg4))
	var14 = vm.f32(vm.f32(0.02) * vm.cos(arg4))
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, var6, var7, var8)
	effect.SptSetColor(arg0, 128.0, 128.0, 128.0, 0.0)
	effect.SptSetVeloPos(arg0, var12, value_5, var14)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 2.0)
	effect.SptSetVeloRotz(arg0, value_4)
	effect.SptSetScale(arg0, value, value, value)
end

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
	local color_w: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var14: s32 = 0
	local var19: s32 = 0
	local value: f32 = 0
	effect.GetUserId()
	var19 = effect.SptAssignSprite_2(1) or var19
	if var19 == 0 then
		return
	end
	effect.SptSetTexname("effect00")
	effect.SptInitSprite(0, 1)
	effect.SptSetAlphab(0, 2, 1)
	effect.SptSetUvSize(0, 0.1, 161.0, 95.0, 95.0, 1)
	effect.SptSetPutSize(0, 24.0, 48.0, 1)
	effect.SptSetDrawFlag(0, 0, 1)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 1)
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	var11 = 15.0
	var12 = 0.0
	var14 = 0
	while var14 < 1 do
		helper_244(var14, work_vect1_x, work_vect1_y, work_vect1_z, var11, var12)
		var14 = var14 + 1
	end
	while var14 < 150 do
		for var15 = 0, 0 do
			do
				local _, _, _, out4 = effect.SptGetColor(var15)
				color_w = out4 or color_w
			end
			if color_w > 64.0 then
				effect.SptSetColor(var15, 128.0, 128.0, 128.0, 63.0)
				value = effect.GetRand(0.6) or value
				value = vm.f32(value + vm.f32(0.4))
				effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, -value)
			end
		end
		vm.wait()
		var14 = var14 + 1
	end
	effect.SptSetDrawFlag(0, 0, 1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
