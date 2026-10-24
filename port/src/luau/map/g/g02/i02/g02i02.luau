--!strict
-- map/g/g02/i02/g02i02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_025d5797 = require("@lib/event/helper_025d5797")
local helper_09fd1f10 = require("@lib/event/helper_09fd1f10")
local helper_1e9c998a = require("@lib/event/helper_1e9c998a")
local helper_29a88422 = require("@lib/event/helper_29a88422")
local helper_2d88bb14 = require("@lib/event/helper_2d88bb14")
local helper_3a74ecc4 = require("@lib/event/helper_3a74ecc4")
local helper_4be4f575 = require("@lib/event/helper_4be4f575")
local helper_56b874f1 = require("@lib/event/helper_56b874f1")
local helper_6dfa44e2 = require("@lib/event/helper_6dfa44e2")
local helper_71fa1d07 = require("@lib/event/helper_71fa1d07")
local helper_7a5e82c7 = require("@lib/event/helper_7a5e82c7")
local helper_91637685 = require("@lib/event/helper_91637685")
local helper_b681f72a = require("@lib/event/helper_b681f72a")
local helper_d9c15850 = require("@lib/event/helper_d9c15850")

--- Helper function.
local function helper_f5bc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 61 then
			if at <= 1 then
				helper_6dfa44e2(30)
			end
			if at <= 2 then
				helper_6dfa44e2(30)
			end
			if at <= 3 then
				helper_6dfa44e2(40)
			end
			if at <= 4 then
				helper_4be4f575(3040010)
			end
			if at <= 5 then
				helper_d9c15850(2)
			end
			if at <= 6 then
				helper_d9c15850(2)
			end
			if at <= 7 then
				helper_4be4f575(3040015)
			end
			if at <= 8 then
				helper_4be4f575(3040020)
			end
			if at <= 9 then
				helper_4be4f575(3040030)
			end
			if at <= 10 then
				helper_6dfa44e2(60)
			end
			if at <= 11 then
				helper_d9c15850(2)
			end
			if at <= 12 then
				helper_6dfa44e2(60)
			end
			if at <= 13 then
				helper_d9c15850(2)
			end
			if at <= 14 then
				helper_4be4f575(3040040)
			end
			if at <= 15 then
				helper_4be4f575(3040050)
			end
			if at <= 16 then
				helper_4be4f575(3040055)
			end
			if at <= 17 then
				helper_d9c15850(1)
			end
			if at <= 18 then
				helper_4be4f575(3040060)
			end
			if at <= 19 then
				helper_4be4f575(3040070)
			end
			if at <= 20 then
				helper_d9c15850(2)
			end
			if at <= 21 then
				helper_4be4f575(3040080)
			end
			if at <= 22 then
				helper_4be4f575(3040090)
			end
			if at <= 23 then
				helper_d9c15850(0)
			end
			if at <= 24 then
				helper_4be4f575(3040100)
			end
			if at <= 25 then
				helper_d9c15850(1)
			end
			if at <= 26 then
				helper_4be4f575(3040105)
			end
			if at <= 27 then
				helper_d9c15850(0)
			end
			if at <= 28 then
				helper_d9c15850(1)
			end
			if at <= 29 then
				helper_6dfa44e2(20)
			end
			if at <= 30 then
				helper_4be4f575(3040110)
			end
			if at <= 31 then
				helper_d9c15850(1)
			end
			if at <= 32 then
				helper_4be4f575(3040120)
			end
			if at <= 33 then
				helper_71fa1d07()
			end
			if at <= 34 then
				helper_4be4f575(3040130)
			end
			if at <= 35 then
				helper_d9c15850(2)
			end
			if at <= 36 then
				helper_d9c15850(1)
			end
			if at <= 37 then
				helper_4be4f575(3040140)
			end
			if at <= 38 then
				helper_4be4f575(3040150)
			end
			if at <= 39 then
				helper_4be4f575(3040160)
			end
			if at <= 40 then
				helper_4be4f575(3040170)
			end
			if at <= 41 then
				helper_d9c15850(0)
			end
			if at <= 42 then
				helper_d9c15850(1)
			end
			if at <= 43 then
				helper_4be4f575(3040180)
			end
			if at <= 44 then
				helper_d9c15850(0)
			end
			if at <= 45 then
				helper_4be4f575(3040185)
			end
			if at <= 46 then
				helper_d9c15850(0)
			end
			if at <= 47 then
				helper_4be4f575(3040190)
			end
			if at <= 48 then
				helper_d9c15850(0)
			end
			if at <= 49 then
				helper_d9c15850(2)
			end
			if at <= 50 then
				helper_4be4f575(3040200)
			end
			if at <= 51 then
				helper_d9c15850(0)
			end
			if at <= 52 then
				helper_6dfa44e2(20)
			end
			if at <= 53 then
				helper_4be4f575(3040205)
			end
			if at <= 54 then
				helper_d9c15850(0)
			end
			if at <= 55 then
				helper_4be4f575(3040210)
			end
			if at <= 56 then
				helper_d9c15850(1)
			end
			if at <= 57 then
				helper_4be4f575(3040220)
			end
			if at <= 58 then
				helper_d9c15850(2)
			end
			if at <= 59 then
				helper_4be4f575(3040230)
			end
			if at <= 60 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(62)
			end
			return part2()
		end
		if at <= 62 then
			helper_6dfa44e2(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_6dfa44e2(4)
		if vm.skipping() then
			return skip(63)
		end
		event.LoadBgm(46)
		event.PlayBgm(0)
		event.SndSeStop(var0, 4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
		event.SetStatus(1, 0, 256, 0)
		event.SetAi(1, 24)
		event.CharaActive(1, 24)
		event.CharaActive(0)
		event.SetCharaPos(0, 10.0, 0.0, 50.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(304, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
	event.LoadSound(3206)
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(101)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(3206) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e300/e304/")
	event.LoadMes(0, 5, "e304.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e304_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e304_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e304_shirooza.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncChara(3, 25)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 26)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e304/e304_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e300/e304/e304_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 10.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 28.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -16.0, 22.0, -139.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目とじ")
	event.EohSetSoundId(2, var0)
	event.EohSetPos(3, 36.0, 16.0, -125.0)
	event.EohSetRot(3, -1.57, 1.57, 0.0)
	event.EohSetMotion(3, "寝てる", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "苦しい顔")
	event.EohSetPos(4, 28.0, 0.0, -125.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetMotion(4, "寝てる", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(23.47, 35.37, -95.07)
	event.CmrsSetRef(-22.7, 30.41, -142.37)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目とじ～目あき")
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(19.26, 16.51, 43.78)
	event.CmrsSetRef(18.61, 15.64, 99.16)
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(23.47, 35.37, -95.07)
	event.CmrsSetRef(-22.7, 30.41, -142.37)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "羽を広げる", 2)
	event.ObjsNextMotion(2, "羽を広げるＬ", 4)
	helper_4be4f575(3040010)
	if vm.skipping() then
		return skip(5)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "飛び立つ", 2)
	event.ObjsNextMotion(2, "威嚇", 4)
	event.ObjsPosDelay(2, 16)
	event.ObjsMove2(2, -16.0, 26.0, -100.0, 20, 1, 0.4)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(35.02, 20.48, 149.96)
	event.CmrsSetRef(17.73, 29.4, 92.69)
	event.SndSePlay(var0, 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "はげしく目パチ")
	event.ObjsSetPos(2, 5.55, 40.85, 52.84)
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "のけぞる", 6)
	event.ObjsNextMotion(0, "のけぞるL", 4)
	event.EohSetTexAnim(1, 1, "おどろき目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.ObjsSetMotion(1, "のけぞり", 6)
	event.ObjsNextMotion(1, "のけぞりＬ", 4)
	helper_4be4f575(3040015)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(65.27, 58.85, -5.44)
	event.CmrsSetRef(18.94, 39.86, 68.94)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おどろき顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おどろき顔")
	event.EohSetTexAnim(1, 1, "おどろき目パチ")
	event.ObjsSetMotion(1, "わ？！Ｌ", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_4be4f575(3040020)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "両手をあげる", 6)
	event.ObjsNextMotion(0, "両手をあげるL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_4be4f575(3040030)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSeStop(var0, 4)
	event.CmrsSetPos(29.87, 41.56, 88.42)
	event.CmrsSetRef(4.41, 53.32, 58.77)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "はばたき", 4)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(51.68, 27.48, 135.38)
	event.CmrsSetRef(13.28, 36.86, 75.77)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 50)
	event.ObjsAddPas(2, 5.55, 40.85, 52.84)
	event.ObjsAddPas(2, 6.83, 40.26, 58.8)
	event.ObjsAddPas(2, 10.74, 39.69, 62.17)
	event.ObjsAddPas(2, 16.41, 38.74, 59.72)
	event.ObjsAddPas(2, 19.84, 35.64, 50.19)
	event.ObjsAddPas(2, 19.61, 35.09, 37.65)
	event.ObjsAddPas(2, 18.41, 30.77, 26.53)
	event.ObjsStartPas(2)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(23.47, 35.37, -95.07)
	event.CmrsSetRef(-22.7, 30.41, -142.37)
	event.ObjsSetMotion(2, "とまる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetPos(2, -16.0, 22.0, -94.0)
	event.ObjsMove(2, -16.0, 22.0, -139.0, 30)
	event.ObjsRotDelay(2, 14)
	event.ObjsRotation(2, 0.0, 0.0, 0.0, 16)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var0, 6)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(14)
	end
	helper_4be4f575(3040040)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(45.81, 19.16, 68.48)
	event.CmrsSetRef(14.16, 21.7, 103.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040050)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040055)
	if vm.skipping() then
		return skip(17)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(33.12, 38.41, 137.48)
	event.CmrsSetRef(18.26, 27.68, 89.72)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_4be4f575(3040060)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040070)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(29.31, 32.0, -134.74)
	event.CmrsSetRef(-18.96, 32.0, -134.63)
	event.EohSetTexAnim(2, 0)
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(21)
	end
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	helper_4be4f575(3040080)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(45.81, 19.16, 68.48)
	event.CmrsSetRef(14.16, 21.7, 103.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "かなし顔")
	event.EohSetTexAnim(0, 1, "かなし目パチ")
	event.ObjsSetMotion(0, "ええっ！？", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_4be4f575(3040090)
	if vm.skipping() then
		return skip(23)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(24)
	end
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.ObjsSetMotion(1, "考え", 2)
	event.ObjsNextMotion(1, "考えＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040100)
	if vm.skipping() then
		return skip(25)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(26)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "かなし目とじ")
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	event.ObjsSetMotion(0, "ためいき", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 8)
	event.EohSetTexAnim(1, 1, "おこり目～こまり目とじ")
	event.ObjsSetMotion(1, "考えから頭抱え", 2)
	event.ObjsNextMotion(1, "頭抱えＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040105)
	if vm.skipping() then
		return skip(27)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(28)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-4.91, 44.54, -168.27)
	event.CmrsSetRef(0.23, 19.22, -89.2)
	event.ObjsSetPos(0, 0.0, 0.0, -15.0)
	event.ObjsResetDaPosition(0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり目とじ～目あき")
	event.ObjsSetPos(1, 18.0, 0.0, -15.0)
	event.ObjsSetMotion(1, "戻り立ち", 6, -1.0, 1)
	event.ObjsNextMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040110)
	if vm.skipping() then
		return skip(31)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(32.06, 48.28, -125.0)
	event.CmrsSetRef(28.58, 28.64, -125.0)
	event.CmrsMove2(19.07, 48.28, -125.0, 15.59, 28.64, -125.0, 120, 2, 0.5)
	helper_4be4f575(3040120)
	if vm.skipping() then
		return skip(33)
	end
	helper_71fa1d07()
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(65.13, 60.48, -149.63)
	event.CmrsSetRef(21.07, 34.26, -126.11)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	event.ObjsSetPos(0, 0.0, 0.0, -50.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove(0, 0.0, 0.0, -92.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 18.0, 0.0, -50.0)
	event.ObjsResetDaPosition(1)
	event.ObjsPosDelay(1, 6)
	event.ObjsMotionDelay(1, 6)
	event.ObjsMove(1, 18.0, 0.0, -92.0, 60)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_4be4f575(3040130)
	if vm.skipping() then
		return skip(35)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(36)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(14.36, 18.14, -97.03)
	event.CmrsSetRef(15.15, 18.07, -120.41)
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 33)
		event.CharaActive(0, 34)
	end
	helper_4be4f575(3040140)
	if vm.skipping() then
		return skip(38)
	end
	if active_chr_no == 0 then
		event.CharaActive(1, 0)
	else
		event.CharaActive(1, 33)
		event.CharaActive(1, 34)
	end
	event.CmrsSetPos(65.13, 60.48, -149.63)
	event.CmrsSetRef(21.07, 34.26, -126.11)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.EohSetTexAnim(0, 0, "通常目パチ")
	event.EohSetTexAnim(0, 1, "かなし目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "かなし目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040150)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(8.32, 21.99, -128.13)
	event.CmrsSetRef(9.19, 21.92, -97.06)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "かなし目～通常目")
	event.ObjsSetMotion(0, "ひらめいた", 6)
	event.ObjsNextMotion(0, "ひらめいたL", 4)
	event.ObjsSePlay(0, var0, 9)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし目～通常目")
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3040160)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040170)
	if vm.skipping() then
		return skip(41)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(42)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(6.72, 41.81, -47.45)
	event.CmrsSetRef(6.21, 28.47, -97.09)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "左前見Ｌ", 4)
	event.ObjsSetMotion(0, "モニカ見る", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3040180)
	if vm.skipping() then
		return skip(44)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3040185)
	if vm.skipping() then
		return skip(46)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(47)
	end
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(2, "左前見会話", 2)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "シローザ見る", 6)
	event.ObjsNextMotion(0, "シローザ見るL", 4)
	helper_4be4f575(3040190)
	if vm.skipping() then
		return skip(48)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(49)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(50)
	end
	event.CmrsSetPos(65.13, 60.48, -149.63)
	event.CmrsSetRef(21.07, 34.26, -126.11)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.ObjsSetMotion(0, "シローザ見る会話", 6)
	event.ObjsNextMotion(0, "シローザ見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3040200)
	if vm.skipping() then
		return skip(51)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotion(0, "シローザ見る戻り", 2)
	event.ObjsNextMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 6)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(53)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3040205)
	if vm.skipping() then
		return skip(54)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSetMotion(1, "左向くうなづき", 2)
	event.ObjsNextMotion(1, "左向くL", 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3040210)
	if vm.skipping() then
		return skip(56)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(34.88, 32.74, -147.43)
	event.CmrsSetRef(-5.99, 31.93, -128.42)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(2, "左前見会話", 2)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	event.ObjsSetPos(0, -7.02, 0.0, -110.43)
	event.ObjsSetRot(0, 0.0, -2.42, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	helper_4be4f575(3040220)
	if vm.skipping() then
		return skip(58)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(59)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3040230)
	if vm.skipping() then
		return skip(60)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(61)
	end
	return part2()
end

--- Helper function.
local function helper_15a88()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 72 then
			if at <= 1 then
				helper_3a74ecc4()
			end
			if at <= 2 then
				helper_6dfa44e2(60)
			end
			if at <= 3 then
				helper_4be4f575(3060010)
			end
			if at <= 4 then
				helper_d9c15850(3)
			end
			if at <= 5 then
				helper_4be4f575(3060015)
			end
			if at <= 6 then
				helper_d9c15850(1)
			end
			if at <= 7 then
				helper_4be4f575(3060020)
			end
			if at <= 8 then
				helper_d9c15850(2)
			end
			if at <= 9 then
				helper_6dfa44e2(30)
			end
			if at <= 10 then
				helper_d9c15850(2)
			end
			if at <= 11 then
				helper_4be4f575(3060030)
			end
			if at <= 12 then
				helper_6dfa44e2(60)
			end
			if at <= 13 then
				helper_d9c15850(2)
			end
			if at <= 14 then
				helper_4be4f575(3060040)
			end
			if at <= 15 then
				helper_4be4f575(3060045)
			end
			if at <= 16 then
				helper_d9c15850(2)
			end
			if at <= 17 then
				helper_4be4f575(3060050)
			end
			if at <= 18 then
				helper_4be4f575(3060060)
			end
			if at <= 19 then
				helper_d9c15850(2)
			end
			if at <= 20 then
				helper_4be4f575(3060065)
			end
			if at <= 21 then
				helper_4be4f575(3060070)
			end
			if at <= 22 then
				helper_d9c15850(0)
			end
			if at <= 23 then
				helper_4be4f575(3060080)
			end
			if at <= 24 then
				helper_d9c15850(2)
			end
			if at <= 25 then
				helper_29a88422(1)
			end
			if at <= 26 then
				helper_6dfa44e2(60)
			end
			if at <= 27 then
				helper_91637685(0, -1, 8, 0, 0)
				helper_1e9c998a(0)
			end
			if at <= 28 then
				helper_09fd1f10(0)
				helper_d9c15850(1)
			end
			if at <= 29 then
				helper_4be4f575(3060095)
			end
			if at <= 30 then
				helper_4be4f575(3060100)
			end
			if at <= 31 then
				helper_4be4f575(3060110)
			end
			if at <= 32 then
				helper_d9c15850(6)
			end
			if at <= 33 then
				helper_6dfa44e2(4)
			end
			if at <= 34 then
				helper_4be4f575(3060115)
			end
			if at <= 35 then
				helper_d9c15850(6)
			end
			if at <= 36 then
				helper_4be4f575(3060120)
			end
			if at <= 37 then
				helper_d9c15850(0)
			end
			if at <= 38 then
				helper_d9c15850(1)
			end
			if at <= 39 then
				helper_4be4f575(3060130)
			end
			if at <= 40 then
				helper_d9c15850(7)
			end
			if at <= 41 then
				helper_4be4f575(3060140)
			end
			if at <= 42 then
				helper_d9c15850(9)
			end
			if at <= 44 then
				helper_4be4f575(3060150)
			end
			if at <= 45 then
				helper_d9c15850(1)
			end
			if at <= 46 then
				helper_4be4f575(3060160)
			end
			if at <= 47 then
				helper_4be4f575(3060165)
			end
			if at <= 48 then
				helper_d9c15850(0)
			end
			if at <= 49 then
				helper_4be4f575(3060170)
			end
			if at <= 50 then
				helper_d9c15850(1)
			end
			if at <= 51 then
				helper_4be4f575(3060180)
			end
			if at <= 52 then
				helper_d9c15850(0)
			end
			if at <= 53 then
				helper_4be4f575(3060190)
			end
			if at <= 54 then
				helper_d9c15850(1)
			end
			if at <= 55 then
				helper_4be4f575(3060195)
			end
			if at <= 56 then
				helper_d9c15850(1)
			end
			if at <= 57 then
				helper_4be4f575(3060200)
			end
			if at <= 58 then
				helper_d9c15850(0)
			end
			if at <= 59 then
				helper_d9c15850(1)
			end
			if at <= 60 then
				helper_6dfa44e2(20)
			end
			if at <= 61 then
				helper_4be4f575(3060210)
			end
			if at <= 62 then
				helper_d9c15850(2)
			end
			if at <= 63 then
				helper_d9c15850(1)
			end
			if at <= 64 then
				helper_4be4f575(3060220)
			end
			if at <= 65 then
				helper_4be4f575(3060230)
			end
			if at <= 66 then
				helper_d9c15850(1)
			end
			if at <= 67 then
				helper_025d5797(3060240, 300)
			end
			if at <= 68 then
				helper_71fa1d07()
			end
			if at <= 69 then
				helper_025d5797(3060250, 300)
			end
			if at <= 70 then
				helper_71fa1d07()
			end
			if at <= 71 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(73)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 10)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.EohSetShow(6, 1)
		event.SetMotion(0, "立ち", 4)
		event.StopBgm(0)
		event.StopEnvBgm()
		event.SndStopSrc()
		event.SetSavedataEtc(0, 5)
		event.SndInReverb(0)
		event.GotoDrawChapter(3)
		if vm.wait() then
			return skip(74)
		end
		event.SndInReverb(1)
		event.SetFadeOut(0)
	end
	event.SetFadeOut(0)
	event.SetFlag(306, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(54)
	event.PlayBgm(0)
	event.LoadSound(3209)
	var0 = event.SndLoadSound(3209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e306/")
	event.LoadMes(0, 5, "e306.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e306_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e306_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e306_duck.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e306_shirooza.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(3, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e306_lin.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(4, 37)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e306_bed.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(5, 38)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	block = event.LoadImg_4(5, "e306a.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e30601", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(8, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 8)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e30602", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(9, 1)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 9)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e30603", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(10, 2)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 10)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e306/e306_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e300/e306/e306_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetLoadbgFile("snd2/bgm/bg_049.sound.json")
	helper_3a74ecc4()
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncObj(6, "p01_g02i02", "g02i02_02-m0")
	event.EohSetShow(6, 0)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 32.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 16.0, 0.0, 80.0)
	event.EohSetRot(2, 0.0, -3.13, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetSoundId(2, var0)
	event.EohSetPos(3, -16.0, 22.0, -139.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetPos(4, 36.0, 16.0, -125.0)
	event.EohSetRot(4, -1.57, 1.57, 0.0)
	event.EohSetMotion(4, "寝てる", 4)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "苦しい顔")
	event.EohSetPos(5, 28.0, 0.0, -125.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetMotion(5, "寝てる", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-6.81, 44.73, -170.75)
	event.CmrsSetRef(-0.46, 20.2, -91.77)
	event.SetFadeIn(30)
	var3 = event.GetSndId(2) or var3
	event.SndSePlay(var3, 61)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(30.03, 37.26, -62.58)
	event.CmrsSetRef(-1.3, 23.77, -138.99)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_4be4f575(3060010)
	if vm.skipping() then
		return skip(4)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-30.92, 74.61, 2.48)
	event.CmrsSetRef(23.3, 23.77, -120.36)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "はげしく目パチ")
	event.ObjsSetMotion(3, "左前見会話", 6)
	event.ObjsNextMotion(3, "左前見Ｌ", 4)
	event.ObjsSetPos(0, 0.0, 0.0, -30.0)
	event.ObjsMove(0, 0.0, 0.0, -70.0, 44)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 44)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 32.0, 0.0, -30.0)
	event.ObjsMove(1, 32.0, 0.0, -70.0, 50)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetPos(2, 16.0, 0.0, -46.0)
	event.ObjsMove(2, 16.0, 0.0, -96.0, 40)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	helper_4be4f575(3060015)
	if vm.skipping() then
		return skip(6)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.CmrsSetPos(29.58, 42.39, -112.5)
	event.CmrsSetRef(6.47, 6.19, -131.58)
	event.ObjsSetPos(2, 9.48, 0.8, -104.57)
	event.ObjsSetMotion(4, "苦しむ", 4)
	event.ObjsSetMotion(5, "苦しむ", 4)
	helper_4be4f575(3060020)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(4, "寝てる")
	event.ObjsSetMotion(5, "寝てる")
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(2, "リンの顔に手", 6)
	event.ObjsNextMotion(2, "リンの顔に手Ｌ", 4)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(9)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(15.15, 29.59, -152.03)
	event.CmrsSetRef(15.79, 17.82, -106.92)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetPos(2, 16.0, 0.0, -96.0)
	event.ObjsSetMotion(2, "リンの顔に手戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetRot(0, 0.0, 2.66, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -2.66, 0.0)
	event.ObjsResetDaPosition(1)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_4be4f575(3060030)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(73.2, 51.86, -50.13)
	event.CmrsSetRef(-0.03, 5.67, -99.79)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "こまり目～通常目")
	event.ObjsSetMotion(2, "振り返る", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsRotDelay(2, 20)
	event.ObjsRotation2(2, 0.0, 0.0, 0.0, 21, 0, 0.3)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(13)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_4be4f575(3060040)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_4be4f575(3060045)
	if vm.skipping() then
		return skip(16)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060050)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSyncObj(2, 0.0, 20.0, 0.0, -1.57, 0.0, 50.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsMove(2, 16.0, 0.0, -20.0, 90)
	event.ObjsSetMotion(2, "歩き会話")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsMotionDelay(0, 14)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "ダック見振り返り", 6)
	event.ObjsNextMotion(1, "ダック見振り返りＬ", 4)
	helper_4be4f575(3060060)
	if vm.skipping() then
		return skip(19)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_4be4f575(3060065)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(17.46, 26.93, 16.32)
	event.CmrsSetRef(15.22, 20.74, -39.27)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～考え目")
	event.ObjsSetRot(0, 0.0, 0.3, 0.0)
	event.ObjsSetMotion(0, "会話", 6, -1, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetRot(1, 0.0, -0.3, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "考え", 6)
	event.ObjsNextMotion(1, "考えＬ", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060070)
	if vm.skipping() then
		return skip(22)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(23)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "顎に手", 2)
	event.ObjsNextMotion(2, "顎に手Ｌ", 4)
	helper_4be4f575(3060080)
	if vm.skipping() then
		return skip(24)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "考えから思いつく", 2)
	event.ObjsNextMotion(1, "考えから思いつくＬ", 4)
	event.ObjsSeDelay(1, 110)
	event.ObjsSePlay(1, var0, 9)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 1, "目とじ～片目あき")
	event.ObjsTexaDelay(0, 120)
	event.ObjsTexAnime(0, 1, "こまり目～通常目")
	event.ObjsTexaDelay(1, 90)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "考え目～おどろき目")
	event.SetPakuAnim(1, "わらい口パク")
	event.StreamOpen3(1, 3060090)
	helper_29a88422(1)
	if vm.skipping() then
		return skip(26)
	end
	event.StreamPlay(1)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(27)
	end
	event.MesMake_2(0, 3060090)
	helper_91637685(0, -1, 8, 0, 0)
	helper_1e9c998a(0)
	if vm.skipping() then
		return skip(28)
	end
	helper_09fd1f10(0)
	event.StreamClose(1)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060095)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060100)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(52.88, 6.41, -45.54)
	event.CmrsSetRef(31.82, 20.73, -69.95)
	event.FadeOutBgm(60)
	event.ObjsSetRot(0, 0.0, 0.24, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, -0.24, 0.0)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsColorDelay(6, 30)
	event.ObjsSetColor(6, 128, 128, 128, 128, 30)
	event.ObjsSeDelay(6, 50)
	event.ObjsSePlay(6, var0, 10)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060110)
	if vm.skipping() then
		return skip(32)
	end
	helper_d9c15850(6)
	if vm.skipping() then
		return skip(33)
	end
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(34)
	end
	event.LoadBgmPack(49)
	event.PlayBgm(0)
	event.ObjsColorDelay(6, 30)
	event.ObjsSetColor(6, 128, 128, 128, 0, 30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060115)
	if vm.skipping() then
		return skip(35)
	end
	helper_d9c15850(6)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(59.88, 44.11, -12.91)
	event.CmrsSetRef(15.2, 12.73, -72.05)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsMove(2, 16.0, 0.0, -40.0, 40)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060120)
	if vm.skipping() then
		return skip(37)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(38)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(1, "右向く会話", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsColorDelay(7, 30)
	event.ObjsSetColor(7, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3060130)
	if vm.skipping() then
		return skip(40)
	end
	helper_d9c15850(7)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetColor(9, 128, 128, 128, 128, 30)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3060140)
	if vm.skipping() then
		return skip(42)
	end
	helper_d9c15850(9)
	if vm.skipping() then
		return skip(43)
	end
	if vm.wait() then
		return skip(44)
	end
	event.SetCrossfade(30)
	event.ObjsSetColor(7, 128, 128, 128, 0)
	event.ObjsSetColor(9, 128, 128, 128, 0)
	event.CmrsSetPos(68.34, 29.51, -63.36)
	event.CmrsSetRef(5.13, 12.73, -78.64)
	event.ObjsSetPos(0, 0.0, 0.0, -85.0)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 32.0, 0.0, -85.0)
	event.ObjsSetMotion(1, "右向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetPos(2, 16.0, 0.0, -60.0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060150)
	if vm.skipping() then
		return skip(45)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(57.95, 49.92, -115.62)
	event.CmrsSetRef(12.94, 14.17, -71.8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～うれし半口")
	event.ObjsSetMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3060160)
	if vm.skipping() then
		return skip(47)
	end
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3060165)
	if vm.skipping() then
		return skip(48)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(1, "右向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060170)
	if vm.skipping() then
		return skip(50)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 11)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3060180)
	if vm.skipping() then
		return skip(52)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsSetPos(36.82, 7.72, -52.98)
	event.CmrsSetRef(31.69, 22.04, -85.14)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.6, 0.0)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3060190)
	if vm.skipping() then
		return skip(54)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsSetPos(15.34, 34.38, -16.07)
	event.CmrsSetRef(16.07, 19.81, -79.1)
	event.ObjsSetRot(0, 0.0, 1.32, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -1.32, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "ちょっとだけ", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3060195)
	if vm.skipping() then
		return skip(56)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 11)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060200)
	if vm.skipping() then
		return skip(58)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(60)
	end
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(61)
	end
	event.CmrsSetPos(-41.83, 36.46, -99.09)
	event.CmrsSetRef(26.84, 14.91, -69.03)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.24, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuMotion(2, "会話２", 0, "立ち", 0)
	helper_4be4f575(3060210)
	if vm.skipping() then
		return skip(62)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(63)
	end
	event.CmrsSetPos(49.67, 39.65, -52.94)
	event.CmrsSetRef(3.96, 26.47, -113.14)
	event.FadeOutBgm(60)
	event.ObjsRotation(0, 0.0, -2.79, 0.0, 28)
	event.ObjsSetMotion(0, "振り返る（PG）", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotation(1, 0.0, -2.4, 0.0, 34)
	event.ObjsSetMotion(1, "振り返りＰＧ", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetMotion(3, "左前見会話", 2)
	event.ObjsNextMotion(3, "左前見Ｌ", 4)
	helper_4be4f575(3060220)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsMotionDelay(1, 23)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3060230)
	if vm.skipping() then
		return skip(66)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(67)
	end
	event.CmrsSetPos(29.58, 45.4, -134.29)
	event.CmrsSetRef(13.02, 17.45, -125.0)
	event.CmrsMove2(23.74, 36.44, -131.02, 13.02, 17.45, -125.0, 160, 2, 1.0)
	helper_025d5797(3060240, 300)
	if vm.skipping() then
		return skip(68)
	end
	helper_71fa1d07()
	if vm.skipping() then
		return skip(69)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-25.96, 22.2, -107.48)
	event.CmrsSetRef(-0.56, 22.17, -86.82)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.CmrsMove2(-18.06, 22.2, -101.05, -0.56, 22.17, -86.82, 160, 2, 1.0)
	helper_025d5797(3060250, 300)
	if vm.skipping() then
		return skip(70)
	end
	helper_71fa1d07()
	if vm.skipping() then
		return skip(71)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(72)
	end
	return part2()
end

--- Helper function.
local function helper_1d5ec()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_d9c15850(2)
			end
			if at <= 2 then
				helper_d9c15850(0)
			end
			if at <= 3 then
				helper_4be4f575(3280020)
			end
			if at <= 4 then
				helper_d9c15850(0)
			end
			if at <= 5 then
				helper_4be4f575(3280030)
			end
			if at <= 6 then
				helper_d9c15850(1)
			end
			if at <= 7 then
				helper_4be4f575(3280040)
			end
			if at <= 8 then
				helper_d9c15850(2)
			end
			if at <= 9 then
				helper_4be4f575(3280050)
			end
			if at <= 10 then
				helper_d9c15850(1)
			end
			if at <= 11 then
				helper_4be4f575(3280055)
			end
			if at <= 12 then
				helper_d9c15850(0)
			end
			if at <= 13 then
				helper_4be4f575(3280060)
			end
			if at <= 14 then
				helper_d9c15850(0)
			end
			if at <= 15 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.LoadMes(0, -1)
		event.SetAi(1, 24)
		event.CharaActive(1, 24)
		event.SetMotion(24, "立ち", 4)
		event.CharaActive(0)
		event.SetCharaPos(0, 12.0, 0.0, -85.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(328, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(3214)
	var0 = event.SndLoadSound(3214) or var0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e328/")
	event.LoadMes(0, 5, "e328.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e328_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e328_moinca.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	event.LoadChara(5, "event/e300/e330/e330_shirooza.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e300/e328/e328_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e300/e328/e328_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 28.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -16.0, 22.0, -139.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFrameShow(2, "skin2", 1)
	event.EohSetFrameShow(2, "skin2_2", 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(25.92, 36.8, 138.37)
	event.CmrsSetRef(19.04, 28.52, 93.05)
	event.SetFadeIn(30)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_4be4f575(3280010)
	if vm.skipping() then
		return skip(1)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-96.42, 37.63, -127.02)
	event.CmrsSetRef(-24.38, 22.71, -119.34)
	event.ObjsSetPos(0, -28.0, 0.0, -60.0)
	event.ObjsMove(0, -28.0, 0.0, -94.0, 54)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 54)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -8.0, 0.0, -54.0)
	event.ObjsMove(1, -8.0, 0.0, -94.0, 60)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3280020)
	if vm.skipping() then
		return skip(4)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3280030)
	if vm.skipping() then
		return skip(6)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-19.25, 29.93, -55.81)
	event.CmrsSetRef(-17.02, 24.91, -120.47)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_4be4f575(3280040)
	if vm.skipping() then
		return skip(8)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3280050)
	if vm.skipping() then
		return skip(10)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4be4f575(3280055)
	if vm.skipping() then
		return skip(12)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 2)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 2)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4be4f575(3280060)
	if vm.skipping() then
		return skip(14)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Helper function.
local function helper_7ce4(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_2d88bb14(arg0, arg1)
			arg2 = 0
			arg2 = 1
			arg2 = 1
			var4 = var4 + 1
		end
		var4 = vm.i32(var4 + 1)
		return var4, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var4 = 0
	while true do
		var3 = helper_2d88bb14(arg0, arg1)
		if var3 ~= 0 then
			arg2 = 0
			if arg1 == 1 and var3 == 2 then
				arg2 = 1
			end
			if arg1 == 2 and var3 == 3 then
				arg2 = 1
			end
			var4 = vm.i32(var4 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var4 = vm.i32(var4 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	return var4, arg2
end

--- Helper function.
local function helper_87ac(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7ce4(arg0, 0, var6)
		end
		helper_09fd1f10(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7ce4(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_09fd1f10(arg0)
end

--- Helper function.
local function helper_c65c()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7a5e82c7(1, 4)
			var0 = 52
			var0 = 54
			var0 = 53
			helper_87ac(1, var0, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7a5e82c7(1, 4)
	event.MesSetBuff(1, 1, 1)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id < 0 then
		var0 = 52
	else
		var2 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var2
		event.SetMesItemDirect(1, 2, var2)
		var3 = event.GetNpcStatus(now_party_chara_id) or var3
		if bit32.band(var3, 4) ~= 0 then
			var0 = 54
		else
			var0 = 53
		end
	end
	helper_87ac(1, var0, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

--- Helper function.
local function helper_8648(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_09fd1f10(arg0)
		return arg5
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_7ce4(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_09fd1f10(arg0)
	return arg5
end

--- Helper function.
local function helper_1fab4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 88 then
			if at <= 1 then
				helper_6dfa44e2(30)
			end
			if at <= 2 then
				helper_6dfa44e2(4)
			end
			if at <= 3 then
				helper_6dfa44e2(30)
			end
			if at <= 4 then
				helper_4be4f575(3300010)
			end
			if at <= 5 then
				helper_d9c15850(3)
			end
			if at <= 6 then
				helper_4be4f575(3300020)
			end
			if at <= 7 then
				helper_d9c15850(2)
			end
			if at <= 8 then
				helper_4be4f575(3300030)
			end
			if at <= 9 then
				helper_d9c15850(3)
			end
			if at <= 10 then
				helper_4be4f575(3300040)
			end
			if at <= 11 then
				helper_d9c15850(2)
			end
			if at <= 12 then
				helper_4be4f575(3300050)
			end
			if at <= 13 then
				helper_4be4f575(3300060)
			end
			if at <= 14 then
				helper_d9c15850(3)
			end
			if at <= 15 then
				helper_4be4f575(3300070)
			end
			if at <= 16 then
				helper_4be4f575(3300080)
			end
			if at <= 17 then
				helper_d9c15850(3)
			end
			if at <= 18 then
				helper_4be4f575(3300090)
			end
			if at <= 19 then
				helper_d9c15850(2)
			end
			if at <= 20 then
				helper_4be4f575(3300100)
			end
			if at <= 21 then
				helper_4be4f575(3300110)
			end
			if at <= 22 then
				helper_d9c15850(0)
			end
			if at <= 23 then
				helper_4be4f575(3300120)
			end
			if at <= 24 then
				helper_4be4f575(3300130)
			end
			if at <= 25 then
				helper_d9c15850(3)
			end
			if at <= 26 then
				helper_4be4f575(3300140)
			end
			if at <= 27 then
				helper_d9c15850(2)
			end
			if at <= 28 then
				helper_4be4f575(3300150)
			end
			if at <= 29 then
				helper_4be4f575(3300155)
			end
			if at <= 30 then
				helper_d9c15850(3)
			end
			if at <= 31 then
				helper_4be4f575(3300160)
			end
			if at <= 32 then
				helper_d9c15850(2)
			end
			if at <= 33 then
				helper_4be4f575(3300170)
			end
			if at <= 34 then
				helper_4be4f575(3300175)
			end
			if at <= 35 then
				helper_d9c15850(2)
			end
			if at <= 36 then
				helper_4be4f575(3300180)
			end
			if at <= 37 then
				helper_d9c15850(2)
			end
			if at <= 38 then
				helper_d9c15850(3)
			end
			if at <= 39 then
				helper_4be4f575(3300190)
			end
			if at <= 40 then
				helper_d9c15850(3)
			end
			if at <= 41 then
				helper_4be4f575(3300200)
			end
			if at <= 42 then
				helper_d9c15850(3)
			end
			if at <= 43 then
				helper_6dfa44e2(30)
			end
			if at <= 44 then
				helper_6dfa44e2(15)
			end
			if at <= 45 then
				helper_6dfa44e2(110)
			end
			if at <= 46 then
				helper_4be4f575(3300210)
			end
			if at <= 47 then
				helper_d9c15850(2)
			end
			if at <= 48 then
				helper_4be4f575(3300220)
			end
			if at <= 49 then
				helper_d9c15850(2)
			end
			if at <= 50 then
				helper_d9c15850(5)
			end
			if at <= 51 then
				helper_4be4f575(3300225)
			end
			if at <= 52 then
				helper_4be4f575(3300230)
			end
			if at <= 53 then
				helper_4be4f575(3300240)
			end
			if at <= 54 then
				helper_4be4f575(3300250)
			end
			if at <= 55 then
				helper_4be4f575(3300260)
			end
			if at <= 56 then
				helper_d9c15850(2)
			end
			if at <= 57 then
				helper_4be4f575(3300270)
			end
			if at <= 58 then
				helper_d9c15850(3)
			end
			if at <= 59 then
				helper_4be4f575(3300280)
			end
			if at <= 60 then
				helper_4be4f575(3300285)
			end
			if at <= 61 then
				helper_d9c15850(2)
			end
			if at <= 62 then
				helper_4be4f575(3300290)
			end
			if at <= 63 then
				helper_4be4f575(3300295)
			end
			if at <= 64 then
				helper_d9c15850(1)
			end
			if at <= 65 then
				helper_4be4f575(3300300)
			end
			if at <= 66 then
				helper_4be4f575(3300310)
			end
			if at <= 67 then
				helper_4be4f575(3300315)
			end
			if at <= 68 then
				helper_d9c15850(1)
			end
			if at <= 69 then
				helper_4be4f575(3300320)
			end
			if at <= 70 then
				helper_4be4f575(3300325)
			end
			if at <= 71 then
				helper_d9c15850(3)
			end
			if at <= 72 then
				helper_4be4f575(3300330)
			end
			if at <= 73 then
				helper_4be4f575(3300335)
			end
			if at <= 74 then
				helper_d9c15850(2)
			end
			if at <= 75 then
				helper_4be4f575(3300340)
			end
			if at <= 76 then
				helper_4be4f575(3300345)
			end
			if at <= 77 then
				helper_4be4f575(3300350)
			end
			if at <= 78 then
				helper_4be4f575(3300360)
			end
			if at <= 79 then
				helper_4be4f575(3300365)
			end
			if at <= 80 then
				helper_4be4f575(3300370)
			end
			if at <= 81 then
				helper_d9c15850(1)
			end
			if at <= 82 then
				helper_4be4f575(3300380)
			end
			if at <= 83 then
				helper_d9c15850(2)
			end
			if at <= 84 then
				helper_d9c15850(1)
			end
			if at <= 85 then
				helper_6dfa44e2(10)
			end
			if at <= 86 then
				helper_6dfa44e2(40)
			end
			if at <= 87 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(89)
			end
			return part2()
		end
		if at <= 89 then
			helper_6dfa44e2(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.StopBgm(0)
		helper_6dfa44e2(4)
		if vm.skipping() then
			return skip(90)
		end
		event.LoadBgm(46)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0, 25)
		event.CharaActive(0, 26)
		event.SetAi(1, 24)
		event.CharaActive(1, 24)
		event.EohSetShow(8, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, 10.0, 0.0, 50.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFlag(330, 1)
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(3217)
	var0 = event.SndLoadSound(3217) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e330/")
	event.LoadMes(0, 5, "e330.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e330_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e330_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.SetStatus(1, 0, 256, 1)
	event.LoadChara(5, "e330_shirooza.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncChara(3, 25)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 26)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	block = event.LoadImg_4(5, "e330.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e33001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e33002", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(6, 1)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e33003", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(7, 2)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e300/e330/e330_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e300/e330/e330_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(8, "p01_g02i02", "g02i02_02-m0")
	event.EohSetShow(8, 0)
	event.EohSetPos(0, 28.0, 0.0, -90.0)
	event.EohSetRot(0, 0.0, -2.78, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "うれし口ひらき")
	event.EohSetPos(1, 10.0, 0.0, -90.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "うれし口ひらき")
	event.EohSetPos(2, 72.38, 16.24, -92.51)
	event.EohSetRot(2, 0.0, -2.28, 0.0)
	event.EohSetMotion(2, "たんすの上立ち", 4)
	event.EohSetFrameShow(2, "skin2", 0)
	event.EohSetFrameShow(2, "skin2_2", 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetPos(3, 35.0, 16.0, -125.0)
	event.EohSetRot(3, -1.57, 1.57, 0.0)
	event.EohSetMotion(3, "寝てる", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "苦しい顔")
	event.EohSetMotion(4, "寝てる", 4)
	event.SetStatus(1, 25, 8, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(24.01, 39.57, -131.04)
	event.CmrsSetRef(12.03, 16.62, -125.29)
	event.SetFadeIn(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexaDelay(3, 14)
	event.ObjsTexAnime(3, 1, "目をあける")
	event.ObjsTexaDelay(3, 40)
	helper_4be4f575(3300010)
	if vm.skipping() then
		return skip(5)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-1.81, 27.97, -154.78)
	event.CmrsSetRef(22.11, 20.33, -117.13)
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300020)
	if vm.skipping() then
		return skip(7)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(87.79, 35.12, -53.62)
	event.CmrsSetRef(30.17, 14.59, -122.91)
	event.SndSePlay(var0, 6)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "ボーっと顔")
	event.EohSetTexAnim(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "皆の方を見る", 6)
	event.ObjsNextMotion(3, "皆の方を見るL", 4)
	event.ObjsSetMotion(4, "皆の方を見る", 6)
	event.ObjsNextMotion(4, "皆の方を見るL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_4be4f575(3300030)
	if vm.skipping() then
		return skip(9)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300040)
	if vm.skipping() then
		return skip(11)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-0.25, 29.43, -153.39)
	event.CmrsSetRef(31.82, 19.45, -101.83)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "まばたき目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～半口")
	event.SetPakuAnim(3, "通常口パク")
	helper_4be4f575(3300050)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(14.77, 25.94, -93.48)
	event.CmrsSetRef(24.16, 22.04, -127.87)
	event.SndSePlay(var0, 7)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "無表情")
	event.EohSetTexAnim(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "起きる", 6)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる", 6)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300060)
	if vm.skipping() then
		return skip(14)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(15.87, 27.57, -153.99)
	event.CmrsSetRef(47.68, 18.9, -91.11)
	helper_4be4f575(3300070)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_4be4f575(3300080)
	if vm.skipping() then
		return skip(17)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300090)
	if vm.skipping() then
		return skip(19)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-19.09, 25.03, -107.24)
	event.CmrsSetRef(21.58, 22.33, -92.56)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300100)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "半口～大口")
	helper_4be4f575(3300110)
	if vm.skipping() then
		return skip(22)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-29.66, 47.69, -64.04)
	event.CmrsSetRef(49.02, 14.93, -110.71)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_4be4f575(3300120)
	if vm.skipping() then
		return skip(24)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_4be4f575(3300130)
	if vm.skipping() then
		return skip(25)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(40.99, 26.64, -119.35)
	event.CmrsSetRef(70.6, 26.45, -93.81)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目とじ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "首を振る", 6)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300140)
	if vm.skipping() then
		return skip(27)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(99.48, 34.17, -94.04)
	event.CmrsSetRef(30.19, 25.94, -108.59)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "かなしわらい顔")
	event.EohSetTexAnim(3, 1, "かなし目パチ")
	event.SetPakuAnim(3, "わらい口パク")
	helper_4be4f575(3300150)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_4be4f575(3300155)
	if vm.skipping() then
		return skip(30)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300160)
	if vm.skipping() then
		return skip(32)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(92.85, 16.62, -119.64)
	event.CmrsSetRef(40.1, 33.22, -74.69)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_4be4f575(3300170)
	if vm.skipping() then
		return skip(34)
	end
	helper_4be4f575(3300175)
	if vm.skipping() then
		return skip(35)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(15.77, 23.48, -148.74)
	event.CmrsSetRef(56.68, 21.9, -74.53)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "うつむく", 2)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_4be4f575(3300180)
	if vm.skipping() then
		return skip(37)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(38)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(64.26, 45.15, -27.39)
	event.CmrsSetRef(38.5, 14.35, -130.85)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "おこり顔")
	event.EohSetTexAnim(3, 1, "おこり目パチ")
	event.ObjsSetMotion(3, "あせる", 2)
	event.ObjsNextMotion(3, "あせるL", 4)
	event.ObjsSetMotion(4, "あせる", 2)
	event.ObjsNextMotion(4, "あせるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300190)
	if vm.skipping() then
		return skip(40)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-131.61, 184.06, -64.71)
	event.CmrsSetRef(51.21, 2.33, -126.16)
	event.SndSePlay(var0, 8)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(3, "頭をかかえる", 2)
	event.ObjsNextMotion(3, "頭をかかえるL", 4)
	event.ObjsSetMotion(4, "頭をかかえる", 2)
	event.ObjsNextMotion(4, "頭をかかえるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300200)
	if vm.skipping() then
		return skip(42)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(43)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(44)
	end
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(45)
	end
	event.SetStatus(1, 25, 8, 0)
	event.ObjsSetPos(0, 0.0, 0.0, -90.0)
	event.ObjsSetRot(0, 0.0, -1.69, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 0.0, 0.0, -70.0)
	event.ObjsSetRot(1, 0.0, -1.81, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(3, -53.0, 0.0, -97.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "おちこみ立ち", 4)
	event.ObjsSetPos(2, -16.0, 22.0, -139.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "左前見Ｌ", 4)
	event.EohSetFrameShow(2, "skin2", 1)
	event.EohSetFrameShow(2, "skin2_2", 0)
	event.CmrsSetPos(57.82, 62.91, -139.67)
	event.CmrsSetRef(-55.62, 5.38, -89.44)
	event.SetFadeIn(30)
	helper_6dfa44e2(110)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-93.03, 24.39, -105.26)
	event.CmrsSetRef(12.72, 20.96, -113.84)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "絶望顔")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300210)
	if vm.skipping() then
		return skip(47)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(45.38, 35.01, -120.42)
	event.CmrsSetRef(-20.5, 28.5, -120.11)
	event.SpriteSetDraw(0, 1)
	event.ObjsColorDelay(5, 30)
	event.ObjsSetColor(5, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300220)
	if vm.skipping() then
		return skip(49)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(50)
	end
	helper_d9c15850(5)
	if vm.skipping() then
		return skip(51)
	end
	helper_4be4f575(3300225)
	if vm.skipping() then
		return skip(52)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(6, 128, 128, 128, 128, 30)
	helper_4be4f575(3300230)
	if vm.skipping() then
		return skip(53)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(7, 128, 128, 128, 128, 30)
	helper_4be4f575(3300240)
	if vm.skipping() then
		return skip(54)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.ObjsSetColor(7, 128, 128, 128, 0, 30)
	event.CmrsSetPos(56.94, 81.54, -45.44)
	event.CmrsSetRef(-56.07, 1.34, -106.43)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300250)
	if vm.skipping() then
		return skip(55)
	end
	helper_4be4f575(3300260)
	if vm.skipping() then
		return skip(56)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(-119.33, 41.11, -95.7)
	event.CmrsSetRef(-22.39, 11.99, -99.98)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(3, "いやいや", 6)
	event.ObjsNextMotion(3, "おちこみ立ち", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300270)
	if vm.skipping() then
		return skip(58)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(59)
	end
	helper_4be4f575(3300280)
	if vm.skipping() then
		return skip(60)
	end
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300285)
	if vm.skipping() then
		return skip(61)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(62)
	end
	event.CmrsSetPos(10.36, 21.88, -39.67)
	event.CmrsSetRef(-27.66, 19.71, -97.71)
	event.SndSePlay(var0, 9)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "かなし顔")
	event.EohSetTexAnim(3, 1, "かなし目パチ")
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsMotionDelay(3, 40)
	event.ObjsSetMotion(3, "振り返る", 6)
	event.ObjsNextMotion(3, "振り返るL", 4)
	event.ObjsRotDelay(3, 40)
	event.ObjsRotation(3, 0.0, -1.93, 0.0, 40)
	event.ObjsSeDelay(3, 40)
	event.ObjsSePlay(3, var0, 10)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300290)
	if vm.skipping() then
		return skip(63)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300295)
	if vm.skipping() then
		return skip(64)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(65)
	end
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300300)
	if vm.skipping() then
		return skip(66)
	end
	event.CmrsSetPos(-70.31, 31.36, -128.99)
	event.CmrsSetRef(-9.47, 13.8, -67.09)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300310)
	if vm.skipping() then
		return skip(67)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300315)
	if vm.skipping() then
		return skip(68)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsSetPos(-26.17, 19.91, -113.4)
	event.CmrsSetRef(-51.02, 21.23, -95.32)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300320)
	if vm.skipping() then
		return skip(70)
	end
	event.SndSePlay(var0, 11)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目をとじる")
	event.ObjsSetMotion(3, "ふさぎこむ", 4)
	event.ObjsNextMotion(3, "ふさぎこむL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_4be4f575(3300325)
	if vm.skipping() then
		return skip(71)
	end
	helper_d9c15850(3)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(-2.71, 9.25, -74.51)
	event.CmrsSetRef(-22.45, 20.78, -105.38)
	event.CharaActive(0, 0)
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "うつろ顔")
	event.ObjsSetPos(3, -30.0, 0.0, -97.0)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300330)
	if vm.skipping() then
		return skip(73)
	end
	helper_4be4f575(3300335)
	if vm.skipping() then
		return skip(74)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(75)
	end
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_4be4f575(3300340)
	if vm.skipping() then
		return skip(76)
	end
	helper_4be4f575(3300345)
	if vm.skipping() then
		return skip(77)
	end
	helper_4be4f575(3300350)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(-77.82, 32.14, -80.91)
	event.CmrsSetRef(-1.37, 15.08, -92.17)
	event.CharaActive(1, 0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, -53.0, 0.0, -97.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3300360)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3300365)
	if vm.skipping() then
		return skip(80)
	end
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3300370)
	if vm.skipping() then
		return skip(81)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsSetPos(27.61, 76.95, -20.78)
	event.CmrsSetRef(-28.7, 15.08, -105.78)
	event.SndSePlay(var0, 12)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetRot(0, 0.0, -2.62, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.89, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_4be4f575(3300380)
	if vm.skipping() then
		return skip(83)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var0, 13)
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(85)
	end
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(86)
	end
	event.CmrsSetPos(-68.75, 20.99, -120.19)
	event.CmrsSetRef(-23.11, 15.08, -79.67)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetRot(0, 0.0, -1.66, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.05, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(87)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(88)
	end
	return part2()
end

--- Helper function.
local function helper_efe4()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			helper_d9c15850(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(2)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_28064()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 2
		end
		if at <= 2 then
			helper_1fab4()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_c65c()
		end
		if at <= 5 then
			helper_efe4()
		end
	end
	function part2() end
	function landing1()
		helper_c65c()
		if vm.skipping() then
			return skip(4)
		end
		if vm.wait() then
			return skip(5)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		var4 = event.GetNpcStatus(now_party_chara_id) or var4
		if bit32.band(var4, 4) ~= 0 then
			event.SetNpcStatus(now_party_chara_id, 4)
		else
			event.SetNpcStatus(now_party_chara_id, 2)
		end
		event.SetNpcStatus(26, 128)
		event.SetNpcStatus(26, 1)
		return part2()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "リンが苦しそうにしている。\n（(#)ボタンでメニューを開く）")
		var1 = helper_8648(0, -1, 5, 0, 0, var1)
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.GotoUseItem(364)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(2)
			end
		end
		if var2 == 364 then
			event.FuncPointShow("", "syumai", 0)
			event.FuncPointShow("", "event_550", 0)
			helper_1fab4()
			if vm.skipping() then
				return skip(3)
			end
			helper_c65c()
			if vm.skipping() then
				return skip(4)
			end
			if vm.wait() then
				return skip(5)
			end
			now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
			var4 = event.GetNpcStatus(now_party_chara_id) or var4
			if bit32.band(var4, 4) ~= 0 then
				event.SetNpcStatus(now_party_chara_id, 4)
			else
				event.SetNpcStatus(now_party_chara_id, 2)
			end
			event.SetNpcStatus(26, 128)
			event.SetNpcStatus(26, 1)
		elseif var2 > 0 then
			helper_efe4()
			if vm.skipping() then
				return skip(6)
			end
		end
	end
	return part2()
end

--- Helper function.
local function helper_1a2c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_9d8c(arg0: any, arg1: f32)
	local rot_y: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local angle: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var10 = rot_y
			var11 = arg1
			angle = vm.f32(var11 - var10)
			var14 = 0.0
			var15 = 10.0
			var13 = helper_1a2c(0.0, angle, var14, var15)
			var13 = vm.f32(var13 + var10)
			var14 = vm.f32(var14 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, arg0)
	event.EohGetPos(0)
	do
		local _, out2, _ = event.EohGetRot(0)
		rot_y = out2 or rot_y
	end
	var10 = rot_y
	var11 = arg1
	angle = vm.f32(var11 - var10)
	angle = event.AngleLimit(angle) or angle
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	var14 = 0.0
	var15 = 10.0
	while var14 <= var15 do
		var13 = helper_1a2c(0.0, angle, var14, var15)
		var13 = vm.f32(var13 + var10)
		event.EohSetRot(0, 0.0, var13, 0.0)
		var14 = vm.f32(var14 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.EohSetRot(0, 0.0, arg1, 0.0)
end

--- Helper function.
local function helper_8118(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b681f72a(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7ce4(arg0, 0, var5)
		end
		helper_09fd1f10(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_b681f72a(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7ce4(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_09fd1f10(arg0)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_56b874f1

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local now_party_chara_id: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			return
		end
	end
	helper_56b874f1()
	flag = event.GetFlag(300) or flag
	flag_2 = event.GetFlag(304) or flag_2
	flag_3 = event.GetFlag(306) or flag_3
	flag_4 = event.GetFlag(324) or flag_4
	flag_5 = event.GetFlag(328) or flag_5
	event.GetFlag(330)
	if flag == 1 then
		if flag_2 == 0 then
			helper_f5bc()
			if vm.skipping() then
				return skip(1)
			end
			return
		else
			now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
			if flag_3 == 0 and now_party_chara_id == 6 then
				helper_15a88()
				if vm.skipping() then
					return skip(2)
				end
				event.SetNpcStatus(6, 2)
				event.BgmLoadCancel()
				event.MapJump(-1, "g02", 503)
				if vm.wait() then
					return skip(3)
				end
				return
			end
			if flag_4 == 1 and flag_5 == 0 then
				helper_1d5ec()
				if vm.skipping() then
					return skip(4)
				end
				return
			end
		end
	end
	var7 = event.GetSndId(2) or var7
	event.SndSePlay(var7, 61)
	event.SetCharaPos(0, 8.0, 0.0, 120.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local now_party_chara_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_c65c()
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetNpcStatus(now_party_chara_id, 2)
	event.SetNpcStatus(26, 128)
	event.SetNpcStatus(26, 1)
end

--- Program 200.
script[200] = function()
	local now_map_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no == 1 then
		event.GotoOutside(-1, "g02", 100)
	else
		event.MapJump(-1, "g02", 100)
	end
	if vm.wait() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_28064()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 550.
script[550] = function()
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var5 = vm.f32(9.52)
			var7 = vm.f32(-125.12)
			helper_9d8c(player_chara, var8)
		end
		if at <= 2 then
			helper_87ac(0, -1, 4, 256, 312)
		end
		if at <= 3 then
			helper_6dfa44e2(15)
		end
	end
	print("550-------------------------------------------------")
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraPos(9.08, 28.93, -152.07)
	event.SetCameraRef(11.2, 18.91, -112.52)
	event.SetFadeIn(15)
	player_chara = event.GetControlChrid() or player_chara
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	var5 = vm.f32(9.52)
	var7 = vm.f32(-125.12)
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_9d8c(player_chara, var8)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(306) or flag
	if flag == 0 then
		event.MesMake_2(0, "はぁはぁはぁ・・・\nう～ん。うぅ～ん。")
	else
		event.MesMake_2(0, "はぁはぁはぁ・・・\nう～ん、はあん・・・")
	end
	helper_87ac(0, -1, 4, 256, 312)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetCamera(1, 3.1415927)
	event.Finish()
	event.SetFadeIn(15)
end

--- Program 551.
script[551] = function()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8118(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_8118(0, -1, var1, player_chara, 0)
		end
		if at <= 3 then
			helper_8118(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_8118(0, -1, var1, player_chara, 0)
		end
	end
	print("551-------------------------------------------------")
	player_chara = event.GetControlChrid() or player_chara
	var1 = 24
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_9d8c(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(356) or flag
	if flag ~= 0 then
		event.MesMake_2(
			0,
			"リンは修行の旅に行っちゃったホ。\n賢者になるまで帰らないと言ってたホ。<page>でも、賢者になれたかなんて、\n誰が決めるホ？<page>賢者にならなくても良いから\n早く帰って来て欲しいホ～"
		)
	else
		flag_2 = event.GetFlag(330) or flag_2
		if flag_2 ~= 0 then
			event.MesMake_2(0, "リンのこと、頼んだホ。\n気をつけていくホ。")
		else
			flag_3 = event.GetFlag(324) or flag_3
			if flag_3 ~= 0 then
				event.MesMake_2(
					0,
					"なにもたもたしてるホ！<page>早くシューマイを\n食べさせるホ！"
				)
			else
				flag_4 = event.GetFlag(317) or flag_4
				if flag_4 ~= 0 then
					event.MesMake_2(0, "まだ『奇跡の料理』は\n手に入らないホか？")
					helper_8118(0, -1, var1, player_chara, 0)
					if vm.skipping() then
						return skip(2)
					end
					event.MesMake_2(0, "ぐずホ、のろまホ！\n頼りにならないホ～")
				else
					flag_5 = event.GetFlag(320) or flag_5
					if flag_5 ~= 0 then
						event.MesMake_2(0, "まだ『白き風の花』は\n手に入らないホか？")
						helper_8118(0, -1, var1, player_chara, 0)
						if vm.skipping() then
							return skip(3)
						end
						event.MesMake_2(0, "ぐずホ、のろまホ！\n頼りにならないホ～")
					else
						flag_6 = event.GetFlag(306) or flag_6
						if flag_6 ~= 0 then
							event.MesMake_2(0, "まだラオチャオ飯店は\n復活してないホか？")
							helper_8118(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(4)
							end
							event.MesMake_2(0, "ぐずホ、のろまホ！\n頼りにならないホ～")
						else
							event.MesMake_2(
								0,
								"早く医者を連れて来るホ。\nあわてず急いで連れて来るホ。"
							)
						end
					end
				end
			end
		end
	end
	helper_8118(0, -1, var1, player_chara, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8118(0, -1, var0, player_chara, 0)
		end
	end
	print("KITA-------------------------------\n")
	var0 = event.GetEventData_2(13) or var0
	player_chara = event.GetControlChrid() or player_chara
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_9d8c(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	helper_8118(0, -1, var0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 13040.
script[13040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 0)
	event.SetFlag(306, 0)
	event.SetFlag(324, 0)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_f5bc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13060.
script[13060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 1)
	event.SetFlag(306, 0)
	event.SetFlag(324, 0)
	event.SetFlag(330, 0)
	event.SetNpcStatus(6, 128)
	event.SetNpcStatus(6, 1)
	helper_56b874f1()
	helper_15a88()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02", 503)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 13280.
script[13280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 1)
	event.SetFlag(306, 1)
	event.SetFlag(324, 1)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_1d5ec()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13300.
script[13300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(324, 1)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_1fab4()
	if vm.skipping() then
		return skip(1)
	end
end

return script
