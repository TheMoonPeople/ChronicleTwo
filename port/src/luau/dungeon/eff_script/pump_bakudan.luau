--!strict
-- dungeon/eff_script/pump_bakudan.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
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
	local work_vect2_y: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_z: f32 = 0
	local var21: s32 = 0
	local var22: s32 = 0
	local value: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	var22 = effect.GetTargetId() or var22
	value = effect.GetValue(0) or value
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(var22)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = effect.GetDirVector(rot_x, rot_y, rot_z)
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
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, work_vect2_x)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(rot_x, rot_y, rot_z)
	effect.ChrSetScale(1.5, 1.5, 1.5)
	effect.ChrSetShow(1, 1, 1.0)
	effect.ColprimCreate("吹っ飛び攻撃")
	effect.ColprimSetDamage(value)
	do
		local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	work_vect2_y = vm.f32(vm.f32(work_vect2_y / 180.0) * vm.f32(3.1415927))
	rot_x = vm.cos(work_vect2_y)
	rot_y = vm.sin(work_vect2_y)
	work_vect2_z = -work_vect2_z
	var21 = 0
	while var21 < 60 do
		do
			local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		var16 = vm.f32(work_vect2_x * var21)
		var15 = vm.f32(var16 * rot_x)
		var16 = vm.f32(vm.f32(var16 * rot_y) + vm.f32(vm.f32(vm.f32(work_vect2_z * var21) * var21) * 0.5))
		do
			local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		var10 = 1.0
		var9 = vm.f32(var9 * var15)
		var11 = vm.f32(var11 * var15)
		var10 = vm.f32(var10 * var16)
		do
			local out1, out2, out3 = effect.AddVector(var9, var10, var11, work_vect1_x, work_vect1_y, work_vect1_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3, out4 = effect.IntersectionPoint_11(4, var12, var13, var14, var9, var10, var11)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
			var22 = out4 or var22
		end
		if var22 >= 0 then
			effect.ColprimDelete(-1)
			effect.EsCreate_1("Ｍ小爆発")
			effect.EsSetVect1(var12, var13 + 1.0, var14)
			break
		else
			effect.ChrSetPos(var9, var10, var11)
			effect.ColprimSetCoord(var9, var10, var11, 10.0)
			vm.wait()
			var21 = var21 + 1
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
