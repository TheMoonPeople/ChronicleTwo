--!strict
-- map/s/s21/s21.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0924108c = require("@lib/event/helper_0924108c")
local helper_13e53048 = require("@lib/event/helper_13e53048")
local helper_19a74323 = require("@lib/event/helper_19a74323")
local helper_330d2062 = require("@lib/event/helper_330d2062")
local helper_6fdd737a = require("@lib/event/helper_6fdd737a")
local helper_8b3317ed = require("@lib/event/helper_8b3317ed")
local helper_93fd01b9 = require("@lib/event/helper_93fd01b9")
local helper_9fb4735f = require("@lib/event/helper_9fb4735f")
local helper_b6a1431a = require("@lib/event/helper_b6a1431a")
local helper_db7d11d7 = require("@lib/event/helper_db7d11d7")
local helper_f506758a = require("@lib/event/helper_f506758a")
local helper_f5f5ea6d = require("@lib/event/helper_f5f5ea6d")

--- Program 99.
local function program_99()
	local argc: s32 = 0
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7689)
	argc = event.GetItemHaveNum(374) or argc
	flag = event.GetFlag(708) or flag
	if argc >= 1 or flag == 1 then
		event.FuncPointShow("", "item", 0)
	else
		event.EohSyncObj(0, "p06s21")
		event.EohSetShow(0, 1)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetBitCtrl(1, 1)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
end

--- Helper function.
local function helper_10394()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 46 then
			if at <= 1 then
				helper_13e53048(120)
			end
			if at <= 2 then
				helper_8b3317ed()
			end
			if at <= 3 then
				helper_13e53048(120)
			end
			if at <= 4 then
				helper_13e53048(30)
			end
			if at <= 5 then
				helper_13e53048(3)
			end
			if at <= 6 then
				helper_13e53048(30)
			end
			if at <= 7 then
				helper_13e53048(3)
			end
			if at <= 8 then
				helper_f5f5ea6d(7040010, -1)
			end
			if at <= 9 then
				helper_13e53048(3)
			end
			if at <= 10 then
				helper_13e53048(15)
			end
			if at <= 11 then
				helper_f5f5ea6d(7040020, -1)
			end
			if at <= 12 then
				helper_db7d11d7(1)
			end
			if at <= 13 then
				helper_db7d11d7(0)
			end
			if at <= 14 then
				helper_13e53048(30)
			end
			if at <= 15 then
				helper_13e53048(120)
			end
			if at <= 16 then
				helper_db7d11d7(3)
			end
			if at <= 17 then
				helper_13e53048(60)
			end
			if at <= 18 then
				helper_13e53048(90)
			end
			if at <= 19 then
				helper_8b3317ed()
			end
			if at <= 20 then
				helper_db7d11d7(2)
			end
			if at <= 21 then
				helper_f5f5ea6d(7040030, -1)
			end
			if at <= 22 then
				helper_13e53048(30)
			end
			if at <= 23 then
				helper_13e53048(30)
			end
			if at <= 24 then
				helper_f5f5ea6d(7040040, -1)
			end
			if at <= 25 then
				helper_13e53048(30)
			end
			if at <= 26 then
				helper_f5f5ea6d(7040050, -1)
			end
			if at <= 27 then
				helper_13e53048(45)
			end
			if at <= 28 then
				helper_f5f5ea6d(7040060, -1)
			end
			if at <= 29 then
				helper_13e53048(30)
			end
			if at <= 30 then
				helper_f5f5ea6d(7040065, -1)
			end
			if at <= 31 then
				helper_db7d11d7(2)
			end
			if at <= 32 then
				helper_13e53048(60)
			end
			if at <= 33 then
				helper_f5f5ea6d(7040070, -1)
			end
			if at <= 34 then
				helper_db7d11d7(2)
			end
			if at <= 35 then
				helper_13e53048(30)
			end
			if at <= 36 then
				helper_f5f5ea6d(7040075, -1)
			end
			if at <= 37 then
				helper_13e53048(30)
			end
			if at <= 38 then
				helper_f5f5ea6d(7040080, -1)
			end
			if at <= 39 then
				helper_13e53048(30)
			end
			if at <= 40 then
				helper_13e53048(30)
			end
			if at <= 41 then
				helper_13e53048(30)
			end
			if at <= 42 then
				helper_9fb4735f(7040090)
			end
			if at <= 43 then
				helper_9fb4735f(7040100)
			end
			if at <= 44 then
				helper_8b3317ed()
			end
			if at <= 45 then
				helper_13e53048(30)
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
	event.LoadMes(0, 5, "e704.txt")
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
	helper_13e53048(90)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSyncObj(1, 10.0, 25.0, -4.0, -2.23, -8.6, -36.0, "", 1)
	helper_13e53048(120)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(165.07, 45.68, 324.48)
	event.CmrsSetRef(-14.87, 29.27, 175.92)
	event.CmrsMove(165.92, 45.68, 324.48, 179.98, 29.27, 90.51, 120)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSyncObj(1, 10.0, 6.0, 3.0, 3.14, 0.0, 0.1, "kao", 1)
	event.CmrsSetAhd(0.83, -3.65, 4.33)
	event.CmrsMoveAhd(-0.45, -3.65, 4.75, 120)
	helper_13e53048(120)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_13e53048(3)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(8)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_13e53048(3)
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
	helper_f5f5ea6d(7040010, -1)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 0)
	event.SetFadeOut(3, 255, 255, 255)
	helper_13e53048(3)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeIn(8)
	helper_13e53048(15)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f5f5ea6d(7040020, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(13)
	end
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_13e53048(30)
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
	helper_13e53048(120)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-34.94, 19.17, -59.73)
	event.CmrsSetRef(-108.47, 18.37, 28.41)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "キラ目")
	helper_db7d11d7(3)
	if vm.skipping() then
		return skip(17)
	end
	helper_13e53048(60)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-114.02, 20.03, 23.45)
	event.CmrsSetRef(-107.61, 17.93, 2.79)
	event.CharaActive(12)
	event.ObjsNextMotion(4, "きらきら", 4)
	event.ObjsSetMotion(3, "見とれる", 4)
	helper_13e53048(90)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-93.25, 23.69, 13.62)
	event.CmrsSetRef(-95.05, 19.16, 42.11)
	event.CharaActive(0, 12)
	event.CmrsMove(-93.53, 23.69, 18.08, -95.05, 18.87, 42.11, 60)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-114.02, 20.03, 23.45)
	event.CmrsSetRef(-107.61, 17.93, 2.79)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "さみし顔")
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くＬ", 4)
	helper_db7d11d7(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(2, 1, "さみし目～通常目")
	event.SetPakuAnim(2, "通常口パク")
	helper_f5f5ea6d(7040030, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_13e53048(30)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-93.24, 25.67, 17.4)
	event.CmrsSetRef(-94.91, 17.61, 46.62)
	helper_13e53048(30)
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
	helper_f5f5ea6d(7040040, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_13e53048(30)
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
	helper_f5f5ea6d(7040050, -1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "指差す戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsSetMotion(2, "振り向く戻り", 6)
	event.ObjsNextMotion(2, "座り", 4)
	helper_13e53048(45)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "さみし顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_f5f5ea6d(7040060, -1)
	if vm.skipping() then
		return skip(29)
	end
	helper_13e53048(30)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_f5f5ea6d(7040065, -1)
	if vm.skipping() then
		return skip(31)
	end
	helper_db7d11d7(2)
	if vm.skipping() then
		return skip(32)
	end
	helper_13e53048(60)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_f5f5ea6d(7040070, -1)
	if vm.skipping() then
		return skip(34)
	end
	helper_db7d11d7(2)
	if vm.skipping() then
		return skip(35)
	end
	helper_13e53048(30)
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
	helper_f5f5ea6d(7040075, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_13e53048(30)
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
	helper_f5f5ea6d(7040080, -1)
	if vm.skipping() then
		return skip(39)
	end
	helper_13e53048(30)
	if vm.skipping() then
		return skip(40)
	end
	event.SetFadeOut(30, 255, 255, 255)
	event.FadeOutBgm(30)
	helper_13e53048(30)
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
	helper_13e53048(30)
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
	helper_9fb4735f(7040090)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(0, "指さす", 6)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(7040100)
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
	helper_8b3317ed()
	if vm.skipping() then
		return skip(45)
	end
	event.SetFadeOut(30)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(46)
	end
	return part2()
end

--- Helper function.
local function helper_1884(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, arg0, arg1, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_84d0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_6fdd737a(arg0, 0, var6)
		end
		helper_19a74323(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_6fdd737a(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_19a74323(arg0)
end

--- Helper function.
local function helper_7898(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_b6a1431a(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_ba38(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var2
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_7898(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_ff20()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_84d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_13e53048(30)
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
			helper_84d0(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_84d0(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_ba38(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_13e53048(30)
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
local function helper_c764(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_93fd01b9(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_93fd01b9(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_84d0(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_fc0()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		argc = event.CheckLoadbgFile() or argc
		if argc == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_10c4(arg0: s32)
	local stream_open_state: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if vm.wait() then
			return skip(2)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

--- Helper function.
local function helper_6038(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10c4(1)
		end
		if at <= 2 then
			helper_f506758a(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_10c4(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_f506758a(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_e3c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.ChkPadCtrl(arg0) or var1
	return var1
end

--- Helper function.
local function helper_c624(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_93fd01b9(1, 4)
			helper_84d0(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_93fd01b9(1, 4)
	helper_84d0(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db30(arg0: any, arg1: any)
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
				helper_fc0()
			end
			if at <= 2 then
				helper_13e53048(30)
			end
			if at <= 3 then
				helper_6038(arg1, -1)
			end
			if at <= 4 then
				helper_13e53048(10)
			end
			if at <= 5 then
				helper_13e53048(30)
			end
			if at <= 6 then
				helper_13e53048(120)
			end
			if at <= 7 then
				local _ = helper_e3c(0)
			end
			if at <= 8 then
				helper_c624(1)
			end
			if at <= 9 then
				helper_c624(4)
			end
			if at <= 10 then
				helper_c624(active_chr_no)
			end
			if at <= 11 then
				helper_c624(1)
			end
			if at <= 12 then
				helper_13e53048(30)
			end
			if at <= 14 then
				helper_13e53048(30)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_fc0()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_13e53048(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6038(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_13e53048(10)
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
		helper_13e53048(30)
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
		helper_13e53048(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_e3c(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c624(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_c624(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c624(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_c624(1)
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
		helper_13e53048(30)
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
		helper_13e53048(30)
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
	helper_13e53048(4)
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
local function helper_fdfc(arg0: s32)
	return helper_db30(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1884(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		helper_1884(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
	end
	program_99()
	flag = event.GetFlag(704) or flag
	if flag == 0 then
		helper_10394()
		if vm.skipping() then
			return skip(1)
		end
		helper_1884(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.8, -200.0)
		event.SetCameraPos(0.0, 40.8, -80.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_1884(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 38.4, 685.0)
		event.SetCameraPos(0.0, 48.4, 565.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_ff20()
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

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_84d0(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_13e53048(16)
		end
		if at <= 4 then
			helper_c764(374, 1)
		end
		if at <= 5 then
			helper_330d2062(1)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_84d0(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_84d0(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	argc = event.GetNextFloor(var2, 0) or argc
	event.DngSetFloorId(argc)
	event.SetFloorInfo(stage_id, var2, 5, 2)
	event.SetFloorInfo(stage_id, argc, 5, 1)
	helper_13e53048(6)
	if vm.skipping() then
		return skip(3)
	end
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var4, var5, var6, 10)
	helper_13e53048(16)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncObj(1, "p06s21")
	event.EohSetShow(1, 0)
	event.AddItem(374)
	helper_c764(374, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFloorInfo(6, 11, 5, 2)
	event.FuncPointShow("", "item", 0)
	helper_330d2062(1)
	if vm.skipping() then
		return skip(6)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fdfc(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17040.
script[17040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10394()
	if vm.skipping() then
		return skip(1)
	end
end

return script
