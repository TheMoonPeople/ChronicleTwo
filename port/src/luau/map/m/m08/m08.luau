--!strict
-- map/m/m08/m08.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_39643f5e = require("@lib/event/helper_39643f5e")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_972d1084 = require("@lib/event/helper_972d1084")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a0450e0f = require("@lib/event/helper_a0450e0f")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")

--- Helper function.
local function helper_21648()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.ClearStack(4)
	event.AssignStack(4)
	event.ClearStack(5)
	event.AssignStack(5)
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/lm/c01ev.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "屋根", 5)
	event.LoadChara(5, "event/lm/p00_02ev.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "屋根", 5)
	event.LoadChara(5, "event/lm/p00_03ev.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "屋根の上", 5)
	event.LoadChara(5, "event/opening/p5/p5_donnie.gltf", "info", 11)
	event.CharaActive(11)
	event.SetCharaPos(11, 0.0, 0.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetMotion(11, "閉める", 2)
	event.CmrsInit()
	event.CmrsSyncObj(0, 5.0, 20.0, 0.0, 2.2, 20.0, 100.0, "ground")
	helper_888ab2a3(30)
	event.EohSetMotion(0, "屋根", 6)
	event.EohSetMotion(1, "屋根", 6)
	event.EohSetMotion(2, "屋根の上", 6)
	event.CmrsMoveAhd2(-2.2, 40.0, 100.0, 48, 2, 0.4)
	event.CmrsMoveAhd2(-2.2, 160.0, 200.0, 20, 0, 0.4)
	event.CmrsAhddelay(20)
	event.CmrsMoveAhd2(1.57, 5.0, 80.0, 28, 0, 0.4)
	event.CmrsMoveAhd2(1.57, 0.0, 30.0, 50, 0, 0.4)
	event.CmrsMoveAhd2(-2.84, 150.0, 230.0, 30, 0, 0.2)
	helper_c624bc16()
	event.CmrsReleaseObj()
	helper_c956b4a2(32)
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.CharaActive(1, 0)
end

--- Helper function.
local function helper_debc()
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetProjection(618.0)
		event.AssignStack(4)
		event.ClearStack(4)
		event.AssignStack(5)
		event.ClearStack(5)
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 367.64, 52.0, 143.02)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(0, "走り")
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 430)
		event.ObjsAddPas(0, 367.64, 52.0, 143.02)
		event.ObjsAddPas(0, 437.18, 52.0, 143.7)
		event.ObjsAddPas(0, 525.69, 4.07, 150.85)
		event.ObjsAddPas(0, 592.54, 4.07, 146.54)
		event.ObjsAddPas(0, 662.48, 0.0, 106.25)
		event.ObjsAddPas(0, 724.99, 0.0, 74.39)
		event.ObjsAddPas(0, 815.37, 0.0, 75.89)
		event.ObjsAddPas(0, 949.64, 0.0, 155.14)
		event.ObjsAddPas(0, 1096.43, 0.0, 260.16)
		event.ObjsAddPas(0, 1196.25, 0.0, 375.44)
		event.ObjsAddPas(0, 1279.57, 0.0, 504.31)
		event.ObjsAddPas(0, 1300.41, 0.0, 606.99)
		event.ObjsStartPas(0)
		event.SetStatus(1, 0, 8, 1)
		event.InitDramaScene()
		event.CmrsInit()
		event.CmrsSetPos(665.91, 81.93, -90.96)
		event.CmrsSetRef(496.81, 61.93, 126.47)
		event.CmrsFadeInit()
		event.CmrsFadeIn(30)
		helper_888ab2a3(90)
		event.CmrsSetPos(411.47, 70.02, -81.02)
		event.CmrsSetRef(742.24, 61.93, 120.93)
		event.SetStatus(1, 0, 8, 0)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(500)
		event.CmrsAddPas(366.48, 63.99, -74.02, 504.01, 35.91, 19.16)
		event.CmrsAddPas(376.09, 64.39, -74.07, 513.62, 37.39, 19.11)
		event.CmrsAddPas(383.64, 65.08, -76.39, 522.12, 39.72, 18.44)
		event.CmrsAddPas(393.5, 65.72, -75.66, 529.18, 42.2, 17.46)
		event.CmrsAddPas(397.26, 66.22, -77.95, 534.79, 47.76, 15.23)
		event.CmrsAddPas(403.26, 66.95, -79.13, 540.79, 58.7, 14.05)
		event.CmrsAddPas(408.35, 67.87, -80.75, 545.88, 84.01, 12.43)
		event.CmrsAddPas(409.92, 69.25, -82.46, 547.44, 114.61, 10.72)
		event.CmrsAddPas(413.71, 70.4, -82.7, 551.24, 185.45, 10.48)
		event.CmrsStartPas()
		helper_888ab2a3(200)
		helper_888ab2a3(270)
		event.CmrsFadeInit()
		event.CmrsFadeOut(30)
		helper_c624bc16()
	end)
	event.CancelDramaScene()
	event.SetStatus(1, 0, 8, 0)
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_888ab2a3(4)
	event.SoundLoadCancel()
	event.MapJump_3(-1, "m06", 152)
end

--- Helper function.
local function helper_1201c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		event.SetProjection(618.0)
		event.SetTime(24.0)
		event.SetMesWindowMode(0, 7)
		event.LoadSound(1220)
		var1 = event.SndLoadSound_2(1220) or var1
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadMes(0, 5, "event/opening/p5/op5.txt")
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
		event.SetLoadbgFile_1("event/opening/p5/p5_pierrot.gltf")
		at = 1
		vm.wait(1)
		at = 2
		helper_479dc9e9()
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
		at = 3
		helper_9cbdc640(1)
		event.StreamPlay(1)
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
		at = 4
		helper_0958ca60(4)
		at = 5
		helper_0958ca60(5)
		at = 6
		helper_0958ca60(6)
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
		at = 7
		helper_888ab2a3(50)
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
		at = 8
		helper_0958ca60(0)
		at = 9
		helper_0958ca60(4)
		at = 10
		helper_0958ca60(5)
		at = 11
		helper_0958ca60(6)
		at = 12
		helper_c624bc16()
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
		event.ObjsTexAnime(0, 1, "閉開口２(1)")
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
		at = 13
		helper_0958ca60(0)
		event.CmrsReleaseObj()
		event.CmrsSetPos(1358.11, 30.53, 762.36)
		event.CmrsSetRef(1402.76, 30.68, 550.39)
		event.CmrsMove(1358.11, 30.53, 762.36, 1402.76, 162.32, 550.39, 30)
		event.ObjsSetPos(0, 1309.0, 0.0, 597.0)
		event.ObjsSetMotion(0, "右上向き", 4)
		at = 14
		helper_c624bc16()
		at = 15
		helper_888ab2a3(10)
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
		at = 16
		helper_888ab2a3(30)
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
		at = 17
		helper_888ab2a3(30)
		event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.68, 6.0, 90.0, "chara")
		event.ObjsSetMotion(0, "のぼり一連", 1)
		event.EohSetFootSoundId(0, 6)
		at = 18
		helper_0958ca60(0)
		event.CmrsReleaseObj()
		event.CmrsSetPos(1507.85, 274.71, 487.29)
		event.CmrsSetRef(1400.71, 250.07, 551.81)
		event.CmrsMove(1314.65, 274.71, 571.79, 1193.02, 250.07, 591.57, 126)
		event.ObjsSetMotion(0, "ポールから屋根へ", 6)
		event.ObjsMotionWait(0)
		event.ObjsSeDelay(0, 100)
		event.ObjsSePlay(0, var1, 14)
		event.EohSetFootSoundId(0, 6)
		at = 19
		helper_888ab2a3(30)
		event.EohSetFootSoundId(0, 3)
		at = 20
		helper_888ab2a3(50)
		event.EohSetFootSoundId(0, 6)
		at = 21
		helper_888ab2a3(20)
		event.EohSetFootSoundId(0, 20)
		at = 22
		helper_0958ca60(0)
		event.CmrsSetPos(755.22, 455.36, 770.08)
		event.CmrsSetRef(863.16, 329.8, 574.01)
		event.CmrsMove2(787.23, 433.36, 739.6, 785.29, 312.14, 548.14, 60, 0, 1.0)
		event.EohSetFootSoundId(0, 20)
		event.ObjsSetMotion(0, "屋根上1", 6)
		event.ObjsMotionWait(0)
		event.ObjsSeDelay(0, 40)
		event.ObjsSePlay(0, var1, 15)
		at = 23
		vm.wait(23)
		at = 24
		helper_888ab2a3(120)
		at = 25
		helper_c624bc16()
		event.StreamClose(1)
		event.CmrsSetPos(924.31, 255.15, 487.82)
		event.CmrsSetRef(725.21, 270.97, 431.93)
		event.SetLoadbgFile_1("event/opening/p5/p5_mints3.gltf")
		at = 26
		helper_0958ca60(0)
		at = 27
		helper_479dc9e9()
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
		at = 28
		helper_0958ca60(5)
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
		at = 29
		vm.wait(29)
		event.SetPakuAnim(0, "通常口パク", "怒り口(3)")
		at = 30
		helper_29101c9c(50020, 70)
		event.ResetPakuAnim()
		event.StreamOpen3(1, 50023)
		at = 31
		helper_9cbdc640(1)
		event.StreamPlay(1)
		at = 32
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "振り向いて走る", 6)
		event.ObjsMotionWait(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "真剣目（通常）(3)")
		event.ObjsTexAnime(0, 1, "怒り口(3)")
		at = 33
		helper_0958ca60(0)
		event.StreamClose(1)
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
		at = 34
		helper_0958ca60(0)
		event.CharaActive(0, 12)
		event.CharaActive(0, 13)
		event.CmrsSetPos(122.6, 376.58, -28.31)
		event.CmrsSetRef(298.28, 326.93, 63.42)
		event.CmrsMove(196.7, 361.64, 10.38, 298.28, 326.93, 63.42, 95)
		event.EohSetFootSoundId(0, 6)
		event.ObjsSetMotion(0, "アーム上に", 6)
		event.ObjsNextMotion(0, "アーム上ループ", 4)
		event.StreamOpen3(1, 50025)
		at = 35
		var0 = helper_f616ba9e(1)
		event.ObjsSeDelay(0, 46)
		event.ObjsSePlay(0, var1, 16)
		at = 36
		helper_888ab2a3(vm.i32(46 - var0))
		event.StreamPlay(1)
		at = 37
		helper_c624bc16()
		event.EohSetFootSoundId(4, 6)
		event.CharaActive(1, 12)
		event.ObjsSetPos(4, 306.41, 281.14, 189.26)
		event.ObjsSetRot(4, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(4, "にじりより", 4)
		event.ObjsMove(4, 306.41, 305.3, 134.35, 60)
		at = 38
		helper_0958ca60(4)
		event.StreamClose(1)
		event.CmrsSetPos(306.41, 325.86, 27.66)
		event.CmrsSetRef(306.25, 328.7, 143.17)
		event.CharaActive(0, 0)
		event.ObjsSetMotion(4, "にじりより", 4)
		event.ObjsMove(4, 306.41, 314.03, 121.65, 60)
		at = 39
		helper_0958ca60(4)
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
		at = 40
		helper_888ab2a3(40)
		event.CmrsSetPos(306.41, 325.86, 27.66)
		event.CmrsSetRef(306.25, 328.7, 143.17)
		event.CharaActive(0, 0)
		event.ObjsSetMotion(4, "にじりより", 4)
		event.ObjsMove(4, 306.41, 314.94, 82.06, 60)
		at = 41
		helper_0958ca60(4)
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
		at = 42
		helper_888ab2a3(45)
		event.CmrsPrdelay(40)
		event.CmrsSetPos(265.28, 340.09, 25.51)
		event.CmrsSetRef(310.44, 335.75, 45.81)
		at = 43
		helper_29101c9c(50030, 30)
		at = 44
		helper_c624bc16()
		event.StreamOpen3(1, 50035)
		at = 45
		var0 = helper_f616ba9e(1)
		at = 46
		helper_888ab2a3(vm.i32(30 - var0))
		event.CharaActive(1, 9)
		event.CmrsSetPos(310.38, 335.43, 87.38)
		event.CmrsSetRef(308.52, 338.73, 49.68)
		event.StreamPlay(1)
		at = 47
		helper_888ab2a3(5)
		event.ObjsSePlay(0, var1, 17)
		at = 48
		helper_0958ca60(0)
		event.StreamClose(1)
		event.CmrsSetPos(204.46, 341.45, 61.97)
		event.CmrsSetRef(312.97, 339.16, 66.9)
		event.CharaActive(1, 12)
		event.CharaDaEnable(0, 0)
		event.SetLoadbgFile_2("event/opening/p5/p00_08a.gltf", "event/opening/p5/p5_mints4.gltf")
		event.ObjsSetMotion(0, "ジャンプ殴り一連", 6)
		event.ObjsSetPos(4, 0.0, 0.0, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(4, "殴られピエロ", 6)
		event.ObjsSeDelay(0, 40)
		event.ObjsSePlay(0, var1, 18)
		at = 49
		helper_888ab2a3(40)
		event.ObjsSetStep(0, 0.05)
		event.ObjsSetStep(4, 0.05)
		at = 50
		helper_888ab2a3(65)
		event.ObjsSetStep(0, 0.55)
		event.ObjsSetStep(4, 0.55)
		event.ObjsSePlay(0, var1, 19)
		at = 51
		helper_888ab2a3(20)
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
			at = 52
			vm.wait(52)
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
		at = 53
		helper_0958ca60(0)
		event.StopBgm(0)
		at = 54
		helper_888ab2a3(30)
		event.CmrsSetPos(305.23, 330.85, 172.41)
		event.CmrsSetRef(307.36, 334.06, 94.37)
		event.CharaActive(0, 15)
		at = 55
		helper_479dc9e9()
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
		at = 56
		helper_29101c9c(50040, 130)
		at = 57
		helper_0958ca60(0)
		event.StreamClose(1)
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
		at = 58
		helper_888ab2a3(40)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		at = 59
		helper_0958ca60(2)
		at = 60
		helper_c624bc16()
		event.CmrsSetPos(309.79, 330.51, 134.62)
		event.CmrsSetRef(307.18, 335.35, 97.64)
		event.CharaActive(0, 9)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "上向き目（４）")
		at = 61
		vm.wait(61)
		event.SetPakuAnim(0, "通常口パク", "怒り口")
		at = 62
		helper_29101c9c(50050, 50)
		event.ResetPakuAnim()
		event.CmrsSetPos(330.17, 424.73, 30.18)
		event.CmrsSetRef(316.71, 427.89, 163.92)
		event.ObjsSetMotion(3, "会話", 6)
		event.ObjsNextMotion(3, "立ち")
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "怒り目")
		at = 63
		vm.wait(63)
		event.SetPakuAnim(3, "口パク", "怒り口")
		at = 64
		helper_29101c9c(50060, 360)
		event.ResetPakuAnim()
		at = 65
		helper_0958ca60(3)
		event.CmrsSetPos(309.79, 330.51, 134.62)
		event.CmrsSetRef(307.18, 335.35, 97.64)
		event.CharaDaEnable(0, 0)
		event.ObjsSetMotion(0, "ペンダント見る", 6)
		event.ObjsNextMotion(0, "ペンダント見るL", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "考え目（下)（４）")
		at = 66
		vm.wait(66)
		event.SetPakuAnim(0, "通常口パク", "怒り口")
		at = 67
		helper_29101c9c(50070, 90)
		event.ResetPakuAnim()
		at = 68
		helper_0958ca60(0)
		event.CmrsSetPos(267.41, 346.68, 117.05)
		event.CmrsSetRef(331.3, 325.62, 92.25)
		event.CharaActive(1, 12)
		event.SetPakuAnim(4, "口パク")
		at = 69
		helper_29101c9c(50080, 40)
		event.ResetPakuAnim()
		event.CmrsSetPos(309.79, 330.51, 134.62)
		event.CmrsSetRef(307.18, 335.35, 97.64)
		event.ObjsSetMotion(0, "「え？」", 6)
		event.ObjsNextMotion(0, "髪ゆれL", 4)
		event.ObjsNormalDrive(0)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "口パク横小(4)")
		at = 70
		helper_29101c9c(50090, 30)
		at = 71
		helper_0958ca60(0)
		event.CmrsSetPos(267.41, 346.68, 117.05)
		event.CmrsSetRef(331.3, 325.62, 92.25)
		event.ObjsInit(4)
		event.CharaActive(0, 12)
		event.DeleteChara(12)
		event.ClearStack(7)
		at = 72
		helper_888ab2a3(60)
		event.CmrsSetPos(345.09, 332.09, 125.17)
		event.CmrsSetRef(307.31, 337.01, 97.3)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "口パク横小(4)")
		at = 73
		helper_888ab2a3(60)
		event.ObjsMotionDelay(0, 40)
		event.ObjsSetMotion(0, "声で振り返る", 6)
		event.ObjsNextMotion(0, "声で振り返るL", 4)
		event.ObjsTexaDelay(0, 40)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "怒り目（目パチ）(4)")
		event.ObjsTexAnime(0, 1, "怒り口")
		event.SetPakuAnim(3, "口パク", "怒り口")
		at = 74
		helper_29101c9c(50100, 136)
		event.ResetPakuAnim()
		at = 75
		helper_0958ca60(0)
		at = 76
		helper_29101c9c(50110, 130)
		event.StreamClose(1)
		event.SetLoadbgFile_2("event/opening/p5/p5_hata.gltf", "event/opening/p5/p5_donnie.gltf")
		at = 77
		vm.wait(77)
		at = 78
		helper_479dc9e9()
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
		at = 79
		helper_0958ca60(0)
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
		at = 80
		helper_29101c9c(50120, 90)
		event.ResetPakuAnim()
		at = 81
		helper_0958ca60(3)
		event.CmrsSetPos(308.57, 343.26, 143.54)
		event.CmrsSetRef(306.87, 327.08, 91.96)
		event.ObjsSetMotion(0, "これは渡さないよL", 4)
		event.ObjsNormalDrive(0)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "怒り目追加")
		at = 82
		vm.wait(82)
		event.SetPakuAnim(0, "通常口パク", "怒り口")
		at = 83
		helper_29101c9c(50130, 70)
		event.ResetPakuAnim()
		event.CharaDaEnable(0, 1)
		event.CmrsSetPos(325.39, 421.07, 130.43)
		event.CmrsSetRef(318.19, 429.82, 166.44)
		event.ObjsSetMotion(2, "屋根上でのループ", 4)
		event.ObjsSetMotion(3, "会話2", 6)
		event.ObjsNextMotion(3, "立ち")
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "怒り目（通常）")
		at = 84
		vm.wait(84)
		event.SetPakuAnim(3, "口パク", "にやり口")
		at = 85
		helper_29101c9c(50140, 200)
		event.ResetPakuAnim()
		at = 86
		helper_0958ca60(3)
		event.StreamOpen3(1, 50142)
		at = 87
		helper_9cbdc640(1)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "怒り目（通常）")
		event.ObjsTexAnime(3, 1, "怒り口")
		event.CmrsSetPos(339.19, 360.48, -9.14)
		event.CmrsSetRef(354.68, 418.65, 219.48)
		event.PlayBgm(0)
		event.ObjsSetMotion(2, "アームにジャンプ", 6, 0.1)
		at = 88
		helper_888ab2a3(30)
		event.StreamPlay(1)
		event.ObjsSetStep(2, 0.3)
		event.CmrsMove(240.84, 360.48, -368.07, 354.68, 418.65, 219.48, 30)
		event.ObjsSePlay(2, var1, 26)
		event.ObjsSetMotion(0, "アームから飛ぶ", 6)
		event.ObjsMotionWait(0)
		at = 89
		helper_c624bc16()
		event.CmrsSetPos(76.65, 161.52, -242.26)
		event.CmrsSetRef(290.86, 295.09, 19.51)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		event.ObjsSePlay(2, var1, 27)
		at = 90
		helper_c624bc16()
		at = 91
		helper_0958ca60(0)
		event.StreamClose(1)
		event.CmrsSetPos(116.51, 186.59, -118.26)
		event.CmrsSetRef(201.47, 239.72, -54.14)
		event.ObjsSetMotion(0, "ストリートに向く", 6)
		event.ObjsNextMotion(0, "ストリートに向くL", 4)
		at = 92
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "アームからジャンプ", 6)
		event.ObjsSePlay(2, var1, 26)
		at = 93
		helper_0958ca60(0)
		event.CmrsSetPos(159.03, 244.48, -60.67)
		event.CmrsSetRef(172.64, 209.39, -85.13)
		event.ObjsSetMotion(2, "アームからジャンプ", 1)
		event.ObjsSetMotion(0, "上を向く", 6)
		event.ObjsNextMotion(0, "上を向くL", 6)
		at = 94
		helper_888ab2a3(20)
		event.ObjsSetMotion(0, "右見て顔戻す", 6)
		event.ObjsMotionWait(0)
		at = 95
		helper_0958ca60(0)
		at = 96
		helper_888ab2a3(10)
		event.CmrsSetPos(-125.14, 515.89, -280.6)
		event.CmrsSetRef(167.93, 227.34, -78.38)
		event.ObjsSetMotion(2, "アームからジャンプ", 2)
		event.ObjsMotionWait(2)
		event.ObjsSetMotion(0, "ストリートへ飛ぶ", 6)
		at = 97
		helper_888ab2a3(16)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		event.ObjsSePlay(2, var1, 27)
		at = 98
		helper_0958ca60(2)
		event.CmrsSetPos(61.35, 203.41, -149.02)
		event.CmrsSetRef(185.39, 255.7, -89.34)
		event.ObjsSetMotion(2, "顔回転", 6)
		event.ObjsMotionWait(2)
		at = 99
		helper_0958ca60(2)
		helper_39643f5e(0)
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
		at = 100
		helper_0958ca60(0)
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
		at = 101
		helper_888ab2a3(10)
		event.ObjsSePlay(0, var1, 30)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		at = 102
		helper_888ab2a3(5)
		event.ObjsSetMotion(0, "驚き振り向き", 6)
		event.ObjsNextMotion(0, "かわし走り", 6)
		event.ObjsPosDelay(0, 22)
		event.ObjsMove(0, -348.2, 0.0, -4.9, 44)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "真剣目(4)")
		event.ObjsTexAnime(0, 1, "イィー口(4)")
		at = 103
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "つかみ歩き", 6)
		event.ObjsNextMotion(2, "歩き", 4)
		event.ObjsMove(2, -201.84, 0.0, -54.55, 42)
		event.ObjsSeDelay(2, 10)
		event.ObjsSePlay(2, var1, 31)
		event.ObjsSeDelay(2, 25)
		event.ObjsSePlay(2, var1, 31)
		event.CmrsMove(-454.24, 18.12, 21.38, -338.77, 24.59, -7.74, 44)
		event.StreamOpen3(1, 50143)
		at = 104
		helper_9cbdc640(1)
		at = 105
		helper_0958ca60(0)
		event.StreamPlay(1)
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
		at = 106
		helper_888ab2a3(20)
		event.StreamClose(1)
		event.StreamOpen3(1, 50146)
		at = 107
		var0 = helper_f616ba9e(1)
		at = 108
		helper_888ab2a3(vm.i32(10 - var0))
		event.StreamPlay(1)
		at = 109
		helper_0958ca60(0)
		event.StreamClose(1)
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
		at = 110
		helper_888ab2a3(50)
		event.ObjsSetMotion(2, "手を上げる", 6)
		event.ObjsMotionWait(2)
		event.ObjsSePlay(2, var1, 32)
		at = 111
		helper_0958ca60(2)
		at = 112
		helper_0958ca60(0)
		event.CmrsSetPos(-475.03, 150.78, 109.5)
		event.CmrsSetRef(-424.67, 158.91, 53.02)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(3, "指差し", 6)
		event.EohSetFrameShow(3, "sashi", 1)
		event.EohSetFrameShow(3, "cube61_8", 0)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "怒り目")
		at = 113
		vm.wait(113)
		event.SetPakuAnim(3, "口パク", "にやり口")
		at = 114
		helper_29101c9c(50150, 90)
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
		at = 115
		helper_888ab2a3(10)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		at = 116
		helper_0958ca60(0)
		event.CmrsSetPos(-632.86, 81.14, 94.35)
		event.CmrsSetRef(-452.4, 42.5, 29.14)
		event.ObjsSetMotion(0, "ハイハイから走りに", 6)
		event.ObjsNextMotion(0, "走り改", 4)
		event.ObjsMove(0, -253.41, 0.0, -13.35, 60)
		event.StreamOpen3(1, 50155)
		at = 117
		var0 = helper_f616ba9e(1)
		event.StreamPlay(1)
		at = 118
		helper_888ab2a3(vm.i32(30 - var0))
		event.ObjsSetMotion(2, "またくぐり", 2)
		at = 119
		helper_0958ca60(0)
		event.StreamClose(1)
		event.CmrsSetPos(-530.73, 114.8, 110.26)
		event.CmrsSetRef(-447.57, 126.89, 72.6)
		event.ObjsSetMotion(3, "振り向き", 6)
		event.ObjsNextMotion(3, "振り向きL", 4)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "怒り目（通常）")
		event.SetPakuAnim(3, "口パク", "怒り口")
		at = 120
		helper_29101c9c(50160, 200)
		event.ResetPakuAnim()
		event.StreamOpen3(1, 50170)
		at = 121
		helper_9cbdc640(1)
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
		helper_82705ce2(0, -1, 8, 0, 0)
		at = 122
		helper_a0450e0f(0, 40)
		helper_6992f518(0)
		event.StreamClose(1)
		event.SetMesPos(0, 0)
		event.EohSetShadow(0, 0)
		event.StreamOpen3(1, 50175)
		at = 123
		helper_9cbdc640(1)
		event.StreamPlay(1)
		at = 124
		helper_0958ca60(0)
		event.CmrsReleaseObj()
		event.StreamClose(1)
		event.EohSetShadow(0, 1)
		helper_39643f5e(1)
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
		at = 125
		var0 = helper_f616ba9e(1)
		event.StreamPlay(1)
		event.MesMake_2(0, 50180)
		helper_82705ce2(0, -1, 8, 0, 0)
		at = 126
		helper_a0450e0f(0, vm.i32(40 - var0))
		helper_6992f518(0)
		event.StreamClose(1)
		event.SetMesPos(0, 0)
		at = 127
		helper_0958ca60(0)
		event.StreamClose(1)
		event.CmrsSetPos(224.56, 13.63, 269.0)
		event.CmrsSetRef(224.0, 6.84, 324.3)
		event.ObjsSetPos(5, 0.0, 0.0, 0.0)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(5, "手招き", 6)
		at = 128
		helper_888ab2a3(30)
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
		at = 129
		helper_0958ca60(5)
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
		at = 130
		helper_888ab2a3(35)
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		at = 131
		helper_0958ca60(2)
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
		at = 132
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "歩き")
		event.ObjsMove(2, 454.97, 0.0, -72.57, 40)
		at = 133
		helper_888ab2a3(10)
		event.ObjsSetMotion(5, "覗きあけ", 6)
		at = 134
		helper_0958ca60(2)
		event.SetLocalFlag(0, 1)
	end, function(received: { any }): boolean
		if at == 35 then
			var0 = received[1] :: number
		end
		if at == 45 then
			var0 = received[1] :: number
		end
		if at == 107 then
			var0 = received[1] :: number
		end
		if at == 117 then
			var0 = received[1] :: number
		end
		if at == 125 then
			var0 = received[1] :: number
		end
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_238b5abc(4)
		end
		if at <= 4 then
			helper_238b5abc(5)
		end
		if at <= 5 then
			helper_238b5abc(6)
		end
		if at <= 6 then
			helper_038a2e4d(50)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			helper_238b5abc(4)
		end
		if at <= 9 then
			helper_238b5abc(5)
		end
		if at <= 10 then
			helper_238b5abc(6)
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_038a2e4d(10)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_038a2e4d(30)
		end
		if at <= 19 then
			helper_038a2e4d(50)
		end
		if at <= 20 then
			helper_038a2e4d(20)
		end
		if at <= 21 then
			helper_238b5abc(0)
		end
		if at <= 23 then
			helper_038a2e4d(120)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		if at <= 25 then
			helper_238b5abc(0)
		end
		if at <= 26 then
			helper_344d6cd8()
		end
		if at <= 27 then
			helper_238b5abc(5)
		end
		if at <= 29 then
			helper_53ffe901(50020, 70)
		end
		if at <= 30 then
			helper_238b5abc(1)
		end
		if at <= 31 then
			helper_238b5abc(0)
		end
		if at <= 32 then
			helper_238b5abc(0)
		end
		if at <= 33 then
			helper_238b5abc(0)
		end
		if at <= 34 then
			var0 = helper_523109b8(1)
		end
		if at <= 35 then
			helper_038a2e4d(vm.i32(46 - var0))
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_238b5abc(4)
		end
		if at <= 38 then
			helper_238b5abc(4)
		end
		if at <= 39 then
			helper_038a2e4d(40)
		end
		if at <= 40 then
			helper_238b5abc(4)
		end
		if at <= 41 then
			helper_038a2e4d(45)
		end
		if at <= 42 then
			helper_53ffe901(50030, 30)
		end
		if at <= 43 then
			helper_344d6cd8()
		end
		if at <= 44 then
			var0 = helper_523109b8(1)
		end
		if at <= 45 then
			helper_038a2e4d(vm.i32(30 - var0))
		end
		if at <= 46 then
			helper_038a2e4d(5)
		end
		if at <= 47 then
			helper_238b5abc(0)
		end
		if at <= 48 then
			helper_038a2e4d(40)
		end
		if at <= 49 then
			helper_038a2e4d(65)
		end
		if at <= 50 then
			helper_038a2e4d(20)
		end
		if at <= 51 then
			var2 = 0
			var3 = 2.0
		end
		if at <= 52 then
			var3 = vm.f32(var3 + vm.f32(0.1))
			var5 = vm.f32(var5 - var3)
			local _ = var2 < 30
			var2 = var2 + 1
			helper_238b5abc(0)
		end
		if at <= 53 then
			helper_038a2e4d(30)
		end
		if at <= 54 then
			helper_344d6cd8()
		end
		if at <= 55 then
			helper_53ffe901(50040, 130)
		end
		if at <= 56 then
			helper_238b5abc(0)
		end
		if at <= 57 then
			helper_038a2e4d(40)
		end
		if at <= 58 then
			helper_238b5abc(2)
		end
		if at <= 59 then
			helper_344d6cd8()
		end
		if at <= 61 then
			helper_53ffe901(50050, 50)
		end
		if at <= 63 then
			helper_53ffe901(50060, 360)
		end
		if at <= 64 then
			helper_238b5abc(3)
		end
		if at <= 66 then
			helper_53ffe901(50070, 90)
		end
		if at <= 67 then
			helper_238b5abc(0)
		end
		if at <= 68 then
			helper_53ffe901(50080, 40)
		end
		if at <= 69 then
			helper_53ffe901(50090, 30)
		end
		if at <= 70 then
			helper_238b5abc(0)
		end
		if at <= 71 then
			helper_038a2e4d(60)
		end
		if at <= 72 then
			helper_038a2e4d(60)
		end
		if at <= 73 then
			helper_53ffe901(50100, 136)
		end
		if at <= 74 then
			helper_238b5abc(0)
		end
		if at <= 75 then
			helper_53ffe901(50110, 130)
		end
		if at <= 77 then
			helper_344d6cd8()
		end
		if at <= 78 then
			helper_238b5abc(0)
		end
		if at <= 79 then
			helper_53ffe901(50120, 90)
		end
		if at <= 80 then
			helper_238b5abc(3)
		end
		if at <= 82 then
			helper_53ffe901(50130, 70)
		end
		if at <= 84 then
			helper_53ffe901(50140, 200)
		end
		if at <= 85 then
			helper_238b5abc(3)
		end
		if at <= 86 then
			helper_238b5abc(1)
		end
		if at <= 87 then
			helper_038a2e4d(30)
		end
		if at <= 88 then
			helper_344d6cd8()
		end
		if at <= 89 then
			helper_344d6cd8()
		end
		if at <= 90 then
			helper_238b5abc(0)
		end
		if at <= 91 then
			helper_238b5abc(2)
		end
		if at <= 92 then
			helper_238b5abc(0)
		end
		if at <= 93 then
			helper_038a2e4d(20)
		end
		if at <= 94 then
			helper_238b5abc(0)
		end
		if at <= 95 then
			helper_038a2e4d(10)
		end
		if at <= 96 then
			helper_038a2e4d(16)
		end
		if at <= 97 then
			helper_238b5abc(2)
		end
		if at <= 98 then
			helper_238b5abc(2)
		end
		if at <= 99 then
			helper_4a9b8bc5(0)
			helper_238b5abc(0)
		end
		if at <= 100 then
			helper_038a2e4d(10)
		end
		if at <= 101 then
			helper_038a2e4d(5)
		end
		if at <= 102 then
			helper_238b5abc(2)
		end
		if at <= 103 then
			helper_238b5abc(1)
		end
		if at <= 104 then
			helper_238b5abc(0)
		end
		if at <= 105 then
			helper_038a2e4d(20)
		end
		if at <= 106 then
			var0 = helper_523109b8(1)
		end
		if at <= 107 then
			helper_038a2e4d(vm.i32(10 - var0))
		end
		if at <= 108 then
			helper_238b5abc(0)
		end
		if at <= 109 then
			helper_038a2e4d(50)
		end
		if at <= 110 then
			helper_238b5abc(2)
		end
		if at <= 111 then
			helper_238b5abc(0)
		end
		if at <= 113 then
			helper_53ffe901(50150, 90)
		end
		if at <= 114 then
			helper_038a2e4d(10)
		end
		if at <= 115 then
			helper_238b5abc(0)
		end
		if at <= 116 then
			var0 = helper_523109b8(1)
		end
		if at <= 117 then
			helper_038a2e4d(vm.i32(30 - var0))
		end
		if at <= 118 then
			helper_238b5abc(0)
		end
		if at <= 119 then
			helper_53ffe901(50160, 200)
		end
		if at <= 120 then
			helper_238b5abc(1)
		end
		if at <= 121 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_972d1084(0, 40)
		end
		if at <= 122 then
			helper_d16eef1e(0)
			helper_238b5abc(1)
		end
		if at <= 123 then
			helper_238b5abc(0)
		end
		if at <= 124 then
			helper_4a9b8bc5(1)
			var0 = helper_523109b8(1)
		end
		if at <= 125 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_972d1084(0, vm.i32(40 - var0))
		end
		if at <= 126 then
			helper_d16eef1e(0)
			helper_238b5abc(0)
		end
		if at <= 127 then
			helper_038a2e4d(30)
		end
		if at <= 128 then
			helper_238b5abc(5)
		end
		if at <= 129 then
			helper_038a2e4d(35)
		end
		if at <= 130 then
			helper_238b5abc(2)
		end
		if at <= 131 then
			helper_238b5abc(2)
		end
		if at <= 132 then
			helper_038a2e4d(10)
		end
		if at <= 133 then
			helper_238b5abc(2)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SoundAllStop()
	event.StreamClose(1)
	at = 135
	helper_888ab2a3(4)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_21648

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_debc

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	local argc: s32 = 0
	event.SetLocalFlag(0, 0)
	helper_1201c()
	event.SndInReverb(0)
	argc = event.GetLocalFlag(0) or argc
	if argc == 1 then
		event.SetCrossfade(60)
	else
		event.SetFadeIn(60)
	end
	vm.wait(2)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetBgColor(0, 0, 0)
	event.SetMovieCc(0, 0)
	event.SetMovieCc(1, 0, 105.0, "あのときはすごくドキドキした。", 90)
	event.SetMovieCc(1, 1, 210.0, "でもちょっと楽しかったかな。", 90)
	event.SetMovieCc(1, 2, 390, "毎日たいくつなことばかりだったから。", 90)
	event.SetMovieCc(1, 3, 540, "これが、ボクの不思議な冒険の始まりだったんだ。", 150)
	event.SetMovieCc(0, 1)
	event.LoadMovie(5, "movie/open1.mp4")
	event.SetFadeOut(0)
	vm.wait(3)
	vm.wait(4)
	event.SetMovieCc(0, 0)
	event.SndInReverb(1)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.MapJump_3(-1, "d01e01", 151)
end

return script
