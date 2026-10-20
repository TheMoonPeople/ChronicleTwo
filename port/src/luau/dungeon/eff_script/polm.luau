--!strict
-- dungeon/eff_script/polm.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var15: f32 = 0
	local target_id: s32 = 0
	local var17: s32 = 0
	local value: s32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var25: f32 = 0
	local var26: s32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	var17 = 0
	var15 = 16.0
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
	target_id = effect.GetTargetId() or target_id
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(var3, var4, var5)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	effect.MonSePlay(10)
	while true do
		do
			local out1, out2, out3 = effect.ChrGetDirVector()
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, var15)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
			var19 = out4 or var19
		end
		if var19 >= 0 then
			effect.EsCreate_1("ロボミサイル爆発")
			effect.EsSetVect1(var20, var21, var22)
			effect.EsSetValue(0, value)
			break
		else
			do
				local out1, out2, out3 = effect.ScnGetChrPos(target_id)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_y = vm.f32(pos_y + 25.0)
			do
				local out1, out2, out3 = effect.ChrGetRefRot(pos_x, pos_y, pos_z)
				pitch = out1 or pitch
				yaw = out2 or yaw
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = effect.ChrGetRot()
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			var26 = effect.AngleCmp(var4, yaw, 0.76) or var26
			if var26 == 0 then
				do
					local out1, out2, out3 = effect.CopyVector(pitch, yaw, var25)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(var3, var4, var5, 6)
			do
				local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			var27 = effect.DistVector2(var0, var1, var2, pos_x, pos_y, pos_z) or var27
			if var27 <= 24.0 then
				effect.EsCreate_1("ロボミサイル爆発")
				effect.EsSetVect1(var0, var1, var2)
				effect.EsSetValue(0, value)
				break
			else
				if vm.imod(var17, 3) == 0 then
					do
						local out1, out2, out3 = effect.ChrGetDirVector()
						var28 = out1 or var28
						var29 = out2 or var29
						var30 = out3 or var30
					end
					var28 = -var28
					var29 = -var29
					var30 = -var30
					do
						local out1, out2, out3 = effect.ScaleVector(var28, var29, var30, 40.0)
						var28 = out1 or var28
						var29 = out2 or var29
						var30 = out3 or var30
					end
					effect.EsCreate_1("ロボミサイル煙")
					effect.EsSetVect1(var0 + var28, var1 + var29, var2 + var30)
				end
				if var17 >= 150 then
					effect.EsCreate_1("ロボミサイル爆発")
					effect.EsSetVect1(var0, var1, var2)
					effect.EsSetValue(0, value)
					break
				else
					var17 = var17 + 1
					vm.wait()
				end
			end
		end
	end
	effect.MonSeStop(10)
	effect.MonSePlay(11)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
