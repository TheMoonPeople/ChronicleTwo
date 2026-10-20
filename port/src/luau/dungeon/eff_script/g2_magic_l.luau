--!strict
-- dungeon/eff_script/g2_magic_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local value: f32 = 0
	local var3: f32 = 0
	local rot_y: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local work_vect2_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: s32 = 0
	local var23: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var27: s32 = 0
	local value_2: s32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var32: s32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	local var46: s32 = 0
	user_id = effect.GetUserId() or user_id
	target_id = effect.GetTargetId() or target_id
	target_id = 0
	value = 0.0
	value = effect.GetValueFloat(0) or value
	var3 = vm.f32(8.0 + vm.f32(4.0 * value))
	do
		local out1, out2, out3 = effect.ScnGetChrPos(user_id)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	rot_y = effect.ScnGetChrRot_2(user_id) or rot_y
	do
		local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var14 = out1 or var14
		var15 = out2 or var15
		work_vect2_z = out3 or work_vect2_z
	end
	var14 = 0.0
	var15 = 0.0
	work_vect2_z = 0.0
	var20 = vm.f32(0.4)
	var20 = effect.DistVector2(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2) or var20
	var20 = vm.f32(vm.f32(0.4) - vm.f32(vm.f32(vm.fdiv(vm.f32(0.4), var20)) * 10))
	var14 = effect.GetRand(vm.f32(-3.1415927) * var20) or var14
	var15 = effect.GetRand(vm.f32(3.1415927) * var20) or var15
	var15 = vm.f32(vm.f32(var15 - vm.f32(0.5235988)) + rot_y)
	var15 = effect.AngleLimit(var15) or var15
	work_vect2_z = 0.0
	do
		local out1, out2, out3 = effect.GetDirVector(var14, var15, work_vect2_z)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.NormalVector(var17, var18, var19)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var17, var18, var19, var3)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var22 = effect.SptAssignSprite_2(52) or var22
	if var22 == 0 then
		return
	end
	effect.SptSetTexname("c02flame")
	effect.SptInitSprite(0, 52)
	effect.SptSetDrawFlag(0, 1, 52)
	effect.SptSetAlphab(0, 2, 52)
	effect.SptSetPutSize(0, 10.0, 10.0, 52)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 52)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 52)
	var23 = 4
	var27 = 0
	while var27 < 45 do
		if var27 == 5 then
			value_2 = effect.GetValue(1) or value_2
			effect.ColprimCreate("火弾２", 1)
			effect.ColprimSetDamage(value_2)
		end
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var11, var12, var13, var17, var18, var19)
			var11 = out1 or var11
			var12 = out2 or var12
			var13 = out3 or var13
		end
		do
			local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, _ = effect.GetRefRot_9(var11, var12, var13, pos_x_2, pos_y_2, pos_z_2)
			var29 = out1 or var29
			var30 = out2 or var30
		end
		var32 = effect.AngleCmp(var15, var30, 3.1415927) or var32
		if var32 == 0 then
			var29 = vm.f32(var29 - var14)
			var29 = effect.AngleLimit(var29) or var29
			var29 = vm.f32(var29 / 6.0)
			var14 = vm.f32(var14 + var29)
			var14 = effect.AngleLimit(var14) or var14
			var30 = vm.f32(var30 - var15)
			var30 = effect.AngleLimit(var30) or var30
			var30 = vm.f32(var30 / 6.0)
			var15 = vm.f32(var15 + var30)
			var15 = effect.AngleLimit(var15) or var15
		end
		do
			local out1, out2, out3 = effect.GetDirVector(var14, var15, work_vect2_z)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var17, var18, var19, var3)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = effect.CopyVector(vector_x, vector_y, vector_z)
			var33 = out1 or var33
			var34 = out2 or var34
			var35 = out3 or var35
		end
		do
			local out1, out2, out3 = effect.SubVector(var33, var34, var35, var11, var12, var13)
			var33 = out1 or var33
			var34 = out2 or var34
			var35 = out3 or var35
		end
		do
			local out1, out2, out3 = effect.DivVector(var33, var34, var35, 2)
			var33 = out1 or var33
			var34 = out2 or var34
			var35 = out3 or var35
		end
		effect.SptSetUvSize(0, 0.0, 64.0, 64.0, 64.0, 4)
		effect.SptVanSetPos(0, var36, var37, var38, -var33, -var34, -var35, 0.0, 0.0, 0.0, 4)
		effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.SptColorConv(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.SptVanSetScl(0, 1.5 + vm.f32(1.5 * value), 1.5 + vm.f32(1.5 * value), 0.1, 0.1, 0.0, 0.0, 4)
		effect.SptSetAlphab(var23, 2, 2)
		effect.SptSetUvSize(var23, 0.0, 0.0, 64.0, 64.0, 2)
		effect.SptVanSetPos(var23, var36, var37, var38, var33, var34, var35, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var23, 128.0, 128.0, 128.0, 128.0, 2)
		effect.SptColorConv(var23, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var23, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		effect.SptSetAlphab(var23 + 2, 3, 2)
		effect.SptSetUvSize(var23 + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.ScaleVector(var33, var34, var35, 2.0)
			var33 = out1 or var33
			var34 = out2 or var34
			var35 = out3 or var35
		end
		do
			local out1, out2, out3 = effect.AddVector(var36, var37, var38, var33, var34, var35)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		effect.SptVanSetPos(var23 + 2, var36, var37, var38, var33, var34, var35, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var23 + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.SptColorConv(var23 + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var23 + 2, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		for var39 = 0, 3 do
			value_3 = effect.GetRand(3.1415927) or value_3
			value_3 = vm.f32(vm.f32(value_3 + 2.0) + vm.f32(2.0 * value))
			effect.SptScaleConv(var23 + var39, value_3, value_3, 4.0)
			value_3 = effect.GetRand(6.2831855) or value_3
			value_3 = vm.f32(value_3 - vm.f32(3.1415927))
			effect.SptSetRotz(var23 + var39, value_3)
			value_3 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_4 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_5 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_5
			value_5 = vm.f32(value_5 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			effect.SptSetVeloPos(var23 + var39, value_3, value_4, value_5)
		end
		var23 = var23 + 4
		if var23 >= 52 then
			var23 = 4
		end
		do
			local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var11, var12, var13)
			var46 = out4 or var46
		end
		if var46 >= 0 then
			effect.EsCreate_1("ギル２魔法Ｈ")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			effect.EsSetValueFloat(0, value)
			break
		else
			if var27 > 10 then
				effect.ColprimSetCoord(var11, var12, var13, 10.0)
				var46 = effect.ColprimGetHitcnt() or var46
				if var46 > 0 then
					effect.EsCreate_1("ギル２魔法Ｈ")
					effect.EsSetVect1(vector_x, vector_y, vector_z)
					effect.EsSetValueFloat(0, value)
					break
				end
			end
			var27 = var27 + 1
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
	var27 = 0
	while var27 < 20 do
		var27 = var27 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
