--!strict
-- dungeon/eff_script/houdan.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
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
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	effect.ChrSetScale(0.5, 0.5, 0.5)
	do
		local out1, out2, out3 = effect.CopyVector(work_vect2_x, work_vect2_y, work_vect2_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.SubVector(var9, var10, var11, var0, var1, var2)
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
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 30.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var15 = effect.DistVector2(var0, var1, var2, work_vect2_x, work_vect2_y, work_vect2_z) or var15
	var14 = vm.f32(vm.f32(-1.1999999) + vm.f32(var15 * vm.f32(0.0004)))
	var15 = vm.f32(vm.f32(var15 / 30.0) + 1.0)
	var10 = vm.f32(
		vm.fdiv(
			vm.f32(vm.f32(vm.f32(work_vect2_y - var1) * 2.0) - vm.f32(vm.f32(var14 * var15) * var15)),
			vm.f32(var15 * 2.0)
		)
	)
	effect.ColprimCreate("円形チェック用")
	var16 = 0
	while var16 < 120 do
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var10 = vm.f32(var10 + var14)
		do
			local out1, out2, out3, out4 = effect.IntersectionPoint_11(4, var6, var7, var8, var0, var1, var2)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
			var17 = out4 or var17
		end
		if var17 >= 0 then
			do
				local out1, out2, out3 = effect.CopyVector(var18, var19, var20)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			break
		else
			effect.ColprimSetCoord(var0, var1, var2, 4.0)
			var17 = effect.ColprimGetHitcnt() or var17
			if var17 > 0 then
				do
					local out1, out2, out3 = effect.ColprimGetHitPos()
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
				break
			else
				effect.ChrSetPos(var0, var1, var2)
				var16 = var16 + 1
				vm.wait()
			end
		end
	end
	effect.ColprimDelete(-1)
	effect.EsCreate_1("Ｍ爆発大")
	effect.EsSetVect1(var6, var7, var8)
	effect.EsSetValue(0, value)
	effect.EsSetValue(1, value_2)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
