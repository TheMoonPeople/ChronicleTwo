--!strict
-- dungeon/eff_script/mg_fball2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_110(arg0: any, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	for var15 = 0, 7 do
		value = 1.0
		value_2 = 1.0
		value_3 = 1.0
		value = effect.GetRand(360.0) or value
		value_2 = effect.GetRand(15.0) or value_2
		value_3 = effect.GetRand(8.0) or value_3
		value_4 = effect.GetRand(400.0) or value_4
		effect.GetRand(800.0)
		value = vm.f32(vm.f32(value / 180.0) * vm.f32(3.1415927))
		value_4 = vm.f32(value_4 / 100.0)
		value_4 = vm.f32(value_4 + 2.0)
		var7 = vm.f32(vm.f32(vm.f32(arg1 + arg4) / 2.0) + vm.f32(vm.sin(value) * value_2))
		var8 = vm.f32(vm.f32(vm.f32(vm.f32(arg2 + arg5) / 2.0) - value_3) + 4.0)
		var9 = vm.f32(vm.f32(vm.f32(arg3 + arg6) / 2.0) + vm.f32(vm.cos(value) * value_2))
		effect.SptSetDrawFlag(vm.wrap(var15 + arg0), 1)
		effect.SptSetColor(vm.wrap(var15 + arg0), 128.0, 128.0, 128.0, 128.0)
		effect.SptSetScale(vm.wrap(var15 + arg0), value_4, value_4)
		effect.SptSetPos(vm.wrap(var15 + arg0), var7, var8, var9)
		effect.SptSetVeloCol(vm.wrap(var15 + arg0), 0.0, 0.0, 0.0, -7.0)
	end
	arg0 = vm.wrap(arg0 + 8)
	if arg0 >= 160 then
		arg0 = 0
	end
	return arg0
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
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var28: s32 = 0
	local var29: s32 = 0
	local target_id: s32 = 0
	local value: s32 = 0
	local var32: any = 0
	local var34: s32 = 0
	local value_2: s32 = 0
	local color_w: f32 = 0
	var34 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	target_id = effect.GetTargetId() or target_id
	value_2 = effect.GetValue(1) or value_2
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y, pos_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.SubVector(var9, var10, var11, var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	value = effect.GetValue(0) or value
	effect.ColprimCreate("Ｍギル火柱１")
	effect.ColprimSetDamage(value)
	effect.ChrSetScale(2.0, 2.0, 2.0)
	var26 = vm.f32(1.5707964)
	var24 = vm.cos(var26)
	var25 = vm.sin(var26)
	var12 = vm.f32(vm.f32(var9 * var24) + vm.f32(var11 * var25))
	var13 = var10
	var14 = vm.f32(vm.f32(var9 * -var25) + vm.f32(var11 * var24))
	do
		local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	work_vect2_z = vm.f32(vm.f32(work_vect2_z / 180.0) * vm.f32(3.1415927))
	var24 = vm.cos(work_vect2_z)
	var25 = vm.sin(work_vect2_z)
	var26 = vm.f32(1.0 - var24)
	var15 = vm.f32(
		vm.f32(
			vm.f32(var12 * vm.f32(var24 + vm.f32(vm.f32(var26 * var9) * var9)))
				+ vm.f32(var13 * vm.f32(vm.f32(vm.f32(var26 * var9) * var10) + vm.f32(var11 * var25)))
		) + vm.f32(var14 * vm.f32(vm.f32(vm.f32(var26 * var9) * var11) + vm.f32(var10 * var25)))
	)
	var16 = vm.f32(
		vm.f32(
			vm.f32(var12 * vm.f32(vm.f32(vm.f32(var26 * var9) * var10) - vm.f32(var11 * var25)))
				+ vm.f32(var13 * vm.f32(var24 + vm.f32(vm.f32(var26 * var10) * var10)))
		) + vm.f32(var14 * vm.f32(vm.f32(vm.f32(var26 * var10) * var11) + vm.f32(var9 * var25)))
	)
	var17 = vm.f32(
		vm.f32(
			vm.f32(var12 * vm.f32(vm.f32(vm.f32(var26 * var11) * var9) + vm.f32(var10 * var25)))
				+ vm.f32(var13 * vm.f32(vm.f32(vm.f32(var26 * var10) * var11) - vm.f32(var9 * var25)))
		) + vm.f32(var14 * vm.f32(var24 + vm.f32(vm.f32(var26 * var11) * var11)))
	)
	do
		local out1, out2, out3 = effect.CopyVector(var15, var16, var17)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var29 = effect.SptAssignSprite_2(160) or var29
	if var29 == 0 then
		return
	end
	effect.SptSetTexname("hinoko2")
	effect.SptInitSprite(0, 160)
	effect.SptSetAlphab(0, 2, 160)
	effect.SptSetUvSize(0, 64.0, 64.0, 128.0, 128.0, 160)
	effect.SptSetPutSize(0, 1.2, 1.2, 160)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 160)
	effect.SptSetDrawFlag(0, 0, 160)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 160)
	var32 = 0
	var28 = 0
	while var28 < 90 do
		if target_id == 1 then
			do
				local out1, out2, out3 = effect.ScnGetChrPos(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
		end
		var9 = vm.f32(pos_x - var0)
		var10 = vm.f32(pos_y - var1)
		var11 = vm.f32(pos_z - var2)
		do
			local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, work_vect2_y * 100.0)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var12, var13, var14, vm.f32(1.0 - work_vect2_y) * 100.0)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.AddVector(var12, var13, var14, var9, var10, var11)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.CopyVector(var12, var13, var14)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, work_vect2_x)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		if var28 > 10 then
			do
				local out1, out2, out3, out4 = effect.IntersectionPoint_11(4, var18, var19, var20, var0, var1, var2)
				var15 = out1 or var15
				var16 = out2 or var16
				var17 = out3 or var17
				var29 = out4 or var29
			end
			if var29 >= 0 and var28 <= 82 then
				do
					local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				effect.ColprimDelete(-1)
				effect.EsCreate_1("Ｍギル火柱１")
				effect.EsSetVect1(var15, var16, var17)
				effect.EsSetVect2(var18, var19, var20)
				effect.EsSetValue(0, value)
				effect.EsSetValue(1, value_2)
				break
			end
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(var15, var16, var17)
		effect.ColprimSetCoord(var6, var7, var8, 10.0)
		for var33 = 0, 159 do
			var29 = effect.SptGetDrawFlag(var33) or var29
			if var29 == 1 then
				do
					local out1, out2, out3, out4 = effect.SptGetColor(var33)
					var15 = out1 or var15
					var16 = out2 or var16
					var17 = out3 or var17
					color_w = out4 or color_w
				end
				if color_w <= 0.0 then
					effect.SptSetDrawFlag(var33, 0)
				else
					do
						local out1, out2, out3 = effect.SptGetPos(var33)
						var15 = out1 or var15
						var16 = out2 or var16
						var17 = out3 or var17
					end
					var16 = vm.f32(var16 - vm.f32(-0.8))
					effect.SptSetPos(var33, var15, var16, var17)
				end
			end
		end
		var32 = helper_110(var32, var0, var1, var2, var18, var19, var20)
		if var28 == 77 then
			effect.ChrSetShow(0, 1, -10.0)
			var34 = 1
			effect.ColprimDelete(-1)
		end
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		var28 = var28 + 1
		vm.wait()
	end
	var28 = 0
	while var28 < 16 do
		vm.wait()
		var28 = var28 + 1
	end
	if var34 == 0 then
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
