--!strict
-- dungeon/eff_script/m_cball_l2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: f32 = 0
	local revers_vec_x: f32 = 0
	local revers_vec_y: f32 = 0
	local revers_vec_z: f32 = 0
	local var16: s32 = 0
	local value_2: s32 = 0
	local reversed: s32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
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
	value_2 = effect.GetValue(0) or value_2
	value = effect.GetValueFloat(1) or value
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetMotion("冷気弾ループ", -1, 4)
	effect.ChrSetScale(1.5, 1.5, 1.5)
	effect.ChrSetShow(1, 1, 0.1)
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, value)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	effect.ColprimCreate("氷弾２")
	effect.ColprimSetDamage(value_2)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var16 = 0
	while var16 < 90 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch, yaw, var5)
		effect.ColprimSetCoord(var0, var1, var2, 8.400001)
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
			var19 = effect.ColprimGetHitcnt() or var19
			if var19 > 0 then
				effect.EsCreate_1("氷弾Ｈ")
				effect.EsSetVect1(var0, var1, var2)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
					var19 = out4 or var19
				end
				if var19 >= 0 then
					effect.EsCreate_1("氷弾Ｈ")
					effect.EsSetVect1(var20, var21, var22)
					break
				else
					do
						local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
						vector_x = out1 or vector_x
						vector_y = out2 or vector_y
						vector_z = out3 or vector_z
					end
					vm.wait()
					var16 = var16 + 1
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
		effect.ColprimCreate("氷弾２", 0)
		effect.ColprimSetDamage(value_2)
		do
			local out1, out2, out3 = effect.CopyVector(revers_vec_x, revers_vec_y, revers_vec_z)
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
			local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, 7.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var16 = 0
		while var16 < 60 do
			do
				local out1, out2, out3 = effect.ChrGetPos()
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
				pitch = out1 or pitch
				yaw = out2 or yaw
				var5 = out3 or var5
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(pitch, yaw, var5)
			effect.ColprimSetCoord(var0, var1, var2, 6.0)
			var23 = effect.ColprimGetHitcnt() or var23
			if var23 > 0 then
				effect.EsCreate_1("氷弾Ｈ")
				effect.EsSetVect1(var0, var1, var2)
				effect.EsSetVect2(pitch, yaw, var5)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var24 = out1 or var24
					var25 = out2 or var25
					var26 = out3 or var26
					var23 = out4 or var23
				end
				if var23 >= 0 then
					effect.EsCreate_1("氷弾Ｈ")
					effect.EsSetVect1(var24, var25, var26)
					effect.EsSetVect2(pitch, yaw, var5)
					break
				else
					do
						local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
						vector_x = out1 or vector_x
						vector_y = out2 or vector_y
						vector_z = out3 or vector_z
					end
					vm.wait()
					var16 = var16 + 1
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
