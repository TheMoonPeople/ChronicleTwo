--!strict
-- dungeon/eff_script/m_dokueki_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var20: s32 = 0
	local value: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: s32 = 0
	effect.GetUserId()
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
	do
		local out1, out2, out3 = effect.GetDirVector(var3, var4, var5)
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
		local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 3.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(var3, var4, var5)
	effect.ChrSetMotion("ループ")
	effect.ChrSetScale(1.5, 1.5, 1.5)
	effect.ChrSetShow(1, 1, 0.1)
	var1 = vm.f32(var1 - 1.0)
	var23 = vm.f32(0.3)
	var22 = 5.0
	var20 = 0
	while var20 < 100 do
		if var20 == 5 then
			effect.ColprimCreate("毒液２")
			effect.ColprimSetDamage(value)
		end
		var24 = var10
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, var22)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		var10 = vm.f32(var24 + var23)
		if var10 > vm.f32(2.2) then
			var23 = vm.f32(-0.65)
		end
		var22 = vm.f32(var22 - vm.f32(0.005))
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
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var25 = out1 or var25
			var26 = out2 or var26
			var27 = out3 or var27
			var28 = out4 or var28
		end
		if var28 >= 0 then
			effect.EsCreate_1("毒液H")
			effect.EsSetVect1(var25, var26 + 1.0, var27)
			break
		else
			if var20 > 5 then
				var28 = effect.ColprimGetHitcnt() or var28
				if var28 > 0 then
					effect.EsCreate_1("毒液H")
					effect.EsSetVect1(var0, var1, var2)
					break
				end
			end
			effect.ChrSetPos(var0, var1, var2)
			effect.ChrSetRot(var3, var4, var5)
			if var20 > 5 then
				effect.ColprimSetCoord(var0, var1, var2, 6.0)
			end
			vm.wait()
			var20 = var20 + 1
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
