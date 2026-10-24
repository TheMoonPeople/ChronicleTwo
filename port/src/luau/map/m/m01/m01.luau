--!strict
-- map/m/m01/m01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_0bb8412f = require("@lib/event/helper_0bb8412f")
local helper_0c59fe05 = require("@lib/event/helper_0c59fe05")
local helper_10625ea5 = require("@lib/event/helper_10625ea5")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_16499da3 = require("@lib/event/helper_16499da3")
local helper_17dff7d2 = require("@lib/event/helper_17dff7d2")
local helper_19d3006e = require("@lib/event/helper_19d3006e")
local helper_1a58a941 = require("@lib/event/helper_1a58a941")
local helper_3488ae95 = require("@lib/event/helper_3488ae95")
local helper_3c69053d = require("@lib/event/helper_3c69053d")
local helper_43bab21c = require("@lib/event/helper_43bab21c")
local helper_44214ec9 = require("@lib/event/helper_44214ec9")
local helper_464b0610 = require("@lib/event/helper_464b0610")
local helper_47e094a6 = require("@lib/event/helper_47e094a6")
local helper_4f9cb005 = require("@lib/event/helper_4f9cb005")
local helper_5cfb3070 = require("@lib/event/helper_5cfb3070")
local helper_5e014937 = require("@lib/event/helper_5e014937")
local helper_6082cadd = require("@lib/event/helper_6082cadd")
local helper_684f356d = require("@lib/event/helper_684f356d")
local helper_6b3da2ca = require("@lib/event/helper_6b3da2ca")
local helper_6b43f254 = require("@lib/event/helper_6b43f254")
local helper_7cc9b820 = require("@lib/event/helper_7cc9b820")
local helper_81ec7156 = require("@lib/event/helper_81ec7156")
local helper_84e1c96f = require("@lib/event/helper_84e1c96f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_952acc1e = require("@lib/event/helper_952acc1e")
local helper_9acf546e = require("@lib/event/helper_9acf546e")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a3a848ae = require("@lib/event/helper_a3a848ae")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a4226c93 = require("@lib/event/helper_a4226c93")
local helper_a46cd0c5 = require("@lib/event/helper_a46cd0c5")
local helper_a981053a = require("@lib/event/helper_a981053a")
local helper_ab2e6ffb = require("@lib/event/helper_ab2e6ffb")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_ba4251cf = require("@lib/event/helper_ba4251cf")
local helper_beae94b8 = require("@lib/event/helper_beae94b8")
local helper_c0233b3e = require("@lib/event/helper_c0233b3e")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c319e890 = require("@lib/event/helper_c319e890")
local helper_c4aeb2aa = require("@lib/event/helper_c4aeb2aa")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c79dc3a2 = require("@lib/event/helper_c79dc3a2")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d9dc0658 = require("@lib/event/helper_d9dc0658")
local helper_e1d33012 = require("@lib/event/helper_e1d33012")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e6998a9e = require("@lib/event/helper_e6998a9e")
local helper_f266fe03 = require("@lib/event/helper_f266fe03")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")
local helper_fae3f8ff = require("@lib/event/helper_fae3f8ff")

--- Helper function.
local function helper_3ca30()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.SetFlag(800, 1)
		event.SetCameraPos(1863.34, -57.23, -1093.45)
		event.SetCameraRef(1673.6, -34.95, -1596.24)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		helper_888ab2a3(4)
		event.LoadBgm(193)
		event.PlayBgm(0)
		var0 = event.SndLoadSound_2(1261) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.ChangeDir("event/e800/e800/")
		event.LoadMes(0, 5, "e800.txt")
		if active_chr_no == 0 then
			event.LoadMotion(5, "e800_mints.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
		end
		event.LoadChara(5, "e800_need.gltf", "info", 35)
		event.CharaActive(35)
		event.EohSyncChara(2, 35)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		block = event.LoadImg_4(5, "e800.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "e80001", block)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetUvsize(0, 0, 0, 512, 448)
		event.SpriteSetPutsize(0, 512, 448)
		event.SpriteSetPos(0, 256, 224)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(3, 0)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.SpriteInit(1)
		event.SpriteSetType(1, 0)
		event.SpriteSetTexture(1, "e80002", block)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetUvsize(1, 0, 0, 512, 448)
		event.SpriteSetPutsize(1, 512, 448)
		event.SpriteSetPos(1, 256, 224)
		event.SpriteSetDraw(1, 1)
		event.EohSyncSprite(4, 1)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ChangeDir("")
		event.EohSetPos(0, 1471.93, -90.0, -1214.38)
		event.EohSetRot(0, 0.0, 2.95, 0.0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 2)
		event.EohSetPos(2, 1693.4, -48.85, -1747.04)
		event.EohSetRot(2, 0.0, -3.09, 0.0)
		event.EohSetMotion(2, "立ち", 4)
		event.EohSetFootSoundId(2, 2)
		event.InitDramaScene()
		event.CmrsInit()
		event.CmrsSetPos(1863.34, -57.23, -1093.45)
		event.CmrsSetRef(1673.6, -34.95, -1596.24)
		event.CharaActive(0)
		event.CmrsMove(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
		event.SetFadeIn(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "デフォルト顔")
		event.ObjsTexAnime(2, 1, "通常目パチ")
		helper_888ab2a3(180)
		event.ObjsSetMotion(0, "走り")
		event.ObjsMove(0, 1616.06, -90.0, -1552.76, 120, 1)
		helper_c624bc16()
		event.CmrsSetPos(1819.9, 101.8, -1573.08)
		event.CmrsSetRef(1698.78, -1.69, -1732.94)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 1607.13, -77.8, -1633.37)
		event.ObjsSetRot(0, 0.0, 2.95, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsMove(0, 1657.71, -48.85, -1704.67, 60, 1)
		event.ObjsMotionDelay(0, 60)
		event.ObjsSetMotion(0, "立ち")
		helper_888ab2a3(30)
		event.ObjsSetMotion(2, "振り向き", 6)
		event.ObjsRotation(2, 0.0, -0.33, 0.0, 20)
		event.ObjsMotionDelay(2, 20)
		event.ObjsNextMotion(2, "立ち", 4)
		helper_0958ca60(0)
		helper_888ab2a3(30)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000010)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(8000020)
		event.CmrsSetPos(1680.47, -37.85, -1706.19)
		event.CmrsSetRef(1694.26, -26.32, -1748.64)
		event.EohSetFrameShow(2, "te_l", 0)
		event.EohSetFrameShow(2, "te_r", 0)
		event.EohSetFrameShow(2, "te_gl--v0", 1)
		event.EohSetFrameShow(2, "te_gr--v0", 1)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "しんけん顔")
		event.ObjsTexAnime(2, 1, "しんけん目パチ")
		event.SetStatus(1, 0, 256, 1)
		event.ObjsSetMotion(2, "エキサイト", 6)
		event.ObjsNextMotion(2, "エキサイト戻り", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000030)
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "会話", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000035)
		event.CmrsSetPos(1819.9, 101.8, -1573.08)
		event.CmrsSetRef(1698.78, -1.69, -1732.94)
		event.EohSetFrameShow(2, "te_l", 1)
		event.EohSetFrameShow(2, "te_r", 1)
		event.EohSetFrameShow(2, "te_gl--v0", 0)
		event.EohSetFrameShow(2, "te_gr--v0", 0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsSetMotion(2, "会話", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000040)
		event.ObjsSetMotion(0, "うなづく", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		helper_e34416e2(8000050)
		event.SetStatus(1, 0, 256, 0)
		event.ObjsSetColor(3, 128, 128, 128, 128, 30)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000060)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000065)
		event.SetPakuAnim(0, "わらい口パク")
		helper_e34416e2(8000070)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000080)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000090)
		event.ObjsSetColor(3, 128, 128, 128, 0, 30)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000100)
		event.SndSePlay(var0, 0)
		event.ObjsSetMotion(0, "がっつ", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		helper_e34416e2(8000110)
		event.ObjsSetColor(4, 128, 128, 128, 128, 30)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000120)
		event.ObjsSetColor(4, 128, 128, 128, 0, 30)
		event.CmrsSetPos(1704.99, -31.99, -1684.63)
		event.CmrsSetRef(1684.93, -26.32, -1741.26)
		event.ObjsSetPos(0, 1678.13, -48.85, -1729.46)
		event.ObjsSetRot(0, 0.0, 2.95, 0.0)
		event.ObjsResetDaPosition(0)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(8000130)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.EohSetFootSoundId(0, 0)
	event.SpriteSetDraw(0, 0)
	event.DelExtMotion(0)
	event.DeleteChara(35)
	event.DelImg(0)
	event.LoadMes(0, -1)
	event.CharaActive(0)
	event.SetCharaPos(0, 1678.13, -48.85, -1729.46)
	event.SetCharaRot(0, 0.0, 2.95, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.1415927, 10.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3b974()
	event.Initialize()
	event.CharaActive(0, 0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.SetProjection(524.9)
	event.CmrsInit()
	event.CmrsSetPos(-2805.19, 378.19, -1591.92)
	event.CmrsSetRef(-2901.57, 398.3, -1620.79)
	helper_888ab2a3(30)
	event.CmrsMove(-2805.19, 378.19, -1591.92, -2902.6, 398.3, -1571.73, 300)
	vm.wait(2)
	helper_c956b4a2(32)
	event.CharaActive(1, 0)
end

--- Event 248, which map data, a script or the engine runs by number.
local function event_248()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "You can't enter here in the demo version.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesWindowMode(0, 1)
end

--- Helper function.
local function helper_424a8()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local at: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.Initialize()
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.SetMotion(0, "立ち", 4)
		event.SetMesWindowMode(0, 5)
		var0 = event.GetMenuEtc_2(1) or var0
		if var0 == 1 then
			event.MesMake_2(0, "『釣り大会会場前』に移動しますか？")
		else
			event.MesMake_2(0, "『ギョレース会場前』に移動しますか？")
		end
		print("11111111111111111111111111111111\n")
		at = 1
		var1 = helper_c190f878(0, -1, 8, 256, 208, 2, 1)
		if var1 == 0 then
			event.CmrsSetPos(1332.56, 67.86, 1494.1)
			event.CmrsSetRef(1508.0, 12.6, 1425.04)
			event.CmrsMove2(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
			end
			event.ObjsSetPos(0, var2, var3, 1415.0)
			event.ObjsSetRot(0, 0.0, 1.57, 0.0)
			event.ObjsMove(0, 1800.0, var3, 1415.0, 90)
			at = 2
			helper_888ab2a3(15)
			event.SetFadeOut(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsRotation(0, 0.0, -1.57, 0.0, 15)
		at = 4
		helper_888ab2a3(15)
		do
			local _, out2, out3 = event.GetCharaPos(0)
			var6 = out2 or var6
			var7 = out3 or var7
		end
		event.ObjsMove(0, 1480.0, var6, var7, 45)
		at = 5
		helper_888ab2a3(45)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(15)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 5 then
			if at <= 4 then
				helper_038a2e4d(45)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_216ec()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.GetQuestEtc(0, 8) or var0
	if var0 == 1 then
		var1 = event.GetCnt(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.SetCnt(12, 2)
			end
			helper_a4226c93(0, vm.f32(-1.57))
			helper_125385ee(0, 1)
			event.MesMake_2(
				0,
				"ドアに手紙がはさんである。<page>「今日のパーティーは、とろりんチーズが\n　いまいちとろりんとしないので、中止に\n　します。　　　　　　　　　　　ポーク」"
			)
			helper_a3cc6850(0, -1, 5, 256, 208)
			event.SetFuncEtc(1)
			vm.wait(3)
		end
	end
end

--- Helper function.
local function helper_40bc4()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		var0 = helper_94a172bf(5, 160)
		if var0 == 0 then
			event.SetFadeOut(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_403e8()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		vm.wait(1)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "『地下水道入り口』に移動しますか？")
		at = 2
		var0 = helper_c190f878(0, -1, 8, 0, 0, 2, 1)
		event.SetMesWindowMode(0, 1)
		if var0 == 0 then
			event.SetFadeOut(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				var0 = helper_f8bbcc57(0, -1, 8, 0, 0, 2, 1)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Event 530, which map data, a script or the engine runs by number.
local function event_530()
	event.FuncPointShow("p01_e01g01-0", "invent_36-0", 1)
	helper_a3a848ae()
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.BgmPlayCancel()
	vm.wait(2)
	event.GotoInterior(-1, "i01h01", 500, 1)
	vm.wait(3)
end

--- Helper function.
local function helper_3397c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: any = 0
	local var16: s32 = 0
	local active_chr_no: s32 = 0
	local var18: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesPreset(0, 0)
		event.SetMesShippo(0, 1)
		var2 = event.GetChapter() or var2
		var3 = event.GetEventData_2(14) or var3
		event.GetNowMapNo()
		now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
		event.CtrlcStay()
		event.SetAi(0, arg0)
		if var3 == 3 then
			at = 1
			helper_d9dc0658(arg0, arg1)
		end
		if var3 == 5 then
			at = 2
			helper_1a58a941(arg0, arg1)
		end
		if var3 == 4 then
			flag = event.GetFlag(104) or flag
			if flag == 0 then
				at = 3
				helper_16499da3()
			else
				at = 4
				helper_0bb8412f(arg0, arg1)
			end
		end
		if var3 == 7 then
			at = 5
			helper_a46cd0c5(arg0, arg1)
		end
		if var3 == 8 then
			at = 6
			helper_952acc1e(arg0, arg1)
		end
		if var3 == 10 then
			at = 7
			helper_3c69053d(arg0, arg1)
		end
		if var3 == 11 then
			at = 8
			helper_c0233b3e(arg0, arg1)
		end
		if var3 == 12 then
			var7 = event.GetQuestEtc(0, 0) or var7
			var8 = event.GetQuestEtc(0, 8) or var8
			if var7 == 2 and var8 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 9
				var9 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var9 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var9 == 1 then
					at = 10
					helper_81ec7156(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 28 then
				at = 11
				helper_16499da3()
			else
				at = 12
				helper_81ec7156(arg0, arg1)
			end
		end
		if var3 == 14 then
			at = 13
			helper_fae3f8ff(arg0, arg1)
		end
		if var3 == 15 then
			var10 = event.GetQuestEtc(0, 0) or var10
			var11 = event.GetQuestEtc(0, 10) or var11
			if var10 == 2 and var11 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 14
				var12 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var12 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var12 == 1 then
					at = 15
					helper_44214ec9(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 30 then
				at = 16
				helper_16499da3()
			else
				at = 17
				helper_44214ec9(arg0, arg1)
			end
		end
		if var3 == 16 then
			at = 18
			helper_4f9cb005(arg0, arg1)
		end
		if var3 == 17 then
			at = 19
			helper_9acf546e(arg0, arg1)
		end
		if var3 == 18 then
			var13 = event.GetQuestEtc(0, 0) or var13
			var14 = event.GetQuestEtc(0, 13) or var14
			if var13 == 2 and var14 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 20
				var15 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var15 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var15 == 1 then
					at = 21
					helper_ab2e6ffb(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 33 then
				at = 22
				helper_16499da3()
			else
				at = 23
				helper_ab2e6ffb(arg0, arg1)
			end
		end
		if var3 == 19 then
			at = 24
			helper_19d3006e(arg0, arg1)
		end
		if var3 == 20 then
			at = 25
			helper_6b3da2ca(arg0, arg1)
		end
		if var3 == 21 then
			at = 26
			helper_e1d33012(arg0, arg1)
		end
		if var3 == 23 then
			at = 27
			helper_17dff7d2(arg0, arg1)
		end
		if var3 == 24 then
			at = 28
			helper_beae94b8(arg0, arg1)
		end
		if var3 == 25 then
			at = 29
			helper_43bab21c(arg0, arg1)
		end
		if var3 == 33 then
			var16 = event.GetQuestEtc(0, 8) or var16
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if var16 == 1 and active_chr_no == 0 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "買い物させて\nこんにちは")
				at = 30
				var18 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var18 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var18 == 1 then
					at = 31
					helper_84e1c96f(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			at = 32
			helper_16499da3()
		end
		if var3 == 1 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.MesMake_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			at = 33
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 2 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.MesMake_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			at = 34
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 6 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.MesMake_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			at = 35
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 13 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.MesMake_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			at = 36
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 22 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.MesMake_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			at = 37
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		event.SetAi(1, arg0)
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 9 then
				var9 = received[1] :: number
			end
			if at <= 1 then
				helper_6b43f254(arg0, arg1)
			end
			if at <= 2 then
				helper_c4aeb2aa()
			end
			if at <= 3 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 4 then
				helper_7cc9b820(arg0, arg1)
			end
			if at <= 5 then
				helper_5e014937(arg0, arg1)
			end
			if at <= 6 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 7 then
				helper_5cfb3070(arg0, arg1)
			end
			if at <= 8 then
				var9 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		if at <= 14 then
			if at == 14 then
				var12 = received[1] :: number
			end
			if at <= 11 then
				helper_7cc9b820(arg0, arg1)
			end
			if at <= 12 then
				helper_464b0610(arg0, arg1)
			end
			if at <= 13 then
				var12 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 15 then
			return 0
		end
		if at <= 20 then
			if at == 20 then
				var15 = received[1] :: number
			end
			if at <= 16 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 17 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 18 then
				helper_c79dc3a2(arg0, arg1)
			end
			if at <= 19 then
				var15 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 21 then
			return 0
		end
		if at <= 30 then
			if at == 30 then
				var18 = received[1] :: number
			end
			if at <= 22 then
				helper_ba4251cf(arg0, arg1)
			end
			if at <= 23 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 24 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 25 then
				helper_c319e890(arg0, arg1)
			end
			if at <= 26 then
				helper_f266fe03(arg0, arg1)
			end
			if at <= 27 then
				helper_6b43f254(arg0, arg1)
			end
			if at <= 28 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 29 then
				var18 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 31 then
			return 0
		end
		if at <= 37 then
			if at <= 32 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 33 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 34 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 35 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 36 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_35d2c()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.GetEventData_2(14) or var0
		var1 = event.GetEventData_2(13) or var1
		player_chara = event.GetControlChrid() or player_chara
		if var0 <= 34 then
			at = 1
			helper_3397c(var1, player_chara)
		else
			at = 2
			helper_47e094a6()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_3488ae95()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_b8d9d9d0

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	helper_b8d9d9d0()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		flag = event.GetFlag(736) or flag
		flag_2 = event.GetFlag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.SetFadeOut(0)
			helper_3ca30()
			event.SetSavedataEtc(0, 10)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(8)
			vm.wait(2)
			event.SndInReverb(1)
			event.LoadSound(1000)
			var3 = event.GetDefBgmNo(10) or var3
			event.LoadBgm(var3)
			event.PlayBgm(0)
			event.AutoChengeBgmVol(1)
			event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
			event.ResetCamera(1, 0.0, 10.0)
			event.SetFadeIn(30)
			return
		end
		var4 = event.GetCnt(4) or var4
		if var4 == 0 then
			event.SetCharaPos(0, 560.0, 4.1, 120.0)
			event.SetCharaRot(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.SetCharaPos(0, 2095.0, 0.0, 2100.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.SetCharaPos(0, -4260.0, 350.0, 2810.0)
			event.SetCharaRot(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.SetCharaPos(0, -3770.0, 359.4, -1640.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		flag_3 = event.GetFlag(105) or flag_3
		flag_4 = event.GetFlag(109) or flag_4
		flag_5 = event.GetFlag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.GetBgmNo() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
			event.GetMasterVol()
			if var8 ~= 10 then
				event.SetFadeOut(0)
				event.LoadSound(1000)
				var8 = event.GetDefBgmNo(10) or var8
				event.StopBgm(0)
				helper_888ab2a3(4)
				event.LoadBgm(var8)
				event.PlayBgm(0)
				event.SetFlag(56, 1)
				event.AutoChengeBgmVol(1)
				event.SetFadeIn(30)
			end
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var11 = event.GetMapType(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_9dafbc83(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.ResetCamera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.GetFlag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.SetCharaPos(0, 1645.1, -41.3, -1812.6)
						event.SetCharaRot(0, 0.0, -0.09, 0.0)
						event.ResetCamera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_6082cadd()
					end
				end
				get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.SetCharaPos(0, 1450.0, 0.0, 1420.0)
					event.SetCharaRot(0, 0.0, -1.57, 0.0)
					event.ResetCamera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_e6998a9e()
				end
			end
		end
	end
	event.SetFlag(40, 0)
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_3b974

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
		return
	end
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.GotoInterior(-1, "i01h01", 100, 1)
	vm.wait(4)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local at: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		at = 1
		if helper_424a8() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.SetFadeOut(0)
			at = 2
			vm.wait(2)
			event.MapJump_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
		return
	end
	event.MapJump_2(-1, "i02h01")
	vm.wait(3)
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_211() end

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_212() end

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_213() end

--- Event 214, which map data, a script or the engine runs by number.
function script.event_214()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 215, which map data, a script or the engine runs by number.
function script.event_215()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 216, which map data, a script or the engine runs by number.
function script.event_216()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_217() end

--- Event 218, which map data, a script or the engine runs by number.
function script.event_218()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 219, which map data, a script or the engine runs by number.
function script.event_219()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 220, which map data, a script or the engine runs by number.
function script.event_220()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 221, which map data, a script or the engine runs by number.
function script.event_221()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 222, which map data, a script or the engine runs by number.
function script.event_222()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	else
		helper_216ec()
	end
end

--- Event 223, which map data, a script or the engine runs by number.
function script.event_223()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
end

script.event_248 = event_248

--- Event 290, which map data, a script or the engine runs by number.
function script.event_290()
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(800) or flag
	if flag == 0 then
		return
	end
	if helper_40bc4() ~= 0 then
		event.DngSetStageId(6)
		event.GotoMenu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var3 == 37 then
				event.BgmLoadCancel()
			end
			event.GotoDng(6, var3, 1010)
		end
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	var0 = event.GetEventData_2(15) or var0
	event.SetCnt(4, var0)
	helper_93cb8168()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var1 = event.GetCnt(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.SetCnt(7, 2)
		event.MesMake_2(0, "よし！急いでパッカーの所に戻らなきゃ。")
	else
		event.MesMake_2(0, "だまって乗ったら怒られるかな？")
	end
	helper_a3cc6850(0, -1, 5, 256, 208)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_403e8() ~= 0 then
		event.MapJump_3(-1, "d01e01", 100)
	end
end

script.event_530 = event_530

--- Event 531, which map data, a script or the engine runs by number.
function script.event_531()
	local at: number = 0
	return vm.guard(function()
		event.SetFadeOut(0)
		event.SetCameraPos(345.12, 84.74, -31.95)
		event.SetCameraRef(351.66, 70.52, 137.18)
		event.SetCharaPos(0, 350.13, 52.0, 148.02)
		event.SetCharaRot(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		at = 1
		vm.wait(1)
		event.GotoInterior(-1, "i01h01", 510, 1)
		at = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end

--- Event 540, which map data, a script or the engine runs by number.
function script.event_540()
	helper_a981053a()
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i03h01a", 500)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	event.SetCameraPos(1300.0, 50.0, 763.0)
	event.SetCameraRef(1300.0, 30.0, 968.18)
	event.SetMotion(0, "立ち")
	var1 = event.SearchCharaNo(50) or var1
	var2 = vm.i32(var1 + 1)
	event.SetAi(0, var2)
	event.SetAi(0, var1)
	event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
	helper_907fd9a8(var1, -1, 0, 0)
	event.MesMake_2(0, "おとなしく引き返した方が\n身のためだぜ。")
	helper_907fd9a8(var2, -1, 0, 0)
	event.SetFadeOut(20)
	helper_888ab2a3(20)
	event.SetCharaPos(0, 1302, 0, 951)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetAi(1, var2)
	event.SetAi(1, var1)
	event.SetFadeIn(20)
end

--- Event 560, which map data, a script or the engine runs by number.
script.event_560 = helper_b8d9d9d0

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	helper_35d2c()
end

--- Event 11051, which map data, a script or the engine runs by number.
script.event_11051 = event_530

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11052, 1)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11053, 1)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	event.SetFlag(103, 1)
	event.SetFlag(106, 0)
	event.SetFlag(107, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11060, 1)
	vm.wait(2)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_a981053a()
	event.CancelLoadVillager()
	vm.wait(2)
	event.MapJump_3(-1, "i03h01a", 500)
	vm.wait(3)
end

--- Event 18000, which map data, a script or the engine runs by number.
function script.event_18000()
	helper_3ca30()
	event.SetSavedataEtc(0, 10)
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(8)
	vm.wait(2)
	event.SndInReverb(1)
	event.LoadBgm(0)
	event.LoadSound(1000)
	event.PlayBgm(0)
	event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

return script
