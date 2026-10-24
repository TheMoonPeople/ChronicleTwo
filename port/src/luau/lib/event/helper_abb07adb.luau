--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18b9d874 = require("@lib/event/helper_18b9d874")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_43b6fee5 = require("@lib/event/helper_43b6fee5")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_c2293a20 = require("@lib/event/helper_c2293a20")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_abb07adb(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 52 then
			if at <= 1 then
				helper_2f481f12(4)
			end
			if at <= 2 then
				helper_93bb7fa4(3170010)
			end
			if at <= 3 then
				helper_e8f4b85c(2)
			end
			if at <= 4 then
				helper_2f481f12(30)
			end
			if at <= 5 then
				helper_b027b809()
			end
			if at <= 6 then
				helper_2f481f12(30)
			end
			if at <= 7 then
				helper_e8f4b85c(1)
			end
			if at <= 8 then
				helper_e8f4b85c(0)
			end
			if at <= 9 then
				helper_2f481f12(40)
			end
			if at <= 10 then
				helper_2f481f12(10)
			end
			if at <= 11 then
				helper_2f481f12(38)
			end
			if at <= 12 then
				helper_2f481f12(14)
			end
			if at <= 13 then
				helper_e8f4b85c(1)
			end
			if at <= 14 then
				helper_e8f4b85c(0)
			end
			if at <= 15 then
				helper_e8f4b85c(2)
			end
			if at <= 16 then
				helper_2f481f12(10)
			end
			if at <= 17 then
				helper_e8f4b85c(1)
			end
			if at <= 18 then
				helper_e8f4b85c(0)
			end
			if at <= 19 then
				helper_e8f4b85c(2)
			end
			if at <= 20 then
				helper_93bb7fa4(3170020)
			end
			if at <= 21 then
				helper_e8f4b85c(2)
			end
			if at <= 22 then
				helper_b027b809()
			end
			if at <= 23 then
				helper_93bb7fa4(3170025)
			end
			if at <= 24 then
				helper_e8f4b85c(2)
			end
			if at <= 25 then
				helper_93bb7fa4(3170030)
			end
			if at <= 26 then
				helper_e8f4b85c(1)
			end
			if at <= 27 then
				helper_e8f4b85c(0)
			end
			if at <= 28 then
				helper_93bb7fa4(3170040)
			end
			if at <= 29 then
				helper_93bb7fa4(3170050)
			end
			if at <= 30 then
				helper_b027b809()
			end
			if at <= 31 then
				helper_2f481f12(2)
			end
			if at <= 32 then
				helper_2f481f12(120)
			end
			if at <= 33 then
				helper_18b9d874(363, 1)
			end
			if at <= 34 then
				helper_2f481f12(30)
			end
			if at <= 35 then
				helper_2f481f12(30)
			end
			if at <= 36 then
				helper_93bb7fa4(3170060)
			end
			if at <= 37 then
				helper_e8f4b85c(2)
			end
			if at <= 38 then
				helper_93bb7fa4(3170065)
			end
			if at <= 39 then
				helper_93bb7fa4(3170070)
			end
			if at <= 40 then
				helper_93bb7fa4(3170075)
			end
			if at <= 41 then
				helper_93bb7fa4(3170080)
			end
			if at <= 42 then
				helper_e8f4b85c(2)
			end
			if at <= 43 then
				helper_e8f4b85c(2)
			end
			if at <= 44 then
				helper_93bb7fa4(3170090)
			end
			if at <= 45 then
				helper_e8f4b85c(4)
			end
			if at <= 46 then
				helper_e8f4b85c(0)
			end
			if at <= 47 then
				helper_2f481f12(2)
			end
			if at <= 48 then
				helper_2f481f12(120)
			end
			if at <= 49 then
				helper_18b9d874(arg0, 1)
			end
			if at <= 50 then
				helper_c2293a20(3170100, 90)
			end
			if at <= 51 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(53)
			end
			return part2()
		end
		if at <= 53 then
			helper_43b6fee5(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.StopBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.DelExtMotion(0)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.LoadMes(0, -1)
		helper_43b6fee5(0)
		if vm.skipping() then
			return skip(54)
		end
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(317, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(193)
	event.PlayBgm(1)
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	var2 = event.SndLoadSound(3817) or var2
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e317/")
	event.LoadMes(0, 5, "e317_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e317_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.LoadChara(5, "e317_boss.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(2, 15)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e317_hana.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(3, 16)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetReference(0, "item", 16)
	event.ChangeDir("")
	event.LoadItem(5, arg0, "info", 17)
	event.CharaActive(0, 17)
	event.EohSyncChara(4, 17)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 18)
	event.CharaActive(0, 18)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 13)
		event.LoadEquip(5, 0, 4, "info", 13)
		event.LoadEquip(5, 0, 3, "info", 13)
		event.LoadEquip(5, 0, 2, "info", 13, 14)
		event.LoadMotion(5, "event/e300/e317/e317_mints.gltf", "info", 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 13)
		event.EohSyncChara(0, 13)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/e300/e317/e317_monica.gltf", "info", 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.DelExtMotion(13)
		event.LoadMotion(5, "event/e300/e317/e317_monica.gltf", "info", 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 13)
		event.EohSyncChara(1, 13)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(13)
	event.CharaActive(14)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	event.EohSetPos(0, 10.0, 62.79, 1296.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(1, -10.0, 62.79, 1296.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 1)
	event.EohSetPos(2, -323.0, 73.0, 801.25)
	event.EohSetRot(2, 0.0, 2.88, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetShadow(2, 0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetSoundId(2, var2)
	event.EohSetFrameStatus(2, "hana", 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-270.99, 155.56, 855.04)
	event.CmrsSetRef(-317.48, 77.29, 790.97)
	event.SetFadeIn(30)
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_93bb7fa4(3170010)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var2, 0)
	event.ObjsSetMotion(2, "立ちから飛び", 2)
	event.ObjsNextMotion(2, "飛び", 4)
	event.ObjsPosDelay(2, 30)
	event.ObjsMove2(2, -292.12, 88.0, 718.16, 40, 1, 1.0)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-173.05, 197.62, 491.25)
	event.CmrsSetRef(-157.61, 198.62, 397.99)
	event.ObjsSetPos(2, -257.58, 157.22, 483.43)
	event.ObjsMove(2, -13.74, 178.47, -571.1, 180)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMove2(8.44, 86.91, 1369.12, -11.91, 107.25, 1150.24, 120, 0, 0.2)
	helper_b027b809()
	if vm.skipping() then
		return skip(6)
	end
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-30.54, 63.5, 1250.05)
	event.CmrsSetRef(1.85, 81.24, 1299.33)
	event.SndSePlay(var2, 2)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(9)
	end
	helper_2f481f12(40)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(8.44, 86.91, 1369.12)
	event.CmrsSetRef(-11.91, 107.25, 1150.24)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 140)
	event.ObjsAddPas(2, -99.87, 325.67, -377.78)
	event.ObjsAddPas(2, -86.48, 290.88, -92.22)
	event.ObjsAddPas(2, -74.49, 270.46, 99.58)
	event.ObjsAddPas(2, -80.07, 258.98, 356.49)
	event.ObjsAddPas(2, -108.42, 224.24, 515.31)
	event.ObjsAddPas(2, -190.47, 156.03, 662.8)
	event.ObjsStartPas(2)
	helper_2f481f12(38)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsMove(1, -145.57, 26.27, 1125.27, 100, 1)
	event.ObjsRotation(1, 0.0, -2.54, 0.0, 10)
	event.ObjsSetMotion(1, "走り")
	helper_2f481f12(14)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(0, -115.45, 30.53, 1131.91, 86, 1)
	event.ObjsRotation(0, 0.0, -2.54, 0.0, 10)
	event.ObjsSetMotion(0, "走り")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(14)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(15)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-368.06, 55.78, 1062.51)
	event.CmrsSetRef(-342.12, 43.19, 881.2)
	event.SndSePlay(var2, 3)
	event.ObjsSetMotion(2, "飛びから立ち", 6)
	event.ObjsSetMotionNowTime(2, 40)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetPos(2, -329.15, 98.27, 784.46)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.ObjsMove(2, -334.07, 73.0, 828.92, 30)
	event.ObjsSetPos(1, -323.44, 0.56, 979.56)
	event.ObjsSetRot(1, 0.0, -2.9, 0.0)
	event.ObjsMove(1, -338.5, 0.26, 920.0, 40, 1)
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, -3.02, 0.0, 10)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMotionDelay(1, 1)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetPos(0, -346.15, 0.78, 1002.45)
	event.ObjsSetRot(0, 0.0, 2.9, 0.0)
	event.ObjsMove(0, -355.0, 0.46, 920.0, 40, 1)
	event.ObjsRotDelay(0, 30)
	event.ObjsRotation(0, 0.0, 2.78, 0.0, 10)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 1)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(18)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(19)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsMoveAhd2(0.63, 12.59, 190.82, 120, 0, 0.4)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "会話２", 6, 0.6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_93bb7fa4(3170020)
	if vm.skipping() then
		return skip(21)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(22)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(23)
	end
	event.EohSetFrameStatus(2, "hana", 1)
	event.ObjsSetMotion(2, "頭を下げる", 2)
	event.ObjsNextMotion(2, "頭を下げるL", 4)
	helper_93bb7fa4(3170025)
	if vm.skipping() then
		return skip(24)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(25)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～大口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～おどろき目")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "あーっ！", 6)
	event.ObjsNextMotion(0, "あーっ！L", 4)
	event.ObjsSetMotion(1, "上向き指差し", 6)
	event.ObjsNextMotion(1, "上向き指差しＬ", 4)
	helper_93bb7fa4(3170030)
	if vm.skipping() then
		return skip(26)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(27)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(28)
	end
	helper_93bb7fa4(3170040)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-354.86, 5.98, 980.21)
	event.CmrsSetRef(-340.74, 53.89, 881.38)
	event.CmrsMove2(-312.11, 124.5, 846.08, -346.32, 77.26, 868.46, 30, 0, 1.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3170050)
	if vm.skipping() then
		return skip(30)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(31)
	end
	event.SndPauseBgm()
	event.CharaActive(1, 18)
	event.SetCharaPos(18, -336.95, 92.55, 866.22)
	event.SetCharaRot(18, 0.6, -0.84, 0.0)
	event.SetMotion(18, "発動", 6)
	helper_2f481f12(2)
	if vm.skipping() then
		return skip(32)
	end
	event.SndSePlay(var1, 0)
	helper_2f481f12(120)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var2, 7)
	helper_18b9d874(363, 1)
	if vm.skipping() then
		return skip(34)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(35)
	end
	event.PlayBgm(1)
	event.CharaActive(0, 18)
	event.CmrsSetPos(-265.62, 162.13, 816.12)
	event.CmrsSetRef(-337.34, 74.97, 859.33)
	event.SetFadeIn(30)
	event.EohSetFrameStatus(2, "hana", 0)
	event.CharaActive(1, 16)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "花持ち立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_93bb7fa4(3170060)
	if vm.skipping() then
		return skip(37)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-362.47, 38.8, 1063.3)
	event.CmrsSetRef(-337.46, 47.14, 861.71)
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_93bb7fa4(3170065)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_93bb7fa4(3170070)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3170075)
	if vm.skipping() then
		return skip(41)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_93bb7fa4(3170080)
	if vm.skipping() then
		return skip(42)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(43)
	end
	event.SndSePlay(var2, 4)
	event.ObjsSetMotion(2, "立ちから飛び", 2)
	event.ObjsNextMotion(2, "飛び", 4)
	event.ObjsPosDelay(2, 30)
	event.ObjsMove2(2, -334.07, 133.0, 828.92, 30, 1, 1.0)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(44)
	end
	helper_93bb7fa4(3170090)
	if vm.skipping() then
		return skip(45)
	end
	event.SndSePlay(var2, 5)
	event.CharaActive(17)
	event.ObjsSetPos(4, -334.07, 133.0, 828.92)
	event.ObjsSetRot(4, 0.0, -1.57, 0.0)
	event.ObjsJump(4, -343.64, 25.73, 905.48, -0.2, 30)
	helper_e8f4b85c(4)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-342.47, 55.33, 881.22)
	event.CmrsSetRef(-346.84, 21.58, 917.8)
	event.SndSePlay(var2, 6)
	event.CharaActive(0, 16)
	event.SetReference(0, "ef00", 17)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "クラブゲット", 6)
	event.ObjsNextMotion(0, "クラブゲットL", 4)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(47)
	end
	event.SndPauseBgm()
	event.ObjsSetMotion(2, "飛び", 1)
	event.CharaActive(1, 18)
	event.SetCharaPos(18, -351.31, 30.76, 917.09)
	event.SetCharaRot(18, 0.4, -0.12, 0.0)
	event.SetMotion(18, "発動", 6, -1.0, 1)
	helper_2f481f12(2)
	if vm.skipping() then
		return skip(48)
	end
	event.SndSePlay(var1, 0)
	helper_2f481f12(120)
	if vm.skipping() then
		return skip(49)
	end
	event.SndSePlay(var2, 7)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_18b9d874(arg0, 1)
	if vm.skipping() then
		return skip(50)
	end
	event.PlayBgm(1)
	event.CharaActive(0, 18)
	event.ObjsSetMotion(2, "飛び", 4)
	event.CmrsSetPos(-366.74, 221.09, 968.17)
	event.CmrsSetRef(-335.68, 196.88, 838.07)
	event.SndSePlay(var2, 8)
	event.ObjsSetRot(2, 0.0, 2.86, 0.0)
	event.ObjsMove(2, -211.7, 150.58, 316.36, 120)
	helper_c2293a20(3170100, 90)
	if vm.skipping() then
		return skip(51)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(52)
	end
	return part2()
end

return helper_abb07adb
