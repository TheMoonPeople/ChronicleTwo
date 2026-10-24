--!strict
-- map/s/s31/s31_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_187e6e93 = require("@lib/event/helper_187e6e93")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_2cd0005b = require("@lib/event/helper_2cd0005b")
local helper_377e162e = require("@lib/event/helper_377e162e")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_430062d3 = require("@lib/event/helper_430062d3")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_83f868da = require("@lib/event/helper_83f868da")
local helper_8c030e97 = require("@lib/event/helper_8c030e97")
local helper_8d0aeec9 = require("@lib/event/helper_8d0aeec9")
local helper_8d6f315a = require("@lib/event/helper_8d6f315a")
local helper_a269bbe8 = require("@lib/event/helper_a269bbe8")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e4882772 = require("@lib/event/helper_e4882772")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

--- Program 99.
local function program_99()
	print("map_init-------------------------\n")
	helper_4337dd96()
end

--- Helper function.
local function helper_300f8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -300.0, 0.0, 3490.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_27308()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(20)
		end
		if at <= 2 then
			helper_2386f745(0)
		end
		if at <= 3 then
			helper_c1c32f84(10)
		end
		helper_8c030e97()
	end
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_8c030e97()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	var1 = event.GetCnt(15) or var1
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m8")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		end
	else
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m7")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m11")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m9")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
		end
	end
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	var5 = 240.0
	if var0 == 2 then
		var5 = -270.0
	end
	if var0 == 3 then
		var5 = -790.0
	end
	event.CmrsInit()
	if var1 == 0 then
		event.CmrsSetPos(var5 - vm.f32(135.23), 32.86, 3321.61)
		event.CmrsSetRef(var5, 31.8, 3450.0)
	else
		event.CmrsSetPos(var5 + vm.f32(135.23), 32.86, 3878.39)
		event.CmrsSetRef(var5, 31.8, 3750.0)
	end
	event.SetFadeIn(30)
	if var1 == 0 then
		event.ObjsSetPos(0, var5, 30.0, 3580.0)
		event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	else
		event.ObjsSetPos(0, var5, 25.9, 3650.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	end
	if var1 == 0 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	end
	var6 = event.GetSndId(2) or var6
	event.SndSePlay(var6, 92)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(2)
	end
	if var1 == 0 then
		event.ObjsMove(0, var5, 0.0, 3500.0, 30)
	else
		event.ObjsMove(0, var5, 0.0, 3700.0, 30)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_8c030e97()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_260ac()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2386f745(1)
		end
		if at <= 2 then
			helper_c1c32f84(10)
		end
		if at <= 3 then
			helper_c1c32f84(30)
		end
		if at <= 4 then
			helper_c1c32f84(20)
		end
		if at <= 5 then
			helper_2386f745(0)
		end
		if at <= 6 then
			helper_c1c32f84(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 190.0, 0.0, 3600.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(1080.93, 20.56, 4488.23)
	event.CmrsSetRef(1048.27, 47.31, 4411.07)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 790.0, 0.0, 3600.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-405.22998, 32.86, 3321.61)
	event.CmrsSetRef(-270.0, 31.8, 3450.0)
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -270.0, 30.0, 3580.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -270.0, 0.0, 3505.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -270.0, 0.0, 3450.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_2edc8()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_2386f745(0)
			end
			if at <= 2 then
				helper_c1c32f84(60)
			end
			if at <= 3 then
				helper_2386f745(0)
			end
			if at <= 4 then
				helper_c1c32f84(10)
			end
			if at <= 5 then
				helper_430062d3(7240010, -1, 10)
			end
			if at <= 6 then
				helper_430062d3(7240020, -1, 10)
			end
			if at <= 7 then
				helper_430062d3(7240030, -1, 10)
			end
			if at <= 8 then
				helper_430062d3(7240040, -1, 10)
			end
			if at <= 9 then
				helper_430062d3(7240050, -1, 10)
			end
			if at <= 10 then
				helper_e5dca676()
			end
			if at <= 11 then
				helper_430062d3(7240060, -1, 10)
			end
			if at <= 12 then
				helper_07cf3e45(7240070, 120)
			end
			if at <= 13 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.CharaActive(1, 0)
		event.StopBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.BgmLoadCancel()
		event.Finish()
	end
	event.SetFlag(724, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_c1c32f84(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7829)
	event.ChangeDir("event/e700/e724/")
	event.LoadMes(0, 5, "e724_1.txt")
	event.LoadChara(5, "e724_sun.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.EohSyncObj(2, "p01_shadow-0")
	event.ChangeDir("")
	event.LoadChara(5, "event/e700/e704/kaisou_waku.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSetPos(0, 0.0, 0.0, 3500.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "呆然目パチ")
	event.EohSetShow(1, 0)
	event.EohSetShow(2, 0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.InitDramaScene()
	event.ObjsMove(0, 0.0, 0.0, 3600.0, 120)
	event.ObjsSetMotion(0, "しょんぼり歩き", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 13.49, 3735.45)
	event.CmrsSetRef(0.0, 32.22, 3509.35)
	event.CmrsCharaAttach(9, 610.7, -1)
	event.SetFadeIn(30)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(59.11, 9.92, 3492.87)
	event.CmrsSetRef(0.0, 17.92, 3578.09)
	event.ObjsMove(0, 0.0, 0.0, 3650.0, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "しょんぼり立ち")
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(60.0, 16.0, 3650.0)
	event.CmrsSetRef(0.0, 16.0, 3650.0)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMoveAhd2(3.14, 0.0, 60.0, 800, 0, 0.1)
	event.ObjsSetMotion(0, "顔を上に上げる", 2)
	event.ObjsNextMotion(0, "顔を上に上げるＬ", 4)
	helper_430062d3(7240010, -1, 10)
	if vm.skipping() then
		return skip(6)
	end
	helper_430062d3(7240020, -1, 10)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "顔を上から下", 2)
	event.ObjsNextMotion(0, "顔を上から下Ｌ", 4)
	helper_430062d3(7240030, -1, 10)
	if vm.skipping() then
		return skip(8)
	end
	helper_430062d3(7240040, -1, 10)
	if vm.skipping() then
		return skip(9)
	end
	helper_430062d3(7240050, -1, 10)
	if vm.skipping() then
		return skip(10)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 33.0, 3690.0)
	event.CmrsSetRef(0.0, 13.5, 3650.0)
	helper_430062d3(7240060, -1, 10)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsMove2(0.0, 433.0, 4490.0, 0.0, 13.5, 3650.0, 150, 1, 0.2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "空を見上げる", 2)
	event.ObjsNextMotion(0, "空を見上げるＬ", 4)
	helper_07cf3e45(7240070, 120)
	if vm.skipping() then
		return skip(13)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

--- Helper function.
local function helper_29484()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_a269bbe8(3, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(20)
		helper_c1c32f84(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1cfd0()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(0, 1)
			return 0
		end
		if at <= 3 then
			helper_c1c32f84(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_377e162e(0, 4)
	event.MesMake_2(0, "Go inside\nLeave")
	var0 = helper_83f868da(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_377e162e(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_296d0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
				pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
				pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
				var5 = var5 + 1
				var6 = 2.0
				var5 = 0
				pos_y = vm.f32(pos_y + var6)
				pos_y = vm.f32(pos_y - var6)
				var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
				var5 = var5 + 1
			end
			if at <= 2 then
				helper_2386f745(3)
			end
			if at <= 3 then
				helper_c1c32f84(20)
			end
			if at <= 4 then
				helper_c1c32f84(10)
			end
			if at <= 5 then
				helper_c1c32f84(60)
			end
			if at <= 6 then
				helper_c1c32f84(10)
			end
			if at <= 7 then
				helper_2386f745(1)
			end
			if at <= 8 then
				helper_42c67f56(6000370)
			end
			if at <= 9 then
				helper_42c67f56(6000380)
			end
			if at <= 10 then
				helper_2386f745(0)
			end
			if at <= 11 then
				helper_42c67f56(6000390)
			end
			if at <= 12 then
				helper_42c67f56(6000400)
			end
			if at <= 13 then
				helper_42c67f56(6000410)
			end
			if at <= 14 then
				helper_c1c32f84(200)
			end
			if at <= 15 then
				helper_2386f745(0)
			end
			if at <= 16 then
				helper_42c67f56(6000420)
			end
			if at <= 17 then
				helper_42c67f56(6000430)
			end
			if at <= 18 then
				helper_42c67f56(6000435)
			end
			if at <= 19 then
				helper_42c67f56(6000440)
			end
			if at <= 20 then
				helper_42c67f56(6000450)
			end
			if at <= 21 then
				helper_42c67f56(6000460)
			end
			if at <= 22 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		helper_2cd0005b(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetShow(7, 1)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetPos(3, 790.0, 0.0, 3600.0)
		event.EohSetRot(3, 0.0, 1.57, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.CharaActive(0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
		helper_2cd0005b(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(7800)
	var0 = event.SndLoadSound(7800) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e600/")
	event.LoadMes(0, 5, "e600_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e600_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e600_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e600_osmond.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e600_hikari.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.LoadChara(5, "e600_nagare.gltf", "info", 36)
	event.CharaActive(1, 36)
	event.EohSyncChara(6, 36)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.EohSyncObj(3, "p01_train01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "s3601_13-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "s3601_15-m2")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(7, "p01_shadow-0")
	event.EohSetPos(0, 593.01, 30.8, 3553.84)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 583.22, 30.8, 3557.92)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 588.09, 30.8, 3562.57)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 16)
	event.EohSetPos(3, -6000.0, 2400.0, 1600.0)
	event.EohSetRot(3, 0.2, 1.2, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(7, 0)
	event.EohSetPos(6, -6000.0, 2480.0, 1600.0)
	event.EohSetRot(6, 0.2, 1.2, 0.0)
	event.EohSetMotion(6, "ループ", 4)
	event.SetCharaPos(35, -6000.0, 2400.0, 1600.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1067.88, 491.78, 4477.15)
	event.CmrsSetRef(432.94, 580.78, 4182.04)
	event.CmrsMove2(1067.88, 491.78, 4477.15, 858.72, 267.72, 3985.84, 90, 2, 1.0)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.SetFadeIn(30)
	event.ObjsRotation2(3, 0.0, 1.57, 0.0, 60, 2, 1.0)
	event.ObjsRotation2(6, 0.0, 1.57, 0.0, 60, 2, 1.0)
	var5 = 0
	while var5 < 90 do
		if var5 == 20 then
			event.SetCharaShow(35, 0, 1, 0.033333335)
			event.SetCharaShow(36, 0, 1, 0.033333335)
		end
		if vm.wait() then
			return skip(1)
		end
		do
			local out1, out2, out3 = event.EohGetPos(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
		pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		event.EohSetPos(6, pos_x, pos_y + 80.0, pos_z)
		var5 = var5 + 1
	end
	event.ObjsMove2(3, 790.0, 0.0, 3600.0, 30, 2, 1.0)
	event.ObjsRotation(3, 0.0, 1.57, 0.0, 30)
	event.ObjsMove2(6, 790.0, 0.0, 3680.0, 30, 2, 1.0)
	event.ObjsRotation(6, 0.0, 1.57, 0.0, 30)
	var6 = 2.0
	var5 = 0
	while var5 < 30 do
		do
			local out1, out2, out3 = event.EohGetPos(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if vm.imod(var5, 2) == 0 then
			pos_y = vm.f32(pos_y + var6)
		else
			pos_y = vm.f32(pos_y - var6)
		end
		var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		var5 = var5 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_2386f745(3)
	if vm.skipping() then
		return skip(3)
	end
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(407.12, 258.94, 3255.47)
	event.CmrsSetRef(609.92, 112.52, 3513.32)
	event.ObjsSetPos(3, 790.0, 0.0, 3600.0)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 4)
	event.ObjsRotation2(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
	event.ObjsRotation2(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsJump(0, 616.43, 0.0, 3519.44, -0.2, 20)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 4)
	event.ObjsSetMotion(0, "着地", 1)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "着地", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsJump(1, 590.55, 0.0, 3527.36, -0.2, 20)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "着地", 1)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "着地", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(734.79, 34.32, 3415.62)
	event.CmrsSetRef(645.05, 7.39, 3483.16)
	event.ObjsSetPos(0, 678.03, 0.0, 3463.04)
	event.ObjsSetRot(0, 0.0, 2.18, 0.0)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1, 1)
	event.ObjsMove(0, 732.73, 0.0, 3421.88, 90)
	event.ObjsResetDaPosition(0)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, 623.2, 0.0, 3468.36)
	event.ObjsSetRot(1, 0.0, 2.9, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 604.19, 0.0, 3501.3)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6000370)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(6000380)
	if vm.skipping() then
		return skip(10)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(834.25, 32.04, 3503.77)
	event.CmrsSetRef(728.22, 120.07, 3124.24)
	event.ObjsSetPos(0, 688.8, 11.3, 3250.37)
	event.ObjsSetRot(0, 0.0, -2.26, 0.0)
	event.ObjsSetMotion(0, "指さす", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6000390)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(616.62, 51.57, 3428.73)
	event.CmrsSetRef(613.93, 8.94, 3476.66)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
	event.ObjsSetRot(1, 0.0, -2.9, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(2, "歩き（上見）")
	event.ObjsMove(2, 603.8, 0.0, 3472.38, 60)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち（上見）")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(6000400)
	if vm.skipping() then
		return skip(13)
	end
	helper_42c67f56(6000410)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 995.95, 3461.49)
	event.CmrsSetRef(0.0, 846.5, 1987.55)
	event.CmrsMove2(0.0, 25.08, 3461.49, 0.0, 392.85, 1987.55, 120, 0, 1.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.EohSetFootSoundId(2, 2)
	event.ObjsSetPos(0, -12.0, 0.0, 3300.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetPos(1, 12.0, 0.0, 3300.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 3320.0)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	helper_c1c32f84(200)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsMove(0, -12.0, 14.0, 3000.0, 160, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(1, 12.0, 14.0, 3000.0, 160, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(2, 0.0, 9.0, 3020.0, 160, 1)
	event.ObjsSetMotion(2, "歩き")
	helper_2386f745(0)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(35.49, 35.66, 2985.73)
	event.CmrsSetRef(5.9, 35.78, 3001.23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上向くL", 4, -1, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
	event.ObjsSetMotion(2, "立ち（上見）", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(6000420)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-25.58, 61.54, 2959.33)
	event.CmrsSetRef(-12.23, 37.86, 2998.16)
	event.CmrsMove2(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6000430)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6000435)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(0.0, 6.31, 3126.74)
	event.CmrsSetRef(0.0, 59.43, 2999.73)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(6000440)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 5)
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "上見から振り返り", 6)
	event.ObjsNextMotion(1, "上見から振り返りL", 4)
	helper_42c67f56(6000450)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6000460)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_2df20()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_c1c32f84(20)
			end
			if at <= 3 then
				helper_c1c32f84(15)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.BgmLoadCancel()
		event.CmrsInit()
		event.CharaActive(1, 0)
		event.DelImg(0)
		event.EsmClear()
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(166)
	event.PlayBgm(0)
	event.LoadSound(7811)
	var0 = event.SndLoadSound(7811) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.CharaActive(0, 0)
	event.EohSyncObj(4, "p01_toge-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_toge-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EsmInitialize(5)
	event.EsmLoadBase("e612砂煙")
	event.EsmInitFix(5)
	event.EohSetPos(4, 674.4, -314.4, 2807.93)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 1)
	event.EohSetPos(5, -998.0, -343.6, 2925.65)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(5, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1225.24, 296.8, 2174.0)
	event.CmrsSetRef(1176.18, 319.43, 2038.46)
	event.CmrsQuake(0.0, 2.4, 0.2, -1)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(674.4, 40.0, 2807.93)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(861.02, 134.12, 2949.14)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(643.56, 119.57, 2978.62)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.CmrsSetPos(936.44, 592.45, 3336.76)
	event.CmrsSetRef(714.95, 229.99, 2890.91)
	event.SndSePlay(var0, 1)
	event.ObjsMove(4, 674.4, 40.0, 2807.93, 10)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-1432.81, 435.38, 3449.66)
	event.CmrsSetRef(-1123.85, 241.13, 3144.02)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1252.94, 0.8, 3245.52)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1008.78, 0.4, 3092.24)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1174.3, 0.78, 2981.77)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.SndSePlay(var0, 1)
	event.ObjsMove(5, -998.0, 9.62, 2925.65, 10)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_25e64()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_377e162e(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "I'll wait for you here.\nI hope it all goes well.")
	else
		event.MesMake_2(0, "I'll wait here.\nMake sure you get him.")
	end
	helper_8d6f315a(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8c030e97()
			helper_260ac()
		end
		helper_300f8()
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_300f8()
		helper_2cd0005b(vm.f32(94.2), vm.f32(34.8), vm.f32(2842.4), 0.0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 77 then
				helper_300f8()
				helper_2cd0005b(0.0, 80.0, 2560.0, 0.0)
				event.ResetCamera(1, 0.0, 20.0)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 8 then
					helper_300f8()
					helper_27308()
					if vm.skipping() then
						return skip(1)
					end
					helper_8c030e97()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					helper_260ac()
					if vm.skipping() then
						return skip(2)
					end
					helper_300f8()
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2edc8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_29484()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s33")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			helper_8d0aeec9()
		end
	end
	var0 = helper_1cfd0()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 8)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_e4882772()
		if vm.skipping() then
			return skip(2)
		end
		event.StopBgm(0)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s37")
		if vm.wait() then
			return skip(4)
		end
	else
		helper_8d0aeec9()
		if vm.skipping() then
			return skip(5)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_187e6e93()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 499.
script[499] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_260ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_300f8()
	end
	helper_4337dd96()
	helper_296d0()
	if vm.skipping() then
		return skip(1)
	end
	helper_300f8()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2df20()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s35")
	event.LoadScript("s35/s35.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2edc8()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 511)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_25e64()
		if vm.skipping() then
			return skip(1)
		end
	end
end

return script
