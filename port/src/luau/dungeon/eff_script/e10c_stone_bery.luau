--!strict
-- dungeon/eff_script/e10c_stone_bery.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local revers_vec_x: f32 = 0
	local revers_vec_y: f32 = 0
	local revers_vec_z: f32 = 0
	local var18: s32 = 0
	local value: s32 = 0
	local reversed: s32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var25: s32 = 0
	local var29: s32 = 0
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
	value = effect.GetValue(0) or value
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
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 8.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(var3, var4, var5)
	effect.ChrSetMotion("ループ")
	effect.ChrSetShow(1, 1, 0.1)
	effect.ColprimCreate("石化攻撃")
	effect.ColprimSetDamage(value)
	var18 = 0
	while var18 < 90 do
		var21 = vm.f32(vm.f32(0.5 * vm.cos(0.0)) * var18)
		var22 = vm.f32(
			vm.f32(vm.f32(0.5 * vm.sin(0.0)) * var18) - vm.f32(vm.f32(vm.f32(vm.f32(0.005) * var18) * var18) / 2)
		)
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var23, var11, var21)
			var9 = out1 or var9
			var23 = out2 or var23
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, out3 = effect.ScaleVector(var23, var10, vm.bits_float(var25) :: number, var22)
			var23 = out1 or var23
			var10 = out2 or var10
			var25 = vm.float_bits(out3) or var25
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
		effect.ColprimSetCoord(var0, var1, var2, 9.0)
		do
			local out1, out2, out3, out4 = effect.ColprimGetRevcnt()
			reversed = out1 or reversed
			revers_vec_x = out2 or revers_vec_x
			revers_vec_y = out3 or revers_vec_y
			revers_vec_z = out4 or revers_vec_z
		end
		if reversed > 0 then
			effect.EsCreate_1("ガードエフェクトＡ")
			effect.EsSetVect1(var0, var1, var2)
			break
		else
			var25 = effect.ColprimGetHitcnt() or var25
			if var25 > 0 then
				break
			else
				do
					local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var25 = out4 or var25
				end
				if var25 >= 0 then
					break
				else
					vm.wait()
					var18 = var18 + 1
				end
			end
		end
	end
	effect.ColprimDelete(-1)
	if reversed > 0 then
		if revers_vec_x == 0.0 and revers_vec_y == 0.0 and revers_vec_z == 0.0 then
			print("reverse zero vector-----------\n")
			reversed = 0
		end
	end
	vm.wait()
	if reversed > 0 then
		effect.ColprimCreate("石化攻撃", 0)
		effect.ColprimSetDamage(value)
		do
			local out1, out2, out3 = effect.CopyVector(revers_vec_x, revers_vec_y, revers_vec_z)
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
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 10.0)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		var18 = 0
		while var18 < 60 do
			do
				local out1, out2, out3 = effect.ChrGetPos()
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
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
			effect.ColprimSetCoord(var0, var1, var2, 5.0)
			var29 = effect.ColprimGetHitcnt() or var29
			if var29 > 0 then
				break
			else
				do
					local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var29 = out4 or var29
				end
				if var29 >= 0 then
					break
				else
					do
						local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
						vector_x = out1 or vector_x
						vector_y = out2 or vector_y
						vector_z = out3 or vector_z
					end
					vm.wait()
					var18 = var18 + 1
				end
			end
		end
		effect.ColprimDelete(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
