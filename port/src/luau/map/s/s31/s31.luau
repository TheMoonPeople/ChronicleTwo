--!strict
-- map/s/s31/s31.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_0e547894 = require("@lib/event/helper_0e547894")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_bdaf51ab = require("@lib/event/helper_bdaf51ab")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e57c38b0 = require("@lib/event/helper_e57c38b0")
local helper_e9ab25fd = require("@lib/event/helper_e9ab25fd")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	print("map_init-------------------------\n")
	helper_4337dd96()
end

--- Helper function.
local function helper_25ca0()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.EohSyncObj_2(1, "p01_train01")
		event.EohSetPos(1, 790.0, 0.0, 3600.0)
		event.EohSetRot(1, 0.0, 1.57, 0.0)
		var0 = event.GetCnt(0) or var0
		if var0 == 0 then
			helper_946c0402()
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
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m1")
			event.EohSyncObj_3(3, "p01_train01", "s3601_14-m6")
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m1")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m")
			if var0 == 2 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m5")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m10")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m4")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m2")
			end
			if var0 == 3 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m3")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m8")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m5")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m")
			event.EohSyncObj_3(3, "p01_train01", "s3601_14-m7")
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m1")
			if var0 == 2 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m4")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m11")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m2")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m3")
			end
			if var0 == 3 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m2")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m9")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m3")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m5")
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
		at = 1
		helper_888ab2a3(30)
		event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
		at = 2
		helper_888ab2a3(20)
		if var1 == 0 then
			event.ObjsMove(0, var5, 0.0, 3500.0, 30)
		else
			event.ObjsMove(0, var5, 0.0, 3700.0, 30)
		end
		event.ObjsSetMotion(0, "走り", 4)
		event.EohSetFootSoundId(0, 6)
		at = 3
		helper_0958ca60(0)
		event.EohSetFootSoundId(0, 0)
		event.ObjsSetMotion(0, "立ち")
		at = 4
		helper_888ab2a3(10)
		event.SetFadeIn(1)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetPos(5, pos_x, pos_y, pos_z)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		helper_946c0402()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_238b5abc(0)
			end
			if at <= 3 then
				helper_038a2e4d(10)
			end
			helper_d7295df9()
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_24a44()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	event.Initialize()
	var0 = event.SndLoadSound_3(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj_2(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 190.0, 0.0, 3600.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.EohSyncObj_3(2, "p01_train01", "s3601_12-m5")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(3, "p01_train01", "s3601_14-m10")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(4, "p01_train01", "s3601_16-m4")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(5, "p01_train01", "s3601_17-m2")
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
	helper_0958ca60(1)
	helper_888ab2a3(10)
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
	helper_888ab2a3(30)
	event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	helper_888ab2a3(20)
	event.ObjsMove(0, -270.0, 0.0, 3505.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_0958ca60(0)
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_888ab2a3(10)
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
local function helper_2d750()
	vm.section(function()
		event.SetFlag(724, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.CharaActive(0, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		event.StopBgm(0)
		helper_888ab2a3(6)
		event.LoadBgm(113)
		event.PlayBgm(0)
		event.LoadSound(7829)
		event.ChangeDir("event/e700/e724/")
		event.LoadMes(0, 5, "e724.txt")
		event.LoadChara(5, "e724_sun.gltf", "info", 8)
		event.CharaActive(8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.EohSyncObj_2(1, "p01_train01")
		event.EohSyncObj_2(2, "p01_shadow-0")
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
		helper_0958ca60(0)
		event.CmrsSetPos(59.11, 9.92, 3492.87)
		event.CmrsSetRef(0.0, 17.92, 3578.09)
		event.ObjsMove(0, 0.0, 0.0, 3650.0, 80)
		event.ObjsMotionDelay(0, 80)
		event.ObjsSetMotion(0, "しょんぼり立ち")
		helper_888ab2a3(60)
		event.CmrsSetPos(60.0, 16.0, 3650.0)
		event.CmrsSetRef(0.0, 16.0, 3650.0)
		helper_0958ca60(0)
		helper_888ab2a3(10)
		event.CmrsMoveAhd2(3.14, 0.0, 60.0, 800, 0, 0.1)
		event.ObjsSetMotion(0, "顔を上に上げる", 2)
		event.ObjsNextMotion(0, "顔を上に上げるＬ", 4)
		helper_29101c9c(7240010, 180)
		helper_29101c9c(7240020, 180)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "目あき～目とじ")
		event.ObjsSetMotion(0, "顔を上から下", 2)
		event.ObjsNextMotion(0, "顔を上から下Ｌ", 4)
		helper_29101c9c(7240030, 160)
		helper_29101c9c(7240035, 140)
		helper_29101c9c(7240040, 180)
		helper_e34416e2(7240050)
		helper_c624bc16()
		event.CmrsSetPos(0.0, 33.0, 3690.0)
		event.CmrsSetRef(0.0, 13.5, 3650.0)
		helper_e34416e2(7240060)
		event.CmrsMove2(0.0, 433.0, 4490.0, 0.0, 13.5, 3650.0, 150, 1, 0.2)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "目とじ～目あき")
		event.ObjsSetMotion(0, "空を見上げる", 2)
		event.ObjsNextMotion(0, "空を見上げるＬ", 4)
		helper_29101c9c(7240070, 120)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
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

--- Helper function.
local function helper_27e1c()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		at = 1
		var0 = helper_94a172bf(3, -1)
		if var0 == 0 then
			event.SetFadeOut(20)
			at = 2
			helper_888ab2a3(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_17020()
	local now_map_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local at: number = 0
	return vm.guard(function()
		now_map_no = event.GetNowMapNo() or now_map_no
		event.Initialize()
		event.GetSndId(1)
		var5 = event.GetEventData_2(3) or var5
		event.GetEventData_2(4)
		event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
		print("train_id=", var5, "----------------\n")
		print("fpos[0]=", var1, "---------------\n")
		print("fpos[1]=", var2, "---------------\n")
		print("fpos[2]=", var3, "---------------\n")
		if var3 < 4500.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
		if now_map_no == 76 then
			if var3 < 3600.0 then
				var8 = vm.f32(1.5707964)
			else
				var8 = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 72 then
			if var3 < 4500.0 then
				var8 = vm.f32(1.5707964)
			else
				var8 = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
			var8 = vm.f32(3.1415927)
		end
		if now_map_no == 87 then
			var8 = vm.f32(2.3561945)
		end
		if now_map_no == 83 or now_map_no == 103 then
			var8 = vm.f32(1.5707964)
		end
		event.SetWorldCoord(var1, var2, var3, var8)
		var9 = 0
		if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
			var9 = 1
		end
		if var5 == 4 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m1")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m1")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m6")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m1")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m")
			event.SetCnt(0, 1)
		end
		if var5 == 5 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m7")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m1")
			event.SetCnt(0, 1)
		end
		if var5 == 2 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m5")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m3")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m10")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m2")
			event.SetCnt(0, 2)
		end
		if var5 == 3 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m4")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m2")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m11")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m3")
			event.SetCnt(0, 2)
		end
		if var5 == 6 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m3")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m5")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m8")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m4")
			event.SetCnt(0, 3)
		end
		if var5 == 7 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m2")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m4")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m9")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m5")
			event.SetCnt(0, 3)
		end
		var10 = event.GetSndId(2) or var10
		event.SndSePlay(var10, 92)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
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
		event.CmrsInit()
		var14 = 0.0
		var15 = 46.0
		if now_map_no == 34 then
			var14 = vm.f32(35.8)
		end
		if now_map_no == 16 then
			var14 = vm.f32(-7.86)
		end
		if now_map_no == 54 then
			var14 = 36.0
		end
		if now_map_no == 83 then
			var14 = vm.f32(29.22)
		end
		if now_map_no == 87 then
			var14 = -6.0
		end
		if now_map_no == 103 then
			var14 = vm.f32(-13.87)
		end
		if now_map_no == 72 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		if now_map_no == 76 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		if now_map_no == 155 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		event.ObjsSetPos(0, var15, var14, 0.0)
		event.ObjsSetRot(0, 0.0, -1.5707964, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.CmrsSetPos(148.0, 23.45, -118.4)
		event.CmrsSetRef(5.11, 26.65, 8.6)
		if now_map_no == 34 or now_map_no == 54 then
			event.CmrsSetPos(106.46, 47.9, -133.32)
			event.CmrsSetRef(5.11, 77.95, 8.6)
		end
		if now_map_no == 83 then
			event.CmrsSetPos(148.0, 35.52, -118.4)
			event.CmrsSetRef(5.11, 77.95, 8.6)
		end
		at = 1
		helper_888ab2a3(10)
		if vm.imod(var5, 2) ~= 1 then
			event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 2
				helper_888ab2a3(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
				at = 3
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
					at = 4
					helper_888ab2a3(20)
				else
					event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
					at = 5
					helper_888ab2a3(10)
				end
			end
		else
			event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 6
				helper_888ab2a3(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
				at = 7
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
					at = 8
					helper_888ab2a3(20)
				else
					event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
					at = 9
					helper_888ab2a3(10)
				end
			end
		end
		event.ObjsSetMotion(0, "走り")
		event.ObjsMove(0, -50.0, 30.0, 0.0, 45)
		var16 = 0
		if
			now_map_no == 16
			or now_map_no == 83
			or now_map_no == 87
			or now_map_no == 103
			or now_map_no == 72
			or now_map_no == 76
			or now_map_no == 155
		then
			print("てつのあしおと\n")
			var16 = 6
		end
		if now_map_no == 34 or now_map_no == 54 then
			print("いしのあしおと\n")
			var16 = 2
		end
		event.EohSetFootSoundId(0, var16)
		at = 10
		helper_888ab2a3(30)
		event.SetFadeOut(30)
		at = 11
		helper_888ab2a3(30)
		event.EohSetFootSoundId(0, 0)
		event.EohSetMotion(0, "立ち", 4)
		if vm.imod(var5, 2) ~= 1 then
			event.SetCharaPos(0, 50.0, -14.0, 0.0)
			event.SetCharaRot(0, 0.0, -1.57, 0.0)
		else
			event.SetCharaPos(0, -50.0, -14.0, 0.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if at <= 11 then
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_038a2e4d(20)
			end
			if at <= 4 then
				helper_038a2e4d(10)
			end
			if at <= 5 then
				helper_038a2e4d(20)
			end
			if at <= 6 then
				helper_038a2e4d(30)
			end
			if at <= 7 then
				helper_038a2e4d(20)
			end
			if at <= 8 then
				helper_038a2e4d(10)
			end
			if at <= 9 then
				var16 = 0
				print("てつのあしおと\n")
				var16 = 6
				print("いしのあしおと\n")
				var16 = 2
				helper_038a2e4d(30)
			end
			if at <= 10 then
				helper_038a2e4d(30)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_23c00000()
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: s32 = 0
	print("train_id=", var5, "----------------\n")
	print("fpos[0]=", var1, "---------------\n")
	print("fpos[1]=", var2, "---------------\n")
	print("fpos[2]=", var3, "---------------\n")
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	helper_038a2e4d(30)
	helper_038a2e4d(30)
end

--- Helper function.
local function helper_28068()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(600, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		event.LoadSound(7800)
		var0 = event.SndLoadSound_2(7800) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e600/")
		event.LoadMes(0, 5, "e600.txt")
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
		event.EohSyncObj_2(3, "p01_train01")
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.EohSyncObj_3(4, "p01_train01", "s3601_13-m1")
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.EohSyncObj_3(5, "p01_train01", "s3601_15-m2")
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.EohSyncObj_2(7, "p01_shadow-0")
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
			at = 1
			vm.wait(1)
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
			at = 2
			vm.wait(2)
		end
		at = 3
		helper_0958ca60(3)
		at = 4
		helper_888ab2a3(20)
		event.CmrsSetPos(407.12, 258.94, 3255.47)
		event.CmrsSetRef(609.92, 112.52, 3513.32)
		event.ObjsSetPos(3, 790.0, 0.0, 3600.0)
		event.ObjsSetRot(3, 0.0, 1.57, 0.0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CharaActive(34)
		at = 5
		helper_888ab2a3(10)
		event.SndSePlay(var0, 4)
		event.ObjsRotation2(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
		event.ObjsRotation2(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
		at = 6
		helper_888ab2a3(60)
		event.ObjsJump(0, 616.43, 0.0, 3519.44, -0.2, 20)
		event.ObjsSetMotion(0, "走り")
		event.ObjsMotionDelay(0, 4)
		event.ObjsSetMotion(0, "着地", 1)
		event.ObjsMotionDelay(0, 10)
		event.ObjsSetMotion(0, "着地", 2)
		event.ObjsNextMotion(0, "立ち", 4)
		at = 7
		helper_888ab2a3(10)
		event.ObjsJump(1, 590.55, 0.0, 3527.36, -0.2, 20)
		event.ObjsSetMotion(1, "走り")
		event.ObjsMotionDelay(1, 4)
		event.ObjsSetMotion(1, "着地", 1)
		event.ObjsMotionDelay(1, 10)
		event.ObjsSetMotion(1, "着地", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 8
		helper_0958ca60(1)
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
		at = 9
		helper_e34416e2(6000370)
		event.SetPakuAnim(1, "通常口パク")
		at = 10
		helper_e34416e2(6000380)
		at = 11
		helper_0958ca60(0)
		event.CmrsSetPos(834.25, 32.04, 3503.77)
		event.CmrsSetRef(728.22, 120.07, 3124.24)
		event.ObjsSetPos(0, 688.8, 11.3, 3250.37)
		event.ObjsSetRot(0, 0.0, -2.26, 0.0)
		event.ObjsSetMotion(0, "指さす", 4, -1.0, 1)
		event.SetPakuAnim(0, "通常口パク")
		at = 12
		helper_e34416e2(6000390)
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
		at = 13
		helper_e34416e2(6000400)
		at = 14
		helper_e34416e2(6000410)
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
		at = 15
		helper_888ab2a3(200)
		event.ObjsMove(0, -12.0, 14.0, 3000.0, 160, 1)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(1, 12.0, 14.0, 3000.0, 160, 1)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMove(2, 0.0, 9.0, 3020.0, 160, 1)
		event.ObjsSetMotion(2, "歩き")
		at = 16
		helper_0958ca60(0)
		event.CmrsSetPos(35.49, 35.66, 2985.73)
		event.CmrsSetRef(5.9, 35.78, 3001.23)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "おこり顔")
		event.EohSetTexAnim(1, 1, "おこり目パチ")
		event.ObjsSetMotion(0, "上向くL", 4, -1, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
		event.ObjsSetMotion(2, "立ち（上見）", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 17
		helper_e34416e2(6000420)
		event.CmrsSetPos(-25.58, 61.54, 2959.33)
		event.CmrsSetRef(-12.23, 37.86, 2998.16)
		event.CmrsMove2(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
		event.SetPakuAnim(0, "通常口パク")
		at = 18
		helper_e34416e2(6000430)
		event.SetPakuAnim(0, "通常口パク")
		at = 19
		helper_e34416e2(6000435)
		event.CmrsSetPos(0.0, 6.31, 3126.74)
		event.CmrsSetRef(0.0, 59.43, 2999.73)
		event.SetPakuAnim(1, "通常口パク")
		at = 20
		helper_e34416e2(6000440)
		event.ObjsSetMotion(0, "振り返る", 6)
		event.ObjsNextMotion(0, "振り返るL", 4)
		event.ObjsSeDelay(0, 10)
		event.ObjsSePlay(0, var0, 5)
		event.ObjsMotionDelay(1, 4)
		event.ObjsSetMotion(1, "上見から振り返り", 6)
		event.ObjsNextMotion(1, "上見から振り返りL", 4)
		at = 21
		helper_e34416e2(6000450)
		event.SetPakuAnim(0, "通常口パク")
		at = 22
		helper_e34416e2(6000460)
		event.SetFadeOut(30)
		at = 23
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
			local _ = var5 < 90
			local _ = var5 == 20
			var5 = var5 + 1
			var6 = 2.0
			var5 = 0
			pos_y = vm.f32(pos_y + var6)
			pos_y = vm.f32(pos_y - var6)
			var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
			local _ = var5 < 30
			local _ = vm.imod(var5, 2) == 0
			var5 = var5 + 1
		end
		if at <= 2 then
			helper_238b5abc(3)
		end
		if at <= 3 then
			helper_038a2e4d(20)
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_038a2e4d(60)
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_8cd371d7(6000370)
		end
		if at <= 9 then
			helper_8cd371d7(6000380)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_8cd371d7(6000390)
		end
		if at <= 12 then
			helper_8cd371d7(6000400)
		end
		if at <= 13 then
			helper_8cd371d7(6000410)
		end
		if at <= 14 then
			helper_038a2e4d(200)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(6000420)
		end
		if at <= 17 then
			helper_8cd371d7(6000430)
		end
		if at <= 18 then
			helper_8cd371d7(6000435)
		end
		if at <= 19 then
			helper_8cd371d7(6000440)
		end
		if at <= 20 then
			helper_8cd371d7(6000450)
		end
		if at <= 21 then
			helper_8cd371d7(6000460)
		end
		if at <= 22 then
			helper_038a2e4d(30)
		end
		return true
	end)
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
	helper_9dafbc83(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_2c8a8()
	local var0: s32 = 0
	vm.section(function()
		event.SetFlag(612, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		helper_888ab2a3(4)
		event.LoadBgm(166)
		event.PlayBgm(0)
		event.LoadSound(7811)
		var0 = event.SndLoadSound_2(7811) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.GetActiveChrNo()
		event.CharaActive(0, 0)
		event.EohSyncObj_2(4, "p01_toge-0")
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.EohSyncObj_2(5, "p01_toge-1")
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
		helper_888ab2a3(30)
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
		helper_888ab2a3(20)
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
		helper_888ab2a3(15)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.SndSeStop(var0, 0)
	event.BgmLoadCancel()
	event.CmrsInit()
	event.CharaActive(1, 0)
	event.DelImg(0)
	event.EsmClear()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event_99()
		print("start_event--------------------------------------------\n")
		mc_load = event.CheckMcLoad() or mc_load
		if mc_load == 1 then
			helper_e57c38b0()
			helper_9dafbc83(vm.f32(94.2), vm.f32(34.8), vm.f32(2842.4), 0.0)
			event.ResetCamera(1, 0.0, 20.0)
			event.SetFadeIn(30)
		else
			old_map_no = event.GetOldMapNo() or old_map_no
			var2 = event.GetMapType(old_map_no) or var2
			if var2 ~= -1 then
				if old_map_no == 77 then
					helper_e57c38b0()
					helper_9dafbc83(0.0, 80.0, 2560.0, 0.0)
					event.ResetCamera(1, 0.0, 20.0)
					event.SetFadeIn(30)
				else
					var3 = event.GetCnt(1) or var3
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var3 == 8
					then
						helper_e57c38b0()
						at = 1
						helper_25ca0()
						helper_946c0402()
						event.SetFadeIn(15)
						event.ResetCamera(1, 0.0)
					else
						at = 2
						helper_24a44()
						helper_e57c38b0()
					end
				end
			end
			event.SetMotion(0, "立ち")
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_d7295df9()
				helper_bdaf51ab()
			end
			helper_1ef0d4b2()
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_2d750

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_27e1c() ~= 0 then
		event.MapJump_2(-1, "s33")
		vm.wait(2)
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_e9ab25fd()
		if var0 ~= 1 then
			return
		end
		event.SetCnt(1, 8)
		var1 = event.GetEventData_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_cf15df04()
			event.StopBgm(0)
			at = 3
			vm.wait(3)
			event.MapJump_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_17020()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 5 then
			end
			if at <= 4 then
				helper_23c00000()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 499, which map data, a script or the engine runs by number.
script.event_499 = helper_24a44

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_4337dd96()
	helper_28068()
	helper_e57c38b0()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_2c8a8()
	event.LoadDungeonMapFile("s35")
	event.LoadScript("s35/s35.stb", 500)
	vm.wait(2)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_2d750()
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 511)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_0e547894()
	end
end

return script
