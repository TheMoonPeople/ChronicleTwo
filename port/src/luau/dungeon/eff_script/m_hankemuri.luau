--!strict
-- dungeon/eff_script/m_hankemuri.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	value_4 = vm.f32(value_4 + 4.0)
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
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local color_w: f32 = 0
	local user_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: s32 = 0
	user_id = effect.GetUserId() or user_id
	var19 = effect.SptAssignSprite_2(16) or var19
	if var19 == 0 then
		return
	end
	effect.SptSetTexname("effect00")
	effect.SptInitSprite(0, 15)
	effect.SptSetAlphab(0, 2, 15)
	effect.SptSetUvSize(0, 0.1, 161.0, 95.0, 95.0, 15)
	effect.SptSetPutSize(0, 128.0, 128.0, 15)
	effect.SptSetDrawFlag(0, 0, 15)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 15)
	effect.SptInitSprite(15, 1)
	effect.SptSetAlphab(15, 2, 1)
	effect.SptSetUvSize(15, 161.0, 161.0, 95.0, 95.0, 1)
	effect.SptSetPutSize(15, 194.0, 194.0, 1)
	effect.SptSetDrawFlag(15, 0, 1)
	effect.SptSetPos(15, 0.0, 0.0, 0.0, 1)
	var20 = 0
	var17 = 0
	var18 = 15
	while true do
		for var15 = 0, 15 do
			do
				local _, _, _, out4 = effect.SptGetColor(var15)
				color_w = out4 or color_w
			end
			if var15 < 15 then
				if color_w > 96.0 then
					effect.SptSetColor(var15, 96.0, 96.0, 96.0, 96.0)
					effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var15, 0)
				end
			else
				if color_w > 64.0 then
					effect.SptSetColor(var15, 64.0, 64.0, 64.0, 64.0)
					effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var15, 0)
				end
			end
		end
		do
			local out1, out2, out3 = effect.ScnGetChrPos(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var21 = 0
		helper_8fa274d5(var17, pos_x, pos_y, pos_z, 0.0, 0.0)
		var17 = var17 + 1
		if var17 >= 15 then
			var17 = 0
		end
		var21 = var21 + 1
		if vm.imod(var20, 4) == 0 then
			helper_9a8(var18, pos_x, pos_y, pos_z, 0.0, 0.0)
		end
		if vm.imod(var20, 4) == 0 then
			var18 = 0
			if var18 >= 16 then
				var18 = 15
				var20 = 0
			end
		end
		helper_777ac8df(3)
		var20 = vm.i32(var20 + 1)
		vm.wait()
	end
	effect.SptSetDrawFlag(0, 0, 16)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
