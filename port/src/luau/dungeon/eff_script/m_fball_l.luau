--!strict
-- dungeon/eff_script/m_fball_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var15: s32 = 0
	local value: s32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
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
	value = effect.GetValue(0) or value
	do
		local out1, out2, out3 = effect.GetDirVector(work_vect2_x, work_vect2_y, work_vect2_z)
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
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 8.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.ChrSetMotion("火炎弾ループ")
	effect.ChrSetScale(1.5, 1.5, 1.5)
	effect.ChrSetShow(1, 1, 0.1)
	var15 = 0
	while var15 < 10 do
		vm.wait()
		var15 = var15 + 1
	end
	effect.ColprimCreate("火弾")
	effect.ColprimSetDamage(value)
	var15 = 0
	while var15 < 60 do
		var17 = vm.f32(vm.f32(1.5 * vm.cos(0.0)) * var15)
		var18 = vm.f32(
			vm.f32(vm.f32(1.5 * vm.sin(0.0)) * var15) - vm.f32(vm.f32(vm.f32(vm.f32(0.025) * var15) * var15) / 2)
		)
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var19, var11, var17)
			var9 = out1 or var9
			var19 = out2 or var19
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, out3 = effect.ScaleVector(var19, var10, vm.bits_float(var21) :: number, var18)
			var19 = out1 or var19
			var10 = out2 or var10
			var21 = vm.float_bits(out3) or var21
		end
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ColprimSetCoord(var0, var1, var2, 8.400001)
		var21 = effect.ColprimGetHitcnt() or var21
		if var21 > 0 then
			effect.EsCreate_1("火炎弾ヒット")
			effect.EsSetVect1(var0, var1, var2)
			effect.EsSetVect2(work_vect2_x, work_vect2_y, work_vect2_z)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
				var21 = out4 or var21
			end
			if var21 >= 0 then
				do
					local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				do
					local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 10.0)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				do
					local out1, out2, out3 = effect.CopyVector(var22, var23, var24)
					var25 = out1 or var25
					var26 = out2 or var26
					var27 = out3 or var27
				end
				do
					local out1, out2, out3 = effect.AddVector(var25, var26, var27, -var9, -var10, -var11)
					var25 = out1 or var25
					var26 = out2 or var26
					var27 = out3 or var27
				end
				effect.EsCreate_1("火炎弾ヒット")
				effect.EsSetVect1(var25, var26, var27)
				effect.EsSetVect2(work_vect2_x, work_vect2_y, work_vect2_z)
				break
			else
				vm.wait()
				var15 = var15 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
