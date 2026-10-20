--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b5edc9 = require("@lib/event/helper_09b5edc9")
local helper_2503c0bf = require("@lib/event/helper_2503c0bf")
local helper_500caf86 = require("@lib/event/helper_500caf86")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_aa1ac59e = require("@lib/event/helper_aa1ac59e")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_d84b5170 = require("@lib/event/helper_d84b5170")
local helper_f1a83e45 = require("@lib/event/helper_f1a83e45")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_8acf52e7()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 70 then
			if at <= 1 then
				helper_500caf86()
			end
			if at <= 2 then
				helper_a0e17f3c(60)
			end
			if at <= 3 then
				helper_fa57afea(3060010)
			end
			if at <= 4 then
				helper_a19c5ee3(3)
			end
			if at <= 5 then
				helper_a19c5ee3(1)
			end
			if at <= 6 then
				helper_fa57afea(3060020)
			end
			if at <= 7 then
				helper_a19c5ee3(2)
			end
			if at <= 8 then
				helper_a0e17f3c(30)
			end
			if at <= 9 then
				helper_a19c5ee3(2)
			end
			if at <= 10 then
				helper_fa57afea(3060030)
			end
			if at <= 11 then
				helper_a0e17f3c(60)
			end
			if at <= 12 then
				helper_a19c5ee3(2)
			end
			if at <= 13 then
				helper_fa57afea(3060040)
			end
			if at <= 14 then
				helper_fa57afea(3060045)
			end
			if at <= 15 then
				helper_a19c5ee3(2)
			end
			if at <= 16 then
				helper_fa57afea(3060050)
			end
			if at <= 17 then
				helper_fa57afea(3060060)
			end
			if at <= 18 then
				helper_a19c5ee3(2)
			end
			if at <= 19 then
				helper_fa57afea(3060065)
			end
			if at <= 20 then
				helper_fa57afea(3060070)
			end
			if at <= 21 then
				helper_a19c5ee3(0)
			end
			if at <= 22 then
				helper_fa57afea(3060080)
			end
			if at <= 23 then
				helper_a19c5ee3(2)
			end
			if at <= 24 then
				helper_aa1ac59e(1)
			end
			if at <= 25 then
				helper_2503c0bf(0, -1, 8, 0, 0)
				helper_f1a83e45(0)
			end
			if at <= 26 then
				helper_d84b5170(0)
				helper_a19c5ee3(1)
			end
			if at <= 27 then
				helper_fa57afea(3060095)
			end
			if at <= 28 then
				helper_fa57afea(3060100)
			end
			if at <= 29 then
				helper_fa57afea(3060110)
			end
			if at <= 30 then
				helper_a19c5ee3(6)
			end
			if at <= 31 then
				helper_a0e17f3c(4)
			end
			if at <= 32 then
				helper_fa57afea(3060115)
			end
			if at <= 33 then
				helper_a19c5ee3(6)
			end
			if at <= 34 then
				helper_fa57afea(3060120)
			end
			if at <= 35 then
				helper_a19c5ee3(0)
			end
			if at <= 36 then
				helper_a19c5ee3(1)
			end
			if at <= 37 then
				helper_fa57afea(3060130)
			end
			if at <= 38 then
				helper_a19c5ee3(7)
			end
			if at <= 39 then
				helper_fa57afea(3060140)
			end
			if at <= 40 then
				helper_a19c5ee3(9)
			end
			if at <= 42 then
				helper_fa57afea(3060150)
			end
			if at <= 43 then
				helper_a19c5ee3(1)
			end
			if at <= 44 then
				helper_fa57afea(3060160)
			end
			if at <= 45 then
				helper_fa57afea(3060165)
			end
			if at <= 46 then
				helper_a19c5ee3(0)
			end
			if at <= 47 then
				helper_fa57afea(3060170)
			end
			if at <= 48 then
				helper_a19c5ee3(1)
			end
			if at <= 49 then
				helper_fa57afea(3060180)
			end
			if at <= 50 then
				helper_a19c5ee3(0)
			end
			if at <= 51 then
				helper_fa57afea(3060190)
			end
			if at <= 52 then
				helper_a19c5ee3(1)
			end
			if at <= 53 then
				helper_fa57afea(3060195)
			end
			if at <= 54 then
				helper_a19c5ee3(1)
			end
			if at <= 55 then
				helper_fa57afea(3060200)
			end
			if at <= 56 then
				helper_a19c5ee3(0)
			end
			if at <= 57 then
				helper_a19c5ee3(1)
			end
			if at <= 58 then
				helper_a0e17f3c(20)
			end
			if at <= 59 then
				helper_fa57afea(3060210)
			end
			if at <= 60 then
				helper_a19c5ee3(2)
			end
			if at <= 61 then
				helper_a19c5ee3(1)
			end
			if at <= 62 then
				helper_fa57afea(3060220)
			end
			if at <= 63 then
				helper_fa57afea(3060230)
			end
			if at <= 64 then
				helper_a19c5ee3(1)
			end
			if at <= 65 then
				helper_09b5edc9(3060240, 300)
			end
			if at <= 66 then
				helper_b35e85eb()
			end
			if at <= 67 then
				helper_09b5edc9(3060250, 300)
			end
			if at <= 68 then
				helper_b35e85eb()
			end
			if at <= 69 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(71)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 10)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.EohSetShow(6, 1)
		event.SetMotion(0, "立ち", 4)
		event.StopBgm(0)
		event.StopEnvBgm()
		event.SndStopSrc()
		event.SetSavedataEtc(0, 5)
		event.SndInReverb(0)
		event.GotoDrawChapter(3)
		if vm.wait() then
			return skip(72)
		end
		event.SndInReverb(1)
		event.SetFadeOut(0)
	end
	event.SetFadeOut(0)
	event.SetFlag(306, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(54)
	event.PlayBgm(0)
	event.LoadSound(3209)
	var0 = event.SndLoadSound(3209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e306/")
	event.LoadMes(0, 5, "e306_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e306_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e306_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e306_duck.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e306_shirooza.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(3, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e306_lin.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(4, 37)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e306_bed.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(5, 38)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	block = event.LoadImg_4(5, "e306a.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e30601", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(8, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 8)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e30602", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(9, 1)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 9)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e30603", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(10, 2)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 10)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e306/e306_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e306/e306_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetLoadbgFile("snd2/bgm/bg_049.sound.json")
	helper_500caf86()
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncObj(6, "p01_g02i02", "g02i02_02-m0")
	event.EohSetShow(6, 0)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 32.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 16.0, 0.0, 80.0)
	event.EohSetRot(2, 0.0, -3.13, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetSoundId(2, var0)
	event.EohSetPos(3, -16.0, 22.0, -139.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetPos(4, 36.0, 16.0, -125.0)
	event.EohSetRot(4, -1.57, 1.57, 0.0)
	event.EohSetMotion(4, "寝てる", 4)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "苦しい顔")
	event.EohSetPos(5, 28.0, 0.0, -125.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetMotion(5, "寝てる", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-6.81, 44.73, -170.75)
	event.CmrsSetRef(-0.46, 20.2, -91.77)
	event.SetFadeIn(30)
	var3 = event.GetSndId(2) or var3
	event.SndSePlay(var3, 61)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(30.03, 37.26, -62.58)
	event.CmrsSetRef(-1.3, 23.77, -138.99)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_fa57afea(3060010)
	if vm.skipping() then
		return skip(4)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-30.92, 74.61, 2.48)
	event.CmrsSetRef(23.3, 23.77, -120.36)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "はげしく目パチ")
	event.ObjsSetPos(0, 0.0, 0.0, -30.0)
	event.ObjsMove(0, 0.0, 0.0, -70.0, 44)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 44)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 32.0, 0.0, -30.0)
	event.ObjsMove(1, 32.0, 0.0, -70.0, 50)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetPos(2, 16.0, 0.0, -46.0)
	event.ObjsMove(2, 16.0, 0.0, -96.0, 40)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.CmrsSetPos(29.58, 42.39, -112.5)
	event.CmrsSetRef(6.47, 6.19, -131.58)
	event.ObjsSetPos(2, 9.48, 0.8, -104.57)
	event.ObjsSetMotion(4, "苦しむ", 4)
	event.ObjsSetMotion(5, "苦しむ", 4)
	helper_fa57afea(3060020)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(4, "寝てる")
	event.ObjsSetMotion(5, "寝てる")
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(2, "リンの顔に手", 6)
	event.ObjsNextMotion(2, "リンの顔に手Ｌ", 4)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(8)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(15.15, 29.59, -152.03)
	event.CmrsSetRef(15.79, 17.82, -106.92)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetPos(2, 16.0, 0.0, -96.0)
	event.ObjsSetMotion(2, "リンの顔に手戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetRot(0, 0.0, 2.66, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -2.66, 0.0)
	event.ObjsResetDaPosition(1)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_fa57afea(3060030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(73.2, 51.86, -50.13)
	event.CmrsSetRef(-0.03, 5.67, -99.79)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "こまり目～通常目")
	event.ObjsSetMotion(2, "振り返る", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsRotDelay(2, 20)
	event.ObjsRotation2(2, 0.0, 0.0, 0.0, 21, 0, 0.3)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(12)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_fa57afea(3060040)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_fa57afea(3060045)
	if vm.skipping() then
		return skip(15)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060050)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSyncObj(2, 0.0, 20.0, 0.0, -1.57, 0.0, 50.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsMove(2, 16.0, 0.0, -20.0, 90)
	event.ObjsSetMotion(2, "歩き会話")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsMotionDelay(0, 14)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "ダック見振り返り", 6)
	event.ObjsNextMotion(1, "ダック見振り返りＬ", 4)
	helper_fa57afea(3060060)
	if vm.skipping() then
		return skip(18)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_fa57afea(3060065)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(17.46, 26.93, 16.32)
	event.CmrsSetRef(15.22, 20.74, -39.27)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～考え目")
	event.ObjsSetRot(0, 0.0, 0.3, 0.0)
	event.ObjsSetMotion(0, "会話", 6, -1, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetRot(1, 0.0, -0.3, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "考え", 6)
	event.ObjsNextMotion(1, "考えＬ", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060070)
	if vm.skipping() then
		return skip(21)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "顎に手", 2)
	event.ObjsNextMotion(2, "顎に手Ｌ", 4)
	helper_fa57afea(3060080)
	if vm.skipping() then
		return skip(23)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "考えから思いつく", 2)
	event.ObjsNextMotion(1, "考えから思いつくＬ", 4)
	event.ObjsSeDelay(1, 60)
	event.ObjsSePlay(1, var0, 9)
	event.ObjsTexaDelay(1, 40)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "考え目～おどろき目")
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 1, "目とじ～片目あき")
	event.ObjsTexaDelay(0, 120)
	event.ObjsTexAnime(0, 1, "こまり目～通常目")
	event.SetPakuAnim(1, "わらい口パク")
	event.StreamOpen3(1, 3060090)
	helper_aa1ac59e(1)
	if vm.skipping() then
		return skip(25)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 3060090)
	helper_2503c0bf(0, -1, 8, 0, 0)
	helper_f1a83e45(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_d84b5170(0)
	event.StreamClose(1)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(27)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060095)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060100)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(52.88, 6.41, -45.54)
	event.CmrsSetRef(31.82, 20.73, -69.95)
	event.FadeOutBgm(60)
	event.ObjsSetRot(0, 0.0, 0.24, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, -0.24, 0.0)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsColorDelay(6, 30)
	event.ObjsSetColor(6, 128, 128, 128, 128, 30)
	event.ObjsSeDelay(6, 50)
	event.ObjsSePlay(6, var0, 10)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060110)
	if vm.skipping() then
		return skip(30)
	end
	helper_a19c5ee3(6)
	if vm.skipping() then
		return skip(31)
	end
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(32)
	end
	event.LoadBgmPack(49)
	event.PlayBgm(0)
	event.ObjsColorDelay(6, 30)
	event.ObjsSetColor(6, 128, 128, 128, 0, 30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060115)
	if vm.skipping() then
		return skip(33)
	end
	helper_a19c5ee3(6)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(59.88, 44.11, -12.91)
	event.CmrsSetRef(15.2, 12.73, -72.05)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsMove(2, 16.0, 0.0, -40.0, 40)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060120)
	if vm.skipping() then
		return skip(35)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(36)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsSetMotion(1, "右向く会話", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsColorDelay(7, 30)
	event.ObjsSetColor(7, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3060130)
	if vm.skipping() then
		return skip(38)
	end
	helper_a19c5ee3(7)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetColor(9, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3060140)
	if vm.skipping() then
		return skip(40)
	end
	helper_a19c5ee3(9)
	if vm.skipping() then
		return skip(41)
	end
	if vm.wait() then
		return skip(42)
	end
	event.SetCrossfade(30)
	event.ObjsSetColor(7, 128, 128, 128, 0)
	event.ObjsSetColor(9, 128, 128, 128, 0)
	event.CmrsSetPos(68.34, 29.51, -63.36)
	event.CmrsSetRef(5.13, 12.73, -78.64)
	event.ObjsSetPos(0, 0.0, 0.0, -85.0)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 32.0, 0.0, -85.0)
	event.ObjsSetMotion(1, "右向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetPos(2, 16.0, 0.0, -60.0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060150)
	if vm.skipping() then
		return skip(43)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(57.95, 49.92, -115.62)
	event.CmrsSetRef(12.94, 14.17, -71.8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～うれし半口")
	event.ObjsSetMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_fa57afea(3060160)
	if vm.skipping() then
		return skip(45)
	end
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_fa57afea(3060165)
	if vm.skipping() then
		return skip(46)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetMotion(1, "右向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060170)
	if vm.skipping() then
		return skip(48)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 11)
	event.SetPakuAnim(0, "わらい口パク")
	helper_fa57afea(3060180)
	if vm.skipping() then
		return skip(50)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(36.82, 7.72, -52.98)
	event.CmrsSetRef(31.69, 22.04, -85.14)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.6, 0.0)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3060190)
	if vm.skipping() then
		return skip(52)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsSetPos(15.34, 34.38, -16.07)
	event.CmrsSetRef(16.07, 19.81, -79.1)
	event.ObjsSetRot(0, 0.0, 1.32, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -1.32, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "ちょっとだけ", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3060195)
	if vm.skipping() then
		return skip(54)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 11)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060200)
	if vm.skipping() then
		return skip(56)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(58)
	end
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(59)
	end
	event.CmrsSetPos(-41.83, 36.46, -99.09)
	event.CmrsSetRef(26.84, 14.91, -69.03)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.24, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_fa57afea(3060210)
	if vm.skipping() then
		return skip(60)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(61)
	end
	event.CmrsSetPos(49.67, 39.65, -52.94)
	event.CmrsSetRef(3.96, 26.47, -113.14)
	event.FadeOutBgm(60)
	event.ObjsRotation(0, 0.0, -2.79, 0.0, 28)
	event.ObjsSetMotion(0, "振り返る（PG）", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotation(1, 0.0, -2.4, 0.0, 34)
	event.ObjsSetMotion(1, "振り返りＰＧ", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(3, "左前見会話", 2)
	event.ObjsNextMotion(3, "左前見Ｌ", 4)
	helper_fa57afea(3060220)
	if vm.skipping() then
		return skip(63)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsMotionDelay(1, 23)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3060230)
	if vm.skipping() then
		return skip(64)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsSetPos(29.58, 45.4, -134.29)
	event.CmrsSetRef(13.02, 17.45, -125.0)
	event.CmrsMove2(23.74, 36.44, -131.02, 13.02, 17.45, -125.0, 160, 2, 1.0)
	helper_09b5edc9(3060240, 300)
	if vm.skipping() then
		return skip(66)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(67)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-25.96, 22.2, -107.48)
	event.CmrsSetRef(-0.56, 22.17, -86.82)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.CmrsMove2(-18.06, 22.2, -101.05, -0.56, 22.17, -86.82, 160, 2, 1.0)
	helper_09b5edc9(3060250, 300)
	if vm.skipping() then
		return skip(68)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(69)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(70)
	end
	return part2()
end

return helper_8acf52e7
