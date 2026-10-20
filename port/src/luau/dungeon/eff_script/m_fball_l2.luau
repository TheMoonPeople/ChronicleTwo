--!strict
-- dungeon/eff_script/m_fball_l2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var29: s32 = 0
	local value_5: s32 = 0
	local value_6: s32 = 0
	local var33: s32 = 0
	local target_id: s32 = 0
	local value_7: s32 = 0
	local value_8: s32 = 0
	local var37: s32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	value_7 = 0
	var33 = 1
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	value_4 = 0.0
	value_5 = 0
	value_6 = 0
	target_id = 0
	effect.GetUserId()
	target_id = effect.GetTargetId() or target_id
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	value_5 = effect.GetValue(0) or value_5
	value = effect.GetValueFloat(1) or value
	value_3 = effect.GetValueFloat(2) or value_3
	value_4 = effect.GetValueFloat(3) or value_4
	value_6 = effect.GetValue(4) or value_6
	value_2 = effect.GetValueFloat(5) or value_2
	value_7 = effect.GetValue(6) or value_7
	value_8 = effect.GetValue(7) or value_8
	effect.ChrSetPos(var3, var4, var5)
	effect.ColprimCreate("火弾")
	effect.ColprimSetDamage(value_5)
	effect.ChrSetScale(1.5, 1.5, 1.5)
	if value_6 ~= 0 then
		do
			local out1, out2, out3 = effect.ScnGetChrPos(target_id)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
	else
		do
			local out1, out2, out3 = effect.GetWorkVect2()
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	do
		local out1, out2, out3 = effect.SubVector(var15, var16, var17, var3, var4, var5)
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	do
		local out1, out2, out3 = effect.NormalVector(var15, var16, var17)
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	var18 = vm.f32(vm.f32(var15 * vm.cos(vm.f32(-1.5707964))) + vm.f32(var17 * vm.sin(vm.f32(-1.5707964))))
	var19 = var16
	var20 = vm.f32(vm.f32(var15 * -vm.sin(vm.f32(-1.5707964))) + vm.f32(var17 * vm.cos(vm.f32(-1.5707964))))
	var22 = vm.sin(value_4)
	var21 = vm.cos(value_4)
	var23 = vm.f32(1.0 - var21)
	var0 = vm.f32(
		vm.f32(
			vm.f32(var18 * vm.f32(var21 + vm.f32(vm.f32(var23 * var15) * var15)))
				+ vm.f32(var19 * vm.f32(vm.f32(vm.f32(var23 * var15) * var16) + vm.f32(var17 * var22)))
		) + vm.f32(var20 * vm.f32(vm.f32(vm.f32(var23 * var15) * var17) + vm.f32(var16 * var22)))
	)
	var1 = vm.f32(
		vm.f32(
			vm.f32(var18 * vm.f32(vm.f32(vm.f32(var23 * var15) * var16) - vm.f32(var17 * var22)))
				+ vm.f32(var19 * vm.f32(var21 + vm.f32(vm.f32(var23 * var16) * var16)))
		) + vm.f32(var20 * vm.f32(vm.f32(vm.f32(var23 * var16) * var17) + vm.f32(var15 * var22)))
	)
	var2 = vm.f32(
		vm.f32(
			vm.f32(var18 * vm.f32(vm.f32(vm.f32(var23 * var17) * var15) + vm.f32(var16 * var22)))
				+ vm.f32(var19 * vm.f32(vm.f32(vm.f32(var23 * var16) * var17) - vm.f32(var15 * var22)))
		) + vm.f32(var20 * vm.f32(var21 + vm.f32(vm.f32(var23 * var17) * var17)))
	)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.NormalVector(var18, var19, var20)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.ScnGetChrPos(target_id)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var1 = vm.f32(var1 + 10.0)
	do
		local out1, out2, out3 = effect.CopyVector(var3, var4, var5)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var29 = 0
	while var29 < value_7 do
		value = vm.f32(value + value_2)
		if value_6 ~= 0 then
			do
				local out1, out2, out3 = effect.ScnGetChrPos(target_id)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
		end
		if var29 < value_8 then
			var15 = vm.f32(var0 - var3)
			var16 = vm.f32(var1 - var4)
			var17 = vm.f32(var2 - var5)
			do
				local out1, out2, out3 = effect.NormalVector(var15, var16, var17)
				var15 = out1 or var15
				var16 = out2 or var16
				var17 = out3 or var17
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var15, var16, var17, value_3)
				var15 = out1 or var15
				var16 = out2 or var16
				var17 = out3 or var17
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var18, var19, var20, 1.0 - value_3)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.AddVector(var18, var19, var20, var15, var16, var17)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.NormalVector(var18, var19, var20)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.CopyVector(var18, var19, var20)
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
		else
			do
				local out1, out2, out3 = effect.CopyVector(var18, var19, var20)
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
		end
		do
			local out1, out2, out3 = effect.AddVector(var3, var4, var5, var6, var7, var8)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var3, var4, var5)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var11 = out3 or var11
		end
		var37 = effect.ColprimGetHitcnt() or var37
		if var37 > 0 then
			var33 = 0
			effect.EsCreate_1("火弾Ｈ")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			break
		else
			if var29 > 10 then
				do
					local out1, out2, out3, out4 =
						effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var3, var4, var5)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
					var37 = out4 or var37
				end
				if var37 >= 0 then
					var33 = 0
					effect.ChrSetPos(var38, var39, var40)
					effect.EsCreate_1("火弾Ｈ")
					effect.EsSetVect1(var38, var39, var40)
					break
				end
			end
			effect.ChrSetPos(var3, var4, var5)
			effect.ChrSetRot(pitch, yaw, var11)
			effect.ColprimSetCoord(var3, var4, var5, 8.400001)
			do
				local out1, out2, out3 = effect.CopyVector(var3, var4, var5)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vm.wait()
			var29 = var29 + 1
		end
	end
	effect.ColprimDelete(-1)
	if var33 ~= 0 then
		var29 = 0
		effect.ChrSetShow(0, 1, -0.5)
		while var29 < 30 do
			vm.wait()
			var29 = var29 + 1
		end
	end
	effect.ChrSetShow(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
