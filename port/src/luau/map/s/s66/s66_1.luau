--!strict
-- map/s/s66/s66_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_420e28fe = require("@lib/event/helper_420e28fe")
local helper_6a261f52 = require("@lib/event/helper_6a261f52")
local helper_743dd247 = require("@lib/event/helper_743dd247")
local helper_927bc2b6 = require("@lib/event/helper_927bc2b6")
local helper_b624ae36 = require("@lib/event/helper_b624ae36")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_e938()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 33
		global0 = 33
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e700/e736/e736_1.txt")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e736/e736_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e700/e736/e736_monica.gltf", "info", global1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 33
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e736/e736_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e700/e736/e736_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.CharaActive(0, global1)
	end
	event.AssignStack(6)
	event.ClearStack(6)
	event.LoadChara(6, "event/e700/e736/e736_c_union.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.LoadChara(6, "event/e700/e736/e736_eina.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(4, 38)
	event.ObjsInit(4, 38)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(6, "event/e700/e736/p00_05a.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(6, "event/e700/e736/p00_31a.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(6, 40)
	event.ObjsInit(6, 40)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(6, "event/e700/e736/e736_kieru_hikari.gltf", "info", 45)
	event.CharaActive(0, 45)
	event.CopyChara(6, 45, 46)
	event.CharaActive(0, 46)
	event.CopyChara(6, 45, 47)
	event.CharaActive(0, 47)
	event.CopyChara(6, 45, 48)
	event.CharaActive(0, 48)
	event.EohSyncObj(14, "p01_s98")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSetShow(14, 1)
	event.ObjsSetPos(14, -2000.0, 9000.0, -9000.0)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
	event.EohSyncObj(15, "p01_gekka")
	event.EohSetShow(15, 0)
end

--- Helper function.
local function helper_e3e4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(47)
	event.DeleteChara(48)
	event.DeleteChara(49)
	event.DeleteChara(50)
	event.DeleteChara(51)
	event.DeleteChara(52)
	event.EohSetShow(14, 0)
	event.EohSetShow(15, 1)
end

--- Helper function.
local function helper_fdb4()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 90 then
			if at <= 4 then
				helper_c1c32f84(45)
			end
			if at <= 5 then
				helper_e938()
				helper_c1c32f84(60)
			end
			if at <= 6 then
				helper_c1c32f84(15)
			end
			if at <= 7 then
				helper_e5dca676()
			end
			if at <= 8 then
				helper_07cf3e45(7360010, -1)
			end
			if at <= 9 then
				helper_c1c32f84(30)
			end
			if at <= 10 then
				helper_07cf3e45(7360015, 120)
			end
			if at <= 11 then
				helper_c1c32f84(30)
			end
			if at <= 12 then
				helper_07cf3e45(7360020, -1)
			end
			if at <= 13 then
				helper_c1c32f84(15)
			end
			if at <= 14 then
				helper_e5dca676()
			end
			if at <= 15 then
				helper_c1c32f84(30)
			end
			if at <= 16 then
				helper_07cf3e45(7360030, -1)
			end
			if at <= 17 then
				helper_07cf3e45(7360035, -1)
			end
			if at <= 18 then
				helper_07cf3e45(7360040, 90)
			end
			if at <= 19 then
				helper_c1c32f84(15)
			end
			if at <= 20 then
				helper_e5dca676()
			end
			if at <= 21 then
				helper_07cf3e45(7360050, -1)
			end
			if at <= 22 then
				helper_c1c32f84(30)
			end
			if at <= 23 then
				helper_07cf3e45(7360060, -1)
			end
			if at <= 24 then
				helper_e5dca676()
			end
			if at <= 25 then
				helper_c1c32f84(30)
			end
			if at <= 26 then
				helper_c1c32f84(30)
			end
			if at <= 27 then
				helper_e5dca676()
			end
			if at <= 28 then
				helper_2386f745(4)
			end
			if at <= 29 then
				helper_07cf3e45(7360070, -1)
			end
			if at <= 30 then
				helper_07cf3e45(7360080, -1)
			end
			if at <= 31 then
				helper_c1c32f84(30)
			end
			if at <= 32 then
				helper_07cf3e45(7360090, -1)
			end
			if at <= 33 then
				helper_c1c32f84(30)
			end
			if at <= 34 then
				helper_07cf3e45(7360100, -1)
			end
			if at <= 35 then
				helper_2386f745(0)
			end
			if at <= 36 then
				helper_07cf3e45(7360110, -1)
			end
			if at <= 37 then
				helper_2386f745(0)
			end
			if at <= 38 then
				helper_07cf3e45(7360120, -1)
			end
			if at <= 39 then
				helper_07cf3e45(7360130, -1)
			end
			if at <= 40 then
				helper_c1c32f84(15)
			end
			if at <= 41 then
				helper_07cf3e45(7360140, -1)
			end
			if at <= 42 then
				helper_2386f745(0)
			end
			if at <= 43 then
				helper_07cf3e45(7360145, 120)
			end
			if at <= 44 then
				helper_2386f745(0)
			end
			if at <= 45 then
				helper_07cf3e45(7360150, 90)
			end
			if at <= 46 then
				helper_c1c32f84(15)
			end
			if at <= 47 then
				helper_2386f745(0)
			end
			if at <= 48 then
				helper_07cf3e45(7360155, -1)
			end
			if at <= 49 then
				helper_2386f745(0)
			end
			if at <= 50 then
				helper_c1c32f84(60)
			end
			if at <= 51 then
				helper_c1c32f84(60)
			end
			if at <= 52 then
				helper_07cf3e45(7360160, -1)
			end
			if at <= 53 then
				helper_2386f745(0)
			end
			if at <= 54 then
				helper_07cf3e45(7360170, -1)
			end
			if at <= 55 then
				helper_07cf3e45(7360180, -1)
			end
			if at <= 56 then
				helper_2386f745(0)
			end
			if at <= 57 then
				helper_c1c32f84(20)
			end
			if at <= 58 then
				helper_2386f745(4)
			end
			if at <= 59 then
				helper_07cf3e45(7360190, -1)
			end
			if at <= 60 then
				helper_c1c32f84(3)
			end
			if at <= 61 then
				helper_c1c32f84(5)
			end
			if at <= 62 then
				helper_c1c32f84(45)
			end
			if at <= 63 then
				helper_c1c32f84(120)
			end
			if at <= 64 then
				helper_c1c32f84(10)
			end
			if at <= 65 then
				helper_c1c32f84(10)
			end
			if at <= 66 then
				helper_c1c32f84(10)
			end
			if at <= 67 then
				helper_c1c32f84(210)
			end
			if at <= 68 then
				helper_c1c32f84(10)
			end
			if at <= 69 then
				helper_c1c32f84(10)
			end
			if at <= 70 then
				helper_c1c32f84(10)
			end
			if at <= 71 then
				helper_c1c32f84(10)
			end
			if at <= 72 then
				helper_2386f745(10)
			end
			if at <= 73 then
				helper_2386f745(11)
			end
			if at <= 74 then
				helper_2386f745(12)
			end
			if at <= 75 then
				helper_2386f745(13)
			end
			if at <= 76 then
				helper_07cf3e45(7360200, -1)
			end
			if at <= 77 then
				helper_c1c32f84(30)
			end
			if at <= 78 then
				helper_07cf3e45(7360210, -1)
			end
			if at <= 79 then
				helper_c1c32f84(30)
			end
			if at <= 80 then
				helper_07cf3e45(7360215, -1)
			end
			if at <= 81 then
				helper_e5dca676()
			end
			if at <= 82 then
				helper_07cf3e45(7360220, -1)
			end
			if at <= 83 then
				helper_07cf3e45(7360230, -1)
			end
			if at <= 84 then
				helper_07cf3e45(7360240, 30)
			end
			if at <= 85 then
				helper_c1c32f84(15)
			end
			if at <= 86 then
				helper_07cf3e45(7360250, -1)
			end
			if at <= 87 then
				helper_07cf3e45(7360255, -1)
			end
			if at <= 88 then
				helper_07cf3e45(7360260, -1)
			end
			if at <= 89 then
				helper_e5dca676()
			end
			if vm.skip_end() then
				return skip(91)
			end
			return part2()
		end
		if at <= 91 then
			helper_c1c32f84(35)
		end
		helper_e3e4()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c1c32f84(35)
		if vm.skipping() then
			return skip(92)
		end
		event.SndSeAllStop(4)
		event.SetProjection(projection)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(4, 0)
		event.SetTime(time)
		if vm.wait() then
			return skip(93)
		end
		helper_e3e4()
	end
	event.SetFlag(736, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	event.LoadBgm(118)
	event.LoadSound(6243)
	var4 = event.SndLoadSound(6243) or var4
	event.SetFadeOut(30)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(5)
	end
	helper_e938()
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.5)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(4, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "泣き目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "かなし目パチ")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.CmrsSetPos(6.53, 80.05, 766.11)
	event.CmrsSetRef(4.76, 541.47, 211.05)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsMove2(6.53, 80.05, 766.11, 4.76, 64.48, 211.05, 480, 2, 0.5)
	event.ObjsSetPos(0, 6.03, -7.06, 200.37)
	event.ObjsSetRot(0, 0.0, 2.33, 0.0)
	event.ObjsSetPos(1, 24.67, -7.06, 178.01)
	event.ObjsSetRot(1, 0.0, -0.67, 0.0)
	event.ObjsSetPos(4, -39.08, -7.06, 139.45)
	event.ObjsSetRot(4, 0.0, 0.65, 0.0)
	event.ObjsSetPos(5, -63.71, -7.06, 154.12)
	event.ObjsSetRot(5, 0.0, 1.01, 0.0)
	event.ObjsSetPos(6, -79.03, -7.06, 188.9)
	event.ObjsSetRot(6, 0.0, 1.01, 0.0)
	event.SetCharaPos(44, 0.0, 3300.0, 0.0)
	event.SetScale(44, 30.0, 30.0, 30.0)
	event.SetMotion(44, "ループ", 4, -1, 1)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.CharaActive(1, 40)
	event.CharaActive(1, 44)
	event.SndSePlay(var4, 2)
	event.SetFadeIn(30)
	event.PlayBgm(0)
	event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(7)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(23.13, 18.08, 243.15)
	event.CmrsSetRef(13.28, 16.71, 190.69)
	event.CmrsMove2(-5.38, 18.08, 240.82, 13.28, 16.71, 190.69, 360, 2, 1.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(7360010, -1)
	if vm.skipping() then
		return skip(9)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "うつむき", 6)
	event.ObjsNextMotion(1, "うつむきL", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(7360015, 120)
	if vm.skipping() then
		return skip(11)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(7360020, -1)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "うる目")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(14)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(9.36, 18.08, 134.06)
	event.CmrsSetRef(18.46, 16.71, 186.15)
	event.SetCrossfade(30)
	event.CmrsMove2(37.9, 18.08, 136.86, 18.46, 16.71, 186.15, 240, 2, 1.0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_07cf3e45(7360030, -1)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_07cf3e45(7360035, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目あき～目とじ")
	event.ObjsSetMotion(1, "うなづき", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口わらい")
	helper_07cf3e45(7360040, 90)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "泣き目～通常目")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(20)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(40.36, 16.65, 283.36)
	event.CmrsSetRef(10.43, 16.71, 186.62)
	event.CmrsMove2(2.3, 16.65, 295.13, -27.63, 16.71, 198.39, 210, 2, 1.0)
	event.ObjsSetMotion(0, "左", 6)
	event.ObjsNextMotion(0, "左L", 4)
	helper_07cf3e45(7360050, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(23)
	end
	helper_07cf3e45(7360060, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "通常目～かなし目")
	event.ObjsSetMotion(4, "歩き")
	event.ObjsMove(4, -8.93, -7.06, 177.8, 120)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "目あき～目とじ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(27)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetPos(1, -118.41, -7.06, 31.17)
	event.ObjsSetRot(1, 0.0, 0.53, 0.0)
	event.ObjsSetPos(0, -8.93, -7.06, 177.8)
	event.ObjsSetRot(0, 0.0, 0.65, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目パチ")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "目とじ～目あき")
	event.CmrsSetPos(-4.66, 14.22, 222.94)
	event.CmrsSetRef(-5.05, 19.91, 179.84)
	event.ObjsSetMotion(0, "エイナ見立ち", 4, -1, 1)
	helper_2386f745(4)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(4, "立ち")
	event.SetPakuAnim(4, "わらい口パク")
	helper_07cf3e45(7360070, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360080, -1)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(32)
	end
	event.SetPakuAnim(4, "わらい口パク")
	helper_07cf3e45(7360090, -1)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(-45.47, 18.64, 171.07)
	event.CmrsSetRef(-4.63, 19.91, 182.55)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "通常目～泣き目")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "下見る", 6)
	event.ObjsNextMotion(0, "下見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360100, -1)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "泣き目パチ")
	helper_2386f745(0)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "下見る戻り", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360110, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-4.66, 14.22, 222.94)
	event.CmrsSetRef(-5.05, 19.91, 179.84)
	event.SetPakuAnim(4, "わらい口パク")
	helper_07cf3e45(7360120, -1)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目")
	event.ObjsTexAnime(0, 1, "半口")
	event.SetPakuAnim(4, "通常口パク")
	helper_07cf3e45(7360130, -1)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-45.47, 18.64, 171.07)
	event.CmrsSetRef(-4.63, 19.91, 182.55)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目～目とじ")
	event.ObjsTexAnime(0, 1, "半口")
	event.SndSePlay(var4, 3)
	event.ObjsSetMotion(0, "涙をふく", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき２")
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360140, -1)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(0, "手を広げる", 6)
	event.ObjsNextMotion(0, "手を広げるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360145, 120)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "手を広げる戻り", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360150, 90)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(47)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "下向き～目とじ")
	event.ObjsSetMotion(0, "下見る", 6)
	event.ObjsNextMotion(0, "下見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360155, -1)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(50)
	end
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(0, "下見る戻り", 2)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(-45.34, 17.5, 214.87)
	event.CmrsSetRef(37.61, 23.19, 150.26)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "泣き目あき～目とじ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき～目とじ")
	event.ObjsTexAnime(0, 1, "口とじ～半口～口とじ")
	event.ObjsSetMotion(0, "抱く", 6)
	event.ObjsNextMotion(0, "抱くL", 4)
	event.ObjsSetMotion(4, "抱く", 6)
	event.ObjsNextMotion(4, "抱くL", 4)
	event.SndSePlay(var4, 4)
	event.SetPakuAnim(4, "わらい口パク")
	helper_07cf3e45(7360160, -1)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(54)
	end
	event.SetPakuAnim(4, "わらい口パク")
	helper_07cf3e45(7360170, -1)
	if vm.skipping() then
		return skip(55)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "目とじ～泣き目あき")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき３")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(0, "抱く戻り", 2)
	event.ObjsNextMotion(0, "抱く戻りL", 4)
	event.ObjsSetMotion(4, "抱く戻り", 2)
	event.ObjsNextMotion(4, "抱く戻りL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_07cf3e45(7360180, -1)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "うる目")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目２")
	event.ObjsTexAnime(0, 1, "半口")
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(4, "後ずさり", 2)
	event.ObjsNextMotion(4, "後ずさりL", 4)
	event.ObjsMove(4, -24.91, -7.06, 157.36, 60)
	helper_2386f745(4)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目パチ")
	event.ObjsTexAnime(1, 1, "口わらい")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(34.99, 37.57, 229.69, -39.55, 3.5, 143.97)
	event.CmrsAddPas(-14.43, 37.57, 171.71, -89.76, 3.5, 90.67)
	event.CmrsStartPas()
	event.ObjsSetRot(0, 0.0, -2.35, 0.0)
	event.ObjsSetPos(4, -68.67, -7.06, 112.54)
	event.ObjsSetRot(4, 0.0, 0.77, 0.0)
	event.ObjsSetPos(5, -139.47, -7.06, 60.43)
	event.ObjsSetRot(5, 0.0, 0.65, 0.0)
	event.ObjsSetPos(6, -144.0, -7.06, 85.39)
	event.ObjsSetRot(6, 0.0, 0.89, 0.0)
	event.SetCharaPos(45, -118.41, -7.06, 31.17)
	event.SetCharaPos(46, -68.67, -7.06, 112.54)
	event.SetCharaPos(47, -139.47, -7.06, 60.43)
	event.SetCharaPos(48, -144.0, -7.06, 85.39)
	event.ObjsSetMotion(0, "母さん！！", 6)
	event.ObjsNextMotion(0, "母さん！！L", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(7360190, -1)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 5)
	event.SetMotion(47, "発動", 6, -1, 1)
	event.CharaActive(1, 47)
	event.SetCharaShow(39, 0, 1, 0.025)
	helper_c1c32f84(3)
	if vm.skipping() then
		return skip(61)
	end
	event.SetMotion(48, "発動", 6, -1, 1)
	event.CharaActive(1, 48)
	event.SetCharaShow(40, 0, 1, 0.025)
	helper_c1c32f84(5)
	if vm.skipping() then
		return skip(62)
	end
	event.SetMotion(45, "発動", 6, -1, 1)
	event.CharaActive(1, 45)
	event.SetCharaShow(global1, 0, 1, 0.025)
	event.CharaActive(0, 37)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(63)
	end
	event.SetMotion(46, "発動", 6, -1, 1)
	event.CharaActive(1, 46)
	event.SetCharaShow(38, 0, 1, 0.025)
	event.CharaActive(0, global1)
	helper_c1c32f84(120)
	if vm.skipping() then
		return skip(64)
	end
	event.CharaActive(0, 38)
	event.CharaActive(0, 39)
	event.CharaActive(0, 40)
	event.CharaActive(0, 45)
	event.CharaActive(0, 46)
	event.CharaActive(0, 47)
	event.CharaActive(0, 48)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(global1)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(47)
	event.DeleteChara(48)
	event.DeleteChara(44)
	event.ClearStack(6)
	event.LoadChara(6, "event/e700/e736/e736_tojiru.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.LoadChara(6, "event/e700/e736/e736_nobori_new.gltf", "info", 49)
	event.CharaActive(0, 49)
	event.EohSyncChara(10, 49)
	event.ObjsInit(10, 49)
	event.ObjsSyncObj(10, 10)
	event.CopyChara(6, 49, 50)
	event.CharaActive(0, 50)
	event.EohSyncChara(11, 50)
	event.ObjsInit(11, 50)
	event.ObjsSyncObj(11, 11)
	event.CopyChara(6, 49, 51)
	event.CharaActive(0, 51)
	event.EohSyncChara(12, 51)
	event.ObjsInit(12, 51)
	event.ObjsSyncObj(12, 12)
	event.CopyChara(6, 49, 52)
	event.CharaActive(0, 52)
	event.EohSyncChara(13, 52)
	event.ObjsInit(13, 52)
	event.ObjsSyncObj(13, 13)
	event.LoadChara(6, "event/e700/e736/e736_tom.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(7, 41)
	event.ObjsInit(7, 41)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(6, "event/e700/e736/e736_vorneo.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(8, 42)
	event.ObjsInit(8, 42)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(6, "event/e700/e736/e736_starbre.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(9, 43)
	event.ObjsInit(9, 43)
	event.ObjsSyncObj(9, 9)
	event.SetCharaPos(44, 0.0, 2500.0, 0.0)
	event.SetScale(44, 10.0, 10.0, 10.0)
	event.CharaActive(1, 44)
	event.CharaActive(1, 49)
	event.CharaActive(1, 50)
	event.CharaActive(1, 51)
	event.CharaActive(1, 52)
	event.SetScale(49, 4.0, 4.0, 4.0)
	event.SetScale(50, 4.0, 4.0, 4.0)
	event.SetScale(51, 4.0, 4.0, 4.0)
	event.SetScale(52, 4.0, 4.0, 4.0)
	event.SetCharaPos(49, -150.0, -7.06, 150.0)
	event.SetCharaPos(50, -15.0, -7.06, -150.0)
	event.SetCharaPos(51, 65.0, -7.06, -150.0)
	event.SetCharaPos(52, 150.0, -7.06, 150.0)
	event.CharaActive(0, global0)
	event.CharaActive(1, 41)
	event.CharaActive(1, 42)
	event.CharaActive(1, 43)
	event.ObjsSetPos(7, -61.65, -268.37, 2725.79)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.ObjsSetPos(8, -36.27, -268.37, 2730.68)
	event.ObjsSetRot(8, 0.0, 3.04, 0.0)
	event.ObjsSetPos(9, -11.81, -268.37, 2711.11)
	event.ObjsSetRot(9, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetMotion(8, "立ち", 4)
	event.ObjsSetMotion(9, "立ち", 4)
	event.SndSePlay(var4, 6)
	event.CmrsSetPos(-26.29, -233.08, 2912.11)
	event.CmrsSetRef(-24.95, 6.64, 2652.48)
	event.CmrsMove2(-26.29, -233.08, 2912.11, -24.95, -215.15, 2652.48, 600, 0, 0.5)
	event.ObjsMove(10, 0.0, 3000.0, 0.0, 240)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsMove(11, 0.0, 3000.0, 0.0, 240)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsMove(12, 0.0, 3000.0, 0.0, 240)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsMove(13, 0.0, 3000.0, 0.0, 240)
	helper_c1c32f84(210)
	if vm.skipping() then
		return skip(68)
	end
	event.SetCharaShow(49, 0, 1, 0.025)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(69)
	end
	event.SetCharaShow(50, 0, 1, 0.025)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(70)
	end
	event.SetCharaShow(51, 0, 1, 0.025)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(71)
	end
	event.SetCharaShow(52, 0, 1, 0.025)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(72)
	end
	event.SetCharaShow(44, 0, 1, 0.0125)
	helper_2386f745(10)
	if vm.skipping() then
		return skip(73)
	end
	helper_2386f745(11)
	if vm.skipping() then
		return skip(74)
	end
	helper_2386f745(12)
	if vm.skipping() then
		return skip(75)
	end
	helper_2386f745(13)
	if vm.skipping() then
		return skip(76)
	end
	event.CharaActive(0, 49)
	event.CharaActive(0, 50)
	event.CharaActive(0, 51)
	event.CharaActive(0, 52)
	event.SetCrossfade(30)
	event.EohSetShow(14, 0)
	event.SetPakuAnim(9, "通常口パク")
	helper_07cf3e45(7360200, -1)
	if vm.skipping() then
		return skip(77)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(78)
	end
	event.SetPakuAnim(8, "通常口パク")
	helper_07cf3e45(7360210, -1)
	if vm.skipping() then
		return skip(79)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(80)
	end
	event.SetPakuAnim(8, "通常口パク")
	helper_07cf3e45(7360215, -1)
	if vm.skipping() then
		return skip(81)
	end
	event.ResetPakuAnim()
	helper_e5dca676()
	if vm.skipping() then
		return skip(82)
	end
	event.CharaActive(0, 44)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(360)
	event.CmrsAddPas(-102.41, -105.05, 2573.33, -32.34, -245.11, 2715.49)
	event.CmrsAddPas(-50.57, -128.25, 2558.78, -32.34, -245.11, 2715.49)
	event.CmrsAddPas(11.71, -166.6, 2586.87, -32.34, -245.11, 2715.49)
	event.CmrsAddPas(30.07, -183.67, 2650.65, -32.34, -245.11, 2715.49)
	event.CmrsStartPas()
	event.SetPakuAnim(7, "口パク")
	helper_07cf3e45(7360220, -1)
	if vm.skipping() then
		return skip(83)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(9, "通常口パク")
	helper_07cf3e45(7360230, -1)
	if vm.skipping() then
		return skip(84)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "えっ？", 6)
	event.ObjsNextMotion(7, "えっ？Ｌ", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_07cf3e45(7360240, 30)
	if vm.skipping() then
		return skip(85)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(86)
	end
	event.CmrsInit()
	event.CmrsSetPos(-66.1, -251.95, 2901.4)
	event.CmrsSetRef(-26.73, -211.8, 2660.25)
	event.CmrsMove2(-66.1, -251.95, 2901.4, -26.73, 95.62, 2660.25, 540, 2, 1.0)
	event.SetPakuAnim(9, "通常口パク")
	helper_07cf3e45(7360250, -1)
	if vm.skipping() then
		return skip(87)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(9, "通常口パク")
	helper_07cf3e45(7360255, -1)
	if vm.skipping() then
		return skip(88)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(7, "通常口パク")
	helper_07cf3e45(7360260, -1)
	if vm.skipping() then
		return skip(89)
	end
	event.ResetPakuAnim()
	helper_e5dca676()
	if vm.skipping() then
		return skip(90)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 500.
-- Defined empty, so the engine runs this instead of its default.
script[500] = function() end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_fdb4()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "i04h01", 530)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_927bc2b6()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_420e28fe()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 630)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_743dd247()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 640)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6a261f52()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 650)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 650.
script[650] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b624ae36()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16400.
script[16400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_927bc2b6()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 17360.
script[17360] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	event.SetSavedataEtc(0, 10)
	event.MapJump(-1, "s66", 17370)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 17370.
script[17370] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_fdb4()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "i04h01", 530)
	if vm.wait() then
		return skip(2)
	end
end

return script
