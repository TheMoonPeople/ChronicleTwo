--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b5edc9 = require("@lib/event/helper_09b5edc9")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_aa1ac59e = require("@lib/event/helper_aa1ac59e")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_ef2c87f2 = require("@lib/event/helper_ef2c87f2")
local helper_f1cdfb4a = require("@lib/event/helper_f1cdfb4a")

--- Helper function.
local function helper_f503d904()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_a0e17f3c(240)
			end
			if at <= 2 then
				helper_b35e85eb()
			end
			if at <= 3 then
				helper_a19c5ee3(0)
			end
			if at <= 4 then
				helper_f1cdfb4a(10280, -1, 10)
			end
			if at <= 5 then
				helper_f1cdfb4a(10285, -1, 10)
			end
			if at <= 6 then
				helper_aa1ac59e(1)
			end
			if at <= 7 then
				helper_a19c5ee3(0)
			end
			if at <= 8 then
				helper_a19c5ee3(0)
			end
			if at <= 9 then
				helper_ef2c87f2(0, -1, 8, 0, 0, 100)
			end
			if at <= 10 then
				helper_a19c5ee3(0)
			end
			if at <= 11 then
				helper_09b5edc9(10295, 60)
			end
			if at <= 12 then
				helper_a19c5ee3(0)
			end
			if at <= 13 then
				helper_a0e17f3c(10)
			end
			if at <= 14 then
				helper_a0e17f3c(30)
			end
			if at <= 15 then
				helper_b35e85eb()
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_a0e17f3c(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "目パチ")
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "目パチ")
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.EohSetFootSoundId(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.EohSetPos(4, 0.0, 0.0, 0.0)
		event.EohSetPos(5, 0.0, 0.0, 0.0)
		event.EohSetShow(5, 1)
		event.EohSetShow(11, 0)
		event.EohSetShow(12, 1)
		event.EohSetShow(13, 0)
		event.EohSetShow(14, 1)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(18)
		end
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.SetActiveLight(2)
	event.LoadBgm(46)
	event.PlayBgm(0, -1)
	event.LoadSound(1205)
	event.PlayEnvBgm(2)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch5_1.txt")
	var0 = event.SndLoadSound(1205) or var0
	event.LoadMotion(5, "event/opening/p1/p1_mints3.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 117.75, -0.02, -149.55)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "眠りL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "眠り目")
	event.ObjsTexAnime(0, 1, "眠り口")
	event.LoadChara(5, "event/opening/p1/clock.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 117.75, -0.02, -149.55)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "眠りL", 4)
	event.EohSyncObj(4, "p14_i01h01")
	event.EohSetShow(4, 1)
	event.EohSetPos(4, 6.0, 0.0, -6.0)
	event.EohSyncObj(5, "p15_i01h01")
	event.EohSetShow(5, 0)
	event.EohSyncObj(6, "p10_i01h01")
	event.EohSetShow(6, 0)
	event.EohSyncObj(7, "p11_i01h01")
	event.EohSetShow(7, 0)
	event.EohSyncObj(8, "p12_i01h01")
	event.EohSetShow(8, 1)
	event.EohSyncObj(9, "p16_i01h01")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p17_i01h01")
	event.EohSetShow(10, 0)
	event.EohSyncObj(11, "p09_i01h01", "i01h01_19-m0")
	event.EohSetShow(11, 1)
	event.EohSyncObj(12, "p09_i01h01", "i01h01_20-m0")
	event.EohSetShow(12, 0)
	event.EohSyncObj(13, "p09_i01h01", "i01h01_19-m1")
	event.EohSetShow(13, 0)
	event.EohSyncObj(14, "p09_i01h01", "i01h01_20-m1")
	event.EohSetShow(14, 1)
	event.StreamOpen3(1, 10275)
	helper_aa1ac59e(1)
	if vm.skipping() then
		return skip(1)
	end
	event.StreamPlay(1)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 33)
	event.ObjsSeDelay(0, 80)
	event.ObjsSePlay(0, var0, 33)
	event.ObjsSeDelay(0, 70)
	event.ObjsSePlay(0, var0, 33)
	event.CmrsInit()
	event.CmrsSetPos(65.26, 55.35, -105.97)
	event.CmrsSetRef(122.66, 18.15, -147.06)
	event.CmrsMove(83.15, 42.11, -118.77, 122.66, 18.15, -147.06, 300)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	helper_a0e17f3c(240)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "起きる", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSePlay(0, var0, 34)
	event.ObjsSeDelay(0, 58)
	event.ObjsSePlay(0, var0, 35)
	event.ObjsSetMotion(1, "起きる", 6)
	event.ObjsNextMotion(1, "起きるL", 4)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(3)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "しまった目1")
	event.StreamClose(1)
	event.SetPakuAnim(0, "通常口パク", "しまった口")
	helper_f1cdfb4a(10280, -1, 10)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(140.85, 35.61, -112.8)
	event.CmrsSetRef(124.35, 18.15, -148.12)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "しまった目2")
	event.ObjsSetMotion(0, "時計を見る", 6)
	event.ObjsNextMotion(0, "時計を見るL", 4)
	event.ObjsSetMotion(1, "時計を見る", 6)
	event.ObjsNextMotion(1, "時計を見るL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 36)
	event.SetPakuAnim(0, "通常口パク", "しまった口")
	helper_f1cdfb4a(10285, -1, 10)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.StreamOpen3(1, 10290)
	helper_aa1ac59e(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(8)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "立ち上がる", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(1, "立ち上がる", 6)
	event.ObjsSePlay(0, var0, 37)
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetFootSoundId(0, 10)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 100)
	event.ObjsAddPas(0, 134.46, -1.98, -103.03)
	event.ObjsAddPas(0, 123.03, -1.98, -87.26)
	event.ObjsAddPas(0, 101.92, 11.36, -89.62)
	event.ObjsAddPas(0, 82.14, 19.76, -87.16)
	event.ObjsAddPas(0, 73.3, 23.58, -87.13)
	event.ObjsAddPas(0, 50.27, 23.58, -84.67)
	event.ObjsAddPas(0, 46.6, 23.58, -75.68)
	event.ObjsAddPas(0, 52.24, 23.58, -61.6)
	event.ObjsAddPas(0, 65.4, 31.9, -58.93)
	event.ObjsAddPas(0, 75.19, 34.77, -60.48)
	event.ObjsAddPas(0, 90.17, 44.07, -59.42)
	event.ObjsAddPas(0, 103.03, 49.87, -58.95)
	event.ObjsAddPas(0, 114.25, 49.87, -45.23)
	event.ObjsAddPas(0, 115.21, 49.87, -24.8)
	event.ObjsStartPas(0)
	event.CmrsSetPos(84.39, 41.53, -180.36)
	event.CmrsSetRef(100.27, 28.67, -69.26)
	event.CmrsMove(25.83, 93.33, -175.38, 84.03, 62.87, -63.53, 100)
	event.ObjsTexAnime(0, 0, "しまった口")
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, 10290)
	helper_ef2c87f2(0, -1, 8, 0, 0, 100)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.StreamClose(1)
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.CmrsSetPos(107.28, 133.46, -74.73)
	event.CmrsSetRef(67.71, 60.83, 92.76)
	event.EohSetFootSoundId(0, 3)
	event.ObjsSetMotion(0, "右向き走り", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, 113.58, 51.83, -23.73)
	event.ObjsAddPas(0, 99.94, 56.88, 2.25)
	event.ObjsAddPas(0, 92.02, 56.87, 52.46)
	event.ObjsAddPas(0, 93.75, 56.87, 104.26)
	event.ObjsAddPas(0, 96.64, 51.0, 131.42)
	event.ObjsStartPas(0)
	event.CmrsAhddelay(20)
	event.CmrsSyncObj(0, 0.0, 23.0, 0.0, -1.0, 0.0, 40.0)
	event.CmrsAhddelay(40)
	event.CmrsReleaseObj()
	event.CmrsPrdelay(60)
	event.CmrsSetPos(45.96, 119.76, 60.89)
	event.CmrsSetRef(100.02, 63.83, 140.46)
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_09b5edc9(10295, 60)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "ドア開け", 6)
	event.ObjsSeDelay(0, 20)
	var1 = event.GetSndId(2) or var1
	event.ObjsSePlay(0, var1, 66)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(15)
	end
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_f503d904
