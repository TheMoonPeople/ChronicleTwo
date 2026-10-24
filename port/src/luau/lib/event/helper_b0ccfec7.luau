--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_b0ccfec7()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 38 then
			if at <= 1 then
				helper_a0e17f3c(6)
			end
			if at <= 2 then
				helper_a0e17f3c(20)
			end
			if at <= 3 then
				helper_a0e17f3c(50)
			end
			if at <= 4 then
				helper_a0e17f3c(10)
			end
			if at <= 5 then
				helper_a0e17f3c(40)
			end
			if at <= 6 then
				helper_a19c5ee3(0)
			end
			if at <= 7 then
				helper_a19c5ee3(0)
			end
			if at <= 8 then
				helper_b35e85eb()
			end
			if at <= 9 then
				helper_b35e85eb()
			end
			if at <= 10 then
				helper_a0e17f3c(30)
			end
			if at <= 11 then
				helper_fa57afea(8160010)
			end
			if at <= 12 then
				helper_fa57afea(8160015)
			end
			if at <= 13 then
				helper_fa57afea(8160020)
			end
			if at <= 14 then
				helper_a19c5ee3(0)
			end
			if at <= 15 then
				helper_a0e17f3c(20)
			end
			if at <= 16 then
				helper_fa57afea(8160030)
			end
			if at <= 17 then
				helper_fa57afea(8160035)
			end
			if at <= 18 then
				helper_a0e17f3c(10)
			end
			if at <= 19 then
				helper_a0e17f3c(20)
			end
			if at <= 20 then
				helper_a0e17f3c(20)
			end
			if at <= 21 then
				helper_b35e85eb()
			end
			if at <= 22 then
				helper_a0e17f3c(30)
			end
			if at <= 23 then
				helper_a0e17f3c(10)
			end
			if at <= 24 then
				helper_fa57afea(8160040)
			end
			if at <= 25 then
				helper_fa57afea(8160050)
			end
			if at <= 26 then
				helper_fa57afea(8160060)
			end
			if at <= 27 then
				helper_fa57afea(8160070)
			end
			if at <= 28 then
				helper_fa57afea(8160080)
			end
			if at <= 29 then
				helper_fa57afea(8160090)
			end
			if at <= 30 then
				helper_b35e85eb()
			end
			if at <= 31 then
				helper_a19c5ee3(2)
			end
			if at <= 32 then
				helper_fa57afea(8160100)
			end
			if at <= 33 then
				helper_fa57afea(8160105)
			end
			if at <= 34 then
				helper_fa57afea(8160110)
			end
			if at <= 35 then
				helper_fa57afea(8160120)
			end
			if at <= 36 then
				helper_a19c5ee3(2)
			end
			if at <= 37 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(39)
			end
			return part2()
		end
		if at <= 39 then
			helper_a0e17f3c(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.SndSeStop(var1, 2)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SndSeStop(var1, 5)
		event.EohSetShow(4, 0)
		event.SpriteSetDraw(0, 0)
		event.SetMotionBlur(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.StopBgm(0)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(40)
		end
		event.LoadBgm(40)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(816, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_a0e17f3c(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.LoadSound(8809)
	var1 = event.SndLoadSound(8809) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e816/")
	event.LoadMes(0, 5, "e816_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e816_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e816_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e816_majin.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e816telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e816telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e816/e816_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e816/e816_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.LoadChara(5, "event/e200/e206/e206_bbaku.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncObj(4, "p04")
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetShow(4, 1)
	event.EohSetPos(0, 772.29, -72.1, 1522.76)
	event.EohSetRot(0, 0.0, -2.64, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, -1000.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetScale(2, 8.0, 8.0, 8.0)
	event.SetCharaPos(11, 974.5, 0.34, 1616.44)
	event.SetCharaRot(11, 0.0, 1.32, 0.0)
	event.SetScale(11, 1.0, 1.0, 1.0)
	if active_chr_no == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
	else
		event.CharaActive(0, 0)
	end
	event.InitDramaScene()
	event.ObjsPosDelay(0, 20)
	event.ObjsMove(0, 850.58, -72.1, 1669.29, 40)
	event.ObjsRotDelay(0, 20)
	event.ObjsRotation(0, 0.0, 0.52, 0.0, 8)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(988.97, 77.53, 1641.42)
	event.CmrsSetRef(768.43, -42.14, 1535.48)
	event.SetFadeIn(30)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 0)
	helper_a0e17f3c(50)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(var1, 0)
	event.SndSePlay(var1, 1)
	event.CmrsQuake2(0.0, 1.0, 0.0, 50)
	event.CharaActive(11)
	event.SetMotion(11, "ｴﾌｪｸﾄ_バギー爆発", 6)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetShow(4, 0)
	event.ObjsSetRot(0, 0.0, -2.6, 0.0)
	helper_a0e17f3c(40)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(0, 805.68, -72.1, 1578.18, 90)
	event.ObjsSetMotion(0, "歩き")
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(526.21, 180.7, 925.23)
	event.CmrsSetRef(591.71, 28.27, 1249.82)
	if active_chr_no == 0 then
		event.CharaActive(1, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 0)
	end
	event.ObjsSetPos(0, 647.7, -69.42, 1336.0)
	event.ObjsSetRot(0, 0.0, -2.48, 0.0)
	event.ObjsMove(0, 594.08, -64.59, 1267.87, 90)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 642.51, -70.56, 1362.06)
	event.ObjsSetRot(1, 0.0, -2.6, 0.0)
	event.ObjsMove(1, 586.91, -65.57, 1291.72, 90)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(680.66, 6.68, 980.64)
	event.CmrsSetRef(575.95, -0.27, 930.94)
	event.CmrsMove2(680.66, 6.68, 980.64, 608.93, 31.74, 882.58, 40, 0, 0.4)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsMove2(680.66, 6.68, 980.64, 576.22, 34.02, 919.65, 14, 2, 0.2)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(10)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(577.41, -36.52, 1231.62)
	event.CmrsSetRef(593.55, -49.69, 1286.96)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.ObjsSetMotion(0, "指さす", 6)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(8160010)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(8160015)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(8160020)
	if vm.skipping() then
		return skip(14)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-175.42, 20.69, 292.74)
	event.CmrsSetRef(-130.55, 18.84, 404.37)
	event.FadeOutBgm(60)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetPos(0, 30.86, -3.88, 469.02)
	event.ObjsSetRot(0, 0.0, -2.12, 0.0)
	event.ObjsMove(0, -163.18, 0.0, 334.91, 50)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 6)
	event.ObjsSetMotion(0, "キョロキョロ", 4)
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetPos(1, 73.45, -7.05, 525.46)
	event.ObjsSetRot(1, 0.0, -2.12, 0.0)
	event.ObjsMove(1, -116.94, 0.0, 392.73, 60)
	event.ObjsRotDelay(1, 50)
	event.ObjsRotation(1, 0.0, 2.84, 0.0, 10)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(16)
	end
	helper_fa57afea(8160030)
	if vm.skipping() then
		return skip(17)
	end
	helper_fa57afea(8160035)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(57.5, 40.21, 529.52)
	event.CmrsSetRef(-184.49, 8.41, 336.31)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, -182.92, 0.0, 359.09)
	event.ObjsSetRot(1, 0.0, -2.36, 0.0)
	event.ObjsSetPos(2, -367.65, 0.0, 193.54)
	event.ObjsSetRot(2, 0.0, 0.9, 0.0)
	event.ObjsSetMotion(2, "ふってくる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SndSePlay(var1, 3)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "ドスン", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "着地振動", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.CmrsQuake(0.0, 8.0, 0.0, 40)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsMove2(57.5, 40.21, 529.52, -184.49, 99.45, 336.31, 60, 0, 0.2)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(21)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128, 128, 128, 128, 20)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(23)
	end
	event.SpriteSetDraw(0, 0)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-201.98, 60.97, 306.62)
	event.CmrsSetRef(-164.55, 1.55, 356.48)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(8160040)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(8160050)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(8160060)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetRef(-332.71, 270.78, 221.57)
	event.CmrsSetAhd(0.43, -34.0, 115.0)
	event.CmrsMoveAhd2(1.54, -34.0, 115.0, 200, 0, 0.2)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_fa57afea(8160070)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_fa57afea(8160080)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_fa57afea(8160090)
	if vm.skipping() then
		return skip(30)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-314.29, 515.61, 172.37)
	event.CmrsSetRef(-286.23, 270.78, 236.95)
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(2, "覗き込み会話", 6)
	event.ObjsMotionWait(2)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(32)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 4, "覗き込み会話とまり", 0)
	helper_fa57afea(8160100)
	if vm.skipping() then
		return skip(33)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
	helper_fa57afea(8160105)
	if vm.skipping() then
		return skip(34)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(8160110)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
	helper_fa57afea(8160120)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(2, "一歩前へ", 6)
	event.ObjsNextMotion(2, "一歩前へＬ", 4)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(37)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(38)
	end
	return part2()
end

return helper_b0ccfec7
