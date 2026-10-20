--!strict
-- dungeon/eff_script/menu_flame.pac/c02flame.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var21: s32 = 0
	local var22: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var26: s32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var44: s32 = 0
	user_id = effect.GetUserId() or user_id
	target_id = effect.GetTargetId() or target_id
	value = effect.GetValueFloat(0) or value
	value = 0.0
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
			var20 = vm.f32(var20 * vm.f32(0.001))
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
	var21 = effect.SptAssignSprite_2(52) or var21
	if var21 == 0 then
		return
	end
	effect.SptSetTexname("c02flame")
	effect.SptInitSprite(0, 52)
	effect.SptSetDrawFlag(0, 1, 52)
	effect.SptSetAlphab(0, 2, 52)
	effect.SptSetPutSize(0, 10.0, 10.0, 52)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 52)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 52)
	var22 = 4
	var26 = 0
	while var26 < 120 do
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
			var27 = out1 or var27
			var28 = out2 or var28
		end
		var30 = effect.AngleCmp(var15, var28, 1.6) or var30
		if var30 == 0 then
			var27 = vm.f32(var27 - var14)
			var27 = effect.AngleLimit(var27) or var27
			var27 = vm.f32(var27 / 6.0)
			var14 = vm.f32(var14 + var27)
			var14 = effect.AngleLimit(var14) or var14
			var28 = vm.f32(var28 - var15)
			var28 = effect.AngleLimit(var28) or var28
			var28 = vm.f32(var28 / 6.0)
			var15 = vm.f32(var15 + var28)
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
			var34 = out1 or var34
			var35 = out2 or var35
			var36 = out3 or var36
		end
		do
			local out1, out2, out3 = effect.CopyVector(vector_x, vector_y, vector_z)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
		end
		do
			local out1, out2, out3 = effect.SubVector(var31, var32, var33, var11, var12, var13)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
		end
		do
			local out1, out2, out3 = effect.DivVector(var31, var32, var33, 2)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
		end
		effect.SptSetUvSize(0, 0.0, 64.0, 64.0, 64.0, 4)
		effect.SptVanSetPos(0, var34, var35, var36, -var31, -var32, -var33, 0.0, 0.0, 0.0, 4)
		effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.SptColorConv(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.SptVanSetScl(0, 1.5 + vm.f32(1.5 * value), 1.5 + vm.f32(1.5 * value), 0.1, 0.1, 0.0, 0.0, 4)
		effect.SptSetAlphab(var22, 2, 2)
		effect.SptSetUvSize(var22, 0.0, 0.0, 64.0, 64.0, 2)
		effect.SptVanSetPos(var22, var34, var35, var36, var31, var32, var33, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var22, 128.0, 128.0, 128.0, 128.0, 2)
		effect.SptColorConv(var22, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var22, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		effect.SptSetAlphab(var22 + 2, 3, 2)
		effect.SptSetUvSize(var22 + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.ScaleVector(var31, var32, var33, 2.0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
		end
		do
			local out1, out2, out3 = effect.AddVector(var34, var35, var36, var31, var32, var33)
			var34 = out1 or var34
			var35 = out2 or var35
			var36 = out3 or var36
		end
		effect.SptVanSetPos(var22 + 2, var34, var35, var36, var31, var32, var33, 0.0, 0.0, 0.0, 2)
		effect.SptSetColor(var22 + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.SptColorConv(var22 + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.SptSetScale(var22 + 2, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 2)
		for var37 = 0, 3 do
			value_2 = effect.GetRand(3.1415927) or value_2
			value_2 = vm.f32(vm.f32(value_2 + 2.0) + vm.f32(2.0 * value))
			effect.SptScaleConv(var22 + var37, value_2, value_2, 4.0)
			value_2 = effect.GetRand(6.2831855) or value_2
			value_2 = vm.f32(value_2 - vm.f32(3.1415927))
			effect.SptSetRotz(var22 + var37, value_2)
			value_2 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_2
			value_2 = vm.f32(value_2 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_3 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_4 = effect.GetRand(1.0 + vm.f32(1.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			effect.SptSetVeloPos(var22 + var37, value_2, value_3, value_4)
		end
		var22 = var22 + 4
		if var22 >= 52 then
			var22 = 4
		end
		do
			local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var11, var12, var13)
			var44 = out4 or var44
		end
		if var44 >= 0 then
			effect.EsCreate_1("モニカ魔法－火ヒット")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			effect.EsSetValueFloat(0, value)
			break
		else
			effect.ColprimSetCoord(var11, var12, var13, 10.0)
			var44 = effect.ColprimGetHitcnt() or var44
			if var44 > 0 then
				effect.EsCreate_1("モニカ魔法－火ヒット")
				effect.EsSetVect1(vector_x, vector_y, vector_z)
				effect.EsSetValueFloat(0, value)
				break
			else
				var26 = var26 + 1
				vm.wait()
			end
		end
	end
	effect.ColprimDelete(-1)
	var26 = 0
	while var26 < 20 do
		var26 = var26 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
