--!strict
-- dungeon/eff_script/mem_bullet.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local value: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	effect.GetUserId()
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	value = effect.GetValue(0) or value
	do
		local out1, out2, out3 = effect.ScaleVector(var8, var9, var10, 5.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	effect.ColprimCreate("鼻マシンガン")
	effect.ColprimSetDamage(value)
	effect.EsSetVect1(var2, var3, var4)
	var15 = 0
	while var15 < 150 do
		do
			local out1, out2, out3 = effect.CopyVector(var2, var3, var4)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var2, var3, var4, var8, var9, var10)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		do
			local out1, out2, out3 = effect.CopyVector(var8, var9, var10)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.NormalVector(var16, var17, var18)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.CopyVector(-var8, -var9, -var10)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.NormalVector(var16, var17, var18)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var16, var17, var18, 0.5)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		effect.ColprimSetCoord(var2, var3, var4, 4.0)
		effect.ChrSetPos(var2, var3, var4)
		var19 = effect.ColprimGetHitcnt() or var19
		if var19 > 0 then
			effect.EsCreate_1("メムイータ－弾Ｈ")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var2, var3, var4)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var19 = out4 or var19
			end
			if var19 >= 0 then
				effect.EsCreate_1("メムイータ－弾Ｈ")
				effect.EsSetVect1(var20, var21, var22)
				break
			else
				var15 = var15 + 1
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
