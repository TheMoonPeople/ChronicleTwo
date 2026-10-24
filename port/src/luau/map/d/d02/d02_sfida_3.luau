--!strict
-- map/d/d02/d02_sfida_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01829caf = require("@lib/event/helper_01829caf")
local helper_14d96446 = require("@lib/event/helper_14d96446")
local helper_151d91c2 = require("@lib/event/helper_151d91c2")
local helper_23369a5e = require("@lib/event/helper_23369a5e")
local helper_2efb013d = require("@lib/event/helper_2efb013d")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_45677aa8 = require("@lib/event/helper_45677aa8")
local helper_55c18c3d = require("@lib/event/helper_55c18c3d")
local helper_638d969d = require("@lib/event/helper_638d969d")
local helper_72407cf0 = require("@lib/event/helper_72407cf0")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7b3cac20 = require("@lib/event/helper_7b3cac20")
local helper_a47895cb = require("@lib/event/helper_a47895cb")
local helper_aea2bb82 = require("@lib/event/helper_aea2bb82")
local helper_ce8d5f8c = require("@lib/event/helper_ce8d5f8c")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e62dd413 = require("@lib/event/helper_e62dd413")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_2e5b8(sp: number)
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14d96446(0, 2000, 8, 0, 0, sp + junk + 3)
				junk += 1
			end
			return 1
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.SetMesWindowMode(0, 4)
		helper_14d96446(0, 2000, 8, 0, 0, sp + junk + 2)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	var1 = event.GetEquipItemno(0, 0) or var1
	if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
		event.SetMesWindowMode(0, 4)
		helper_14d96446(0, 2001, 8, 0, 0, sp + junk + 2)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.SetMesWindowMode(0, 1)
	event.SphidaSetCulbNo(var1)
	event.PadAutoRepeatOff()
	return 0
end

--- Helper function.
local function helper_2aee0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local angle: f32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		x = vm.f32(vm.sin(arg3) * 16.0)
		y = 8.0
		z = vm.f32(vm.cos(arg3) * 16.0)
		angle = vm.f32(arg4 - arg3)
		arg4 = vm.f32(arg3 + 0.5)
		arg3 = vm.f32(arg3 + vm.f32(0.2))
		arg4 = vm.f32(arg3 - 0.5)
		x_2 = vm.f32(vm.sin(arg4) * 16.0)
		y_2 = 8.0
		z_2 = vm.f32(vm.cos(arg4) * 16.0)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	arg3 = event.AngleLimit(arg3) or arg3
	arg3 = event.AngleLimit(arg3) or arg3
	arg4 = event.AngleLimit(arg4) or arg4
	arg4 = event.AngleLimit(arg4) or arg4
	x = vm.f32(vm.sin(arg3) * 16.0)
	y = 8.0
	z = vm.f32(vm.cos(arg3) * 16.0)
	if arg4 ~= arg3 then
		angle = vm.f32(arg4 - arg3)
		angle = event.AngleLimit(angle) or angle
		if angle > 0.0 then
			arg4 = vm.f32(arg3 + 0.5)
		else
			arg3 = vm.f32(arg3 + vm.f32(0.2))
			arg4 = vm.f32(arg3 - 0.5)
		end
	end
	arg4 = event.AngleLimit(arg4) or arg4
	x_2 = vm.f32(vm.sin(arg4) * 16.0)
	y_2 = 8.0
	z_2 = vm.f32(vm.cos(arg4) * 16.0)
	do
		local out1, out2, out3 = event.AddVector(x, y, z, arg0, arg1, arg2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = event.AddVector(x_2, y_2, z_2, arg0, arg1, arg2)
		x_2 = out1 or x_2
		y_2 = out2 or y_2
		z_2 = out3 or z_2
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x_2, y_2, z_2, 1) or var12
	if var12 >= 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x, y - 16.0, z, 1) or var12
	if var12 < 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, x_2, y_2 - 16.0, z_2, 1) or var12
	if var12 < 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2e9d4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg1 = vm.f32(arg1 + 3.0)
		var7 = 0.0
		var8 = 0.0
		var9 = helper_2aee0(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 + var7)
		var9 = helper_2aee0(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 - var7)
		var8 = var7
		var7 = vm.f32(var7 + vm.f32(0.3926991))
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	event.SphidaSetBallPos(arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(8, arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(9, arg0, arg1 + 3.0, arg2)
	arg1 = vm.f32(arg1 + 3.0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg3 = event.GetRefAngle(arg0, arg1, arg2, pos_x, pos_y, pos_z) or arg3
	var7 = 0.0
	var8 = 0.0
	while var7 <= vm.f32(3.1415927) do
		var9 = helper_2aee0(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		if var9 == 1 then
			arg3 = vm.f32(arg3 + var7)
			break
		else
			var9 = helper_2aee0(
				arg0,
				arg1,
				arg2,
				vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
				vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
			)
			if var9 == 1 then
				arg3 = vm.f32(arg3 - var7)
				break
			else
				var8 = var7
				var7 = vm.f32(var7 + vm.f32(0.3926991))
			end
		end
	end
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "かまえ", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_2f340(arg0: f32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = vm.f32(var2 + 25.0)
		arg0 = vm.f32(arg0 - vm.f32(3.1415927))
		var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
		var2 = vm.f32(var2 + 0.0)
		var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraCtrl(0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var2 = vm.f32(var2 + 25.0)
	event.SetCameraRef(var1, var2, var3)
	arg0 = vm.f32(arg0 - vm.f32(3.1415927))
	arg0 = event.AngleLimit(arg0) or arg0
	var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
	var2 = vm.f32(var2 + 0.0)
	var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	event.SetCameraPos(var1, var2, var3)
	event.SetCameraCtrl(1)
	event.CtrlcMoveRange(10.0, 40.0, 60.0, 160.0)
end

--- Helper function.
local function helper_31c88(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.GetEquipItemno(0, 0) or var3
	do
		local out1, out2, out3 = event.SphidaGetCulbDef(var3)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	return arg0, arg1, arg2
end

--- Helper function.
local function helper_290c0(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local language_code: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
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
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		language_code = 0
		language_code = language_code + 1
		mini_level = 0
		var6 = vm.f32(var6 + 3.0)
		var15 = vm.f32(var15 + 3.0)
		var18 = 100.0
		var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
		var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		vm.stack(sp + 41)
		var19 = 0
		language_code = 0
		var18 = 100.0
		vm.stack(sp + 52)
		var18 = vm.f32(var18 - var29)
		vm.stack(sp + 47)
		var31 = vm.f32(20.0 - var29)
		vm.stack(sp + 43)
		var18 = vm.f32(var18 - var31)
		vm.stack(sp + 47)
		language_code = language_code + 1
		vm.stack(sp + 46)
		mini_level = mini_level + 1
		vm.stack(sp + 51)
		language_code = language_code + 1
		vm.stack(sp + 50)
		mini_level = mini_level + 1
		vm.stack(sp + 55)
		language_code = language_code + 1
		vm.stack(sp + 54)
		mini_level = mini_level + 1
		vm.stack(sp + 57)
		var19 = var19 + 1
		vm.stack(sp + 51)
	end
	if vm.skipping() then
		return skip(1)
	end
	language_code = 0
	while language_code < 48 do
		event.SpriteInit(language_code)
		event.SpriteSetType(language_code, 1)
		event.SpriteSetTexture(language_code, "sphida_bar", arg2)
		event.SpriteSetUvsize(language_code, 64, 0, 32, 32)
		event.SpriteSetPutsize(language_code, 2, 2)
		event.SpriteSetColor(language_code, 128, 128, 128, 128)
		event.SpriteSetDraw(language_code, 0)
		language_code = language_code + 1
	end
	mini_level = event.SphidaGetMiniLevel() or mini_level
	if mini_level == 0 then
		language_code = event.GetLanguage() or language_code
		event.SpriteSetType(31, 0)
		event.SpriteSetDraw(31, 1)
		if language_code == 0 then
			event.SpriteSetUvsize(31, 308, 146, 204, 30)
			event.SpriteSetPutsize(31, 204, 30)
			event.SpriteSetPos(31, 120, 30)
		else
			event.SpriteSetUvsize(31, 286, 146, 226, 30)
			event.SpriteSetPutsize(31, 226, 30)
			event.SpriteSetPos(31, 140, 30)
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 100.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.CopyVector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var19 = 0
	language_code = 0
	while var19 < 6 do
		var18 = 100.0
		do
			local out1, out2, out3 = event.CopyVector(var11, var12, var13)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		while true do
			do
				local out1, out2, out3 = event.AddVector(var5, var6, var7, var8, var9, var10)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			vm.stack(sp + 47)
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.ChkIntersectionPoint_15(12, var14, var15, var16, var5, var6, var7, 1)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var23 = out4 or var23
				var24 = out5 or var24
				var25 = out6 or var25
				var30 = out7 or var30
			end
			if var30 >= 0 then
				do
					local out1, out2, out3 = event.CopyVector(-var11, -var12, -var13)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.NormalVector(var26, var27, var28)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.ScaleVector(var26, var27, var28, 3.0)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.AddVector(var20, var21, var22, var26, var27, var28)
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
				var18 = vm.f32(var18 - var29)
				if var18 <= 0.0 then
					break
				end
				while true do
					var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
					if var29 <= 20.0 then
						var31 = vm.f32(20.0 - var29)
						var18 = vm.f32(var18 - var31)
						do
							local out1, out2, out3 = event.CopyVector(var20, var21, var22)
							var14 = out1 or var14
							var15 = out2 or var15
							var16 = out3 or var16
						end
						break
					end
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = vm.i32(language_code + 1)
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
					if language_code >= 31 then
						break
					end
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, var31)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(language_code, var14, var15, var16)
				event.SpriteSetDraw(language_code, 1)
				language_code = language_code + 1
				if vm.imod(language_code, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, 20.0)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.ScaleVector(var8, var9, var10, var18)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				if vm.imod(language_code, 5) == 0 then
					break
				end
			else
				while language_code < 31 do
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = language_code + 1
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				break
			end
		end
		var19 = var19 + 1
	end
end

--- Helper function.
local function helper_2ad88()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 48 do
		event.SpriteSetDraw(var0, 0)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_2badc(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local junk = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local angle: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 60
			var5 = 76
			local _ = helper_2aee0(
				var16,
				var17,
				var18,
				vm.f32(var11 + vm.f32(1.5707964)),
				vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
			) == 1
			var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			var14 = 0.0
			var5 = 76
			var4 = 400
			var4 = 200
			var5 = 0
			var5 = var5 - 1
			var4 = var4 - 1
			var13 = arg1
			var13 = vm.f32(var13 + var15)
			var13 = 5.0
			var13 = 30.0
			arg0 = var11
			arg1 = var13
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			helper_290c0(arg0, arg1, arg2, sp + junk + 27)
			local _ = helper_aea2bb82(0)
			var3 = 0
			local _ = helper_aea2bb82(1)
			var3 = 1
			junk += 10
		end
		if at <= 2 then
			helper_2ad88()
		end
		return var3, arg0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = 60
	var5 = 76
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.SetFcameraFollowFlag(1)
	event.SetCameraCtrl(1)
	event.CtrlcSetRotCancel(43)
	event.SetCameraSpeed(6.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraFollow(var6, var7 + 20.0, var8)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(100.0)
	event.CtrlcMoveRange(10.0, 30.0, 80.0, 120.0)
	while true do
		do
			local out1, out2 = event.GetApad_2()
			var14 = out1 or var14
			var15 = out2 or var15
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.GetCharaRot(0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		if var14 ~= 0.0 then
			if
				helper_2aee0(
					var16,
					var17,
					var18,
					vm.f32(var11 + vm.f32(1.5707964)),
					vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
				) == 1
			then
				var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			else
				var14 = 0.0
			end
		end
		event.SetCharaRot(0, var10, var11, var12)
		if var4 <= 0 then
			event.SetMotion(0, "待機")
			var5 = 76
			var4 = 400
		else
			if var14 ~= 0.0 then
				event.SetMotion(0, "かまえバタバタ")
				var4 = 200
				var5 = 0
			elseif var5 <= 0 then
				event.SetMotion(0, "かまえ")
			else
				var5 = var5 - 1
			end
			var4 = var4 - 1
		end
		var13 = arg1
		var13 = vm.f32(var13 + var15)
		if var13 <= 5.0 then
			var13 = 5.0
		end
		if var13 >= 30.0 then
			var13 = 30.0
		end
		arg0 = var11
		arg1 = var13
		event.SphidaCalcCarry(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
		angle = vm.f32(arg0 - vm.f32(3.1415927))
		angle = event.AngleLimit(angle) or angle
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		helper_290c0(arg0, arg1, arg2, sp + junk + 19)
		if helper_aea2bb82(0) ~= 0 then
			event.SetMotion(0, "かまえ")
			var3 = 0
			break
		elseif helper_aea2bb82(1) ~= 0 then
			var3 = 1
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	helper_2ad88()
	if vm.wait() then
		return skip(3)
	end
	return var3, arg0, arg1
end

--- Helper function.
local function helper_28fcc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(26)
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d01/d01_sfida.stb", 6000)
end

--- Helper function.
local function helper_3086c()
	local get_now_horl: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(1)
	event.SetBeforeCmrid(0)
	event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
	event.SetFcameraHeight(5.0)
	event.SetFcameraDist(160.0)
	event.SetCameraSpeed(6.0)
	event.CtrlcSetRotCancel(1)
	event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
	event.ResetCamera(0)
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if get_now_horl == 0 then
		event.LoadScript("d02/d02_sfida.stb", 6000)
		return
	end
	if get_now_horl == 1 then
		event.LoadScript("d03/d03_sfida.stb", 6000)
		return
	end
	if get_now_horl == 2 then
		event.LoadScript("d04/d04_sfida.stb", 6000)
		return
	end
	if get_now_horl == 3 then
		event.LoadScript("d05/d05_sfida.stb", 6000)
		return
	end
	if get_now_horl == 4 then
		event.LoadScript("d05/d05_sfida.stb", 6001)
		return
	end
	if get_now_horl == 5 then
		event.LoadScript("d06/d06_sfida.stb", 6000)
		return
	end
	if get_now_horl == 6 then
		event.LoadScript("d07/d07_sfida.stb", 6000)
		return
	end
	if get_now_horl == 7 then
		event.LoadScript("d01/d01_sfida.stb", 6001)
		return
	end
end

--- Helper function.
local function helper_2fbf8()
	local language_code: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			local _ = helper_aea2bb82(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	language_code = event.GetLanguage() or language_code
	var2 = event.SphidaGetScore(-1) or var2
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "omake_sfida", tex_bank)
	event.SpriteSetPos(0, 256, 192)
	if language_code == 3 then
		event.SpriteSetUvsize(0, 0, 38, 162, 34)
		event.SpriteSetPutsize(0, 162, 34)
	else
		event.SpriteSetUvsize(0, 0, 38, 182, 34)
		event.SpriteSetPutsize(0, 182, 34)
	end
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetDraw(1, 0)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "omake_sfida", tex_bank)
	event.SpriteSetUvsize(2, 136, 0, 104, 38)
	event.SpriteSetPos(2, 278, 224)
	event.SpriteSetPutsize(2, 104, 38)
	event.SpriteSetColor(2, 128, 128, 128, 128)
	event.SpriteSetDraw(2, 1)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "omake_sfida", tex_bank)
	event.SpriteSetUvsize(3, vm.i32(vm.imod(var2, 10) * 28), 96, 28, 32)
	event.SpriteSetPos(3, 208, 224)
	event.SpriteSetPutsize(3, 28, 32)
	event.SpriteSetColor(3, 128, 128, 128, 128)
	event.SpriteSetDraw(3, 1)
	if vm.idiv(var2, 10) > 0 then
		event.SpriteInit(4)
		event.SpriteSetType(4, 0)
		event.SpriteSetTexture(4, "omake_sfida", tex_bank)
		event.SpriteSetUvsize(4, vm.i32(vm.idiv(var2, 10) * 28), 96, 28, 32)
		event.SpriteSetPos(4, 184, 224)
		event.SpriteSetPutsize(4, 28, 32)
		event.SpriteSetColor(4, 128, 128, 128, 128)
		event.SpriteSetDraw(4, 1)
	end
	while true do
		if helper_aea2bb82(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
end

--- Helper function.
local function helper_30f1c(arg0: s32, sp: number)
	local junk = 0
	local omake_mode: s32 = 0
	local get_now_horl: s32 = 0
	local count: s32 = 0
	local get_now_horl_2: s32 = 0
	local stage_id: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count_2: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7b3cac20()
				helper_28fcc()
				junk += 4
			end
			return
		end
		if at <= 7 then
			if at <= 3 then
				helper_14d96446(0, 2003, 8, 0, 0, sp + junk + 18)
				junk += 3
			end
			if at <= 4 then
				helper_14d96446(0, 2003, 8, 0, 0, sp + junk + 16)
				junk += 1
			end
			if at <= 5 then
				helper_2fbf8()
			end
			if at <= 6 then
				helper_7b3cac20()
				helper_28fcc()
			end
			return
		end
		if at <= 8 then
			helper_2f481f12(30)
		end
		helper_7b3cac20()
		helper_3086c()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SphidaSetStatusFlag(0)
	event.DeleteChara(12)
	event.EsmClear()
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 1)
	event.SetCameraCtrl(1)
	event.DeleteSwordEffect()
	omake_mode = event.SphidaGetOmakeMode() or omake_mode
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if arg0 == 1 and omake_mode == 1 then
		count = event.SphidaGetParCount() or count
		if get_now_horl ~= 8 then
			event.SphidaSetScore(-1, vm.i32(count + 3))
		end
		helper_7b3cac20()
		get_now_horl_2 = event.SphidaGetNowHole() or get_now_horl_2
		if get_now_horl_2 == 8 then
			helper_28fcc()
			if vm.skipping() then
				return skip(2)
			end
			return
		else
			helper_3086c()
		end
		return
	end
	if omake_mode == 0 then
		event.SetStatusbarShow(1, 0.1)
	end
	event.SetCrossfade(15)
	if arg0 == 1 then
		if omake_mode == 0 then
			stage_id = event.DngGetStageId() or stage_id
			var6 = event.DngGetFloorId() or var6
			var7 = event.GetFloorInfo(stage_id, var6, 4) or var7
			if var7 == 1 then
				event.SetFloorInfo(stage_id, var6, 5, 128)
				event.AddYarikomiMedal(1)
				do
					local out1, out2, out3 = event.GetBeforeCameraNextPos()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.SetCameraPos(position_x, position_y, position_z)
				do
					local out1, out2, out3 = event.GetBeforeCameraNextRef()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.SetCameraRef(position_x, position_y, position_z)
				event.SetMesWindowMode(0, 4)
				helper_14d96446(0, 2010, 8, 0, 0, sp + junk + 15)
				if vm.skipping() then
					return skip(3)
				end
				event.ResetCamera(0)
			end
		end
	end
	count_2 = event.SphidaGetParCount() or count_2
	if arg0 == 0 and count_2 <= 0 then
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraPos(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraRef(position_x_2, position_y_2, position_z_2)
		event.SetMesWindowMode(0, 4)
		if omake_mode == 0 then
			helper_14d96446(0, 2003, 8, 0, 0, sp + junk + 15)
			if vm.skipping() then
				return skip(4)
			end
		else
			if get_now_horl == 8 then
				helper_14d96446(0, 2003, 8, 0, 0, sp + junk + 15)
				if vm.skipping() then
					return skip(5)
				end
				helper_2fbf8()
				if vm.skipping() then
					return skip(6)
				end
				helper_7b3cac20()
				helper_28fcc()
				if vm.skipping() then
					return skip(7)
				end
				return
			else
				event.MesMake_2(0, "Die Kugel ist verschwunden.\nGehe zum n[UNI00e4]chsten Platz.")
				helper_14d96446(0, -1, 8, 0, 0, sp + junk + 15)
				if vm.skipping() then
					return skip(8)
				end
			end
			event.SetFadeOut(30)
			helper_2f481f12(30)
			if vm.skipping() then
				return skip(9)
			end
			helper_7b3cac20()
			helper_3086c()
			return
		end
		event.ResetCamera(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_2c930(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local var15: s32 = 0
	local value: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				var12 = 1
			end
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		return 0, arg0, arg2, arg3, arg4, arg6
	end
	angle = vm.f32(arg2 - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var12 = 0
	code = -10
	event.SphidaResetPowgage()
	event.SphidaStartPowgage()
	while code == -10 do
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		do
			local out1, out2 = event.GetApad_2()
			var8 = out1 or var8
			var9 = out2 or var9
		end
		event.SphidaSetSpinMarkPos(var8, var9)
		if (if var12 == 0 then helper_aea2bb82(1) else 0) ~= 0 then
			event.SphidaSetSpinMarkPos(0.0, 0.0)
			event.SphidaResetPowgage()
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if helper_aea2bb82(0) ~= 0 then
			event.SphidaTriggerPowgage()
			if vm.wait() then
				return skip(1)
			end
			code = event.SphidaGetPowgageCode() or code
			if var12 == 0 or code ~= -10 then
				event.SndSePlay(arg5, 0)
				do
					local out1, out2 = event.SphidaGetPgCursorPos()
					x = out1 or x
					y = out2 or y
				end
				event.SpriteSetType(10 + var12, 0)
				event.SpriteSetAlphab(10 + var12, 2)
				event.SpriteSetUvsize(10 + var12, 0, 224, 32, 32)
				event.SpriteSetDraw(10 + var12, 1)
				event.SpriteSetPutsize(10 + var12, 32, 32)
				event.SpriteSetPos(10 + var12, x, y)
				event.SpriteSetScale(10 + var12, 0.2, 0.2, 0.2)
				event.EohSyncSprite(20 + var12, 10 + var12)
				event.ObjsInit(20 + var12)
				event.ObjsSyncObj(20 + var12, 20 + var12)
				event.ObjsSetScale(20 + var12, 2, 2, 2, 10)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 128, 2)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 0, 8)
				var12 = 1
			end
		else
			if vm.wait() then
				return skip(2)
			end
		end
		code = event.SphidaGetPowgageCode() or code
	end
	if code == 5 then
		event.SphidaSetSpinMarkPos(0.0, 0.0)
		event.SphidaResetPowgage()
		return 1, arg0, arg2, arg3, arg4, arg6
	end
	arg0 = event.SphidaGetShotPow() or arg0
	var15 = event.GetDebugFlag() or var15
	if var15 == 1 then
		var15 = event.GetPadon() or var15
		if bit32.band(var15, 16) ~= 0 then
			arg0 = 1.0
			code = 0
		end
	end
	if code == 4 then
		arg0 = vm.f32(arg0 * 0.0)
	end
	if code == -3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == 3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == -2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == 2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == -1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 - value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 0 then
		arg0 = vm.f32(arg0 * vm.f32(1.1))
		var8 = vm.f32(var8 * arg0)
		var9 = vm.f32(var9 * arg0)
	end
	arg6 = code
	arg2 = event.AngleLimit(arg2) or arg2
	arg3 = var8
	arg4 = var9
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
	return 0, arg0, arg2, arg3, arg4, arg6
end

--- Helper function.
local function helper_2f78c(arg0: s32)
	local count: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		count = count - 1
	end
	if vm.skipping() then
		return skip(1)
	end
	count = event.SphidaGetParCount() or count
	count = vm.i32(count - 1)
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	argc = event.GetItemHaveNum(10) or argc
	if argc <= 0 then
		event.AddItem(10, 1)
	end
	argc = event.GetItemHaveNum(302) or argc
	if argc <= 0 then
		event.AddItem(302, 1)
	end
	event.SetFlag(220, 1)
	event.SetFlag(317, 1)
	event.DelMonster(-1)
	event.Finish()
end

--- Program 1120.
script[1120] = function()
	local sp: number = 0
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14d96446(0, 23, 8, 0, 0, sp + junk + 37)
			end
			var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 3 then
			helper_ce8d5f8c()
			helper_638d969d()
		end
		if at <= 5 then
			helper_638d969d()
		end
		if at <= 6 then
			var14 = vm.f32(var14 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var14 = vm.f32(var14 + var19)
			helper_72407cf0()
			local _ = helper_aea2bb82(0)
			junk += 6
		end
		if at <= 7 then
			var18 = var18 + 1
		end
		if at <= 8 then
			helper_45677aa8()
			value = 0
			value = value + 4
			var18 = 0
			var14 = vm.f32(var14 + var19)
			junk += 1
		end
		if at <= 9 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_55c18c3d(var14, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_55c18c3d(var14, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			local _ = helper_55c18c3d(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var26 = var14
			helper_2f481f12(20)
			junk += 7
		end
		if at <= 10 then
			var30 = 100
			var30 = 6
			var30 = 0
			var30 = 2
			var30 = 100
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_2f481f12(10)
			junk += 7
		end
		if at <= 11 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_2f481f12(20)
			junk += 1
		end
		if at <= 12 then
			local _ = helper_55c18c3d(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			junk += 3
		end
		if at <= 13 then
			helper_14d96446(0, 2310, 8, 0, 0, sp + junk + 37)
		end
		if at <= 14 then
			helper_14d96446(0, 2311, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 15 then
			helper_14d96446(0, 2312, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 16 then
			helper_14d96446(0, 2313, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 17 then
			helper_14d96446(0, 2314, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 18 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			junk += 1
		end
		if at <= 19 then
			helper_14d96446(0, 2320, 8, 0, 0, sp + junk + 37)
		end
		if at <= 20 then
			helper_14d96446(0, 2321, 8, 0, 0, sp + junk + 40)
			junk += 3
		end
		if at <= 21 then
			helper_14d96446(0, 2322, 8, 0, 0, sp + junk + 39)
			junk += 2
		end
		if at <= 22 then
			helper_14d96446(0, 2323, 8, 0, 0, sp + junk + 39)
			junk += 2
		end
		if at <= 23 then
			helper_14d96446(0, 2324, 8, 0, 0, sp + junk + 39)
			junk += 2
		end
		if at <= 24 then
			helper_14d96446(0, 2325, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 25 then
			helper_14d96446(0, 2328, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 26 then
			helper_14d96446(0, 2326, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 27 then
			helper_14d96446(0, 2329, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 28 then
			helper_14d96446(0, 2327, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
		if at <= 29 then
			helper_14d96446(0, 2330, 8, 0, 0, sp + junk + 38)
			junk += 1
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_ce8d5f8c()
		if active_chr_no == 2 then
			helper_14d96446(0, 22, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_14d96446(0, 23, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var1, var2, var3)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(3)
	end
	helper_ce8d5f8c()
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	event.AssignStack(5)
	event.ClearStack(5)
	helper_638d969d()
	if vm.skipping() then
		return skip(4)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile("ring.gltf", "randomcoin.gltf")
	if vm.wait() then
		return skip(5)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(6)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.GetRand(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.AngleLimit(var14) or var14
	event.SetCharaRot(13, 0.0, var14, 0.0)
	event.ChangeDir("")
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.SndSePlay(var11, 0)
		end
		if var18 == 30 then
			helper_72407cf0()
		end
		if (if var18 >= 30 then helper_aea2bb82(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			if vm.wait() then
				return skip(7)
			end
			break
		else
			var18 = var18 + 1
			if vm.wait() then
				return skip(8)
			end
		end
	end
	helper_45677aa8()
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if vm.wait() then
			return skip(9)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_55c18c3d(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_55c18c3d(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_55c18c3d(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_2f481f12(20)
	if vm.skipping() then
		return skip(10)
	end
	value_2 = event.GetRandInt(10) or value_2
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if value_2 < var30 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_2f481f12(10)
			if vm.skipping() then
				return skip(11)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_2f481f12(20)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_55c18c3d(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var11, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(13)
			end
		end
		helper_14d96446(0, 2310, 8, 0, 0, sp + junk + 37)
		if vm.skipping() then
			return skip(14)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_14d96446(0, 2311, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(15)
			end
		end
		if var32 == 2 then
			helper_14d96446(0, 2312, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(16)
			end
		end
		if var32 == 3 then
			helper_14d96446(0, 2313, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(17)
			end
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_14d96446(0, 2314, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(18)
			end
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(19)
			end
		end
		helper_14d96446(0, 2320, 8, 0, 0, sp + junk + 37)
		if vm.skipping() then
			return skip(20)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_14d96446(0, 2321, 8, 0, 0, sp + junk + 37)
				if vm.skipping() then
					return skip(21)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_14d96446(0, 2322, 8, 0, 0, sp + junk + 37)
				if vm.skipping() then
					return skip(22)
				end
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_14d96446(0, 2323, 8, 0, 0, sp + junk + 37)
				if vm.skipping() then
					return skip(23)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_14d96446(0, 2324, 8, 0, 0, sp + junk + 37)
				if vm.skipping() then
					return skip(24)
				end
			end
			if active_chr_no == 2 then
				helper_14d96446(0, 2325, 8, 0, 0, sp + junk + 37)
				if vm.skipping() then
					return skip(25)
				end
			end
		end
		if var32 == 8 then
			helper_14d96446(0, 2328, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(26)
			end
		end
		if var32 == 9 then
			helper_14d96446(0, 2326, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(27)
			end
		end
		if var32 == 10 then
			helper_14d96446(0, 2329, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(28)
			end
		end
		if var32 == 11 then
			helper_14d96446(0, 2327, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(29)
			end
		end
		if var32 == 12 then
			helper_14d96446(0, 2330, 8, 0, 0, sp + junk + 37)
			if vm.skipping() then
				return skip(30)
			end
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(513, 0)
	event.SetCameraCtrl(1)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local sp: number = 0
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14d96446(0, 23, 8, 0, 0, sp + junk + 24)
			end
			return
		end
		if at <= 3 then
			helper_638d969d()
		end
		if at <= 4 then
			junk += 1
		end
		if at <= 5 then
			helper_638d969d()
		end
		if at <= 6 then
			pos_y_2 = vm.f32(var9 + 18.0)
			var17 = vm.f32(var17 + vm.f32(2.9))
			var17 = vm.f32(var17 + vm.f32(2.4))
			var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
			var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
			var17 = vm.f32(var17 - vm.f32(3.1415927))
			var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
			var19 = vm.f32(var9 + 18.0)
			var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
			helper_2f481f12(16)
			junk += 4
		end
		if at <= 7 then
			helper_2f481f12(2)
		end
		if at <= 8 then
			helper_2f481f12(10)
		end
		if at <= 9 then
			helper_2f481f12(20)
		end
		if at <= 10 then
			helper_e8f4b85c(0)
		end
		if at <= 11 then
			helper_14d96446(0, 2400, 8, 0, 0, sp + junk + 24)
		end
		if at <= 12 then
			junk += 1
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_ce8d5f8c()
		if active_chr_no == 2 then
			helper_14d96446(0, 22, 8, 0, 0, sp + junk + 24)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_14d96446(0, 23, 8, 0, 0, sp + junk + 24)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.DngPause(16, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetFlag(31, 1)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(3)
		end
		helper_638d969d()
		if vm.skipping() then
			return skip(4)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(5)
		end
		helper_638d969d()
		if vm.skipping() then
			return skip(6)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var4
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.CopyVector(var8, var9, var10)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var17 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.AngleLimit(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.AngleLimit(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.AngleLimit(var17) or var17
	event.SetCharaRot(0, 0.0, var17, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		var19 = vm.f32(var9 + 18.0)
		var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.SetCharaPos(12, var18, var19, var20)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_2f481f12(16)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	helper_2f481f12(2)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(9)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.GetRefAngle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.SetCharaRot(12, 0.0, var17, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_2f481f12(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var4, 1)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_14d96446(0, 2400, 8, 0, 0, sp + junk + 24)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(13)
		end
	end
	event.DngPause(529, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var1, var2, var3)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.SetCameraCtrl(1)
	event.Finish()
end

--- Program 2500.
script[2500] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_14d96446(0, 2600, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2510.
script[2510] = function()
	local sp: number = 0
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_a47895cb(0, 0, var0, sp + 1)
		end
		helper_23369a5e(0)
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_e62dd413(0, 2610, 8, 0, 0)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_a47895cb(0, 0, var0, sp + 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_23369a5e(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2520.
script[2520] = function()
	local sp: number = 0
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_a47895cb(0, 0, var0, sp + 1)
		end
		if at <= 2 then
			helper_23369a5e(0)
			helper_14d96446(0, 2621, 8, 0, 0, sp + 1)
		end
		if at <= 3 then
			helper_14d96446(0, 2622, 8, 0, 0, sp + 1)
		end
		if at <= 4 then
			helper_14d96446(0, 2623, 8, 0, 0, sp + 1)
		end
		if at <= 5 then
			helper_14d96446(0, -1, 8, 0, 0, sp + 1)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_e62dd413(0, 2620, 8, 0, 0)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_a47895cb(0, 0, var0, sp + 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_23369a5e(0)
	helper_14d96446(0, 2621, 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(3)
	end
	helper_14d96446(0, 2622, 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(4)
	end
	helper_14d96446(0, 2623, 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, 'Mehr erf[UNI00e4]hrst du unter\n"Hilfe" im Hauptmen[UNI00fc].')
	helper_14d96446(0, -1, 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(6)
	end
	if vm.wait() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2530.
script[2530] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Lenken des Buggys\n   Beschleunige mit (L)↑, bremse mit (L)↓.\n   lenke mit (L) ← oder →.\n   Scharfe Kurven: [l1] + (L) ← oder →."
	)
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2540.
script[2540] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_14d96446(0, -1, 8, 0, 0, sp + 0)
		end
		if at <= 2 then
			helper_14d96446(0, -1, 8, 0, 0, sp + 0)
		end
		if at <= 3 then
			helper_14d96446(0, -1, 8, 0, 0, sp + 0)
		end
		if at <= 4 then
			helper_14d96446(0, -1, 8, 0, 0, sp + 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]Du kannst die Magie-Raub-\nKlinge jetzt verwenden.")
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Die Fertigkeit Magie-Raub-Klinge\nerlaubt es dir, die Energie von\nElementarangriffen wie Feuer beim\nAbwehren aufzunehmen.<page>Beim Angriff verwandelt\nsie sich in Magie."
	)
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Die Energie eines Elements kannst\ndu immer weiter aufladen.\nNimmst du aber einen anderen Elementar-\nTyp auf, verlierst du die ganze Ladung."
	)
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wie viel Elementarenergie du\nabsorbieren kannst, h[UNI00e4]ngt von der\nHaltbarkeit deiner Waffe ab."
	)
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Um absorbierte Elementarenergie als\nMagie abzugeben, dr[UNI00fc]cke [l1]\n w[UNI00e4]hrend du mit [r1] abwehrst."
	)
	helper_14d96446(0, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 3000.
script[3000] = function()
	local sp: number = 0
	local junk = 0
	local var0: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: s32 = 0
	local var48: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var52: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var58: any = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ce8d5f8c()
				local _ = helper_2e5b8(sp + junk + 59)
				junk += 1
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				helper_638d969d()
			end
			if at <= 4 then
				var3, var4, var5, var7 = helper_2e9d4(var3, var4, var5, var7)
				helper_2f340(var7)
				var12 = 12.5
				var13, var14, var15 = helper_31c88(var13, var14, var15)
				_, var7, var12 = helper_2badc(var7, var12, tex_bank, sp + junk + 60)
				junk += 2
			end
			if at <= 5 then
				helper_30f1c(0, sp + junk + 59)
			end
			return
		end
		if at <= 14 then
			if at <= 8 then
				var22 = 0
				helper_2f481f12(10)
				junk += 8
			end
			if at <= 9 then
				helper_2f481f12(25)
				junk += 1
			end
			if at <= 10 then
				helper_2f481f12(34)
				junk += 2
			end
			if at <= 11 then
				helper_2f481f12(39)
			end
			if at <= 12 then
				helper_2f481f12(50)
				junk += 2
			end
			if at <= 13 then
				helper_2f78c(var2)
				helper_30f1c(0, sp + junk + 59)
			end
			return
		end
		if at <= 15 then
			var43 = var43 - 1
			var47 = var47 + 1
			var47 = 0
			var47 = var47 + 1
			junk += 4
		end
		if at <= 16 then
			var47 = 0
			var47 = var47 + 1
			junk += 1
		end
		if at <= 17 then
			var42 = vm.i32(var42 + 1)
			helper_2f481f12(54)
			junk += 1
		end
		if at <= 18 then
			helper_2f481f12(30)
		end
		if at <= 19 then
			helper_e8f4b85c(0)
			junk += 1
		end
		if at <= 20 then
			helper_2f481f12(90)
		end
		if at <= 22 then
			count = vm.i32(count + 2)
			local _ = helper_aea2bb82(0)
			junk += 6
		end
		if at <= 23 then
			helper_2fbf8()
			junk += 1
		end
		if at <= 24 then
			helper_2f481f12(30)
		end
		if at <= 25 then
			var58 = helper_151d91c2(0, 2002, 8, 256, 208, 2, 0)
			junk += 1
		end
		if at <= 27 then
			var12 = vm.f32(var12 - vm.f32(3.1415927))
			var9 = vm.f32(var9 + vm.f32(vm.sin(var12) * 50.0))
			var11 = vm.f32(var11 + vm.f32(vm.cos(var12) * 50.0))
			var47 = 0
			var19 = vm.f32(var19 + 1.0)
			var21 = vm.f32(var21 + 1.0)
			var47 = var47 + 1
			var7 = vm.f32(var7 - vm.f32(3.1415927))
			var9 = vm.f32(vm.f32(vm.sin(var7) * 100.0) + var9)
			var10 = vm.f32(var10 + 30.0)
			var11 = vm.f32(vm.f32(vm.cos(var7) * 100.0) + var11)
			helper_e8f4b85c(0)
			junk += 5
		end
		if at <= 28 then
			helper_2f481f12(20)
		end
		if at <= 29 then
			helper_2f78c(-1)
			helper_2f78c(var2)
			helper_30f1c(var22, sp + junk + 60)
			junk += 1
		end
	end
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	helper_ce8d5f8c()
	event.SetMotion(0, "立ち")
	local t0 = helper_2e5b8(sp + junk + 59)
	if vm.skipping() then
		junk += 1
		return skip(2)
	end
	if t0 ~= 0 then
		event.Finish()
		return
	end
	var0 = event.SphidaGetOmakeMode() or var0
	if var0 == 0 then
		event.SetStatusbarShow(0, 0.1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	if vm.wait() then
		return skip(3)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	var2 = event.SndLoadSound(5, "snd2/mon/en_900.sound.json") or var2
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EsmInitialize(5, 1)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 0)
	event.SetCrossfade(15)
	event.SphidaResetPowgage()
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var3, var4, var5, var7 = helper_2e9d4(var3, var4, var5, var7)
	helper_2f340(var7)
	event.SphidaSetStatusFlag(1)
	var12 = 12.5
	event.SphidaCalcCarry(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13, var14, var15 = helper_31c88(var13, var14, var15)
	event.SphidaSetPowgageSafeLevel(var15)
	do
		local out1, out2, out3 = event.ZeroVector()
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	while true do
		event.SphidaSetMinimapFlag(1)
		event.SphidaSetMmLineFlag(1)
		local t1: s32
		t1, var7, var12 = helper_2badc(var7, var12, tex_bank, sp + junk + 59)
		local t2 = t1
		if vm.skipping() then
			junk += 1
			return skip(5)
		end
		if t2 ~= 0 then
			event.SphidaSetMinimapFlag(0)
			event.SphidaSetMmLineFlag(0)
			event.SphidaSetBallPos(var9, var10, var11)
			event.SetCharaPos(8, var9, var10, var11)
			event.SetCharaPos(9, var9, var10, var11)
			helper_30f1c(0, sp + junk + 59)
			if vm.skipping() then
				return skip(6)
			end
			return
		end
		event.SphidaSetMinimapFlag(0)
		event.SphidaSetMmLineFlag(0)
		local t3: s32
		t3, var13, var7, var17, var16, var15 = helper_2c930(var13, tex_bank, var7, var17, var16, var2, var15)
		local t4 = if t3 == 0 then 1 else 0
		if vm.skipping() then
			junk += 1
			return skip(7)
		end
		if t4 ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	do
		local out1, out2, out3 = event.CopyVector(var3, var4, var5)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	var22 = 0
	if var15 ~= 1 and var15 ~= -1 and var15 ~= 4 then
		event.SpriteSetType(0, 1)
		event.SpriteSetDraw(0, 1)
		event.SpriteSetPutsize(0, 10.8, 11.6)
		event.SpriteSetPos(0, var3, var4 + 30.0, var5)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		if var15 == 0 then
			event.SpriteSetUvsize(0, 78, 198, 54, 58)
		end
		if var15 == 2 or var15 == -2 then
			event.SpriteSetUvsize(0, 186, 190, 70, 66)
		end
		if var15 == 3 or var15 == -3 then
			event.SpriteSetUvsize(0, 132, 198, 54, 58)
		end
		event.EohSyncSprite(18, 0)
		event.ObjsInit(18)
		event.ObjsSyncObj(18, 18)
		event.ObjsSetColor(18, 128, 128, 128, 128, 4)
		event.ObjsColorDelay(18, 20)
		event.ObjsSetColor(18, 128, 128, 128, 0, 6)
		helper_2f481f12(10)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var13 <= vm.f32(0.3) then
		event.SetMotion(0, "小ショット", 2)
		helper_2f481f12(25)
		if vm.skipping() then
			return skip(10)
		end
		if var15 ~= 4 then
			event.SndSePlay(var2, 3)
		end
	elseif var13 <= vm.f32(0.6) then
		event.SetMotion(0, "中ショット", 2)
		helper_2f481f12(34)
		if vm.skipping() then
			return skip(11)
		end
		event.SndSePlay(var2, 2)
	else
		event.SetMotion(0, "大ショット", 2)
		helper_2f481f12(39)
		if vm.skipping() then
			return skip(12)
		end
		if var15 == 0 then
			event.SndSePlay(var2, 12)
		else
			event.SndSePlay(var2, 1)
		end
	end
	if var15 == 4 then
		helper_2f481f12(50)
		if vm.skipping() then
			return skip(13)
		end
		helper_2f78c(var2)
		event.SphidaSetBallPos(var9, var10, var11)
		event.SetCharaPos(8, var9, var10, var11)
		event.SetCharaPos(9, var9, var10, var11)
		helper_30f1c(0, sp + junk + 59)
		if vm.skipping() then
			return skip(14)
		end
		return
	end
	if var15 == 0 then
		event.SpriteSetType(1, 0)
		event.SpriteSetDraw(1, 1)
		event.SpriteSetPos(1, 256, 278)
		event.SpriteSetUvsize(1, 246, 104, 266, 42)
		event.SpriteSetPutsize(1, 266, 42)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetScale(1, 10, 10, 10)
		event.EohSyncSprite(19, 1)
		event.ObjsInit(19)
		event.ObjsSyncObj(19, 19)
		event.ObjsJump(19, 256, 138, 0, 3.6, 20)
		event.ObjsSetScale(19, 1, 1, 1, 18)
		event.ObjsSetColor(19, 128, 128, 128, 128, 12)
		event.ObjsColorDelay(19, 30)
		event.ObjsSetColor(19, 128, 128, 128, 0, 6)
	end
	var13 = helper_dff48a5c(var13)
	var12 = vm.f32(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13 = vm.f32(var13 - vm.f32(var13 * var12))
	var23 = vm.f32(vm.sin(var7) * vm.f32(var13 * vm.cos(var12)))
	var24 = vm.f32(var13 * vm.sin(var12))
	var25 = vm.f32(vm.cos(var7) * vm.f32(var13 * vm.cos(var12)))
	var17 = vm.f32(vm.f32(var17 * vm.f32(3.1415927)) / 2.0)
	var18 = vm.f32(vm.f32(vm.f32(-var25 * var14) * var16) * vm.f32(0.4))
	var16 = vm.f32(vm.f32(vm.f32(-var23 * var14) * var16) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var30 = 0
	var15 = 0
	var43 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.ChkIntersectionPoint_13(0, var3, var4 + 5.0, var5, var3, var4, var5, 0)
		var31 = out1 or var31
		var32 = out2 or var32
		var33 = out3 or var33
		var42 = out4 or var42
		var44 = out5 or var44
	end
	if var42 >= 0 and (var44 == 1 or var44 == 7) then
		print("----------------START_MIZU-------------------\n")
		var13 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var13 = 0.0
	end
	var47 = 0
	while true do
		if var4 >= 180.0 then
			var23 = vm.f32(var23 * vm.f32(0.999))
			var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0098) * (var47 + 1)))
			var25 = vm.f32(var25 * vm.f32(0.999))
		else
			var42 = event.ChkIntersectionPoint_9(12, var3, var4, var5, var3, vm.f32(var4 - 3.0) - vm.f32(0.01), var5, 0)
				or var42
			if var15 == 1 and var42 >= 0 then
				var23 = vm.f32(var23 * vm.f32(0.94))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.00045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.94))
				var23 = vm.f32(var23 + var16)
				var25 = vm.f32(var25 + var18)
				var16 = vm.f32(var16 * vm.f32(0.8))
				var18 = vm.f32(var18 * vm.f32(0.8))
			else
				var23 = vm.f32(var23 * vm.f32(0.999))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.AddVector(var3, var4, var5, var23, var24, var25)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		if var17 ~= 0.0 then
			var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
			var12 = vm.f32(var12 + var17)
			var12 = event.AngleLimit(var12) or var12
			var23 = vm.f32(var23 + vm.f32(vm.f32(vm.sin(var12) / 10.0) * var14))
			var25 = vm.f32(var25 + vm.f32(vm.f32(vm.cos(var12) / 10.0) * var14))
		end
		var41 = event.DistVector(var16, 0.0, var18) or var41
		if var41 > vm.f32(0.01) then
			var26 = event.DistVector(var16, 0.0, var18) or var26
			var12 = event.GetRefAngle(var19, var20, var21, var19 + var16, var20, var21 + var18) or var12
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.SetCharaRot(8, var6, var12, var8)
			event.AddCharaRot(8, var26 * 12.0, 0.0, 0.0)
			event.SetCharaRot(9, var6, var12, var8)
			event.AddCharaRot(9, var26 * 12.0, 0.0, 0.0)
		else
			var26 = event.DistVector(var23, 0.0, var25) or var26
			var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.SetCharaRot(8, var6, var12, var8)
			event.AddCharaRot(8, var26 / 10.0, 0.0, 0.0)
			event.SetCharaRot(9, var6, var12, var8)
			event.AddCharaRot(9, var26 / 10.0, 0.0, 0.0)
		end
		var26 = event.DistVector(var23, var24, var25) or var26
		var40 = var26
		var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
		var37 = vm.f32(vm.sin(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		var39 = vm.f32(vm.cos(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		event.SwordEffectAddPoint(
			var3 - var37,
			var4,
			var5 - var39,
			vm.f32(var3 + var37) + var37,
			var4,
			vm.f32(var5 + var39) + var39
		)
		do
			local out1, out2, out3 = event.CopyVector(var23, var24, var25)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.NormalVector(var37, var38, var39)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.ScaleVector(var37, var38, var39, 3.0)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3, out4, out5 =
				event.ChkIntersectionPoint_13(0, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var42 = out4 or var42
			var44 = out5 or var44
		end
		if var42 >= 0 and (var44 == 1 or var44 == 7) then
			event.EsmCreate("足水パシャ")
			event.EsmSetVect1(var31, var32, var33)
			if var43 <= 0 then
				event.SndSePlay(var2, 11)
				var43 = 10
			end
			if var13 == 0.0 then
				var13 = 1.0
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var25 = vm.f32(var25 * vm.f32(0.4))
				var16 = 0.0
				var18 = 0.0
				event.DeleteSwordEffect()
				print("----------------SE OFF-------------------\n")
			else
				var13 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
		end
		if var42 < 0 then
			if var4 >= 380.0 and var24 > 0.0 then
				do
					local out1, out2, out3 = event.CopyVector(var3, var4, var5)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, -var24, var25)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.NormalVector(var34, var35, var36)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				var42 = 1
			end
		end
		while var42 >= 0 do
			var17 = 0.0
			if var26 > 8.0 then
				helper_79d90c82()
			end
			if var13 ~= 1.0 and var43 <= 0 then
				event.SndSePlay(var2, 6)
				var43 = 10
			end
			do
				local out1, out2, out3 = event.CopyVector(-var23, -var24, -var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.NormalVector(var23, var24, var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.ScaleVector(var23, var24, var25, 3.0)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.AddVector(var31, var32, var33, var23, var24, var25)
				var31 = out1 or var31
				var32 = out2 or var32
				var33 = out3 or var33
			end
			do
				local out1, out2, out3 = event.SubVector(var19, var20, var21, var31, var32, var33)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var41 = event.DistVector(var19, var20, var21) or var41
			var41 = vm.f32(var40 - var41)
			if var41 <= 0.0 then
				break
			else
				var40 = var41
				do
					local out1, out2, out3 = event.CopyVector(-var23, -var24, -var25)
					var23 = out1 or var23
					var24 = out2 or var24
					var25 = out3 or var25
				end
				if var24 < 0.0 and var35 > 0.0 then
					var23 = vm.f32(var16 * 2.0)
					var24 = 0.0
					var25 = vm.f32(var18 * 2.0)
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					if
						var23 < 0.0 and var34 > 0.0
						or var23 > 0.0 and var34 < 0.0
						or var25 < 0.0 and var36 > 0.0
						or var25 > 0.0 and var36 < 0.0
					then
						var16 = 0.0
						var18 = 0.0
					end
					var23 = 0.0
					var24 = 0.0
					var25 = 0.0
				end
				if var13 == 0.0 then
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.9)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.58)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.9)) + var25)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.8)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.4)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.8)) + var25)
				end
				do
					local out1, out2, out3 = event.CopyVector(var31, var32, var33)
					var19 = out1 or var19
					var20 = out2 or var20
					var21 = out3 or var21
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.NormalVector(var37, var38, var39)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.ScaleVector(var37, var38, var39, 3.0)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.ScaleVector(var34, var35, var36, var41)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.CopyVector(var31, var32, var33)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = event.AddVector(var3, var4, var5, var34, var35, var36)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.ChkIntersectionPoint_16(
						12,
						var19,
						var20,
						var21,
						var3 + var37,
						var4 + var38,
						var5 + var39,
						1
					)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var34 = out4 or var34
					var35 = out5 or var35
					var36 = out6 or var36
					var42 = out7 or var42
					var44 = out8 or var44
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.ChkIntersectionPoint_16(12, var3, var4, var5, var3, var4 - 3.0, var5, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
			var44 = out8 or var44
		end
		if var42 >= 0 then
			var17 = 0.0
			var4 = vm.f32(var32 + 3.0)
			var41 = event.DistVector(var23, 0.0, var25) or var41
			if var41 < vm.f32(2.6) or var24 >= -1.0 and var24 <= 0.0 then
				var24 = 0.0
				var15 = 1
			else
				if var13 == 0.0 then
					var23 = vm.f32(var23 * vm.f32(0.9))
					var24 = -vm.f32(var24 * vm.f32(0.58))
					var25 = vm.f32(var25 * vm.f32(0.9))
					var23 = vm.f32(var23 + vm.f32(var16 * 2.0))
					var25 = vm.f32(var25 + vm.f32(var18 * 2.0))
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var23 = vm.f32(var23 * vm.f32(0.8))
					var24 = -vm.f32(var24 * vm.f32(0.4))
					var25 = vm.f32(var25 * vm.f32(0.8))
					var16 = 0.0
					var18 = 0.0
				end
				if var26 > 8.0 then
					helper_79d90c82()
				end
				if var13 ~= 1.0 and var43 <= 0 then
					event.SndSePlay(var2, 5)
					var43 = 10
				end
			end
			var41 = event.DistVector(var16, 0.0, var18) or var41
			if var24 == 0.0 and var26 < vm.f32(1.6) and var41 < vm.f32(0.4) then
				if var44 == 6 then
					var30 = 1
					break
				end
				var44 = event.AmgGetAttrStatus(var3, var4, var5) or var44
				if not (var44 == 1) then
					break
				end
				var30 = 1
				break
			end
		end
		if var4 < -500.0 then
			var30 = 1
			break
		elseif var47 >= 480 then
			var30 = 1
			break
		else
			var45 = event.SphidaGetPinCol() or var45
			var46 = event.SphidaGetBallCol() or var46
			x = vm.f32(pos_x - var3)
			y = vm.f32(pos_y - var4)
			z = vm.f32(pos_z - var5)
			var48 = event.DistVector(x, y, z) or var48
			if var46 ~= var45 then
				var52 = event.LinePointDist(var19, var20, var21, var3, var4, var5, pos_x, pos_y, pos_z) or var52
				if var52 >= 0.0 and var52 <= 30.0 then
					var22 = 1
					break
				end
				if var48 ~= 0.0 then
					if var48 <= 120.0 then
						do
							local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(vm.f32(0.6), var48))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.AddVector(var3, var4, var5, x, y, z)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = event.AddVector(var23, var24, var25, x, y, z)
							var23 = out1 or var23
							var24 = out2 or var24
							var25 = out3 or var25
						end
					end
				else
					var22 = 1
					break
				end
			elseif var48 ~= 0.0 then
				if var48 <= 60.0 then
					do
						local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(1.0, var48))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.SubVector(var3, var4, var5, x, y, z)
						var3 = out1 or var3
						var4 = out2 or var4
						var5 = out3 or var5
					end
					do
						local out1, out2, out3 = event.SubVector(var23, var24, var25, x, y, z)
						var23 = out1 or var23
						var24 = out2 or var24
						var25 = out3 or var25
					end
				end
			end
			event.SetCharaPos(8, var3, var4, var5)
			event.SetCharaPos(9, var3, var4, var5)
			do
				local out1, out2, out3 = event.CopyVector(var3, var4, var5)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			if var4 <= -50.0 then
				event.SetFcameraFollowFlag(0)
				if var30 >= 30 then
					if var30 >= 50 then
						break
					end
				else
					event.SetCameraRef(var3, var4, var5)
				end
				var30 = var30 + 1
			elseif var47 >= 20 then
				event.CtrlcMoveRange(20.0, 30.0, 60.0, 200.0)
				event.SetCameraSpeed(8.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraFollow(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25
				)
				do
					local out1, out2, out3 = event.GetCameraPos()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.GetRefAngle(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.CtrlcSetRotate(yaw)
				event.CtrlcMoveCamera(8)
				event.CtrlcStep()
			end
			event.SphidaSetBallPos(var3, var4, var5)
			if vm.wait() then
				return skip(15)
			end
			if var43 > 0 then
				var43 = var43 - 1
			end
			var47 = var47 + 1
		end
	end
	event.SetCharaPos(8, var3, var4, var5)
	event.SetCharaPos(9, var3, var4, var5)
	event.SphidaSetStatusFlag(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var30 == 0 then
		event.SphidaSetBallPos(var3, var4, var5)
		count = event.SphidaGetParCount() or count
		if var22 == 1 then
			event.CharaActive(0, 0)
			event.CharaActive(0, 8)
			event.CharaActive(0, 9)
			event.CharaActive(1, 12)
			event.SetCharaPos(12, pos_x, pos_y, pos_z)
			event.SetMotion(12, "発動", 6)
			event.SndSePlay(var2, 17)
			var47 = 0
			while var47 < 2 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var47 = var47 + 1
				if vm.wait() then
					return skip(16)
				end
			end
			event.CharaActive(0, 10)
			do
				local out1, out2, out3 = event.SphidaGetPinPos()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var47 = 0
			while var47 < 100 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var47 = var47 + 1
				if vm.wait() then
					return skip(17)
				end
			end
			event.CharaActive(0, 11)
			var45 = event.DngGetStageId() or var45
			var46 = event.DngGetFloorId() or var46
			var42 = event.GetFloorInfo(var45, var46, 4) or var42
			do
				local out1, out2 = event.SphidaGetPrize(var42)
				var43 = out1 or var43
				var44 = out2 or var44
			end
			var42 = vm.i32(var42 + 1)
			event.SetFloorInfo(var45, var46, 4, var42)
			if var0 == 0 then
				event.PostTreasureBox(pos_x, pos_y - 30.0, pos_z, var12, var43)
			end
			helper_2f481f12(54)
			if vm.skipping() then
				return skip(18)
			end
			helper_2f481f12(30)
			if vm.skipping() then
				return skip(19)
			end
			event.DeleteChara(8)
			event.DeleteChara(9)
			event.DeleteChara(10)
			event.DeleteChara(11)
			event.SphidaSetPlayFlag(0)
			var2 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var2
			event.StopBgm(0)
			event.SndSePlay(var2, 0)
			event.CharaActive(1, 0)
			event.SetFcameraFollowFlag(0)
			event.SetCameraCtrl(0)
			event.CmrsInit()
			event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.ObjsSetMotion(0, "カップインポーズ", 6)
			event.ObjsNormalDrive(0)
			event.ObjsNextMotion(0, "カップインポーズL", 4)
			event.ObjsResetDaPosition(0)
			var43 = event.GetLanguage() or var43
			if var43 == 0 then
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 258, 0, 254, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			else
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 206, 0, 306, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			end
			event.EohSyncSprite(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
			event.ObjsSetColor(1, 128, 128, 128, 128, 60)
			helper_e8f4b85c(0)
			if vm.skipping() then
				return skip(20)
			end
			helper_2f481f12(90)
			if vm.skipping() then
				return skip(21)
			end
			if vm.wait() then
				return skip(22)
			end
			event.PlayBgm(0)
			if var0 == 1 then
				count = vm.i32(count + 2)
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "omake_sfida", tex_bank)
				event.SpriteSetPos(0, 256, 192)
				if var43 == 3 then
					event.SpriteSetUvsize(0, 162, 38, 100, 34)
					event.SpriteSetPutsize(0, 100, 34)
				elseif var43 == 5 then
					event.SpriteSetUvsize(0, 182, 38, 160, 34)
					event.SpriteSetPutsize(0, 160, 34)
				else
					event.SpriteSetUvsize(0, 182, 38, 80, 34)
					event.SpriteSetPutsize(0, 80, 34)
				end
				event.SpriteSetColor(0, 128, 128, 128, 128)
				event.SpriteSetDraw(0, 1)
				event.SpriteInit(1)
				event.SpriteSetType(1, 0)
				event.SpriteSetTexture(1, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(1, 280, 96, 28, 32)
				event.SpriteSetPos(1, 174, 224)
				event.SpriteSetPutsize(1, 28, 32)
				event.SpriteSetColor(1, 128, 128, 128, 128)
				event.SpriteSetDraw(1, 1)
				event.SpriteInit(2)
				event.SpriteSetType(2, 0)
				event.SpriteSetTexture(2, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(2, 136, 0, 104, 38)
				event.SpriteSetPos(2, 296, 224)
				event.SpriteSetPutsize(2, 104, 38)
				event.SpriteSetColor(2, 128, 128, 128, 128)
				event.SpriteSetDraw(2, 1)
				event.SpriteInit(3)
				event.SpriteSetType(3, 0)
				event.SpriteSetTexture(3, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(3, vm.i32(vm.imod(count, 10) * 28), 96, 28, 32)
				event.SpriteSetPos(3, 228, 224)
				event.SpriteSetPutsize(3, 28, 32)
				event.SpriteSetColor(3, 128, 128, 128, 128)
				event.SpriteSetDraw(3, 1)
				if vm.idiv(count, 10) > 0 then
					event.SpriteInit(4)
					event.SpriteSetType(4, 0)
					event.SpriteSetTexture(4, "omake_sfida", tex_bank)
					event.SpriteSetUvsize(4, vm.i32(vm.idiv(count, 10) * 28), 96, 28, 32)
					event.SpriteSetPos(4, 204, 224)
					event.SpriteSetPutsize(4, 28, 32)
					event.SpriteSetColor(4, 128, 128, 128, 128)
					event.SpriteSetDraw(4, 1)
				end
				while true do
					if helper_aea2bb82(0) ~= 0 then
						break
					else
						if vm.wait() then
							return skip(23)
						end
					end
				end
				var0 = event.SphidaGetNowHole() or var0
				if var0 == 8 then
					event.SphidaSetScore(-1, count)
					helper_2fbf8()
					if vm.skipping() then
						return skip(24)
					end
				end
				event.SetFadeOut(30)
				helper_2f481f12(30)
				if vm.skipping() then
					return skip(25)
				end
				event.SpriteSetDraw(0, 0)
				event.SpriteSetDraw(1, 0)
				event.SpriteSetDraw(2, 0)
			end
			event.CmrsReleaseObj()
			event.SpriteSetDraw(0, 0)
		elseif count >= 2 then
			event.SetMesWindowMode(0, 5)
			event.SetMesQuestionGyou(0, 0)
			var58 = helper_151d91c2(0, 2002, 8, 256, 208, 2, 0)
			if vm.skipping() then
				return skip(26)
			end
			if vm.wait() then
				return skip(27)
			end
			if var58 == 0 then
				do
					local out1, out2, out3, out4 = event.GetPartsFuncPos(var3, var4, var5, 100.0, "point")
					var42 = out1 or var42
					var9 = out2 or var9
					var10 = out3 or var10
					var11 = out4 or var11
				end
				if var42 == 0 then
					do
						local out1, out2, out3 = event.GetPartsOrigin(var3, var4, var5, 100.0)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
				end
				do
					local out1, out2, out3 = event.SphidaGetPinPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var26 = event.DistVector2(var9, var10, var11, pos_x, pos_y, pos_z) or var26
				if var26 < 40.0 then
					var12 = event.GetRand(6.2831855) or var12
					var12 = vm.f32(var12 - vm.f32(3.1415927))
					var9 = vm.f32(var9 + vm.f32(vm.sin(var12) * 50.0))
					var11 = vm.f32(var11 + vm.f32(vm.cos(var12) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.GetNearTboxPos(var9, var10, var11)
						var31 = out1 or var31
						var32 = out2 or var32
						var33 = out3 or var33
						var42 = out4 or var42
					end
					var47 = 0
					while var42 >= 0 do
						do
							local out1, out2, out3 = event.CopyVector(var9, var10, var11)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.SubVector(var19, var20, var21, var31, var32, var33)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						var19 = vm.f32(var19 + 1.0)
						var21 = vm.f32(var21 + 1.0)
						do
							local out1, out2, out3 = event.NormalVector(var19, var20, var21)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.ScaleVector(var19, var20, var21, 30.1)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.CopyVector(var31, var32, var33)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3 = event.AddVector(var9, var10, var11, var19, var20, var21)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3, out4 = event.GetNearTboxPos(var9, var10, var11)
							var31 = out1 or var31
							var32 = out2 or var32
							var33 = out3 or var33
							var42 = out4 or var42
						end
						var47 = var47 + 1
						if var47 > 6 then
							break
						end
					end
				end
				var7 = event.GetRefAngle(var9, var10, var11, var3, var4, var5) or var7
				event.SetCharaPos(0, var9, var10, var11)
				event.SetCharaRot(0, 0.0, var7, 0.0)
				event.SetCameraRef(var9, var10 + 30.0, var11)
				var7 = vm.f32(var7 - vm.f32(3.1415927))
				var7 = event.AngleLimit(var7) or var7
				var9 = vm.f32(vm.f32(vm.sin(var7) * 100.0) + var9)
				var10 = vm.f32(var10 + 30.0)
				var11 = vm.f32(vm.f32(vm.cos(var7) * 100.0) + var11)
				event.SetCameraPos(var9, var10, var11)
				event.ResetCamera(0)
			end
		end
	else
		event.SndSePlay(var2, 18)
		event.SetFcameraFollowFlag(0)
		event.SetCameraCtrl(0)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.ObjsSetMotion(0, "だめだめ", 6)
		event.ObjsNormalDrive(0)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "sphida_bar", tex_bank)
		event.SpriteSetUvsize(0, 334, 54, 178, 34)
		event.SpriteSetPos(0, 256, -25)
		event.SpriteSetPutsize(0, 160, 50)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.5, 8)
		helper_e8f4b85c(0)
		if vm.skipping() then
			return skip(28)
		end
		helper_2f481f12(20)
		if vm.skipping() then
			return skip(29)
		end
		event.SpriteSetDraw(0, 0)
		event.SphidaSetBallPos(var9, var10, var11)
		event.SetCharaPos(8, var9, var10, var11)
		event.SetCharaPos(9, var9, var10, var11)
		event.CmrsReleaseObj()
	end
	if var22 == 1 then
		helper_2f78c(-1)
	else
		helper_2f78c(var2)
	end
	helper_30f1c(var22, sp + junk + 59)
	if vm.skipping() then
		return skip(30)
	end
end

--- Program 3001.
script[3001] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2f78c(-1)
		end
	end
	event.Initialize()
	helper_ce8d5f8c()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	var0 = helper_151d91c2(0, 2004, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		helper_2f78c(-1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Program 3002.
script[3002] = function()
	local sp: number = 0
	local junk = 0
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_151d91c2(0, -1, 8, 0, 0, 2, 1)
		end
		if at <= 2 then
			junk += 1
		end
	end
	event.Initialize()
	helper_ce8d5f8c()
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Das ist das letzte Mal, dass du\ndie Kugel zu dir holen kannst.")
	helper_14d96446(0, -1, 8, 0, 0, sp + junk + 4)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "Die Kugel zu dir holen?")
	var0 = helper_151d91c2(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		event.SphidaSetLastChallenge(1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

--- Program 3003.
script[3003] = function()
	local var0: any = 0
	local get_now_horl: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_2fbf8()
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			if at <= 3 then
				helper_7b3cac20()
				helper_28fcc()
			end
			return
		end
		if at <= 5 then
			helper_2f481f12(30)
		end
		if at <= 6 then
			helper_3086c()
		end
	end
	event.Initialize()
	helper_ce8d5f8c()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if get_now_horl == 8 then
		event.MesMake_2(0, "Das ist das letzte Loch. Aufgeben?")
		var0 = helper_151d91c2(0, -1, 8, 0, 0, 2, 1)
		if vm.skipping() then
			return skip(1)
		end
		if var0 == 0 then
			helper_2fbf8()
			if vm.skipping() then
				return skip(2)
			end
			event.SetFadeOut(30)
			helper_2f481f12(30)
			if vm.skipping() then
				return skip(3)
			end
			helper_7b3cac20()
			helper_28fcc()
			if vm.skipping() then
				return skip(4)
			end
			return
		end
	else
		event.MesMake_2(0, "An diesem Loch aufgeben und\nzum n[UNI00e4]chsten Platz gehen?")
		var0 = helper_151d91c2(0, -1, 8, 0, 0, 2, 1)
		if vm.skipping() then
			return skip(5)
		end
		if var0 == 0 then
			event.SetFadeOut(30)
			helper_2f481f12(30)
			if vm.skipping() then
				return skip(6)
			end
			helper_3086c()
		end
	end
	if vm.wait() then
		return skip(7)
	end
	event.Finish()
end

--- Program 6000.
script[6000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_01829caf(2, 1)
			helper_2f481f12(30)
		end
	end
	event.Initialize()
	helper_2efb013d()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.BgmLoadCancel()
	event.DngSetFloorId(0)
	event.LoadDungeonMapFile("d02f01", "mstage1", 64)
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	helper_01829caf(2, 1)
	event.SphidaSetNowHole(1)
	event.SetCharaPos(0, 640.0, 0.0, 1920.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(640.0, 30.0, 1920.0)
	event.SetCameraPos(640.0, 40.0, 2020.0)
	event.SetFadeIn(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoMenu(28)
	if vm.wait() then
		return skip(4)
	end
	event.ResetCamera(0)
	event.Finish()
end

return script
