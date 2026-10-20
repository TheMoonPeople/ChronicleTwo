--!strict
-- dungeon/eff_script/mg_fball3.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var14: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local work_vect2_x: f32 = 0
	local var24: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var29: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
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
	value_3 = effect.GetValue(0) or value_3
	value = effect.GetValueFloat(1) or value
	value_2 = effect.GetValueFloat(2) or value_2
	value_4 = effect.GetValue(3) or value_4
	effect.ChrSetScale(2.0, 2.0, 2.0)
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y, pos_z)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.SubVector(var6, var7, var8, var0, var1, var2)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var7 = 0.0
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var21 = vm.cos(vm.f32(1.0471976))
	var22 = vm.sin(vm.f32(1.0471976))
	var9 = vm.f32(var6 * var21)
	var10 = vm.f32(1.0 * var22)
	var11 = vm.f32(var8 * var21)
	do
		local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, value_2 * 2.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var24 = 0
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y, pos_z)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	while var24 < vm.f32(15.0 + work_vect2_x) do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var14 = out3 or var14
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch, yaw, var14)
		if var24 > 1.0 then
			effect.EsCreate_1("Ｍギル火の粉")
			effect.EsSetVect1(var0, var1, var2)
			effect.EsSetVect2(vector_x, vector_y, vector_z)
		end
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		vm.wait()
		var24 = vm.f32(var24 + 1.0)
	end
	value_3 = effect.GetValue(0) or value_3
	effect.ColprimCreate("Ｍギル火柱１")
	effect.ColprimSetDamage(value_3)
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	var0 = vm.f32(vm.sin(work_vect2_y) * work_vect2_z)
	var2 = vm.f32(vm.cos(work_vect2_y) * work_vect2_z)
	pos_x = vm.f32(pos_x + var0)
	pos_z = vm.f32(pos_z + var2)
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y + 200.0, pos_z)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y, pos_z)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.SubVector(var6, var7, var8, pos_x, pos_y + 200.0, pos_z)
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
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 20.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var24 = 0
	while var24 < 60.0 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
			var29 = out4 or var29
		end
		if var29 >= 0 then
			effect.ColprimDelete(-1)
			effect.EsCreate_1("Ｍギル火柱１")
			effect.EsSetVect1(var18, var19, var20)
			effect.EsSetVect2(pitch, yaw, var14)
			effect.EsSetValue(0, value_3)
			effect.EsSetValue(1, value_4)
			break
		else
			do
				local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
				pitch = out1 or pitch
				yaw = out2 or yaw
				var14 = out3 or var14
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(pitch, yaw, var14)
			effect.ColprimSetCoord(var9, var10, var11, value)
			effect.EsCreate_1("Ｍギル火の粉")
			effect.EsSetVect1(var0, var1, var2)
			effect.EsSetVect2(vector_x, vector_y, vector_z)
			do
				local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vm.wait()
			var24 = vm.f32(var24 + 1.0)
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
