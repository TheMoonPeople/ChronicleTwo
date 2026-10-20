--!strict
-- dungeon/eff_script/m_fwball_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: s32 = 0
	local var18: s32 = 0
	local value_4: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var24: s32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	value = 0.0
	value_3 = 0
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
	value_4 = effect.GetValue(0) or value_4
	value_3 = effect.GetValue(1) or value_3
	value = effect.GetValueFloat(2) or value
	value_2 = effect.GetValueFloat(3) or value_2
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
	effect.ChrSetMotion("風弾ループ")
	effect.ChrSetShow(1, 1, 0.1)
	var18 = 0
	while var18 < value_3 do
		vm.wait()
		var18 = var18 + 1
	end
	effect.ColprimCreate("弱攻撃")
	effect.ColprimSetDamage(value_4)
	var18 = 0
	while var18 < 60 do
		var20 = vm.f32(vm.f32(value * vm.cos(0.0)) * var18)
		var21 =
			vm.f32(vm.f32(vm.f32(value * vm.sin(0.0)) * var18) - vm.f32(vm.f32(vm.f32(value_2 * var18) * var18) / 2))
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var22, var11, var20)
			var9 = out1 or var9
			var22 = out2 or var22
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, out3 = effect.ScaleVector(var22, var10, vm.bits_float(var24) :: number, var21)
			var22 = out1 or var22
			var10 = out2 or var10
			var24 = vm.float_bits(out3) or var24
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
		effect.ColprimSetCoord(var0, var1, var2, 10.0)
		var24 = effect.ColprimGetHitcnt() or var24
		if var24 > 0 then
			effect.ColprimDelete(-1)
			effect.EsCreate_1("風弾Ｈ")
			effect.EsSetVect1(var0, var1, var2)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
				var24 = out4 or var24
			end
			if var24 >= 0 then
				effect.ColprimDelete(-1)
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
					local out1, out2, out3 = effect.CopyVector(var25, var26, var27)
					var28 = out1 or var28
					var29 = out2 or var29
					var30 = out3 or var30
				end
				do
					local out1, out2, out3 = effect.AddVector(var28, var29, var30, -var9, -var10, -var11)
					var28 = out1 or var28
					var29 = out2 or var29
					var30 = out3 or var30
				end
				effect.EsCreate_1("風弾Ｈ")
				effect.EsSetVect1(var28, var29, var30)
				break
			else
				vm.wait()
				var18 = var18 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
