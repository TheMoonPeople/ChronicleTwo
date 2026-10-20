--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_384c5eb1 = require("@lib/event/helper_384c5eb1")
local helper_6492ac5f = require("@lib/event/helper_6492ac5f")
local helper_8c283814 = require("@lib/event/helper_8c283814")
local helper_99d125b7 = require("@lib/event/helper_99d125b7")

--- Helper function.
local function helper_b772712e()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 42 then
			if at <= 1 then
				helper_384c5eb1(1)
			end
			if at <= 2 then
				helper_100ac525(30)
			end
			if at <= 3 then
				helper_384c5eb1(1)
			end
			if at <= 4 then
				helper_99d125b7(6080010, -1)
			end
			if at <= 5 then
				helper_100ac525(30)
			end
			if at <= 6 then
				helper_8c283814()
			end
			if at <= 7 then
				helper_8c283814()
			end
			if at <= 8 then
				helper_100ac525(30)
			end
			if at <= 9 then
				helper_100ac525(60)
			end
			if at <= 10 then
				helper_100ac525(30)
			end
			if at <= 11 then
				helper_384c5eb1(1)
			end
			if at <= 12 then
				helper_100ac525(30)
			end
			if at <= 13 then
				helper_99d125b7(6080020, -1)
			end
			if at <= 14 then
				helper_100ac525(30)
			end
			if at <= 15 then
				helper_99d125b7(6080025, -1)
			end
			if at <= 16 then
				helper_384c5eb1(2)
			end
			if at <= 17 then
				helper_99d125b7(6080030, -1)
			end
			if at <= 18 then
				helper_100ac525(15)
			end
			if at <= 19 then
				helper_99d125b7(6080040, -1)
			end
			if at <= 20 then
				helper_100ac525(15)
			end
			if at <= 21 then
				helper_99d125b7(6080045, -1)
			end
			if at <= 22 then
				helper_99d125b7(6080050, -1)
			end
			if at <= 23 then
				helper_100ac525(30)
			end
			if at <= 24 then
				helper_99d125b7(6080060, -1)
			end
			if at <= 25 then
				helper_100ac525(15)
			end
			if at <= 26 then
				helper_99d125b7(6080070, -1)
			end
			if at <= 27 then
				helper_100ac525(30)
			end
			if at <= 28 then
				helper_99d125b7(6080075, -1)
			end
			if at <= 29 then
				helper_384c5eb1(2)
			end
			if at <= 30 then
				helper_99d125b7(6080080, -1)
			end
			if at <= 31 then
				helper_100ac525(15)
			end
			if at <= 32 then
				helper_100ac525(120)
			end
			if at <= 33 then
				helper_100ac525(30)
			end
			if at <= 34 then
				helper_99d125b7(6080090, -1)
			end
			if at <= 35 then
				helper_100ac525(60)
			end
			if at <= 36 then
				helper_384c5eb1(3)
			end
			if at <= 37 then
				helper_99d125b7(6080100, -1)
			end
			if at <= 38 then
				helper_100ac525(20)
			end
			if at <= 39 then
				helper_99d125b7(6080105, 150)
			end
			if at <= 40 then
				helper_100ac525(90)
			end
			if at <= 41 then
				helper_8c283814()
			end
			if vm.skip_end() then
				return skip(43)
			end
			return part2()
		end
		if at <= 43 then
			helper_100ac525(4)
		end
		helper_6492ac5f(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_100ac525(4)
		if vm.skipping() then
			return skip(44)
		end
		event.LoadBgm(36)
		event.PlayBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		helper_6492ac5f(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.2, 400.0)
		event.SetCameraPos(0.0, 40.2, 520.0)
		event.ResetCamera(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetFadeIn(30)
	end
	event.SetFadeOut(0)
	event.SetFlag(608, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_100ac525(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(51)
	event.PlayBgm(0)
	event.LoadSound(7806)
	var0 = event.SndLoadSound(7806) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e608/")
	event.LoadMes(0, 5, "e608_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e608_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e608_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e608telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e608telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e600/e608/e608_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(10)
	event.LoadChara(5, "event/e600/e608/e608_f_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e608/e608_sun.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3, 12)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 18.8, 0.2, 627.69)
	event.EohSetRot(0, 0.0, 3.07, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -18.33, 0.2, 634.43)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(2, -1.11, 280.0, -571.36)
	event.EohSetRot(2, 0.0, -0.01, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 21)
	event.EohSetPos(3, 0.59, 43.94, -81.95)
	event.EohSetRot(3, 0.0, -0.01, 0.0)
	event.EohSetMotion(3, "両手広げるＬ", 4)
	event.EohSetFootSoundId(3, 21)
	event.InitDramaScene()
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.CmrsInit()
	event.CmrsSetPos(-3.47, 496.82, -690.82)
	event.CmrsSetRef(-5.22, 214.08, 91.62)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 18.97, 0.2, 554.51, 90, 1)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -18.13, 0.2, 545.88, 90, 1)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-2.06, 19.94, 249.02)
	event.CmrsSetRef(-1.59, 24.2, 291.92)
	event.ObjsSetPos(1, -9.31, 0.2, 281.32)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 7.09, 0.2, 282.56)
	event.ObjsSetRot(0, 0.0, -2.97, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	helper_99d125b7(6080010, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-154.98, 28.42, 533.81)
	event.CmrsSetRef(-279.55, 40.6, 353.0)
	event.CmrsMove(225.39, 28.42, 472.47, 339.8, 36.75, 291.8, 360)
	helper_8c283814()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsMove(-3.33, 119.35, 266.15, -1.27, 158.81, 55.32, 90)
	helper_8c283814()
	if vm.skipping() then
		return skip(8)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.36, 292.54, -536.23)
	event.CmrsSetRef(-2.12, 298.3, -575.85)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	event.ObjsSetPos(1, -18.46, 0.2, 55.61)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 14.5, 0.2, 63.44)
	event.ObjsResetDaPosition(0)
	helper_100ac525(60)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -1.25, 130.16, -257.23, 400, 1)
	event.ObjsMotionDelay(2, 400)
	event.ObjsSetMotion(2, "立ち")
	helper_100ac525(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-3.6, 35.33, 230.79)
	event.CmrsSetRef(-2.02, 46.97, 103.92)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(13)
	end
	helper_99d125b7(6080020, -1)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "左→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "右から上", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_99d125b7(6080025, -1)
	if vm.skipping() then
		return skip(16)
	end
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(42.03, 12.5, 8.79)
	event.CmrsSetRef(-17.69, 20.13, 73.01)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_99d125b7(6080030, -1)
	if vm.skipping() then
		return skip(18)
	end
	helper_100ac525(15)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-1.98, 141.34, -232.47)
	event.CmrsSetRef(-1.03, 144.72, -259.94)
	helper_99d125b7(6080040, -1)
	if vm.skipping() then
		return skip(20)
	end
	helper_100ac525(15)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(2, "笑う", 6)
	event.ObjsNextMotion(2, "笑うL", 4)
	event.ObjsNextMotion(2, "笑う戻り", 4)
	event.ObjsNextMotion(2, "立ち")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目～わらい目")
	helper_99d125b7(6080045, -1)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-3.6, 35.33, 230.79)
	event.CmrsSetRef(-2.02, 46.97, 103.92)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -0.89, 36.96, -59.99, 400, 1)
	event.ObjsMotionDelay(2, 400)
	event.ObjsSetMotion(2, "立ち")
	helper_99d125b7(6080050, -1)
	if vm.skipping() then
		return skip(23)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(24)
	end
	helper_99d125b7(6080060, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_100ac525(15)
	if vm.skipping() then
		return skip(26)
	end
	helper_99d125b7(6080070, -1)
	if vm.skipping() then
		return skip(27)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(28)
	end
	helper_99d125b7(6080075, -1)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var0, 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "身構え", 6)
	event.ObjsNextMotion(1, "身構えL", 4)
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSetMotion(2, "笑う", 6)
	event.ObjsNextMotion(2, "笑うL", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目～わらい目")
	helper_99d125b7(6080080, -1)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	helper_100ac525(15)
	if vm.skipping() then
		return skip(32)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.56, 41.19, 0.3)
	event.CmrsSetRef(-0.5, 43.3, -50.78)
	event.CmrsMove2(-1.3, 37.59, -12.38, -0.5, 43.3, -50.78, 120, 2, 1.0)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	helper_100ac525(120)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(13.66, 39.05, 16.1)
	event.CmrsSetRef(16.97, 18.33, 61.91)
	event.ObjsSetMotion(2, "立ち")
	event.CmrsMove(-16.73, 39.05, 18.35, -15.62, 18.33, 64.27, 120)
	event.SetPakuAnim(0, "通常口パク")
	helper_99d125b7(6080090, -1)
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(1.22, 23.49, 141.64)
	event.CmrsSetRef(1.34, 25.13, 39.83)
	event.ObjsSetMotion(2, "フードに手をやる", 6)
	event.ObjsNextMotion(2, "フードに手をやるL", 4)
	helper_100ac525(60)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSePlay(var0, 5)
	event.CmrsSetPos(33.21, 53.76, -44.92)
	event.CmrsSetRef(3.6, 57.9, -78.66)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ")
	event.CharaActive(0, 11)
	event.CharaActive(12)
	event.ObjsSetMotion(3, "頭ぶるぶる", 6)
	event.ObjsNextMotion(3, "両手広げる", 4)
	event.ObjsNextMotion(3, "両手広げるＬ", 4)
	helper_384c5eb1(3)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsSetMotion(3, "両手広げ会話")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ～目あき")
	helper_99d125b7(6080100, -1)
	if vm.skipping() then
		return skip(38)
	end
	helper_100ac525(20)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsPrdelay(60)
	event.CmrsSetPos(9.9, 35.11, 33.88)
	event.CmrsSetRef(15.48, 21.68, 64.42)
	event.CmrsMove(11.17, 31.65, 40.85, 15.48, 21.68, 64.42, 60)
	event.CmrsSetPos(-14.64, 35.21, 35.6)
	event.CmrsSetRef(-16.78, 21.68, 60.9)
	event.ObjsTexaDelay(3, 60)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "こわれ目パチ")
	event.CmrsMove(-14.36, 32.13, 37.22, -17.13, 20.52, 65.0, 60)
	event.CmrsSetPos(0.31, 58.43, -61.11)
	event.CmrsSetRef(0.74, 63.75, -85.24)
	event.ObjsSetMotion(3, "両手広げ会話", 4)
	event.ObjsMotionDelay(3, 150)
	event.ObjsSetMotion(3, "両手広げるＬ", 4)
	event.CmrsMove(0.73, 32.94, -12.13, 0.74, 63.75, -85.24, 60)
	helper_99d125b7(6080105, 150)
	if vm.skipping() then
		return skip(40)
	end
	helper_100ac525(90)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_8c283814()
	if vm.skipping() then
		return skip(42)
	end
	return part2()
end

return helper_b772712e
