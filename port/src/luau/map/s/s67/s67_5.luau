--!strict
-- map/s/s67/s67_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_10eb8()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
		active_chr_no = 1
	end
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 41)
		event.LoadEquip(5, 1, 0, "info", global1, 42)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 41)
		event.LoadEquip(5, 0, 0, "info", global0, 42)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(2, 35)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e700/e732/e732_dark.gltf", "info", 36, 1)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(3, 36)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncObj_2(6, "p06_d06b03-0")
	event.ObjsSyncObj(4, 6)
	event.ObjsSetPos(4, 0.0, 20065.8, 9390.18)
	event.EohSetScale(6, 6.0, 6.0, 6.0)
	event.LoadChara(5, "event/e700/e732/e732_dedeath.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e700/e732/e732_moonbreak_f1.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.LoadChara(5, "event/e700/e732/e732_moonbreak_f2.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.LoadChara(5, "event/e700/e732/e732_moonbreak_h.gltf", "info", 45)
	event.CharaActive(0, 45)
	event.LoadChara(5, "event/e700/e732/e732_moonbreak_light.gltf", "info", 46)
	event.CharaActive(0, 46)
	event.EohSyncChara(7, 46)
	event.ObjsInit(5, 46)
	event.ObjsSyncObj(5, 7)
	event.LoadChara(5, "event/e700/e732/e700_a_hikari.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ７３２光雨")
	event.EsmInitFix(5)
	event.CharaActive(1, 41)
	event.CharaActive(1, 42)
	event.LoadMes(0, 5, "event/e700/e732/e732_1.txt")
end

--- Helper function.
local function helper_22300000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_108bc()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
		event.DeleteChara(41)
		event.DeleteChara(42)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
		event.DeleteChara(41)
		event.DeleteChara(42)
	end
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(33)
	event.DeleteChara(39)
	event.EohSetScale(6, 1.0, 1.0, 1.0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_1276c()
	local var4: s32 = 0
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(732, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(35)
		event.LoadBgm(113)
		event.LoadSound(7839)
		var4 = event.SndLoadSound_2(7839) or var4
		helper_10eb8()
		projection = event.GetProjection() or projection
		event.InitDramaScene()
		event.EohSetFootSoundId(0, 2)
		event.EohSetFootSoundId(1, 2)
		event.CharaActive(0, 41)
		event.CharaActive(0, 42)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "くるし目パチ")
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.CmrsSetPos(1.74, 7.93, -125.36)
		event.CmrsSetRef(0.0, 45.32, 0.0)
		event.ObjsSetPos(2, 0.0, 0.0, -355.97)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSetPos(3, 0.0, 0.0, 0.0)
		event.ObjsSetRot(3, 0.0, 3.12, 0.0)
		event.ObjsSetPos(0, -11.44, 0.0, -59.19)
		event.ObjsSetRot(0, 0.0, 0.12, 0.0)
		event.ObjsSetPos(1, 15.8, 0.0, -56.73)
		event.ObjsSetRot(1, 0.0, -0.12, 0.0)
		event.ObjsSetMotion(3, "ぐふう", 4)
		event.ObjsSetMotion(0, "上見構え", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上見構え", 4, -1.0, 1)
		event.CharaActive(1, 41)
		event.CharaActive(1, 42)
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 1)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 1)
		event.SetFadeIn(30)
		at = 2
		helper_25abe6d2(15)
		event.ObjsSetMotion(2, "倒れ", 4)
		at = 3
		helper_c28d4a31(7320010, -1)
		at = 4
		helper_25abe6d2(15)
		event.EohSetFrameShow(5, "skin4", 0)
		event.SetCharaPos(38, 0.0, 0.0, 0.0)
		event.SetCharaRot(38, 0.0, 0.0, 0.0)
		event.SetMotion(38, "立ち")
		event.CharaActive(1, 38)
		event.CmrsSetPos(20.77, 31.1, -40.75)
		event.CmrsSetRef(-2.9, 53.83, -8.05)
		event.CmrsMove2(88.65, 1.66, -134.55, -2.9, 53.83, -8.05, 150, 2, 1.0)
		at = 5
		helper_c28d4a31(7320020, -1)
		at = 6
		helper_c624bc16()
		at = 7
		helper_c28d4a31(7320030, -1)
		event.SetMotion(38, "笑い", 2, -1, 1)
		event.SetCharaShow(36, 0, 1, 0.025)
		event.SndSePlay(var4, 0)
		at = 8
		helper_25abe6d2(270)
		event.CharaActive(0, 41)
		event.CharaActive(0, 42)
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 0)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 0)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.SndSePlay(var4, 1)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(27.9, 77.1, 17.22, 55.5, -0.18, -47.34)
		event.CmrsAddPas(-22.28, 77.1, -4.23, 5.32, -0.18, -68.79)
		event.CmrsStartPas()
		event.SetCrossfade(30)
		at = 9
		helper_c624bc16()
		event.CmrsSetPos(2.09, 7.26, -118.61)
		event.CmrsSetRef(1.46, 36.09, -47.77)
		event.SetCrossfade(30)
		at = 10
		helper_25abe6d2(60)
		event.ObjsSetMotion(0, "左・振り返り", 6)
		event.ObjsNextMotion(0, "左・振り返りL")
		at = 11
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsSetMotion(1, "走り", 4)
		event.CmrsSetPos(-159.57, 241.29, -121.7)
		event.CmrsSetRef(-16.11, 35.13, -290.72)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, -30.95, 0.0, -223.57)
		event.ObjsAddPas(0, -29.63, 0.0, -334.52)
		event.ObjsStartPas(0)
		event.ObjsInitPas(1)
		event.ObjsSetPasFrm(1, 60)
		event.ObjsAddPas(1, 25.19, 0.0, -188.89)
		event.ObjsAddPas(1, 12.96, 0.0, -294.16)
		event.ObjsStartPas(1)
		at = 12
		helper_0958ca60(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "心配顔")
		event.ObjsTexAnime(0, 1, "心配目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "心配顔")
		event.ObjsTexAnime(1, 1, "心配目パチ")
		event.PlayBgm(0)
		event.ObjsSetPos(0, -16.72, 0.0, -361.54)
		event.ObjsSetRot(0, 0.0, 2.17, 0.0)
		event.ObjsSetPos(1, 21.91, 0.0, -350.53)
		event.ObjsSetRot(1, 0.0, -2.19, 0.0)
		event.ObjsSetMotion(0, "しゃがむL", 4)
		event.ObjsSetMotion(1, "しゃがみL", 4)
		event.CmrsSetPos(-34.54, 58.66, -391.76)
		event.CmrsSetRef(-3.33, 7.63, -413.95)
		event.CmrsMove2(-33.16, 58.66, -340.34, -1.95, 7.63, -362.53, 150, 2, 1.0)
		at = 13
		helper_c624bc16()
		event.ObjsSetMotion(2, "ユリス見る", 2)
		event.ObjsNextMotion(2, "ユリス見る会話", 2)
		event.ObjsNextMotion(2, "ユリス見るL", 4)
		at = 14
		helper_c28d4a31(7320040, -1)
		at = 15
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "ユリス見る会話", 2)
		event.ObjsNextMotion(2, "ユリス見るL", 4)
		at = 16
		helper_c28d4a31(7320050, -1)
		at = 17
		helper_25abe6d2(30)
		event.CmrsSetPos(-16.35, 40.86, -345.71)
		event.CmrsSetRef(-1.17, 7.63, -374.58)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "くるし目あき～目とじ")
		event.ObjsSetMotion(2, "ユリス見る戻り", 2)
		event.ObjsNextMotion(2, "倒れ会話", 2)
		event.ObjsNextMotion(2, "倒れ", 4)
		at = 18
		helper_c28d4a31(7320060, -1)
		at = 19
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "起きる", 2)
		event.ObjsNextMotion(2, "起きるL", 4)
		at = 20
		helper_25abe6d2(20)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "心配顔")
		event.ObjsTexAnime(0, 1, "心配目～通常目")
		event.ObjsTexAnime(0, 1, "半口")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "心配顔")
		event.ObjsTexAnime(1, 1, "心配目～通常目")
		event.ObjsTexAnime(1, 1, "半口")
		event.SndSePlay(var4, 2)
		event.ObjsSetMotion(0, "サン・起きあがる", 6)
		event.ObjsNextMotion(0, "サン・起きあがるL")
		event.ObjsSetMotion(1, "サン立つ", 6)
		event.ObjsNextMotion(1, "サン立つL")
		event.CmrsSetPos(-0.48, 7.35, -418.26)
		event.CmrsSetRef(-0.27, 7.63, -374.61)
		at = 21
		helper_c28d4a31(7320062, -1)
		at = 22
		helper_25abe6d2(30)
		at = 23
		helper_0958ca60(2)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "無表情")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.ObjsSetMotion(2, "上向き歩き", 4)
		event.ObjsSetMotion(0, "右見る", 4)
		event.ObjsSetMotion(1, "しゃがみ左見る", 4)
		event.CmrsSetPos(0.81, 64.97, -80.15)
		event.CmrsSetRef(0.0, 8.4, -355.97)
		event.ObjsInitPas(2)
		event.ObjsSetPasFrm(2, 540)
		event.ObjsAddPas(2, 0.0, 0.0, -300.97)
		event.ObjsAddPas(2, 0.0, 0.0, -132.95)
		event.ObjsStartPas(2)
		event.CmrsMoveRef(0.0, 8.4, -182.95, 540)
		at = 24
		helper_c28d4a31(7320070, -1)
		at = 25
		helper_25abe6d2(15)
		at = 26
		helper_c28d4a31(7320080, -1)
		at = 27
		helper_25abe6d2(15)
		at = 28
		helper_c624bc16()
		event.ObjsSetMotion(2, "上向くL", 4)
		event.ObjsSetPos(2, 0.0, 0.0, 0.0)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.SetProjection(200.0)
		event.CmrsSetPos(-2.12, 16.61, -87.09)
		event.CmrsSetRef(-0.05, 86.09, 255.81)
		event.ObjsSetMotion(2, "上向く会話", 2)
		at = 29
		helper_c28d4a31(7320085, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 30
		helper_25abe6d2(30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "くるし目パチ")
		event.SetProjection(projection)
		event.CmrsSetPos(30.59, 14.36, 15.74)
		event.CmrsSetRef(0.0, 18.7, 0.0)
		event.SetCrossfade(30)
		event.ObjsSetMotion(2, "上向く会話")
		at = 31
		helper_c28d4a31(7320090, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 32
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "上向く会話")
		at = 33
		helper_c28d4a31(7320100, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 34
		helper_25abe6d2(30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "くるし目パチ～目とじ")
		event.ObjsSetMotion(2, "下向く", 2)
		event.ObjsNextMotion(2, "下向く会話")
		at = 35
		helper_c28d4a31(7320110, -1)
		event.ObjsSetMotion(2, "下向くL")
		at = 36
		helper_25abe6d2(30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目とじ～目あき")
		event.ObjsSetMotion(2, "下向く会話", 2)
		event.ObjsNextMotion(2, "下→上", 2)
		event.ObjsNextMotion(2, "上向く会話", 4)
		at = 37
		helper_c28d4a31(7320120, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 38
		helper_25abe6d2(30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "おこり目パチ")
		event.CmrsSetPos(34.66, 78.5, 33.42)
		event.CmrsSetRef(0.62, 18.7, -0.62)
		event.SetCrossfade(30)
		event.ObjsSetMotion(2, "下→上", 6)
		event.ObjsNextMotion(2, "上向く会話", 4)
		event.CmrsMove2(6.93, 54.08, 29.68, 0.62, 18.7, -0.62, 200, 2, 1.0)
		at = 39
		helper_c28d4a31(7320125, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 40
		helper_25abe6d2(15)
		event.ObjsSetMotion(2, "上向く会話")
		at = 41
		helper_c28d4a31(7320130, -1)
		event.ObjsSetMotion(2, "上向くL")
		at = 42
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "手をかざす", 6)
		event.ObjsNextMotion(2, "手をかざす会話", 4)
		at = 43
		helper_c28d4a31(7320140, -1)
		event.ObjsSetMotion(2, "手をかざすL")
		event.CmrsInit()
		event.FadeOutBgm(30)
		event.SetMotionBlur(60)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(30)
		event.CmrsAddPas(7.14, 54.26, 29.71, 0.62, 18.7, -0.62)
		event.CmrsAddPas(116.13, 382.36, 166.44, 0.62, 18.7, -0.62)
		event.CmrsStartPas()
		at = 44
		helper_c624bc16()
		event.SetMotionBlur(0)
		event.SetCharaPos(43, 0.0, 0.0, 0.0)
		event.SetCharaRot(43, 0.0, 0.0, 0.0)
		event.SetCharaPos(44, 0.0, 0.0, 0.0)
		event.SetCharaRot(44, -0.9, 0.0, 0.0)
		event.SetCharaPos(45, 0.0, 120.78, -8.63)
		event.SetCharaRot(45, 0.0, 0.0, 0.0)
		event.SetCharaPos(46, 16.0, 7.55, -303.55)
		event.SetCharaRot(46, 0.0, 0.0, 0.0)
		event.CharaActive(1, 43)
		event.SndSePlay(var4, 4)
		event.SetMotion(43, "手をかざすL")
		event.SetCharaShow(43, 1, 1, 0.025)
		event.SetProjection(200.0)
		event.SndSeStop(var4, 1)
		event.SndSePlay(var4, 3)
		event.CmrsSetPos(-0.18, 16.61, -42.1)
		event.CmrsSetRef(-0.05, 86.09, 255.81)
		event.CmrsMove2(-0.18, 16.61, -42.1, -0.05, 235.45, 255.81, 100, 2, 1.0)
		event.StopBgm(0)
		event.SndSePlay(var4, 5)
		event.SetMotion(44, "手をかざすL", 2, -1, 1)
		event.CharaActive(1, 44)
		at = 45
		helper_25abe6d2(100)
		event.SetCharaShow(43, 0, 1, 0.025)
		at = 46
		helper_25abe6d2(100)
		event.SetMotion(45, "月破壊（ヒット）", 2, -1, 1)
		event.SndSePlay(var4, 6)
		event.CharaActive(1, 45)
		at = 47
		helper_25abe6d2(60)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おどろき顔")
		event.ObjsTexAnime(0, 1, "おどろき目パチ")
		event.ObjsTexAnime(0, 1, "半口")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おどろき顔")
		event.ObjsTexAnime(1, 1, "おどろき目パチ")
		event.ObjsTexAnime(1, 1, "半口")
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.ObjsSetPos(0, 17.39, 0.0, -347.79)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetPos(1, 2.28, 0.0, -342.63)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.SetProjection(projection)
		event.CmrsSetPos(49.31, 17.33, -336.13)
		event.CmrsSetRef(-69.21, 27.55, -358.14)
		event.ObjsSetMotion(5, "発動", 6)
		event.ObjsNextMotion(5, "ループ", 4)
		event.CharaActive(1, 46)
		at = 48
		helper_25abe6d2(60)
		at = 49
		helper_25abe6d2(120)
		event.CharaActive(0, 46)
		event.EsmCreate("Ｅ７３２光雨")
		event.EsmSetVect1(0.0, 140.0, 0.0)
		event.EsmSetVect2(500.0, 0.0, 500.0)
		event.EsmSetValue(0, 700)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "無表情")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "通常目パチ")
		event.EohSetShow(6, 0)
		event.ObjsSetPos(0, 13.0, 0.0, -159.19)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetPos(1, -13.0, 0.0, -156.73)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(2, "上向くL", 4)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(2.81, 138.78, 11.72, -3.06, -51.06, -141.04)
		event.CmrsAddPas(7.79, 138.78, 141.19, 1.89, -51.06, -12.32)
		event.CmrsStartPas()
		event.SetCrossfade(30)
		event.LoadBgm(112)
		at = 50
		helper_25abe6d2(90)
		event.PlayBgm(0)
		at = 51
		helper_c624bc16()
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "まんぞく目とじ")
		event.CmrsSetPos(24.93, 17.0, 8.96)
		event.CmrsSetRef(-1.11, 17.28, -1.22)
		event.SetCrossfade(30)
		at = 52
		helper_25abe6d2(90)
		at = 53
		helper_c28d4a31(7320150, -1)
		at = 54
		helper_25abe6d2(30)
		event.SetCharaPos(39, 0.0, 42.78, 36.3)
		event.SetCharaRot(39, 0.0, -3.12, 0.0)
		event.CharaActive(1, 39)
		event.SetMotion(39, "後光", 4, -1, 1)
		event.SetMotion(33, "浮遊立ち")
		event.SetCharaPos(33, 0.0, 42.78, 36.3)
		event.SetCharaRot(33, 0.0, -3.12, 0.0)
		event.CharaActive(1, 33)
		event.CmrsSetPos(-0.65, 13.67, -139.44)
		event.CmrsSetRef(-1.11, 30.17, -1.22)
		at = 55
		helper_25abe6d2(30)
		event.CmrsMove2(-0.96, 53.08, -45.59, -1.11, 64.72, -1.22, 200, 2, 1.0)
		event.SetMotion(33, "浮遊会話")
		at = 56
		helper_c28d4a31(7320160, -1)
		at = 57
		helper_c624bc16()
		event.CharaActive(0, 33)
		event.CharaActive(0, 39)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "泣き目")
		event.CmrsSetPos(24.93, 17.0, 8.96)
		event.CmrsSetRef(-1.11, 17.28, -1.22)
		at = 58
		helper_c28d4a31(7320170, -1)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "泣き目あき～目とじ")
		at = 59
		helper_25abe6d2(60)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目とじ～泣き目あき")
		event.ObjsSetMotion(2, "振り返る", 2)
		at = 60
		helper_25abe6d2(20)
		event.ObjsRotation(2, 0.0, 3.1, 0.0, 30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "まんぞく目パチ")
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.CmrsSetPos(1.99, 35.18, -222.99)
		event.CmrsSetRef(-1.11, 8.64, -1.22)
		at = 61
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "立ち2")
		at = 62
		helper_25abe6d2(20)
		event.ObjsSetMotion(2, "会話2")
		at = 63
		helper_c28d4a31(7320180, -1)
		event.ObjsSetMotion(2, "立ち2")
		at = 64
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "会話2")
		event.ObjsSetMotion(2, "立ち2")
		at = 65
		helper_25abe6d2(30)
		event.CmrsSetPos(-0.17, 20.98, -62.1)
		event.CmrsSetRef(0.0, 8.4, 0.0)
		event.ObjsSetMotion(2, "会話2")
		at = 66
		helper_c28d4a31(7320190, -1)
		event.ObjsSetMotion(2, "立ち2")
		at = 67
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "会話2")
		at = 68
		helper_c28d4a31(7320200, -1)
		event.ObjsSetMotion(2, "立ち2")
		at = 69
		helper_25abe6d2(30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "まんぞく目～目とじ")
		event.CmrsSetPos(-30.4, 17.0, -5.26)
		event.CmrsSetRef(-1.11, 17.28, -1.22)
		event.ObjsSetMotion(2, "上向く", 2)
		event.ObjsNextMotion(2, "死", 2)
		event.ObjsNextMotion(2, "死L", 4)
		event.SndSePlay(var4, 7)
		at = 70
		helper_25abe6d2(60)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(-1.15, 259.68, -39.55, -0.39, 8.4, -13.48)
		event.CmrsAddPas(-1.15, 117.74, -39.55, -0.39, 8.4, -13.48)
		event.CmrsStartPas()
		at = 71
		helper_c624bc16()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_52aadc70(7320010, -1)
		end
		if at <= 3 then
			helper_d3f20302(15)
		end
		if at <= 4 then
			helper_52aadc70(7320020, -1)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_52aadc70(7320030, -1)
		end
		if at <= 7 then
			helper_d3f20302(270)
		end
		if at <= 8 then
			helper_344d6cd8()
		end
		if at <= 9 then
			helper_d3f20302(60)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_344d6cd8()
		end
		if at <= 13 then
			helper_52aadc70(7320040, -1)
		end
		if at <= 14 then
			helper_d3f20302(30)
		end
		if at <= 15 then
			helper_52aadc70(7320050, -1)
		end
		if at <= 16 then
			helper_d3f20302(30)
		end
		if at <= 17 then
			helper_52aadc70(7320060, -1)
		end
		if at <= 18 then
			helper_d3f20302(30)
		end
		if at <= 19 then
			helper_d3f20302(20)
		end
		if at <= 20 then
			helper_52aadc70(7320062, -1)
		end
		if at <= 21 then
			helper_d3f20302(30)
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			helper_52aadc70(7320070, -1)
		end
		if at <= 24 then
			helper_d3f20302(15)
		end
		if at <= 25 then
			helper_52aadc70(7320080, -1)
		end
		if at <= 26 then
			helper_d3f20302(15)
		end
		if at <= 27 then
			helper_344d6cd8()
		end
		if at <= 28 then
			helper_52aadc70(7320085, -1)
		end
		if at <= 29 then
			helper_d3f20302(30)
		end
		if at <= 30 then
			helper_52aadc70(7320090, -1)
		end
		if at <= 31 then
			helper_d3f20302(30)
		end
		if at <= 32 then
			helper_52aadc70(7320100, -1)
		end
		if at <= 33 then
			helper_d3f20302(30)
		end
		if at <= 34 then
			helper_52aadc70(7320110, -1)
		end
		if at <= 35 then
			helper_d3f20302(30)
		end
		if at <= 36 then
			helper_52aadc70(7320120, -1)
		end
		if at <= 37 then
			helper_d3f20302(30)
		end
		if at <= 38 then
			helper_52aadc70(7320125, -1)
		end
		if at <= 39 then
			helper_d3f20302(15)
		end
		if at <= 40 then
			helper_52aadc70(7320130, -1)
		end
		if at <= 41 then
			helper_d3f20302(30)
		end
		if at <= 42 then
			helper_52aadc70(7320140, -1)
		end
		if at <= 43 then
			helper_344d6cd8()
		end
		if at <= 44 then
			helper_d3f20302(100)
		end
		if at <= 45 then
			helper_d3f20302(100)
		end
		if at <= 46 then
			helper_d3f20302(60)
		end
		if at <= 47 then
			helper_d3f20302(60)
		end
		if at <= 48 then
			helper_d3f20302(120)
		end
		if at <= 49 then
			helper_d3f20302(90)
		end
		if at <= 50 then
			helper_344d6cd8()
		end
		if at <= 51 then
			helper_d3f20302(90)
		end
		if at <= 52 then
			helper_52aadc70(7320150, -1)
		end
		if at <= 53 then
			helper_d3f20302(30)
		end
		if at <= 54 then
			helper_d3f20302(30)
		end
		if at <= 55 then
			helper_52aadc70(7320160, -1)
		end
		if at <= 56 then
			helper_344d6cd8()
		end
		if at <= 57 then
			helper_52aadc70(7320170, -1)
		end
		if at <= 58 then
			helper_d3f20302(60)
		end
		if at <= 59 then
			helper_d3f20302(20)
		end
		if at <= 60 then
			helper_238b5abc(2)
		end
		if at <= 61 then
			helper_d3f20302(20)
		end
		if at <= 62 then
			helper_52aadc70(7320180, -1)
		end
		if at <= 63 then
			helper_d3f20302(30)
		end
		if at <= 64 then
			helper_d3f20302(30)
		end
		if at <= 65 then
			helper_52aadc70(7320190, -1)
		end
		if at <= 66 then
			helper_d3f20302(30)
		end
		if at <= 67 then
			helper_52aadc70(7320200, -1)
		end
		if at <= 68 then
			helper_d3f20302(30)
		end
		if at <= 69 then
			helper_d3f20302(60)
		end
		if at <= 70 then
			helper_344d6cd8()
		end
		return true
	end)
	event.CancelDramaScene()
	event.FadeOutBgm(60)
	event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
	at = 72
	helper_25abe6d2(60)
	event.StopBgm(0)
	event.SetProjection(projection)
	event.SndSeAllStop(4)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	at = 73
	vm.wait(73)
	event.EsmClear()
	at = 74
	vm.wait(74)
	helper_108bc()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1276c()
	event.MapJump_3(-1, "s44", 500)
end

--- Event 17320, which map data, a script or the engine runs by number.
function script.event_17320()
	helper_1276c()
	event.MapJump_3(-1, "s44", 500)
end

return script
