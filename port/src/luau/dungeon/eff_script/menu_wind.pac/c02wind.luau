--!strict
-- dungeon/eff_script/menu_wind.pac/c02wind.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local value: f32 = 0
	local angle: f32 = 0
	local var4: f32 = 0
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
	local var16: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local value_2: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local vector_x_2: f32 = 0
	local vector_y_2: f32 = 0
	local vector_z_2: f32 = 0
	local var34: s32 = 0
	local var35: s32 = 0
	local var36: s32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var41: s32 = 0
	user_id = effect.GetUserId() or user_id
	target_id = effect.GetTargetId() or target_id
	value = effect.GetValueFloat(0) or value
	value = 0.0
	angle = 0.0
	do
		local out1, out2, out3 = effect.ScnGetChrPos(user_id)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var4 = effect.ScnGetChrRot_2(user_id) or var4
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	if target_id <= -1 then
		pos_x_2 = vm.f32(vm.f32(vm.sin(var4) * 400.0) + pos_x)
		pos_y_2 = vm.f32(20.0 + pos_y)
		pos_z_2 = vm.f32(vm.f32(vm.cos(var4) * 400.0) + pos_z)
	else
		do
			local out1, out2, out3 = effect.ScnGetChrEntobjPos(target_id, 0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
	end
	value_2 = effect.GetRand(2.0943952) or value_2
	value_2 = vm.f32(value_2 - vm.f32(1.0471976))
	var4 = vm.f32(var4 + value_2)
	var4 = effect.AngleLimit(var4) or var4
	var24 = vm.f32(vm.f32(vm.sin(var4) * 30.0) + pos_x)
	var25 = vm.f32(40.0 + pos_y)
	var26 = vm.f32(vm.f32(vm.cos(var4) * 30.0) + pos_z)
	var4 = effect.ScnGetChrRot_2(user_id) or var4
	var27 = effect.SptAssignSprite_2(20) or var27
	if var27 == 0 then
		return
	end
	effect.SptSetTexname("c02wind")
	effect.SptInitSprite(0, 20)
	effect.SptSetAlphab(0, 2, 20)
	effect.SptSetDrawFlag(0, 1, 20)
	effect.SptSetPutSize(0, 20.0, 20.0, 20)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 20)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 20)
	var35 = 0
	var34 = 0
	while var34 < 10 do
		do
			local out1, out2, out3 = effect.CopyVector(var24, var25, var26)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		do
			local out1, out2, out3 = effect.SubVector(var20, var21, var22, var11, var12, var13)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		do
			local out1, out2, out3 = effect.DivVector(var20, var21, var22, 3.0)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var11, var12, var13, var20, var21, var22)
			var11 = out1 or var11
			var12 = out2 or var12
			var13 = out3 or var13
		end
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			vector_x_2 = out1 or vector_x_2
			vector_y_2 = out2 or vector_y_2
			vector_z_2 = out3 or vector_z_2
		end
		do
			local out1, out2, out3 = effect.CopyVector(vector_x, vector_y, vector_z)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		do
			local out1, out2, out3 = effect.SubVector(var28, var29, var30, var11, var12, var13)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		do
			local out1, out2, out3 = effect.DivVector(var28, var29, var30, 2)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		effect.SptVanSetPos(var35, vector_x_2, vector_y_2, vector_z_2, var28, var29, var30, 0.0, 0.0, 0.0, 2)
		effect.SptVanSetCol(var35, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.SptColorConv(var35, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.SptVanSetScl(var35, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 0.0, -0.04, 0.0, 0.0, 2)
		effect.SptScaleConv(
			var35,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			4.0,
			2
		)
		effect.SptVanSetRot(var35, angle, -0.6, 0.0, 2)
		angle = vm.f32(angle + vm.f32(1.2))
		angle = effect.AngleLimit(angle) or angle
		var35 = var35 + 2
		if var35 >= 20 then
			var35 = 0
		end
		effect.ColprimSetCoord(var11, var12, var13, 10.0)
		var36 = effect.ColprimGetHitcnt() or var36
		if var36 > 0 then
			effect.EsCreate_1("モニカ魔法－風ヒット")
			effect.EsSetVect1(vector_x, vector_y, vector_z)
			effect.EsSetValueFloat(0, value)
			break
		else
			var34 = var34 + 1
			vm.wait()
		end
	end
	var37 = 1.0
	var4 = effect.GetRefRot_7(var11, var12, var13, pos_x_2, pos_y_2, pos_z_2) or var4
	do
		local out1, out2, out3 = effect.GetRefRot_9(var11, var12, var13, pos_x_2, pos_y_2, pos_z_2)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var14 = effect.GetRand(0.5235988) or var14
	var14 = vm.f32(var14 + vm.f32(0.2617994))
	var16 = 0.0
	do
		local out1, out2, out3 = effect.GetDirVector(var14, var15, var16)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = effect.NormalVector(var20, var21, var22)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var20, var21, var22, var37)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	var35 = 0
	var34 = 0
	while var34 < 90 do
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var11, var12, var13, var20, var21, var22)
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
			var38 = out1 or var38
			var39 = out2 or var39
		end
		var41 = effect.AngleCmp(var15, var39, 1.6) or var41
		if var41 == 0 then
			var38 = vm.f32(var38 - var14)
			var38 = effect.AngleLimit(var38) or var38
			var38 = vm.f32(var38 / 6.0)
			var14 = vm.f32(var14 + var38)
			var14 = effect.AngleLimit(var14) or var14
			var39 = vm.f32(var39 - var15)
			var39 = effect.AngleLimit(var39) or var39
			var39 = vm.f32(var39 / 6.0)
			var15 = vm.f32(var15 + var39)
			var15 = effect.AngleLimit(var15) or var15
		end
		do
			local out1, out2, out3 = effect.GetDirVector(var14, var15, var16)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var20, var21, var22, var37)
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		var37 = vm.f32(var37 * 2.0)
		if var37 > 16.0 then
			var37 = 16.0
		end
		do
			local out1, out2, out3 = effect.CopyVector(var11, var12, var13)
			vector_x_2 = out1 or vector_x_2
			vector_y_2 = out2 or vector_y_2
			vector_z_2 = out3 or vector_z_2
		end
		do
			local out1, out2, out3 = effect.CopyVector(vector_x, vector_y, vector_z)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		do
			local out1, out2, out3 = effect.SubVector(var28, var29, var30, var11, var12, var13)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		do
			local out1, out2, out3 = effect.DivVector(var28, var29, var30, 2)
			var28 = out1 or var28
			var29 = out2 or var29
			var30 = out3 or var30
		end
		effect.SptVanSetPos(var35, vector_x_2, vector_y_2, vector_z_2, var28, var29, var30, 0.0, 0.0, 0.0, 2)
		effect.SptVanSetCol(var35, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.SptColorConv(var35, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.SptVanSetScl(var35, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 0.0, -0.04, 0.0, 0.0, 2)
		effect.SptScaleConv(
			var35,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			4.0,
			2
		)
		effect.SptVanSetRot(var35, angle, -0.6, 0.0, 2)
		angle = vm.f32(angle + vm.f32(1.2))
		angle = effect.AngleLimit(angle) or angle
		var35 = var35 + 2
		if var35 >= 20 then
			var35 = 0
		end
		do
			local _, _, _, out4 = effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var11, var12, var13)
			var36 = out4 or var36
		end
		if var36 >= 0 then
			break
		else
			effect.ColprimSetCoord(var11, var12, var13, 10.0)
			var36 = effect.ColprimGetHitcnt() or var36
			if var36 > 0 then
				effect.EsCreate_1("モニカ魔法－風ヒット")
				effect.EsSetVect1(vector_x, vector_y, vector_z)
				effect.EsSetValueFloat(0, value)
				break
			else
				var34 = var34 + 1
				vm.wait()
			end
		end
	end
	effect.ColprimDelete(-1)
	var34 = 0
	while var34 < 30 do
		var34 = var34 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
