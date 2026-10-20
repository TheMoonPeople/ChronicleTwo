--!strict
-- dungeon/eff_script/g_magic2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var4: f32 = 0
	local work_vect2_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local target_id: s32 = 0
	local user_id: s32 = 0
	local value: s32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var21: f32 = 0
	local var23: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		var4 = out2 or var4
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.GetValue(0) or value
	target_id = effect.GetTargetId() or target_id
	user_id = effect.GetUserId() or user_id
	var12 = 0
	while var12 < 10 do
		var12 = var12 + 1
		vm.wait()
	end
	effect.ChrSetMotion("ループ", -1, 4)
	effect.ChrSetShow(1, 1, 0.04)
	var12 = 0
	while var12 < 24 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "magic")
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.ChrSetPos(var0, var1, var2)
		var12 = var12 + 1
		vm.wait()
	end
	effect.ChrSetShow(0)
	effect.ColprimCreate("吹っ飛び弱")
	effect.ColprimSetDamage(value)
	var12 = 0
	while true do
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.GetDirVector(work_vect2_x, var4, work_vect2_z)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var13, var14, var15, 16.0)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var13, var14, var15)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var16 = effect.IntersectionPoint_8(0, vector_x, vector_y + 1.0, vector_z, var0, var1 + 1.0, var2) or var16
		if var16 >= 0 then
			break
		else
			do
				local out1, out2, out3 = effect.ScnGetChrPos(target_id)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local _, out2, _ = effect.GetRefRot_9(var0, var1, var2, pos_x, pos_y, pos_z)
				var21 = out2 or var21
			end
			var23 = effect.AngleCmp(var4, var21, 1.2) or var23
			if var23 == 0 then
				var21 = vm.f32(var21 - var4)
				var21 = effect.AngleLimit(var21) or var21
				var21 = vm.f32(var21 / 6.0)
				var4 = vm.f32(var4 + var21)
				var4 = effect.AngleLimit(var4) or var4
			end
			if vm.imod(var12, 2) == 0 then
				effect.EsCreate_1("ギル魔法サブ２")
				effect.EsSetVect1(var0, 2.5, var2)
			end
			effect.ColprimSetCoord(var0, var1, var2, 10.0)
			var12 = vm.i32(var12 + 1)
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
