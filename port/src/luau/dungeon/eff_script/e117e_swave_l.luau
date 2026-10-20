--!strict
-- dungeon/eff_script/e117e_swave_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: s32 = 0
	local value: s32 = 0
	local var18: s32 = 0
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
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(var6, var7, var8)
	effect.ChrSetMotion("ループ")
	do
		local out1, out2, out3 = effect.GetDirVector(var6, var7, var8)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var12, var13, var14, 15.0)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	effect.ColprimCreate("インフェ攻撃")
	effect.ColprimSetDamage(value)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var16 = 0
	while var16 < 115 do
		vm.wait()
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var12, var13, var14)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ColprimSetCoord(var0, var1, var2, 25.0)
		var18 = effect.ColprimGetHitcnt() or var18
		if var18 > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var18 = out4 or var18
			end
			if var18 >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				var16 = var16 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
	effect.ChrSetShow(0, 1, -0.9)
	var16 = 0
	while var16 < 15 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var12, var13, var14)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.ChrSetPos(var0, var1, var2)
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

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
