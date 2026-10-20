--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_d7e2d7c2()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 22 then
			if at <= 1 then
				helper_8f31f334(3)
			end
			if at <= 2 then
				helper_8f31f334(1)
			end
			if at <= 3 then
				helper_8f31f334(3)
			end
			if at <= 4 then
				helper_8f31f334(1)
			end
			if at <= 5 then
				helper_8f31f334(1)
			end
			if at <= 6 then
				helper_aafd6a80(30)
			end
			if at <= 7 then
				helper_aafd6a80(60)
			end
			if at <= 8 then
				helper_8f31f334(3)
			end
			if at <= 9 then
				helper_184013af()
			end
			if at <= 10 then
				helper_aafd6a80(60)
			end
			if at <= 11 then
				helper_6c719c99(6480030)
			end
			if at <= 12 then
				helper_6c719c99(6480040)
			end
			if at <= 13 then
				helper_1f9a3afd(6480050, 180)
			end
			if at <= 14 then
				helper_6c719c99(6480060)
			end
			if at <= 15 then
				helper_184013af()
			end
			if at <= 16 then
				helper_1f9a3afd(6480070, 90)
			end
			if at <= 17 then
				helper_6c719c99(6480075)
			end
			if at <= 18 then
				helper_6c719c99(6480080)
			end
			if at <= 19 then
				helper_6c719c99(6480090)
			end
			if at <= 20 then
				helper_aafd6a80(60)
			end
			if at <= 21 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(23)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 5)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetFootSoundId(2, 0)
		event.EohSetFootSoundId(3, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -2.21, 0.0, 25.73)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(648, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EyeViewDrawOnOff(1)
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(22)
	event.PlayBgm(0)
	event.LoadSound(6234)
	var0 = event.SndLoadSound(6234) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e648/")
	event.LoadMes(0, 5, "e648_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e648_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e648_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e648_eina.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e648_osmond.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(3, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s3701-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p06_s3701-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p07_s3701")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e600/e648/e648_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 3.38, -9.6, -127.86)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 23)
	event.EohSetPos(1, 19.72, -9.6, -146.14)
	event.EohSetRot(1, 0.0, -0.81, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 23)
	event.EohSetPos(3, 0.11, -2.82, -96.44)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち", 4)
	event.EohSetFootSoundId(3, 23)
	event.EohSetPos(2, 6.69, -90.34, 352.05)
	event.EohSetRot(2, 0.0, -3.12, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.ObjsSetScale(2, 5.0, 5.0, 5.0)
	event.EohSetShow(6, 1)
	event.EohSetRot(4, 0.0, -0.698, 0.0)
	event.EohSetRot(5, 0.0, 0.698, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-46.32, 72.59, -4.25)
	event.CmrsSetRef(17.61, 1.85, -139.47)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsMove(-21.97, 53.85, 239.94, -0.71, 18.82, 149.47, 240)
	event.ObjsSetMotion(3, "歩き")
	event.ObjsMove(3, -2.2, 0.4, 130.63, 210, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -17.63, 2.56, 106.07, 210, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 2.24, -9.6, -123.75, 40, 1)
	event.ObjsRotation(1, 0.0, 0.03, 0.0, 60)
	event.ObjsMove(1, 8.05, 2.56, 103.09, 200, 1)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(3, 17.35, 1.28, 162.87, 60, 1)
	event.ObjsRotation(3, 0.0, 0.6, 0.0, 12)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "立ち")
	event.ObjsMove(0, -23.89, 1.28, 151.76, 60, 1)
	event.ObjsRotation(0, 0.0, -0.21, 0.0, 12)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(1, 48.6, 2.56, 134.01, 60, 1)
	event.ObjsRotation(1, 0.0, 0.39, 0.0, 12)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(3, 0.45, 6.12, 164.04, 20)
	event.ObjsRotation(3, 0.0, 0.12, 0.0, 12)
	event.ObjsSetMotion(3, "座り２in", 6)
	event.ObjsNextMotion(3, "座り２", 4)
	event.SndSePlay(var0, 2)
	event.ObjsMove(0, -38.0, 1.28, 140.62, 20, 1)
	event.ObjsRotation(0, 0.0, -0.81, 0.0, 12)
	event.ObjsSetMotion(0, "座る", 6)
	event.ObjsNextMotion(0, "座るL", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove(1, 37.97, 1.28, 143.09, 20, 1)
	event.ObjsRotation(1, 0.0, 0.39, 0.0, 12)
	event.ObjsSetMotion(1, "すわる", 6)
	event.ObjsNextMotion(1, "すわるL", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var0, 4)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(4, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(5, 0.0, 0.0, 0.0, 60)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var0, 4)
	event.CmrsSetPos(-1.39, 81.74, 51.11)
	event.CmrsSetRef(-0.5, 5.15, 148.47)
	event.ObjsSetMotion(1, "モニタ見", 4)
	event.ObjsSetMotion(0, "モニタ見座り", 4)
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(3, "座り", 6)
	event.ObjsNextMotion(3, "いじる", 6)
	event.ObjsNextMotion(3, "座り", 4)
	event.CmrsMove(-0.45, 41.97, 94.94, 0.95, 44.66, 154.44, 120)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 6)
	helper_184013af()
	if vm.skipping() then
		return skip(10)
	end
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSeStop(var0, 5)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SetPakuAnim(2, "口パク")
	helper_6c719c99(6480030)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(2, "口パク")
	helper_6c719c99(6480040)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-8.29, 48.08, 237.9)
	event.CmrsSetRef(-26.87, 28.39, 169.28)
	event.CmrsMove(5.54, 48.08, 239.48, 27.19, 24.6, 164.47, 270)
	helper_1f9a3afd(6480050, 180)
	if vm.skipping() then
		return skip(14)
	end
	helper_6c719c99(6480060)
	if vm.skipping() then
		return skip(15)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-3.52, 33.93, 32.57)
	event.CmrsSetRef(-1.23, 25.71, 110.05)
	event.ObjsSetMotion(3, "座り２", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_1f9a3afd(6480070, 90)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_6c719c99(6480075)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-32.92, 60.21, 232.25)
	event.CmrsSetRef(-8.31, 19.18, 160.67)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "モニタ見うなづき", 6)
	event.ObjsNextMotion(0, "モニタ見座り", 4)
	event.SetPakuAnim(0, "\tわらい口パク")
	helper_6c719c99(6480080)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(1, "モニタうなずき", 6)
	event.ObjsNextMotion(1, "モニタ見", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6c719c99(6480090)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(3, "うなづく", 6)
	event.ObjsNextMotion(3, "座り２", 4)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(21)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(22)
	end
	return part2()
end

return helper_d7e2d7c2
