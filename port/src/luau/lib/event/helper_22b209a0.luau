--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_8b19a097 = require("@lib/event/helper_8b19a097")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_22b209a0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 56 then
			if at <= 1 then
				helper_a8b5d854(4)
			end
			if at <= 2 then
				helper_a8b5d854(30)
			end
			if at <= 3 then
				helper_a8b5d854(30)
			end
			if at <= 4 then
				helper_8b19a097(7080010, -1)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			if at <= 6 then
				helper_8b19a097(7080020, 60)
			end
			if at <= 7 then
				helper_a8b5d854(60)
			end
			if at <= 8 then
				helper_8b19a097(7080030, -1)
			end
			if at <= 9 then
				helper_a8b5d854(30)
			end
			if at <= 10 then
				helper_8b19a097(7080035, -1)
			end
			if at <= 11 then
				helper_a8b5d854(30)
			end
			if at <= 12 then
				helper_8b19a097(7080040, -1)
			end
			if at <= 13 then
				helper_a8b5d854(30)
			end
			if at <= 14 then
				helper_8b19a097(7080050, 60)
			end
			if at <= 15 then
				helper_a8b5d854(30)
			end
			if at <= 16 then
				helper_8b19a097(7080060, -1)
			end
			if at <= 17 then
				helper_a8b5d854(30)
			end
			if at <= 18 then
				helper_40ca6466(2)
			end
			if at <= 19 then
				helper_a8b5d854(45)
			end
			if at <= 20 then
				helper_8b19a097(7080070, -1)
			end
			if at <= 21 then
				helper_a8b5d854(30)
			end
			if at <= 22 then
				helper_a8b5d854(20)
			end
			if at <= 23 then
				helper_8b19a097(7080080, -1)
			end
			if at <= 24 then
				helper_a8b5d854(30)
			end
			if at <= 25 then
				helper_40ca6466(2)
			end
			if at <= 26 then
				helper_40ca6466(2)
			end
			if at <= 27 then
				helper_a8b5d854(20)
			end
			if at <= 28 then
				helper_8b19a097(7080090, -1)
			end
			if at <= 29 then
				helper_a8b5d854(20)
			end
			if at <= 30 then
				helper_8b19a097(7080100, -1)
			end
			if at <= 31 then
				helper_a8b5d854(30)
			end
			if at <= 32 then
				helper_a8b5d854(20)
			end
			if at <= 33 then
				helper_8b19a097(7080110, 60)
			end
			if at <= 34 then
				helper_a8b5d854(20)
			end
			if at <= 35 then
				helper_8b19a097(7080120, -1)
			end
			if at <= 36 then
				helper_a8b5d854(30)
			end
			if at <= 37 then
				helper_8b19a097(7080130, 60)
			end
			if at <= 38 then
				helper_8b19a097(7080140, -1)
			end
			if at <= 39 then
				helper_a8b5d854(20)
			end
			if at <= 40 then
				helper_8b19a097(7080150, -1)
			end
			if at <= 41 then
				helper_40ca6466(2)
			end
			if at <= 42 then
				helper_a8b5d854(30)
			end
			if at <= 43 then
				helper_8b19a097(7080160, -1)
			end
			if at <= 44 then
				helper_a8b5d854(20)
			end
			if at <= 45 then
				helper_8b19a097(7080165, -1)
			end
			if at <= 46 then
				helper_40ca6466(2)
			end
			if at <= 47 then
				helper_a8b5d854(20)
			end
			if at <= 48 then
				helper_a8b5d854(20)
			end
			if at <= 49 then
				helper_8b19a097(7080170, 60)
			end
			if at <= 50 then
				helper_a8b5d854(30)
			end
			if at <= 51 then
				helper_a8b5d854(15)
			end
			if at <= 52 then
				helper_a8b5d854(15)
			end
			if at <= 53 then
				helper_a8b5d854(60)
			end
			if at <= 54 then
				helper_a8b5d854(90)
			end
			if at <= 55 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(57)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, -1.22, 0.0)
		event.EohSetRot(5, 0.0, 1.22, 0.0)
		event.CharaActive(0)
		event.CharaActive(8)
		event.CharaActive(9)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(708, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_a8b5d854(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7818)
	var0 = event.SndLoadSound(7818) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e708/")
	event.LoadMes(0, 5, "e708_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e708_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e708_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e708_andrea.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e708_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "kaisou_waku.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(7, 12)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e708/e708_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e708/e708_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncObj(4, "p04s50")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p05s50")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p06s50")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSetPos(0, 9.54, 0.8, 502.98)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.6, 0.8, 505.27)
	event.EohSetRot(1, 0.0, 3.02, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -17.67, -2.8, 1.78)
	event.EohSetRot(2, 0.0, 1.58, 0.0)
	event.EohSetPos(3, -21.32, -2.8, -26.09)
	event.EohSetRot(3, 0.0, -0.1, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, -1.57, 0.0)
	event.EohSetShow(6, 1)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "花いけ立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CmrsInit()
	event.CmrsSetPos(-89.69, 118.46, -108.66)
	event.CmrsSetRef(-1.67, 30.09, -7.9)
	event.CharaActive(12)
	event.SetCharaType(12, 4)
	event.CmrsCharaAttach(12, 600.7, -1)
	event.SndSePlay(var0, 1)
	event.SetFadeIn(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "花いけから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "こまり目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CmrsSetPos(29.44, 24.13, 17.48)
	event.CmrsSetRef(-22.52, 17.78, -11.7)
	helper_8b19a097(7080010, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080020, 60)
	if vm.skipping() then
		return skip(7)
	end
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目あき～目とじ")
	event.ObjsSetMotion(3, "うつむく", 6)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	helper_8b19a097(7080030, -1)
	if vm.skipping() then
		return skip(9)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(3, "うつむき会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	helper_8b19a097(7080035, -1)
	if vm.skipping() then
		return skip(11)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsTexaDelay(2, 20)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080040, -1)
	if vm.skipping() then
		return skip(13)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(3, "うつむく戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ～目あき")
	helper_8b19a097(7080050, 60)
	if vm.skipping() then
		return skip(15)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-48.47, 12.55, -42.34)
	event.CmrsSetRef(-10.84, 19.04, -6.38)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080060, -1)
	if vm.skipping() then
		return skip(17)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(18)
	end
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	helper_a8b5d854(45)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_8b19a097(7080070, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-48.47, 12.55, -42.34)
	event.CmrsSetRef(-10.84, 19.04, -6.38)
	event.ObjsSetMotion(3, "正面向き立ち")
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "立ちからしゃがむ", 6)
	event.ObjsNextMotion(2, "しゃがむ会話", 6)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 180)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080080, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(25)
	end
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(2, "しゃがみから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SndSePlay(var0, 3)
	event.CmrsSetPos(-20.65, 17.48, -24.48)
	event.CmrsSetRef(-16.7, 25.56, 1.9)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(27)
	end
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 150)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080090, -1)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "ちょっと上向く", 6)
	event.ObjsNextMotion(2, "ちょっと上向くＬ", 4)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 210)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080100, -1)
	if vm.skipping() then
		return skip(31)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(33)
	end
	helper_8b19a097(7080110, 60)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(-20.65, 17.48, -24.48)
	event.CmrsSetRef(-16.7, 25.56, 1.9)
	event.ObjsSetMotion(2, "左見る", 6)
	event.ObjsNextMotion(2, "左見るＬ", 4)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 90)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080120, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(37)
	end
	helper_8b19a097(7080130, 60)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(2, "左見るから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080140, -1)
	if vm.skipping() then
		return skip(39)
	end
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 90)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080150, -1)
	if vm.skipping() then
		return skip(41)
	end
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(42)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(2, "身体ごと向く", 6)
	event.ObjsNextMotion(2, "身体ごと向くＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 90)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080160, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_8b19a097(7080165, -1)
	if vm.skipping() then
		return skip(46)
	end
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(47)
	end
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(49)
	end
	helper_8b19a097(7080170, 60)
	if vm.skipping() then
		return skip(50)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(51)
	end
	event.FadeOutBgm(30)
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(52)
	end
	event.CharaActive(0, 12)
	event.ObjsSetPos(1, -8.49, -1.96, 108.26)
	event.ObjsSetPos(0, 10.48, -1.96, 111.88)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(53)
	end
	event.SndSeStop(var0, 1)
	event.LoadSound(7819)
	var2 = event.SndLoadSound(7819) or var2
	event.SetFadeIn(30)
	event.ObjsSetPos(2, -8.49, -1000.0, 108.26)
	event.ObjsSetPos(3, 10.48, -1000.0, 111.88)
	event.CmrsSetPos(-14.02, 13.72, 63.77)
	event.CmrsSetRef(7.42, 21.78, 134.93)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(54)
	end
	event.CmrsSetPos(0.05, 16.14, 284.86)
	event.CmrsSetRef(1.57, 67.05, -251.65)
	event.SndSePlay(var2, 4)
	event.ObjsRotation2(4, 0.0, -1.22, 0.0, 60, 1, 0.7)
	event.ObjsRotation2(5, 0.0, 1.22, 0.0, 60, 1, 0.7)
	helper_a8b5d854(90)
	if vm.skipping() then
		return skip(55)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(56)
	end
	return part2()
end

return helper_22b209a0
