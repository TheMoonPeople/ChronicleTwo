--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_b6c190ae()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 60 then
			if at <= 1 then
				helper_a0e17f3c(30)
			end
			if at <= 2 then
				helper_a0e17f3c(30)
			end
			if at <= 3 then
				helper_a0e17f3c(40)
			end
			if at <= 4 then
				helper_a19c5ee3(2)
			end
			if at <= 5 then
				helper_a19c5ee3(2)
			end
			if at <= 6 then
				helper_fa57afea(3040010)
			end
			if at <= 7 then
				helper_fa57afea(3040020)
			end
			if at <= 8 then
				helper_fa57afea(3040030)
			end
			if at <= 9 then
				helper_a0e17f3c(60)
			end
			if at <= 10 then
				helper_a19c5ee3(2)
			end
			if at <= 11 then
				helper_a0e17f3c(60)
			end
			if at <= 12 then
				helper_a19c5ee3(2)
			end
			if at <= 13 then
				helper_fa57afea(3040040)
			end
			if at <= 14 then
				helper_fa57afea(3040050)
			end
			if at <= 15 then
				helper_fa57afea(3040055)
			end
			if at <= 16 then
				helper_a19c5ee3(1)
			end
			if at <= 17 then
				helper_fa57afea(3040060)
			end
			if at <= 18 then
				helper_fa57afea(3040070)
			end
			if at <= 19 then
				helper_a19c5ee3(2)
			end
			if at <= 20 then
				helper_fa57afea(3040080)
			end
			if at <= 21 then
				helper_fa57afea(3040090)
			end
			if at <= 22 then
				helper_a19c5ee3(0)
			end
			if at <= 23 then
				helper_fa57afea(3040100)
			end
			if at <= 24 then
				helper_a19c5ee3(1)
			end
			if at <= 25 then
				helper_fa57afea(3040105)
			end
			if at <= 26 then
				helper_a19c5ee3(0)
			end
			if at <= 27 then
				helper_a19c5ee3(1)
			end
			if at <= 28 then
				helper_a0e17f3c(20)
			end
			if at <= 29 then
				helper_fa57afea(3040110)
			end
			if at <= 30 then
				helper_a19c5ee3(1)
			end
			if at <= 31 then
				helper_fa57afea(3040120)
			end
			if at <= 32 then
				helper_b35e85eb()
			end
			if at <= 33 then
				helper_fa57afea(3040130)
			end
			if at <= 34 then
				helper_a19c5ee3(2)
			end
			if at <= 35 then
				helper_a19c5ee3(1)
			end
			if at <= 36 then
				helper_fa57afea(3040140)
			end
			if at <= 37 then
				helper_fa57afea(3040150)
			end
			if at <= 38 then
				helper_fa57afea(3040160)
			end
			if at <= 39 then
				helper_fa57afea(3040170)
			end
			if at <= 40 then
				helper_a19c5ee3(0)
			end
			if at <= 41 then
				helper_a19c5ee3(1)
			end
			if at <= 42 then
				helper_fa57afea(3040180)
			end
			if at <= 43 then
				helper_a19c5ee3(0)
			end
			if at <= 44 then
				helper_fa57afea(3040185)
			end
			if at <= 45 then
				helper_a19c5ee3(0)
			end
			if at <= 46 then
				helper_fa57afea(3040190)
			end
			if at <= 47 then
				helper_a19c5ee3(0)
			end
			if at <= 48 then
				helper_a19c5ee3(2)
			end
			if at <= 49 then
				helper_fa57afea(3040200)
			end
			if at <= 50 then
				helper_a19c5ee3(0)
			end
			if at <= 51 then
				helper_a0e17f3c(20)
			end
			if at <= 52 then
				helper_fa57afea(3040205)
			end
			if at <= 53 then
				helper_a19c5ee3(0)
			end
			if at <= 54 then
				helper_fa57afea(3040210)
			end
			if at <= 55 then
				helper_a19c5ee3(1)
			end
			if at <= 56 then
				helper_fa57afea(3040220)
			end
			if at <= 57 then
				helper_a19c5ee3(2)
			end
			if at <= 58 then
				helper_fa57afea(3040230)
			end
			if at <= 59 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(61)
			end
			return part2()
		end
		if at <= 61 then
			helper_a0e17f3c(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_a0e17f3c(4)
		if vm.skipping() then
			return skip(62)
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
	helper_a0e17f3c(4)
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
	event.LoadMes(0, 5, "e304_1.txt")
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
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目とじ～目あき")
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(19.26, 16.51, 43.78)
	event.CmrsSetRef(18.61, 15.64, 99.16)
	helper_a0e17f3c(40)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(23.47, 35.37, -95.07)
	event.CmrsSetRef(-22.7, 30.41, -142.37)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "羽を広げる", 2)
	event.ObjsNextMotion(2, "羽を広げるＬ", 4)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "飛び立つ", 2)
	event.ObjsNextMotion(2, "威嚇", 4)
	event.ObjsPosDelay(2, 16)
	event.ObjsMove2(2, -16.0, 26.0, -100.0, 20, 1, 0.4)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(6)
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
	helper_fa57afea(3040010)
	if vm.skipping() then
		return skip(7)
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
	helper_fa57afea(3040020)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "両手をあげる", 6)
	event.ObjsNextMotion(0, "両手をあげるL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_fa57afea(3040030)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var0, 4)
	event.CmrsSetPos(29.87, 41.56, 88.42)
	event.CmrsSetRef(4.41, 53.32, 58.77)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "はばたき", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(10)
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
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(11)
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
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 6)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_fa57afea(3040040)
	if vm.skipping() then
		return skip(14)
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
	helper_fa57afea(3040050)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040055)
	if vm.skipping() then
		return skip(16)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(33.12, 38.41, 137.48)
	event.CmrsSetRef(18.26, 27.68, 89.72)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_fa57afea(3040060)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040070)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(29.31, 32.0, -134.74)
	event.CmrsSetRef(-18.96, 32.0, -134.63)
	event.EohSetTexAnim(2, 0)
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	helper_fa57afea(3040080)
	if vm.skipping() then
		return skip(21)
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
	helper_fa57afea(3040090)
	if vm.skipping() then
		return skip(22)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(23)
	end
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.ObjsSetMotion(1, "考え", 2)
	event.ObjsNextMotion(1, "考えＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040100)
	if vm.skipping() then
		return skip(24)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(25)
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
	helper_fa57afea(3040105)
	if vm.skipping() then
		return skip(26)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(27)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(28)
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
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040110)
	if vm.skipping() then
		return skip(30)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(32.06, 48.28, -125.0)
	event.CmrsSetRef(28.58, 28.64, -125.0)
	event.CmrsMove2(19.07, 48.28, -125.0, 15.59, 28.64, -125.0, 120, 2, 0.5)
	helper_fa57afea(3040120)
	if vm.skipping() then
		return skip(32)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(33)
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
	helper_fa57afea(3040130)
	if vm.skipping() then
		return skip(34)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(35)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(14.36, 18.14, -97.03)
	event.CmrsSetRef(15.15, 18.07, -120.41)
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 33)
		event.CharaActive(0, 34)
	end
	helper_fa57afea(3040140)
	if vm.skipping() then
		return skip(37)
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
	helper_fa57afea(3040150)
	if vm.skipping() then
		return skip(38)
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
	helper_fa57afea(3040160)
	if vm.skipping() then
		return skip(39)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040170)
	if vm.skipping() then
		return skip(40)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(41)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(42)
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
	helper_fa57afea(3040180)
	if vm.skipping() then
		return skip(43)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3040185)
	if vm.skipping() then
		return skip(45)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(46)
	end
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(2, "左前見会話", 2)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "シローザ見る", 6)
	event.ObjsNextMotion(0, "シローザ見るL", 4)
	helper_fa57afea(3040190)
	if vm.skipping() then
		return skip(47)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(48)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(65.13, 60.48, -149.63)
	event.CmrsSetRef(21.07, 34.26, -126.11)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.ObjsSetMotion(0, "シローザ見る会話", 6)
	event.ObjsNextMotion(0, "シローザ見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3040200)
	if vm.skipping() then
		return skip(50)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(0, "シローザ見る戻り", 2)
	event.ObjsNextMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 6)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(52)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3040205)
	if vm.skipping() then
		return skip(53)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(1, "左向くうなづき", 2)
	event.ObjsNextMotion(1, "左向くL", 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3040210)
	if vm.skipping() then
		return skip(55)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(34.88, 32.74, -147.43)
	event.CmrsSetRef(-5.99, 31.93, -128.42)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(2, "左前見会話", 2)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	event.ObjsSetPos(0, -7.02, 0.0, -110.43)
	event.ObjsSetRot(0, 0.0, -2.42, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	helper_fa57afea(3040220)
	if vm.skipping() then
		return skip(57)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(58)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3040230)
	if vm.skipping() then
		return skip(59)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(60)
	end
	return part2()
end

return helper_b6c190ae
