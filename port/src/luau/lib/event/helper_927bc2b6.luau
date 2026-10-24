--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_927bc2b6()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 17 then
			if at <= 1 then
				helper_2386f745(0)
			end
			if at <= 2 then
				helper_c1c32f84(30)
			end
			if at <= 3 then
				helper_07cf3e45(6400010, -1)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if at <= 5 then
				helper_07cf3e45(6400020, -1)
			end
			if at <= 6 then
				helper_c1c32f84(20)
			end
			if at <= 7 then
				helper_c1c32f84(10)
			end
			if at <= 8 then
				helper_c1c32f84(45)
			end
			if at <= 9 then
				helper_c1c32f84(140)
			end
			if at <= 10 then
				helper_c1c32f84(140)
			end
			if at <= 11 then
				helper_2386f745(4)
			end
			if at <= 12 then
				helper_c1c32f84(90)
			end
			if at <= 13 then
				helper_07cf3e45(6400030, -1)
			end
			if at <= 14 then
				helper_c1c32f84(30)
			end
			if at <= 15 then
				helper_07cf3e45(6400040, -1)
			end
			if at <= 16 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(18)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SetMotionBlur(0)
		event.StopBgm(0)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.LoadSound(6206)
	var0 = event.SndLoadSound(6206) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_hajike.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_hajike1.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, -7.1, 300.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -10.0, -7.1, 300.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(3, -2.85, 23.99, 5.49)
	event.EohSetPos(4, 491.48, 2937.75, -491.2)
	event.EohSetPos(2, -261.21, 2948.26, 263.88)
	event.EohSetRot(2, 0.0, 2.76, 0.0)
	event.EohSetShow(2, 0)
	event.ObjsSetMotion(2, "停止", 4)
	event.ObjsSetScale(2, 6.0, 6.0, 6.0)
	event.SetTime(0)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(0, 35)
	event.CharaActive(0, 36)
	event.CmrsInit()
	event.CmrsSetPos(464.69, 792.55, 769.26)
	event.CmrsSetRef(-8.98, 22.94, 15.83)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 13.62, -7.06, 180.22, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsNextMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -17.18, -7.06, 176.73, 120, 1)
	event.ObjsMotionDelay(1, 120)
	event.ObjsNextMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.CmrsSetPos(-6.27, -6.79, 122.45)
	event.CmrsSetRef(-6.44, 20.36, 185.12)
	event.ObjsSetPos(0, 3.4, -7.06, 176.16)
	event.ObjsResetDaPosition(0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsQuake2(0.0, 0.2, 0.0, -1)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(0, "キョロキョロ")
	event.ObjsSetMotion(1, "きょろきょろ")
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(6400010, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(6400020, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSeStop(var0, 0)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsInit()
	event.CmrsSetPos(731.98, 1651.1, -1178.87)
	event.CmrsSetRef(572.56, 1335.85, -926.68)
	event.SndSePlay(var0, 1)
	event.CharaActive(35)
	event.ObjsSetMotion(3, "ラピスビームのみ", 6)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 35)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 1.12, -7.06, 174.14)
	event.ObjsSetRot(0, 0.0, -2.66, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.CmrsSetPos(515.15, 272.77, -565.02)
	event.CmrsSetRef(479.36, 1520.54, -493.2)
	event.SetMotionBlur(100)
	event.CharaActive(36)
	event.ObjsSetMotion(4, "ビーム収束", 6)
	event.ObjsNextMotion(4, "ループ", 4)
	event.ObjsMotionDelay(4, 65)
	event.ObjsNextMotion(4, "はじけ", 6)
	event.ObjsMotionWait(4)
	helper_c1c32f84(140)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(3959.58, 1269.87, -3946.94)
	event.CmrsSetRef(3453.93, 1511.55, -3437.8)
	helper_c1c32f84(140)
	if vm.skipping() then
		return skip(11)
	end
	event.SetCrossfade(30)
	event.SetCharaShow(34, 1, 1, 0.033333335)
	helper_2386f745(4)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetShow(4, 0)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMotionBlur(0)
	event.CmrsSetPos(-19.79, 61.27, 135.82)
	event.CmrsSetRef(-6.87, 2.39, 183.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(6400030, -1)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "やった！！", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_07cf3e45(6400040, -1)
	if vm.skipping() then
		return skip(16)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(17)
	end
	return part2()
end

return helper_927bc2b6
