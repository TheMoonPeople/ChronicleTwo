--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d6fefb8 = require("@lib/event/helper_4d6fefb8")
local helper_5c88e2f9 = require("@lib/event/helper_5c88e2f9")
local helper_b17f3e99 = require("@lib/event/helper_b17f3e99")
local helper_bc115506 = require("@lib/event/helper_bc115506")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")

--- Helper function.
local function helper_56b42349()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 48 then
			if at <= 1 then
				helper_bc115506(5320390)
			end
			if at <= 2 then
				helper_bc115506(5320400)
			end
			if at <= 3 then
				helper_bc115506(5320410)
			end
			if at <= 4 then
				helper_4d6fefb8()
			end
			if at <= 5 then
				helper_bc115506(5320420)
			end
			if at <= 6 then
				helper_bc115506(5320430)
			end
			if at <= 7 then
				helper_bc115506(5320435)
			end
			if at <= 8 then
				helper_4d6fefb8()
			end
			if at <= 9 then
				helper_bc115506(5320440)
			end
			if at <= 10 then
				helper_5c88e2f9(2)
			end
			if at <= 11 then
				helper_bc115506(5320450)
			end
			if at <= 12 then
				helper_4d6fefb8()
			end
			if at <= 13 then
				helper_bc115506(5320460)
			end
			if at <= 14 then
				helper_bc115506(5320465)
			end
			if at <= 15 then
				helper_c85a55f2(12)
			end
			if at <= 16 then
				helper_5c88e2f9(2)
			end
			if at <= 17 then
				helper_c85a55f2(5)
			end
			if at <= 18 then
				helper_c85a55f2(5)
			end
			if at <= 19 then
				helper_5c88e2f9(2)
			end
			if at <= 20 then
				helper_c85a55f2(20)
			end
			if at <= 21 then
				helper_c85a55f2(10)
			end
			if at <= 22 then
				helper_4d6fefb8()
			end
			if at <= 23 then
				helper_c85a55f2(30)
			end
			if at <= 24 then
				helper_5c88e2f9(2)
			end
			if at <= 25 then
				helper_bc115506(5320480)
			end
			if at <= 26 then
				helper_5c88e2f9(2)
			end
			if at <= 27 then
				helper_4d6fefb8()
			end
			if at <= 28 then
				helper_bc115506(5320490)
			end
			if at <= 29 then
				helper_4d6fefb8()
			end
			if at <= 30 then
				helper_bc115506(5320500)
			end
			if at <= 31 then
				helper_bc115506(5320510)
			end
			if at <= 32 then
				helper_bc115506(5320515)
			end
			if at <= 33 then
				helper_bc115506(5320520)
			end
			if at <= 34 then
				helper_4d6fefb8()
			end
			if at <= 35 then
				helper_bc115506(5320530)
			end
			if at <= 36 then
				helper_bc115506(5320540)
			end
			if at <= 37 then
				helper_b17f3e99()
			end
			if at <= 38 then
				helper_4d6fefb8()
			end
			if at <= 39 then
				helper_c85a55f2(10)
			end
			if at <= 40 then
				helper_c85a55f2(4)
			end
			if at <= 41 then
				helper_5c88e2f9(1)
			end
			if at <= 42 then
				helper_c85a55f2(10)
			end
			if at <= 43 then
				helper_c85a55f2(10)
			end
			if at <= 44 then
				helper_bc115506(5320550)
			end
			if at <= 45 then
				helper_bc115506(5320560)
			end
			if at <= 46 then
				helper_c85a55f2(90)
			end
			if at <= 47 then
				helper_c85a55f2(30)
			end
			if vm.skip_end() then
				return skip(49)
			end
			return part2()
		end
		if at <= 49 then
			helper_c85a55f2(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 16)
		var3 = event.GetBgmNo() or var3
		if var3 ~= 35 then
			event.StopBgm(0)
			helper_c85a55f2(4)
			if vm.skipping() then
				return skip(50)
			end
			event.LoadBgm(35)
			event.PlayBgm(0)
		end
		event.SpriteSetDraw(0, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.SpriteSetDraw(3, 0)
		event.SpriteSetDraw(4, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.DeleteChara(13)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(3, 1)
		event.EohSetShow(4, 1)
	end
	event.SetFlag(532, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.LoadSound(5822)
	var1 = event.SndLoadSound(5822) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e532_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e532_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e532_guiltoni.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e532_m_guil.gltf", "p00_23a", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(10, 13)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 10)
	event.LoadChara(5, "e532_kawaru_hikari.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e532_guil_kage.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.LoadChara(5, "e532_tgate_f.gltf", "info", 17)
	event.CharaActive(0, 17)
	event.LoadChara(5, "e532_tgate_h.gltf", "info", 18)
	event.CharaActive(0, 18)
	block = event.LoadImg_4(5, "e532telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e532telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 347)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(12, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 12)
	event.ChangeDir("")
	event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 19)
	event.CharaActive(0, 19)
	if active_chr_no == 1 then
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e532/e532_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetPos(1, -34.13, 0.0, -72.15)
	event.EohSetRot(1, 0.0, 0.46, 0.0)
	event.EohSetMotion(1, "立つL", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "下向き立ち", 4)
	event.EohNormalDrive(2)
	event.EohResetDaPosition(2)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.EohSetPos(10, 48.15, 0.0, -39.92)
	event.EohSetRot(10, 0.0, -0.96, 0.0)
	event.EohSetMotion(10, "立ち2", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1.0, 31.0, 23.46)
	event.CmrsSetRef(1.0, 31.0, 1.39)
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320380)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320390)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(32.47, 29.12, 7.82)
	event.CmrsSetRef(-0.08, 29.06, 7.66)
	event.CmrsMove2(32.49, 29.12, 2.2, -0.05, 29.06, 2.04, 90, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320400)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320410)
	if vm.skipping() then
		return skip(4)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-11.1, 23.74, 47.57)
	event.CmrsSetRef(-11.12, 23.68, 10.21)
	event.CmrsMove2(1.26, 23.74, 47.57, 1.24, 23.68, 10.2, 120, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320420)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320430)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320435)
	if vm.skipping() then
		return skip(8)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(21.93, 20.24, 29.75)
	event.CmrsSetRef(0.34, 28.43, 3.64)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あき")
	event.ObjsSetMotion(2, "普通立ちへ", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320440)
	if vm.skipping() then
		return skip(10)
	end
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(21.31, 32.88, -28.93)
	event.CmrsSetRef(15.92, 30.08, 1.51)
	event.CmrsMove2(11.89, 32.88, -30.6, 6.5, 30.08, -0.16, 90, 2, 1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320450)
	if vm.skipping() then
		return skip(12)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(21.93, 20.24, 29.75)
	event.CmrsSetRef(0.34, 28.43, 3.64)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320460)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320465)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var1, 13)
	event.ObjsRotation(2, 0.0, 2.04, 0.0, 12)
	event.ObjsMove(2, 112.86, 0.0, -57.4, 120)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 120)
	event.ObjsSetMotion(2, "立ち")
	helper_c85a55f2(12)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(12.52, 143.33, 237.6)
	event.CmrsSetRef(19.7, 10.27, 44.27)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(17)
	end
	helper_c85a55f2(5)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(193.83, 30.9, -96.26)
	event.CmrsSetRef(115.38, 26.4, -60.1)
	event.ObjsSetRot(0, 0.0, 2.54, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, 1.54, 0.0)
	event.ObjsResetDaPosition(1)
	helper_c85a55f2(5)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var1, 14)
	event.ObjsSetMotion(2, "魔法構え", 2)
	event.ObjsNextMotion(2, "魔法構えL", 4)
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var1, 15)
	event.CharaActive(1, 17)
	event.SetCharaPos(17, 112.86, 0.0, -57.4)
	event.SetCharaRot(17, 0.0, 2.04, 0.0)
	event.SetMotion(17, "魔法構えL", 6)
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(93.61, 28.03, 33.84)
	event.CmrsSetRef(141.27, 27.9, -88.39)
	event.CmrsMove2(139.2, 30.07, -23.94, 196.24, 29.95, -119.09, 60, 2, 0.4)
	event.CharaActive(1, 18)
	event.SetCharaPos(18, 177.89, 30.0, -88.76)
	event.SetCharaRot(18, 0.0, 0.0, 0.0)
	event.SetMotion(18, "発生", 6)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(1, 19)
	event.SetCharaPos(19, 177.89, 30.0, -88.76)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.SetCharaShow(19, 1, 1, 0.1)
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(23)
	end
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-83.46, 20.24, 40.29)
	event.CmrsSetRef(25.57, 18.02, -14.67)
	event.ObjsSetPos(0, -34.9, 0.0, 31.89)
	event.ObjsSetRot(0, 0.0, 2.18, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -54.15, 0.0, 12.15)
	event.ObjsSetRot(1, 0.0, 2.02, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsMove(2, 149.89, 0.0, -76.07, 40)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(195.01, 15.44, -79.93)
	event.CmrsSetRef(159.74, 21.63, -83.99)
	event.StopBgm(0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目～くるし目")
	event.SndSePlay(var1, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.CharaActive(0, 19)
	event.CharaActive(1, 15)
	event.SetCharaShow(15, 1, 1, 0.033333335)
	event.SetCharaPos(15, 161.48, 0.0, -80.57)
	event.SetCharaRot(15, 0.0, 2.04, 0.0)
	event.ObjsSetMotion(2, "うぐっ", 6)
	event.ObjsNextMotion(2, "頭抱え", 6)
	event.ObjsNextMotion(2, "頭抱えL", 4)
	event.ObjsSePlay(2, var1, 17)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var1, 18)
	event.ObjsTexaDelay(2, 30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目パチ")
	event.ObjsTexAnime(2, 1, "口とじ～大口")
	event.CmrsPrdelay(30)
	event.CmrsSetPos(185.9, 26.26, -83.55)
	event.CmrsSetRef(160.82, 28.01, -82.54)
	event.CmrsMove2(225.88, 13.42, -85.2, 160.83, 18.04, -82.53, 60, 0, 1.0)
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320480)
	if vm.skipping() then
		return skip(26)
	end
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(27)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-153.15, 54.88, 77.9)
	event.CmrsSetRef(-32.02, 26.4, 15.61)
	event.CmrsMove2(-153.15, 54.88, 77.9, -32.02, 93.93, 15.61, 60, 0, 1.0)
	helper_bc115506(5320490)
	if vm.skipping() then
		return skip(29)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-45.58, 18.39, -25.71)
	event.CmrsSetRef(-44.29, 20.81, 21.82)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 19)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320500)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(1, "上向く", 6)
	event.CmrsSetPos(152.29, 17.2, -116.31)
	event.CmrsSetRef(169.35, 16.15, -86.33)
	event.CmrsMoveRef(163.62, 23.13, -83.64, 120)
	event.CmrsMoveAhd2(1.42, -8.07, 36.58, 90, 0, 1.0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目パチ")
	event.ObjsSetMotion(2, "苦しむ", 6)
	event.ObjsNextMotion(2, "苦しむL", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var1, 20)
	helper_bc115506(5320510)
	if vm.skipping() then
		return skip(32)
	end
	helper_bc115506(5320515)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目とじ")
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320520)
	if vm.skipping() then
		return skip(34)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(-65.76, 1.45, 77.12)
	event.CmrsSetRef(-31.95, 23.15, 22.39)
	event.ObjsSetPos(0, -54.15, 0.0, 12.15)
	event.ObjsSetRot(0, 0.0, 2.02, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -34.9, 0.0, 31.89)
	event.ObjsSetRot(1, 0.0, 2.18, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320530)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_bc115506(5320540)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(27.41, 54.66, -24.03)
	event.CmrsSetRef(-38.65, 16.14, 19.92)
	event.CmrsMove2(27.41, 88.01, -24.03, -38.65, 16.14, 19.92, 60, 2, 1.0)
	event.SndSePlay(var1, 21)
	event.CharaActive(0, 15)
	event.CharaActive(0, 11)
	event.CharaActive(1, 16)
	event.SetCharaPos(16, 98.8, 0.0, -70.68)
	event.SetCharaRot(16, 0.0, 2.16, 0.0)
	event.SetMotion(16, "伸びる", 6)
	event.ObjsSetMotion(0, "ギル巨大化", 6)
	event.ObjsNextMotion(0, "ギル巨大化L", 4)
	event.ObjsSetMotion(1, "ギル巨大化", 6)
	event.SetLoadbgFile("snd2/bgm/bg_035.sound.json")
	helper_b17f3e99()
	if vm.skipping() then
		return skip(38)
	end
	event.LoadBgmPack(35)
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(39)
	end
	event.CharaActive(0, 16)
	event.PlayBgm(0)
	event.CmrsSetPos(-201.41, 27.8, 185.21)
	event.CmrsSetRef(-35.48, 67.52, 28.17)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.SndSeStop(var1, 16)
	event.CharaActive(1, 13)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(40)
	end
	event.SndSePlay(var1, 22)
	event.ObjsSetMotion(8, "攻撃１", 6)
	event.ObjsNextMotion(8, "攻撃１ループ", 4)
	helper_c85a55f2(4)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(0, "よける", 6)
	event.ObjsSetMotion(1, "後ろ飛び", 6)
	event.ObjsMotionWait(1)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(42)
	end
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(-36.53, 21.01, 90.55)
	event.CmrsSetRef(-110.73, 24.73, 53.44)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.SndSePlay(var1, 23)
	event.ObjsSetPos(0, -130.27, 0.0, 15.93)
	event.ObjsSetMotion(0, "バトル立ち2", 4, -1.0, 1)
	event.ObjsSetPos(1, -64.55, 0.0, 84.34)
	event.ObjsSetMotion(1, "戦うしか", 4, -1.0, 1)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(1, "戦うしかユリス見", 2)
	event.ObjsNextMotion(1, "戦うしかユリス見L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320550)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(1, "上見へ", 2)
	event.ObjsNextMotion(1, "上見へL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320560)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-247.3, 94.84, 129.46)
	event.CmrsSetRef(-110.28, 94.53, 54.08)
	event.CmrsMove(-217.34, 94.84, 112.98, -110.28, 94.53, 54.08, 120)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(8, "立ち", 4)
	helper_c85a55f2(90)
	if vm.skipping() then
		return skip(47)
	end
	event.SetFadeOut(30)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(48)
	end
	return part2()
end

return helper_56b42349
