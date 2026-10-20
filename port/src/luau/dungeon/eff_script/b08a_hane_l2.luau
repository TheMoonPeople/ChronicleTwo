--!strict
-- dungeon/eff_script/b08a_hane_l2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var28: s32 = 0
	local var29: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local hit_num: s32 = 0
	value = 0
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
	value = effect.GetValue(1) or value
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
	value_2 = effect.GetValue(0) or value_2
	effect.ColprimCreate("グリ羽根")
	effect.ColprimSetDamage(value_2)
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
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var28 = 0
	while var28 < 90 do
		if value == 1 then
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
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var15 = out1 or var15
				var16 = out2 or var16
				var17 = out3 or var17
				var29 = out4 or var29
			end
			if var29 >= 0 and var28 <= 82 then
				effect.EsCreate_1("グリ羽根Ｈ")
				effect.EsSetVect1(var15, var16, var17)
				break
			end
		end
		hit_num = effect.ColprimGetHitcnt() or hit_num
		if hit_num > 0 then
			effect.EsCreate_1("グリ羽根Ｈ")
			effect.EsSetVect1(var0, var1, var2)
			break
		else
			do
				local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
				var15 = out1 or var15
				var16 = out2 or var16
				var17 = out3 or var17
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(var15, var16, var17)
			effect.ColprimSetCoord(var0, var1, var2, 12.0)
			if var28 == 77 then
				effect.ChrSetShow(0, 1, -10.0)
				effect.ColprimDelete(-1)
			end
			do
				local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			var28 = var28 + 1
			vm.wait()
		end
	end
	var28 = 0
	effect.ChrSetShow(0, 1, -0.1)
	while var28 < 15 do
		vm.wait()
		var28 = var28 + 1
	end
	effect.ChrSetShow(0, 0)
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
