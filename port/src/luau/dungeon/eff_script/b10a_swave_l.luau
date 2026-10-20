--!strict
-- dungeon/eff_script/b10a_swave_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var23: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var26: s32 = 0
	local value_3: s32 = 0
	local value_4: f32 = 0
	local value_5: s32 = 0
	local value_6: s32 = 0
	local value_7: s32 = 0
	local var36: s32 = 0
	var16 = 8.0
	value_6 = 0
	value_3 = 0
	value_4 = 0.0
	value_5 = 0
	value_6 = 0
	value_2 = 0.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	value_3 = effect.GetValue(0) or value_3
	value_4 = effect.GetValueFloat(1) or value_4
	value_5 = effect.GetValue(2) or value_5
	value_6 = effect.GetValue(3) or value_6
	value_2 = effect.GetValueFloat(4) or value_2
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetMotion("ループ")
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	var13 = 0.0
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.SubVector(var17, var18, var19, var0, var1, var2)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.NormalVector(var17, var18, var19)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var23 = effect.DistVector2(var12, var13, var14, var0, var1, var2) or var23
	if var23 < 150.0 then
		value_4 = 1.0
	else
		if value_5 == 0 then
			do
				local out1, out2, out3 = effect.CopyVector(var17, var18, var19)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			var13 = 0.0
			do
				local out1, out2, out3 = effect.ScaleVector(var12, var13, var14, 2000.0)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
		end
		if value_6 == 0 then
			var23 = 0.0
			value = 0.0
			value = effect.GetRand(1.5707964) or value
			var23 = effect.GetRand(50.0) or var23
			var23 = vm.f32(var23 + 100.0)
			value_7 = 0
			value_7 = effect.GetRandInt(100) or value_7
			if value_7 < 50 then
				value = vm.f32(value * -1.0)
			end
			do
				local out1, out2, out3 = effect.ScnGetChrPos(0)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			var12 = vm.f32(var12 + vm.f32(vm.sin(value) * var23))
			var13 = 0.0
			var14 = vm.f32(var14 + vm.f32(vm.cos(value) * var23))
		end
	end
	effect.ColprimCreate("グリソニック")
	effect.ColprimSetDamage(value_3)
	x = vm.f32(vm.f32(var17 * vm.cos(value_2)) + vm.f32(var19 * vm.sin(value_2)))
	y = var18
	z = vm.f32(vm.f32(var17 * -vm.sin(value_2)) + vm.f32(var19 * vm.cos(value_2)))
	do
		local out1, out2, out3 = effect.NormalVector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var26 = 0
	while var26 < 25 do
		if value_5 ~= 0 then
			if var26 < 13 and var26 > 6 then
				do
					local out1, out2, out3 = effect.ScnGetChrPos(0)
					var12 = out1 or var12
					var13 = out2 or var13
					var14 = out3 or var14
				end
				var13 = 0.0
			end
		end
		if var26 < 18 then
			var16 = vm.f32(var16 + 1.0)
			var17 = vm.f32(var12 - var0)
			var18 = vm.f32(var13 - var1)
			var19 = vm.f32(var14 - var2)
			do
				local out1, out2, out3 = effect.NormalVector(var17, var18, var19)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var17, var18, var19, value_4)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = effect.ScaleVector(x, y, z, 1.0 - value_4)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.AddVector(x, y, z, var17, var18, var19)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.NormalVector(x, y, z)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.CopyVector(x, y, z)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, var16)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(var3, var4, var5)
		effect.ColprimSetCoord(var0, var1, var2, 15.0)
		var36 = effect.ColprimGetHitcnt() or var36
		if var36 > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var36 = out4 or var36
			end
			if var36 >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				if var16 > 50.0 then
					break
				else
					vm.wait()
					var26 = var26 + 1
				end
			end
		end
	end
	effect.ColprimDelete(-1)
	effect.ChrSetShow(0, 1, -0.9)
	var26 = 0
	while var26 < 15 do
		vm.wait()
		var26 = var26 + 1
	end
	effect.ChrSetShow(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
