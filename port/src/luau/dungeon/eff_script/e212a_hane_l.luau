--!strict
-- dungeon/eff_script/e212a_hane_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var20: s32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	value_2 = 0
	value = 0.0
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
	do
		local out1, out2, out3 = effect.GetDirVector(var3, var4, var5)
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
	var10 = vm.f32(-0.6)
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, value)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetMotion("ティグリフ羽弾（ループ）", 4)
	effect.ColprimCreate("中攻撃")
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
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(var3, var4, var5)
		effect.ColprimSetCoord(var0, var1, var2, 8.0)
		var20 = effect.ColprimGetHitcnt() or var20
		if var20 > 0 then
			var19 = 0
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
				var20 = out4 or var20
			end
			if var20 >= 0 then
				effect.EsCreate_1("ティグ羽根Ｈ")
				effect.EsSetVect1(var21, var22, var23)
				var19 = 1
				effect.ChrSetPos(var21, var22, var23)
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
	if var19 ~= 0 then
		effect.ChrSetShow(0, 1, -0.9)
		var16 = 0
		while var16 < 30 do
			vm.wait()
			var16 = var16 + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
