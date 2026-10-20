--!strict
-- dungeon/eff_script/e219ex_fire_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: f32 = 0
	local var16: s32 = 0
	local value_2: s32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	value_2 = 0
	value = 0.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	value_2 = effect.GetValue(0) or value_2
	value = effect.GetValueFloat(1) or value
	effect.GetValue(2)
	do
		local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, value)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetMotion("火炎弾ループ", -1, 4)
	effect.ChrSetScale(1.2, 1.2, 1.2)
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var16 = 0
	while var16 < 90 do
		if var16 == 4 then
			effect.ColprimCreate("ドラゴン火弾")
			effect.ColprimSetDamage(value_2)
		end
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
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch, yaw, var5)
		if var16 > 4 then
			effect.ColprimSetCoord(var0, var1, var2, 12.0)
		end
		var19 = effect.ColprimGetHitcnt() or var19
		if var19 > 0 then
			effect.EsCreate_1("ドラゴン火弾Ｈ")
			effect.EsSetVect1(var0, var1, var2)
			effect.EsSetValue(0, value_2)
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
				effect.EsCreate_1("ドラゴン火弾Ｈ")
				effect.EsSetVect1(var20, var21, var22)
				effect.EsSetValue(0, value_2)
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

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
