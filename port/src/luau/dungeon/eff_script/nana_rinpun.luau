--!strict
-- dungeon/eff_script/nana_rinpun.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local work_vect2_z: f32 = 0
	local value: s32 = 0
	local target_id: s32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local value_2: s32 = 0
	local var26: s32 = 0
	local var27: { f32 } = table.create(3, 0)
	local var30: { f32 } = table.create(3, 0)
	local value_3: f32 = 0
	local var34: f32 = 0
	var0 = 4.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var4 = out1 or var4
		var5 = out2 or var5
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.GetValue(0) or value
	target_id = effect.GetTargetId() or target_id
	effect.SptAssignSprite_1(30)
	effect.SptSetTexname("nana_rinpun")
	effect.SptInitSprite(0, 30)
	effect.SptSetAlphab(0, 2, 30)
	effect.SptSetDrawFlag(0, 1, 30)
	effect.SptSetPos(0, 0.0, -1000.0, 0.0, 30)
	effect.SptSetPutSize(0, 10.0, 10.0, 30)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 30)
	var15 = 0
	var14 = 0
	while var14 < 300 do
		do
			local out1, out2, out3 = effect.GetDirVector(var4, var5, work_vect2_z)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var16, var17, var18, var0)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = effect.AddVector(var1, var2, var3, var16, var17, var18)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = effect.ScnGetChrPos(target_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + 30.0)
		do
			local out1, out2, _ = effect.GetRefRot_9(var1, var2, var3, pos_x, pos_y, pos_z)
			var22 = out1 or var22
			var23 = out2 or var23
		end
		var22 = vm.f32(var22 - var4)
		var23 = vm.f32(var23 - var5)
		var22 = effect.AngleLimit(var22) or var22
		var23 = effect.AngleLimit(var23) or var23
		var22 = vm.f32(var22 / 30.0)
		var23 = vm.f32(var23 / 60.0)
		var4 = vm.f32(var4 + var22)
		var5 = vm.f32(var5 + var23)
		var4 = effect.AngleLimit(var4) or var4
		var5 = effect.AngleLimit(var5) or var5
		var26 = 0
		while var26 < 3 do
			var27[var26 + 1] = effect.GetRand(30.0) or var27[var26 + 1]
			var27[var26 + 1] = vm.f32(var27[var26 + 1] - 15.0)
			var26 = var26 + 1
		end
		var26 = 0
		while var26 < 3 do
			var30[var26 + 1] = effect.GetRand(30.0) or var30[var26 + 1]
			var30[var26 + 1] = vm.f32(var30[var26 + 1] - 15.0)
			var26 = var26 + 1
		end
		do
			local out1, out2, out3 = effect.SubVector(var30[1], var30[2], var30[3], var27[1], var27[2], var27[3])
			var30[1] = out1 or var30[1]
			var30[2] = out2 or var30[2]
			var30[3] = out3 or var30[3]
		end
		var34 = effect.DistVector(var30[1], var30[2], var30[3]) or var34
		do
			local out1, out2, out3 = effect.DivVector(var30[1], var30[2], var30[3], var34)
			var30[1] = out1 or var30[1]
			var30[2] = out2 or var30[2]
			var30[3] = out3 or var30[3]
		end
		do
			local out1, out2, out3 = effect.AddVector(var27[1], var27[2], var27[3], var1, var2, var3)
			var27[1] = out1 or var27[1]
			var27[2] = out2 or var27[2]
			var27[3] = out3 or var27[3]
		end
		effect.SptSetPos(var15, var27[1], var27[2], var27[3])
		value_2 = effect.GetRandInt(7) or value_2
		effect.SptSetUvSize(
			var15,
			vm.i32(vm.i32(vm.imod(value_2, 2) * 64) + 1),
			vm.i32(vm.i32(vm.idiv(value_2, 2) * 64) + 1),
			62.0,
			62.0
		)
		effect.SptSetColor(var15, 128.0, 128.0, 128.0, 0.0)
		value_3 = effect.GetRand(2.0) or value_3
		value_3 = vm.f32(1.0 - vm.f32(value_3 / 10.0))
		effect.SptSetScale(var15, value_3, value_3)
		effect.SptSetVeloPos(var15, var30[1], var30[2], var30[3])
		effect.SptSetVeloRotz(var15, 0.19634955)
		effect.SptSetVeloCol(var15, 0.0, 0.0, 0.0, 24.0)
		effect.SptSetAccCol(var15, 0.0, 0.0, 0.0, -1.8)
		var15 = var15 + 1
		if var15 >= 30 then
			var15 = 0
		end
		if vm.imod(var14, 6) == 0 then
			effect.ColprimDelete(-1)
			effect.GetUserId()
			effect.ColprimCreate("りんぷん")
			effect.ColprimSetDamage(value)
			effect.ColprimSetCoord(var1, var2, var3, 20.0)
		end
		var14 = var14 + 1
		vm.wait()
	end
	effect.ColprimDelete(-1)
	var14 = 0
	while var14 < 30 do
		var14 = var14 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
