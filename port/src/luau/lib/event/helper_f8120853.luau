--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75f3e820 = require("@lib/event/helper_75f3e820")
local helper_9b8126b9 = require("@lib/event/helper_9b8126b9")
local helper_a057a7e5 = require("@lib/event/helper_a057a7e5")
local helper_ae53acce = require("@lib/event/helper_ae53acce")
local helper_ffeb2648 = require("@lib/event/helper_ffeb2648")

--- Helper function.
local function helper_f8120853()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 104 then
			if at <= 2 then
				helper_ffeb2648()
			end
			if at <= 4 then
				helper_ffeb2648()
			end
			if at <= 5 then
				helper_ae53acce(0)
			end
			if at <= 6 then
				helper_ae53acce(0)
			end
			if at <= 7 then
				helper_ae53acce(3)
			end
			if at <= 8 then
				helper_ae53acce(4)
			end
			if at <= 9 then
				helper_ae53acce(5)
			end
			if at <= 10 then
				helper_75f3e820(10)
			end
			if at <= 11 then
				helper_ae53acce(0)
			end
			if at <= 12 then
				helper_75f3e820(5)
			end
			if at <= 13 then
				helper_ae53acce(0)
			end
			if at <= 14 then
				helper_75f3e820(30)
			end
			if at <= 15 then
				helper_75f3e820(15)
			end
			if at <= 16 then
				helper_ae53acce(0)
			end
			if at <= 17 then
				helper_ae53acce(3)
			end
			if at <= 18 then
				helper_ae53acce(4)
			end
			if at <= 19 then
				helper_75f3e820(8)
			end
			if at <= 20 then
				helper_75f3e820(35)
			end
			if at <= 21 then
				helper_ae53acce(0)
			end
			if at <= 22 then
				helper_ae53acce(3)
			end
			if at <= 23 then
				helper_ae53acce(4)
			end
			if at <= 24 then
				helper_ae53acce(0)
			end
			if at <= 25 then
				helper_75f3e820(30)
			end
			if at <= 26 then
				helper_9b8126b9()
			end
			if at <= 27 then
				helper_75f3e820(15)
			end
			if at <= 28 then
				helper_75f3e820(45)
			end
			if at <= 29 then
				helper_75f3e820(30)
			end
			if at <= 30 then
				helper_75f3e820(20)
			end
			if at <= 31 then
				helper_9b8126b9()
			end
			if at <= 32 then
				helper_75f3e820(30)
			end
			if at <= 33 then
				helper_ae53acce(0)
			end
			if at <= 34 then
				helper_9b8126b9()
			end
			if at <= 35 then
				helper_ae53acce(0)
			end
			if at <= 36 then
				helper_ffeb2648()
			end
			if at <= 37 then
				helper_75f3e820(30)
			end
			if at <= 38 then
				helper_ae53acce(0)
			end
			if at <= 39 then
				helper_9b8126b9()
			end
			if at <= 40 then
				helper_a057a7e5(0, 4000, 8, 0, 0, 40)
			end
			if at <= 41 then
				helper_9b8126b9()
			end
			if at <= 42 then
				helper_75f3e820(30)
			end
			if at <= 43 then
				helper_75f3e820(30)
			end
			if at <= 44 then
				helper_75f3e820(30)
			end
			if at <= 45 then
				helper_75f3e820(30)
			end
			if at <= 46 then
				helper_75f3e820(30)
			end
			if at <= 47 then
				helper_75f3e820(26)
			end
			if at <= 48 then
				helper_75f3e820(70)
			end
			if at <= 49 then
				helper_75f3e820(4)
			end
			if at <= 50 then
				helper_75f3e820(20)
			end
			if at <= 51 then
				helper_75f3e820(20)
			end
			if at <= 52 then
				helper_75f3e820(40)
			end
			if at <= 53 then
				helper_ae53acce(0)
			end
			if at <= 54 then
				helper_ae53acce(0)
			end
			if at <= 55 then
				helper_75f3e820(40)
			end
			if at <= 56 then
				helper_ffeb2648()
			end
			if at <= 57 then
				helper_75f3e820(10)
			end
			if at <= 58 then
				helper_ae53acce(0)
			end
			if at <= 59 then
				helper_75f3e820(10)
			end
			if at <= 60 then
				helper_ae53acce(0)
			end
			if at <= 61 then
				helper_75f3e820(10)
			end
			if at <= 62 then
				helper_9b8126b9()
			end
			if at <= 63 then
				helper_ae53acce(0)
			end
			if at <= 64 then
				helper_75f3e820(40)
			end
			if at <= 65 then
				helper_ae53acce(0)
			end
			if at <= 66 then
				helper_75f3e820(20)
			end
			if at <= 67 then
				helper_ffeb2648()
			end
			if at <= 68 then
				helper_75f3e820(60)
			end
			if at <= 69 then
				helper_ae53acce(0)
			end
			if at <= 70 then
				helper_ae53acce(3)
			end
			if at <= 71 then
				helper_ae53acce(0)
			end
			if at <= 72 then
				helper_ae53acce(3)
			end
			if at <= 73 then
				helper_ae53acce(0)
			end
			if at <= 74 then
				helper_75f3e820(22)
			end
			if at <= 75 then
				helper_75f3e820(80)
			end
			if at <= 76 then
				helper_a057a7e5(0, 4010, 8, 0, 0, 60)
			end
			if at <= 77 then
				helper_ae53acce(4)
			end
			if at <= 78 then
				helper_ae53acce(5)
			end
			if at <= 79 then
				helper_ae53acce(3)
			end
			if at <= 80 then
				helper_75f3e820(30)
			end
			if at <= 81 then
				helper_75f3e820(60)
			end
			if at <= 82 then
				helper_a057a7e5(0, 4020, 8, 0, 0, 60)
			end
			if at <= 83 then
				helper_ae53acce(0)
			end
			if at <= 84 then
				helper_75f3e820(10)
			end
			if at <= 85 then
				helper_75f3e820(58)
			end
			if at <= 86 then
				helper_a057a7e5(0, 4030, 8, 0, 0, 30)
			end
			if at <= 87 then
				helper_ae53acce(6)
			end
			if at <= 88 then
				helper_75f3e820(14)
			end
			if at <= 89 then
				helper_75f3e820(10)
			end
			if at <= 90 then
				helper_75f3e820(5)
			end
			if at <= 91 then
				helper_ae53acce(2)
			end
			if at <= 92 then
				helper_ae53acce(0)
			end
			if at <= 93 then
				helper_ae53acce(0)
			end
			if at <= 94 then
				helper_9b8126b9()
			end
			if at <= 95 then
				helper_75f3e820(3)
			end
			if at <= 96 then
				helper_75f3e820(5)
			end
			if at <= 97 then
				helper_ae53acce(0)
			end
			if at <= 98 then
				helper_75f3e820(10)
			end
			if at <= 99 then
				helper_ae53acce(0)
			end
			if at <= 100 then
				helper_ae53acce(0)
			end
			if at <= 101 then
				helper_ae53acce(0)
			end
			if at <= 102 then
				helper_75f3e820(20)
			end
			if at <= 103 then
				helper_9b8126b9()
			end
			if vm.skip_end() then
				return skip(105)
			end
			return part2()
		end
		if at <= 105 then
			helper_75f3e820(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.CharaActive(1, 0)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_75f3e820(6)
		if vm.skipping() then
			return skip(106)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.DeleteChara(17)
	event.DeleteChara(18)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.SetMesWindowMode(0, 7)
	event.LoadBgm(106)
	event.PlayBgm(0)
	event.LoadSeEnv(3)
	event.PlayEnvBgm(0)
	event.InitDramaScene()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1216) or var0
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 548.18, 133.45, -204.55)
	event.ObjsSetRot(0, 0.0, -2.64, 0.0)
	event.ObjsTexAnime(0, 0)
	event.LoadChara(5, "event/opening/p4/buranko.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "待機", 4)
	event.LoadChara(5, "event/opening/p4/light.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetFrameShow(2, "kusari", 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "待機", 4)
	event.SetLoadbgFile("event/opening/p4/p4_pierrot_kihon.gltf")
	if vm.wait() then
		return skip(2)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 728.98, 133.45, 91.56)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 772.23, 133.45, 85.26)
	event.ObjsSetRot(4, 0.0, -2.52, 0.0)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 737.7, 133.45, 178.69)
	event.ObjsSetRot(5, 0.0, -2.52, 0.0)
	event.EohSyncChrobj(7, 10, "light_rot")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsRotation(7, 0.01, 0.0, 0.0, -1)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(14, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko1.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko2.gltf", "info", 16)
	event.CharaActive(16)
	event.SetCharaPos(16, -20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/up_kusari.gltf", "info", 17)
	event.CharaActive(17)
	event.SetReference(10, "up_kusari", 17)
	event.LoadChara(5, "event/opening/p4/shuchusen.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(6, 20)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.AssignStack(6)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints1.gltf", "info", 0)
	event.SetLoadbgFile("event/opening/p4/p4_pierrot1.gltf")
	if vm.wait() then
		return skip(4)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(5)
	end
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 13)
	event.SetLoadbgFile("event/opening/p4/p4_mints2.gltf", "event/opening/p4/p4_pierrot2.gltf")
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsNextMotion(0, "おっとっと", 6)
	event.ObjsMotionWait(0)
	event.ObjsMove(0, 452.01, 133.45, -365.64, 50)
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsMove(3, 464.87, 133.45, -344.58, 125)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 6.0)
	event.ObjsMove(4, 486.28, 133.45, -397.17, 160)
	event.ObjsSetMotion(5, "走り", 4)
	event.ObjsSetMotionNowTime(5, 12.0)
	event.ObjsMove(5, 428.16, 133.45, -335.04, 180)
	event.CmrsInit()
	event.CmrsSetPos(547.06, 213.33, -103.4)
	event.CmrsSetRef(534.68, 170.7, -203.08)
	event.CmrsMove(537.57, 209.13, -119.23, 500.76, 170.7, -269.77, 45)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(426.81, 155.31, -411.47)
	event.CmrsSetRef(456.18, 150.65, -363.99)
	event.ObjsTexAnime(0, 1, "驚き（１）")
	event.ObjsTexAnime(0, 1, "大きな口（１）")
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "だっしゅ！！（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(283.78, 126.6, -281.55)
	event.CmrsSetRef(445.98, 163.55, -447.12)
	event.ObjsSetPos(0, 34.0, 0.0, -42.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "飛ぶ", 6)
	event.ObjsNextMotion(0, "ぶらさがりL", 4)
	event.ObjsSePlay(0, var0, 8)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 9)
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(3, "落ちる", 6)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 10)
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(4, "立ち")
	helper_ae53acce(5)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(5, "立ち")
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(312.69, 142.84, -492.3)
	event.CmrsSetRef(387.96, 148.13, -434.53)
	event.ObjsSetPos(0, 373.67, 133.45, -445.03)
	event.ObjsSetRot(0, 0.0, -2.28, 0.0)
	event.ObjsSetMotion(0, "よじのぼり", 6)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	event.ObjsSePlay(0, var0, 11)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 342.75, 133.45, -468.75, 15)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 164.0, -140.0)
	event.CmrsSetRef(10.0, 164.0, -352.47)
	event.CmrsMove(0.0, 164.0, -140.0, -10.0, 164.0, -352.47, 155)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 110)
	event.ObjsAddPas(0, 216.54, 133.45, -548.56)
	event.ObjsAddPas(0, 182.72, 133.45, -564.69)
	event.ObjsAddPas(0, -0.73, 133.45, -590.33)
	event.ObjsAddPas(0, -190.24, 133.45, -560.44)
	event.ObjsAddPas(0, -232.51, 133.45, -532.93)
	event.ObjsStartPas(0)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 110)
	event.ObjsAddPas(3, 235.84, 133.45, -501.84)
	event.ObjsAddPas(3, 174.96, 133.45, -531.08)
	event.ObjsAddPas(3, 10.05, 133.45, -560.78)
	event.ObjsAddPas(3, -179.09, 133.45, -536.68)
	event.ObjsAddPas(3, -227.25, 133.45, -513.05)
	event.ObjsStartPas(3)
	helper_75f3e820(15)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 12.0)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 110)
	event.ObjsAddPas(4, 248.7, 135.36, -572.26)
	event.ObjsAddPas(4, 200.97, 135.36, -594.75)
	event.ObjsAddPas(4, 19.57, 135.36, -627.45)
	event.ObjsAddPas(4, -183.63, 135.36, -599.12)
	event.ObjsAddPas(4, -243.31, 135.36, -569.25)
	event.ObjsStartPas(4)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(17)
	end
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(18)
	end
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-76.14, 200.79, -552.98)
	event.CmrsSetRef(-244.03, 164.0, -536.48)
	event.CmrsMove(-86.73, 200.79, -548.01, -281.45, 164.0, -521.18, 43)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -77.37, 133.45, -569.47)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, -108.56, 133.45, -613.85)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, -207.41, 133.45, -545.84)
	event.ObjsAddPas(0, -362.81, 133.45, -457.15)
	event.ObjsAddPas(0, -455.6, 133.45, -366.11)
	event.ObjsAddPas(0, -496.87, 133.45, -294.54)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "飛ぶ2", 6)
	event.ObjsNextMotion(0, "走り", 4)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 12)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 120)
	event.ObjsAddPas(3, -77.37, 133.45, -569.47)
	event.ObjsAddPas(3, -204.83, 133.45, -519.56)
	event.ObjsAddPas(3, -351.11, 133.45, -436.61)
	event.ObjsAddPas(3, -436.92, 133.45, -351.79)
	event.ObjsAddPas(3, -474.71, 133.45, -285.13)
	event.ObjsStartPas(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsMotionWait(3)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsMotionWait(3)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsNextMotion(3, "飛ぶ", 6)
	event.ObjsNextMotion(3, "走り", 4)
	event.ObjsSeDelay(3, 72)
	event.ObjsSePlay(3, var0, 12)
	helper_75f3e820(8)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 120)
	event.ObjsAddPas(4, -108.56, 133.45, -613.85)
	event.ObjsAddPas(4, -245.28, 133.45, -564.91)
	event.ObjsAddPas(4, -378.72, 133.45, -485.4)
	event.ObjsAddPas(4, -481.13, 133.45, -385.99)
	event.ObjsAddPas(4, -521.02, 133.45, -316.93)
	event.ObjsStartPas(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsNextMotion(4, "飛ぶ", 6)
	event.ObjsNextMotion(4, "走り", 4)
	event.ObjsSeDelay(4, 72)
	event.ObjsSePlay(4, var0, 12)
	helper_75f3e820(35)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(-253.07, 137.49, -256.64)
	event.CmrsSetRef(-383.77, 149.38, -384.26)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(22)
	end
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(23)
	end
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "立ち", 4)
	event.CmrsSetPos(-624.63, 203.17, -154.88)
	event.CmrsSetRef(-576.54, 149.38, 113.64)
	event.ObjsSetPos(0, -583.25, 133.45, -101.95)
	event.ObjsSetRot(0, 0.0, 0.07, 0.0)
	event.ObjsMove(0, -577.83, 133.45, 14.04, 30)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsSetMotionNowTime(0, 10.0)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsNextMotion(0, "ストップ", 6)
	event.ObjsNextMotion(0, "ストップL", 6)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "出現", 6)
	event.ObjsNextMotion(5, "出現L", 4)
	event.ObjsSePlay(5, var0, 13)
	event.ObjsSeDelay(5, 50)
	event.ObjsSePlay(5, var0, 14)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-564.24, 148.01, 41.12)
	event.CmrsSetRef(-579.7, 154.29, 16.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "口パク小")
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-567.19, 160.39, 76.35)
	event.CmrsSetRef(-562.84, 160.91, 93.75)
	event.CmrsMove(-570.96, 160.39, 77.29, -566.61, 160.91, 94.69, 45)
	event.ObjsSetMotion(5, "かまえ立ち", 4, 0.05)
	event.ObjsSetPos(5, -570.67, 133.45, 93.71)
	event.ObjsSetRot(5, 0.0, -2.88, 0.0)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(27)
	end
	helper_75f3e820(15)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-476.38, 153.26, 55.85)
	event.CmrsSetRef(-580.21, 159.97, 82.18)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "vsピエロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "vsピエロ（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 15)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 16)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "vsピエロ", 6)
	helper_75f3e820(45)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-552.26, 154.78, 179.33)
	event.CmrsSetRef(-572.64, 133.7, 67.83)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "あ！！（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 130)
	event.ObjsAddPas(3, -505.19, 133.45, -266.75)
	event.ObjsAddPas(3, -525.23, 133.45, -172.98)
	event.ObjsAddPas(3, -544.18, 133.45, -7.69)
	event.ObjsAddPas(3, -510.83, 133.45, 98.05)
	event.ObjsStartPas(3)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 12.0)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 150)
	event.ObjsAddPas(4, -521.02, 133.45, -316.93)
	event.ObjsAddPas(4, -550.86, 133.45, -178.43)
	event.ObjsAddPas(4, -548.36, 133.45, -1.85)
	event.ObjsAddPas(4, -527.93, 133.45, 69.26)
	event.ObjsStartPas(4)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsMove(-574.0, 156.97, 179.02, -487.34, 166.42, 108.67, 60)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(31)
	end
	helper_9b8126b9()
	if vm.skipping() then
		return skip(32)
	end
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(4, "立ち")
	event.CmrsSetPos(-524.03, 172.04, -43.4)
	event.CmrsSetRef(-445.68, 174.18, 59.09)
	event.CmrsMove(-524.03, 172.04, -43.4, -415.83, 184.9, 28.66, 60)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(34)
	end
	helper_9b8126b9()
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(-403.56, 235.67, 109.42)
	event.CmrsSetRef(-352.18, 211.03, 18.75)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ブランコ前（１）")
	event.ObjsTexAnime(0, 1, "口パク横大（１）")
	event.ObjsSetPos(0, -374.25, 184.32, 26.34)
	event.ObjsSetRot(0, 0.0, 2.0, 0.0)
	event.ObjsMove(0, -328.72, 184.32, 6.44, 18)
	event.ObjsSetMotion(0, "走り2", 6)
	event.ObjsNextMotion(0, "後ろを見る", 2)
	event.ObjsMotionWait(0)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(0, "後ろを見るL", 4)
	helper_ffeb2648()
	if vm.skipping() then
		return skip(37)
	end
	event.DelExtMotion(0)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints2.gltf", "info", 0)
	event.DelExtMotion(11)
	event.DelExtMotion(12)
	event.DelExtMotion(13)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 13)
	event.SetLoadbgFile("event/opening/p4/p4_mints3.gltf", "event/opening/p4/p4_pierrot3.gltf")
	event.CmrsSetPos(-341.49, 223.49, -20.69)
	event.CmrsSetRef(-385.73, 190.51, 33.94)
	event.ObjsSetPos(3, -402.0, 159.7, 49.66)
	event.ObjsSetRot(3, 0.0, 2.14, 0.0)
	event.ObjsSetMotion(3, "立ち上がり", 6)
	event.ObjsSetPos(4, -482.22, 134.65, 113.65)
	event.ObjsSetRot(4, 0.0, 2.14, 0.0)
	event.ObjsMove(4, -445.32, 147.11, 83.57, 30)
	event.ObjsSetMotion(4, "綱渡り", 4)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-403.56, 235.67, 109.42)
	event.CmrsSetRef(-352.18, 211.03, 18.75)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "ブランコを取る", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(1, "ブランコを取る", 6)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(-267.74, 231.08, 97.99)
	event.CmrsSetRef(-305.0, 211.03, 3.73)
	event.ObjsSePlay(0, var0, 17)
	event.ObjsSetMotion(0, "空中ブランコ", 6)
	event.ObjsSetMotion(1, "空中ブランコ", 6)
	event.CmrsMove(-86.05, 232.08, 330.06, -180.81, 158.06, -26.95, 60)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSePlay(0, var0, 28)
	event.ObjsSetPos(3, 0.0, -1000.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "かまえ立ち", 4)
	event.ObjsSetPos(4, 0.0, -1000.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "かまえ立ち", 4)
	event.ObjsSetMotionNowTime(0, 16.0)
	event.ObjsSetMotionNowTime(1, 16.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	event.CmrsAhddelay(40)
	event.CmrsReleaseObj()
	helper_a057a7e5(0, 4000, 8, 0, 0, 40)
	if vm.skipping() then
		return skip(41)
	end
	helper_9b8126b9()
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetPos(3, -309.76, 184.62, 0.22)
	event.ObjsSetRot(3, 0.0, 0.96, 0.0)
	event.ObjsSetPos(4, -321.11, 184.32, -16.48)
	event.ObjsSetRot(4, 0.0, 0.54, 0.0)
	event.ObjsSetMotionNowTime(0, 68.0)
	event.ObjsSetMotionNowTime(1, 68.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中２（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsReleaseObj()
	event.ObjsSetMotionNowTime(0, 64.0)
	event.ObjsSetMotionNowTime(1, 64.0)
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotionNowTime(0, 78.4)
	event.ObjsSetMotionNowTime(1, 78.4)
	event.CmrsSetPos(-341.79, 268.45, 142.52)
	event.CmrsSetRef(-275.52, 194.52, 6.09)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotionNowTime(0, 80.0)
	event.ObjsSetMotionNowTime(1, 80.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "戻るー！！（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 5.0, 1.5, 0.0, 30.0, "bcol00", 1)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsReleaseObj()
	event.ObjsSetMotionNowTime(0, 102.4)
	event.ObjsSetMotionNowTime(1, 102.4)
	event.CmrsSetPos(-220.35, 212.87, 157.52)
	event.CmrsSetRef(-306.54, 193.56, -8.65)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "蹴飛ばされる", 6)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 18)
	helper_75f3e820(26)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "捕まえ失敗", 6)
	helper_75f3e820(70)
	if vm.skipping() then
		return skip(49)
	end
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	helper_75f3e820(4)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSePlay(0, var0, 19)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSePlay(0, var0, 20)
	event.ObjsSePlay(0, var0, 28)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotionNowTime(0, 208.0)
	event.ObjsSetMotionNowTime(1, 208.0)
	event.ObjsMotionWait(1)
	event.ObjsSetMotion(1, "たれさがり")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中（２）")
	event.ObjsTexAnime(0, 1, "怒り口（２）")
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "怒り口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	helper_75f3e820(40)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(163.49, 140.77, 131.57)
	event.CmrsSetRef(270.66, 194.2, -19.59)
	event.ObjsMotionWait(0)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 21)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(54)
	end
	event.CmrsSetPos(447.58, 266.17, -85.27)
	event.CmrsSetRef(357.43, 185.48, 3.08)
	event.ObjsSetPos(0, 349.03, 184.32, 4.08)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "立ち上がる", 6)
	event.ObjsNextMotion(0, "キョロキョロ立ち", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "口パク小")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsSetPos(452.54, 255.33, -129.4)
	event.CmrsSetRef(388.48, 192.54, 28.93)
	event.ObjsRotation(0, 0.0, 0.85, 0.0, 6)
	event.ObjsSetMotion(0, "かまえ立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "気づく（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CharaActive(11)
	event.CharaActive(12)
	event.ObjsSetPos(3, 442.04, 148.45, 80.27)
	event.ObjsSetRot(3, 0.0, -2.28, 0.0)
	event.ObjsMove(3, 422.02, 155.31, 63.91, 40)
	event.ObjsSetMotion(3, "綱渡り", 4)
	event.ObjsSetMotionNowTime(3, 3.5)
	event.ObjsSetPos(4, 472.84, 137.68, 106.72)
	event.ObjsSetRot(4, 0.0, -2.28, 0.0)
	event.ObjsMove(4, 454.19, 144.23, 90.87, 40)
	event.ObjsSetMotion(4, "綱渡り", 4)
	helper_75f3e820(40)
	if vm.skipping() then
		return skip(56)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(57)
	end
	event.DelExtMotion(0)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints3.gltf", "info", 0)
	event.ObjsSetMotion(0, "キョロキョロ立ち", 5)
	event.CmrsSetPos(373.64, 213.67, 15.39)
	event.CmrsSetRef(347.99, 207.28, 2.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	event.ObjsTexaDelay(0, 57)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "見上げる（２）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "キョロキョロ立ち", 6)
	event.ObjsNextMotion(0, "上を見る", 6)
	event.ObjsNextMotion(0, "上を見るL", 4)
	event.DelExtMotion(11)
	event.DelExtMotion(12)
	event.DelExtMotion(13)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 13)
	event.SetLoadbgFile("event/opening/p4/p4_kusari.gltf", "event/opening/p4/p4_kemuri.gltf")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(59)
	end
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsSetPos(452.33, 233.67, -60.78)
	event.CmrsSetRef(343.67, 205.51, -9.42)
	event.EohSetShadow(0, 0)
	event.ObjsSetPos(0, 358.46, 184.32, -6.15)
	event.ObjsSetRot(0, 0.0, -2.87, 0.0)
	event.ObjsSetMotion(0, "柱･しがみつき", 6)
	event.ObjsMotionWait(0)
	event.ObjsSePlay(0, var0, 22)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsSetPos(3, 397.41, 184.32, 30.99)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.ObjsMove(3, 370.41, 184.32, -8.43, 35)
	event.ObjsSetMotion(3, "歩き", 6)
	event.ObjsNextMotion(3, "上を見る", 6)
	event.ObjsNextMotion(3, "上を見るL", 4)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsMove(0, 358.46, 380.32, -6.15, 200)
	event.ObjsSetMotion(0, "柱･登り", 4)
	event.CmrsMove(452.33, 233.67, -60.78, 343.67, 351.26, -9.42, 160)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(63)
	end
	event.CmrsSetPos(436.58, 475.72, -3.59)
	event.CmrsSetRef(343.67, 410.45, -9.42)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetPos(0, 358.46, 370.64, -6.15)
	event.ObjsSetMotion(0, "柱･棒に立つ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_75f3e820(40)
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsSetPos(367.47, 421.1, 17.39)
	event.CmrsSetRef(340.3, 420.48, -31.37)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSetMotion(0, "下見立ち", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣下見")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(67)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(68)
	end
	event.AssignStack(7)
	event.ClearStack(7)
	event.LoadChara(7, "event/opening/p4/p4_kusari.gltf", "info", 18)
	event.CharaActive(0, 18)
	event.EohSyncChara(10, 18)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 0.0, 448.0, 105.0)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(7, "event/opening/p4/p4_kemuri.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.SetCharaPos(19, 0.0, 23.09, 23.0)
	event.CmrsSetPos(439.18, 421.1, 162.79)
	event.CmrsSetRef(340.3, 366.23, -31.37)
	event.ObjsSetPos(3, 354.39, 291.6, -24.56)
	event.ObjsSetRot(3, 0.0, -2.76, 0.0)
	event.ObjsSetMotion(3, "柱･登り", 4)
	event.ObjsMove(3, 354.39, 321.6, -24.56, 60)
	event.ObjsSetPos(4, 360.04, 254.11, -32.06)
	event.ObjsSetRot(4, 0.0, -1.49, 0.0)
	event.ObjsSetMotion(4, "柱･登り", 4)
	event.ObjsMove(4, 360.04, 284.11, -32.06, 60)
	helper_75f3e820(60)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsSetPos(367.47, 421.1, 17.39)
	event.CmrsSetRef(340.3, 420.48, -31.37)
	event.ObjsSetMotion(0, "棒の先を見る", 6)
	event.ObjsNextMotion(0, "踏み出す", 6, 0.1)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "○７（３）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(70)
	end
	event.CmrsSetPos(132.73, 389.48, 276.32)
	event.CmrsSetRef(306.5, 389.69, -17.39)
	event.CmrsMove(132.73, 389.48, 276.32, -0.73, 353.3, -17.15, 210)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsSetPos(0, 309.1, 392.52, -23.46)
	event.ObjsSetRot(0, 0.0, -1.43, 0.0)
	event.ObjsSetMotion(0, "綱渡り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "綱渡り", 6)
	event.ObjsNextMotion(0, "綱走り")
	event.ObjsMove(0, 274.31, 373.41, -16.87, 80)
	event.ObjsMove(0, 183.47, 333.23, 0.0, 50)
	event.ObjsMove(0, 9.21, 327.28, 0.0, 80)
	event.ObjsRotDelay(0, 140)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 6)
	event.ObjsSetPos(3, 354.39, 373.19, -24.56)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.ObjsSetMotion(3, "柱･登り", 4)
	event.ObjsMove(3, 354.39, 403.19, -24.56, 60)
	event.ObjsSetPos(4, 360.04, 327.61, -32.06)
	event.ObjsSetRot(4, 0.0, -1.49, 0.0)
	event.ObjsSetMotion(4, "柱･登り", 4)
	event.ObjsMove(4, 360.04, 387.61, -32.06, 90)
	event.CharaActive(13)
	event.ObjsSetPos(5, 347.62, 292.91, -38.69)
	event.ObjsSetRot(5, 0.0, 0.65, 0.0)
	event.ObjsSetMotion(5, "柱･登り", 4)
	event.ObjsMove(5, 347.62, 352.91, -38.69, 90)
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(3, "柱･棒に立つ", 6)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(-215.21, 383.68, 0.36)
	event.CmrsSetRef(4.09, 338.95, -1.2)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "ぐらぐら", 6)
	event.ObjsNextMotion(0, "ぐらぐらL", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "ぐらぐらL", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetPos(3, 142.97, 331.31, 0.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "綱渡り", 4, 0.35)
	event.ObjsSetMotionNowTime(5, 3.5)
	event.ObjsMove(3, 60.0, 328.26, 0.0, 80)
	event.ObjsMove(3, 40.0, 328.26, 0.0, 20)
	event.ObjsSetPos(4, 212.27, 343.23, -5.15)
	event.ObjsSetRot(4, 0.0, -1.45, 0.0)
	event.ObjsSetMotion(4, "綱渡り", 6, 0.35)
	event.ObjsSetMotionNowTime(4, 7.0)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsNextMotion(4, "棒の上立ち", 6)
	event.ObjsNextMotion(4, "棒の上立ちL", 4)
	event.ObjsMove(4, 183.0, 332.22, 0.0, 30)
	event.ObjsMove(4, -23.0, 328.47, 0.0, 134)
	event.ObjsRotDelay(4, 30)
	event.ObjsRotation(4, 0.0, -1.57, 0.0, 6)
	event.ObjsSetPos(5, 260.46, 368.14, -15.47)
	event.ObjsSetRot(5, 0.0, -1.45, 0.0)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsNextMotion(5, "棒の上立ち", 6)
	event.ObjsNextMotion(5, "棒の上立ちL", 4)
	event.ObjsMove(5, 183.0, 332.22, 0.0, 84)
	event.ObjsMove(5, 0.0, 328.22, 0.0, 100)
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(73)
	end
	event.ObjsSetMotion(3, "飛びつき", 6)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsSetMotion(0, "ライトに飛ぶ", 6)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSetMotion(2, "ライトに飛ぶ", 6)
	event.ObjsNextMotion(2, "まわる", 4)
	helper_75f3e820(22)
	if vm.skipping() then
		return skip(75)
	end
	event.EohSetMotion(0, "ライトに飛ぶL", 4)
	event.SetReference(10, "mints", 0)
	event.ObjsSePlay(2, var0, 25)
	event.ObjsSeDelay(2, 134)
	event.ObjsSePlay(2, var0, 25)
	helper_75f3e820(80)
	if vm.skipping() then
		return skip(76)
	end
	event.CmrsSetPos(-189.64, 319.88, 278.88)
	event.CmrsSetRef(23.52, 338.95, 28.18)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -23.05, 328.26, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "棒の上立ち(正面）L", 4, 0.02)
	event.ObjsSetMotionNowTime(3, 1.4)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 7.4, 327.14, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "棒の上立ち(正面）L", 4, 0.02)
	event.ObjsSetMotionNowTime(4, 2.6000001)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 38.44, 327.39, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "棒の上立ち(正面）L", 4)
	event.ObjsPosDelay(4, 100)
	event.ObjsMotionDelay(4, 100)
	event.ObjsSetMotion(4, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(4, 10)
	event.ObjsJump(4, 13.2, 315.39, 40.3, -0.4, 14)
	event.ObjsPosDelay(5, 105)
	event.ObjsMotionDelay(5, 105)
	event.ObjsRotDelay(5, 105)
	event.ObjsSetMotion(5, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(5, 10)
	event.ObjsRotDelay(5, 10)
	event.ObjsJump(5, 28.98, 312.19, 49.95, -0.4, 14)
	event.ObjsRotation(5, 0.0, -0.84, 0.0, 14)
	event.ObjsPosDelay(3, 109)
	event.ObjsMotionDelay(3, 109)
	event.ObjsRotDelay(3, 109)
	event.ObjsSetMotion(3, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(3, 10)
	event.ObjsRotDelay(3, 10)
	event.ObjsJump(3, -25.86, 311.84, 49.12, -0.4, 14)
	event.ObjsRotation(3, 0.0, 0.84, 0.0, 14)
	helper_a057a7e5(0, 4010, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(77)
	end
	event.CmrsPrdelay(30)
	event.CmrsSetPos(-208.72, 388.6, 84.96)
	event.CmrsSetRef(2.62, 320.22, 24.49)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(1.55, 445.57, 288.5)
	event.CmrsSetRef(-0.46, 280.6, 24.97)
	helper_ae53acce(4)
	if vm.skipping() then
		return skip(78)
	end
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "つかまりL", 4)
	event.SetReference(10, "pierrot2", 12)
	helper_ae53acce(5)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "つかまりL", 4)
	event.SetReference(10, "pierrot3", 13)
	helper_ae53acce(3)
	if vm.skipping() then
		return skip(80)
	end
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "つかまりL", 4)
	event.SetReference(10, "pierrot1", 11)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(81)
	end
	event.CmrsSetPos(16.78, 341.72, 53.54)
	event.CmrsSetRef(0.31, 383.37, 104.98)
	event.CharaActive(18)
	event.CharaActive(0, 17)
	event.ObjsSetPos(2, 0.0, -1000.0, 0.0)
	event.EohSetFrameShow(2, "kusari", 0)
	event.ObjsSetMotion(10, "ちぎれそう", 6)
	event.ObjsSetMotionNowTime(10, 3.0)
	event.SndSePlay(var0, 32)
	helper_75f3e820(60)
	if vm.skipping() then
		return skip(82)
	end
	event.EohSetFrameShow(2, "kusari", 1)
	event.CharaActive(17)
	event.CharaActive(0, 18)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, -0.4, 20.0, 20.0, "bcol00", 2)
	event.ObjsSetMotion(0, "見上げる", 2)
	event.ObjsNextMotion(0, "見上げるL", 4)
	event.ObjsTexaDelay(0, 15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	helper_a057a7e5(0, 4020, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(83)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(84)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(16.78, 341.72, 53.54)
	event.CmrsSetRef(0.31, 383.37, 104.98)
	event.ObjsSetPos(2, 0.0, -1000.0, 0.0)
	event.EohSetFrameShow(2, "kusari", 0)
	event.CharaActive(0, 17)
	event.CharaActive(18)
	event.ObjsSetMotion(10, "ちぎれそう待機", 6)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(85)
	end
	event.ObjsSetMotion(10, "ちぎれる", 6)
	event.ObjsSeDelay(10, 4)
	event.ObjsSePlay(10, var0, 26)
	helper_75f3e820(58)
	if vm.skipping() then
		return skip(86)
	end
	event.CharaActive(0, 18)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.CmrsSyncObj(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
	event.ObjsMotionDelay(6, 30)
	event.SndSePlay(var0, 33)
	event.CmrsCharaAttach(20, 60.0, 30)
	event.CharaActive(20)
	event.CharaActive(17)
	event.ObjsSetMotion(2, "落下", 6, 0.3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	helper_a057a7e5(0, 4030, 8, 0, 0, 30)
	if vm.skipping() then
		return skip(87)
	end
	helper_ae53acce(6)
	if vm.skipping() then
		return skip(88)
	end
	event.CmrsReleaseObj()
	event.CharaActive(0, 20)
	event.CmrsSetPos(0.0, 18.46, -95.54)
	event.CmrsSetRef(0.0, 194.33, 107.78)
	event.CmrsMove(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
	event.CharaActive(0, 17)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "落下", 6, 0.3)
	event.ObjsNextMotion(2, "停止", 4)
	event.ObjsSePlay(2, var0, 27)
	event.EohSetShadow(0, 1)
	helper_75f3e820(14)
	if vm.skipping() then
		return skip(89)
	end
	event.ObjsSetMotion(0, "飛び降りる", 2)
	event.ObjsNextMotion(0, "飛び降りるL", 6, 0.2)
	event.ObjsNextMotion(0, "着地", 6)
	event.ObjsMotionWait(0)
	event.ObjsMotionDelay(0, 10)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(90)
	end
	event.DelReference(0)
	event.ObjsSetPos(0, 0.0, 65.81, 94.16)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsJump(0, 0.0, 10.6, 6.0, -0.2, 30)
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(91)
	end
	event.CharaActive(19)
	event.SetMotion(19, "けむり", 6)
	helper_ae53acce(2)
	if vm.skipping() then
		return skip(92)
	end
	event.StopBgm(0)
	event.ObjsInit(7)
	event.DelReference(11)
	event.ObjsSetPos(3, -11.72, 150.0, 41.97)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.DelReference(12)
	event.ObjsSetPos(4, -46.57, 150.0, 23.97)
	event.ObjsSetRot(4, 0.0, 3.14, 0.0)
	event.DelReference(13)
	event.ObjsSetPos(5, 40.14, 150.0, 31.42)
	event.ObjsSetRot(5, 0.0, 3.14, 0.0)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(93)
	end
	event.CmrsSetPos(1.17, 26.95, -26.03)
	event.CmrsSetRef(1.17, 33.68, 4.49)
	event.ObjsSetMotion(0, "舞台上キョロキョロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "開きからにこり")
	event.ObjsSePlay(0, var0, 28)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(94)
	end
	event.CmrsSetRef(0.0, 33.68, 4.49)
	event.CmrsSetAhd(0.9, 9.0, 50.0)
	event.CmrsMoveAhd(-0.9, 9.0, 50.0, 180)
	event.ObjsSetMotion(0, "手を振る", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "手を振る", 6)
	event.ObjsNextMotion(0, "ピエロを見る", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "感動（３）")
	event.ObjsTexAnime(0, 1, "うれし口（３）")
	event.ObjsTexaDelay(0, 224)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ピエロに気づく（３）")
	event.ObjsTexAnime(0, 1, "大口")
	helper_9b8126b9()
	if vm.skipping() then
		return skip(95)
	end
	event.CmrsSetPos(0.58, 36.11, -34.49)
	event.CmrsSetRef(0.57, 34.06, 5.95)
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -11.72, 8.8, 41.97, -0.2, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 29)
	helper_75f3e820(3)
	if vm.skipping() then
		return skip(96)
	end
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, -46.57, 8.8, 23.97, -0.2, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 29)
	helper_75f3e820(5)
	if vm.skipping() then
		return skip(97)
	end
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, 40.14, 8.8, 31.42, -0.2, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 29)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(98)
	end
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(99)
	end
	event.CmrsSetPos(0.0, 38.54, -121.38)
	event.CmrsSetRef(1.17, 33.68, 5.24)
	event.ObjsSetMotion(0, "走り出し", 6)
	event.ObjsNextMotion(0, "走り", 4)
	event.ObjsPosDelay(0, 8)
	event.ObjsMove(0, 0.0, 10.6, -104.0, 30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "大口")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(100)
	end
	event.CmrsSetPos(0.0, 41.13, -104.26)
	event.CmrsSetRef(0.0, 20.2, -217.19)
	event.ObjsSetPos(0, 0.0, 0.0, -200.0)
	event.ObjsMove(0, 0.0, 0.0, -350.0, 30)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(101)
	end
	event.CmrsSetPos(-60.96, 9.43, -525.19)
	event.CmrsSetRef(0.0, 28.11, -410.09)
	event.CmrsMove(-60.96, 9.43, -525.19, 0.0, 28.11, -451.39, 35)
	event.ObjsSetMotion(0, "客を飛び超える", 6)
	event.ObjsMove(0, 0.0, 0.0, -470.0, 35)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 30)
	event.SetMotion(15, "振り向き", 2)
	event.SetMotion(16, "振り向き", 2)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(102)
	end
	event.CmrsSetPos(-107.5, 71.31, -471.79)
	event.CmrsSetRef(21.82, 28.11, -671.17)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetPos(0, -40.33, 0.0, -525.86)
	event.ObjsSetRot(0, 0.0, 2.7, 0.0)
	event.ObjsMove(0, 29.23, 5.07, -691.14, 50)
	helper_75f3e820(20)
	if vm.skipping() then
		return skip(103)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(104)
	end
	return part2()
end

return helper_f8120853
