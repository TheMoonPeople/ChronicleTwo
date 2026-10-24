--!strict
-- map/i/i02/h01/i02h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0023415a = require("@lib/event/helper_0023415a")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_2a6b1824 = require("@lib/event/helper_2a6b1824")
local helper_4919d694 = require("@lib/event/helper_4919d694")
local helper_54bbe647 = require("@lib/event/helper_54bbe647")
local helper_6cc2fba1 = require("@lib/event/helper_6cc2fba1")
local helper_7af77120 = require("@lib/event/helper_7af77120")
local helper_874b82cd = require("@lib/event/helper_874b82cd")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8acd5089 = require("@lib/event/helper_8acd5089")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_a4226c93 = require("@lib/event/helper_a4226c93")
local helper_a8fbb720 = require("@lib/event/helper_a8fbb720")
local helper_b1f88208 = require("@lib/event/helper_b1f88208")
local helper_b7fd5700 = require("@lib/event/helper_b7fd5700")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_e72cbda6 = require("@lib/event/helper_e72cbda6")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_1ff90()
	local var0: s32 = 0
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 6)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.EohSyncObj_2(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -119.0, 0.0, -2000.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.EohSyncObj_3(2, "p01_train01", "train08-m0")
	event.EohSyncObj_3(3, "p01_train01", "train08-m1")
	event.EohSyncObj_3(4, "p01_train01", "train10-m0")
	event.EohSyncObj_3(5, "p01_train01", "train10-m1")
	event.EohSyncObj_3(6, "p01_train01", "train10-m12")
	event.EohSyncObj_3(7, "p01_train01", "train10-m13")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 66)
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.SetFadeIn(30)
	event.CharaActive(0)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, -1.5, 0.0, 30)
	helper_888ab2a3(20)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	helper_888ab2a3(20)
	event.EohSetFootSoundId(0, 2)
	helper_888ab2a3(10)
	event.ObjsSetMotion(0, "立ち")
	helper_888ab2a3(10)
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 0)
	event.ResetCamera(1, 3.14, 28.0)
end

--- Helper function.
local function helper_1f404()
	local var0: s32 = 0
	event.Initialize()
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj_2(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj_3(2, "p01_train01", "s3601_12-m1")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(3, "p01_train01", "s3601_14-m6")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.SetFadeIn(30)
	helper_888ab2a3(60)
	event.CharaActive(0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 92)
	helper_888ab2a3(15)
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_0958ca60(0)
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_888ab2a3(10)
	event.SetFadeIn(1)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 28.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_ba60(arg0: any)
	event.SetCrossfade(1, 1, 60)
	event.CmrsSetPos(14.46, 268.16, 737.45)
	event.CmrsSetRef(-30.4, 237.84, 510.02)
	event.CmrsMove2(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	helper_c624bc16()
	event.StopBgm(0)
	helper_888ab2a3(4)
	event.LoadBgm(193)
end

--- Helper function.
local function helper_d514(arg0: s32)
	event.CmrsSetPos(-130.02, 67.35, -2138.26)
	event.CmrsSetRef(-120.37, 83.46, -1843.2)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 6)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_c624bc16()
	event.SndSePlay(arg0, 9)
	event.SndSePlay(arg0, 10)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -116.18, 50.38, -1787.14)
	event.SetMotion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_888ab2a3(30)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.EohSyncObj_2(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.ObjsSetMotion(6, "ぶしゅー", 6)
	event.ObjsSetMotion(7, "ぶしゅー", 6)
	event.ObjsSetPos(6, -114.25, 13.26, -1653.54)
	event.ObjsSetRot(6, 0.0, 3.04, 0.0)
	event.ObjsSetPos(7, -126.53, 32.32, -1662.93)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 11)
	helper_888ab2a3(45)
	event.CharaActive(0, 40)
end

--- Helper function.
local function helper_dc7c(arg0: s32)
	event.CmrsSetPos(-326.52, 113.91, -1579.31)
	event.CmrsSetRef(-22.58, 118.56, -2134.59)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 10)
	event.SndSePlay(arg0, 12)
	event.ObjsMove(11, -200.0, 0.0, 0.0, 285)
	event.ObjsMove(12, 200.0, 0.0, 0.0, 285)
	helper_0958ca60(11)
	helper_0958ca60(12)
	helper_888ab2a3(30)
end

--- Helper function.
local function helper_dfa8(arg0: s32)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.13, 124.81, -2141.66)
	event.CmrsSetRef(-142.51, 84.44, -1891.87)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSePlay(arg0, 13)
	event.ObjsMove2(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	helper_888ab2a3(60)
end

--- Helper function.
local function helper_e270(arg0: any)
	event.CmrsInit()
	event.CmrsSetPos(-127.04, 86.04, -2182.12)
	event.CmrsSetRef(-120.48, 84.44, -1718.57)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.CmrsMove2(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.ObjsMove(10, -120.0, 0.0, -2100.0, 45)
	helper_888ab2a3(45)
end

--- Helper function.
local function helper_e584(arg0: any)
	event.CmrsSetPos(-292.76, 173.19, -1582.23)
	event.CmrsSetRef(-228.24, 151.8, -1773.02)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.ObjsMove(10, -120.0, 0.0, -3050.0, 90)
	helper_888ab2a3(90)
end

--- Helper function.
local function helper_e7cc(arg0: s32)
	event.CmrsSetPos(57.23, 251.57, 242.48)
	event.CmrsSetRef(21.23, 241.82, 43.83)
	event.CharaActive(1, 36)
	event.SetCharaPos(36, 266.91, 197.74, 696.65)
	event.SetCharaRot(36, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	event.ObjsMove(10, -120.0, 0.0, -6000.0, 120)
	helper_888ab2a3(30)
	event.CmrsMoveAhd2(-2.57, 9.27, 80.0, 120, 0, 0.4)
	helper_c624bc16()
	event.SndSeStop(arg0, 9)
end

--- Helper function.
local function helper_edd0()
	local var0: s32 = 0
	vm.section(function()
		event.SetFlag(109, 1)
		event.SetFlag(9, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(1246)
		var0 = event.SndLoadSound_2(1246) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.CharaActive(0, 0)
		event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
		event.CharaActive(1, 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.SetCharaPos(33, -251.33, 36.72, -1629.09)
		event.SetCharaRot(33, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/e100/e109/e109_vorneo.gltf", "info", 34)
		event.CharaActive(1, 34)
		event.EohSyncChara(2, 34)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.SetCharaPos(34, -251.33, 36.72, -1629.09)
		event.SetCharaRot(34, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/e100/e109/e109_tom.gltf", "info", 35)
		event.CharaActive(1, 35)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.SetCharaPos(35, -251.33, 36.72, -1629.09)
		event.SetCharaRot(35, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/e100/e109/e109_need.gltf", "info", 36)
		event.CharaActive(0, 36)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.SetCharaPos(36, -251.33, 36.72, -1629.09)
		event.SetCharaRot(36, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/e200/e202/e202_train_pika.gltf", "info", 40)
		event.CharaActive(0, 40)
		event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 38)
		event.CharaActive(0, 38)
		event.EohSyncChara(6, 38)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetPos(6, -120.0, 0.0, -1690.0)
		event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 39)
		event.CharaActive(0, 39)
		event.EohSyncChara(7, 39)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.ObjsSetPos(7, -120.0, 0.0, -1690.0)
		event.EohSyncObj_2(10, "p01_train01")
		event.ObjsInit(10)
		event.ObjsSyncObj(10, 10)
		event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
		event.EohSyncObj_3(11, "p41_i02h01", "i02h01_41-m")
		event.ObjsInit(11)
		event.ObjsSyncObj(11, 11)
		event.ObjsSetPos(11, 0.0, 0.0, 0.0)
		event.EohSyncObj_3(12, "p42_i02h01", "i02h01_42-m")
		event.ObjsInit(12)
		event.ObjsSyncObj(12, 12)
		event.ObjsSetPos(12, 0.0, 0.0, 0.0)
		event.EsmInitialize(5)
		event.EsmLoadBase("列車煙")
		event.EsmInitFix(5)
		event.LoadMes(0, 5, "event/e100/e109/e109b.txt")
		event.StopBgm(0)
		event.SndSePlay(var0, 6)
		event.EohSetSoundId(1, var0)
		event.EohSetSoundId(2, var0)
		event.EohSetSoundId(3, var0)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目パチ")
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "目パチ")
		event.InitDramaScene()
		helper_ba60(var0)
		helper_0023415a(var0)
		helper_a8fbb720(var0)
		helper_8acd5089(var0)
		helper_2a6b1824(var0)
		helper_d514(var0)
		helper_dc7c(var0)
		helper_dfa8(var0)
		helper_e270(var0)
		helper_e584(var0)
		helper_e7cc(var0)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		helper_54bbe647(var0)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.StopBgm(0)
	event.StopBgm(1)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.SndSeStop(var0, 6)
	event.SndSeStop(var0, 9)
	event.SndSeStop(var0, 10)
	event.CharaActive(1, 0)
	event.EsmClear()
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1ed64()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMotion(0, "立ち")
		event.Initialize()
		helper_125385ee(0, 4)
		event.MesMake_2(0, "中に入る\n出発する")
		at = 1
		var0 = helper_b1f88208(0, -1, 5, 256, 208, 2, 0)
		if var0 == -1 then
			helper_125385ee(0, 1)
			return 0
		end
		if var0 == 1 then
			event.SetFadeOut(15)
			at = 2
			helper_888ab2a3(15)
			event.GotoMenu(19, 0)
			at = 3
			vm.wait(3)
			event.SetFadeIn(15)
			at = 4
			helper_888ab2a3(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			helper_fbd9683d(0, 1)
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_038a2e4d(15)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_165e8(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var14: s32 = 0
	local now_map_no: s32 = 0
	local var16: s32 = 0
	event.Initialize()
	event.GetSndId(1)
	var11 = event.GetEventData_2(3) or var11
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var7) -- retail: the handler rejects 5 arguments
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", var1, "---------------\n")
	print("fpos[1]=", var2, "---------------\n")
	print("fpos[2]=", var3, "---------------\n")
	print("train_id=", var11, "---------------\n")
	event.SetWorldCoord(var1, var2, var3, var7)
	event.EohSyncObj_2(0, "p01_train01")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg0 ~= 0 then
		var4 = vm.f32(5.51)
		var5 = vm.f32(19.05)
		var6 = vm.f32(19.05)
		var14 = 6
	else
		var4 = 19.75
		var5 = 19.75
		var6 = 19.75
		var14 = 2
		now_map_no = event.GetNowMapNo() or now_map_no
		if now_map_no == 83 then
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			event.EohSetPos(0, pos_x, pos_y - 2.0, pos_z)
			var14 = 3
		end
		if now_map_no == 54 then
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
		end
	end
	if vm.imod(var11, 2) ~= 1 then
		var7 = vm.f32(-3.1415927)
	end
	if var11 == 2 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m0")
		event.EohSyncObj_3(2, "p01_train01", "train08-m1")
		event.EohSyncObj_3(3, "p01_train01", "train10-m0")
		event.EohSyncObj_3(4, "p01_train01", "train10-m1")
		event.EohSyncObj_3(5, "p01_train01", "train10-m12")
		event.EohSyncObj_3(6, "p01_train01", "train10-m13")
		event.SetCnt(0, 1)
	end
	if var11 == 3 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m2")
		event.EohSyncObj_3(2, "p01_train01", "train08-m3")
		event.EohSyncObj_3(3, "p01_train01", "train10-m3")
		event.EohSyncObj_3(4, "p01_train01", "train10-m2")
		event.EohSyncObj_3(5, "p01_train01", "train10-m15")
		event.EohSyncObj_3(6, "p01_train01", "train10-m14")
		event.SetCnt(0, 1)
	end
	if var11 == 4 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m4")
		event.EohSyncObj_3(2, "p01_train01", "train08-m5")
		event.EohSyncObj_3(3, "p01_train01", "train10-m4")
		event.EohSyncObj_3(4, "p01_train01", "train10-m5")
		event.EohSyncObj_3(5, "p01_train01", "train10-m16")
		event.EohSyncObj_3(6, "p01_train01", "train10-m17")
		event.SetCnt(0, 2)
	end
	if var11 == 5 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m6")
		event.EohSyncObj_3(2, "p01_train01", "train08-m7")
		event.EohSyncObj_3(3, "p01_train01", "train10-m6")
		event.EohSyncObj_3(4, "p01_train01", "train10-m7")
		event.EohSyncObj_3(5, "p01_train01", "train10-m18")
		event.EohSyncObj_3(6, "p01_train01", "train10-m19")
		event.SetCnt(0, 2)
	end
	if var11 == 6 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m8")
		event.EohSyncObj_3(2, "p01_train01", "train08-m9")
		event.EohSyncObj_3(3, "p01_train01", "train10-m8")
		event.EohSyncObj_3(4, "p01_train01", "train10-m9")
		event.EohSyncObj_3(5, "p01_train01", "train10-m20")
		event.EohSyncObj_3(6, "p01_train01", "train10-m21")
		event.SetCnt(0, 3)
	end
	if var11 == 7 then
		event.EohSyncObj_3(1, "p01_train01", "train08-m10")
		event.EohSyncObj_3(2, "p01_train01", "train08-m11")
		event.EohSyncObj_3(3, "p01_train01", "train10-m10")
		event.EohSyncObj_3(4, "p01_train01", "train10-m11")
		event.EohSyncObj_3(5, "p01_train01", "train10-m22")
		event.EohSyncObj_3(6, "p01_train01", "train10-m23")
		event.SetCnt(0, 3)
	end
	var16 = event.GetSndId(2) or var16
	event.SndSePlay(var16, 66)
	if vm.imod(var11, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 12.08, var4, 0.42)
		event.ObjsSetRot(0, 0.0, -1.5015928, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 46.06, -74.18)
		event.CmrsSetRef(-3.0, 50.74, 0.18)
		helper_888ab2a3(10)
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(20)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_888ab2a3(18)
		event.EohSetFootSoundId(0, 4)
		helper_888ab2a3(12)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.EohSetMotion(0, "立ち", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -12.08, var4, -0.42)
		event.ObjsSetRot(0, 0.0, 1.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 46.06, 74.18)
		event.CmrsSetRef(3.0, 50.74, -0.18)
		helper_888ab2a3(10)
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_888ab2a3(20)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_888ab2a3(18)
		event.EohSetFootSoundId(0, 4)
		helper_888ab2a3(12)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.EohSetMotion(0, "立ち", 4)
	end
	if vm.imod(var11, 2) ~= 1 then
		event.SetCharaPos(0, 65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSyncObj_2(0, "p01_train01")
	event.EohSetPos(0, pos_x, pos_y, pos_z)
end

--- Helper function.
local function helper_22300000(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var11: s32 = 0
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", var1, "---------------\n")
	print("fpos[1]=", var2, "---------------\n")
	print("fpos[2]=", var3, "---------------\n")
	print("train_id=", var11, "---------------\n")
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(18)
	helper_038a2e4d(12)
	helper_038a2e4d(30)
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(18)
	helper_038a2e4d(12)
	helper_038a2e4d(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_4919d694

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	event.Initialize()
	helper_4919d694()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -240.0, 35.8, 140.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 10 or old_map_no == 22 or old_map_no == 121 then
				event.SetCharaPos(0, 0.0, 198.8, 1450.0)
				event.SetCharaRot(0, 0.0, 3.14, 0.0)
				event.ResetCamera(1, 3.14)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 1 then
					helper_946c0402()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var4 = event.GetChapter() or var4
					if var4 ~= 6 and var4 ~= 7 then
						helper_1ff90()
					else
						helper_1f404()
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1f404

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_edd0

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		at = 1
		vm.wait(1)
		event.EohSyncObj_2(0, "p01_train01")
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		print("pos[0]=", pos_x, "-----------\n")
		print("pos[1]=", pos_y, "-----------\n")
		print("pos[2]=", pos_z, "-----------\n")
		event.EohSetPos(0, pos_x, pos_y, 0.0)
		event.CharaActive(0, 122)
		event.CharaActive(0, 123)
		event.CharaActive(0, 0)
		event.SetCameraPos(-345.21, 89.08, 234.02)
		event.SetCameraRef(-238.57, 83.73, 148.63)
		at = 2
		vm.wait(2)
		at = 3
		helper_c956b4a2(32)
		event.CharaActive(1, 122)
		event.CharaActive(1, 123)
		event.CharaActive(1, 0)
		event.EohSetPos(0, pos_x, pos_y, -1800.0)
		event.EohSetRot(0, 0.0, 3.1415927, 0.0)
		event.ResetCamera(0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				print("pos[0]=", pos_x, "-----------\n")
				print("pos[1]=", pos_y, "-----------\n")
				print("pos[2]=", pos_z, "-----------\n")
			end
			if at <= 2 then
				helper_874b82cd(32)
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	vm.wait(1)
	event.MapJump_2(-1, "m02")
	vm.wait(2)
	event.Ext(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.Ext(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.GetFlag(202) or flag
		if flag == 0 then
			at = 1
			helper_a4226c93(0, vm.f32(1.57))
			helper_125385ee(0, 1)
			event.MesMake_2(
				0,
				"これは「列車」という機械だと\nスターブルは言ってたっけ・・・<page>今はトムとボルネオさんのお家に\nなってるけど、ボクが生まれる前は\n動いてたんだって。ホントかな？"
			)
			at = 2
			helper_9e7d1511(0, -1, 5, 256, 208)
			event.MesMake_2(0, "本当にこんな大きな物が\n動くなら、見てみたいな。")
			at = 3
			helper_9e7d1511(0, -1, 5, 256, 208)
			return
		end
		at = 4
		var1 = helper_1ed64()
		if var1 ~= 1 then
			return
		end
		event.SetCnt(1, 1)
		var2 = event.GetChapter() or var2
		var3 = event.GetEventData_2(3) or var3
		if var3 <= 1 then
			if var2 ~= 6 and var2 ~= 7 then
				at = 5
				helper_cf15df04()
				event.StopBgm(0)
				at = 6
				vm.wait(6)
				event.MapJump_2(-1, "s08")
			else
				at = 7
				helper_cf15df04()
				event.StopBgm(0)
				at = 8
				vm.wait(8)
				event.MapJump_2(-1, "s37")
			end
			at = 9
			vm.wait(9)
		elseif var2 ~= 6 and var2 ~= 7 then
			at = 10
			helper_165e8(0)
			event.StopBgm(0)
			event.MapJump_2(100, "s07")
		else
			at = 11
			helper_e72cbda6()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_fbd9683d(0, 1)
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 4 then
				var1 = received[1] :: number
			end
			return 0
		end
		if at <= 11 then
			if at == 11 then
			end
			if at <= 6 then
				helper_6cc2fba1()
			end
			if at <= 9 then
				helper_22300000(0)
			end
			if at <= 10 then
				helper_b7fd5700()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	var0 = event.SearchCharaNo(2) or var0
	event.CharaActive(0, var0)
	event.SetAi(0, var0)
	helper_edd0()
	event.GotoDng(0, -1, 1000)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_7af77120

return script
