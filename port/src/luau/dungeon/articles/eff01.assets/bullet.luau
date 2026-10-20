--!strict
-- dungeon/articles/eff01.assets/bullet.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
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
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: s32 = 0
	var19 = 0
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
	effect.SptSetTexname("effect00")
	effect.SptAssignSprite_1(16)
	effect.SptInitSprite(0, 16)
	effect.SptSetAlphab(0, 2, 16)
	effect.SptSetDrawFlag(0, 1, 16)
	effect.SptSetPutSize(0, 1.0, 1.0, 16)
	effect.SptSetUvSize(0, 32.0, 80.0, 16.0, 16.0, 16)
	var20 = 0
	while var20 < 60 do
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.CopyVector(-var6, -var7, -var8)
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
		do
			local out1, out2, out3 = effect.ScaleVector(var15, var16, var17, 0.5)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.IntersectionPoint_14(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
			var12 = out4 or var12
			var13 = out5 or var13
			var14 = out6 or var14
			var21 = out7 or var21
		end
		if var21 >= 0 then
			do
				local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			effect.SptVanSetPos(0, var0, var1, var2, var15, var16, var17, 0.0, 0.0, 0.0, 16)
			effect.SptVanSetCol(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
			var18 = effect.DistVector(var6, var7, var8) or var18
			do
				local out1, out2, out3 = effect.CopyVector(var12, var13, var14)
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
				local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, var18 / 2.0)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			break
		else
			effect.SptVanSetPos(0, var0, var1, var2, var15, var16, var17, 0.0, 0.0, 0.0, 16)
			effect.SptVanSetCol(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		end
		effect.ColprimSetCoord(vector_x, vector_y, vector_z, var0, var1, var2, 1.0)
		var21 = effect.ColprimGetHitcnt() or var21
		if var21 > 0 then
			var19 = 1
			break
		else
			var20 = var20 + 1
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
	if var20 >= 60 or var19 == 1 then
		return
	end
	var18 = 128.0
	vm.wait()
	var20 = 0
	while var20 < 6 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.CopyVector(-var6, -var7, -var8)
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
		do
			local out1, out2, out3 = effect.ScaleVector(var15, var16, var17, 0.5)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		effect.SptVanSetPos(0, var0, var1, var2, var15, var16, var17, 0.0, 0.0, 0.0, 16)
		effect.SptVanSetCol(0, var18, var18, var18, var18, 0.0, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		var18 = vm.f32(var18 - vm.f32(21.333334))
		var20 = var20 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
