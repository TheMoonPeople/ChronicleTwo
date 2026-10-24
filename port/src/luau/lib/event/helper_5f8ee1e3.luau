--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_5f8ee1e3()
	local var0: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local time: f32 = 0
	local var5: { f32 } = table.create(16, 0)
	local var21: s32 = 0
	local check_motion_end: s32 = 0
	local var23: f32 = 0
	local var24: s32 = 0
	local var25: s32 = 0
	local check_motion_end_2: s32 = 0
	local var27: f32 = 0
	local var28: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				var5[1] = vm.f32(1.46)
				var5[2] = vm.f32(2.24)
				var5[3] = 3.0
				var5[4] = vm.f32(-2.44)
				var5[5] = 3.0
				var5[6] = vm.f32(-2.48)
				var5[7] = vm.f32(-1.7)
				var5[8] = vm.f32(-0.92)
				var5[9] = vm.f32(1.46)
				var5[10] = vm.f32(2.24)
				var5[11] = 3.0
				var5[12] = vm.f32(-2.44)
				var5[13] = 3.0
				var5[14] = vm.f32(-2.48)
				var5[15] = vm.f32(-1.7)
				var5[16] = vm.f32(-0.92)
				var21 = 0
				var23 = vm.f32(var23 - vm.f32(0.4))
				var23 = vm.f32(var23 + var5[var21 + 1])
				var21 = var21 + 1
			end
			if at <= 2 then
				var25 = 0
				var27 = vm.f32(var27 - vm.f32(0.4))
				var27 = vm.f32(var27 + var5[var25 + 1])
				var25 = var25 + 1
			end
			if at <= 3 then
				var0 = 5
				var0 = var0 + 1
				helper_efffcfbb(20)
			end
			if at <= 4 then
				helper_efffcfbb(64)
			end
			if at <= 5 then
				helper_efffcfbb(4)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
		var0 = 0
		var0 = var0 + 1
		var0 = 0
		var0 = var0 + 1
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(524.9)
		event.EohSetShow(0, 1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.CharaActive(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(24)
		event.DeleteChara(13)
		var0 = 0
		while var0 < 10 do
			event.DeleteChara(14 + var0)
			var0 = var0 + 1
		end
		var0 = 0
		while var0 < 16 do
			event.DeleteChara(25 + var0)
			var0 = var0 + 1
		end
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(300.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.EohSyncObj(0, "p03_s55")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e540_canon_l.gltf", "info", 24)
	event.CharaActive(1, 24)
	event.SetCharaType(24, 4)
	event.EohSyncChara(1, 24)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e540_bakuha01.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.EohSyncChara(2, 13)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	var0 = 0
	while var0 < 10 do
		if var0 == 0 then
			event.LoadChara(5, "e540_bakuha02.gltf", "info", 14)
		else
			event.CopyChara(5, 14, 14 + var0)
		end
		event.CharaActive(1, 14 + var0)
		event.SetCharaType(14 + var0, 4)
		event.EohSyncChara(10 + var0, 14 + var0)
		event.ObjsInit(10 + var0)
		event.ObjsSyncObj(10 + var0, 10 + var0)
		value = event.GetRand(58.0) or value
		event.ObjsSetMotion(10 + var0, "爆破02", 4)
		event.ObjsNormalDrive(10 + var0)
		event.ObjsSetMotionNowTime(10 + var0, value)
		var0 = var0 + 1
	end
	event.LoadChara(5, "e540_golem.gltf", "e33a", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(3, 8)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 8, 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 8, 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(5, 10)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 8, 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(6, 11)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	var0 = 0
	while var0 < 16 do
		if var0 == 0 then
			event.LoadChara(5, "e540_canon_new.gltf", "info", 25)
		else
			event.CopyChara(5, 25, 25 + var0)
		end
		event.CharaActive(1, 25 + var0)
		event.SetCharaType(25 + var0, 4)
		event.EohSyncChara(20 + var0, 25 + var0)
		event.ObjsInit(20 + var0)
		event.ObjsSyncObj(20 + var0, 20 + var0)
		value_2 = event.GetRand(6.0) or value_2
		if var0 >= 8 then
			value_3 = event.GetRand(6.0) or value_3
			value_2 = vm.f32(value_2 + value_3)
		end
		event.ObjsSetMotion(20 + var0, "発射", 4)
		event.ObjsNormalDrive(20 + var0)
		event.ObjsSetMotionNowTime(20 + var0, value_2)
		var0 = var0 + 1
	end
	event.ChangeDir("")
	event.SetCharaPos(25, 450.35, 3680.96, 7972.66)
	event.SetCharaRot(25, 0.96, 1.46, 0.0)
	event.SetCharaPos(26, 435.87, 3680.96, 7802.53)
	event.SetCharaRot(26, 0.96, 2.24, 0.0)
	event.SetCharaPos(27, 305.04, 3680.96, 7691.47)
	event.SetCharaRot(27, 0.96, 3.0, 0.0)
	event.SetCharaPos(28, 132.67, 3680.96, 7703.67)
	event.SetCharaRot(28, 0.96, -2.44, 0.0)
	event.SetCharaPos(29, -167.88, 3680.96, 7686.37)
	event.SetCharaRot(29, 0.96, 3.0, 0.0)
	event.SetCharaPos(30, -340.18, 3680.96, 7705.62)
	event.SetCharaRot(30, 0.96, -2.48, 0.0)
	event.SetCharaPos(31, -449.71, 3680.96, 7837.29)
	event.SetCharaRot(31, 0.96, -1.7, 0.0)
	event.SetCharaPos(32, -437.68, 3680.96, 8010.44)
	event.SetCharaRot(32, 0.96, -0.92, 0.0)
	event.SetCharaPos(33, 455.83, 3604.71, 7973.68)
	event.SetCharaRot(33, 0.96, 1.46, 0.0)
	event.SetCharaPos(34, 443.35, 3603.73, 7795.28)
	event.SetCharaRot(34, 0.96, 2.24, 0.0)
	event.SetCharaPos(35, 305.48, 3604.05, 7685.46)
	event.SetCharaRot(35, 0.96, 3.0, 0.0)
	event.SetCharaPos(36, 129.93, 3603.34, 7702.09)
	event.SetCharaRot(36, 0.96, -2.44, 0.0)
	event.SetCharaPos(37, -167.88, 3602.73, 7686.37)
	event.SetCharaRot(37, 0.96, 3.0, 0.0)
	event.SetCharaPos(38, -343.8, 3601.56, 7701.06)
	event.SetCharaRot(38, 0.96, -2.48, 0.0)
	event.SetCharaPos(39, -459.5, 3600.35, 7835.23)
	event.SetCharaRot(39, 0.96, -1.7, 0.0)
	event.SetCharaPos(40, -442.8, 3599.23, 8012.61)
	event.SetCharaRot(40, 0.96, -0.92, 0.0)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func1", 1)
	event.FuncPointShow("", "func2", 1)
	event.FuncPointShow("", "func3", 1)
	event.FuncPointShow("", "func4", 1)
	event.FuncPointShow("", "func5", 1)
	event.FuncPointShow("", "func6", 1)
	event.FuncPointShow("", "func7", 1)
	event.FuncPointShow("", "func8", 1)
	event.FuncPointShow("", "func9", 1)
	event.FuncPointShow("", "func10", 1)
	event.FuncPointShow("", "func11", 1)
	event.FuncPointShow("", "func12", 1)
	event.FuncPointShow("", "func13", 1)
	event.FuncPointShow("", "func14", 1)
	event.FuncPointShow("", "func15", 1)
	event.FuncPointShow("", "func16", 1)
	helper_efffcfbb(7)
	if vm.skipping() then
		return skip(1)
	end
	time = event.GetTime() or time
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetRef(0.0, 3840.0, 8000.0)
	event.CmrsSetAhd(2.2, -260.0, 700.0)
	event.CmrsMoveAhd2(-2.2, -260.0, 700.0, 200, 0, 0.1)
	event.InitDramaScene()
	event.SetFadeIn(10)
	var5[1] = vm.f32(1.46)
	var5[2] = vm.f32(2.24)
	var5[3] = 3.0
	var5[4] = vm.f32(-2.44)
	var5[5] = 3.0
	var5[6] = vm.f32(-2.48)
	var5[7] = vm.f32(-1.7)
	var5[8] = vm.f32(-0.92)
	var5[9] = vm.f32(1.46)
	var5[10] = vm.f32(2.24)
	var5[11] = 3.0
	var5[12] = vm.f32(-2.44)
	var5[13] = 3.0
	var5[14] = vm.f32(-2.48)
	var5[15] = vm.f32(-1.7)
	var5[16] = vm.f32(-0.92)
	while true do
		var21 = 0
		while var21 < 16 do
			check_motion_end = event.CheckMotionEnd(25 + var21) or check_motion_end
			if check_motion_end == 1 then
				var23 = event.GetRand(0.8) or var23
				var23 = vm.f32(var23 - vm.f32(0.4))
				var23 = vm.f32(var23 + var5[var21 + 1])
				var23 = event.AngleLimit(var23) or var23
				event.ObjsSetRot(20 + var21, 0.96, var23, 0.0)
			end
			var21 = var21 + 1
		end
		var24 = event.CmrsCheck() or var24
		if var24 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.CmrsSetPos(-129.3, 4840.78, 7873.86)
	event.CmrsSetRef(-97.75, 4461.75, 7845.38)
	event.CmrsMove(-129.3, 4840.78, 7873.86, -97.75, 4461.75, 7845.38, 60)
	while true do
		var25 = 0
		while var25 < 16 do
			check_motion_end_2 = event.CheckMotionEnd(25 + var25) or check_motion_end_2
			if check_motion_end_2 == 1 then
				var27 = event.GetRand(0.8) or var27
				var27 = vm.f32(var27 - vm.f32(0.4))
				var27 = vm.f32(var27 + var5[var25 + 1])
				var27 = event.AngleLimit(var27) or var27
				event.ObjsRotDelay(20 + var25, 1)
				event.ObjsSetRot(20 + var25, 0.96, var27, 0.0)
			end
			var25 = var25 + 1
		end
		var28 = event.CmrsCheck() or var28
		if var28 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.CmrsSetPos(-838.46, 443.91, 6728.31)
	event.CmrsSetRef(-626.97, 456.9, 6698.64)
	event.SetCharaPos(25, 177.21, 2042.6, 7491.21)
	event.SetCharaRot(25, 0.96, 3.14, 0.0)
	event.SetCharaPos(26, 9.56, 2042.6, 7310.69)
	event.SetCharaRot(26, 0.96, -2.78, 0.0)
	event.SetCharaPos(27, 248.57, 2042.6, 7876.09)
	event.SetCharaRot(27, 0.96, 2.3, 0.0)
	event.SetCharaPos(28, 420.71, 2042.6, 7546.56)
	event.SetCharaRot(28, 0.96, -2.42, 0.0)
	event.SetCharaPos(29, -946.92, 2206.47, 7990.45)
	event.SetCharaRot(29, 0.96, 3.02, 0.0)
	var0 = 5
	while var0 < 16 do
		event.CharaActive(0, 25 + var0)
		var0 = var0 + 1
	end
	event.ObjsSetPos(10, -460.86, 489.96, 6733.35)
	event.ObjsSetRot(10, 0.0, 0.8, 0.0)
	event.ObjsSetPos(11, -90.64, 396.44, 6295.7)
	event.ObjsSetRot(11, 0.0, 0.08, 0.0)
	event.ObjsSetPos(12, -264.7, 634.72, 6998.68)
	event.ObjsSetRot(12, 0.0, 0.2, 0.0)
	event.ObjsSetPos(13, -598.43, 420.84, 6492.57)
	event.ObjsSetRot(13, 0.0, 2.28, 0.0)
	event.ObjsSetPos(14, -388.61, 444.94, 6499.41)
	event.ObjsSetRot(14, 0.0, -0.88, 0.0)
	event.ObjsSetPos(15, -413.31, 550.94, 6853.8)
	event.ObjsSetRot(15, 0.0, 0.2, 0.0)
	event.ObjsSetPos(16, -417.64, 471.91, 6610.58)
	event.ObjsSetRot(16, 0.0, -2.32, 0.0)
	event.ObjsSetPos(17, -605.07, 555.41, 6886.0)
	event.ObjsSetRot(17, 0.0, -0.4, 0.0)
	event.ObjsSetPos(18, -673.92, 519.48, 6767.61)
	event.ObjsSetRot(18, 0.0, -2.08, 0.0)
	event.ObjsSetPos(19, -831.64, 403.7, 6627.72)
	event.ObjsSetRot(19, 0.0, -0.28, 0.0)
	event.CharaActive(8)
	event.ObjsSetPos(3, -608.57, 411.25, 6691.84)
	event.ObjsSetMotion(3, "立ち（坂）", 4)
	event.ObjsMotionDelay(3, 16)
	event.ObjsSetMotion(3, "貫き", 6)
	event.ObjsNextMotion(3, "貫きループ", 4)
	event.ObjsSetPos(1, -609.01, 806.46, 6905.24)
	event.ObjsSetRot(1, 1.0, 3.14, 0.0)
	event.ObjsPosDelay(1, 10)
	event.ObjsMove(1, -606.13, 219.37, 6528.8, 14)
	event.ObjsSetPos(2, -604.04, 444.49, 6679.45)
	event.ObjsSetRot(2, 0.1, -1.36, 0.0)
	event.ObjsSetMotion(2, "爆破01", 5)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "爆破01", 4)
	event.CharaActive(10)
	event.ObjsSetPos(5, -512.25, 453.1, 6750.9)
	event.ObjsSetRot(5, 1.1, 0.0, 0.0)
	event.ObjsSetMotion(5, "立ち", 1)
	event.CharaActive(9)
	event.ObjsSetPos(4, -456.64, 452.11, 6732.83)
	event.ObjsSetMotion(4, "貫き", 6)
	event.ObjsNextMotion(4, "貫きループ", 4)
	event.CharaActive(11)
	event.ObjsSetPos(6, -717.2, 357.24, 6583.9)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "走り（坂）", 4)
	event.ObjsMove(6, -693.84, 475.24, 6889.62, 130, 1)
	helper_efffcfbb(20)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsJump(4, -494.52, 397.5, 6251.11, -0.8, 24)
	event.ObjsRotation(4, -0.8, 0.0, 0.0, 8)
	helper_efffcfbb(64)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(4)
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

return helper_5f8ee1e3
