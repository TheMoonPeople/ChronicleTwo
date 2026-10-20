--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10d80545 = require("@lib/event/helper_10d80545")
local helper_1497768d = require("@lib/event/helper_1497768d")
local helper_93d5f4e9 = require("@lib/event/helper_93d5f4e9")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a348cd1a = require("@lib/event/helper_a348cd1a")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_1c68bb96()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 46 then
			if at <= 1 then
				helper_efffcfbb(120)
			end
			if at <= 2 then
				helper_10d80545()
			end
			if at <= 3 then
				helper_efffcfbb(120)
			end
			if at <= 4 then
				helper_efffcfbb(30)
			end
			if at <= 5 then
				helper_efffcfbb(3)
			end
			if at <= 6 then
				helper_efffcfbb(30)
			end
			if at <= 7 then
				helper_efffcfbb(3)
			end
			if at <= 8 then
				helper_a348cd1a(7040010, -1)
			end
			if at <= 9 then
				helper_efffcfbb(3)
			end
			if at <= 10 then
				helper_efffcfbb(15)
			end
			if at <= 11 then
				helper_a348cd1a(7040020, -1)
			end
			if at <= 12 then
				helper_a1c34b66(1)
			end
			if at <= 13 then
				helper_a1c34b66(0)
			end
			if at <= 14 then
				helper_efffcfbb(30)
			end
			if at <= 15 then
				helper_efffcfbb(120)
			end
			if at <= 16 then
				helper_a1c34b66(3)
			end
			if at <= 17 then
				helper_efffcfbb(60)
			end
			if at <= 18 then
				helper_efffcfbb(90)
			end
			if at <= 19 then
				helper_10d80545()
			end
			if at <= 20 then
				helper_a1c34b66(2)
			end
			if at <= 21 then
				helper_1497768d(7040030, -1, 15)
			end
			if at <= 22 then
				helper_efffcfbb(30)
			end
			if at <= 23 then
				helper_efffcfbb(30)
			end
			if at <= 24 then
				helper_a348cd1a(7040040, -1)
			end
			if at <= 25 then
				helper_efffcfbb(30)
			end
			if at <= 26 then
				helper_a348cd1a(7040050, 90)
			end
			if at <= 27 then
				helper_efffcfbb(45)
			end
			if at <= 28 then
				helper_a348cd1a(7040060, -1)
			end
			if at <= 29 then
				helper_efffcfbb(30)
			end
			if at <= 30 then
				helper_a348cd1a(7040065, -1)
			end
			if at <= 31 then
				helper_a1c34b66(2)
			end
			if at <= 32 then
				helper_efffcfbb(60)
			end
			if at <= 33 then
				helper_a348cd1a(7040070, -1)
			end
			if at <= 34 then
				helper_a1c34b66(2)
			end
			if at <= 35 then
				helper_efffcfbb(30)
			end
			if at <= 36 then
				helper_1497768d(7040075, -1, 30)
			end
			if at <= 37 then
				helper_efffcfbb(30)
			end
			if at <= 38 then
				helper_a348cd1a(7040080, -1)
			end
			if at <= 39 then
				helper_efffcfbb(30)
			end
			if at <= 40 then
				helper_efffcfbb(30)
			end
			if at <= 41 then
				helper_efffcfbb(30)
			end
			if at <= 42 then
				helper_93d5f4e9(7040090)
			end
			if at <= 43 then
				helper_93d5f4e9(7040100)
			end
			if at <= 44 then
				helper_10d80545()
			end
			if at <= 45 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(47)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 0)
		event.EohSetShow(7, 1)
		event.SetStatusbarShow(1, 1.0)
		event.StopBgm(0)
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
		event.DeleteChara(13)
		event.LoadMes(0, -1)
	end
	event.SetFlag(704, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	event.LoadSound(7206)
	var0 = event.SndLoadSound(7206) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.ChangeDir("event/e700/e704/")
	event.LoadMes(0, 5, "e704_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e704_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e704_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e704_andrea.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e704_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e704_kirakira.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "kaisou_waku.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(8, 13)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e704/e704_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e704/e704_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncObj(5, "p04s21")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p05s21")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p06s21")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSetShow(7, 0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 9.54, 0.8, 502.98)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -11.6, 0.8, 505.27)
	event.EohSetRot(1, 0.0, 3.02, 0.0)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(2, -106.51, 0.8, -0.91)
	event.EohSetRot(2, 0.0, -1.46, 0.0)
	event.EohSetFootSoundId(2, 21)
	event.EohSetPos(3, -76.45, 0.8, 111.79)
	event.EohSetRot(3, 0.0, -3.02, 0.0)
	event.EohSetFootSoundId(3, 21)
	event.EohSetPos(4, -109.63, -0.2, -0.79)
	event.EohSetRot(4, 0.0, -1.34, 0.0)
	event.InitDramaScene()
	event.SetProjection(400.9)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CmrsInit()
	event.CmrsSetPos(-8.58, 59.84, 666.86)
	event.CmrsSetRef(-1.51, 13.48, 346.75)
	event.ObjsSetMotion(0, "キョロキョロ歩き")
	event.ObjsMove(0, 11.42, 0.8, 30.92, 390, 1)
	event.ObjsMotionDelay(0, 390)
	event.ObjsNextMotion(0, "立ち")
	event.ObjsSetMotion(1, "キョロキョロ歩き")
	event.ObjsMove(1, -12.51, 0.8, 30.28, 390, 1)
	event.ObjsMotionDelay(1, 390)
	event.ObjsNextMotion(1, "立ち")
	event.ObjsSetMotion(2, "左向くL", 4)
	event.ObjsSetMotion(3, "左向くL", 4)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSyncObj(1, 10.0, 25.0, -4.0, -2.23, -8.6, -36.0, "", 1)
	helper_efffcfbb(120)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(165.07, 45.68, 324.48)
	event.CmrsSetRef(-14.87, 29.27, 175.92)
	event.CmrsMove(165.92, 45.68, 324.48, 179.98, 29.27, 90.51, 120)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSyncObj(1, 10.0, 6.0, 3.0, 3.14, 0.0, 0.1, "kao", 1)
	event.CmrsSetAhd(0.83, -3.65, 4.33)
	event.CmrsMoveAhd(-0.45, -3.65, 4.75, 120)
	helper_efffcfbb(120)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(-11.72, 13.64, 0.35)
	event.CmrsSetRef(4.72, 26.82, 36.12)
	event.ObjsSetPos(1, -4.82, 0.8, 32.15)
	event.ObjsSetRot(1, 0.0, 2.9, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目～おどろき目")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_efffcfbb(3)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(8)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_efffcfbb(3)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeIn(8)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsSetStep(1, 0.4)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsSetStep(0, 0.4)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a348cd1a(7040010, -1)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_efffcfbb(3)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeIn(8)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_a348cd1a(7040020, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(13)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(15)
	end
	event.SetProjection(524.9)
	event.CharaActive(13)
	event.SetCharaType(13, 4)
	event.CmrsCharaAttach(13, 600.7, -1)
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 1)
	event.SetFadeIn(30)
	event.SndSeStop(var0, 1)
	event.LoadSound(7207)
	event.SndLoadSound(7207)
	event.CmrsSetPos(-1.54, 43.85, 171.85)
	event.CmrsSetRef(-122.14, 15.83, 10.44)
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "さみし顔")
	event.ObjsTexAnime(2, 1, "さみし目パチ")
	event.CharaActive(10)
	event.CharaActive(11)
	event.ObjsSetPos(1, -4.82, -1000.0, 32.15)
	event.ObjsSetPos(0, -4.82, -1000.0, 32.15)
	event.ObjsSetMotion(3, "歩き")
	event.ObjsMove(3, -94.58, 0.8, 39.17, 150)
	event.ObjsMotionDelay(3, 150)
	event.ObjsNextMotion(3, "立ち")
	helper_efffcfbb(120)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-34.94, 19.17, -59.73)
	event.CmrsSetRef(-108.47, 18.37, 28.41)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "キラ目")
	helper_a1c34b66(3)
	if vm.skipping() then
		return skip(17)
	end
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-114.02, 20.03, 23.45)
	event.CmrsSetRef(-107.61, 17.93, 2.79)
	event.CharaActive(12)
	event.ObjsNextMotion(4, "きらきら", 4)
	event.ObjsSetMotion(3, "見とれる", 4)
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-93.25, 23.69, 13.62)
	event.CmrsSetRef(-95.05, 19.16, 42.11)
	event.CharaActive(0, 12)
	event.CmrsMove(-93.53, 23.69, 18.08, -95.05, 18.87, 42.11, 60)
	helper_10d80545()
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-114.02, 20.03, 23.45)
	event.CmrsSetRef(-107.61, 17.93, 2.79)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "さみし顔")
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くＬ", 4)
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(2, 1, "さみし目～通常目")
	event.SetPakuAnim(2, "通常口パク")
	helper_1497768d(7040030, -1, 15)
	if vm.skipping() then
		return skip(22)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-93.24, 25.67, 17.4)
	event.CmrsSetRef(-94.91, 17.61, 46.62)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "キラ目～あわて目")
	event.ObjsSetMotion(3, "何でもない", 6)
	event.ObjsNextMotion(3, "何でもないＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "何でもない戻り", 2)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_a348cd1a(7040040, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-173.93, 34.19, 9.82)
	event.CmrsSetRef(-105.61, 19.83, 12.28)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetPos(3, -105.3, 0.8, 30.6)
	event.ObjsSetRot(3, 0.0, 3.02, 0.0)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(3, "指差す", 6)
	event.ObjsNextMotion(3, "指差すＬ", 4)
	helper_a348cd1a(7040050, 90)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "指差す戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsSetMotion(2, "振り向く戻り", 6)
	event.ObjsNextMotion(2, "座り", 4)
	helper_efffcfbb(45)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "さみし顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_a348cd1a(7040060, -1)
	if vm.skipping() then
		return skip(29)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_a348cd1a(7040065, -1)
	if vm.skipping() then
		return skip(31)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(32)
	end
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_a348cd1a(7040070, -1)
	if vm.skipping() then
		return skip(34)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(35)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(-114.02, 20.03, 23.45)
	event.CmrsSetRef(-107.61, 17.93, 2.79)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexaDelay(2, 10)
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 30)
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_1497768d(7040075, -1, 30)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-118.35, 16.45, 6.07)
	event.CmrsSetRef(-103.94, 18.65, 30.61)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "温か目パチ")
	event.ObjsSetMotion(3, "うなずく", 6)
	event.ObjsNextMotion(3, "口だけ会話", 4)
	event.ObjsMotionDelay(3, 90)
	event.ObjsNextMotion(3, "立ち")
	helper_a348cd1a(7040080, -1)
	if vm.skipping() then
		return skip(39)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(40)
	end
	event.SetFadeOut(30, 255, 255, 255)
	event.FadeOutBgm(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(41)
	end
	event.CharaActive(0, 13)
	event.SetTime(time)
	event.SetTimeStepEnable(1)
	event.LoadSound(7208)
	event.SndLoadSound(7208)
	event.EohSetShow(5, 1)
	event.EohSetShow(6, 0)
	event.ObjsSetPos(1, -4.82, 0.8, 32.15)
	event.ObjsSetPos(0, 11.42, 0.8, 30.92)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.StopBgm(0)
	event.SetFadeIn(30)
	event.EohSetShow(7, 1)
	event.CmrsSetPos(-13.63, 12.51, -3.81)
	event.CmrsSetRef(4.72, 26.82, 36.12)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(7040090)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(0, "指さす", 6)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7040100)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(-2.7, 62.48, 330.48)
	event.CmrsSetRef(-0.63, 27.02, -407.23)
	event.ObjsSetPos(1, -4.82, -1000.0, 32.15)
	event.ObjsSetPos(0, 11.42, -1000.0, 30.92)
	event.ObjsSetPos(2, -4.82, -1000.0, 32.15)
	event.ObjsSetPos(3, 11.42, -1000.0, 30.92)
	event.CmrsMove2(-1.25, 41.62, -332.44, -0.63, 27.02, -407.23, 120, 2, 1.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(45)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(46)
	end
	return part2()
end

return helper_1c68bb96
