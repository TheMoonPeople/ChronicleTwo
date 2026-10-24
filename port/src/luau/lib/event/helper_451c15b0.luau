--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_097407fc = require("@lib/event/helper_097407fc")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_2d5c6a8c = require("@lib/event/helper_2d5c6a8c")
local helper_2f47f9eb = require("@lib/event/helper_2f47f9eb")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_6e94ffcc = require("@lib/event/helper_6e94ffcc")
local helper_7d8cc2b5 = require("@lib/event/helper_7d8cc2b5")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_9b390ef3 = require("@lib/event/helper_9b390ef3")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_451c15b0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 126 then
			if at <= 1 then
				helper_9b390ef3()
			end
			if at <= 2 then
				helper_097407fc(1)
			end
			if at <= 3 then
				helper_126faf7c(4)
			end
			if at <= 4 then
				helper_126faf7c(5)
			end
			if at <= 5 then
				helper_126faf7c(6)
			end
			if at <= 6 then
				helper_b0211f82(50)
			end
			if at <= 7 then
				helper_126faf7c(0)
			end
			if at <= 8 then
				helper_126faf7c(4)
			end
			if at <= 9 then
				helper_126faf7c(5)
			end
			if at <= 10 then
				helper_126faf7c(6)
			end
			if at <= 11 then
				helper_5fe8f3bb()
			end
			if at <= 12 then
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_126faf7c(0)
			end
			if at <= 13 then
				helper_5fe8f3bb()
			end
			if at <= 14 then
				helper_b0211f82(10)
			end
			if at <= 15 then
				helper_b0211f82(30)
			end
			if at <= 16 then
				helper_7e2956fd(0)
				helper_b0211f82(30)
			end
			if at <= 17 then
				helper_126faf7c(0)
			end
			if at <= 18 then
				helper_b0211f82(30)
			end
			if at <= 19 then
				helper_b0211f82(50)
			end
			if at <= 20 then
				helper_b0211f82(20)
			end
			if at <= 21 then
				helper_126faf7c(0)
			end
			if at <= 23 then
				helper_b0211f82(120)
			end
			if at <= 24 then
				helper_5fe8f3bb()
			end
			if at <= 25 then
				helper_126faf7c(0)
			end
			if at <= 26 then
				helper_9b390ef3()
			end
			if at <= 27 then
				helper_126faf7c(5)
			end
			if at <= 29 then
				helper_2d5c6a8c(50020, -1, 10)
			end
			if at <= 30 then
				helper_126faf7c(0)
			end
			if at <= 31 then
				helper_126faf7c(0)
			end
			if at <= 32 then
				helper_126faf7c(0)
			end
			if at <= 33 then
				helper_b0211f82(46)
			end
			if at <= 34 then
				helper_5fe8f3bb()
			end
			if at <= 35 then
				helper_126faf7c(4)
			end
			if at <= 36 then
				helper_126faf7c(4)
			end
			if at <= 37 then
				helper_b0211f82(40)
			end
			if at <= 38 then
				helper_126faf7c(4)
			end
			if at <= 39 then
				helper_b0211f82(45)
			end
			if at <= 40 then
				helper_2d5c6a8c(50030, -1, 0)
			end
			if at <= 41 then
				helper_5fe8f3bb()
			end
			if at <= 42 then
				helper_b0211f82(30)
			end
			if at <= 43 then
				helper_b0211f82(5)
			end
			if at <= 44 then
				helper_126faf7c(0)
			end
			if at <= 45 then
				helper_b0211f82(40)
			end
			if at <= 46 then
				helper_b0211f82(65)
			end
			if at <= 47 then
				helper_b0211f82(20)
			end
			if at <= 48 then
				var2 = 0
				var3 = 2.0
			end
			if at <= 49 then
				var3 = vm.f32(var3 + vm.f32(0.1))
				var5 = vm.f32(var5 - var3)
				var2 = var2 + 1
				helper_126faf7c(0)
			end
			if at <= 50 then
				helper_b0211f82(30)
			end
			if at <= 51 then
				helper_9b390ef3()
			end
			if at <= 52 then
				helper_2d5c6a8c(50040, -1, 10)
			end
			if at <= 53 then
				helper_126faf7c(0)
			end
			if at <= 54 then
				helper_b0211f82(40)
			end
			if at <= 55 then
				helper_126faf7c(2)
			end
			if at <= 56 then
				helper_5fe8f3bb()
			end
			if at <= 58 then
				helper_2d5c6a8c(50050, -1, 10)
			end
			if at <= 60 then
				helper_2d5c6a8c(50060, -1, 10)
			end
			if at <= 61 then
				helper_126faf7c(3)
			end
			if at <= 63 then
				helper_2d5c6a8c(50070, -1, 10)
			end
			if at <= 64 then
				helper_126faf7c(0)
			end
			if at <= 65 then
				helper_2d5c6a8c(50080, -1, 10)
			end
			if at <= 66 then
				helper_2d5c6a8c(50090, -1, 10)
			end
			if at <= 67 then
				helper_126faf7c(0)
			end
			if at <= 68 then
				helper_b0211f82(60)
			end
			if at <= 69 then
				helper_b0211f82(60)
			end
			if at <= 70 then
				helper_2d5c6a8c(50100, -1, 10)
			end
			if at <= 71 then
				helper_126faf7c(0)
			end
			if at <= 72 then
				helper_2d5c6a8c(50110, -1, 10)
			end
			if at <= 74 then
				helper_9b390ef3()
			end
			if at <= 75 then
				helper_126faf7c(0)
			end
			if at <= 76 then
				helper_2d5c6a8c(50120, -1, 10)
			end
			if at <= 77 then
				helper_126faf7c(3)
			end
			if at <= 79 then
				helper_2d5c6a8c(50130, -1, 10)
			end
			if at <= 81 then
				helper_2d5c6a8c(50140, -1, 10)
			end
			if at <= 82 then
				helper_126faf7c(3)
			end
			if at <= 83 then
				helper_b0211f82(30)
			end
			if at <= 84 then
				helper_5fe8f3bb()
			end
			if at <= 85 then
				helper_5fe8f3bb()
			end
			if at <= 86 then
				helper_126faf7c(0)
			end
			if at <= 87 then
				helper_126faf7c(2)
			end
			if at <= 88 then
				helper_126faf7c(0)
			end
			if at <= 89 then
				helper_b0211f82(20)
			end
			if at <= 90 then
				helper_126faf7c(0)
			end
			if at <= 91 then
				helper_b0211f82(10)
			end
			if at <= 92 then
				helper_b0211f82(16)
			end
			if at <= 93 then
				helper_126faf7c(2)
			end
			if at <= 94 then
				helper_126faf7c(2)
			end
			if at <= 95 then
				helper_7d8cc2b5(0)
				helper_126faf7c(0)
			end
			if at <= 96 then
				helper_b0211f82(10)
			end
			if at <= 97 then
				helper_b0211f82(5)
			end
			if at <= 98 then
				helper_126faf7c(2)
			end
			if at <= 99 then
				helper_126faf7c(0)
			end
			if at <= 100 then
				helper_b0211f82(20)
			end
			if at <= 101 then
				helper_b0211f82(10)
			end
			if at <= 102 then
				helper_126faf7c(0)
			end
			if at <= 103 then
				helper_b0211f82(50)
			end
			if at <= 104 then
				helper_126faf7c(2)
			end
			if at <= 105 then
				helper_126faf7c(0)
			end
			if at <= 107 then
				helper_2d5c6a8c(50150, -1, 10)
			end
			if at <= 108 then
				helper_b0211f82(10)
			end
			if at <= 109 then
				helper_126faf7c(0)
			end
			if at <= 110 then
				helper_b0211f82(30)
			end
			if at <= 111 then
				helper_126faf7c(0)
			end
			if at <= 112 then
				helper_2d5c6a8c(50160, -1, 10)
			end
			if at <= 113 then
				helper_097407fc(1)
			end
			if at <= 114 then
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_6e94ffcc(0, 40)
			end
			if at <= 115 then
				helper_7e2956fd(0)
				helper_126faf7c(0)
			end
			if at <= 116 then
				helper_7d8cc2b5(1)
				var0 = helper_2f47f9eb(1)
			end
			if at <= 117 then
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_6e94ffcc(0, vm.i32(40 - var0))
			end
			if at <= 118 then
				helper_7e2956fd(0)
				helper_126faf7c(0)
			end
			if at <= 119 then
				helper_b0211f82(30)
			end
			if at <= 120 then
				helper_126faf7c(5)
			end
			if at <= 121 then
				helper_b0211f82(35)
			end
			if at <= 122 then
				helper_126faf7c(2)
			end
			if at <= 123 then
				helper_126faf7c(2)
			end
			if at <= 124 then
				helper_b0211f82(10)
			end
			if at <= 125 then
				helper_126faf7c(2)
			end
			if vm.skip_end() then
				return skip(127)
			end
			return part2()
		end
		if at <= 127 then
			helper_b0211f82(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SoundAllStop()
		event.StreamClose(1)
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(128)
		end
		event.ObjsInit(7)
		event.EohSetShadow(0, 1)
		event.CharaActive(1, 0)
		event.CharaDaEnable(0, 1)
		event.ShadowClipOff(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetProjection(618.0)
	event.SetTime(24.0)
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1220)
	var1 = event.SndLoadSound(1220) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p5/op5_1.txt")
	event.ShadowClipOff(0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2164.03, 0.0, 1594.92)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.LoadItem(5, 1, "info", 9)
	event.CharaActive(0, 9)
	event.SetReference(0, "ef00", 9)
	event.LoadChara(5, "event/opening/p5/p5_halloween.gltf", "p00_10a", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.EohSetSoundId(2, var1)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.LoadChara(5, "event/opening/p5/p5_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetFrameShow(3, "sashi", 0)
	event.EohSetFrameShow(3, "cube61_8", 1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.SetReference(10, "polcurse", 11)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.SetCharaPos(15, 308.06, 343.64, 99.37)
	event.SetMotion(15, "発動", 5)
	event.AssignStack(6)
	event.ClearStack(6)
	event.SetLoadbgFile("event/opening/p5/p5_pierrot.gltf")
	if vm.wait() then
		return skip(1)
	end
	helper_9b390ef3()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadChara(6, "event/opening/p5/p5_pierrot.gltf", "info", 12)
	event.ShadowClipOff(12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2236.22, 0.0, 1698.15)
	event.ObjsSetRot(4, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(4, "走り", 4)
	event.LoadChara(6, "event/opening/p5/p5_pierrot.gltf", "info", 13)
	event.CharaActive(13)
	event.ShadowClipOff(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 2135.85, 0.0, 1705.51)
	event.ObjsSetRot(5, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(5, "走り", 4, 0.9)
	event.ObjsSetMotionNowTime(5, 4.5)
	event.AssignStack(7)
	event.ClearStack(7)
	event.LoadChara(7, "event/opening/p5/p5_pierrot.gltf", "info", 14)
	event.CharaActive(14)
	event.ShadowClipOff(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 2135.85, 0.0, 1705.51)
	event.ObjsSetRot(6, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(6, "走り", 4, 0.9)
	event.ObjsSetMotionNowTime(6, 9.9)
	event.EohSyncChrobj(7, 10, "cube39")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsRotation(7, 0.0, -0.02, 0.0, -1)
	event.LoadMotion(7, "event/opening/p5/p5_mints2.gltf", "info", 0)
	event.LoadMotion(7, "event/opening/p5/p5_mints1.gltf", "info", 0)
	event.StreamOpen3(1, 50015)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り改", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 140)
	event.ObjsAddPas(0, 2164.03, 0.0, 1594.92)
	event.ObjsAddPas(0, 2122.87, 0.0, 1460.45)
	event.ObjsAddPas(0, 2071.67, 0.0, 1410.58)
	event.ObjsAddPas(0, 1985.11, 0.0, 1391.41)
	event.ObjsAddPas(0, 1908.12, 0.0, 1401.38)
	event.ObjsAddPas(0, 1822.53, 0.0, 1420.07)
	event.ObjsAddPas(0, 1735.11, 0.0, 1420.08)
	event.ObjsAddPas(0, 1612.33, 0.0, 1420.08)
	event.ObjsAddPas(0, 1506.42, 0.0, 1420.08)
	event.ObjsStartPas(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目（常）（１）")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsPosDelay(4, 40)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 130)
	event.ObjsAddPas(4, 2236.22, 0.0, 1698.15)
	event.ObjsAddPas(4, 2139.75, 0.0, 1506.54)
	event.ObjsAddPas(4, 2045.23, 0.0, 1408.76)
	event.ObjsAddPas(4, 1922.9, 0.0, 1402.03)
	event.ObjsAddPas(4, 1825.52, 0.0, 1400.38)
	event.ObjsAddPas(4, 1549.05, 0.0, 1405.64)
	event.ObjsStartPas(4)
	event.ObjsPosDelay(5, 40)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 130)
	event.ObjsAddPas(5, 2135.85, 0.0, 1705.51)
	event.ObjsAddPas(5, 2129.38, 0.0, 1636.95)
	event.ObjsAddPas(5, 2062.06, 0.0, 1503.78)
	event.ObjsAddPas(5, 2003.76, 0.0, 1459.44)
	event.ObjsAddPas(5, 1907.9, 0.0, 1441.22)
	event.ObjsAddPas(5, 1660.93, 0.0, 1435.68)
	event.ObjsStartPas(5)
	event.ObjsPosDelay(6, 40)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 130)
	event.ObjsAddPas(6, 2196.65, 0.0, 1808.46)
	event.ObjsAddPas(6, 2196.65, 0.0, 1758.46)
	event.ObjsAddPas(6, 2174.16, 0.0, 1610.78)
	event.ObjsAddPas(6, 2111.42, 0.0, 1507.12)
	event.ObjsAddPas(6, 2029.71, 0.0, 1437.84)
	event.ObjsAddPas(6, 1908.27, 0.0, 1415.33)
	event.ObjsAddPas(6, 1761.97, 0.0, 1416.2)
	event.ObjsStartPas(6)
	event.CmrsInit()
	event.CmrsSetPos(1552.66, 36.93, 1420.08)
	event.CmrsSetRef(2123.16, 3.69, 1420.08)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_126faf7c(4)
	if vm.skipping() then
		return skip(4)
	end
	helper_126faf7c(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_126faf7c(6)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(1225.16, 107.56, 716.67)
	event.CmrsSetRef(1303.88, 28.72, 938.86)
	event.CmrsMove(1247.41, 86.29, 779.48, 1303.88, 28.72, 938.86, 100)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 100)
	event.ObjsAddPas(0, 1417.18, 0.0, 1383.41)
	event.ObjsAddPas(0, 1377.2, 0.0, 1303.36)
	event.ObjsAddPas(0, 1332.84, 0.0, 1141.9)
	event.ObjsAddPas(0, 1311.76, 0.0, 966.89)
	event.ObjsAddPas(0, 1294.56, 0.0, 858.68)
	event.ObjsStartPas(0)
	helper_b0211f82(50)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 50)
	event.ObjsAddPas(4, 1502.4, 0.0, 1397.74)
	event.ObjsAddPas(4, 1418.3, 0.0, 1351.17)
	event.ObjsAddPas(4, 1375.12, 0.0, 1272.42)
	event.ObjsStartPas(4)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 50)
	event.ObjsAddPas(5, 1547.87, 0.0, 1488.3)
	event.ObjsAddPas(5, 1421.49, 0.0, 1416.47)
	event.ObjsAddPas(5, 1367.47, 0.0, 1333.44)
	event.ObjsStartPas(5)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 50)
	event.ObjsAddPas(6, 1585.91, 0.0, 1458.95)
	event.ObjsAddPas(6, 1499.65, 0.0, 1453.35)
	event.ObjsAddPas(6, 1430.66, 0.0, 1417.08)
	event.ObjsStartPas(6)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_126faf7c(4)
	if vm.skipping() then
		return skip(9)
	end
	helper_126faf7c(5)
	if vm.skipping() then
		return skip(10)
	end
	helper_126faf7c(6)
	if vm.skipping() then
		return skip(11)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(12)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 50005)
	event.SetMesOkuri(0, 0)
	helper_dc39b923(0, -1, 8, 0, 0)
	event.ObjsSetPos(0, 1309.0, 0.0, 967.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "走り見回し一連", 6)
	event.ObjsMove(0, 1309.0, 0.0, 647.0, 64)
	event.ObjsMove(0, 1309.0, 0.0, 607.0, 10)
	event.ObjsMove(0, 1309.0, 0.0, 582.0, 10)
	event.ObjsMove(0, 1309.0, 0.0, 567.0, 10)
	event.ObjsMove(0, 1309.0, 0.0, 557.0, 10)
	event.ObjsTexaDelay(0, 64)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目（常）（１）")
	event.ObjsTexAnime(0, 1, "イィー口(1)")
	event.ObjsSetPos(4, 1502.4, 0.0, 1397.74)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 119)
	event.ObjsAddPas(4, 1502.4, 0.0, 1397.74)
	event.ObjsAddPas(4, 1418.3, 0.0, 1351.17)
	event.ObjsAddPas(4, 1375.12, 0.0, 1272.42)
	event.ObjsAddPas(4, 1348.94, 0.0, 1140.59)
	event.ObjsAddPas(4, 1336.94, 0.0, 1054.42)
	event.ObjsAddPas(4, 1335.18, 0.0, 871.57)
	event.ObjsStartPas(4)
	event.ObjsSetPos(5, 1547.87, 0.0, 1488.3)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 119)
	event.ObjsAddPas(5, 1547.87, 0.0, 1488.3)
	event.ObjsAddPas(5, 1421.49, 0.0, 1416.47)
	event.ObjsAddPas(5, 1367.47, 0.0, 1333.44)
	event.ObjsAddPas(5, 1323.19, 0.0, 1228.93)
	event.ObjsAddPas(5, 1303.23, 0.0, 1136.7)
	event.ObjsAddPas(5, 1286.79, 0.0, 976.16)
	event.ObjsStartPas(5)
	event.ObjsSetPos(6, 1585.91, 0.0, 1458.95)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 119)
	event.ObjsAddPas(6, 1585.91, 0.0, 1458.95)
	event.ObjsAddPas(6, 1499.65, 0.0, 1453.35)
	event.ObjsAddPas(6, 1430.66, 0.0, 1417.08)
	event.ObjsAddPas(6, 1366.4, 0.0, 1356.62)
	event.ObjsAddPas(6, 1336.79, 0.0, 1255.43)
	event.ObjsAddPas(6, 1321.49, 0.0, 1065.94)
	event.ObjsStartPas(6)
	event.CmrsSyncObj(0, 0.0, 15.0, 0.0, -2.9, 20.0, 70.0)
	event.CmrsMoveAhd(3.14, 20.0, 70.0, 80)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(1358.11, 30.53, 762.36)
	event.CmrsSetRef(1402.76, 30.68, 550.39)
	event.CmrsMove(1358.11, 30.53, 762.36, 1402.76, 162.32, 550.39, 30)
	event.ObjsSetPos(0, 1309.0, 0.0, 597.0)
	event.ObjsSetMotion(0, "右上向き", 4)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(14)
	end
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(1315.4, 35.92, 559.68)
	event.CmrsSetRef(1307.34, 19.88, 595.99)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "口パク横大(1)")
	event.ObjsTexaDelay(0, 10)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(1)")
	event.ObjsTexAnime(0, 1, "怒り口(1)")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(16)
	end
	helper_7e2956fd(0)
	event.SetMesOkuri(0, 1)
	event.ObjsInit(6)
	event.CharaActive(0, 14)
	event.DeleteChara(14)
	event.CmrsSetPos(1470.95, 53.06, 625.96)
	event.CmrsSetRef(1414.36, 47.06, 555.98)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目(2)")
	event.ObjsTexAnime(0, 1, "怒り口(2)")
	event.CharaActive(0, 13)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "のぼり一連", 6, -1.0, 1)
	event.ObjsMotionWait(0)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 11)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsSeDelay(0, 60)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 12)
	event.EohSetFrameShow(4, "obj10", 0)
	event.EohSetFrameShow(4, "obj11", 0)
	event.EohSetFrameShow(4, "obj6", 0)
	event.EohSetFrameShow(4, "obj4", 0)
	event.ObjsSetMotion(4, "飛びついて蹴り落ち", 6)
	event.ObjsSeDelay(4, 80)
	event.ObjsSePlay(4, var1, 13)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.68, 6.0, 90.0, "chara")
	event.ObjsSetMotion(0, "のぼり一連", 1)
	event.EohSetFootSoundId(0, 6)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(1507.85, 274.71, 487.29)
	event.CmrsSetRef(1400.71, 250.07, 551.81)
	event.CmrsMove(1314.65, 274.71, 571.79, 1193.02, 250.07, 591.57, 126)
	event.ObjsSetMotion(0, "ポールから屋根へ", 6)
	event.ObjsMotionWait(0)
	event.ObjsSeDelay(0, 100)
	event.ObjsSePlay(0, var1, 14)
	event.EohSetFootSoundId(0, 6)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetFootSoundId(0, 3)
	helper_b0211f82(50)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetFootSoundId(0, 6)
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(21)
	end
	event.EohSetFootSoundId(0, 20)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(755.22, 455.36, 770.08)
	event.CmrsSetRef(863.16, 329.8, 574.01)
	event.CmrsMove2(787.23, 433.36, 739.6, 785.29, 312.14, 548.14, 60, 0, 1.0)
	event.EohSetFootSoundId(0, 20)
	event.ObjsSetMotion(0, "屋根上1", 6)
	event.ObjsMotionWait(0)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var1, 15)
	if vm.wait() then
		return skip(23)
	end
	helper_b0211f82(120)
	if vm.skipping() then
		return skip(24)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(25)
	end
	event.StreamClose(1)
	event.CmrsSetPos(924.31, 255.15, 487.82)
	event.CmrsSetRef(725.21, 270.97, 431.93)
	event.SetLoadbgFile("event/opening/p5/p5_mints3.gltf")
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_9b390ef3()
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(587.67, 352.86, 412.66)
	event.CmrsSetRef(790.95, 282.51, 463.59)
	event.EohSetFrameShow(4, "obj10", 1)
	event.EohSetFrameShow(4, "obj11", 1)
	event.EohSetFrameShow(4, "obj6", 1)
	event.EohSetFrameShow(4, "obj4", 1)
	event.ObjsSetPos(0, 732.13, 257.21, 443.67)
	event.ObjsSetRot(0, 0.0, 1.8, 0.0)
	event.ObjsSetMotion(0, "振り返りループ", 4)
	event.ObjsSetMotion(4, "屋根上手招き", 4)
	event.CharaActive(1, 13)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "屋根すべり", 6)
	event.ObjsMotionWait(5)
	event.ObjsSeDelay(5, 20)
	event.ObjsSePlay(5, var1, 15)
	helper_126faf7c(5)
	if vm.skipping() then
		return skip(28)
	end
	event.ClearStack(7)
	event.DelExtMotion(0)
	event.LoadMotion(7, "event/opening/p5/p5_mints3.gltf", "info", 0)
	event.CmrsSetPos(763.09, 272.22, 446.02)
	event.CmrsSetRef(733.35, 278.11, 441.25)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "会話（帽子）", 6, -1.0, 1)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "困った目(3)")
	if vm.wait() then
		return skip(29)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口(3)")
	helper_2d5c6a8c(50020, -1, 10)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(0, "振り向いて走る", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目（通常）(3)")
	event.ObjsTexAnime(0, 1, "怒り口(3)")
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(1140.15, 357.53, 638.69)
	event.CmrsSetRef(836.46, 316.08, 666.69)
	event.CmrsMove(1091.91, 356.61, 646.98, 811.82, 322.28, 732.96, 124)
	event.ObjsSetMotion(0, "逃げ回るミンツ", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetPos(4, 806.22, 120.38, 561.57)
	event.ObjsSetRot(4, 0.0, -0.72, 0.0)
	event.ObjsMove(4, 723.19, 225.42, 754.46, 86)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsJump(4, 700.96, 239.38, 798.22, -0.2, 18)
	event.ObjsMove(4, 676.73, 252.62, 814.2, 20)
	event.ObjsRotDelay(4, 86)
	event.ObjsRotation(4, 0.0, -1.08, 0.0, 30)
	event.ObjsMotionDelay(4, 86)
	event.ObjsSetStep(4, 0.2)
	event.ObjsMotionDelay(4, 17)
	event.ObjsSetStep(4, 0.9)
	event.ObjsSetPos(5, 816.27, 161.11, 433.68)
	event.ObjsSetRot(5, 0.0, -0.72, 0.0)
	event.ObjsSetMotion(5, "走り", 4)
	event.ObjsMove(5, 722.9, 225.66, 567.51, 72)
	event.ObjsMove(5, 722.9, 225.66, 715.49, 52)
	event.ObjsRotDelay(5, 50)
	event.ObjsRotation(5, 0.0, 0.0, 0.0, 12)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(33)
	end
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CmrsSetPos(122.6, 376.58, -28.31)
	event.CmrsSetRef(298.28, 326.93, 63.42)
	event.CmrsMove(196.7, 361.64, 10.38, 298.28, 326.93, 63.42, 95)
	event.EohSetFootSoundId(0, 6)
	event.ObjsSetMotion(0, "アーム上に", 6)
	event.ObjsNextMotion(0, "アーム上ループ", 4)
	event.ObjsSeDelay(0, 46)
	event.ObjsSePlay(0, var1, 16)
	helper_b0211f82(46)
	if vm.skipping() then
		return skip(34)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(35)
	end
	event.EohSetFootSoundId(4, 6)
	event.CharaActive(1, 12)
	event.ObjsSetPos(4, 306.41, 281.14, 189.26)
	event.ObjsSetRot(4, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(4, "にじりより", 4)
	event.ObjsMove(4, 306.41, 305.3, 134.35, 60)
	helper_126faf7c(4)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(306.41, 325.86, 27.66)
	event.CmrsSetRef(306.25, 328.7, 143.17)
	event.CharaActive(0, 0)
	event.ObjsSetMotion(4, "にじりより", 4)
	event.ObjsMove(4, 306.41, 314.03, 121.65, 60)
	helper_126faf7c(4)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(299.01, 336.06, 82.41)
	event.CmrsSetRef(304.7, 341.54, 42.89)
	event.CharaActive(1, 0)
	event.ObjsSetMotion(0, "グラグラループ", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "下向き目（通常）(3)")
	event.ObjsTexAnime(0, 1, "口ぱく横小(3)")
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "下向き(3)")
	event.ObjsTexAnime(0, 1, "口ぱく横小(3)")
	helper_b0211f82(40)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(306.41, 325.86, 27.66)
	event.CmrsSetRef(306.25, 328.7, 143.17)
	event.CharaActive(0, 0)
	event.ObjsSetMotion(4, "にじりより", 4)
	event.ObjsMove(4, 306.41, 314.94, 82.06, 60)
	helper_126faf7c(4)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(310.38, 335.43, 87.38)
	event.CmrsSetRef(308.52, 338.73, 49.68)
	event.CharaActive(1, 0)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(0, "グラグラからかまえ", 6)
	event.ObjsNextMotion(0, "かまえ～レンチ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(3)")
	event.ObjsTexAnime(0, 1, "怒り口(3)")
	event.ObjsTexaDelay(0, 15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "覚悟～レンチ")
	event.ObjsTexAnime(0, 1, "覚悟の口")
	helper_b0211f82(45)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsPrdelay(40)
	event.CmrsSetPos(265.28, 340.09, 25.51)
	event.CmrsSetRef(310.44, 335.75, 45.81)
	helper_2d5c6a8c(50030, -1, 0)
	if vm.skipping() then
		return skip(41)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(42)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(43)
	end
	event.CharaActive(1, 9)
	event.CmrsSetPos(310.38, 335.43, 87.38)
	event.CmrsSetRef(308.52, 338.73, 49.68)
	helper_b0211f82(5)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSePlay(0, var1, 17)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(204.46, 341.45, 61.97)
	event.CmrsSetRef(312.97, 339.16, 66.9)
	event.CharaActive(1, 12)
	event.CharaDaEnable(0, 0)
	event.SetLoadbgFile("event/opening/p5/p00_08a.gltf", "event/opening/p5/p5_mints4.gltf")
	event.ObjsSetMotion(0, "ジャンプ殴り一連", 6)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "殴られピエロ", 6)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var1, 18)
	helper_b0211f82(40)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetStep(0, 0.05)
	event.ObjsSetStep(4, 0.05)
	helper_b0211f82(65)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetStep(0, 0.55)
	event.ObjsSetStep(4, 0.55)
	event.ObjsSePlay(0, var1, 19)
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(48)
	end
	event.CharaDaEnable(0, 1)
	event.CmrsSetPos(469.18, 186.58, -162.58)
	event.CmrsSetRef(318.39, 307.38, 63.85)
	event.FadeOutBgm(30)
	event.ObjsSetPos(4, 346.08, 290.76, -2.5)
	event.ObjsSetRot(4, 0.0, 2.66, 0.0)
	event.ObjsSetMotion(4, "落ちループ", 4)
	event.ObjsMove(4, 454.18, 290.76, -161.38, 30)
	var2 = 0
	var3 = 2.0
	while var2 < 30 do
		if vm.wait() then
			return skip(49)
		end
		do
			local out1, out2, out3 = event.GetCharaPos(12)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var3 = vm.f32(var3 + vm.f32(0.1))
		var5 = vm.f32(var5 - var3)
		event.SetCharaPos(12, var4, var5, var6)
		var2 = var2 + 1
	end
	event.ObjsSePlay(0, var1, 20)
	event.CmrsSetPos(305.23, 330.85, 172.41)
	event.CmrsSetRef(307.36, 334.06, 94.37)
	event.CharaActive(0, 12)
	event.ObjsSetMotionNowTime(0, 33.0)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "レンチかまえL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var1, 21)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(50)
	end
	event.StopBgm(0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(305.23, 330.85, 172.41)
	event.CmrsSetRef(307.36, 334.06, 94.37)
	event.CharaActive(0, 15)
	helper_9b390ef3()
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsInit(4)
	event.CharaActive(0, 12)
	event.DeleteChara(12)
	event.ObjsInit(5)
	event.CharaActive(0, 13)
	event.DeleteChara(13)
	event.ClearStack(6)
	event.DelExtMotion(0)
	event.LoadMotion(6, "event/opening/p5/p5_mints4.gltf", "info", 0)
	event.AssignStack(7)
	event.ClearStack(7)
	event.LoadChara(7, "event/opening/p5/p00_08a.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 398.37, 315.2, 97.47)
	event.ObjsSetRot(4, 0.0, -1.57, 0.0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "声に反応", 5)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "声に反応", 6)
	event.ObjsNextMotion(0, "「なんだ」L", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "上向き目（４）")
	event.ObjsTexAnime(0, 1, "口パク横小(4)")
	helper_2d5c6a8c(50040, -1, 10)
	if vm.skipping() then
		return skip(53)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(54)
	end
	event.LoadBgm(110)
	event.CmrsSetPos(158.34, 284.03, -147.01)
	event.CmrsSetRef(315.83, 384.57, 166.09)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(2, "屋根の上にジャンプ", 6)
	event.ObjsNextMotion(2, "屋根上でのループ", 4)
	event.ObjsSePlay(2, var1, 23)
	event.ObjsSeDelay(2, 40)
	event.ObjsSePlay(2, var1, 24)
	helper_b0211f82(40)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(56)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(309.79, 330.51, 134.62)
	event.CmrsSetRef(307.18, 335.35, 97.64)
	event.CharaActive(0, 9)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "上向き目（４）")
	if vm.wait() then
		return skip(58)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_2d5c6a8c(50050, -1, 10)
	if vm.skipping() then
		return skip(59)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(330.17, 424.73, 30.18)
	event.CmrsSetRef(316.71, 427.89, 163.92)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "怒り目")
	if vm.wait() then
		return skip(60)
	end
	event.SetPakuAnim(3, "口パク", "怒り口")
	helper_2d5c6a8c(50060, -1, 10)
	if vm.skipping() then
		return skip(61)
	end
	event.ResetPakuAnim()
	helper_126faf7c(3)
	if vm.skipping() then
		return skip(62)
	end
	event.CmrsSetPos(309.79, 330.51, 134.62)
	event.CmrsSetRef(307.18, 335.35, 97.64)
	event.CharaDaEnable(0, 0)
	event.ObjsSetMotion(0, "ペンダント見る", 6)
	event.ObjsNextMotion(0, "ペンダント見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "考え目（下)（４）")
	if vm.wait() then
		return skip(63)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_2d5c6a8c(50070, -1, 10)
	if vm.skipping() then
		return skip(64)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsSetPos(267.41, 346.68, 117.05)
	event.CmrsSetRef(331.3, 325.62, 92.25)
	event.CharaActive(1, 12)
	event.SetPakuAnim(4, "口パク")
	helper_2d5c6a8c(50080, -1, 10)
	if vm.skipping() then
		return skip(66)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(309.79, 330.51, 134.62)
	event.CmrsSetRef(307.18, 335.35, 97.64)
	event.ObjsSetMotion(0, "「え？」", 6)
	event.ObjsNextMotion(0, "髪ゆれL", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "口パク横小(4)")
	helper_2d5c6a8c(50090, -1, 10)
	if vm.skipping() then
		return skip(67)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(68)
	end
	event.CmrsSetPos(267.41, 346.68, 117.05)
	event.CmrsSetRef(331.3, 325.62, 92.25)
	event.ObjsInit(4)
	event.CharaActive(0, 12)
	event.DeleteChara(12)
	event.ClearStack(7)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsSetPos(345.09, 332.09, 125.17)
	event.CmrsSetRef(307.31, 337.01, 97.3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "口パク横小(4)")
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "声で振り返る", 6)
	event.ObjsNextMotion(0, "声で振り返るL", 4)
	event.ObjsTexaDelay(0, 40)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目（目パチ）(4)")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.SetPakuAnim(3, "口パク", "怒り口")
	helper_2d5c6a8c(50100, -1, 10)
	if vm.skipping() then
		return skip(71)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(72)
	end
	helper_2d5c6a8c(50110, -1, 10)
	if vm.skipping() then
		return skip(73)
	end
	event.SetLoadbgFile("event/opening/p5/p5_hata.gltf", "event/opening/p5/p5_donnie.gltf")
	if vm.wait() then
		return skip(74)
	end
	helper_9b390ef3()
	if vm.skipping() then
		return skip(75)
	end
	event.LoadChara(7, "event/opening/p5/p5_hata.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, -172.95, 0.0, -49.1)
	event.ObjsSetRot(4, 0.0, -1.4, 0.0)
	event.ObjsSetMotion(4, "伸び", 5)
	event.LoadChara(7, "event/opening/p5/p5_donnie.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(76)
	end
	event.CmrsSetPos(158.34, 284.03, -147.01)
	event.CmrsSetRef(315.83, 384.57, 166.09)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsSetMotion(2, "屋根上手招き", 4)
	event.ObjsSePlay(2, var1, 25)
	event.ObjsSeDelay(2, 40)
	event.ObjsSePlay(2, var1, 25)
	event.ObjsSeDelay(2, 40)
	event.ObjsSePlay(2, var1, 25)
	event.SetPakuAnim(3, "口パク", "怒り口")
	helper_2d5c6a8c(50120, -1, 10)
	if vm.skipping() then
		return skip(77)
	end
	event.ResetPakuAnim()
	helper_126faf7c(3)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(308.57, 343.26, 143.54)
	event.CmrsSetRef(306.87, 327.08, 91.96)
	event.ObjsSetMotion(0, "これは渡さないよL", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目追加")
	if vm.wait() then
		return skip(79)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_2d5c6a8c(50130, -1, 10)
	if vm.skipping() then
		return skip(80)
	end
	event.ResetPakuAnim()
	event.CharaDaEnable(0, 1)
	event.CmrsSetPos(325.39, 421.07, 130.43)
	event.CmrsSetRef(318.19, 429.82, 166.44)
	event.ObjsSetMotion(2, "屋根上でのループ", 4)
	event.ObjsSetMotion(3, "会話2", 6)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "怒り目（通常）")
	if vm.wait() then
		return skip(81)
	end
	event.SetPakuAnim(3, "口パク", "にやり口")
	helper_2d5c6a8c(50140, -1, 10)
	if vm.skipping() then
		return skip(82)
	end
	event.ResetPakuAnim()
	helper_126faf7c(3)
	if vm.skipping() then
		return skip(83)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "怒り目（通常）")
	event.ObjsTexAnime(3, 1, "怒り口")
	event.CmrsSetPos(339.19, 360.48, -9.14)
	event.CmrsSetRef(354.68, 418.65, 219.48)
	event.PlayBgm(0)
	event.ObjsSetMotion(2, "アームにジャンプ", 6, 0.1)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetStep(2, 0.3)
	event.CmrsMove(240.84, 360.48, -368.07, 354.68, 418.65, 219.48, 30)
	event.ObjsSePlay(2, var1, 26)
	event.ObjsSetMotion(0, "アームから飛ぶ", 6)
	event.ObjsMotionWait(0)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(85)
	end
	event.CmrsSetPos(76.65, 161.52, -242.26)
	event.CmrsSetRef(290.86, 295.09, 19.51)
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	event.ObjsSePlay(2, var1, 27)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(86)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(87)
	end
	event.CmrsSetPos(116.51, 186.59, -118.26)
	event.CmrsSetRef(201.47, 239.72, -54.14)
	event.ObjsSetMotion(0, "ストリートに向く", 6)
	event.ObjsNextMotion(0, "ストリートに向くL", 4)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(88)
	end
	event.ObjsSetMotion(2, "アームからジャンプ", 6)
	event.ObjsSePlay(2, var1, 26)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(89)
	end
	event.CmrsSetPos(159.03, 244.48, -60.67)
	event.CmrsSetRef(172.64, 209.39, -85.13)
	event.ObjsSetMotion(2, "アームからジャンプ", 1)
	event.ObjsSetMotion(0, "上を向く", 6)
	event.ObjsNextMotion(0, "上を向くL", 6)
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(90)
	end
	event.ObjsSetMotion(0, "右見て顔戻す", 6)
	event.ObjsMotionWait(0)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(91)
	end
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(92)
	end
	event.CmrsSetPos(-125.14, 515.89, -280.6)
	event.CmrsSetRef(167.93, 227.34, -78.38)
	event.ObjsSetMotion(2, "アームからジャンプ", 2)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(0, "ストリートへ飛ぶ", 6)
	helper_b0211f82(16)
	if vm.skipping() then
		return skip(93)
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	event.ObjsSePlay(2, var1, 27)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(94)
	end
	event.CmrsSetPos(61.35, 203.41, -149.02)
	event.CmrsSetRef(185.39, 255.7, -89.34)
	event.ObjsSetMotion(2, "顔回転", 6)
	event.ObjsMotionWait(2)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(95)
	end
	helper_7d8cc2b5(0)
	event.CmrsSetPos(-290.5, 112.58, -19.91)
	event.CmrsSetRef(-175.75, 144.25, -48.85)
	event.CmrsMove(-290.5, 18.12, -19.91, -175.75, 24.59, -48.85, 100)
	event.EohSetFootSoundId(0, 2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "顔回転", 6, 0.07)
	event.ObjsSetPos(0, -172.95, 0.0, -49.1)
	event.ObjsSetRot(0, 0.0, -1.4, 0.0)
	event.ObjsSetMotion(0, "ひもぶら下がり", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "下向き目（４）")
	event.ObjsTexAnime(0, 1, "大きな口(4)")
	event.ObjsTexaDelay(0, 100)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(4)")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsSetMotion(4, "ひもぶら下がり", 6)
	event.ObjsSePlay(2, var1, 28)
	event.ObjsSeDelay(2, 25)
	event.ObjsSePlay(2, var1, 28)
	event.ObjsSeDelay(2, 55)
	event.ObjsSePlay(2, var1, 28)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(96)
	end
	event.ObjsSePlay(0, var1, 29)
	event.CharaActive(0, 12)
	event.EohSetFrameShow(2, "light", 0)
	event.EohSetFrameShow(2, "lay1--c0z0app", 0)
	event.EohSetFrameShow(2, "lay2--c0z0app1", 0)
	event.EohSetFrameShow(2, "lay_s--c0z0appba", 0)
	event.EohSetFrameShow(2, "lay_s22--c0z0appba", 0)
	event.ObjsSetPos(2, 4.14, 100.0, -94.66)
	event.ObjsSetRot(2, 0.0, -1.4, 0.0)
	event.ObjsJump(2, 4.14, 0.0, -94.66, -0.1, 10)
	event.ObjsMotionDelay(2, 2)
	event.ObjsSetMotion(2, "着地2", 6)
	event.ObjsMotionWait(2)
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(97)
	end
	event.ObjsSePlay(0, var1, 30)
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_b0211f82(5)
	if vm.skipping() then
		return skip(98)
	end
	event.ObjsSetMotion(0, "驚き振り向き", 6)
	event.ObjsNextMotion(0, "かわし走り", 6)
	event.ObjsPosDelay(0, 22)
	event.ObjsMove(0, -348.2, 0.0, -4.9, 44)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(4)")
	event.ObjsTexAnime(0, 1, "イィー口(4)")
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(99)
	end
	event.ObjsSetMotion(2, "つかみ歩き", 6)
	event.ObjsNextMotion(2, "歩き", 4)
	event.ObjsMove(2, -201.84, 0.0, -54.55, 42)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 31)
	event.ObjsSeDelay(2, 25)
	event.ObjsSePlay(2, var1, 31)
	event.CmrsMove(-454.24, 18.12, 21.38, -338.77, 24.59, -7.74, 44)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(100)
	end
	event.CmrsSyncObj(0, -5.0, 25.0, 0.0, -0.92, -10.0, 50.0)
	event.EohSetShadow(0, 0)
	event.EohSetShadow(2, 0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り改", 6)
	event.ObjsNextMotion(0, "こける", 6, 0.8)
	event.ObjsMotionWait(0)
	event.ObjsSetPos(0, -407.27, 0.0, 10.0)
	event.ObjsMove(0, -549.23, 0.0, 41.66, 80)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "追ってくるピエロロボ(目）")
	event.ObjsTexAnime(0, 1, "追ってくる（口）")
	event.ObjsSetPos(2, -257.7, 0.0, -32.15)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMove(2, -437.38, 0.0, 11.19, 80)
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(101)
	end
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(102)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(103)
	end
	event.CmrsReleaseObj()
	event.EohSetShadow(0, 1)
	event.EohSetShadow(2, 1)
	event.CmrsSetPos(-460.48, 23.67, 35.22)
	event.CmrsSetRef(-493.63, 8.84, 22.81)
	event.CmrsPrdelay(30)
	event.CmrsMove2(-584.45, 23.67, 110.84, -461.07, 39.78, 24.24, 40, 0, 0.3)
	event.ObjsSetPos(0, -488.16, 0.0, 20.52)
	event.ObjsSetRot(0, 0.0, 1.8, 0.0)
	event.ObjsSetMotion(0, "うつぶせから倒れに", 6, -1.0, 1)
	event.ObjsNextMotion(0, "倒れL", 4)
	event.ObjsSetPos(2, -351.24, 0.0, -5.76)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "手を上げる", 5)
	helper_b0211f82(50)
	if vm.skipping() then
		return skip(104)
	end
	event.ObjsSetMotion(2, "手を上げる", 6)
	event.ObjsMotionWait(2)
	event.ObjsSePlay(2, var1, 32)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(105)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(106)
	end
	event.CmrsSetPos(-475.03, 150.78, 109.5)
	event.CmrsSetRef(-424.67, 158.91, 53.02)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "指差し", 6)
	event.EohSetFrameShow(3, "sashi", 1)
	event.EohSetFrameShow(3, "cube61_8", 0)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "怒り目")
	if vm.wait() then
		return skip(107)
	end
	event.SetPakuAnim(3, "口パク", "にやり口")
	helper_2d5c6a8c(50150, -1, 10)
	if vm.skipping() then
		return skip(108)
	end
	event.ResetPakuAnim()
	event.EohSetFrameShow(3, "sashi", 0)
	event.EohSetFrameShow(3, "cube61_8", 1)
	event.CmrsSetPos(-424.39, 57.37, 104.2)
	event.CmrsSetRef(-471.89, 25.88, 13.34)
	event.ObjsSetPos(2, -367.17, 0.0, 9.93)
	event.ObjsSetRot(2, 0.0, -1.4, 0.0)
	event.ObjsSetMotion(2, "つかみそこなう手", 6)
	event.ObjsNextMotion(2, "失敗ループ", 4)
	event.ObjsSePlay(2, var1, 33)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 27)
	event.ObjsSetPos(0, -473.32, 0.0, 2.57)
	event.ObjsSetRot(0, 0.0, 1.68, 0.0)
	event.ObjsSetMotion(0, "かわして前に", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(4)")
	event.ObjsTexAnime(0, 1, "口パク横大(4)")
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(109)
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(110)
	end
	event.CmrsSetPos(-632.86, 81.14, 94.35)
	event.CmrsSetRef(-452.4, 42.5, 29.14)
	event.ObjsSetMotion(0, "ハイハイから走りに", 6)
	event.ObjsNextMotion(0, "走り改", 4)
	event.ObjsMove(0, -253.41, 0.0, -13.35, 60)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(111)
	end
	event.ObjsSetMotion(2, "またくぐり", 2)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(112)
	end
	event.CmrsSetPos(-530.73, 114.8, 110.26)
	event.CmrsSetRef(-447.57, 126.89, 72.6)
	event.ObjsSetMotion(3, "振り向き", 6)
	event.ObjsNextMotion(3, "振り向きL", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "怒り目（通常）")
	event.SetPakuAnim(3, "口パク", "怒り口")
	helper_2d5c6a8c(50160, -1, 10)
	if vm.skipping() then
		return skip(113)
	end
	event.ResetPakuAnim()
	event.StreamOpen3(1, 50170)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(114)
	end
	event.CmrsSyncObj(0, 0.0, 20.0, 0.0, 1.66, 10.0, 80.0)
	event.CmrsAhddelay(40)
	event.CmrsReleaseObj()
	event.CmrsSyncObj(0, 0.0, 23.0, 0.0, 1.66, 1.26, 46.0)
	event.ObjsSetPos(0, -319.98, 0.0, -5.49)
	event.ObjsSetRot(0, 0.0, 1.68, 0.0)
	event.ObjsMove(0, -71.09, 0.0, -25.42, 62)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り改", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り改", 6)
	event.ObjsNextMotion(0, "走りながら右向く", 6)
	event.ObjsNextMotion(0, "走り改", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目(4)")
	event.ObjsTexAnime(0, 1, "口パク横小(4)")
	event.ObjsSetPos(2, -470.35, 0.0, 7.86)
	event.ObjsSetRot(2, 0.0, -1.52, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.StreamPlay(1)
	event.MesMake_2(0, 50170)
	helper_dc39b923(0, -1, 8, 0, 0)
	helper_6e94ffcc(0, 40)
	if vm.skipping() then
		return skip(115)
	end
	helper_7e2956fd(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
	event.EohSetShadow(0, 0)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(116)
	end
	event.CmrsReleaseObj()
	event.EohSetShadow(0, 1)
	helper_7d8cc2b5(1)
	event.CmrsSetPos(89.31, 53.56, -114.59)
	event.CmrsSetRef(190.36, 20.0, 127.33)
	event.CharaActive(1, 13)
	event.ObjsSetPos(5, 203.26, 0.0, 200.92)
	event.ObjsSetRot(5, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(5, "立ち手招き", 4)
	event.ObjsPosDelay(5, 30)
	event.ObjsMove(5, 204.92, 0.0, 250.68, 10)
	event.ObjsSetMotion(0, "走り改", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 40)
	event.ObjsAddPas(0, 95.83, 0.0, -2.57)
	event.ObjsAddPas(0, 137.11, 0.0, 11.63)
	event.ObjsAddPas(0, 164.93, 0.0, 32.86)
	event.ObjsAddPas(0, 185.5, 0.0, 62.2)
	event.ObjsAddPas(0, 202.23, 0.0, 97.29)
	event.ObjsStartPas(0)
	event.StreamOpen3(1, 50180)
	var0 = helper_2f47f9eb(1)
	if vm.skipping() then
		return skip(117)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 50180)
	helper_dc39b923(0, -1, 8, 0, 0)
	helper_6e94ffcc(0, vm.i32(40 - var0))
	if vm.skipping() then
		return skip(118)
	end
	helper_7e2956fd(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(119)
	end
	event.StreamClose(1)
	event.CmrsSetPos(224.56, 13.63, 269.0)
	event.CmrsSetRef(224.0, 6.84, 324.3)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "手招き", 6)
	event.ObjsTexAnime(5, 0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(120)
	end
	event.CmrsSetPos(224.14, 19.67, 443.89)
	event.CmrsSetRef(224.0, 15.17, 324.3)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "待機入り", 6)
	event.ObjsNextMotion(5, "待機", 6)
	event.ObjsNextMotion(5, "閉める", 6)
	event.ObjsMotionWait(5)
	event.ObjsSetPos(0, 226.8, 0.0, 167.7)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsMove(0, 226.8, 0.0, 336.71, 28)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り改", 6)
	event.ObjsNextMotion(0, "マンホールへ", 6)
	event.ObjsSeDelay(5, 62)
	event.ObjsSePlay(5, var1, 36)
	helper_126faf7c(5)
	if vm.skipping() then
		return skip(121)
	end
	event.CmrsSetPos(-62.55, 67.95, -87.07)
	event.CmrsSetRef(-318.49, 68.49, -24.03)
	event.EohSetFrameStatus(2, "light", 1)
	event.EohSetFrameStatus(2, "lay1--c0z0app", 5)
	event.EohSetFrameStatus(2, "lay2--c0z0app1", 1)
	event.EohSetFrameStatus(2, "lay_s--c0z0appba", 1)
	event.EohSetFrameStatus(2, "lay_s22--c0z0appba", 1)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(2, "旋回ジャンプ", 6)
	event.ObjsNextMotion(2, "歩き")
	event.ObjsRotDelay(2, 10)
	event.ObjsRotation(2, 0.0, 1.88, 0.0, 25)
	event.ObjsPosDelay(2, 55)
	event.ObjsMove(2, -296.99, 0.0, -27.41, 30)
	event.ObjsSePlay(2, var1, 34)
	event.ObjsSeDelay(2, 35)
	event.ObjsSePlay(2, var1, 35)
	helper_b0211f82(35)
	if vm.skipping() then
		return skip(122)
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(123)
	end
	event.CmrsSetPos(224.14, 19.67, 443.89)
	event.CmrsSetRef(224.0, 15.17, 324.3)
	event.FadeOutBgm(180)
	event.ObjsSetMotion(5, "覗きあけ", 6)
	event.ObjsSePlay(5, var1, 37)
	event.ObjsMotionDelay(5, 50)
	event.ObjsSetMotion(5, "あせり閉め", 6)
	event.ObjsSeDelay(5, 50)
	event.ObjsSePlay(5, var1, 38)
	event.ObjsSetPos(2, -48.38, 0.0, -130.23)
	event.ObjsSetRot(2, 0.0, 1.52, 0.0)
	event.ObjsMove(2, 238.39, 0.0, -72.31, 40)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち＞右むき", 2)
	event.ObjsNextMotion(2, "立ち＞右むきループ", 6)
	event.ObjsNextMotion(2, "右＞立ち", 6)
	event.ObjsMotionWait(2)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(124)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, 454.97, 0.0, -72.57, 40)
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(125)
	end
	event.ObjsSetMotion(5, "覗きあけ", 6)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(126)
	end
	event.SetLocalFlag(0, 1)
	return part2()
end

return helper_451c15b0
