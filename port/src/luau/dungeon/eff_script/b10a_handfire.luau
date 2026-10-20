--!strict
-- dungeon/eff_script/b10a_handfire.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_110(arg0: s32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	effect.GetUserId()
	value = 0.0
	value_2 = 0.0
	value_3 = vm.f32(1.2)
	value = effect.GetRand(6.2831855) or value
	value_2 = effect.GetRand(1.0) or value_2
	value_3 = effect.GetRand(0.5) or value_3
	value_3 = vm.f32(value_3 + vm.f32(0.8))
	value_2 = vm.f32(value_2 + 5.0)
	x = 0.0
	y = value_2
	z = 0.0
	do
		local out1, out2, out3 = effect.NormalVector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = effect.ScaleVector(x, y, z, value_3)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	value = effect.GetRand(6.2831855) or value
	value_2 = effect.GetRand(5.0) or value_2
	value_2 = vm.f32(value_2 + 3.0)
	var4 = vm.f32(arg1 + vm.f32(vm.sin(value) * value_2))
	var5 = arg2
	var6 = vm.f32(arg3 + vm.f32(vm.cos(value) * value_2))
	y = vm.f32(y + 1.0)
	do
		local out1, out2, out3 = effect.ScaleVector(x, y, z, value_3)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, var4, var5 - 7.0, var6)
	effect.SptSetScale(arg0, 1.0, 1.0)
	effect.SptSetColor(arg0, 128.0, 128.0, 128.0, 0.0)
	effect.SptSetRotz(arg0, 0.25)
	effect.SptSetVeloPos(arg0, x, y, z)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 4.0)
	effect.SptSetVeloScl(arg0, -0.07, -0.07)
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
	local scale_x: f32 = 0
	local color_w: f32 = 0
	local user_id: s32 = 0
	local var22: s32 = 0
	local var24: s32 = 0
	var22 = 0
	var22 = effect.SptAssignSprite_2(160) or var22
	if var22 == 0 then
		return
	end
	effect.SptSetTexname("b10a_handfire")
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	effect.GetWorkVect2()
	user_id = effect.GetUserId() or user_id
	effect.SptInitSprite(0, 160)
	effect.SptSetAlphab(0, 2, 160)
	effect.SptSetUvSize(0, 0.0, 0.0, 128.0, 128.0, 160)
	effect.SptSetPutSize(0, 32.0, 32.0, 160)
	effect.SptSetDrawFlag(0, 0, 160)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 160)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 160)
	while true do
		for var21 = 0, 159 do
			do
				local out1, _ = effect.SptGetScale(var21)
				scale_x = out1 or scale_x
			end
			do
				local _, _, _, out4 = effect.SptGetColor(var21)
				color_w = out4 or color_w
			end
			if color_w > 64.0 then
				effect.SptSetColor(var21, 128.0, 128.0, 128.0, 16.0)
				effect.SptSetVeloCol(var21, 128.0, 128.0, 128.0, -1.2)
			end
			if color_w <= 0.0 or scale_x < 0.0 then
				effect.SptSetDrawFlag(var21, 0)
			end
		end
		for var26 = 0, 3 do
			if vm.imod(var24, 2) == 0 then
				do
					local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol_r")
					var0 = out1 or var0
					var1 = out2 or var1
					var2 = out3 or var2
				end
			end
			if vm.imod(var24, 2) == 1 then
				do
					local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol_l")
					var0 = out1 or var0
					var1 = out2 or var1
					var2 = out3 or var2
				end
			end
			helper_110(var24, var0, var1, var2)
			var24 = var24 + 1
			if var24 >= 160 then
				var24 = 0
			end
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
