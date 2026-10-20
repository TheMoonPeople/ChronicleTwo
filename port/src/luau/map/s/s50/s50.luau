--!strict
-- map/s/s50/s50.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3a88f4ff = require("@lib/event/helper_3a88f4ff")
local helper_430489d5 = require("@lib/event/helper_430489d5")
local helper_47e08a85 = require("@lib/event/helper_47e08a85")
local helper_b01df685 = require("@lib/event/helper_b01df685")
local helper_c35fec39 = require("@lib/event/helper_c35fec39")
local helper_cfb096c9 = require("@lib/event/helper_cfb096c9")
local helper_d779bb0d = require("@lib/event/helper_d779bb0d")
local helper_e1e5862e = require("@lib/event/helper_e1e5862e")
local helper_ee857707 = require("@lib/event/helper_ee857707")
local helper_f163d291 = require("@lib/event/helper_f163d291")
local helper_f8afd4ff = require("@lib/event/helper_f8afd4ff")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7686)
	flag = event.GetFlag(708) or flag
	if flag == 1 then
		event.FuncPointShow("", "e708", 0)
		event.EohSyncObj(0, "p06s50")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, "p04s50")
		event.EohSetRot(0, 0.0, -1.22, 0.0)
		event.EohSyncObj(1, "p05s50")
		event.EohSetRot(1, 0.0, 1.22, 0.0)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetBitCtrl(1, 1)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
end

--- Helper function.
local function helper_2828()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			if vm.wait() then
				return skip(1)
			end
		end
	end
end

--- Helper function.
local function helper_1067c(arg0: s32)
	local active_chr_no: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_cfb096c9(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_d779bb0d(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_cfb096c9(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_cfb096c9(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var2 = helper_430489d5(arg0, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var2 == 0 then
		event.SetFadeOut(30)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return 1
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_10af0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 56 then
			if at <= 1 then
				helper_d779bb0d(4)
			end
			if at <= 2 then
				helper_d779bb0d(30)
			end
			if at <= 3 then
				helper_d779bb0d(30)
			end
			if at <= 4 then
				helper_3a88f4ff(7080010, -1)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if at <= 6 then
				helper_3a88f4ff(7080020, 60)
			end
			if at <= 7 then
				helper_d779bb0d(60)
			end
			if at <= 8 then
				helper_3a88f4ff(7080030, -1)
			end
			if at <= 9 then
				helper_d779bb0d(30)
			end
			if at <= 10 then
				helper_3a88f4ff(7080035, -1)
			end
			if at <= 11 then
				helper_d779bb0d(30)
			end
			if at <= 12 then
				helper_3a88f4ff(7080040, -1)
			end
			if at <= 13 then
				helper_d779bb0d(30)
			end
			if at <= 14 then
				helper_3a88f4ff(7080050, 60)
			end
			if at <= 15 then
				helper_d779bb0d(30)
			end
			if at <= 16 then
				helper_3a88f4ff(7080060, -1)
			end
			if at <= 17 then
				helper_d779bb0d(30)
			end
			if at <= 18 then
				helper_b01df685(2)
			end
			if at <= 19 then
				helper_d779bb0d(45)
			end
			if at <= 20 then
				helper_3a88f4ff(7080070, -1)
			end
			if at <= 21 then
				helper_d779bb0d(30)
			end
			if at <= 22 then
				helper_d779bb0d(20)
			end
			if at <= 23 then
				helper_3a88f4ff(7080080, -1)
			end
			if at <= 24 then
				helper_d779bb0d(30)
			end
			if at <= 25 then
				helper_b01df685(2)
			end
			if at <= 26 then
				helper_b01df685(2)
			end
			if at <= 27 then
				helper_d779bb0d(20)
			end
			if at <= 28 then
				helper_3a88f4ff(7080090, -1)
			end
			if at <= 29 then
				helper_d779bb0d(20)
			end
			if at <= 30 then
				helper_3a88f4ff(7080100, -1)
			end
			if at <= 31 then
				helper_d779bb0d(30)
			end
			if at <= 32 then
				helper_d779bb0d(20)
			end
			if at <= 33 then
				helper_3a88f4ff(7080110, 60)
			end
			if at <= 34 then
				helper_d779bb0d(20)
			end
			if at <= 35 then
				helper_3a88f4ff(7080120, -1)
			end
			if at <= 36 then
				helper_d779bb0d(30)
			end
			if at <= 37 then
				helper_3a88f4ff(7080130, 60)
			end
			if at <= 38 then
				helper_3a88f4ff(7080140, -1)
			end
			if at <= 39 then
				helper_d779bb0d(20)
			end
			if at <= 40 then
				helper_3a88f4ff(7080150, -1)
			end
			if at <= 41 then
				helper_b01df685(2)
			end
			if at <= 42 then
				helper_d779bb0d(30)
			end
			if at <= 43 then
				helper_3a88f4ff(7080160, -1)
			end
			if at <= 44 then
				helper_d779bb0d(20)
			end
			if at <= 45 then
				helper_3a88f4ff(7080165, -1)
			end
			if at <= 46 then
				helper_b01df685(2)
			end
			if at <= 47 then
				helper_d779bb0d(20)
			end
			if at <= 48 then
				helper_d779bb0d(20)
			end
			if at <= 49 then
				helper_3a88f4ff(7080170, 60)
			end
			if at <= 50 then
				helper_d779bb0d(30)
			end
			if at <= 51 then
				helper_d779bb0d(15)
			end
			if at <= 52 then
				helper_d779bb0d(15)
			end
			if at <= 53 then
				helper_d779bb0d(60)
			end
			if at <= 54 then
				helper_d779bb0d(90)
			end
			if at <= 55 then
				helper_d779bb0d(30)
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
	helper_d779bb0d(4)
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
	event.LoadMes(0, 5, "e708.txt")
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "花いけから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_d779bb0d(30)
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
	helper_3a88f4ff(7080010, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_3a88f4ff(7080020, 60)
	if vm.skipping() then
		return skip(7)
	end
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目あき～目とじ")
	event.ObjsSetMotion(3, "うつむく", 6)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	helper_3a88f4ff(7080030, -1)
	if vm.skipping() then
		return skip(9)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(3, "うつむき会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	helper_3a88f4ff(7080035, -1)
	if vm.skipping() then
		return skip(11)
	end
	helper_d779bb0d(30)
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
	helper_3a88f4ff(7080040, -1)
	if vm.skipping() then
		return skip(13)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(3, "うつむく戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ～目あき")
	helper_3a88f4ff(7080050, 60)
	if vm.skipping() then
		return skip(15)
	end
	helper_d779bb0d(30)
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
	helper_3a88f4ff(7080060, -1)
	if vm.skipping() then
		return skip(17)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(18)
	end
	helper_b01df685(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	helper_d779bb0d(45)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_3a88f4ff(7080070, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-48.47, 12.55, -42.34)
	event.CmrsSetRef(-10.84, 19.04, -6.38)
	event.ObjsSetMotion(3, "正面向き立ち")
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "立ちからしゃがむ", 6)
	event.ObjsNextMotion(2, "しゃがむ会話", 6)
	helper_d779bb0d(20)
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
	helper_3a88f4ff(7080080, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(25)
	end
	helper_b01df685(2)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(2, "しゃがみから立ち", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SndSePlay(var0, 3)
	event.CmrsSetPos(-20.65, 17.48, -24.48)
	event.CmrsSetRef(-16.7, 25.56, 1.9)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(27)
	end
	helper_d779bb0d(20)
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
	helper_3a88f4ff(7080090, -1)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "ちょっと上向く", 6)
	event.ObjsNextMotion(2, "ちょっと上向くＬ", 4)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 210)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_3a88f4ff(7080100, -1)
	if vm.skipping() then
		return skip(31)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(33)
	end
	helper_3a88f4ff(7080110, 60)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(-20.65, 17.48, -24.48)
	event.CmrsSetRef(-16.7, 25.56, 1.9)
	event.ObjsSetMotion(2, "左見る", 6)
	event.ObjsNextMotion(2, "左見るＬ", 4)
	helper_d779bb0d(20)
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
	helper_3a88f4ff(7080120, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(37)
	end
	helper_3a88f4ff(7080130, 60)
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
	helper_3a88f4ff(7080140, -1)
	if vm.skipping() then
		return skip(39)
	end
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 90)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_3a88f4ff(7080150, -1)
	if vm.skipping() then
		return skip(41)
	end
	helper_b01df685(2)
	if vm.skipping() then
		return skip(42)
	end
	helper_d779bb0d(30)
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
	helper_3a88f4ff(7080160, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 0, "わらい口パク")
	helper_3a88f4ff(7080165, -1)
	if vm.skipping() then
		return skip(46)
	end
	helper_b01df685(2)
	if vm.skipping() then
		return skip(47)
	end
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-23.78, 29.48, -7.12)
	event.CmrsSetRef(-20.7, 6.84, -39.22)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(49)
	end
	helper_3a88f4ff(7080170, 60)
	if vm.skipping() then
		return skip(50)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(51)
	end
	event.FadeOutBgm(30)
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_d779bb0d(15)
	if vm.skipping() then
		return skip(52)
	end
	event.CharaActive(0, 12)
	event.ObjsSetPos(1, -8.49, -1.96, 108.26)
	event.ObjsSetPos(0, 10.48, -1.96, 111.88)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_d779bb0d(15)
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
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(54)
	end
	event.CmrsSetPos(0.05, 16.14, 284.86)
	event.CmrsSetRef(1.57, 67.05, -251.65)
	event.SndSePlay(var2, 4)
	event.ObjsRotation2(4, 0.0, -1.22, 0.0, 60, 1, 0.7)
	event.ObjsRotation2(5, 0.0, 1.22, 0.0, 60, 1, 0.7)
	helper_d779bb0d(90)
	if vm.skipping() then
		return skip(55)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(56)
	end
	return part2()
end

--- Helper function.
local function helper_ff30()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_b01df685(0)
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		var1 = 86
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		var1 = 64
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(1)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(3)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_c634(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e1e5862e(1, 4)
			helper_cfb096c9(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_e1e5862e(1, 4)
	helper_cfb096c9(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db40(arg0: any, arg1: any)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_ee857707()
			end
			if at <= 2 then
				helper_d779bb0d(30)
			end
			if at <= 3 then
				helper_f163d291(arg1, -1)
			end
			if at <= 4 then
				helper_d779bb0d(10)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if at <= 6 then
				helper_d779bb0d(120)
			end
			if at <= 7 then
				local _ = helper_f8afd4ff(0)
			end
			if at <= 8 then
				helper_c634(1)
			end
			if at <= 9 then
				helper_c634(4)
			end
			if at <= 10 then
				helper_c634(active_chr_no)
			end
			if at <= 11 then
				helper_c634(1)
			end
			if at <= 12 then
				helper_d779bb0d(30)
			end
			if at <= 14 then
				helper_d779bb0d(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.DngCheckPause(16384) or var2
	if var2 ~= 16384 then
		event.DngPause(16384, 1)
	end
	boss_map = event.DngCheckBossMap() or boss_map
	event.GetActiveBgmStatus(-1)
	if var2 ~= 16384 and boss_map ~= 1 then
		var4 = event.GetEventInfoSndid(4) or var4
		argc = event.GetSeStatus(var4, 0) or argc
		battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
		event.SndSeStop(var4, 0)
		print("---------------------------------------------BATTLE BGM STOP\n")
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 or active_chr_no == 1 then
		event.SetTexAnim(0, 0, "目パチ")
		event.SetTexAnim(0, 1, "死に")
	end
	if active_chr_no == 2 then
		event.ActchrSetMotion(0, "故障", 6)
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
		event.EsmCreate("ロボ故障")
	end
	var8 = 0
	if active_chr_no == 2 then
		var8 = event.CheckEnableCharaChange(0) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(1) or var8
		end
	end
	if active_chr_no == 0 then
		var8 = event.CheckEnableCharaChange(1) or var8
	end
	if active_chr_no == 1 then
		var8 = event.CheckEnableCharaChange(0) or var8
	end
	if active_chr_no == 3 then
		var8 = event.CheckEnableCharaChange(1) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(0) or var8
		end
	end
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_ee857707()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_f163d291(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_d779bb0d(10)
			if vm.skipping() then
				return skip(5)
			end
			event.PlayBgm(0)
		end
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "gameover1", block)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetUvsize(0, 0, 0, 576, 128)
		event.SpriteSetPutsize(0, 576, 128)
		event.SpriteSetPos(0, -320, 208)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsMove(0, 288, 208, 0.0, 20)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SpriteInit(1)
		event.SpriteSetType(1, 0)
		event.SpriteSetTexture(1, "gameover1", block)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetUvsize(1, 0, 128, 576, 64)
		event.SpriteSetPutsize(1, 576, 64)
		event.SpriteSetPos(1, 256, 208)
		event.SpriteSetDraw(1, 1)
		event.EohSyncSprite(1, 1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetColor(1, 128, 128, 128, 128, 120)
		helper_d779bb0d(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_f8afd4ff(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c634(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_c634(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c634(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_c634(1)
		if vm.skipping() then
			return skip(12)
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.AddWhp(0, 999)
		event.AddWhp(1, 999)
		if active_chr_no == 2 then
			event.EsmClear()
		end
		if active_chr_no == 0 or active_chr_no == 1 then
			event.SetTexAnim(0, 0, "死に")
			event.SetTexAnim(0, 1, "目パチ")
		end
		event.ActchrSetDefMotion(0, 4)
	elseif var8 == 1 then
		event.SetFadeOut(30)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(13)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(14)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(15)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(1)
		if arg0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_d779bb0d(4)
	if vm.skipping() then
		return skip(16)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
	print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
	print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
	if var2 ~= 16384 and boss_map ~= 1 then
		if argc == 1 then
			print("---------------------------------------------BATTLE BGM PLAY\n")
			event.SndSePlay(var4, 0)
			event.SndSetSeVol(var4, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(10)
	end
	if var2 ~= 16384 then
		event.DngPause(16385, 0)
	else
		event.DngPause(1, 0)
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_fe0c(arg0: s32)
	return helper_db40(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 0.
script[0] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"―ユリスの発明ネタ調査―\nユリスは本を読んで\n　●武器\n　●月の柱\n　●鹿のツノ\nの３つによって何かが発明できると直感した！"
		)
	else
		event.MesMake_2(
			0,
			"―モニカのモンスター調査―\nモニカはそこに記されている内容から\n『ダイヤ』は\n『ダイヤモンド』に目がないことを知った。"
		)
	end
	helper_cfb096c9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	helper_47e08a85(0.0, 0.0, 200.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 200.0)
	event.SetCameraPos(0.0, 40.0, 320.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.CmrsInit()
	event.CmrsQuake(0.0, 1.0, 0.0, 16)
	helper_2828()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_1067c(2)
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DngPause(8192, 0)
		event.ActchrSetDefMotion(0)
		event.SetCharaChangeMask(2, 1)
		event.SetCharaChangeMask(3, 1)
		event.SetBitCtrl(1, 0)
		event.LoadScript("d06/d06.stb", 1000)
	end
end

--- Program 210.
script[210] = function()
	local flag: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cfb096c9(0, -1, 5, 0, 0)
		end
	end
	flag = event.GetFlag(708) or flag
	if flag == 1 then
		local t0 = helper_1067c(1)
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			stage_id = event.DngGetStageId() or stage_id
			var2 = event.DngGetFloorId() or var2
			argc = event.GetNextFloor(var2, 0) or argc
			event.DngSetFloorId(argc)
			event.SetFloorInfo(stage_id, var2, 5, 2)
			event.SetFloorInfo(stage_id, argc, 5, 1)
			event.SetCharaShow(1, 1)
			event.SetCharaShow(2, 1)
			event.DngPause(8192, 0)
			event.ActchrSetDefMotion(0)
			event.SetCharaChangeMask(2, 1)
			event.SetCharaChangeMask(3, 1)
			event.SetBitCtrl(1, 0)
			event.LoadScript("d06/d06.stb", 1000)
		end
	else
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMotion(0, "立ち")
		event.MesMake_2(
			0,
			"　　　扉はかたく閉ざされている。\nこの部屋には何か秘密が在るのだろうか？"
		)
		helper_cfb096c9(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_cfb096c9(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 10 then
			if at <= 3 then
				var1 = 2
			end
			if at <= 4 then
				helper_d779bb0d(3)
			end
			if at <= 5 then
				helper_d779bb0d(10)
			end
			if at <= 6 then
				helper_d779bb0d(3)
			end
			if at <= 7 then
				helper_d779bb0d(20)
			end
			if at <= 8 then
				helper_d779bb0d(30)
			end
			if at <= 9 then
				helper_10af0()
				if not vm.skipping() then
					return landing1()
				end
			end
			helper_47e08a85(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return
		end
	end
	function part2() end
	function landing1()
		helper_47e08a85(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
		event.SetCameraRef(30.0, 27.2, -80.0)
		event.SetCameraPos(30.0, 37.2, 40.0)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_cfb096c9(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_cfb096c9(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "不思議な花びんがある。\n（(#)ボタンでメニューを開く）")
		var3 = helper_c35fec39(0, -1, 5, 256, 208, var3)
		if vm.skipping() then
			return skip(3)
		end
		if var3 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.GotoUseItem(374)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(4)
			end
		end
		if var2 > 0 then
			if var2 == 374 then
				event.SetStatusbarShow(0, 1.0)
				event.EohSyncObj(0, "p06s50")
				event.EohSetShow(0, 1)
				event.FuncPointShow("", "e708", 0)
				event.FuncPointShow("", "next_floor", 1)
				event.SetFadeOut(3, 255, 255, 255)
				helper_d779bb0d(3)
				if vm.skipping() then
					return skip(5)
				end
				event.SetFadeIn(8)
				helper_d779bb0d(10)
				if vm.skipping() then
					return skip(6)
				end
				event.SetFadeOut(3, 255, 255, 255)
				helper_d779bb0d(3)
				if vm.skipping() then
					return skip(7)
				end
				event.SetFadeIn(8)
				helper_d779bb0d(20)
				if vm.skipping() then
					return skip(8)
				end
				event.SetFadeOut(30, 255, 255, 255)
				helper_d779bb0d(30)
				if vm.skipping() then
					return skip(9)
				end
				helper_10af0()
				if vm.skipping() then
					return skip(10)
				end
				helper_47e08a85(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
				event.SetCameraRef(30.0, 27.2, -80.0)
				event.SetCameraPos(30.0, 37.2, 40.0)
				event.ResetCamera(0)
				event.SetFadeIn(10)
				event.Finish()
				return
			else
				helper_ff30()
				if vm.skipping() then
					return skip(11)
				end
			end
		end
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fe0c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17080.
script[17080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	helper_10af0()
	if vm.skipping() then
		return skip(1)
	end
end

return script
