--!strict
-- dungeon/eff_script/kizyu.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var25: s32 = 0
	local var26: s32 = 0
	var22 = 0
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
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	effect.ChrSetScale(0.25, 0.25, 0.25)
	effect.ColprimCreate("機銃")
	effect.ColprimSetDamage(value)
	var25 = 0
	while var25 < 60 do
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
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.IntersectionPoint_14(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
			var12 = out4 or var12
			var13 = out5 or var13
			var14 = out6 or var14
			var26 = out7 or var26
		end
		if var26 >= 0 then
			do
				local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.GetRefRot_9(vector_x, vector_y, vector_z, var0, var1, var2)
				pitch = out1 or pitch
				yaw = out2 or yaw
				var21 = out3 or var21
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(pitch, yaw, var21)
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
			effect.MonSePlay2(value_2, 5)
			break
		else
			do
				local out1, out2, out3 = effect.GetRefRot_9(vector_x, vector_y, vector_z, var0, var1, var2)
				pitch = out1 or pitch
				yaw = out2 or yaw
				var21 = out3 or var21
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(pitch, yaw, var21)
		end
		effect.ColprimSetCoord(vector_x, vector_y, vector_z, var0, var1, var2, 1.0)
		var26 = effect.ColprimGetHitcnt() or var26
		if var26 > 0 then
			var22 = 1
			break
		else
			var25 = var25 + 1
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
	if var25 >= 90 or var22 == 1 then
		return
	end
	var18 = 128.0
	vm.wait()
	var25 = 0
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	while var25 < 6 do
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
			local out1, out2, out3 = effect.GetRefRot_9(vector_x, vector_y, vector_z, var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var21 = out3 or var21
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch, yaw, var21)
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		var18 = vm.f32(var18 - vm.f32(21.333334))
		var25 = var25 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
