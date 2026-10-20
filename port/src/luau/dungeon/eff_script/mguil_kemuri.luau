--!strict
-- dungeon/eff_script/mguil_kemuri.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_244(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = effect.GetRand(arg5) or value
	value_2 = effect.GetRand(360.0) or value_2
	value_3 = effect.GetRand(0.01) or value_3
	value_4 = effect.GetRand(1.0) or value_4
	value_4 = vm.f32(value_4 + 1.0)
	value_2 = vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))
	var6 = vm.f32(arg1 + vm.f32(vm.sin(value_2) * value))
	var7 = arg2
	var8 = vm.f32(arg3 + vm.f32(vm.cos(value_2) * value))
	var12 = vm.f32(vm.f32(0.8) * vm.sin(arg4))
	var13 = value_4
	var14 = vm.f32(vm.f32(0.8) * vm.cos(arg4))
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, var6, var7, var8)
	effect.SptSetColor(arg0, 128.0, 128.0, 128.0, 0.0)
	effect.SptSetVeloPos(arg0, var12, var13, var14)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 0.2)
	effect.SptSetVeloRotz(arg0, value_3)
end

--- Helper function.
local function helper_888(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var17: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = effect.GetRand(arg5) or value
	value_2 = effect.GetRand(360.0) or value_2
	value_3 = effect.GetRand(0.01) or value_3
	value_4 = effect.GetRand(1.0) or value_4
	value_4 = vm.f32(value_4 + 0.5)
	value_2 = vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))
	var17 = vm.sin(arg4)
	var6 = vm.f32(arg1 + vm.f32(vm.sin(value_2) * value))
	var7 = arg2
	var8 = vm.f32(arg3 + vm.f32(vm.cos(value_2) * value))
	var12 = vm.f32(vm.f32(0.4) * var17)
	var13 = value_4
	var14 = vm.f32(vm.f32(0.4) * var17)
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, var6, var7, var8)
	effect.SptSetColor(arg0, 128.0, 128.0, 128.0, 0.0)
	effect.SptSetVeloPos(arg0, var12, var13, var14)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 0.1)
	effect.SptSetVeloRotz(arg0, value_3)
end

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
	local color_w: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local user_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local value: s32 = 0
	user_id = effect.GetUserId() or user_id
	var19 = effect.SptAssignSprite_2(540) or var19
	if var19 == 0 then
		return
	end
	effect.SptSetTexname("effect00")
	effect.SptInitSprite(0, 450)
	effect.SptSetAlphab(0, 2, 450)
	effect.SptSetUvSize(0, 0.1, 161.0, 95.0, 95.0, 450)
	effect.SptSetPutSize(0, 32.0, 32.0, 450)
	effect.SptSetDrawFlag(0, 0, 450)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 450)
	effect.SptInitSprite(450, 90)
	effect.SptSetAlphab(450, 2, 90)
	effect.SptSetUvSize(450, 161.0, 161.0, 95.0, 95.0, 90)
	effect.SptSetPutSize(450, 100.0, 100.0, 90)
	effect.SptSetDrawFlag(450, 0, 90)
	effect.SptSetPos(450, 0.0, 0.0, 0.0, 90)
	var20 = 0
	var17 = 0
	var18 = 450
	while true do
		for var15 = 0, 539 do
			do
				local _, _, _, out4 = effect.SptGetColor(var15)
				color_w = out4 or color_w
			end
			if var15 < 450 then
				if color_w > 24.0 then
					effect.SptSetColor(var15, 128.0, 128.0, 128.0, 48.0)
					effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, -0.3)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var15, 0)
				end
			else
				if color_w > 24.0 then
					effect.SptSetColor(var15, 128.0, 128.0, 128.0, 32.0)
					effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, -0.2)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var15, 0)
				end
			end
		end
		value = effect.GetValue(2) or value
		if value == 0 then
			for var14 = 0, 2 do
				if var14 == 0 then
					do
						local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "eff0_03")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					var11 = 200.0
					var12 = 0.0
				end
				if var14 == 1 then
					do
						local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "eff0_01")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					var11 = 100.0
					var12 = vm.f32(1.5707964)
				end
				if var14 == 2 then
					do
						local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "eff0_02")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					var11 = 100.0
					var12 = vm.f32(-1.5707964)
				end
				for var22 = 0, 1 do
					helper_244(var17, pos_x, pos_y, pos_z, var11, var12)
					if var17 < 450 then
						var17 = var17 + 1
					else
						var17 = 0
					end
				end
				if vm.imod(var20, 4) == 0 then
					helper_888(var18, pos_x, pos_y, pos_z, var11, var12)
				end
				if vm.imod(var20, 4) == 0 then
					if var18 < 540 then
						var18 = var18 + 1
					else
						var18 = 450
						var20 = 0
					end
				end
			end
		end
		var20 = vm.i32(var20 + 1)
		vm.wait()
	end
	effect.SptSetDrawFlag(0, 0, 540)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
