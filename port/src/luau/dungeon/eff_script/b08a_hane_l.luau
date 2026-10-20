--!strict
-- dungeon/eff_script/b08a_hane_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var12: s32 = 0
	local value: s32 = 0
	local value_2: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
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
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	value_2 = 0.0
	value_2 = effect.GetRand(10.0) or value_2
	do
		local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, 10.0 + value_2)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	effect.ChrSetPos(var0, var1, var2)
	effect.ColprimCreate("グリ羽根")
	effect.ColprimSetDamage(value)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var12 = 0
	while var12 < 90 do
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
		effect.ColprimSetCoord(var0, var1, var2, 8.0)
		var15 = effect.ColprimGetHitcnt() or var15
		if var15 > 0 then
			effect.EsCreate_1("グリ羽根Ｈ")
			effect.EsSetVect1(var0, var1, var2)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var16 = out1 or var16
				var17 = out2 or var17
				var18 = out3 or var18
				var15 = out4 or var15
			end
			if var15 >= 0 then
				effect.EsCreate_1("グリ羽根Ｈ")
				effect.EsSetVect1(var16, var17, var18)
				break
			else
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var12 = var12 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
	effect.ChrSetShow(0, 1, -0.1)
	var12 = 0
	while var12 < 30 do
		vm.wait()
		var12 = var12 + 1
	end
	effect.ChrSetShow(0, 0)
	effect.ChrSetPos(0.0, -100.0, 0.0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
