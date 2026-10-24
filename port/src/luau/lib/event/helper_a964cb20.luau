--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_46b7514d = require("@lib/event/helper_46b7514d")
local helper_6b0b98a6 = require("@lib/event/helper_6b0b98a6")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_a964cb20()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 85 then
			if at <= 1 then
				helper_2f481f12(6)
			end
			if at <= 2 then
				helper_2f481f12(2)
			end
			if at <= 3 then
				helper_2f481f12(6)
			end
			if at <= 4 then
				helper_2f481f12(30)
			end
			if at <= 5 then
				var13 = 0
				var13 = var13 + 1
			end
			if at <= 6 then
				helper_b027b809()
			end
			if at <= 7 then
				helper_b027b809()
			end
			if at <= 8 then
				helper_2f481f12(30)
			end
			if at <= 9 then
				helper_93bb7fa4(3120010)
			end
			if at <= 10 then
				helper_e8f4b85c(0)
			end
			if at <= 11 then
				helper_93bb7fa4(3120020)
			end
			if at <= 12 then
				helper_e8f4b85c(2)
			end
			if at <= 13 then
				helper_93bb7fa4(3120030)
			end
			if at <= 14 then
				helper_b027b809()
			end
			if at <= 15 then
				helper_e8f4b85c(0)
			end
			if at <= 16 then
				helper_93bb7fa4(3120040)
			end
			if at <= 17 then
				helper_e8f4b85c(2)
			end
			if at <= 18 then
				helper_2f481f12(60)
			end
			if at <= 19 then
				helper_2f481f12(10)
			end
			if at <= 20 then
				helper_93bb7fa4(3120045)
			end
			if at <= 21 then
				helper_e8f4b85c(2)
			end
			if at <= 22 then
				helper_e8f4b85c(0)
			end
			if at <= 23 then
				helper_e8f4b85c(1)
			end
			if at <= 24 then
				helper_93bb7fa4(3120050)
			end
			if at <= 25 then
				helper_e8f4b85c(1)
			end
			if at <= 26 then
				helper_93bb7fa4(3120060)
			end
			if at <= 27 then
				helper_e8f4b85c(2)
			end
			if at <= 28 then
				helper_93bb7fa4(3120065)
			end
			if at <= 29 then
				helper_e8f4b85c(2)
			end
			if at <= 30 then
				helper_93bb7fa4(3120070)
			end
			if at <= 31 then
				helper_93bb7fa4(3120080)
			end
			if at <= 32 then
				helper_e8f4b85c(2)
			end
			if at <= 33 then
				helper_93bb7fa4(3120085)
			end
			if at <= 34 then
				helper_93bb7fa4(3120090)
			end
			if at <= 35 then
				helper_93bb7fa4(3120100)
			end
			if at <= 36 then
				helper_93bb7fa4(3120105)
			end
			if at <= 37 then
				helper_e8f4b85c(1)
			end
			if at <= 38 then
				helper_93bb7fa4(3120110)
			end
			if at <= 39 then
				helper_e8f4b85c(0)
			end
			if at <= 40 then
				helper_b027b809()
			end
			if at <= 41 then
				helper_93bb7fa4(3120120)
			end
			if at <= 42 then
				helper_b027b809()
			end
			if at <= 43 then
				helper_93bb7fa4(3120130)
			end
			if at <= 44 then
				helper_e8f4b85c(1)
			end
			if at <= 45 then
				helper_93bb7fa4(3120140)
			end
			if at <= 46 then
				helper_93bb7fa4(3120150)
			end
			if at <= 47 then
				helper_93bb7fa4(3120155)
			end
			if at <= 48 then
				helper_e8f4b85c(1)
			end
			if at <= 49 then
				helper_93bb7fa4(3120160)
			end
			if at <= 50 then
				helper_e8f4b85c(0)
			end
			if at <= 51 then
				helper_e8f4b85c(1)
			end
			if at <= 52 then
				helper_93bb7fa4(3120164)
			end
			if at <= 53 then
				helper_e8f4b85c(2)
			end
			if at <= 54 then
				helper_93bb7fa4(3120168)
			end
			if at <= 55 then
				helper_93bb7fa4(3120170)
			end
			if at <= 56 then
				helper_93bb7fa4(3120175)
			end
			if at <= 57 then
				helper_e8f4b85c(0)
			end
			if at <= 58 then
				helper_e8f4b85c(1)
			end
			if at <= 59 then
				helper_93bb7fa4(3120180)
			end
			if at <= 60 then
				helper_e8f4b85c(1)
			end
			if at <= 61 then
				helper_2f481f12(60)
			end
			if at <= 62 then
				helper_93bb7fa4(3120184)
			end
			if at <= 63 then
				helper_e8f4b85c(1)
			end
			if at <= 64 then
				helper_e8f4b85c(1)
			end
			if at <= 65 then
				helper_e8f4b85c(1)
			end
			if at <= 66 then
				helper_e8f4b85c(1)
			end
			if at <= 67 then
				helper_2f481f12(4)
			end
			if at <= 68 then
				helper_46b7514d(3120188, 160)
			end
			if at <= 69 then
				helper_e8f4b85c(1)
			end
			if at <= 70 then
				helper_93bb7fa4(3120190)
			end
			if at <= 71 then
				helper_e8f4b85c(1)
			end
			if at <= 72 then
				helper_e8f4b85c(1)
			end
			if at <= 73 then
				helper_2f481f12(6)
			end
			if at <= 74 then
				helper_46b7514d(3120195, 40)
			end
			if at <= 75 then
				helper_e8f4b85c(0)
			end
			if at <= 76 then
				helper_93bb7fa4(3120200)
			end
			if at <= 77 then
				helper_e8f4b85c(1)
			end
			if at <= 78 then
				helper_b027b809()
			end
			if at <= 79 then
				helper_93bb7fa4(3120210)
			end
			if at <= 80 then
				helper_93bb7fa4(3120220)
			end
			if at <= 81 then
				helper_e8f4b85c(1)
			end
			if at <= 82 then
				helper_93bb7fa4(3120230)
			end
			if at <= 83 then
				helper_e8f4b85c(1)
			end
			if at <= 84 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(86)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var3, 0)
		event.SndSeStop(var3, 6)
		event.SndSeStop(var3, 10)
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DelExtMotion(13)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		event.EohSetFootSoundId(0, 0)
		event.CharaActive(0)
		event.SetCharaPos(0, -25.0, 62.7, 1285.3)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.CharaActive(13)
		event.SetCharaPos(13, 68.04, 41.85, 1180.61)
		event.SetCharaRot(13, 0.0, 3.14, 0.0)
		event.SetMotion(13, "立ち", 4)
		event.CharaNormalDrive(13)
		event.CharaResetDa(13)
		event.SetCameraRef(-25.0, 92.7, 1285.3)
		event.SetCameraPos(-25.0, 102.7, 1385.3)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetFlag(312, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	if active_chr_no == 0 then
		var1 = 0
	else
		var1 = 13
	end
	var3 = event.SndLoadSound(3806) or var3
	helper_6b0b98a6(1)
	event.SphidaSetPlayFlag(0)
	event.LoadChara(4, "chara/c02_base.gltf", "info", 13)
	event.LoadEquip(4, 1, 4, "info", 13)
	event.LoadEquip(4, 1, 3, "info", 13)
	event.LoadEquip(4, 1, 2, "info", 13, 14)
	event.SetCharaNo(13, 1)
	event.LoadChara(4, "event/e300/e314/e314_bou.gltf", "info", 15)
	event.CharaActive(15)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e300/e312/")
	event.LoadMes(0, 5, "e312_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e312_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.LoadChara(5, "e312_boss.gltf", "info", 16)
	event.CharaActive(16)
	event.EohSyncChara(2, 16)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.LoadChara(5, "event/d03/p00_26a.gltf", "info", 17)
	event.CharaActive(17)
	event.EohSyncChara(3, 17)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 13)
		event.LoadEquip(5, 0, 4, "info", 13)
		event.LoadEquip(5, 0, 3, "info", 13)
		event.LoadEquip(5, 0, 2, "info", 13, 14)
		event.LoadMotion(5, "event/e300/e312/e312_mints.gltf", "info", 13)
		event.LoadMotion(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 13)
		event.EohSyncChara(0, 13)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/e300/e312/e312_monica.gltf", "info", 13)
		event.LoadMotion(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 13)
		event.EohSyncChara(1, 13)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -355.0, 30.46, 930.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(1, -338.8, 30.26, 950.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 1)
	event.EohSetPos(3, -150.0, 230.0, 1600.0)
	event.EohSetRot(3, 0.0, 3.14, 0.0)
	event.EohSetMotion(3, "飛び", 4)
	event.ObjsSePlay(3, var3, 1)
	event.ObjsSeDelay(3, 34)
	event.ObjsSePlay(3, var3, 1)
	event.EohSetPos(2, -116.0, 316.0, 235.0)
	event.EohSetRot(2, 0.0, -0.36, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFrameStatus(2, "hana", 0)
	event.SetCharaPos(15, 0.0, 0.5, -170.0)
	event.SetCharaRot(15, 0.0, 1.57, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(254.65, 473.72, 1588.47)
	event.CmrsSetRef(-219.14, 62.76, 1197.82)
	event.SndSePlay(var3, 0)
	event.SetFadeIn(30)
	var4 = -150.0
	var5 = 230.0
	var6 = 1600.0
	var7 = 0.0
	var8 = -8.0
	var9 = -10.0
	vector_x = 0.0
	vector_y = vm.f32(0.2)
	vector_z = 0.0
	var13 = 0
	while var13 < 60 do
		do
			local out1, out2, out3 = event.AddVector(var4, var5, var6, var7, var8, var9)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local out1, out2, out3 = event.AddVector(var7, var8, var9, vector_x, vector_y, vector_z)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		event.EohSetPos(3, var4, var5, var6)
		var13 = var13 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.CharaActive(0, 17)
	event.CmrsSetPos(-303.73, 9.54, 934.94)
	event.CmrsSetRef(-365.55, 6.21, 927.8)
	if active_chr_no == 0 then
		event.CharaActive(0)
	else
		event.CharaActive(13)
		event.CharaActive(14)
	end
	event.ObjsMove(0, -355.0, 0.46, 920.0, 10)
	event.ObjsSetMotion(0, "d03着地", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_2f481f12(6)
	if vm.skipping() then
		return skip(2)
	end
	if active_chr_no == 0 then
		event.CharaActive(13)
		event.CharaActive(14)
	else
		event.CharaActive(0)
	end
	event.ObjsMove(1, -338.5, 0.26, 940.0, 10)
	event.ObjsSetMotion(1, "d03着地", 6)
	helper_2f481f12(2)
	if vm.skipping() then
		return skip(3)
	end
	var14 = event.GetSndId(1) or var14
	event.SndSePlay(var14, 3)
	event.SndSePlay(var14, 2)
	helper_2f481f12(6)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var14, 2)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-359.26, 22.65, 1003.22)
	event.CmrsSetRef(-344.39, 18.85, 907.9)
	event.CmrsMove2(-372.94, 22.65, 1090.93, -287.43, 73.81, 850.46, 60, 0, 1.0)
	event.ObjsSetMotion(2, "飛び", 6)
	event.ObjsNextMotion(2, "飛びから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSeDelay(2, 24)
	event.ObjsSePlay(2, var3, 2)
	event.ObjsSeDelay(2, 34)
	event.ObjsSePlay(2, var3, 2)
	event.ObjsSeDelay(2, 34)
	event.ObjsSePlay(2, var3, 2)
	event.ObjsMove(1, -338.5, 0.26, 920.0, 30)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "立ち")
	do
		local out1, out2, out3 = event.CopyVector(-116.0, 316.0, 235.0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = event.CopyVector(-1.6666666, -3.8, 5.0)
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	do
		local out1, out2, out3 = event.CopyVector(0.0, 0.03, 0.0)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var13 = 0
	while var13 < 120 do
		do
			local out1, out2, out3 = event.AddVector(var4, var5, var6, var7, var8, var9)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local out1, out2, out3 = event.AddVector(var7, var8, var9, vector_x, vector_y, vector_z)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		event.EohSetPos(2, var4, var5, var6)
		var13 = var13 + 1
		if vm.wait() then
			return skip(6)
		end
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-344.6, 67.67, 922.14)
	event.CmrsSetRef(-336.45, 57.21, 848.5)
	event.CmrsMove2(-344.6, 67.67, 922.14, -336.45, 87.1, 848.5, 30, 2, 1.0)
	event.SndSePlay(var3, 3)
	event.ObjsSetPos(2, -329.15, 98.27, 784.46)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.ObjsMove(2, -334.07, 73.0, 828.92, 20)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_b027b809()
	if vm.skipping() then
		return skip(8)
	end
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-298.63, 146.76, 823.22)
	event.CmrsSetRef(-350.98, 51.79, 864.8)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3120010)
	if vm.skipping() then
		return skip(10)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-353.63, 9.34, 984.37)
	event.CmrsSetRef(-341.08, 50.88, 864.19)
	event.ObjsSetMotion(2, "ん？", 2)
	event.ObjsNextMotion(2, "ん？L", 4)
	helper_93bb7fa4(3120020)
	if vm.skipping() then
		return skip(12)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove2(-357.36, 10.22, 1020.11, -341.08, 44.79, 864.19, 30, 0, 1.0)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3120030)
	if vm.skipping() then
		return skip(14)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(15)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(2, "ん？戻り", 2)
	event.ObjsNextMotion(2, "上見る", 6)
	event.ObjsNextMotion(2, "上見るL", 4)
	helper_93bb7fa4(3120040)
	if vm.skipping() then
		return skip(17)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-329.49, 29.05, 893.39)
	event.CmrsSetRef(-347.8, 20.91, 923.24)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-357.36, 10.22, 1020.11)
	event.CmrsSetRef(-341.08, 44.79, 864.19)
	event.ObjsSetMotion(2, "上見る戻り", 2)
	event.ObjsNextMotion(2, "首ふる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "がっかり", 6)
	event.ObjsNextMotion(0, "がっかりL", 4)
	event.ObjsSeDelay(0, 48)
	event.ObjsSePlay(0, var3, 4)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "がっかり", 6)
	event.ObjsNextMotion(1, "がっかりＬ", 4)
	helper_93bb7fa4(3120045)
	if vm.skipping() then
		return skip(21)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(22)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-321.89, 23.1, 893.12)
	event.CmrsSetRef(-338.41, 22.0, 915.41)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120050)
	if vm.skipping() then
		return skip(25)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-304.1, 27.73, 913.73)
	event.CmrsSetRef(-351.1, 29.34, 911.38)
	event.ObjsSetPos(2, -334.88, 22.14, 859.84)
	event.ObjsMove2(2, -335.92, 5.76, 880.52, 20, 2, 0.5)
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_93bb7fa4(3120060)
	if vm.skipping() then
		return skip(27)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(2, "そっぽ向く", 6)
	event.ObjsNextMotion(2, "そっぽ向くL", 4)
	helper_93bb7fa4(3120065)
	if vm.skipping() then
		return skip(29)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-321.89, 23.1, 893.12)
	event.CmrsSetRef(-338.41, 22.0, 915.41)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120070)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-306.68, 100.95, 835.19)
	event.CmrsSetRef(-288.49, 105.02, 752.73)
	event.ObjsSetPos(2, -334.07, 73.0, 828.92)
	event.ObjsSetRot(2, 0.0, 1.08, 0.0)
	event.ObjsSetMotion(2, "指さす", 6)
	event.ObjsNextMotion(2, "指さすL", 4)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var3, 5)
	helper_93bb7fa4(3120080)
	if vm.skipping() then
		return skip(32)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var3, 6)
	event.CmrsMove2(-74.58, 155.23, -161.7, -56.39, 159.31, -244.16, 60, 2, 1.0)
	helper_93bb7fa4(3120085)
	if vm.skipping() then
		return skip(34)
	end
	helper_93bb7fa4(3120090)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSeStop(var3, 6)
	event.CmrsSetPos(-338.06, 23.01, 898.47)
	event.CmrsSetRef(-338.41, 23.92, 922.33)
	event.SndSePlay(var3, 7)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120100)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120105)
	if vm.skipping() then
		return skip(37)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsMove2(-356.43, 23.01, 899.96, -354.36, 23.92, 923.72, 20, 0, 1.0)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3120110)
	if vm.skipping() then
		return skip(39)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(40)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-354.94, 23.0, 917.61)
	event.CmrsSetRef(-338.71, 23.0, 919.34)
	event.CmrsMove2(-365.44, 23.0, 916.48, -338.71, 23.0, 919.34, 40, 2, 1.0)
	event.CharaActive(0, var1)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120120)
	if vm.skipping() then
		return skip(42)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(43)
	end
	event.SndSePlay(var3, 8)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120130)
	if vm.skipping() then
		return skip(44)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(-326.56, 30.19, 903.79)
	event.CmrsSetRef(-350.3, 22.41, 925.37)
	event.ObjsSetRot(0, 0.0, 1.7, 0.0)
	event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -1.82, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.CharaActive(var1)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3120140)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsMove2(-305.69, 31.41, 884.81, -350.3, 12.85, 925.37, 40, 0, 1.0)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120150)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120155)
	if vm.skipping() then
		return skip(48)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左上を見る", 6)
	event.ObjsNextMotion(0, "左上を見るL", 4)
	event.ObjsMotionDelay(1, 18)
	event.ObjsSetMotion(1, "右上見る", 2)
	event.ObjsNextMotion(1, "右上見るＬ", 4)
	helper_93bb7fa4(3120160)
	if vm.skipping() then
		return skip(50)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(51)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(-321.16, 73.7, 923.06)
	event.CmrsSetRef(-335.4, 87.64, 848.65)
	event.ObjsSetPos(2, -334.07, 73.0, 828.92)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "会話２", 6, 0.6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_93bb7fa4(3120164)
	if vm.skipping() then
		return skip(53)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(54)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_93bb7fa4(3120168)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsSetPos(-305.69, 31.41, 884.81)
	event.CmrsSetRef(-350.3, 12.85, 925.37)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93bb7fa4(3120170)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsSetMotion(0, "左上を見る戻り", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "右上見るもどり", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3120175)
	if vm.skipping() then
		return skip(57)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(58)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(1, "考えるうつむき", 2)
	event.ObjsNextMotion(1, "考えるうつむきＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120180)
	if vm.skipping() then
		return skip(60)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(61)
	end
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(1, "考えから待ったへ", 2)
	event.ObjsNextMotion(1, "考えから待ったへＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120184)
	if vm.skipping() then
		return skip(63)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSeDelay(0, 36)
	event.ObjsSePlay(0, var3, 9)
	event.ObjsSetMotion(1, "考えから待ったへもどり", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsMotionDelay(1, 1)
	event.ObjsSetMotion(1, "歩き")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsMove2(1, -325.31, 0.52, 964.6, 30, 1, 1.0)
	event.ObjsRotation(1, 0.0, 0.1, 0.0, 10)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(66)
	end
	event.CmrsSetPos(-344.31, 18.43, 930.21)
	event.CmrsSetRef(-293.44, 28.21, 993.72)
	event.ObjsSetPos(1, -323.37, 0.45, 957.16)
	event.ObjsSetRot(1, 0.0, 1.0, 0.0)
	event.ObjsMove(1, -250.24, 0.82, 1003.33, 60)
	event.ObjsResetDaPosition(1)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く戻り", 4)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(67)
	end
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(68)
	end
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, -253.1, 0.75, 1044.91, 40)
	event.ObjsRotation(1, 0.0, -0.07, 0.0, 8)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 160)
	event.ObjsAddPas(1, -253.1, 0.75, 1044.91)
	event.ObjsAddPas(1, -254.79, 5.38, 1089.94)
	event.ObjsAddPas(1, -256.86, 18.37, 1140.0)
	event.ObjsAddPas(1, -237.68, 31.31, 1196.62)
	event.ObjsAddPas(1, -191.4, 36.23, 1217.18)
	event.ObjsStartPas(1, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_46b7514d(3120188, 160)
	if vm.skipping() then
		return skip(69)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(70)
	end
	event.CmrsSetPos(-147.43, 50.34, 1206.83)
	event.CmrsSetRef(-186.15, 57.43, 1217.59)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93bb7fa4(3120190)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, -150.87, 40.35, 1232.05, 20)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(2.14, 80.3, 1354.88)
	event.CmrsSetRef(-0.07, 78.68, 1304.82)
	event.CmrsMove2(0.83, 65.77, 1325.2, -0.07, 67.0, 1304.82, 160, 2, 1.0)
	event.SndSePlay(var3, 10)
	event.ObjsSetPos(1, 11.14, 63.15, 1259.88)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsMove(1, 11.14, 63.15, 1292.94, 12)
	event.ObjsRotDelay(1, 6)
	event.ObjsRotation(1, 0.0, -0.81, 0.0, 6)
	event.ObjsMotionDelay(1, 12)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMotionDelay(1, 6)
	event.ObjsSetMotion(1, "下を見る", 6)
	event.ObjsNextMotion(1, "下を見るL", 4)
	event.ObjsSetPos(0, -42.37, 55.86, 1225.46)
	event.ObjsSetRot(0, 0.0, 0.5, 0.0)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMove(0, -8.78, 62.88, 1292.68, 30, 1)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(73)
	end
	helper_2f481f12(6)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsSetMotion(0, "下を見る", 6)
	event.ObjsNextMotion(0, "下を見るL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_46b7514d(3120195, 40)
	if vm.skipping() then
		return skip(75)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(76)
	end
	event.ObjsSetMotion(1, "下を見る会話", 2)
	event.ObjsNextMotion(1, "下を見るL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120200)
	if vm.skipping() then
		return skip(77)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(78)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(79)
	end
	event.SndSeStop(var3, 10)
	event.CmrsSetPos(2.14, 80.3, 1354.88)
	event.CmrsSetRef(-0.07, 78.68, 1304.82)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120210)
	if vm.skipping() then
		return skip(80)
	end
	event.CmrsSetPos(-25.77, 92.07, 1321.59)
	event.CmrsSetRef(2.71, 81.81, 1288.92)
	event.ObjsSetRot(1, 0.0, -0.09, 0.0)
	event.ObjsSetMotion(1, "下を見る戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetRot(0, 0.0, 0.14, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "下を見る戻り", 2)
	event.ObjsNextMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120220)
	if vm.skipping() then
		return skip(81)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsSetPos(2.14, 80.3, 1354.88)
	event.CmrsSetRef(-0.07, 78.68, 1304.82)
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3120230)
	if vm.skipping() then
		return skip(83)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(84)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(85)
	end
	return part2()
end

return helper_a964cb20
