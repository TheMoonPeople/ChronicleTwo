--!strict
-- dungeon/eff_script/c02flame.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var28: f32 = 0
	local var29: f32 = 0
	local var31: s32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var45: s32 = 0
	user_id = effect.GetUserId() or user_id
	target_id = effect.GetTargetId() or target_id
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
	if target_id <= -1 then
		pos_x_2 = vm.f32(vm.f32(vm.sin(rot_y) * 300.0) + pos_x)
		pos_y_2 = vm.f32(20.0 + pos_y)
		pos_z_2 = vm.f32(vm.f32(vm.cos(rot_y) * 300.0) + pos_z)
	else
		do
			local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
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
	if var14 == 0.0 and var15 == 0.0 and work_vect2_z == 0.0 then
		var20 = vm.f32(0.4)
		if target_id > 0 then
			var20 = effect.DistVector2(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2) or var20
			var20 = vm.f32(vm.f32(0.4) - vm.f32(vm.f32(vm.fdiv(vm.f32(0.4), var20)) * 10))
		end
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
	else
		do
			local out1, out2, out3 = effect.CopyVector(var14, var15, work_vect2_z)
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
	while var27 < 60 do
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
		if target_id >= 0 then
			do
				local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
		end
		do
			local out1, out2, _ = effect.GetRefRot_9(var11, var12, var13, pos_x_2, pos_y_2, pos_z_2)
			var28 = out1 or var28
			var29 = out2 or var29
		end
		var31 = effect.AngleCmp(var15, var29, 1.6) or var31
		if var31 == 0 then
			var28 = vm.f32(var28 - var14)
			var28 = effect.AngleLimit(var28) or var28
			var28 = vm.f32(var28 / 6.0)
			var14 = vm.f32(var14 + var28)
			var14 = effect.AngleLimit(var14) or var14
			var29 = vm.f32(var29 - var15)
			var29 = effect.AngleLimit(var29) or var29
			var29 = vm.f32(var29 / 6.0)
			var15 = vm.f32(var15 + var29)
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
			var35 = out1 or var35
			var36 = out2 or var36
			var37 = out3 or var37
		end
		do
			local out1, out2, out3 = effect.CopyVector(vector_x, vector_y, vector_z)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.SubVector(var32, var33, var34, var11, var12, var13)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.DivVector(var32, var33, var34, 2)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		effect.SptSetUvSize(0, 0.0, 64.0, 64.0, 64.0, 4)
		effect.SptVanSetPos(0, var35, var36, var37, -var32, -var33, -var34, 0.0, 0.0, 0.0, 4)
		effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.SptColorConv(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.SptVanSetScl(0, 1.5 + vm.f32(1.5 * value), 1.5 + vm.f32(1.5 * value), 0.1, 0.1, 0.0, 0.0, 4)
		effect.SptSetAlphab(var23, 2, 2)
		effect.SptSetUvSize(var23, 0.0, 0.0, 64.0, 64.0, 2)
		effect.SptVanSetPos(var23, var35, var36, var37, var32, var33, var34, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var23, 128.0, 128.0, 128.0, 128.0, 2)
		effect.SptColorConv(var23, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var23, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		effect.SptSetAlphab(var23 + 2, 3, 2)
		effect.SptSetUvSize(var23 + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.ScaleVector(var32, var33, var34, 2.0)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.AddVector(var35, var36, var37, var32, var33, var34)
			var35 = out1 or var35
			var36 = out2 or var36
			var37 = out3 or var37
		end
		effect.SptVanSetPos(var23 + 2, var35, var36, var37, var32, var33, var34, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var23 + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.SptColorConv(var23 + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var23 + 2, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		for var38 = 0, 3 do
			value_2 = effect.GetRand(3.1415927) or value_2
			value_2 = vm.f32(vm.f32(value_2 + 2.0) + vm.f32(2.0 * value))
			effect.SptScaleConv(var23 + var38, value_2, value_2, 4.0)
			value_2 = effect.GetRand(6.2831855) or value_2
			value_2 = vm.f32(value_2 - vm.f32(3.1415927))
			effect.SptSetRotz(var23 + var38, value_2)
			value_2 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_2
			value_2 = vm.f32(value_2 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_3 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_4 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			effect.SptSetVeloPos(var23 + var38, value_2, value_3, value_4)
		end
		var23 = var23 + 4
		if var23 >= 52 then
			var23 = 4
		end
		do
			local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var11, var12, var13)
			var45 = out4 or var45
		end
		if var45 >= 0 then
			effect.EsCreate_1("モニカ魔法－火ヒット")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			effect.EsSetValueFloat(0, value)
			break
		else
			effect.ColprimSetCoord(var11, var12, var13, 10.0)
			var45 = effect.ColprimGetHitcnt() or var45
			if var45 > 0 then
				effect.EsCreate_1("モニカ魔法－火ヒット")
				effect.EsSetVect1(vector_x, vector_y, vector_z)
				effect.EsSetValueFloat(0, value)
				break
			else
				var27 = var27 + 1
				vm.wait()
			end
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
