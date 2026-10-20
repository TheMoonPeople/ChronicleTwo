--!strict
-- dungeon/eff_script/mg_fball1.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local value: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: s32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.GetValue(0) or value
	var25 = effect.GetTargetId() or var25
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(var25)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var25 = effect.GetUserId() or var25
	do
		local out1, out2, out3 = effect.GetDirVector(var3, var4, var5)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, work_vect2_x)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(var3, var4, var5)
	effect.ChrSetMotion("火炎弾ループ")
	effect.ChrSetShow(1, 1, 0.1)
	effect.ColprimCreate("吹っ飛び攻撃")
	effect.ColprimSetDamage(value)
	do
		local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	var21 = vm.cos(work_vect2_y)
	var20 = vm.sin(work_vect2_y)
	work_vect2_z = vm.f32(vm.f32(work_vect2_z / 180.0) * vm.f32(3.1415927))
	var22 = vm.cos(work_vect2_z)
	var23 = vm.sin(work_vect2_z)
	var24 = vm.f32(1.0 - var22)
	var26 = 0
	while var26 < 60 do
		var32 = vm.f32(vm.f32(work_vect2_x * var21) * var26)
		var33 = vm.f32(vm.f32(vm.f32(work_vect2_x * var20) * var26) + vm.f32(vm.f32(vm.f32(-0.5 * var26) * var26) / 2))
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var34, var11, var32)
			var9 = out1 or var9
			var34 = out2 or var34
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, _ = effect.ScaleVector(var34, var10, 0, var33) -- retail: output 3 points past the frame, at the operand stack, so the value is lost
			var34 = out1 or var34
			var10 = out2 or var10
		end
		var28 = vm.f32(
			vm.f32(
				vm.f32(var9 * vm.f32(var22 + vm.f32(vm.f32(var24 * var6) * var6)))
					+ vm.f32(var10 * vm.f32(vm.f32(vm.f32(var24 * var6) * var7) + vm.f32(var8 * var23)))
			) + vm.f32(var11 * vm.f32(vm.f32(vm.f32(var24 * var6) * var8) + vm.f32(var7 * var23)))
		)
		var29 = vm.f32(
			vm.f32(
				vm.f32(var9 * vm.f32(vm.f32(vm.f32(var24 * var6) * var7) - vm.f32(var8 * var23)))
					+ vm.f32(var10 * vm.f32(var22 + vm.f32(vm.f32(var24 * var7) * var7)))
			) + vm.f32(var11 * vm.f32(vm.f32(vm.f32(var24 * var7) * var8) + vm.f32(var6 * var23)))
		)
		var30 = vm.f32(
			vm.f32(
				vm.f32(var9 * vm.f32(vm.f32(vm.f32(var24 * var8) * var6) + vm.f32(var7 * var23)))
					+ vm.f32(var10 * vm.f32(vm.f32(vm.f32(var24 * var7) * var8) - vm.f32(var6 * var23)))
			) + vm.f32(var11 * vm.f32(var22 + vm.f32(vm.f32(var24 * var8) * var8)))
		)
		do
			local out1, out2, out3 = effect.CopyVector(var28, var29, var30)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.AddVector(var9, var10, var11, work_vect1_x, work_vect1_y, work_vect1_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var9, var10, var11)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var9, var10, var11)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
			var31 = out4 or var31
		end
		if var31 >= 0 and var26 <= 52 then
			effect.ColprimDelete(-1)
			effect.EsCreate_1("Ｍギル火柱１")
			effect.EsSetVect1(var28, var29, var30)
			effect.EsSetVect2(var3, var4, var5)
			effect.EsSetValue(0, value)
			break
		else
			effect.ChrSetPos(var9, var10, var11)
			effect.ChrSetRot(var3, var4, var5)
			effect.ColprimSetCoord(var9, var10, var11, 10.0)
			var31 = effect.ColprimGetHitcnt() or var31
			if var31 > 0 then
				effect.ColprimDelete(-1)
				effect.EsCreate_1("Ｍギル火柱１")
				effect.EsSetVect1(var9, var10, var11)
				effect.EsSetVect2(var3, var4, var5)
				effect.EsSetValue(0, value)
				break
			else
				do
					local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var26 = var26 + 1
				if var26 == 47 then
					effect.ChrSetShow(0, 1, -10.0)
					effect.ColprimDelete(-1)
				end
			end
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
