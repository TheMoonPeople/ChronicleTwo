--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a344ece = require("@lib/event/helper_0a344ece")
local helper_75f3e820 = require("@lib/event/helper_75f3e820")
local helper_9b8126b9 = require("@lib/event/helper_9b8126b9")
local helper_a057a7e5 = require("@lib/event/helper_a057a7e5")
local helper_ae53acce = require("@lib/event/helper_ae53acce")
local helper_ffeb2648 = require("@lib/event/helper_ffeb2648")

--- Helper function.
local function helper_b9c0b815()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 106 then
			if at <= 1 then
				helper_ffeb2648()
			end
			if at <= 2 then
				helper_9b8126b9()
			end
			if at <= 3 then
				helper_0a344ece(0, 3010, 8, 0, 0)
			end
			if at <= 4 then
				helper_0a344ece(0, 3020, 8, 0, 0)
			end
			if at <= 5 then
				helper_ae53acce(0)
			end
			if at <= 6 then
				helper_0a344ece(0, 3030, 8, 0, 0)
			end
			if at <= 7 then
				helper_ae53acce(0)
			end
			if at <= 8 then
				helper_a057a7e5(0, 3040, 8, 0, 0, 200)
			end
			if at <= 9 then
				helper_ae53acce(0)
			end
			if at <= 10 then
				helper_ae53acce(0)
			end
			if at <= 11 then
				helper_ae53acce(0)
			end
			if at <= 12 then
				helper_75f3e820(90)
			end
			if at <= 13 then
				helper_9b8126b9()
			end
			if at <= 14 then
				helper_75f3e820(30)
			end
			if at <= 15 then
				helper_ae53acce(0)
			end
			if at <= 16 then
				helper_ae53acce(0)
			end
			if at <= 17 then
				helper_75f3e820(30)
			end
			if at <= 18 then
				helper_0a344ece(0, 3050, 8, 0, 0)
			end
			if at <= 19 then
				helper_ae53acce(0)
			end
			if at <= 20 then
				helper_a057a7e5(0, 3060, 8, 0, 0, 150)
			end
			if at <= 21 then
				helper_a057a7e5(0, 3070, 8, 0, 0, 150)
			end
			if at <= 22 then
				helper_9b8126b9()
			end
			if at <= 23 then
				helper_0a344ece(0, 3080, 8, 0, 0)
			end
			if at <= 24 then
				helper_ae53acce(1)
			end
			if at <= 25 then
				helper_0a344ece(0, 3090, 8, 0, 0)
			end
			if at <= 26 then
				helper_ae53acce(1)
			end
			if at <= 27 then
				helper_ae53acce(1)
			end
			if at <= 28 then
				helper_0a344ece(0, 3100, 8, 0, 0)
			end
			if at <= 29 then
				helper_0a344ece(0, 3110, 8, 0, 0)
			end
			if at <= 30 then
				helper_0a344ece(0, 3120, 8, 0, 0)
			end
			if at <= 31 then
				helper_0a344ece(0, 3130, 8, 0, 0)
			end
			if at <= 32 then
				helper_ae53acce(1)
			end
			if at <= 33 then
				helper_0a344ece(0, 3140, 8, 0, 0)
			end
			if at <= 34 then
				helper_ae53acce(1)
			end
			if at <= 35 then
				helper_0a344ece(0, 3150, 8, 0, 0)
			end
			if at <= 36 then
				helper_75f3e820(4)
			end
			if at <= 37 then
				helper_75f3e820(10)
			end
			if at <= 39 then
				helper_a057a7e5(0, 3160, 8, 0, 0, 60)
			end
			if at <= 40 then
				helper_75f3e820(60)
			end
			if at <= 41 then
				helper_ae53acce(1)
			end
			if at <= 42 then
				helper_0a344ece(0, 3170, 8, 0, 0)
			end
			if at <= 43 then
				helper_75f3e820(30)
			end
			if at <= 44 then
				helper_75f3e820(30)
			end
			if at <= 45 then
				helper_0a344ece(0, 3180, 8, 0, 0)
			end
			if at <= 46 then
				helper_ae53acce(1)
			end
			if at <= 47 then
				helper_0a344ece(0, 3190, 8, 0, 0)
			end
			if at <= 48 then
				helper_ae53acce(1)
			end
			if at <= 49 then
				helper_a057a7e5(0, 3200, 8, 0, 0, 60)
			end
			if at <= 50 then
				helper_ae53acce(1)
			end
			if at <= 51 then
				helper_0a344ece(0, 3210, 8, 0, 0)
			end
			if at <= 52 then
				helper_ae53acce(0)
			end
			if at <= 53 then
				helper_ae53acce(1)
			end
			if at <= 54 then
				helper_0a344ece(0, 3220, 8, 0, 0)
			end
			if at <= 55 then
				helper_ae53acce(1)
			end
			if at <= 56 then
				helper_a057a7e5(0, 3230, 8, 0, 0, 60)
			end
			if at <= 57 then
				helper_ae53acce(1)
			end
			if at <= 58 then
				helper_75f3e820(30)
			end
			if at <= 59 then
				helper_0a344ece(0, 3240, 8, 0, 0)
			end
			if at <= 60 then
				helper_ae53acce(1)
			end
			if at <= 61 then
				helper_ae53acce(2)
			end
			if at <= 62 then
				helper_ae53acce(1)
			end
			if at <= 63 then
				helper_75f3e820(15)
			end
			if at <= 64 then
				helper_9b8126b9()
			end
			if at <= 65 then
				helper_0a344ece(0, 3250, 8, 0, 0)
			end
			if at <= 66 then
				helper_0a344ece(0, 3260, 8, 0, 0)
			end
			if at <= 67 then
				helper_0a344ece(0, 3270, 8, 0, 0)
			end
			if at <= 68 then
				helper_ae53acce(2)
			end
			if at <= 69 then
				helper_75f3e820(20)
			end
			if at <= 70 then
				helper_ae53acce(0)
			end
			if at <= 71 then
				helper_ae53acce(0)
			end
			if at <= 72 then
				helper_75f3e820(30)
			end
			if at <= 73 then
				helper_0a344ece(0, 3280, 8, 0, 0)
			end
			if at <= 74 then
				helper_ae53acce(1)
			end
			if at <= 75 then
				helper_75f3e820(3)
			end
			if at <= 76 then
				helper_75f3e820(4)
			end
			if at <= 77 then
				helper_75f3e820(5)
			end
			if at <= 78 then
				helper_75f3e820(5)
			end
			if at <= 79 then
				helper_75f3e820(20)
			end
			if at <= 80 then
				helper_75f3e820(6)
			end
			if at <= 81 then
				helper_75f3e820(3)
			end
			if at <= 82 then
				helper_75f3e820(2)
			end
			if at <= 83 then
				helper_ae53acce(4)
			end
			if at <= 84 then
				helper_ae53acce(5)
			end
			if at <= 85 then
				helper_ae53acce(6)
			end
			if at <= 86 then
				helper_75f3e820(30)
			end
			if at <= 87 then
				helper_0a344ece(0, 3290, 8, 0, 0)
			end
			if at <= 88 then
				helper_9b8126b9()
			end
			if at <= 89 then
				helper_0a344ece(0, 3300, 8, 0, 0)
			end
			if at <= 90 then
				helper_ae53acce(1)
			end
			if at <= 91 then
				helper_75f3e820(5)
			end
			if at <= 92 then
				helper_75f3e820(3)
			end
			if at <= 93 then
				helper_75f3e820(1)
			end
			if at <= 94 then
				helper_ae53acce(1)
			end
			if at <= 95 then
				helper_ae53acce(3)
			end
			if at <= 96 then
				helper_ae53acce(4)
			end
			if at <= 97 then
				helper_ae53acce(5)
			end
			if at <= 98 then
				helper_ae53acce(6)
			end
			if at <= 99 then
				helper_75f3e820(20)
			end
			if at <= 100 then
				helper_75f3e820(26)
			end
			if at <= 101 then
				helper_75f3e820(20)
			end
			if at <= 102 then
				helper_75f3e820(43)
			end
			if at <= 103 then
				helper_75f3e820(32)
			end
			if at <= 104 then
				helper_75f3e820(70)
			end
			if at <= 105 then
				helper_9b8126b9()
			end
			if vm.skip_end() then
				return skip(107)
			end
			return part2()
		end
		if at <= 107 then
			var1 = 0
			var1 = var1 + 1
			helper_75f3e820(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		var1 = 0
		while var1 < 30 do
			event.ObjsInit(var1)
			var1 = var1 + 1
		end
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.CharaActive(0)
		event.EohSetShow(29, 1)
		event.EohSetShow(30, 1)
		event.EohSetShow(31, 1)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_75f3e820(6)
		if vm.skipping() then
			return skip(108)
		end
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.LoadSeEnv(3)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1215) or var0
	event.LoadMotion(5, "event/opening/p3/p3_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 515.79, 133.45, -51.32)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(0, "右向き立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "キラキラ目")
	event.ObjsTexAnime(0, 1, "感激口")
	event.LoadChara(5, "event/opening/p3/p3_polcurse.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetSoundId(1, var0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 403.49, 0.0, 348.3)
	event.ObjsSetRot(1, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.LoadChara(5, "event/opening/p3/p3_need.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetSoundId(2, var0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 403.49, 0.0, 348.3)
	event.ObjsSetRot(2, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.SetLoadbgFile("event/opening/p3/p3_pierrot.gltf")
	if vm.wait() then
		return skip(1)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadChara(5, "event/opening/p3/p3_pierrot.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.EohSetFrameShow(3, "obj10", 0)
	event.EohSetFrameShow(3, "obj11", 0)
	event.EohSetFrameShow(3, "obj6", 0)
	event.EohSetFrameShow(3, "obj4", 0)
	event.EohSetShadow(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 308.7, -100.0, 243.42)
	event.ObjsSetRot(3, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.LoadChara(5, "event/opening/p3/p3_pierrot.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.EohSetFrameShow(4, "obj10", 0)
	event.EohSetFrameShow(4, "obj11", 0)
	event.EohSetFrameShow(4, "obj6", 0)
	event.EohSetFrameShow(4, "obj4", 0)
	event.EohSetShadow(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 308.7, -100.0, 243.42)
	event.ObjsSetRot(4, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.LoadChara(5, "event/opening/p3/p3_pierrot.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var0)
	event.EohSetFrameShow(5, "obj10", 0)
	event.EohSetFrameShow(5, "obj11", 0)
	event.EohSetFrameShow(5, "obj6", 0)
	event.EohSetFrameShow(5, "obj4", 0)
	event.EohSetShadow(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 308.7, -100.0, 243.42)
	event.ObjsSetRot(5, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(5, "立ち", 4)
	event.LoadChara(5, "event/opening/p3/p3_pierrot.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(6, 14)
	event.EohSetSoundId(6, var0)
	event.EohSetFrameShow(6, "obj10", 0)
	event.EohSetFrameShow(6, "obj11", 0)
	event.EohSetFrameShow(6, "obj6", 0)
	event.EohSetFrameShow(6, "obj4", 0)
	event.EohSetShadow(6, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 308.7, -100.0, 243.42)
	event.ObjsSetRot(6, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(6, "立ち", 4)
	event.SetLoadbgFile("")
	event.EohSyncObj(8, "p04_i03h02a-3", "i03h02a_09-m")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p04_i03h02a-3", "i03h02a_09-m1")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(11, "p04_i03h02a-1", "i03h02a_09-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p04_i03h02a-1", "i03h02a_09-m1")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(14, "p04_i03h02a-4", "i03h02a_09-m")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p04_i03h02a-4", "i03h02a_09-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(17, "p04_i03h02a-7", "i03h02a_09-m")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.EohSyncObj(18, "p04_i03h02a-7", "i03h02a_09-m1")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.EohSyncObj(20, "p04_i03h02a-5", "i03h02a_09-m")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.EohSyncObj(21, "p04_i03h02a-5", "i03h02a_09-m1")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.EohSyncObj(23, "p04_i03h02a-6", "i03h02a_09-m")
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.EohSyncObj(24, "p04_i03h02a-6", "i03h02a_09-m1")
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	event.EohSyncObj(26, "p04_i03h02a-2", "i03h02a_09-m")
	event.ObjsInit(26)
	event.ObjsSyncObj(26, 26)
	event.EohSyncObj(27, "p04_i03h02a-2", "i03h02a_09-m1")
	event.ObjsInit(27)
	event.ObjsSyncObj(27, 27)
	event.EohSyncObj(28, "p10_i03h02a-3")
	event.EohSetShow(28, 1)
	event.ObjsInit(28)
	event.ObjsSyncObj(28, 28)
	event.ObjsSetPos(28, 522.4, 133.457, 264.31)
	event.ObjsSetRot(28, 0.0, 2.07, 0.0)
	event.EohSyncObj(29, "p05_i03h02")
	event.EohSetShow(29, 1)
	event.EohSyncObj(30, "p12_i03h02")
	event.EohSetShow(30, 1)
	event.EohSyncObj(31, "p11_i03h02a")
	event.EohSetShow(31, 1)
	event.PlayEnvBgm(0, -1)
	event.CmrsInit()
	event.CmrsSetPos(490.95, 150.85, -36.92)
	event.CmrsSetRef(516.0, 155.52, -52.16)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(3)
	end
	helper_0a344ece(0, 3010, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "気づく目")
	event.ObjsTexAnime(0, 1, "気づく口")
	helper_0a344ece(0, 3020, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(0, "左を向く", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "口パク", "気づく口")
	helper_0a344ece(0, 3030, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(464.32, 205.65, -101.4)
	event.CmrsSetRef(530.94, 172.86, -6.08)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 200)
	event.ObjsAddPas(0, 515.79, 133.45, -51.32)
	event.ObjsAddPas(0, 541.57, 133.45, -26.11)
	event.ObjsAddPas(0, 567.71, 133.45, 15.9)
	event.ObjsAddPas(0, 579.59, 133.45, 67.16)
	event.ObjsAddPas(0, 575.7, 133.45, 112.7)
	event.ObjsStartPas(0)
	helper_a057a7e5(0, 3040, 8, 0, 0, 200)
	if vm.skipping() then
		return skip(9)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetBgmVolFloat(0.4)
	event.SndSetEnvVol(0.4)
	event.CmrsSetPos(600.01, 181.57, 350.2)
	event.CmrsSetRef(572.65, 156.22, 246.87)
	event.ObjsSetPos(0, 576.02, 133.45, 143.2)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsMove(0, 559.81, 133.45, 206.55, 90)
	event.ObjsSetMotion(0, "きょろきょろ歩き", 4)
	event.ObjsTexAnime(0, 1, "キョロキョロ")
	event.ObjsTexAnime(0, 1, "半開き口")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(574.34, 203.79, 190.06)
	event.CmrsSetRef(543.29, 142.99, 227.79)
	event.CmrsMove2(557.65, 203.79, 250.72, 526.69, 142.99, 288.12, 180, 2, 0.4)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetPos(0, 547.89, 133.45, 215.23)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsMove(0, 534.64, 133.45, 265.0, 90)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "旧・立ち", 2)
	event.ObjsMotionWait(0)
	helper_75f3e820(90)
	if vm.skipping() then
		return skip(13)
	end
	event.FadeOutBgm(90)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(14)
	end
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "手をかける", 6)
	event.ObjsMotionWait(0)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(526.24, 130.39, 294.97)
	event.CmrsSetRef(532.61, 159.94, 272.03)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "身を乗りだす", 6)
	event.ObjsNextMotion(0, "身を乗りだすL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsTexaDelay(0, 25)
	event.ObjsTexAnime(0, 1, "目パチ×2")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0, "目パチ×2")
	event.ObjsTexAnime(0, 1, "目パチ×2")
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(18)
	end
	event.StopBgm(0)
	event.SetPakuAnim(0, "口パク", "怒り口")
	helper_0a344ece(0, 3050, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(20)
	end
	event.LoadBgm(105)
	event.PlayBgm(0, -1)
	event.FadeInBgm(30)
	event.ObjsTexAnime(0, 0)
	event.EohSetShadow(0, 0)
	event.CmrsSetPos(318.23, 170.94, 487.51)
	event.CmrsSetRef(414.66, 165.51, 406.31)
	event.CmrsMove(318.23, 37.87, 487.51, 414.66, 32.43, 406.31, 300)
	event.EohSetShow(29, 0)
	event.EohSetShow(30, 0)
	event.SetPakuAnim(1, "口パク")
	helper_a057a7e5(0, 3060, 8, 0, 0, 150)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_a057a7e5(0, 3070, 8, 0, 0, 150)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_9b8126b9()
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(443.82, 30.29, 368.2)
	event.CmrsSetRef(405.19, 24.85, 336.85)
	event.ObjsSetMotion(1, "つつく", 2)
	event.ObjsNextMotion(1, "つつくL", 4)
	event.ObjsSetMotion(2, "つつく", 2)
	event.ObjsNextMotion(2, "つつくL", 4)
	event.ObjsSeDelay(1, 4)
	event.ObjsSePlay(1, var0, 4)
	event.SetPakuAnim(1, "口パク")
	helper_0a344ece(0, 3080, 8, 0, 0)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(1, "頭をたたく", 2)
	event.ObjsNextMotion(1, "頭をたたくL", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "頭をたたくL", 6)
	event.ObjsNextMotion(1, "頭をたたくL2", 4)
	event.ObjsSetMotion(2, "頭をたたく", 2)
	event.ObjsNextMotion(2, "頭をたたくL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "頭をたたくL", 6)
	event.ObjsNextMotion(2, "頭をたたくL2", 4)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3090, 8, 0, 0)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(1, "頭をたたく戻り", 6)
	event.ObjsNextMotion(1, "腰に手L", 4)
	event.ObjsSetMotion(2, "頭をたたく戻り", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsTexAnime(2, 1, "困り瞬き")
	event.SetPakuMotion(2, "会話", 4, "立ち", 0)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_0a344ece(0, 3100, 8, 0, 0)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.ResetPakuMotion()
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3110, 8, 0, 0)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_0a344ece(0, 3120, 8, 0, 0)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.ResetPakuMotion()
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsMotionWait(1)
	event.ObjsSeDelay(1, 6)
	event.ObjsSePlay(1, var0, 7)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3130, 8, 0, 0)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(432.14, 25.02, 368.63)
	event.CmrsSetRef(402.39, 25.98, 348.56)
	event.ObjsSetMotion(1, "鼻ぴくぴく", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "鼻ぴくぴく", 4)
	event.ObjsTexAnime(1, 1, "クンクン目")
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3140, 8, 0, 0)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsSetMotion(1, "立ち")
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_0a344ece(0, 3150, 8, 0, 0)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.ResetPakuMotion()
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	helper_75f3e820(4)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsTexAnime(1, 0, "クンクン目")
	event.ObjsTexAnime(1, 1, "怒り目")
	event.ObjsTexAnime(1, 1, "怒り口")
	event.ObjsSetMotion(1, "シメル", 6)
	event.ObjsNextMotion(1, "シメルL", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(2, "シメル", 6)
	event.ObjsNextMotion(2, "シメルL", 4)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "痛がり目")
	event.ObjsTexAnime(2, 1, "痛がり口")
	if vm.wait() then
		return skip(39)
	end
	event.SetPakuAnim(2, "口パク", "痛がり口")
	helper_a057a7e5(0, 3160, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	helper_75f3e820(60)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(455.51, 42.59, 306.46)
	event.CmrsSetRef(415.88, 17.86, 345.25)
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(42)
	end
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3170, 8, 0, 0)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "蹴る", 6)
	event.ObjsNextMotion(1, "踏みつけL", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "踏みつけL", 6)
	event.ObjsNextMotion(1, "踏みつけL2", 4)
	event.ObjsSetMotion(2, "蹴る", 6)
	event.ObjsNextMotion(2, "踏みつけL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "踏みつけL", 6)
	event.ObjsNextMotion(2, "踏みつけL2", 4)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(44)
	end
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦しがり目")
	event.ObjsTexAnime(2, 1, "苦しがり口")
	event.CmrsSetPos(504.32, 2.39, 361.02)
	event.CmrsSetRef(456.2, 16.46, 340.74)
	event.SetPakuAnim(2, "口パク", "苦しがり口")
	helper_0a344ece(0, 3180, 8, 0, 0)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_0a344ece(0, 3190, 8, 0, 0)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(1, "笑い", 2)
	event.ObjsNextMotion(1, "笑いL", 4)
	event.ObjsTexAnime(1, 0, "怒り目")
	event.ObjsTexAnime(1, 1, "笑い口")
	helper_a057a7e5(0, 3200, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsTexAnime(1, 0, "笑い口")
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(412.51, 94.68, 448.16)
	event.CmrsSetRef(457.77, 16.14, 335.83)
	event.ObjsSetMotion(2, "相手を見る", 2)
	event.ObjsNextMotion(2, "相手を見るL", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "相手を見る", 2)
	event.ObjsNextMotion(1, "相手を見るL", 4)
	helper_0a344ece(0, 3210, 8, 0, 0)
	if vm.skipping() then
		return skip(52)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(53)
	end
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(54)
	end
	event.SetPakuAnim(1, "口パク")
	helper_0a344ece(0, 3220, 8, 0, 0)
	if vm.skipping() then
		return skip(55)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsSetMotion(1, "相手を見る→笑い", 2)
	event.ObjsNextMotion(1, "笑いL", 4)
	event.ObjsTexAnime(1, 1, "笑い口")
	helper_a057a7e5(0, 3230, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsTexAnime(1, 0, "笑い口")
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetPos(28, 491.85, 57.59, 280.68)
	event.ObjsJump(28, 491.85, 1.02, 280.68, -0.4, 30)
	event.ObjsRotation(28, 1.5, 3.12, 0.35, 30)
	event.ObjsJump(28, 486.47, 3.02, 258.4, -0.3, 20)
	event.ObjsRotation(28, 0.0, 0.0, 0.0, 20)
	event.ObjsJump(28, 491.86, 3.14, 242.12, -0.25, 15)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 15)
	event.ObjsJump(28, 500.58, 3.2, 235.17, -0.15, 10)
	event.ObjsMove(28, 524.68, 3.2, 222.45, 24)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 5)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 5)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 12)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 6)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 6)
	event.ObjsSePlay(28, var0, 17)
	event.ObjsSeDelay(28, 30)
	event.ObjsSePlay(28, var0, 18)
	event.ObjsSeDelay(28, 20)
	event.ObjsSePlay(28, var0, 19)
	event.ObjsSeDelay(28, 15)
	event.ObjsSePlay(28, var0, 20)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(59)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(1, "破片を見る", 2)
	event.ObjsNextMotion(1, "破片を見るL", 4)
	event.ObjsSetMotion(2, "破片を見る", 2)
	event.ObjsNextMotion(2, "破片を見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_0a344ece(0, 3240, 8, 0, 0)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(61)
	end
	helper_ae53acce(2)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(1, "上を見る", 6)
	event.ObjsNextMotion(1, "上を見るL", 4)
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(63)
	end
	helper_75f3e820(15)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetMotion(0, "かんけり", 4)
	event.CmrsSetPos(459.14, 28.95, 319.9)
	event.CmrsSetRef(523.37, 3.23, 222.23)
	event.CmrsPrdelay(15)
	event.Ext(405, 459.14, 28.95, 319.9, 518.73, 134.52, 282.38, 30, 0, 0.2) -- retail: the handler rejects 9 arguments
	event.CmrsPrdelay(30)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsSetPos(526.24, 130.39, 294.97)
	event.CmrsSetRef(532.61, 159.94, 272.03)
	event.ObjsTexAnime(0, 1, "ピクピク目")
	event.ObjsTexAnime(0, 1, "あわあわ口")
	event.ObjsTexAnime(1, 0)
	helper_0a344ece(0, 3250, 8, 0, 0)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "半開き口")
	event.ObjsTexAnime(2, 0)
	event.CmrsSetPos(469.26, 78.46, 302.58)
	event.CmrsSetRef(454.3, 19.03, 336.32)
	event.ObjsSetPos(1, 448.41, 0.0, 334.3)
	event.ObjsSetRot(1, 0.0, 2.65, 0.0)
	event.ObjsSetMotion(1, "上見立ち", 4)
	event.SetPakuAnim(1, "口パク", "気づく口")
	helper_0a344ece(0, 3260, 8, 0, 0)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var0, 21)
	event.ObjsSetMotion(2, "驚く", 6)
	event.ObjsNextMotion(2, "驚くL", 4)
	event.SetPakuAnim(2, "口パク")
	helper_0a344ece(0, 3270, 8, 0, 0)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	helper_ae53acce(2)
	if vm.skipping() then
		return skip(69)
	end
	event.EohSetShadow(0, 1)
	event.CmrsSetPos(510.2, 146.32, 276.25)
	event.CmrsSetRef(534.03, 155.11, 258.68)
	event.EohSetShow(31, 0)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsMotionWait(0)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(70)
	end
	event.SndSePlay(var0, 22)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(71)
	end
	event.EohSetShow(31, 1)
	event.CmrsSetPos(584.86, 197.48, 305.84)
	event.CmrsSetRef(544.65, 150.54, 250.94)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetRot(0, 0.0, 2.8, 0.0)
	event.ObjsMove(0, 570.34, 133.45, 120.98, 50)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(461.98, 29.1, 307.38)
	event.CmrsSetRef(447.72, 27.8, 336.09)
	event.CharaActive(0, 0)
	event.CharaActive(0, 10)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(73)
	end
	event.SndSePlay(var0, 23)
	event.ObjsSetMotion(1, "ニヤリ", 6)
	event.ObjsNextMotion(1, "ニヤリL", 4)
	event.ObjsTexAnime(1, 0, "気づく口")
	event.ObjsTexAnime(1, 1, "見回し")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_0a344ece(0, 3280, 8, 0, 0)
	if vm.skipping() then
		return skip(74)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(75)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(14)
	event.CmrsSetPos(425.56, 60.68, 401.69)
	event.CmrsSetRef(540.96, 27.8, 343.52)
	helper_75f3e820(3)
	if vm.skipping() then
		return skip(76)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(8, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(9, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(3, 595.28, -100.0, 301.83)
	event.ObjsSetRot(3, 0.0, -1.74, 0.0)
	event.ObjsPosDelay(3, 10)
	event.ObjsSetPos(3, 595.28, 0.0, 301.83)
	event.ObjsPosDelay(3, 4)
	event.ObjsJump(3, 552.31, 0.0, 299.96, -0.6, 30)
	event.ObjsSetMotion(3, "ジャンプ", 6)
	event.ObjsNextMotion(3, "ジャンプL", 4)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsSeDelay(3, 15)
	event.ObjsSePlay(3, var0, 25)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 26)
	helper_75f3e820(4)
	if vm.skipping() then
		return skip(77)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(14, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(15, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 530.7, -100.0, 408.01)
	event.ObjsSetRot(5, 0.0, -2.58, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetPos(5, 530.7, 0.0, 408.01)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 508.68, 0.0, 377.01, -0.6, 30)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSeDelay(5, 15)
	event.ObjsSePlay(5, var0, 32)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 35)
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(78)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(11, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(12, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 576.1, -100.0, 360.47)
	event.ObjsSetRot(4, 0.0, -2.22, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetPos(4, 576.1, 0.0, 360.47)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 545.68, 0.0, 340.87, -0.6, 30)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSeDelay(4, 15)
	event.ObjsSePlay(4, var0, 33)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 36)
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(79)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(17, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(18, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 526.55, -100.0, 296.48)
	event.ObjsSetRot(6, 0.0, -2.7, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetPos(6, 526.55, 0.0, 296.48)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 513.97, 0.0, 263.38, -0.6, 30)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSeDelay(6, 15)
	event.ObjsSePlay(6, var0, 34)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 35)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(80)
	end
	event.CmrsSetPos(368.19, 67.07, 517.9)
	event.CmrsSetRef(338.11, 27.8, 359.17)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	helper_75f3e820(6)
	if vm.skipping() then
		return skip(81)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(26, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(27, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 295.21, -100.0, 424.99)
	event.ObjsSetRot(6, 0.0, 1.72, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetPos(6, 295.21, 0.0, 424.99)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 335.17, 0.0, 418.75, -0.6, 30)
	event.ObjsResetMotion(6)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSeDelay(6, 15)
	event.ObjsSePlay(6, var0, 33)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 36)
	helper_75f3e820(3)
	if vm.skipping() then
		return skip(82)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(20, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(21, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 415.0, -100.0, 295.84)
	event.ObjsSetRot(4, 0.0, 1.0, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetPos(4, 415.0, 0.0, 295.84)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 438.03, 0.0, 320.39, -0.6, 30)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSeDelay(4, 15)
	event.ObjsSePlay(4, var0, 25)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 26)
	helper_75f3e820(2)
	if vm.skipping() then
		return skip(83)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(23, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(24, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 310.01, -100.0, 385.25)
	event.ObjsSetRot(5, 0.0, 1.36, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetPos(5, 310.01, 0.0, 385.25)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 353.06, 0.0, 395.44, -0.6, 30)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSeDelay(5, 15)
	event.ObjsSePlay(5, var0, 32)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 35)
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(84)
	end
	helper_ae53acce(5)
	if vm.skipping() then
		return skip(85)
	end
	helper_ae53acce(6)
	if vm.skipping() then
		return skip(86)
	end
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(87)
	end
	event.CmrsSetPos(457.86, 29.1, 315.67)
	event.CmrsSetRef(447.72, 27.8, 336.09)
	event.CmrsMove(461.98, 29.1, 307.38, 447.72, 27.8, 336.09, 240)
	event.ObjsSetPos(3, 411.67, 0.0, 337.3)
	event.ObjsSetRot(3, 0.0, 2.65, 0.0)
	event.ObjsMove(3, 427.17, 0.0, 345.0, 150)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetPos(4, 468.94, 0.0, 362.61)
	event.ObjsSetRot(4, 0.0, 2.65, 0.0)
	event.ObjsMove(4, 453.19, 0.0, 354.78, 150)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetPos(5, 397.62, 0.0, 340.14)
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(5, 60)
	event.ObjsMove(5, 414.56, 0.0, 347.41, 100)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsSetPos(6, 475.17, 0.0, 377.94)
	event.ObjsSetRot(6, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(6, 60)
	event.ObjsMove(6, 458.94, 0.0, 369.88, 100)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsTexAnime(1, 0, "見回し")
	event.ObjsTexAnime(1, 1, "怒り瞬き")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_0a344ece(0, 3290, 8, 0, 0)
	if vm.skipping() then
		return skip(88)
	end
	event.ResetPakuAnim()
	helper_9b8126b9()
	if vm.skipping() then
		return skip(89)
	end
	event.SndSePlay(var0, 27)
	event.ObjsSetMotion(1, "命令する", 6)
	event.ObjsNextMotion(1, "命令するL", 6)
	event.ObjsTexAnime(1, 0, "怒り瞬き")
	event.ObjsTexAnime(1, 1, "右向き目")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_0a344ece(0, 3300, 8, 0, 0)
	if vm.skipping() then
		return skip(90)
	end
	event.ResetPakuAnim()
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(91)
	end
	event.ObjsSetMotion(1, "命令する戻り", 6)
	event.ObjsTexAnime(1, 0, "右向き目")
	event.ObjsTexAnime(1, 1, "にやり目")
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsPosDelay(3, 15)
	event.ObjsMove(3, 427.17, 48.0, 345.0, 10)
	event.ObjsSeDelay(3, 5)
	event.ObjsSePlay(3, var0, 28)
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(92)
	end
	event.ObjsSetMotion(6, "ジャンプ", 2)
	event.ObjsPosDelay(6, 15)
	event.ObjsMove(6, 458.94, 48.0, 369.88, 10)
	event.ObjsSeDelay(6, 5)
	event.ObjsSePlay(6, var0, 28)
	helper_75f3e820(3)
	if vm.skipping() then
		return skip(93)
	end
	event.SndSePlay(var0, 28)
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsPosDelay(4, 15)
	event.ObjsMove(4, 453.19, 48.0, 354.78, 10)
	event.ObjsSeDelay(4, 5)
	event.ObjsSePlay(4, var0, 28)
	helper_75f3e820(1)
	if vm.skipping() then
		return skip(94)
	end
	event.SndSePlay(var0, 28)
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsPosDelay(5, 15)
	event.ObjsMove(5, 414.56, 48.0, 347.41, 10)
	event.ObjsSeDelay(5, 5)
	event.ObjsSePlay(5, var0, 28)
	helper_ae53acce(1)
	if vm.skipping() then
		return skip(95)
	end
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(96)
	end
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(97)
	end
	helper_ae53acce(5)
	if vm.skipping() then
		return skip(98)
	end
	helper_ae53acce(6)
	if vm.skipping() then
		return skip(99)
	end
	event.ObjsSetPos(1, 483.34, 0.0, 472.15)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSetPos(6, 0.0, -100.0, 0.0)
	event.CmrsSetPos(374.25, 90.25, 474.87)
	event.CmrsSetRef(429.51, 90.03, 420.03)
	event.CmrsMove(384.94, 132.84, 483.9, 429.51, 132.62, 420.03, 270)
	event.ObjsSetRot(5, 0.0, 2.77, 0.0)
	event.ObjsSetPos(5, 461.73, 0.8, 410.06)
	event.ObjsJump(5, 558.2, 133.44, 226.12, -0.8, 30)
	event.ObjsSetMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 25)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsNextMotion(5, "歩き")
	event.ObjsPosDelay(5, 20)
	event.ObjsMove(5, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 30)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(100)
	end
	event.ObjsSetRot(4, 0.0, 2.29, 0.0)
	event.ObjsSetPos(4, 399.95, -7.44, 419.55)
	event.ObjsJump(4, 558.2, 133.44, 226.12, -0.8, 30)
	event.Ext(462, 4, 0.0, 2.89, 0.0) -- retail: the handler rejects 4 arguments
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 30)
	helper_75f3e820(26)
	if vm.skipping() then
		return skip(101)
	end
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetPos(3, 507.93, 0.0, 385.84)
	event.ObjsRotDelay(3, 10)
	event.ObjsRotation(3, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(3, 561.55, 99.23, 382.0, -0.4, 30)
	event.ObjsSetMotion(3, "ジャンプL")
	event.ObjsMotionDelay(3, 25)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsNextMotion(3, "ジャンプL")
	event.ObjsPosDelay(3, 32)
	event.ObjsJump(3, 558.2, 133.44, 226.12, -0.6, 30)
	event.ObjsMotionDelay(3, 18)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsNextMotion(3, "歩き")
	event.ObjsPosDelay(3, 20)
	event.ObjsMove(3, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 31)
	event.ObjsSeDelay(3, 62)
	event.ObjsSePlay(3, var0, 30)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(102)
	end
	event.ObjsSetRot(6, 0.0, 2.77, 0.0)
	event.ObjsRotation(6, 0.0, 2.77, 0.0, 30)
	event.ObjsSetPos(6, 490.07, 0.0, 354.49)
	event.ObjsJump(6, 558.2, 133.44, 226.12, -0.8, 30)
	event.ObjsSetMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 25)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsMotionDelay(6, 20)
	event.ObjsNextMotion(6, "歩き")
	event.ObjsPosDelay(6, 20)
	event.ObjsMove(6, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(6, 0.0, -100.0, 0.0)
	event.ObjsSePlay(6, var0, 29)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 30)
	helper_75f3e820(43)
	if vm.skipping() then
		return skip(103)
	end
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsSetPos(5, 412.89, 25.69, 457.94)
	event.ObjsRotDelay(5, 10)
	event.ObjsRotation(5, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(5, 486.54, 130.52, 361.4, -0.4, 30)
	event.ObjsSetMotion(5, "ジャンプL")
	event.ObjsMotionDelay(5, 23)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 24)
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsNextMotion(5, "ジャンプL")
	event.ObjsPosDelay(5, 36)
	event.ObjsJump(5, 558.2, 133.44, 226.12, -0.4, 30)
	event.ObjsMotionDelay(5, 18)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsNextMotion(5, "歩き")
	event.ObjsPosDelay(5, 20)
	event.ObjsMove(5, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 31)
	event.ObjsSeDelay(5, 66)
	event.ObjsSePlay(5, var0, 30)
	event.ObjsSetMotion(1, "走り")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 140)
	event.ObjsAddPas(1, 483.34, 0.0, 472.15)
	event.ObjsAddPas(1, 515.13, 18.89, 455.65)
	event.ObjsAddPas(1, 554.52, 44.98, 429.55)
	event.ObjsAddPas(1, 588.83, 78.8, 393.51)
	event.ObjsAddPas(1, 621.79, 116.64, 341.23)
	event.ObjsAddPas(1, 627.58, 134.46, 326.87)
	event.ObjsStartPas(1)
	helper_75f3e820(32)
	if vm.skipping() then
		return skip(104)
	end
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.ObjsSetPos(4, 416.4, 75.5, 204.13)
	event.ObjsJump(4, 462.7, 152.9, 245.99, -0.3, 30)
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsNextMotion(4, "ジャンプL")
	event.ObjsPosDelay(4, 32)
	event.ObjsJump(4, 558.2, 133.44, 226.12, -0.2, 30)
	event.ObjsRotDelay(4, 72)
	event.ObjsRotation(4, 0.0, 2.77, 0.0, 20)
	event.ObjsMotionDelay(4, 18)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSePlay(4, var0, 29)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 31)
	event.ObjsSeDelay(4, 62)
	event.ObjsSePlay(4, var0, 30)
	helper_75f3e820(70)
	if vm.skipping() then
		return skip(105)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(106)
	end
	return part2()
end

return helper_b9c0b815
