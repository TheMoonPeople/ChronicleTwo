--!strict
-- map/s/s66/s66.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_24b30()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e700/e736/e736.txt")
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
	event.EohSyncObj_2(14, "p01_s98")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSetShow(14, 1)
	event.ObjsSetPos(14, -2000.0, 9000.0, -9000.0)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
	event.EohSyncObj_2(15, "p01_gekka")
	event.EohSetShow(15, 0)
end

--- Helper function.
local function helper_22000000()
	global0 = 0
	global1 = 33
	global0 = 33
	global1 = 0
end

--- Helper function.
local function helper_245dc()
	local active_chr_no: s32 = 0
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
local function helper_25fac()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(736, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		event.LoadBgm(118)
		event.LoadSound(6243)
		var4 = event.SndLoadSound_2(6243) or var4
		event.SetFadeOut(30)
		at = 5
		helper_888ab2a3(45)
		helper_24b30()
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
		at = 6
		helper_888ab2a3(60)
		event.CmrsMove2(6.53, 80.05, 766.11, 4.76, 64.48, 211.05, 284, 2, 0.5)
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
		at = 7
		helper_888ab2a3(15)
		at = 8
		helper_c624bc16()
		event.CmrsSetPos(23.13, 18.08, 243.15)
		event.CmrsSetRef(13.28, 16.71, 190.69)
		event.CmrsMove2(-5.38, 18.08, 240.82, 13.28, 16.71, 190.69, 360, 2, 1.0)
		event.SetPakuAnim(1, "通常口パク")
		at = 9
		helper_29101c9c(7360010, -1)
		at = 10
		helper_888ab2a3(15)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "かなし顔")
		event.ObjsTexAnime(1, 1, "目あき～目とじ")
		event.ObjsSetMotion(1, "うつむき", 6)
		event.ObjsNextMotion(1, "うつむきL", 4)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "通常口パク")
		at = 11
		helper_29101c9c(7360015, -1)
		at = 12
		helper_888ab2a3(30)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "かなし顔")
		event.ObjsTexAnime(1, 1, "目とじ～目あき")
		event.ObjsSetMotion(1, "もどり", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "通常口パク")
		at = 13
		helper_29101c9c(7360020, -1)
		event.ResetPakuAnim()
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "かなし顔")
		event.ObjsTexAnime(1, 1, "うる目")
		at = 14
		helper_888ab2a3(15)
		at = 15
		helper_c624bc16()
		event.CmrsSetPos(9.36, 18.08, 134.06)
		event.CmrsSetRef(18.46, 16.71, 186.15)
		event.SetCrossfade(30)
		event.CmrsMove2(37.9, 18.08, 136.86, 18.46, 16.71, 186.15, 240, 2, 1.0)
		at = 16
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 17
		helper_29101c9c(7360030, -1)
		event.ResetPakuAnim()
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "泣き顔")
		event.ObjsTexAnime(1, 1, "泣き目パチ")
		event.SetPakuAnim(0, "わらい口パク")
		at = 18
		helper_29101c9c(7360035, -1)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "泣き顔")
		event.ObjsTexAnime(1, 1, "泣き目あき～目とじ")
		event.ObjsSetMotion(1, "うなづき", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "口わらい")
		at = 19
		helper_29101c9c(7360040, 30)
		event.ResetPakuAnim()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "泣き顔")
		event.ObjsTexAnime(0, 1, "泣き目～通常目")
		at = 20
		helper_888ab2a3(15)
		at = 21
		helper_c624bc16()
		event.CmrsSetPos(40.36, 16.65, 283.36)
		event.CmrsSetRef(10.43, 16.71, 186.62)
		event.CmrsMove2(2.3, 16.65, 295.13, -27.63, 16.71, 198.39, 180, 2, 1.0)
		event.ObjsSetMotion(0, "左", 6)
		event.ObjsNextMotion(0, "左L", 4)
		at = 22
		helper_29101c9c(7360050, -1)
		at = 23
		helper_29101c9c(7360060, -1)
		at = 24
		helper_c624bc16()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "泣き顔")
		event.ObjsTexAnime(0, 1, "通常目～かなし目")
		event.ObjsSetMotion(4, "歩き")
		event.ObjsMove(4, -8.93, -7.06, 177.8, 120)
		at = 25
		helper_888ab2a3(30)
		event.ObjsTexAnime(4, 0)
		event.ObjsTexAnime(4, 1, "わらい顔")
		event.ObjsTexAnime(4, 1, "目あき～目とじ")
		at = 26
		helper_888ab2a3(30)
		at = 27
		helper_c624bc16()
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
		at = 28
		helper_0958ca60(4)
		event.ObjsSetMotion(4, "立ち")
		event.SetPakuAnim(4, "わらい口パク")
		at = 29
		helper_29101c9c(7360070, -1)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "通常口パク")
		at = 30
		helper_29101c9c(7360080, -1)
		event.ResetPakuAnim()
		at = 31
		helper_888ab2a3(15)
		event.SetPakuAnim(4, "わらい口パク")
		at = 32
		helper_29101c9c(7360090, -1)
		event.ResetPakuAnim()
		at = 33
		helper_888ab2a3(15)
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
		at = 34
		helper_29101c9c(7360100, -1)
		event.ResetPakuAnim()
		event.ObjsTexAnime(4, 0)
		event.ObjsTexAnime(4, 1, "わらい顔")
		event.ObjsTexAnime(4, 1, "泣き目パチ")
		at = 35
		helper_0958ca60(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "かなし顔")
		event.ObjsTexAnime(0, 1, "目とじ～目あき")
		event.ObjsSetMotion(0, "下見る戻り", 6)
		event.ObjsNextMotion(0, "エイナ見立ち", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 36
		helper_29101c9c(7360110, -1)
		event.ResetPakuAnim()
		at = 37
		helper_0958ca60(0)
		event.CmrsSetPos(-4.66, 14.22, 222.94)
		event.CmrsSetRef(-5.05, 19.91, 179.84)
		event.SetPakuAnim(4, "わらい口パク")
		at = 38
		helper_29101c9c(7360120, -1)
		event.ResetPakuAnim()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "かなし顔")
		event.ObjsTexAnime(0, 1, "うる目")
		event.ObjsTexAnime(0, 1, "半口")
		event.SetPakuAnim(4, "通常口パク")
		at = 39
		helper_29101c9c(7360130, -1)
		event.ResetPakuAnim()
		at = 40
		helper_888ab2a3(15)
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
		at = 41
		helper_29101c9c(7360140, -1)
		event.ResetPakuAnim()
		at = 42
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "手を広げる", 6)
		event.ObjsNextMotion(0, "手を広げるL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 43
		helper_29101c9c(7360145, -1)
		event.ResetPakuAnim()
		at = 44
		helper_0958ca60(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "かなし顔")
		event.ObjsTexAnime(0, 1, "前向き～下向き")
		event.ObjsSetMotion(0, "手を広げる戻り", 6)
		event.ObjsNextMotion(0, "エイナ見立ち", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 45
		helper_29101c9c(7360150, -1)
		event.ResetPakuAnim()
		at = 46
		helper_888ab2a3(15)
		at = 47
		helper_0958ca60(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "かなし顔")
		event.ObjsTexAnime(0, 1, "下向き～目とじ")
		event.ObjsSetMotion(0, "下見る", 6)
		event.ObjsNextMotion(0, "下見るL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 48
		helper_29101c9c(7360155, -1)
		event.ResetPakuAnim()
		at = 49
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "下見る戻り", 2)
		at = 50
		helper_888ab2a3(30)
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
		at = 51
		helper_29101c9c(7360160, -1)
		event.ResetPakuAnim()
		at = 52
		helper_0958ca60(0)
		event.SetPakuAnim(4, "わらい口パク")
		at = 53
		helper_29101c9c(7360170, -1)
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
		at = 54
		helper_29101c9c(7360180, -1)
		event.ResetPakuAnim()
		at = 55
		helper_0958ca60(0)
		event.ObjsTexAnime(4, 0)
		event.ObjsTexAnime(4, 1, "わらい顔")
		event.ObjsTexAnime(4, 1, "うる目")
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "かなし顔")
		event.ObjsTexAnime(0, 1, "うる目２")
		event.ObjsTexAnime(0, 1, "半口")
		event.ObjsSetMotion(4, "後ずさり", 2)
		event.ObjsNextMotion(4, "後ずさりL", 4)
		event.ObjsMove(4, -24.91, -7.06, 157.36, 60)
		at = 56
		helper_0958ca60(4)
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
		at = 57
		helper_29101c9c(7360190, -1)
		event.ResetPakuAnim()
		event.SndSePlay(var4, 5)
		event.SetMotion(47, "発動", 6, -1, 1)
		event.CharaActive(1, 47)
		event.SetCharaShow(39, 0, 1, 0.025)
		at = 58
		helper_888ab2a3(3)
		event.SetMotion(48, "発動", 6, -1, 1)
		event.CharaActive(1, 48)
		event.SetCharaShow(40, 0, 1, 0.025)
		at = 59
		helper_888ab2a3(5)
		event.SetMotion(45, "発動", 6, -1, 1)
		event.CharaActive(1, 45)
		event.SetCharaShow(global1, 0, 1, 0.025)
		event.CharaActive(0, 37)
		at = 60
		helper_888ab2a3(45)
		event.SetMotion(46, "発動", 6, -1, 1)
		event.CharaActive(1, 46)
		event.SetCharaShow(38, 0, 1, 0.025)
		event.CharaActive(0, global1)
		at = 61
		helper_888ab2a3(120)
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
		at = 62
		helper_888ab2a3(10)
		event.ObjsMove(11, 0.0, 3000.0, 0.0, 240)
		at = 63
		helper_888ab2a3(10)
		event.ObjsMove(12, 0.0, 3000.0, 0.0, 240)
		at = 64
		helper_888ab2a3(10)
		event.ObjsMove(13, 0.0, 3000.0, 0.0, 240)
		at = 65
		helper_888ab2a3(210)
		event.SetCharaShow(49, 0, 1, 0.025)
		at = 66
		helper_888ab2a3(10)
		event.SetCharaShow(50, 0, 1, 0.025)
		at = 67
		helper_888ab2a3(10)
		event.SetCharaShow(51, 0, 1, 0.025)
		at = 68
		helper_888ab2a3(10)
		event.SetCharaShow(52, 0, 1, 0.025)
		at = 69
		helper_888ab2a3(10)
		event.SetCharaShow(44, 0, 1, 0.0125)
		at = 70
		helper_0958ca60(10)
		at = 71
		helper_0958ca60(11)
		at = 72
		helper_0958ca60(12)
		at = 73
		helper_0958ca60(13)
		event.CharaActive(0, 49)
		event.CharaActive(0, 50)
		event.CharaActive(0, 51)
		event.CharaActive(0, 52)
		event.SetCrossfade(30)
		event.EohSetShow(14, 0)
		event.SetPakuAnim(9, "通常口パク")
		at = 74
		helper_29101c9c(7360200, -1)
		event.ResetPakuAnim()
		at = 75
		helper_888ab2a3(30)
		event.SetPakuAnim(8, "通常口パク")
		at = 76
		helper_29101c9c(7360210, -1)
		event.ResetPakuAnim()
		at = 77
		helper_888ab2a3(30)
		event.SetPakuAnim(8, "通常口パク")
		at = 78
		helper_29101c9c(7360215, -1)
		event.ResetPakuAnim()
		at = 79
		helper_c624bc16()
		event.CharaActive(0, 44)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(360)
		event.CmrsAddPas(-102.41, -105.05, 2573.33, -32.34, -245.11, 2715.49)
		event.CmrsAddPas(-50.57, -128.25, 2558.78, -32.34, -245.11, 2715.49)
		event.CmrsAddPas(11.71, -166.6, 2586.87, -32.34, -245.11, 2715.49)
		event.CmrsAddPas(30.07, -183.67, 2650.65, -32.34, -245.11, 2715.49)
		event.CmrsStartPas()
		event.SetPakuAnim(7, "口パク")
		at = 80
		helper_29101c9c(7360220, -1)
		event.ResetPakuAnim()
		event.SetPakuAnim(9, "通常口パク")
		at = 81
		helper_29101c9c(7360230, -1)
		event.ResetPakuAnim()
		event.ObjsSetMotion(7, "えっ？", 6)
		event.ObjsNextMotion(7, "えっ？Ｌ", 4)
		event.SetPakuAnim(7, "通常口パク")
		at = 82
		helper_29101c9c(7360240, 30)
		event.ResetPakuAnim()
		at = 83
		helper_888ab2a3(15)
		event.CmrsInit()
		event.CmrsSetPos(-66.1, -251.95, 2901.4)
		event.CmrsSetRef(-26.73, -211.8, 2660.25)
		event.CmrsMove2(-66.1, -251.95, 2901.4, -26.73, 95.62, 2660.25, 540, 2, 1.0)
		event.SetPakuAnim(9, "通常口パク")
		at = 84
		helper_29101c9c(7360250, -1)
		event.ResetPakuAnim()
		event.SetPakuAnim(9, "通常口パク")
		at = 85
		helper_29101c9c(7360255, -1)
		event.ResetPakuAnim()
		event.SetPakuAnim(7, "通常口パク")
		at = 86
		helper_29101c9c(7360260, -1)
		event.ResetPakuAnim()
		at = 87
		helper_c624bc16()
	end, function(received: { any }): boolean
		if at <= 4 then
			helper_038a2e4d(45)
		end
		if at <= 5 then
			helper_22000000()
			helper_038a2e4d(60)
		end
		if at <= 6 then
			helper_038a2e4d(15)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			helper_53ffe901(7360010, -1)
		end
		if at <= 9 then
			helper_038a2e4d(15)
		end
		if at <= 10 then
			helper_53ffe901(7360015, -1)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_53ffe901(7360020, -1)
		end
		if at <= 13 then
			helper_038a2e4d(15)
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_53ffe901(7360030, -1)
		end
		if at <= 17 then
			helper_53ffe901(7360035, -1)
		end
		if at <= 18 then
			helper_53ffe901(7360040, 30)
		end
		if at <= 19 then
			helper_038a2e4d(15)
		end
		if at <= 20 then
			helper_344d6cd8()
		end
		if at <= 21 then
			helper_53ffe901(7360050, -1)
		end
		if at <= 22 then
			helper_53ffe901(7360060, -1)
		end
		if at <= 23 then
			helper_344d6cd8()
		end
		if at <= 24 then
			helper_038a2e4d(30)
		end
		if at <= 25 then
			helper_038a2e4d(30)
		end
		if at <= 26 then
			helper_344d6cd8()
		end
		if at <= 27 then
			helper_238b5abc(4)
		end
		if at <= 28 then
			helper_53ffe901(7360070, -1)
		end
		if at <= 29 then
			helper_53ffe901(7360080, -1)
		end
		if at <= 30 then
			helper_038a2e4d(15)
		end
		if at <= 31 then
			helper_53ffe901(7360090, -1)
		end
		if at <= 32 then
			helper_038a2e4d(15)
		end
		if at <= 33 then
			helper_53ffe901(7360100, -1)
		end
		if at <= 34 then
			helper_238b5abc(0)
		end
		if at <= 35 then
			helper_53ffe901(7360110, -1)
		end
		if at <= 36 then
			helper_238b5abc(0)
		end
		if at <= 37 then
			helper_53ffe901(7360120, -1)
		end
		if at <= 38 then
			helper_53ffe901(7360130, -1)
		end
		if at <= 39 then
			helper_038a2e4d(15)
		end
		if at <= 40 then
			helper_53ffe901(7360140, -1)
		end
		if at <= 41 then
			helper_238b5abc(0)
		end
		if at <= 42 then
			helper_53ffe901(7360145, -1)
		end
		if at <= 43 then
			helper_238b5abc(0)
		end
		if at <= 44 then
			helper_53ffe901(7360150, -1)
		end
		if at <= 45 then
			helper_038a2e4d(15)
		end
		if at <= 46 then
			helper_238b5abc(0)
		end
		if at <= 47 then
			helper_53ffe901(7360155, -1)
		end
		if at <= 48 then
			helper_238b5abc(0)
		end
		if at <= 49 then
			helper_038a2e4d(30)
		end
		if at <= 50 then
			helper_53ffe901(7360160, -1)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_53ffe901(7360170, -1)
		end
		if at <= 53 then
			helper_53ffe901(7360180, -1)
		end
		if at <= 54 then
			helper_238b5abc(0)
		end
		if at <= 55 then
			helper_238b5abc(4)
		end
		if at <= 56 then
			helper_53ffe901(7360190, -1)
		end
		if at <= 57 then
			helper_038a2e4d(3)
		end
		if at <= 58 then
			helper_038a2e4d(5)
		end
		if at <= 59 then
			helper_038a2e4d(45)
		end
		if at <= 60 then
			helper_038a2e4d(120)
		end
		if at <= 61 then
			helper_038a2e4d(10)
		end
		if at <= 62 then
			helper_038a2e4d(10)
		end
		if at <= 63 then
			helper_038a2e4d(10)
		end
		if at <= 64 then
			helper_038a2e4d(210)
		end
		if at <= 65 then
			helper_038a2e4d(10)
		end
		if at <= 66 then
			helper_038a2e4d(10)
		end
		if at <= 67 then
			helper_038a2e4d(10)
		end
		if at <= 68 then
			helper_038a2e4d(10)
		end
		if at <= 69 then
			helper_238b5abc(10)
		end
		if at <= 70 then
			helper_238b5abc(11)
		end
		if at <= 71 then
			helper_238b5abc(12)
		end
		if at <= 72 then
			helper_238b5abc(13)
		end
		if at <= 73 then
			helper_53ffe901(7360200, -1)
		end
		if at <= 74 then
			helper_038a2e4d(30)
		end
		if at <= 75 then
			helper_53ffe901(7360210, -1)
		end
		if at <= 76 then
			helper_038a2e4d(30)
		end
		if at <= 77 then
			helper_53ffe901(7360215, -1)
		end
		if at <= 78 then
			helper_344d6cd8()
		end
		if at <= 79 then
			helper_53ffe901(7360220, -1)
		end
		if at <= 80 then
			helper_53ffe901(7360230, -1)
		end
		if at <= 81 then
			helper_53ffe901(7360240, 30)
		end
		if at <= 82 then
			helper_038a2e4d(15)
		end
		if at <= 83 then
			helper_53ffe901(7360250, -1)
		end
		if at <= 84 then
			helper_53ffe901(7360255, -1)
		end
		if at <= 85 then
			helper_53ffe901(7360260, -1)
		end
		if at <= 86 then
			helper_344d6cd8()
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetFadeOut(30)
	at = 88
	helper_888ab2a3(35)
	event.SndSeAllStop(4)
	event.SetProjection(projection)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(4, 0)
	event.SetTime(time)
	at = 89
	vm.wait(89)
	helper_245dc()
end

--- Helper function.
local function helper_2d5ec()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.SetFlag(640, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		helper_888ab2a3(4)
		event.LoadBgm(111)
		event.PlayBgm(0)
		event.LoadSound(6206)
		var0 = event.SndLoadSound_2(6206) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e640/")
		event.LoadMes(0, 5, "e640.txt")
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
		helper_0958ca60(0)
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
		helper_888ab2a3(30)
		event.CmrsQuake2(0.0, 0.2, 0.0, -1)
		event.SndSePlay(var0, 0)
		event.ObjsSetMotion(0, "キョロキョロ")
		event.ObjsSetMotion(1, "きょろきょろ")
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400010, -1)
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400020, -1)
		helper_888ab2a3(20)
		event.SndSeStop(var0, 0)
		helper_888ab2a3(10)
		event.CmrsInit()
		event.CmrsSetPos(731.98, 1651.1, -1178.87)
		event.CmrsSetRef(572.56, 1335.85, -926.68)
		event.SndSePlay(var0, 1)
		event.CharaActive(35)
		event.ObjsSetMotion(3, "ラピスビームのみ", 6)
		helper_888ab2a3(45)
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
		helper_888ab2a3(140)
		event.CmrsSetPos(3959.58, 1269.87, -3946.94)
		event.CmrsSetRef(3453.93, 1511.55, -3437.8)
		helper_888ab2a3(140)
		event.SetCrossfade(30)
		event.SetCharaShow(34, 1, 1, 0.033333335)
		helper_0958ca60(4)
		event.EohSetShow(4, 0)
		helper_888ab2a3(90)
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
		helper_29101c9c(6400030, -1)
		event.ObjsSetMotion(1, "もどり", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "やった！！", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(0, "わらい口パク")
		helper_29101c9c(6400040, -1)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
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

--- Helper function.
local function helper_30394()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.SetFlag(640, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(6212)
		var0 = event.SndLoadSound_2(6212) or var0
		event.SndSePlay(var0, 0)
		event.SndSeStop(var0, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e640/")
		event.LoadMes(0, 5, "e640.txt")
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
		event.EohSyncObj_2(2, "p01_s98")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
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
		event.EohSetPos(0, 12.52, -7.06, 206.03)
		event.EohSetRot(0, 0.0, 3.14, 0.0)
		event.EohSetFootSoundId(0, 2)
		event.EohSetPos(1, 35.37, -7.06, 202.4)
		event.EohSetRot(1, 0.0, 3.14, 0.0)
		event.EohSetFootSoundId(1, 2)
		event.EohSetShow(2, 0)
		event.SetTime(0)
		event.InitDramaScene()
		event.SndSePlay(var0, 2)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CmrsInit()
		event.CmrsSetPos(46.73, 6.1, 159.48)
		event.CmrsSetRef(23.33, 14.34, 206.91)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.SetFadeIn(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "無表情")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		helper_888ab2a3(30)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400140, -1)
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400150, -1)
		event.ObjsSetMotion(0, "上→右", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		helper_0958ca60(0)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400160, -1)
		helper_888ab2a3(15)
		event.ObjsSetMotion(1, "上から左", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		helper_0958ca60(1)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400170, -1)
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "右→上", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "左から上", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400180, -1)
		helper_888ab2a3(45)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "無表情")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.SetPakuAnim(1, "わらい口パク")
		helper_29101c9c(6400190, -1)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
	event.SndSeStop(var0, 2)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.LoadMes(0, -1)
end

--- Helper function.
local function helper_31fac()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.SetFlag(640, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(6215)
		var0 = event.SndLoadSound_2(6215) or var0
		event.SndSePlay(var0, 0)
		event.SndSeStop(var0, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e640/")
		event.LoadMes(0, 5, "e640.txt")
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
		event.EohSyncObj_2(2, "p01_gekka")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.LoadChara(5, "e520_dsmoke.gltf", "info", 34)
		event.CharaActive(34)
		event.EohSyncChara(3, 34)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
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
		event.EohSetPos(0, 26.1, -13.06, 439.65)
		event.EohSetRot(0, 0.0, 3.14, 0.0)
		event.EohSetFootSoundId(0, 2)
		event.EohSetPos(1, 46.14, -13.05, 435.43)
		event.EohSetRot(1, 0.0, -2.9, 0.0)
		event.EohSetFootSoundId(1, 2)
		event.EohSetPos(2, -1611.8, 5821.6, -10655.5)
		event.EohSetRot(2, 0.5235988, 0.0, 0.0)
		event.EohSetShow(2, 1)
		event.ObjsSetScale(2, 0.5, 0.5, 0.5)
		event.EohSetPos(3, -1611.8, 5821.6, -10655.5)
		event.EohSetRot(3, 0.0, -0.8, 0.0)
		event.ObjsSetScale(3, 0.3, 0.3, 0.3)
		event.EohSetShow(3, 1)
		event.SetTime(0)
		event.InitDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CmrsInit()
		event.CmrsSetPos(48.43, -8.6, 485.28)
		event.CmrsSetRef(27.26, 28.52, 399.92)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.SetFadeIn(30)
		event.ObjsMove(2, -8095.4, 4770.2, -11356.4, 3000)
		event.ObjsRotation(2, 0.5235988, 0.0, 0.17453292, 1200)
		event.ObjsMove(3, -8095.4, 4770.2, -11356.4, 3000)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		helper_888ab2a3(30)
		event.SndSePlay(var0, 3)
		event.ObjsSetMotion(0, "やった！！", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(0, "わらい口パク")
		helper_29101c9c(6400220, -1)
		helper_888ab2a3(60)
		event.FadeOutBgm(30)
		helper_0958ca60(0)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400230, -1)
		event.StopBgm(0)
		helper_888ab2a3(4)
		event.LoadBgm(117)
		event.PlayBgm(0)
		helper_888ab2a3(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目～こまり目")
		event.ObjsSetMotion(0, "上→右", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400240, -1)
		helper_0958ca60(0)
		helper_888ab2a3(30)
		event.ObjsSetMotion(1, "指差し", 6)
		event.ObjsNextMotion(1, "指差しL", 4)
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400250, -1)
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "右→上", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		helper_0958ca60(0)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400253, -1)
		event.ObjsSetMotion(1, "もどり", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		helper_888ab2a3(15)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400257, -1)
		helper_0958ca60(1)
		helper_888ab2a3(30)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400260, -1)
		helper_888ab2a3(60)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetShow(2, 0)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.LoadMes(0, -1)
end

--- Helper function.
local function helper_34380()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.SetFlag(640, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		helper_888ab2a3(4)
		event.LoadBgm(33)
		event.PlayBgm(0)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e640/")
		event.LoadMes(0, 5, "e640.txt")
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
		event.EohSyncObj_2(2, "p01_s98")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
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
		event.EohSetPos(0, 12.52, -7.06, 206.03)
		event.EohSetRot(0, 0.0, 2.9, 0.0)
		event.EohSetFootSoundId(0, 2)
		event.EohSetPos(1, 35.37, -7.06, 202.4)
		event.EohSetRot(1, 0.0, -2.9, 0.0)
		event.EohSetFootSoundId(1, 2)
		event.EohSetShow(2, 0)
		event.SetTime(0)
		event.InitDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CmrsInit()
		event.CmrsSetPos(21.14, 60.19, 163.18)
		event.CmrsSetRef(24.82, 14.07, 201.88)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.SetFadeIn(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おどろき顔")
		event.ObjsTexAnime(0, 1, "おどろき目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おどろき顔")
		event.ObjsTexAnime(1, 1, "おどろき目パチ")
		helper_888ab2a3(30)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(6400420, -1)
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(6400430, -1)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.LoadMes(0, -1)
end

--- Helper function.
local function helper_35964()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.SetFlag(640, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e640/")
		event.LoadMes(0, 5, "e640.txt")
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
		event.EohSyncObj_2(2, "p01_s98")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
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
		event.EohSetPos(0, 12.52, -7.06, 206.03)
		event.EohSetRot(0, 0.0, 2.9, 0.0)
		event.EohSetFootSoundId(0, 2)
		event.EohSetPos(1, 35.37, -7.06, 202.4)
		event.EohSetRot(1, 0.0, -2.9, 0.0)
		event.EohSetFootSoundId(1, 2)
		event.EohSetShow(2, 0)
		event.SetTime(0)
		event.InitDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CmrsInit()
		event.CmrsSetPos(-6.36, 3.35, 161.53)
		event.CmrsSetRef(27.9, 14.07, 208.34)
		event.ObjsSetMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.SetFadeIn(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おどろき顔")
		event.ObjsTexAnime(0, 1, "おどろき目～おこり目")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "すごい", 6)
		event.ObjsNextMotion(0, "すごいL", 4)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(6400460)
		event.ObjsSetMotion(1, "上から左", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		helper_0958ca60(1)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(6400470)
		event.ObjsSetMotion(0, "すごい戻り", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		helper_0958ca60(0)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(6400480)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
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
	event.LoadMes(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_500() end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.SetFadeOut(0)
	helper_25fac()
	event.MapJump_3(-1, "i04h01", 530)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_2d5ec()
	event.MapJump_3(-1, "s30", 610)
	vm.wait(2)
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	helper_30394()
	event.MapJump_3(-1, "s30", 630)
	vm.wait(2)
end

--- Event 620, which map data, a script or the engine runs by number.
function script.event_620()
	helper_31fac()
	event.MapJump_3(-1, "s30", 640)
	vm.wait(2)
end

--- Event 630, which map data, a script or the engine runs by number.
function script.event_630()
	helper_34380()
	event.MapJump_3(-1, "s30", 650)
	vm.wait(2)
end

--- Event 650, which map data, a script or the engine runs by number.
function script.event_650()
	helper_35964()
	event.MapJump_3(-1, "s11", 510)
	vm.wait(2)
end

--- Event 16400, which map data, a script or the engine runs by number.
function script.event_16400()
	helper_2d5ec()
	event.MapJump_3(-1, "s30", 610)
	vm.wait(2)
end

--- Event 17360, which map data, a script or the engine runs by number.
function script.event_17360()
	event.SetFadeOut(0)
	event.SetSavedataEtc(0, 10)
	event.MapJump_3(-1, "s66", 17370)
	vm.wait(1)
end

--- Event 17370, which map data, a script or the engine runs by number.
function script.event_17370()
	event.SetFadeOut(0)
	helper_25fac()
	event.MapJump_3(-1, "i04h01", 530)
	vm.wait(2)
end

return script
