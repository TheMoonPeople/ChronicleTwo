--!strict
-- map/g/g03/g03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08c337b8 = require("@lib/event/helper_08c337b8")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_32dba483 = require("@lib/event/helper_32dba483")
local helper_3e566142 = require("@lib/event/helper_3e566142")
local helper_46b7514d = require("@lib/event/helper_46b7514d")
local helper_638d969d = require("@lib/event/helper_638d969d")
local helper_72334e82 = require("@lib/event/helper_72334e82")
local helper_72cb617b = require("@lib/event/helper_72cb617b")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_99d8be68 = require("@lib/event/helper_99d8be68")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e2020895 = require("@lib/event/helper_e2020895")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")
local helper_e95ecf38 = require("@lib/event/helper_e95ecf38")
local helper_fb54e09a = require("@lib/event/helper_fb54e09a")

--- Helper function.
local function helper_19bd8()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var1 = vm.f32(var1 + 30.0)
			var3 = var3 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 18)
	event.SetCharaPos(0, 2065.33, -14.0, -806.24)
	event.SetCharaRot(0, 0.0, -1.42, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(1962.84, 25.0, -888.26)
	event.SetFadeIn(30)
	event.ObjsMove(0, 1899.56, -14.0, -773.11, 40)
	var3 = 0
	while var3 < 40 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_196b0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var1 = vm.f32(var1 + 30.0)
			var3 = var3 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 14)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 1886.59, 0.0, 1431.76)
	event.SetCharaRot(0, 0.0, -2.06, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(1597.0, 30.85, 1279.41)
	event.SetFadeIn(30)
	event.ObjsMove(0, 1727.66, 0.0, 1341.11, 40)
	var3 = 0
	while var3 < 40 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	event.EohSetFootSoundId(0, 0)
end

--- Helper function.
local function helper_1c370()
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

--- Helper function.
local function helper_18678()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var1 = vm.f32(var1 + 30.0)
			var3 = var3 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.SetCharaPos(0, -691.6, 339.04, 2249.38)
	event.SetCharaRot(0, 0.0, 1.91, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(-454.66, 376.79, 2105.55)
	event.SetFadeIn(30)
	event.ObjsMove(0, -584.92, 320.0, 2221.56, 30, 1)
	var3 = 0
	while var3 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_1b5a8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(305) or var0
	return var0
end

--- Helper function.
local function helper_1bb28()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_1b5a8() == 0 then
		return 0
	end
	flag = event.GetFlag(448) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1be68()
	if helper_72334e82() ~= 0 then
		return 1
	end
	if helper_72cb617b() ~= 0 then
		return 1
	end
	if helper_1bb28() ~= 0 then
		return 1
	end
	if helper_08c337b8() ~= 0 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1bfcc(arg0: s32, arg1: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = event.GetChapter() or var5
	if var5 >= 8 then
		return
	end
	event.SetMesWindowMode(1, 8)
	event.SetMotion(0, "立ち")
	var6 = 1050
	if helper_1be68() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.MesMake_2(1, var6)
	helper_e2020895(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1c2e4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1bfcc(arg0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_1bfcc(arg0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1ab14()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e2020895(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var2)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(
		0,
		"C'[UNI00e9]tait quoi, ces bruits que je\nviens d'entendre ? Allons voir\ndans la grotte d'abord, OK ?"
	)
	helper_e2020895(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1a10c()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var0 = helper_fb54e09a(5, 64)
			end
			if at <= 2 then
				helper_2f481f12(10)
			end
			if at <= 3 then
				helper_2f481f12(30)
			end
			return 1
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_fb54e09a(5, 64)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(1800.16, 21.11, -758.98)
		event.CmrsSetRef(1958.18, 16.39, -784.17)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsSetPos(0, 1899.56, -14.0, -773.11)
		event.ObjsSetRot(0, 0.0, 1.73, 0.0)
		event.ObjsMove(0, 2107.33, -14.0, -805.09, 40)
		helper_2f481f12(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFadeOut(30)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(4)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var1)
		var5 = var2
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_18b94()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_2f481f12(20)
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_fb54e09a(5, 75)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(1635.73, 32.56, 1292.96)
		event.CmrsSetRef(1754.78, 30.0, 1358.67)
		event.ObjsSetPos(0, 1782.12, 0.0, 1373.78)
		event.ObjsSetRot(0, 0.0, 1.0, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 50)
		event.ObjsAddPas(0, 1782.12, 0.0, 1373.78)
		event.ObjsAddPas(0, 1825.81, 0.0, 1397.9)
		event.ObjsAddPas(0, 1906.73, 0.0, 1437.54)
		event.ObjsAddPas(0, 1986.2, 0.0, 1465.28)
		event.ObjsStartPas(0)
		helper_2f481f12(20)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.15)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.15)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_17c70()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_2f481f12(20)
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_fb54e09a(5, 83)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(-454.66, 376.79, 2105.55)
		event.CmrsSetRef(-706.43, 390.04, 2258.31)
		event.ObjsSetPos(0, -667.76, 328.93, 2241.58)
		event.ObjsSetRot(0, 0.0, -1.25, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1, 1)
		event.ObjsMove(0, -838.07, 378.91, 2297.28, 50)
		helper_2f481f12(20)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(1.88)) * 30.0) + var1)
		var5 = 326.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(1.88)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_10350(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_e2020895(0, -1, 5, 0, 0)
		end
		helper_99d8be68()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(
			0,
			"On a [UNI00e9]t[UNI00e9] propuls[UNI00e9]s dans le futur\npar la machine temporelle d'Ixion."
		)
	else
		event.MesMake_2(
			0,
			"On a r[UNI00e9]int[UNI00e9]gr[UNI00e9] le pr[UNI00e9]sent gr[UNI00e2]ce [UNI00e0]\nla machine temporelle d'Ixion."
		)
	end
	if vm.wait() then
		return skip(3)
	end
	helper_e2020895(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_99d8be68()
end

--- Helper function.
local function helper_10908(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_b027b809()
			end
			if at <= 2 then
				helper_638d969d()
			end
			if at <= 3 then
				helper_2f481f12(30)
			end
			if at <= 4 then
				helper_e8f4b85c(0)
			end
			if at <= 5 then
				helper_638d969d()
			end
			if at <= 6 then
				helper_e8f4b85c(6)
			end
			if at <= 7 then
				helper_2f481f12(60)
			end
			if at <= 8 then
				helper_2f481f12(60)
			end
			if at <= 9 then
				helper_10350(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_b027b809()
	if vm.skipping() then
		return skip(2)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_e8f4b85c(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_10350(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_17414(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10908(arg0, arg1, arg2, arg3, 1, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_10908(arg0, arg1, arg2, arg3, 1, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_10908(arg0, arg1, arg2, arg3, 1, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_21858()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_2f481f12(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1f61c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_e8f4b85c(1)
			end
			if at <= 2 then
				helper_2f481f12(10)
			end
			if at <= 3 then
				helper_93bb7fa4(4040350)
			end
			if at <= 4 then
				helper_b027b809()
			end
			if at <= 5 then
				helper_93bb7fa4(4040360)
			end
			if at <= 6 then
				helper_93bb7fa4(4040370)
			end
			if at <= 7 then
				helper_2f481f12(10)
			end
			if at <= 8 then
				helper_2f481f12(20)
			end
			if at <= 9 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		if at <= 11 then
			helper_2f481f12(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.LoadSound(4000)
		event.StopBgm(0)
		helper_2f481f12(4)
		if vm.skipping() then
			return skip(12)
		end
		event.LoadBgm(3)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.SetMotion(0, "立ち")
		event.SetCharaPos(0, 1733.3, 0.0, -301.5)
		event.SetCharaRot(0, 0.0, 2.76, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(404, 1)
	event.Initialize()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e400/e404/")
	event.LoadMes(0, 5, "e404_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e404_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e404_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e404_shigu.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e404/e404_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e404/e404_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 1580.54, 0.0, 1092.15)
	event.EohSetRot(0, 0.0, -2.4, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 1501.84, 0.0, 1069.09)
	event.EohSetRot(1, 0.0, -2.64, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 1891.0, -14.0, -716.0)
	event.EohSetRot(2, 0.0, 2.16, 0.0)
	event.ObjsMove(0, 1424.62, 0.0, 938.48, 46)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 46)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 1401.25, 0.0, 947.01, 36)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 36)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, -0.96, 0.0, 8)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(846.73, 268.48, 883.94)
	event.CmrsSetRef(1289.42, 146.71, 951.29)
	event.SetFadeIn(30)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "指さす", 2)
	event.ObjsNextMotion(0, "指さすL", 6)
	event.ObjsRotDelay(1, 4)
	event.ObjsRotation(1, 0.0, 2.2, 0.0, 10)
	event.CmrsMove2(1059.22, 268.48, 1339.51, 1289.42, 146.71, 951.29, 30, 0, 1.0)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 90)
	event.ObjsAddPas(2, 1787.63, -14.0, -561.29)
	event.ObjsAddPas(2, 1891.0, -14.0, -716.0)
	event.ObjsAddPas(2, 2049.12, -14.0, -873.59)
	event.ObjsAddPas(2, 2149.2, -14.0, -954.9)
	event.ObjsAddPas(2, 2250.94, -14.0, -1018.67)
	event.ObjsStartPas(2)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4040350)
	if vm.skipping() then
		return skip(4)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1404.09, 22.36, 896.46)
	event.CmrsSetRef(1422.53, 17.33, 974.51)
	event.ObjsSetRot(0, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4040360)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4040370)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsMove(0, 1530.85, 0.0, 826.72, 60)
	event.ObjsSetMotion(0, "走り")
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(1, 1507.06, 0.0, 850.62, 70)
	event.ObjsSetMotion(1, "走り")
	helper_2f481f12(20)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_3e566142

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local var5: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			helper_32dba483(-140.0, 165.0, 1865.0, vm.f32(2.28))
			var3 = 1
			helper_196b0()
		end
		if at <= 2 then
			var3 = 1
			helper_1c370()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_18678()
		end
		if at <= 4 then
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_18678()
		end
		if at <= 5 then
			helper_1c2e4(1)
		end
	end
	function part2()
		helper_1c2e4(1)
		if vm.skipping() then
			return skip(6)
		end
	end
	function landing1()
		return part2()
	end
	helper_3e566142()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_32dba483(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
		event.ResetCamera(1, 0.0, 10.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		print("old_map = ", old_map_no, "\n")
		print("old_map_type = ", var2, "\n")
		if var2 ~= -1 then
			if var2 == 7 or var2 == 8 or old_map_no == 84 then
				helper_19bd8()
				if vm.skipping() then
					return skip(1)
				end
			else
				var3 = 0
				if old_map_no == 82 then
					helper_32dba483(-140.0, 165.0, 1865.0, vm.f32(2.28))
					event.ResetCamera(1, 0.0, 10.0)
					event.SetFadeIn(30)
					var3 = 1
				end
				if old_map_no == 75 then
					helper_196b0()
					if vm.skipping() then
						return skip(2)
					end
					var3 = 1
				end
				old_sub_map_no = event.GetOldSubmapNo() or old_sub_map_no
				var5 = event.GetMapType(old_sub_map_no) or var5
				if var3 == 0 and not (old_map_no == 2 and var5 == 2) then
					flag = event.GetFlag(402) or flag
					flag_2 = event.GetFlag(360) or flag_2
					if flag == 0 and flag_2 == 1 then
						helper_1c370()
						if vm.skipping() then
							return skip(3)
						end
					else
						helper_18678()
						if vm.skipping() then
							return skip(4)
						end
					end
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
			if 0 <= get_old_interior_map_no then
			else
				helper_18678()
				if vm.skipping() then
					return skip(5)
				end
			end
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_18678()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 201.
script[201] = function()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var7: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1a10c()
		end
		if at <= 3 then
			helper_19bd8()
		end
	end
	flag = event.GetFlag(404) or flag
	if flag == 0 then
		helper_1ab14()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_1a10c()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.DngSetStageId(3)
			event.GotoMenu(3, 3)
			if vm.wait() then
				return skip(3)
			end
			do
				local _, out2, out3, _ = event.GetMenuParam_4()
				var2 = out2 or var2
				var3 = out3 or var3
			end
			if var3 == 0 then
				helper_19bd8()
				if vm.skipping() then
					return skip(4)
				end
				return
			end
			if var3 == 20 then
				flag_2 = event.GetFlag(438) or flag_2
				flag_3 = event.GetFlag(444) or flag_3
				if flag_2 == 1 and flag_3 == 0 then
					event.GotoDng(3, var3, 1010)
				else
					var2 = 3
					var3 = 20
					var7 = event.GetFloorInfo(var2, var3, 7) or var7
					var7 = vm.i32(var7 + 1)
					event.SetFloorInfo(var2, var3, 7, var7)
					event.MapJump(-1, "d04b01", 100)
				end
			else
				flag_4 = event.GetFlag(406) or flag_4
				flag_5 = event.GetFlag(424) or flag_5
				if var3 == 2 and flag_4 == 0 or var3 == 17 and flag_5 == 0 or var3 == 19 then
					event.BgmLoadCancel()
				end
				event.GotoDng(3, var3, 1010)
			end
		end
	end
end

--- Program 202.
script[202] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_18b94()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(404) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump(-1, "s27")
	end
end

--- Program 203.
script[203] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_17c70()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s09")
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17414(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c2e4(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_21858()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	helper_1f61c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 1425.7, 0.0, 1034.8)
	event.SetCharaRot(0, 0.0, -2.37, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
end

--- Program 520.
script[520] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_1b5a8()
			helper_e2020895(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_1c2e4(1)
		end
	end
	helper_3e566142()
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, -140.0, 165.0, 1800.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
	var0 = helper_1b5a8()
	if var0 == 0 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "[(!)]Pour avancer, remplis les conditions\nG[UNI00e9]orama et ranime le Labo central.")
		helper_e2020895(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesPreset(0, 0)
	end
	helper_1c2e4(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14020.
script[14020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	helper_1c370()
	if vm.skipping() then
		return skip(1)
	end
end

return script
