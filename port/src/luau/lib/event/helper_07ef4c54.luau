--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_46b7514d = require("@lib/event/helper_46b7514d")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")
local helper_e95ecf38 = require("@lib/event/helper_e95ecf38")

--- Helper function.
local function helper_07ef4c54()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_2f481f12(120)
			end
			if at <= 2 then
				helper_b027b809()
			end
			if at <= 3 then
				helper_93bb7fa4(4020010)
			end
			if at <= 4 then
				helper_46b7514d(4020015, 40)
			end
			if at <= 5 then
				helper_e8f4b85c(0)
			end
			if at <= 6 then
				helper_93bb7fa4(4020020)
			end
			if at <= 7 then
				helper_93bb7fa4(4020030)
			end
			if at <= 8 then
				helper_93bb7fa4(4020040)
			end
			if at <= 9 then
				helper_93bb7fa4(4020050)
			end
			if at <= 10 then
				helper_e95ecf38(1)
			end
			if at <= 11 then
				helper_e8f4b85c(1)
			end
			if at <= 12 then
				helper_2f481f12(40)
			end
			if at <= 13 then
				helper_93bb7fa4(4020060)
			end
			if at <= 14 then
				helper_93bb7fa4(4020070)
			end
			if at <= 15 then
				helper_e8f4b85c(1)
			end
			if at <= 16 then
				helper_46b7514d(4020080, 200)
			end
			if at <= 17 then
				helper_46b7514d(4020090, 160)
			end
			if at <= 18 then
				helper_46b7514d(4020100, 120)
			end
			if at <= 19 then
				helper_46b7514d(4020110, 240)
			end
			if at <= 20 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.CmrsInit()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		event.SetSavedataEtc(0, 6)
		event.SoundAllStop()
		event.SndInReverb(0)
		event.GotoDrawChapter(4)
		if vm.wait() then
			return skip(23)
		end
		event.SndInReverb(1)
		event.LoadSound(4000)
		event.LoadBgm(3)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.SetMotion(0, "立ち")
		event.SetCharaPos(0, 1333.8, 0.0, 1013.9)
		event.SetCharaRot(0, 0.0, 1.02, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(402, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(4203) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e402/")
	event.LoadMes(0, 5, "e402_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e402_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e402_monica.gltf", "info", 0)
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
		event.LoadMotion(5, "event/e400/e402/e402_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e402/e402_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 471.25, 20.66, 1748.34)
	event.EohSetRot(0, 0.0, 2.42, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetFootSoundId(0, 3)
	event.EohSetPos(1, 465.2, 21.66, 1714.07)
	event.EohSetRot(1, 0.0, 2.06, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(1, 3)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(626.04, 342.91, 851.54, 601.54, 423.33, 982.17)
	event.CmrsAddPas(626.04, 302.51, 851.54, 601.54, 268.91, 982.17)
	event.CmrsAddPas(626.04, 292.84, 851.54, 631.34, 235.24, 1036.0)
	event.CmrsStartPas()
	event.ObjsMove(0, 658.38, 0.0, 1645.68, 200, 1)
	event.ObjsMove(1, 634.81, 0.0, 1650.64, 200, 1)
	event.SetFadeIn(30)
	helper_2f481f12(120)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 14)
	event.EohSetFootSoundId(1, 14)
	helper_b027b809()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(715.95, 6.25, 1348.09)
	event.CmrsSetRef(737.6, 21.29, 1394.21)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "ぼうぜん顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetPos(0, 742.24, 0.0, 1390.21)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 726.5, 0.0, 1393.6)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4020010)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "ぼうぜん顔")
	event.EohSetTexAnim(0, 1, "通常目～うれし目")
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 698.97, -14.0, 868.0, 180)
	event.SetPakuAnim(0, "わらい口パク")
	helper_46b7514d(4020015, 40)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMoveAhd2(0.07, 6.33, 54.89, 40, 0, 1.0)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(0, "はしゃぐ", 2)
	event.ObjsNextMotion(0, "はしゃぐL", 4)
	helper_93bb7fa4(4020020)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(713.67, 19.27, 1363.81)
	event.CmrsSetRef(727.45, 21.29, 1389.89)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "うれし顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93bb7fa4(4020030)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(677.49, 2.27, 847.33)
	event.CmrsSetRef(696.2, 6.92, 872.39)
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 1)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "うれし目パチ")
	event.ObjsSetMotion(0, "うん！", 6)
	event.ObjsNextMotion(0, "うん！L", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93bb7fa4(4020040)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(713.67, 19.27, 1363.81)
	event.CmrsSetRef(727.45, 21.29, 1389.89)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4020050)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(758.44, 28.22, 1458.62)
	event.CmrsSetRef(743.05, 21.29, 1388.25)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "手をふる", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 716.1, 0.0, 1297.83, 90)
	event.StreamOpen3(1, 4020055)
	helper_e95ecf38(1)
	if vm.skipping() then
		return skip(11)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSetMotion(1, "はっ？！", 6)
	event.ObjsNextMotion(1, "はっ？！Ｌ", 4)
	helper_2f481f12(40)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamClose(1)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4020060)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSyncObj(0, 4.0, 22.0, 0.0, -2.2, 0.5, 50.0)
	event.ObjsSetPos(0, 561.8, -14.0, 1018.56)
	event.ObjsSetRot(0, 0.0, 0.48, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4020070)
	if vm.skipping() then
		return skip(15)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(16)
	end
	event.FadeOutBgm(30)
	event.EohSetFootSoundId(0, -1)
	event.EohSetFootSoundId(1, -1)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsPosDelay(0, 60)
	event.ObjsMove(0, 1065.83, 0.0, 1080.26, 230, 1)
	event.ObjsRotDelay(0, 60)
	event.ObjsRotation(0, 0.0, 1.44, 0.0, 10)
	event.ObjsMotionDelay(0, 59)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsMotionDelay(0, 1)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 230)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsPosDelay(1, 60)
	event.ObjsMove(1, 903.05, 0.0, 1267.1, 180)
	event.ObjsRotDelay(1, 60)
	event.ObjsRotation(1, 0.0, 2.06, 0.0, 10)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 180)
	event.ObjsSetMotion(1, "立ち")
	event.CmrsAhddelay(60)
	event.CmrsMoveAhd2(0.76, -1.0, 32.0, 30, 0, 1.0)
	helper_46b7514d(4020080, 200)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsReleaseObj()
	event.CmrsMove2(898.96, 88.81, 1079.93, 876.98, 128.35, 1056.64, 360, 1, 1.0)
	helper_46b7514d(4020090, 160)
	if vm.skipping() then
		return skip(18)
	end
	helper_46b7514d(4020100, 120)
	if vm.skipping() then
		return skip(19)
	end
	helper_46b7514d(4020110, 240)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

return helper_07ef4c54
