--!strict
-- dungeon/eff_script/atora.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_110(arg0: any, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: f32 = 0
	value = effect.GetValueFloat(1) or value
	do
		local out1, out2, out3 = effect.ScnGetChrPos(value)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var4 = effect.DistVector2(arg1, arg2, arg3, pos_x, pos_y + 50.0, pos_z) or var4
	if var4 <= vm.f32(7.6) then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_334(arg0: s32, arg1: f32)
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: s32 = 0
	value = effect.GetValue(0) or value
	if value == 0 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 0.0, 0.0)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
	end
	if value == 1 then
		do
			local out1, out2, out3 = effect.CopyVector(0.0, 0.0, 255.0)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
	end
	if value == 2 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 255.0, 0.0)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
	end
	effect.SptSetColor(arg0, vector_x, vector_y, vector_z, arg1)
end

--- Helper function.
local function helper_678(arg0: s32, arg1: s32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	do
		local out1, out2, out3 = effect.ScnGetChrPos(arg1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	var6 = vm.f32(var6 + 50.0)
	do
		local out1, out2, out3 = effect.SubVector(var5, var6, var7, arg2, arg3, arg4)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = effect.NormalVector(var5, var6, var7)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var5, var6, var7, 3.8)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	effect.SptSetDrawFlag(arg0, 1)
	effect.SptSetPos(arg0, arg2, arg3, arg4)
	helper_334(arg0, 0.0)
	effect.SptSetVeloPos(arg0, var5, var6, var7)
	effect.SptSetVeloCol(arg0, 0.0, 0.0, 0.0, 3.0)
	effect.SptSetScale(arg0, 1.0, 1.0, 1.0)
	effect.SptSetVeloScl(arg0, 0.02, 0.02)
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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local color_w: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local user_id: s32 = 0
	local value: s32 = 0
	local var22: s32 = 0
	local value_2: s32 = 0
	local var24: s32 = 0
	value_2 = 0
	value = 0
	var22 = 0
	var22 = effect.SptAssignSprite_2(16) or var22
	if var22 == 0 then
		return
	end
	effect.SptSetTexname("b08_ex")
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	user_id = effect.GetUserId() or user_id
	value_2 = effect.GetValue(0) or value_2
	value = effect.GetValue(1) or value
	var22 = effect.GetValue(7) or var22
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	if value_2 == 0 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 0.0, 0.0)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
	end
	if value_2 == 1 then
		do
			local out1, out2, out3 = effect.CopyVector(0.0, 0.0, 255.0)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
	end
	if value_2 == 2 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 255.0, 0.0)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
	end
	color_w = 12.0
	effect.SptInitSprite(0, 15)
	effect.SptSetAlphab(0, 2, 15)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 15)
	effect.SptSetPutSize(0, 24.0, 24.0, 15)
	effect.SptSetDrawFlag(0, 0, 15)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 15)
	effect.SptSetColor(0, var12, var13, var14, color_w, 15)
	effect.SptInitSprite(15, 1)
	effect.SptSetAlphab(15, 2, 1)
	effect.SptSetUvSize(15, 0.0, 0.0, 64.0, 64.0, 1)
	effect.SptSetPutSize(15, 48.0, 48.0, 1)
	effect.SptSetDrawFlag(15, 1, 1)
	effect.SptSetPos(15, 0.0, 0.0, 0.0, 1)
	effect.SptSetAccPos(15, 0.0, 0.0, 0.0, 1)
	effect.SptSetColor(15, var12, var13, var14, color_w, 1)
	var24 = 0
	while true do
		vm.wait()
		do
			local out1, out2, out3 = effect.ScnGetChrPos(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.SptSetPos(15, pos_x, pos_y, pos_z)
		value = effect.GetValue(1) or value
		for var21 = 0, 14 do
			var22 = effect.SptGetDrawFlag(var21) or var22
			if var22 == 1 then
				do
					local out1, out2, out3 = effect.SptGetPos(var21)
					var0 = out1 or var0
					var1 = out2 or var1
					var2 = out3 or var2
				end
				do
					local out1, out2, out3, out4 = effect.SptGetColor(var21)
					var12 = out1 or var12
					var13 = out2 or var13
					var14 = out3 or var14
					color_w = out4 or color_w
				end
				if helper_110(value, var0, var1, var2) ~= 0 then
					effect.SptSetDrawFlag(var21, 0)
				end
				if color_w > 64.0 then
					helper_334(var21, 64.0)
					effect.SptSetVeloCol(var21, 0.0, 0.0, 0.0, -2.5)
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var21, 0)
				end
			end
		end
		var22 = effect.GetValue(7) or var22
		if var22 == 0 then
			continue
		end
		helper_678(var24, value, pos_x, pos_y, pos_z)
		var24 = var24 + 1
		if var24 >= 15 then
			var24 = 0
		end
	end
end

--- Ends an effect.
function script.on_finish()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local color_w: f32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var10: s32 = 0
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	effect.SptSetVeloPos(0, 0.0, 0.0, 0.0, 15)
	effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -1.5, 15)
	do
		local out1, out2, out3 = effect.ScnGetChrPos(value_2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 55.0)
	if value == 0 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 0.0, 0.0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
	end
	if value == 1 then
		do
			local out1, out2, out3 = effect.CopyVector(0.0, 0.0, 255.0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
	end
	if value == 2 then
		do
			local out1, out2, out3 = effect.CopyVector(255.0, 255.0, 0.0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
	end
	effect.SptSetPos(15, pos_x, pos_y, pos_z)
	effect.SptSetColor(15, var3, var4, var5, 0.0)
	effect.SptSetVeloCol(15, 0.0, 0.0, 0.0, 2.0)
	effect.SptSetScale(15, 1.0, 1.0, 1.0)
	effect.SptSetVeloScl(15, 0.1, 0.0)
	for var9 = 0, 89 do
		var10 = 0
		while var10 < 15 do
			do
				local out1, out2, out3, out4 = effect.SptGetColor(var10)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
				color_w = out4 or color_w
			end
			if color_w <= 0.0 then
				effect.SptSetDrawFlag(var10, 0)
			end
			var10 = var10 + 1
			if var9 == 45 then
				effect.SptSetVeloScl(15, -0.1, 0.8)
			end
			do
				local out1, out2, out3, out4 = effect.SptGetColor(15)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
				color_w = out4 or color_w
			end
			if color_w > 64.0 then
				effect.SptSetColor(15, var3, var4, var5, 64.0)
				effect.SptSetVeloCol(15, 0.0, 0.0, 0.0, -2.0)
			end
		end
		vm.wait()
	end
end

return script
