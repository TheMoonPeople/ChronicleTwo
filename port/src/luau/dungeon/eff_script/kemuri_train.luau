--!strict
-- dungeon/eff_script/kemuri_train.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_777ac8df = require("@lib/effect/helper_777ac8df")
local helper_8fa274d5 = require("@lib/effect/helper_8fa274d5")

--- Helper function.
local function helper_9a8(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
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
	value_4 = vm.f32(value_4 + 2.0)
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
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 2.0)
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
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local color_w: f32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	value_2 = 1
	effect.SetValueInt(1, 1)
	value = effect.GetValue(0) or value
	var18 = effect.SptAssignSprite_2(181) or var18
	if var18 == 0 then
		return
	end
	effect.SptSetTexname("kemuri_train")
	effect.SptInitSprite(0, 180)
	effect.SptSetAlphab(0, 1, 180)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 180)
	effect.SptSetPutSize(0, 64.0, 64.0, 180)
	effect.SptSetDrawFlag(0, 0, 180)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 180)
	effect.SptInitSprite(180, 1)
	effect.SptSetAlphab(180, 1, 1)
	effect.SptSetUvSize(180, 0.0, 0.0, 64.0, 64.0, 1)
	effect.SptSetPutSize(180, 194.0, 194.0, 1)
	effect.SptSetDrawFlag(180, 0, 1)
	effect.SptSetPos(180, 0.0, 0.0, 0.0, 1)
	var19 = 0
	var16 = 0
	var17 = 180
	while true do
		for var14 = 0, 180 do
			do
				local _, _, _, out4 = effect.SptGetColor(var14)
				color_w = out4 or color_w
			end
			if var14 < 180 then
				if color_w > 96.0 then
					effect.SptSetColor(var14, 96.0, 96.0, 96.0, 96.0)
					effect.SptSetVeloCol(var14, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var14, 0)
				end
			else
				if color_w > 64.0 then
					effect.SptSetColor(var14, 64.0, 64.0, 64.0, 64.0)
					effect.SptSetVeloCol(var14, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var14, 0)
				end
			end
		end
		value_2 = effect.GetValue(1) or value_2
		if value_2 ~= 0 then
			do
				local out1, out2, out3 = effect.GetEohPos(value)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.AddVector(var0, var1, var2, 0.0, 189.914, 30.725)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			for var22 = 0, 3 do
				helper_8fa274d5(var16, var0, var1, var2, 0.0, 45.0)
				var16 = var16 + 1
				if var16 >= 180 then
					var16 = 0
				end
			end
			if vm.imod(var19, 4) == 0 then
				helper_9a8(var17, var0, var1, var2, 0.0, 0.0)
			end
			var17 = 0
			if var17 >= 181 then
				var17 = 180
				var19 = 0
			end
		end
		helper_777ac8df(3)
		var19 = vm.i32(var19 + 1)
		vm.wait()
	end
	effect.SptSetDrawFlag(0, 0, 181)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
