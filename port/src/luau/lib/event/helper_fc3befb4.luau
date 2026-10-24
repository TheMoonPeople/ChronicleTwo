--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_097407fc = require("@lib/event/helper_097407fc")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_31f43910 = require("@lib/event/helper_31f43910")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_fc3befb4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_31f43910(10010, -1, 10)
			end
			if at <= 2 then
				helper_31f43910(10020, -1, 20)
			end
			if at <= 3 then
				helper_31f43910(10030, -1, 10)
			end
			if at <= 4 then
				helper_5fe8f3bb()
			end
			if at <= 5 then
				helper_097407fc(1)
			end
			if at <= 6 then
				helper_b0211f82(30)
			end
			if at <= 7 then
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_5fe8f3bb()
			end
			if at <= 8 then
				helper_126faf7c(0)
			end
			if at <= 9 then
				helper_126faf7c(0)
			end
			if at <= 10 then
				helper_b0211f82(60)
			end
			if at <= 11 then
				helper_7e2956fd(0)
				helper_b0211f82(70)
			end
			if at <= 12 then
				helper_b0211f82(60)
			end
			if at <= 13 then
				helper_126faf7c(0)
			end
			if at <= 14 then
				helper_b0211f82(60)
			end
			if at <= 15 then
				helper_5fe8f3bb()
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_b0211f82(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndInReverb(1)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.CharaActive(1, 0)
		event.SetRain(0)
		event.StopEnvBgm()
		event.StopBgm(0)
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(18)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetTimeStepEnable(0)
	event.SetTime(24)
	event.SetMesWindowMode(0, 0)
	event.LoadSound(1200)
	event.LoadBgm(100)
	event.StopBgm(0)
	event.StopEnvBgm()
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/opening/p1/")
	event.LoadMes(0, 5, "op1ch1_1.txt")
	event.LoadMotion(5, "p1_mints1.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "p1_donnie_h.gltf", "info", 32)
	event.CharaActive(32)
	event.EohSyncChara(1, 32)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "p1_boy_h.gltf", "info", 33)
	event.CharaActive(33)
	event.EohSyncChara(2, 33)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "p1_ojisan_h.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(3, 34)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "p1_onna_h.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "p1_otoko_h.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.EohSetPos(0, -548.51, 0.0, 56.09)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 22)
	event.EohSetPos(1, -604.02, 0.0, 282.4)
	event.EohSetPos(2, 209.56, 0.0, -98.72)
	event.EohSetPos(3, 189.56, 0.0, -120.72)
	event.EohSetPos(4, -393.3, 4.07, 148.39)
	event.EohSetPos(5, 161.13, 0.0, -7.01)
	event.EohSetFootSoundId(1, -1)
	event.EohSetFootSoundId(2, -1)
	event.EohSetFootSoundId(3, -1)
	event.EohSetFootSoundId(4, -1)
	event.EohSetFootSoundId(5, -1)
	event.SetRain(0)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 10000.0, 0.0)
	event.CmrsSetRef(0.0, 10000.0, 0.0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(1)
	event.SndInReverb(0)
	helper_31f43910(10010, -1, 10)
	if vm.skipping() then
		return skip(2)
	end
	helper_31f43910(10020, -1, 20)
	if vm.skipping() then
		return skip(3)
	end
	helper_31f43910(10030, -1, 10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndInReverb(1)
	event.SpriteSetDraw(0, 0)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(1)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesWindowMode(0, 7)
	event.StreamOpen3(1, 10040)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目")
	event.ObjsTexAnime(0, 1, "口半開き")
	event.SetRainCharaNo(0)
	event.SetRain(1)
	event.PlayBgm(0)
	event.PlayEnvBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(152.13, 71.52, -25.06)
	event.CmrsSetRef(-217.76, 200.86, -36.82)
	event.CmrsMove(152.13, 71.52, -25.06, -217.76, 28.14, -36.82, 350)
	event.CmrsFadeInit()
	event.CmrsFadeIn(300)
	event.ObjsSetMotion(0, "走り")
	event.ObjsPosDelay(0, 60)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 260)
	event.ObjsAddPas(0, -548.51, 0.0, 56.09)
	event.ObjsAddPas(0, -353.41, 0.0, 2.28)
	event.ObjsAddPas(0, -186.76, 0.0, -36.95)
	event.ObjsAddPas(0, -68.92, 0.0, -47.91)
	event.ObjsAddPas(0, 64.69, 0.0, -50.33)
	event.ObjsAddPas(0, 99.26, 0.0, -48.9)
	event.ObjsStartPas(0)
	event.ObjsPosDelay(1, 150)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 200)
	event.ObjsAddPas(1, -604.02, 0.0, 282.4)
	event.ObjsAddPas(1, -597.62, 0.0, 201.5)
	event.ObjsAddPas(1, -568.27, 0.0, 141.24)
	event.ObjsAddPas(1, -482.55, 0.0, 66.48)
	event.ObjsAddPas(1, -378.18, 0.0, -17.81)
	event.ObjsAddPas(1, -247.73, 0.0, -40.97)
	event.ObjsStartPas(1)
	event.ObjsPosDelay(2, 50)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 300)
	event.ObjsAddPas(2, 209.56, 0.0, -98.72)
	event.ObjsAddPas(2, 96.96, 0.0, -106.0)
	event.ObjsAddPas(2, -1.93, 0.0, -108.11)
	event.ObjsAddPas(2, -137.39, 0.0, -96.24)
	event.ObjsAddPas(2, -305.14, 0.0, -67.27)
	event.ObjsAddPas(2, -417.37, 0.0, -35.83)
	event.ObjsAddPas(2, -581.83, 0.0, 21.11)
	event.ObjsStartPas(2)
	event.ObjsPosDelay(3, 50)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 300)
	event.ObjsAddPas(3, 189.56, 0.0, -120.72)
	event.ObjsAddPas(3, 76.96, 0.0, -128.0)
	event.ObjsAddPas(3, -21.93, 0.0, -130.11)
	event.ObjsAddPas(3, -157.39, 0.0, -118.24)
	event.ObjsAddPas(3, -325.14, 0.0, -89.27)
	event.ObjsAddPas(3, -437.37, 0.0, -57.83)
	event.ObjsAddPas(3, -601.83, 0.0, -0.8899994)
	event.ObjsStartPas(3)
	event.ObjsPosDelay(4, 50)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 300)
	event.ObjsAddPas(4, -393.3, 4.07, 148.39)
	event.ObjsAddPas(4, -207.09, 4.07, 97.91)
	event.ObjsAddPas(4, -35.64, 4.07, 69.42)
	event.ObjsAddPas(4, 208.95, 4.07, 41.39)
	event.ObjsAddPas(4, 416.81, 4.07, 31.22)
	event.ObjsStartPas(4)
	event.ObjsPosDelay(5, 230)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 120)
	event.ObjsAddPas(5, 161.13, 0.0, -7.01)
	event.ObjsAddPas(5, 31.18, 0.0, -12.31)
	event.ObjsAddPas(5, -112.55, 0.0, -3.64)
	event.ObjsAddPas(5, -228.66, 0.0, 12.44)
	event.ObjsStartPas(5)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 10040)
	event.SetMesOkuri(0, 0)
	helper_dc39b923(0, -1, 8, 0, 0)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(8)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(60)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 64.69, 0.0, -50.33)
	event.ObjsAddPas(0, 195.57, 0.0, -50.59)
	event.ObjsAddPas(0, 314.04, 0.0, -37.39)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, -247.73, 0.0, -40.97)
	event.ObjsAddPas(1, -128.03, 0.0, -59.51)
	event.ObjsAddPas(1, 0.44, 0.0, -67.61)
	event.ObjsAddPas(1, 62.04, 0.0, -66.75)
	event.ObjsStartPas(1)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 540)
	event.ObjsAddPas(2, -581.83, 0.0, 21.11)
	event.ObjsAddPas(2, -689.37, 0.0, 64.97)
	event.ObjsAddPas(2, -740.32, 16.56, 86.78)
	event.ObjsAddPas(2, -1049.71, 16.56, 202.43)
	event.ObjsAddPas(2, -1121.47, 2.23, 228.69)
	event.ObjsAddPas(2, -1330.22, 2.23, 272.91)
	event.ObjsAddPas(2, -1574.35, 2.23, 301.23)
	event.ObjsAddPas(2, -1735.92, 41.05, 301.29)
	event.ObjsAddPas(2, -1920.9, 109.04, 240.05)
	event.ObjsStartPas(2)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 540)
	event.ObjsAddPas(3, -601.83, 0.0, -0.8899994)
	event.ObjsAddPas(3, -709.37, 0.0, 42.97)
	event.ObjsAddPas(3, -760.32, 16.56, 64.78)
	event.ObjsAddPas(3, -1069.71, 16.56, 180.43)
	event.ObjsAddPas(3, -1141.47, 2.23, 206.69)
	event.ObjsAddPas(3, -1350.22, 2.23, 250.91)
	event.ObjsAddPas(3, -1594.35, 2.23, 279.23)
	event.ObjsAddPas(3, -1755.92, 41.05, 279.29)
	event.ObjsAddPas(3, -1940.9, 109.04, 218.05)
	event.ObjsStartPas(3)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 200)
	event.ObjsAddPas(5, -228.66, 0.0, 12.44)
	event.ObjsAddPas(5, -426.83, 0.0, 71.19)
	event.ObjsAddPas(5, -572.44, 0.0, 154.92)
	event.ObjsAddPas(5, -596.78, 0.0, 222.11)
	event.ObjsAddPas(5, -626.03, 0.0, 308.82)
	event.ObjsStartPas(5)
	event.CmrsSyncObj(0, 5.0, 20.0, 0.0, 1.88, -15.0, 45.0)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsReleaseObj()
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 200)
	event.ObjsAddPas(0, 314.04, 0.0, -37.39)
	event.ObjsAddPas(0, 467.75, 0.0, -7.6)
	event.ObjsAddPas(0, 521.55, 0.0, 26.4)
	event.ObjsAddPas(0, 544.99, 0.0, 49.43)
	event.ObjsAddPas(0, 549.06, 3.84, 89.43)
	event.ObjsAddPas(0, 543.57, 4.07, 127.02)
	event.ObjsAddPas(0, 527.1, 4.07, 147.59)
	event.ObjsAddPas(0, 505.16, 19.83, 153.79)
	event.ObjsAddPas(0, 463.28, 49.29, 156.8)
	event.ObjsAddPas(0, 357.41, 52.0, 153.32)
	event.ObjsStartPas(0, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 200)
	event.ObjsAddPas(1, 62.04, 0.0, -66.75)
	event.ObjsAddPas(1, 264.77, 0.0, -59.78)
	event.ObjsAddPas(1, 530.28, 0.0, -36.96)
	event.ObjsAddPas(1, 667.84, 0.0, -20.07)
	event.ObjsStartPas(1)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 180)
	event.ObjsAddPas(4, 649.53, 4.07, 66.43)
	event.ObjsAddPas(4, 531.84, 4.07, 42.39)
	event.ObjsAddPas(4, 374.58, 4.07, 15.26)
	event.ObjsAddPas(4, 292.84, 4.07, -11.21)
	event.ObjsAddPas(4, 250.8, 4.07, -75.74)
	event.ObjsAddPas(4, 236.93, 4.07, -104.61)
	event.ObjsStartPas(4)
	event.CmrsSetPos(716.83, 119.9, -60.37)
	event.CmrsSetRef(504.52, 49.88, 41.63)
	event.SetRainCharaNo(0)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsMove2(716.83, 119.9, -60.37, 476.49, 49.88, 99.17, 200, 1, 1.0)
	event.StreamClose(1)
	helper_7e2956fd(0)
	event.SetMesOkuri(0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	helper_b0211f82(70)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(0, 2)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SetRainCharaNo(-1)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "ドア開け", 2)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(15)
	end
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 66)
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_fc3befb4
