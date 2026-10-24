--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_f37e8af2 = require("@lib/event/helper_f37e8af2")

--- Helper function.
local function helper_43975909()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 52 then
			if at <= 1 then
				helper_1f9a3afd(7280160, 280)
			end
			if at <= 2 then
				helper_8f31f334(2)
			end
			if at <= 3 then
				helper_57ae27b6(1)
			end
			if at <= 4 then
				helper_27ff0b8f(0, -1, 8, 0, 0)
				helper_aafd6a80(180)
			end
			if at <= 5 then
				helper_f37e8af2(0, -1)
			end
			if at <= 6 then
				helper_dd7a6f53(0)
				helper_8f31f334(2)
			end
			if at <= 7 then
				helper_aafd6a80(60)
			end
			if at <= 8 then
				helper_aafd6a80(30)
			end
			if at <= 9 then
				helper_1f9a3afd(7280165, 90)
			end
			if at <= 10 then
				helper_aafd6a80(60)
			end
			if at <= 11 then
				helper_184013af()
			end
			if at <= 12 then
				helper_1f9a3afd(7280170, 150)
			end
			if at <= 13 then
				helper_1f9a3afd(7280180, 120)
			end
			if at <= 14 then
				helper_aafd6a80(30)
			end
			if at <= 15 then
				helper_1f9a3afd(7280190, 500)
			end
			if at <= 16 then
				helper_184013af()
			end
			if at <= 17 then
				helper_aafd6a80(30)
			end
			if at <= 18 then
				helper_1f9a3afd(7280200, 210)
			end
			if at <= 19 then
				helper_8f31f334(2)
			end
			if at <= 20 then
				helper_1f9a3afd(7280210, 480)
			end
			if at <= 21 then
				helper_8f31f334(2)
			end
			if at <= 22 then
				helper_1f9a3afd(7280220, 210)
			end
			if at <= 23 then
				helper_8f31f334(2)
			end
			if at <= 24 then
				helper_8f31f334(1)
			end
			if at <= 25 then
				helper_aafd6a80(60)
			end
			if at <= 26 then
				helper_aafd6a80(60)
			end
			if at <= 27 then
				helper_1f9a3afd(7280230, 240)
			end
			if at <= 28 then
				helper_184013af()
			end
			if at <= 29 then
				helper_aafd6a80(60)
			end
			if at <= 30 then
				helper_aafd6a80(45)
			end
			if at <= 31 then
				helper_aafd6a80(5)
			end
			if at <= 32 then
				helper_1f9a3afd(7280235, 90)
			end
			if at <= 33 then
				helper_aafd6a80(90)
			end
			if at <= 34 then
				helper_8f31f334(3)
			end
			if at <= 35 then
				helper_aafd6a80(30)
			end
			if at <= 36 then
				helper_aafd6a80(90)
			end
			if at <= 37 then
				helper_aafd6a80(60)
			end
			if at <= 38 then
				helper_aafd6a80(100)
			end
			if at <= 39 then
				helper_aafd6a80(30)
			end
			if at <= 40 then
				helper_aafd6a80(60)
			end
			if at <= 41 then
				helper_1f9a3afd(7280240, 90)
			end
			if at <= 42 then
				helper_1f9a3afd(7280245, 210)
			end
			if at <= 43 then
				helper_aafd6a80(90)
			end
			if at <= 44 then
				helper_aafd6a80(30)
			end
			if at <= 45 then
				helper_aafd6a80(30)
			end
			if at <= 46 then
				helper_aafd6a80(90)
			end
			if at <= 47 then
				helper_184013af()
			end
			if at <= 48 then
				helper_aafd6a80(30)
			end
			if at <= 49 then
				helper_aafd6a80(30)
			end
			if at <= 50 then
				helper_aafd6a80(90)
			end
			if at <= 51 then
				helper_aafd6a80(31)
			end
			if vm.skip_end() then
				return skip(53)
			end
			return part2()
		end
		if at <= 53 then
			helper_aafd6a80(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMotionBlur(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 8)
		var2 = event.GetBgmNo() or var2
		if var2 ~= 37 then
			event.StopBgm(0)
			helper_aafd6a80(4)
			if vm.skipping() then
				return skip(54)
			end
			event.LoadBgm(37)
			event.PlayBgm(0)
		end
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
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.LoadMes(0, -1)
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7835)
	var0 = event.SndLoadSound(7835) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e728/")
	event.LoadMes(0, 5, "e728_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e728_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e728_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e728_dark.gltf", "info", 10, 1)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e728_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e728_magic_h.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e728_magic_l.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e728_dehikari.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(7, 14)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e728_san_hit.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(8, 15)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncObj(6, "p06_d06b03-0")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetScale(6, 0.7, 0.7, 0.7)
	event.EohSetPos(1, -1.42, 0.0, -83.64)
	event.EohSetRot(1, 0.0, -0.12, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, -23.19, 0.0, -81.74)
	event.EohSetRot(0, 0.0, 0.26, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, -12.34, 0.0, 42.31)
	event.EohSetRot(2, 0.0, -3.07, 0.0)
	event.EohSetFootSoundId(2, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.SetReference(10, "tama", 14)
	event.EohSetPos(3, 452.27, -10000, 254.12)
	event.EohSetRot(3, 0.0, -0.1, 0.0)
	event.EohSetFootSoundId(3, 1)
	event.EohSetPos(8, 452.27, -10000, 254.12)
	event.EohSetRot(8, 0.0, -0.1, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(8, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetProjection(360.9)
	event.CmrsInit()
	event.CmrsSetPos(6.95, 33.33, -38.64)
	event.CmrsSetRef(2.96, 21.19, 34.24)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove2(6.95, 33.33, -38.64, -16.79, 86.78, 30.71, 120, 2, 1.0)
	helper_1f9a3afd(7280160, 280)
	if vm.skipping() then
		return skip(2)
	end
	event.SetProjection(524.9)
	event.CmrsSetPos(-17.25, 2.73, -179.23)
	event.CmrsSetRef(-11.0, 60.16, -36.27)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "手を上げる", 6)
	event.ObjsNextMotion(2, "手を上げるL", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMotionDelay(2, 180)
	event.ObjsSetMotion(2, "死に絶えるのだ", 6)
	event.ObjsNextMotion(2, "死に絶えるのだL", 4)
	event.ObjsSeDelay(2, 180)
	event.ObjsSePlay(2, var0, 1)
	event.StreamOpen3(1, 7280163)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, 7280163)
	helper_27ff0b8f(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_aafd6a80(180)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(1.58, 101.91, -60.95)
	event.CmrsSetRef(-17.89, 92.73, 25.56)
	helper_f37e8af2(0, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_dd7a6f53(0)
	event.StreamClose(1)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-37.44, 9.97, -30.69)
	event.CmrsSetRef(1007.77, 434.9, -2136.35)
	event.CmrsQuake2(0.0, 3.3, 0.0, 60)
	event.SndSePlay(var0, 2)
	event.EohSetShow(6, 1)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "口とじ～大口")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	helper_1f9a3afd(7280165, 90)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-5.51, 54.41, -260.22)
	event.CmrsSetRef(-13.59, 43.11, -47.5)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetScale(6, 1.0, 1.0, 1.0, 180)
	event.ObjsSetMotion(2, "振り返る", 6)
	event.ObjsNextMotion(2, "上見立ち", 4)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsMove2(-5.51, 375.83, -260.22, -4.47, 459.86, -47.34, 120, 0, 1.0)
	helper_184013af()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-44.01, 88.99, -11.02)
	event.CmrsSetRef(-13.6, 22.3, -75.12)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_1f9a3afd(7280170, 150)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(7280180, 120)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsMove2(-88.64, 165.69, 144.36, -18.85, 102.29, 59.43, 120, 0, 0.5)
	event.SndSeStop(var0, 2)
	event.SndSePlay(var0, 3)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_1f9a3afd(7280190, 500)
	if vm.skipping() then
		return skip(16)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-14.82, 6.49, -265.28)
	event.CmrsSetRef(-12.4, 63.83, -45.92)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "振り返る2", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_1f9a3afd(7280200, 210)
	if vm.skipping() then
		return skip(19)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(2, "闇世界の王", 6)
	event.ObjsNextMotion(2, "闇世界の王L", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var0, 5)
	helper_1f9a3afd(7280210, 480)
	if vm.skipping() then
		return skip(21)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-45.16, 123.78, 11.64)
	event.CmrsSetRef(-7.21, 140.87, 80.61)
	event.StopBgm(0)
	event.CharaActive(13)
	event.ObjsSetPos(5, -9.83, 0.0, -376.53)
	event.ObjsSetMotion(5, "魔法かまえ")
	event.ObjsSetMotion(3, "魔法かまえ", 4)
	event.ObjsSetPos(3, -9.83, 0.0, -376.53)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(8, -9.83, 0.0, -376.53)
	event.ObjsSetMotion(2, "フハハハハ", 4)
	helper_1f9a3afd(7280220, 210)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(12)
	event.ObjsSetPos(4, -16.64, 87.63, 60.46)
	event.ObjsSetRot(4, 0.0, -3.07, 0.0)
	event.ObjsSetMotion(4, "魔法あたる", 6)
	event.ObjsSetMotion(2, "魔法あたる", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSeStop(var0, 3)
	event.CmrsSetPos(-12.59, 20.81, -29.79)
	event.CmrsSetRef(-11.75, 19.91, -100.77)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "後ろ見る", 6)
	event.ObjsNextMotion(0, "後ろ見るL", 4)
	event.ObjsSetMotion(1, "後ろ見", 6)
	event.ObjsNextMotion(1, "後ろ見L", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(25)
	end
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-0.53, 9.74, -325.24)
	event.CmrsSetRef(-10.06, 15.31, -377.35)
	event.ObjsTexAnime(3, 0)
	event.SndSePlay(var0, 8)
	event.ObjsTexAnime(3, 1, "つかれ目パチ")
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSeStop(var0, 8)
	event.CmrsSetPos(8.44, 122.24, -79.64)
	event.CmrsSetRef(17.47, 121.82, 84.02)
	event.CharaActive(0, 13)
	event.CmrsMove(-31.27, 122.24, -88.16, -24.72, 121.82, 75.61, 240)
	helper_1f9a3afd(7280230, 240)
	if vm.skipping() then
		return skip(28)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-143.28, 120.11, -54.02)
	event.CmrsSetRef(-4.2, 126.33, 56.81)
	event.SndSePlay(var0, 9)
	event.ObjsSetMotion(2, "杖投げる", 6)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-63.01, 36.02, -308.06)
	event.CmrsSetRef(6.33, 11.27, -369.11)
	event.SetModelLightSwitch(10, 0)
	event.SetModelLightColor(10, 128.0, 128.0, 128.0, 128.0)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "杖投げる", 6)
	event.ObjsSetScale(2, 0.5, 1.0, 1.0)
	event.ObjsSetPos(2, 6.23, -0.75, -116.64)
	event.ObjsResetDaPosition(2)
	event.ObjsSeDelay(3, 45)
	event.ObjsSePlay(3, var0, 10)
	event.ObjsMotionDelay(3, 45)
	event.ObjsSetMotion(3, "刺さる", 6)
	event.ObjsNextMotion(3, "刺さるL", 4)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(31)
	end
	event.EohSetShow(8, 1)
	event.ObjsSetMotion(8, "刺さる", 6)
	helper_aafd6a80(5)
	if vm.skipping() then
		return skip(32)
	end
	helper_1f9a3afd(7280235, 90)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(-13.1, 29.49, -152.47)
	event.CmrsSetRef(-13.69, 6.9, -67.55)
	event.EohSetShow(8, 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(1, -1.96, 0.0, -78.42)
	event.ObjsSetRot(1, 0.0, -0.48, 0.0)
	event.ObjsResetDaPosition(1)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(-139.53, 12.92, -295.36)
	event.CmrsSetRef(-5.92, 14.31, -385.02)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0)
	event.ObjsSetPos(2, 4.32, 1.63, -115.01)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(2, 4.32, 25.63, -115.01, 120)
	event.ObjsMove(3, -9.83, 25.0, -376.53, 120)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(35)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(-10.74, 103.97, -46.08)
	event.CmrsSetRef(-10.95, 122.33, 62.77)
	event.SetModelLightSwitch(10, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(2, "カモーン", 6)
	event.ObjsNextMotion(2, "カモーンL", 4)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(-139.53, 12.92, -295.36)
	event.CmrsSetRef(-5.92, 14.31, -385.02)
	event.SetModelLightSwitch(10, 0)
	event.SetModelLightColor(10, 128.0, 128.0, 128.0, 128.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0)
	event.ObjsSetPos(2, 4.32, 25.63, -115.01)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(2, 13.34, 42.27, -29.33, 10)
	event.SndSePlay(var0, 12)
	event.ObjsMotionDelay(3, 10)
	event.ObjsSetMotion(3, "落ちる", 6)
	event.ObjsNextMotion(3, "落ちるL", 4)
	event.ObjsMove(3, -9.83, 0.0, -376.53, 30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(38)
	end
	event.SetModelLightSwitch(10, 1)
	event.CmrsSetPos(8.05, 9.57, -432.58)
	event.CmrsSetRef(-4.2, 9.01, -384.9)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(0, -27.05, 0.0, -181.8)
	event.ObjsSetRot(0, 0.0, 3.06, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 7.3, 0.0, -200.98)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, -25.77, 0.0, -317.97, 120)
	event.ObjsRotation(0, 0.0, 2.94, 0.0, 120)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, 4.82, 0.0, -318.77, 120)
	event.ObjsRotation(1, 0.0, -3.0, 0.0, 120)
	helper_aafd6a80(100)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(-31.52, 44.28, -338.11)
	event.CmrsSetRef(-5.77, 5.41, -388.31)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -24.38, 0.0, -382.48)
	event.ObjsSetRot(0, 0.0, 2.22, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 10.7, 0.0, -369.54)
	event.ObjsSetRot(1, 0.0, -2.64, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ２～くるし目")
	event.ObjsSetMotion(0, "しゃがむ", 6)
	event.ObjsNextMotion(0, "しゃがむL", 4)
	event.ObjsMotionDelay(1, 15)
	event.ObjsSetMotion(1, "しゃがみ", 6)
	event.ObjsNextMotion(1, "しゃがみL", 4)
	event.ObjsSetMotion(3, "ユリス見る", 6)
	event.ObjsNextMotion(3, "ユリス見るL", 4)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(41)
	end
	helper_1f9a3afd(7280240, 90)
	if vm.skipping() then
		return skip(42)
	end
	helper_1f9a3afd(7280245, 210)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目～おこり目")
	event.ObjsTexAnime(0, 1, "歯くいしばり")
	event.CmrsSetPos(-6.87, 5.41, -405.85)
	event.CmrsSetRef(-26.19, 16.97, -379.68)
	event.ObjsSetMotion(3, "落ちるL", 6)
	event.ObjsSetPos(1, 10.32, 0.0, -384.63)
	event.ObjsResetDaPosition(1)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.LoadBgm(37)
	event.PlayBgm(0)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(45)
	end
	event.SndSePlay(var0, 13)
	event.ObjsSetMotion(0, "しゃがむ戻り", 6)
	event.ObjsRotation(0, 0.0, 0.18, 0.0, 20)
	event.ObjsMotionDelay(0, 20)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "おきあがり", 6)
	event.ObjsRotation(1, 0.0, -0.24, 0.0, 20)
	event.ObjsMotionDelay(1, 20)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsSetPos(-11.62, 15.51, -310.99)
	event.CmrsSetRef(-10.21, 16.97, -375.48)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(46)
	end
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(21.35, 75.0, -74.7)
	event.CmrsSetRef(-18.07, 133.59, 68.07)
	event.ObjsSetPos(0, -17.05, 0.0, -260.83)
	event.ObjsSetRot(0, 0.0, 0.3, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 20.43, 0.0, -290.0)
	event.ObjsSetRot(1, 0.0, 0.12, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsMove2(71.01, 5.64, -395.51, -82.14, 81.58, 45.26, 120, 2, 1.0)
	helper_184013af()
	if vm.skipping() then
		return skip(48)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(-14.25, 113.8, -124.29)
	event.CmrsSetRef(-12.74, 114.05, 57.05)
	event.ObjsSetMotion(2, "杖構える", 6)
	event.ObjsNextMotion(2, "杖構えるL", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var0, 14)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(50)
	end
	event.SetMotionBlur(100)
	event.CmrsQuake2(0.0, 8.5, 5.5, 150)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(51)
	end
	event.SetFadeOut(20, 255, 255, 255)
	helper_aafd6a80(31)
	if vm.skipping() then
		return skip(52)
	end
	return part2()
end

return helper_43975909
