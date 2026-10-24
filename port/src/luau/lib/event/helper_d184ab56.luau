--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_278fcd8e = require("@lib/event/helper_278fcd8e")
local helper_384c5eb1 = require("@lib/event/helper_384c5eb1")
local helper_8c283814 = require("@lib/event/helper_8c283814")
local helper_99d125b7 = require("@lib/event/helper_99d125b7")

--- Helper function.
local function helper_d184ab56()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 38 then
			if at <= 1 then
				helper_384c5eb1(0)
			end
			if at <= 2 then
				helper_99d125b7(7020010, 100)
			end
			if at <= 3 then
				helper_99d125b7(7020020, 30)
			end
			if at <= 4 then
				helper_384c5eb1(0)
			end
			if at <= 5 then
				helper_8c283814()
			end
			if at <= 6 then
				helper_8c283814()
			end
			if at <= 7 then
				helper_100ac525(42)
			end
			if at <= 8 then
				helper_278fcd8e(7020030)
			end
			if at <= 9 then
				helper_278fcd8e(7020040)
			end
			if at <= 10 then
				helper_100ac525(20)
			end
			if at <= 11 then
				helper_384c5eb1(0)
			end
			if at <= 12 then
				helper_100ac525(20)
			end
			if at <= 13 then
				helper_100ac525(40)
			end
			if at <= 14 then
				helper_100ac525(44)
			end
			if at <= 15 then
				helper_278fcd8e(7020050)
			end
			if at <= 16 then
				helper_384c5eb1(1)
			end
			if at <= 17 then
				helper_278fcd8e(7020060)
			end
			if at <= 18 then
				helper_278fcd8e(7020070)
			end
			if at <= 19 then
				helper_278fcd8e(7020080)
			end
			if at <= 20 then
				helper_278fcd8e(7020085)
			end
			if at <= 21 then
				helper_384c5eb1(0)
			end
			if at <= 22 then
				helper_278fcd8e(7020090)
			end
			if at <= 23 then
				helper_384c5eb1(0)
			end
			if at <= 24 then
				helper_384c5eb1(1)
			end
			if at <= 25 then
				helper_278fcd8e(7020093)
			end
			if at <= 26 then
				helper_278fcd8e(7020097)
			end
			if at <= 27 then
				helper_8c283814()
			end
			if at <= 28 then
				helper_278fcd8e(7020100)
			end
			if at <= 29 then
				helper_8c283814()
			end
			if at <= 30 then
				helper_278fcd8e(7020110)
			end
			if at <= 31 then
				helper_278fcd8e(7020120)
			end
			if at <= 32 then
				helper_278fcd8e(7020130)
			end
			if at <= 33 then
				helper_384c5eb1(0)
			end
			if at <= 34 then
				helper_384c5eb1(1)
			end
			if at <= 35 then
				helper_278fcd8e(7020135)
			end
			if at <= 36 then
				helper_278fcd8e(7020140)
			end
			if at <= 37 then
				helper_100ac525(30)
			end
			if vm.skip_end() then
				return skip(39)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.SetFlag(702, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_100ac525(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(21)
	event.PlayBgm(0)
	event.LoadSound(7816)
	var1 = event.SndLoadSound(7816) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e702/")
	event.LoadMes(0, 5, "e702_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e702_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e702_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e700/e702/e702_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e700/e702/e702_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, 0.0, 600.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 21)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -10.0, 0.0, 600.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.ObjsMove(0, 8, 0.0, 500, 90)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(1, -8, 0.0, 500, 90)
	event.ObjsSetMotion(1, "歩き", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 44.63, 650.83)
	event.CmrsSetRef(0.0, 17.43, 579.14)
	event.CmrsMove2(0.0, 44.63, 650.83, 0.0, 48.22, 579.14, 60, 2, 0.2)
	event.SetFadeIn(30)
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(25.64, 9.7, 457.81)
	event.CmrsSetRef(-0.0, 19.0, 494.74)
	event.CmrsMove(25.64, 9.7, 357.81, 0.0, 19.0, 394.74, 160)
	event.ObjsMove(0, 8, 0.0, 400, 160)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4)
	event.ObjsMove(1, -8, 0.0, 400, 160)
	event.ObjsSetMotion(1, "歩き", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_99d125b7(7020010, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_99d125b7(7020020, 30)
	if vm.skipping() then
		return skip(4)
	end
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 40.03, 416.7)
	event.CmrsSetRef(-18.0, 40.45, 363.59)
	event.CmrsMove2(0.0, 40.03, 416.7, -40.11, 40.45, 389.73, 60, 2, 0.4)
	helper_8c283814()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(0.0, 40.03, 416.7)
	event.CmrsSetRef(18.0, 40.45, 363.59)
	event.CmrsMove2(0.0, 40.03, 416.7, 40.11, 40.45, 389.73, 60, 2, 0.4)
	helper_8c283814()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 18.82, 317.17)
	event.CmrsSetRef(0.0, 21.57, 360.74)
	event.ObjsMove(0, 8, 0.0, 360, 40)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "気がつく", 2)
	event.ObjsNextMotion(0, "そうか！！", 6)
	event.ObjsNextMotion(0, "そうか！！L", 4)
	event.ObjsTexaDelay(0, 40)
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsSeDelay(0, 82)
	event.ObjsSePlay(0, var1, 0)
	event.ObjsMove(1, -8, 0.0, 350, 56)
	event.ObjsRotDelay(1, 46)
	event.ObjsRotation(1, 0.0, 2.42, 0.0, 10)
	event.ObjsMotionDelay(1, 56)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexaDelay(1, 50)
	event.ObjsTexAnime(1, 0, "通常目パチ")
	event.ObjsTexAnime(1, 1, "前向き～右向き")
	helper_100ac525(42)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020030)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_278fcd8e(7020040)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-40.7, 35.07, 417.89)
	event.CmrsSetRef(-4.43, 24.95, 377.6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "立ち", 4, -1, 1)
	event.ObjsSetMotion(0, "走り")
	event.ObjsRotation(0, 0.0, 2.14, 0.0, 6)
	event.ObjsPosDelay(0, 4)
	event.ObjsMove(0, 210.81, 0.0, 225.65, 60)
	helper_100ac525(20)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetFootSoundId(0, 2)
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetPos(0, 718.74, 0.0, -118.54)
	event.ObjsSetRot(0, 0.0, 1.85, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1, 1)
	event.CmrsSetPos(24.13, 18.72, 352.73)
	event.CmrsSetRef(-5.12, 23.16, 345.48)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetRot(1, 0.0, 2.06, 0.0)
	helper_100ac525(20)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(1, 52.38, 0.0, 313.0, 40)
	event.ObjsSetMotion(1, "走り")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.EohSetTexAnim(1, 1, "口とじ")
	helper_100ac525(40)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(757.91, 16.92, -132.45)
	event.CmrsSetRef(694.19, 20.24, -121.26)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetFootSoundId(1, 2)
	event.ObjsSetRot(1, 0.0, 1.73, 0.0)
	event.ObjsSetPos(1, 597.66, 0.0, -109.91)
	event.ObjsMove(1, 714.6, 0.0, -132.69, 40)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	helper_100ac525(44)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "前向き～左向き")
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_278fcd8e(7020050)
	if vm.skipping() then
		return skip(16)
	end
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(640.61, 12.5, -112.65)
	event.CmrsSetRef(758.05, 45.97, -133.12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020060)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_278fcd8e(7020070)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020080)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(757.91, 16.92, -132.45)
	event.CmrsSetRef(694.19, 20.24, -121.26)
	event.ObjsSetRot(1, 0.0, 0.17, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "ホールを示す", 6)
	event.ObjsNextMotion(0, "ホールを示すL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020085)
	if vm.skipping() then
		return skip(21)
	end
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(0, "絵を指す", 6)
	event.ObjsNextMotion(0, "絵を指すL", 4)
	event.ObjsMotionDelay(1, 24)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020090)
	if vm.skipping() then
		return skip(23)
	end
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(659.67, 80.0, -113.9)
	event.CmrsSetRef(778.51, 80.0, -136.24)
	event.CmrsMove2(659.67, 60.0, -113.9, 778.51, 60.0, -136.24, 200, 2, 0.2)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, 1.73, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020093)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020097)
	if vm.skipping() then
		return skip(27)
	end
	helper_8c283814()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(738.56, 22.45, -93.25)
	event.CmrsSetRef(721.11, 22.0, -138.58)
	event.CmrsMove2(731.87, 22.45, -90.67, 714.42, 22.0, -136.01, 160, 2, 0.2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020100)
	if vm.skipping() then
		return skip(29)
	end
	helper_8c283814()
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(640.61, 12.5, -112.65)
	event.CmrsSetRef(758.05, 45.97, -133.12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020110)
	if vm.skipping() then
		return skip(31)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_278fcd8e(7020120)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_278fcd8e(7020130)
	if vm.skipping() then
		return skip(33)
	end
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(34)
	end
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(1, "面白くなって", 6)
	event.ObjsNextMotion(1, "面白くなってL", 4)
	event.ObjsMotionDelay(1, 42)
	event.ObjsNextMotion(1, "面白く_待機", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.SetPakuAnim(1, "わらい口パク")
	helper_278fcd8e(7020135)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(0, "左向くうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_278fcd8e(7020140)
	if vm.skipping() then
		return skip(37)
	end
	event.SetFadeOut(30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(38)
	end
	return part2()
end

return helper_d184ab56
