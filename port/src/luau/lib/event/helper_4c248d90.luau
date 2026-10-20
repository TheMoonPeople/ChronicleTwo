--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_366d50dc = require("@lib/event/helper_366d50dc")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")

--- Helper function.
local function helper_4c248d90()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 61 then
			if at <= 1 then
				helper_adea7ba0(4)
			end
			if at <= 2 then
				helper_adea7ba0(30)
			end
			if at <= 3 then
				helper_261c70db()
			end
			if at <= 4 then
				helper_adea7ba0(30)
			end
			if at <= 5 then
				helper_3ea45d11(7480010, 180)
			end
			if at <= 6 then
				helper_3ea45d11(7480020, 120)
			end
			if at <= 7 then
				helper_adea7ba0(30)
			end
			if at <= 8 then
				helper_3ea45d11(7480030, 90)
			end
			if at <= 9 then
				helper_3ea45d11(7480040, 120)
			end
			if at <= 10 then
				helper_3ea45d11(7480050, 150)
			end
			if at <= 11 then
				helper_3ea45d11(7480060, 180)
			end
			if at <= 12 then
				helper_3ea45d11(7480070, 80)
			end
			if at <= 13 then
				helper_3ea45d11(7480080, 60)
			end
			if at <= 14 then
				helper_3ea45d11(7480090, 60)
			end
			if at <= 15 then
				helper_3ea45d11(7480100, 90)
			end
			if at <= 16 then
				helper_4896c0c7(7480110)
			end
			if at <= 17 then
				helper_23bda4ba(2)
			end
			if at <= 18 then
				helper_3ea45d11(7480120, -1)
			end
			if at <= 19 then
				helper_adea7ba0(20)
			end
			if at <= 20 then
				helper_4896c0c7(7480125)
			end
			if at <= 21 then
				helper_3ea45d11(7480130, -1)
			end
			if at <= 22 then
				helper_adea7ba0(20)
			end
			if at <= 23 then
				helper_4896c0c7(7480135)
			end
			if at <= 24 then
				helper_4896c0c7(7480140)
			end
			if at <= 25 then
				helper_4896c0c7(7480150)
			end
			if at <= 26 then
				helper_3ea45d11(7480160, -1)
			end
			if at <= 27 then
				helper_23bda4ba(3)
			end
			if at <= 28 then
				helper_adea7ba0(10)
			end
			if at <= 29 then
				helper_4896c0c7(7480170)
			end
			if at <= 30 then
				helper_23bda4ba(3)
			end
			if at <= 31 then
				helper_366d50dc(7480180, -1, 30)
			end
			if at <= 32 then
				helper_adea7ba0(15)
			end
			if at <= 33 then
				helper_4896c0c7(7480185)
			end
			if at <= 34 then
				helper_4896c0c7(7480190)
			end
			if at <= 35 then
				helper_4896c0c7(7480200)
			end
			if at <= 36 then
				helper_4896c0c7(7480210)
			end
			if at <= 37 then
				helper_4896c0c7(7480220)
			end
			if at <= 38 then
				helper_4896c0c7(7480230)
			end
			if at <= 39 then
				helper_4896c0c7(7480240)
			end
			if at <= 40 then
				helper_4896c0c7(7480250)
			end
			if at <= 41 then
				helper_3ea45d11(7480260, -1)
			end
			if at <= 42 then
				helper_adea7ba0(15)
			end
			if at <= 43 then
				helper_3ea45d11(7480270, -1)
			end
			if at <= 44 then
				helper_23bda4ba(3)
			end
			if at <= 45 then
				helper_adea7ba0(15)
			end
			if at <= 46 then
				helper_3ea45d11(7480275, 210)
			end
			if at <= 47 then
				helper_3ea45d11(7480280, 120)
			end
			if at <= 48 then
				helper_3ea45d11(7480290, -1)
			end
			if at <= 49 then
				helper_adea7ba0(30)
			end
			if at <= 50 then
				helper_4896c0c7(7480295)
			end
			if at <= 51 then
				helper_3ea45d11(7480300, -1)
			end
			if at <= 52 then
				helper_adea7ba0(30)
			end
			if at <= 53 then
				helper_4896c0c7(7480305)
			end
			if at <= 54 then
				helper_4896c0c7(7480310)
			end
			if at <= 55 then
				helper_23bda4ba(2)
			end
			if at <= 56 then
				helper_3ea45d11(7480320, -1)
			end
			if at <= 57 then
				helper_261c70db()
			end
			if at <= 58 then
				helper_261c70db()
			end
			if at <= 59 then
				helper_adea7ba0(30)
			end
			if at <= 60 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(62)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.CharaActive(0, 37)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(748, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7211)
	var0 = event.SndLoadSound(7211) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.ChangeDir("event/e700/e748/")
	event.LoadMes(0, 5, "e748_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e748_mints.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e748_monica.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e748_andrea.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e748_sun.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e748_heishi.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "kaisou_waku.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.EohSetPos(0, 9.54, -1000.8, 502.98)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.6, -1000.8, 505.27)
	event.EohSetRot(1, 0.0, 3.02, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -65.28, 3.0, 570.89)
	event.EohSetRot(2, 0.0, -1.58, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, -100.12, 6.02, 97.85)
	event.EohSetRot(3, 0.0, 0.86, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetPos(4, -114.49, 6.02, 85.4)
	event.EohSetRot(4, 0.0, 0.86, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(34)
	event.CharaActive(35)
	event.CmrsInit()
	event.CmrsSetPos(-36.83, 30.31, 792.49)
	event.CmrsSetRef(-41.22, 273.64, 621.04)
	event.CharaActive(37)
	event.SetCharaType(37, 4)
	event.CmrsCharaAttach(37, 600.7, -1)
	event.SetFadeIn(30)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "左向き目パチ")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(-36.83, 28.06, 792.49, -41.22, 32.05, 621.04, 120, 1, 1.0)
	helper_261c70db()
	if vm.skipping() then
		return skip(4)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(3, "連行中", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(4, "連行中", 4)
	event.ObjsMove(3, -3.01, 3.0, 243.61, 300)
	event.ObjsRotation(3, 0.0, 0.5, 0.0, 300)
	event.ObjsMove(4, -12.42, 3.0, 226.06, 300)
	event.ObjsRotation(4, 0.0, 0.5, 0.0, 300)
	event.ObjsMove(3, -9.47, 3.0, 310.45, 330)
	event.ObjsRotation(3, 0.0, -0.1, 0.0, 12)
	event.ObjsMove(4, -9.08, 3.0, 290.82, 330)
	event.ObjsRotation(4, 0.0, -0.1, 0.0, 12)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_3ea45d11(7480010, 180)
	if vm.skipping() then
		return skip(6)
	end
	helper_3ea45d11(7480020, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsRotation(2, 0.0, 2.78, 0.0, 12)
	event.ObjsMotionDelay(2, 30)
	event.ObjsNextMotion(2, "立ち")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480030, 90)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(24.11, 19.86, 616.87)
	event.CmrsSetRef(-14.37, 18.99, 524.13)
	event.ObjsSetPos(2, -19.05, 3.0, 550.34)
	event.ObjsSetRot(2, 0.0, 2.66, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(3, -8.65, 3.0, 450.26, 300)
	event.ObjsMove(4, -7.2, 3.0, 430.56, 300)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_3ea45d11(7480040, 120)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(4, 1, "口パク")
	helper_3ea45d11(7480050, 150)
	if vm.skipping() then
		return skip(11)
	end
	helper_3ea45d11(7480060, 180)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(65.31, 13.43, 458.75)
	event.CmrsSetRef(-32.25, 19.69, 525.13)
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480070, 80)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(3, -6.26, 3.0, 505.48, 150)
	event.ObjsMove(4, -4.33, 3.0, 486.12, 150)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_3ea45d11(7480080, 60)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480090, 60)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 2)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "連行解除", 6)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "連行解除", 6)
	event.ObjsNextMotion(4, "立ち")
	event.ObjsTexAnime(4, 1, "口パク")
	helper_3ea45d11(7480100, 90)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(50.08, 20.77, 547.75)
	event.CmrsSetRef(-22.42, 18.57, 549.89)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目パチ")
	event.ObjsSetPos(3, -8.76, 3.0, 533.31)
	event.ObjsSetRot(3, 0.0, -0.1, 0.0)
	event.ObjsSetMotion(3, "上目立ち", 4)
	event.ObjsSetPos(2, -10.6, 3.0, 558.53)
	event.ObjsSetRot(2, 0.0, -2.9, 0.0)
	event.ObjsResetDaPosition(2)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "しゃがむ", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480110)
	if vm.skipping() then
		return skip(17)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(3, "上目立ち会話", 4)
	event.ObjsMotionDelay(3, 180)
	event.ObjsNextMotion(3, "上目立ち", 4)
	helper_3ea45d11(7480120, -1)
	if vm.skipping() then
		return skip(19)
	end
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(20)
	end
	helper_4896c0c7(7480125)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(3, "上目立ち")
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480130, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480135)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(3, "えっ！", 6)
	event.ObjsNextMotion(3, "口だけ会話")
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目～通常目")
	helper_4896c0c7(7480140)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480150)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(3, "ぶるぶる", 6)
	event.ObjsNextMotion(3, "ぶるぶるＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "ぶるぶる戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目あき～目とじ")
	helper_3ea45d11(7480160, -1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(28)
	end
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480170)
	if vm.skipping() then
		return skip(30)
	end
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(3, "目をそらす", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsNextMotion(3, "目をそらす会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "目をそらすＬ", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "前向き～左向き")
	helper_366d50dc(7480180, -1, 30)
	if vm.skipping() then
		return skip(32)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(33)
	end
	helper_4896c0c7(7480185)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(3, "目をそらすＬ")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480190)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480200)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsSetMotion(3, "目をそらす戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "左向き～前向き")
	helper_4896c0c7(7480210)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(35.94, 7.97, 601.38)
	event.CmrsSetRef(-12.68, 20.72, 534.58)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.SetPakuAnim(4, "口パク")
	helper_4896c0c7(7480220)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(3, "嫌だ", 6)
	event.ObjsNextMotion(3, "嫌だ会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "嫌だＬ", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目～おこり目")
	helper_4896c0c7(7480230)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(3, "嫌だＬ")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480240)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(3, "でも", 6)
	event.ObjsNextMotion(3, "でもＬ", 4)
	helper_4896c0c7(7480250)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(27.14, 19.14, 544.75)
	event.CmrsSetRef(-10.12, 20.72, 543.67)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "おこり目パチ")
	event.ObjsSetPos(2, -9.41, 3.0, 551.78)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(2, "せまる", 6)
	event.ObjsNextMotion(2, "せまるＬ", 4)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "わかった", 6)
	event.ObjsNextMotion(3, "わかったＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "わかった会話", 4)
	event.ObjsMotionDelay(3, 90)
	event.ObjsNextMotion(3, "わかったＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480260, -1)
	if vm.skipping() then
		return skip(42)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "おこり目～通常目")
	helper_3ea45d11(7480270, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(45)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-54.72, 17.36, 484.64)
	event.CmrsSetRef(10.21, 20.7, 547.81)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目パチ")
	event.ObjsSetPos(4, -114.49, 6.02, 85.4)
	event.ObjsSeDelay(3, 120)
	event.ObjsSePlay(3, var0, 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsSetMotion(3, "回転１", 6)
	event.ObjsRotDelay(3, 130)
	event.ObjsRotation(3, 0.0, -3.06, 0.0, 15)
	event.ObjsNextMotion(3, "手を頭に歩き")
	event.ObjsPosDelay(3, 150)
	event.ObjsMove(3, -4.25, 3.0, 515.84, 180)
	event.ObjsSeDelay(3, 210)
	event.ObjsSePlay(3, var0, 5)
	event.ObjsMotionDelay(3, 150)
	event.ObjsNextMotion(3, "回転２", 6)
	event.ObjsRotDelay(3, 180)
	event.ObjsRotation(3, 0.0, -0.1, 0.0, 30)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_3ea45d11(7480275, 210)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480280, 120)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "口とじ")
	helper_3ea45d11(7480290, -1)
	if vm.skipping() then
		return skip(49)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_4896c0c7(7480295)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(2, "ため息", 6)
	event.ObjsNextMotion(2, "ため息Ｌ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsTexAnime(2, 1, "ため息")
	helper_3ea45d11(7480300, -1)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "通常口パク")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(53)
	end
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(2, "立ち上がる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(7480305)
	if vm.skipping() then
		return skip(54)
	end
	helper_4896c0c7(7480310)
	if vm.skipping() then
		return skip(55)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(-65.08, 22.44, 574.54)
	event.CmrsSetRef(-13.97, 25.0, 522.35)
	event.ObjsSetPos(3, -25.95, 3.0, 505.44)
	event.ObjsSetRot(3, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(2, -6.29, 3.0, 528.64)
	event.ObjsSetRot(2, 0.0, -2.42, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(2, "眩しいＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "見上げる", 6)
	event.ObjsNextMotion(3, "見上げるＬ", 4)
	event.CmrsPrdelay(120)
	event.CmrsMove2(-65.08, 22.44, 574.54, -24.39, 113.93, 513.67, 90, 1, 1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7480320, -1)
	if vm.skipping() then
		return skip(57)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(58)
	end
	event.CmrsSetPos(-11.49, 83.41, 532.92)
	event.CmrsSetRef(-28.34, 16.36, 500.29)
	event.ObjsSetMotion(3, "眩しい", 4)
	event.CmrsMove(-15.48, 54.13, 525.19, -27.67, 20.34, 500.29, 90)
	helper_261c70db()
	if vm.skipping() then
		return skip(59)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(60)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(61)
	end
	return part2()
end

return helper_4c248d90
