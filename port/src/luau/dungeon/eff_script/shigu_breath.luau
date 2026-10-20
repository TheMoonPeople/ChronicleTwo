--!strict
-- dungeon/eff_script/shigu_breath.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_110(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	do
		local out1, out2, out3 = effect.NormalVector(arg4, arg5, arg6)
		arg4 = out1 or arg4
		arg5 = out2 or arg5
		arg6 = out3 or arg6
	end
	value = effect.GetRand(0.02) or value
	value = vm.f32(value + vm.f32(0.01))
	value_2 = effect.GetRand(6.2831855) or value_2
	value_3 = effect.GetRand(5.0) or value_3
	value_3 = vm.f32(value_3 + 5.0)
	var7 = vm.f32(arg1 + vm.f32(vm.sin(value_2) * value_3))
	var8 = arg2
	var9 = vm.f32(arg3 + vm.f32(vm.cos(value_2) * value_3))
	do
		local out1, out2, out3 = effect.CopyVector(arg4, arg5, arg6)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var10, var11, var12, 5.0)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, var7, var8, var9)
	effect.SptSetColor(arg0, 128.0, 128.0, 128.0, 8.0)
	effect.SptSetScale(arg0, 1.0, 1.0, 1.0)
	effect.SptSetVeloPos(arg0, var10, var11, var12)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 3.0)
	effect.SptSetAccPos(arg0, 0.0, -0.05, 0.0)
	effect.SptSetVeloRotz(arg0, value)
	effect.SptSetVeloScl(arg0, 0.04, 0.04)
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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local color_w: f32 = 0
	local value: f32 = 0
	local var14: s32 = 0
	local user_id: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local pos_y_3: f32 = 0
	local pos_y_4: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = 0.0
	var17 = effect.SptAssignSprite_2(600) or var17
	if var17 == 0 then
		return
	end
	effect.SptSetTexname("Shigu_breath")
	effect.SptInitSprite(0, 600)
	effect.SptSetAlphab(0, 2, 600)
	effect.SptSetUvSize(0, 0.0, 0.0, 128.0, 128.0, 600)
	effect.SptSetPutSize(0, 32.0, 32.0, 600)
	effect.SptSetDrawFlag(0, 0, 600)
	effect.SptSetPos(0, 0.0, -50.0, 0.0, 600)
	effect.SptSetAccPos(0, 0.0, -0.005, 0.0, 600)
	user_id = effect.GetUserId() or user_id
	effect.GetValue(0)
	value = effect.GetValueFloat(1) or value
	var16 = 0
	while true do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "sakana")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "ef_null")
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = effect.SubVector(var3, var4, var5, pos_x, pos_y, pos_z)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var14 = 0
		while var14 < 600 do
			var17 = effect.SptGetDrawFlag(var14) or var17
			if var17 ~= 0 then
				do
					local _, out2, _ = effect.SptGetPos(var14)
					pos_y_3 = out2 or pos_y_3
				end
				do
					local _, out2, _ = effect.ScnGetChrPos(user_id)
					pos_y_4 = out2 or pos_y_4
				end
				pos_y_4 = vm.f32(pos_y_4 - value)
				if pos_y_3 < vm.f32(pos_y_4 + 2.0) then
					pos_y_3 = vm.f32(pos_y_3 * vm.f32(-0.7))
					pos_y_3 = vm.f32(0.7)
					effect.SptSetVeloPos(var14, 0.0, pos_y_3, 0.0)
				end
				do
					local _, _, _, out4 = effect.SptGetColor(var14)
					color_w = out4 or color_w
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var14, 0)
				end
				if color_w >= 96.0 then
					effect.SptSetColor(var14, 128.0, 128.0, 128.0, 31.0)
					effect.SptSetVeloCol(var14, 0.0, 0.0, 0.0, -1.2)
				end
			end
			var14 = var14 + 1
		end
		var14 = 0
		while var14 < 2 do
			value_4 = 0.0
			value_3 = 0.0
			value_4 = effect.GetRand(5.0) or value_4
			value_3 = effect.GetRand(6.2831855) or value_3
			value_4 = vm.f32(value_4 + 12.0)
			helper_110(
				var16,
				pos_x,
				pos_y,
				pos_z,
				vm.f32(var3 + vm.f32(vm.sin(value_3) * value_4)),
				var4,
				vm.f32(var5 + vm.f32(vm.cos(value_3) * value_4))
			)
			var16 = var16 + 1
			if var16 >= 600 then
				var16 = 0
			end
			var14 = var14 + 1
		end
		var17 = effect.GetValue(3) or var17
		if var17 == 1 then
			break
		else
			effect.ScnGetChrFrmPos(user_id, "ef_null")
			vm.wait()
		end
	end
	effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -1.4, 600)
	effect.SptSetVeloPos(0, 0.0, -0.5, 0.0, 600)
	effect.SptSetVeloScl(0, -0.01, -0.01, -0.01, 600)
	var14 = 0
	while var14 < 90 do
		vm.wait()
		var14 = var14 + 1
	end
end

--- Ends an effect.
function script.on_finish()
	effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -0.2, 600)
	effect.SptSetVeloPos(0, 0.0, 0.0, 0.0, 600)
	effect.SptSetVeloScl(0, 0.0, 0.0, 0.0, 600)
	for var0 = 0, 89 do
		vm.wait()
	end
end

return script
