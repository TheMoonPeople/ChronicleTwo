--!strict
-- dungeon/eff_script/robo_missile.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var16: f32 = 0
	local var17: f32 = 0
	local target_id: s32 = 0
	local var19: s32 = 0
	local var21: s32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var27: f32 = 0
	local var28: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	var19 = 0
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
	effect.GetValue(0)
	target_id = effect.GetTargetId() or target_id
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(var3, var4, var5)
	var24 = effect.SptAssignSprite_2(42) or var24
	if var24 == 0 then
		return
	end
	effect.SptSetTexname("Shell_kemuri")
	effect.SptInitSprite(0, 42)
	effect.SptSetDrawFlag(0, 1, 42)
	effect.SptSetAlphab(0, 2, 42)
	effect.SptSetPutSize(0, 24.0, 24.0, 42)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 42)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 42)
	while true do
		do
			local out1, out2, out3 = effect.ChrGetDirVector()
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
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 48.0)
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
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
			var23 = out4 or var23
		end
		if var23 >= 0 then
			effect.EsCreate_1("爆発")
			effect.EsSetVect1(var15, var16, var17)
			effect.EsSetValue(0, 0)
			break
		else
			if target_id >= 0 then
				do
					local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local out1, out2, out3 = effect.ChrGetRefRot(pos_x, pos_y, pos_z)
					pitch = out1 or pitch
					yaw = out2 or yaw
					var27 = out3 or var27
				end
				do
					local out1, out2, out3 = effect.ChrGetRot()
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				var28 = effect.AngleCmp(var4, yaw, 0.76) or var28
				if var28 == 0 then
					do
						local out1, out2, out3 = effect.CopyVector(pitch, yaw, var27)
						var3 = out1 or var3
						var4 = out2 or var4
						var5 = out3 or var5
					end
				end
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(var3, var4, var5, 12)
			if var19 == 1 then
				for var22 = 0, 9 do
					value_3 = effect.GetRand(20.0) or value_3
					value_2 = effect.GetRand(3.1415927) or value_2
					var31 = vm.f32(var0 + vm.f32(vm.sin(value_2) * value_3))
					var32 = var1
					var33 = vm.f32(var2 + vm.f32(vm.cos(value_2) * value_3))
					value_3 = effect.GetRand(0.2) or value_3
					value_3 = vm.f32(value_3 + vm.f32(0.2))
					effect.SptSetPos(32 + var22, var31, var32, var33)
					effect.SptSetColor(32 + var22, 128.0, 128.0, 128.0, 32.0)
					effect.SptSetVeloPos(32 + var22, 0.0, value_3, 0.0)
					effect.SptSetVeloCol(32 + var22, 0.0, 0.0, 0.0, -1.0)
					effect.SptSetVeloRotz(32 + var22, 0.02)
				end
			end
			if vm.imod(var19, 2) == 0 then
				effect.SptSetPos(var21, var0, var1, var2)
				effect.SptSetVeloPos(var21, 0.0, 0.5, 0.0)
				effect.SptSetColor(var21, 128.0, 128.0, 128.0, 32.0)
				effect.SptSetVeloCol(var21, 0.0, 0.0, 0.0, -1.0)
				effect.SptSetVeloRotz(var21, 0.02)
				var21 = var21 + 1
				if var21 >= 42 then
					var21 = 0
				end
			end
			effect.ColprimSetCoord(vector_x, vector_y, vector_z, var0, var1, var2, 2.0)
			var23 = effect.ColprimGetHitcnt() or var23
			if var23 > 0 then
				effect.EsCreate_1("爆発")
				effect.EsSetVect1(var0, var1, var2)
				effect.EsSetValue(0, 0)
				break
			elseif var19 >= 90 then
				break
			else
				var19 = var19 + 1
				vm.wait()
			end
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
