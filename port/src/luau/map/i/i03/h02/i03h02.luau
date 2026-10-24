--!strict
-- map/i/i03/h02/i03h02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_32eed468 = require("@lib/event/helper_32eed468")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_b8ac()
	local var0: s32 = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.InitDramaScene()
		event.AssignStack(4)
		event.ClearStack(4)
		event.AssignStack(5)
		event.ClearStack(5)
		var0 = event.SndLoadSound_2(1213) or var0
		event.LoadMotion(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 3)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, 0.0, -540.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/opening/p1/p1_people.gltf", "info", 9)
		event.CharaActive(9)
		event.SetCharaPos(9, 0.0, 0.0, -405.0)
		event.LoadChara(5, "event/opening/p1/p1_onna1.gltf", "info", 10)
		event.CharaActive(10)
		event.SetCharaPos(10, 18.39, 0.0, -421.29)
		event.LoadChara(5, "event/opening/p1/p1_otoko1.gltf", "info", 11)
		event.CharaActive(11)
		event.SetCharaPos(11, 27.92, 0.0, -433.74)
		event.LoadChara(5, "event/opening/p1/p1_otoko2.gltf", "info", 12)
		event.CharaActive(12)
		event.SetCharaPos(12, -25.29, 0.0, -426.67)
		event.LoadChara(5, "event/opening/p1/p2_macho.gltf", "info", 13)
		event.CharaActive(13)
		event.EohSyncChara(5, 13)
		event.EohSetFrameShow(5, "sphere1", 0)
		event.EohSetFrameShow(5, "sphere1_1", 0)
		event.EohSetFrameShow(5, "sphere1_2", 0)
		event.EohSetFrameShow(5, "sphere1_3", 0)
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetPos(5, 0.0, 11.23, 0.0)
		event.ObjsSetRot(5, 0.0, 3.14, 0.0)
		event.EohSetShadow(5, 0)
		event.SetLoadbgFile_1("event/opening/p1/p2_pierrot.gltf")
		vm.wait(1)
		helper_479dc9e9()
		event.LoadChara(5, "event/opening/p1/p2_pierrot.gltf", "info", 14)
		event.CharaActive(14)
		event.LoadChara(5, "event/opening/p1/p2_pierrot.gltf", "info", 15)
		event.CharaActive(15)
		event.LoadChara(5, "event/opening/p1/p2_pierrot.gltf", "info", 16)
		event.CharaActive(16)
		event.LoadChara(5, "event/opening/p1/p2_pierrot.gltf", "info", 17)
		event.CharaActive(17)
		event.ObjsSetMotion(0, "歩き", 4)
		event.ObjsMove(0, 0.0, 0.0, -440.0, 120)
		event.ObjsSetMotion(5, "投げ4回", 4)
		event.SetMotion(14, "回転1", 4)
		event.SetReference(13, "sphere1", 14)
		event.SetMotion(15, "回転1", 4)
		event.SetReference(13, "sphere1_1", 15)
		event.SetMotion(16, "回転1", 4)
		event.SetReference(13, "sphere1_2", 16)
		event.SetMotion(17, "回転1", 4)
		event.SetReference(13, "sphere1_3", 17)
		event.EohSyncObj_2(31, "p01_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p02_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-1")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-2")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-3")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-4")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-5")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-6")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p04_i03h02a-7")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p05_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p06_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p07_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p08_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p11_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p13_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p14_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p15_i03h02a")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p10_i03h02a-1")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p10_i03h02a-2")
		event.EohSetShow(31, 0)
		event.EohSyncObj_2(31, "p10_i03h02a-3")
		event.EohSetShow(31, 0)
		event.SetActiveLight(1)
		event.CmrsInit()
		event.CmrsSetPos(0.0, 18.72, -581.27)
		event.CmrsSetRef(0.0, -0.38, -526.54)
		event.CmrsMove(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
		event.CmrsFadeInit()
		event.CmrsFadeIn(60)
		helper_c624bc16()
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "旧・立ち")
		helper_888ab2a3(30)
		event.CmrsSetPos(-17.16, 17.61, -542.92)
		event.CmrsSetRef(2.33, 20.36, -409.98)
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "見えないよ", 2)
		event.ObjsNextMotion(0, "見えないよL", 4)
		event.ObjsSeDelay(0, 10)
		event.ObjsSePlay(0, var0, 4)
		event.ObjsSeDelay(0, 110)
		event.ObjsSePlay(0, var0, 5)
		helper_888ab2a3(200)
		event.ObjsSePlay(0, var0, 6)
		helper_9e7d1511(0, 1033, 8, 200, 200)
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "見えないよ戻り", 2)
		event.ObjsNextMotion(0, "旧・立ち", 4)
		helper_0958ca60(0)
		helper_888ab2a3(10)
		event.ObjsSetMotion(0, "キョロキョロ", 6)
		event.ObjsNextMotion(0, "旧・立ち", 4)
		helper_0958ca60(0)
		helper_888ab2a3(10)
		event.CmrsSetPos(-54.54, 71.63, -344.23)
		event.CmrsSetRef(5.47, 6.56, -479.98)
		event.ObjsSetMotion(0, "走り")
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 80)
		event.ObjsAddPas(0, 0.0, 0.0, -440.0)
		event.ObjsAddPas(0, 25.41, 0.0, -505.85)
		event.ObjsAddPas(0, 59.73, 0.0, -569.39)
		event.ObjsAddPas(0, 107.09, 0.0, -622.8)
		event.ObjsAddPas(0, 163.05, 0.0, -656.61)
		event.ObjsAddPas(0, 223.93, 0.0, -656.14)
		event.ObjsStartPas(0)
		helper_0958ca60(0)
		event.SetActiveLight(0)
		vm.wait(15)
		event.CmrsSetPos(385.44, 20.74, -469.02)
		event.CmrsSetRef(478.52, 20.25, -405.79)
		event.ObjsSetPos(0, 431.02, 0.0, -509.53)
		event.ObjsSetRot(0, 0.0, 0.36, 0.0)
		event.ObjsMove(0, 457.0, 0.0, -428.0, 40)
		event.ObjsRotDelay(0, 35)
		event.ObjsRotation(0, 0.0, 0.72, 0.0, 5)
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "旧・立ち")
		helper_888ab2a3(10)
		event.ObjsSetMotion(0, "はしご登り", 2)
		helper_888ab2a3(40)
		event.EohSetFootSoundId(0, 9)
		event.CmrsMove(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.ObjsMotionWait(0)
		helper_0958ca60(0)
		helper_c624bc16()
		event.CmrsSetPos(490.63, 181.9, -336.25)
		event.CmrsSetRef(424.28, 114.59, -295.7)
		event.ObjsSetPos(0, 441.37, 133.45, -339.86)
		event.ObjsSetRot(0, 0.0, 0.41, 0.0)
		event.ObjsMove(0, 459.04, 133.45, -308.23, 40)
		event.EohSetShadow(5, 1)
		event.EohSetFootSoundId(0, 3)
		event.ObjsSetMotion(0, "右向き歩き", 6)
		event.ObjsNextMotion(0, "右を向く", 6)
		event.ObjsNextMotion(0, "右を向くL", 4)
		event.ObjsSeDelay(0, 40)
		event.ObjsSePlay(0, var0, 9)
		helper_32eed468(0, 1034, 8, 200, 200, 60)
		helper_0958ca60(0)
		helper_c624bc16()
		event.CmrsMove(492.91, 169.38, -343.35, 431.02, 155.35, -293.19, 200)
		event.CmrsPrSlowing(0.94, 30)
		helper_c624bc16()
		helper_888ab2a3(30)
		event.CmrsFadeInit()
		event.CmrsFadeOut(60)
		helper_c624bc16()
	end)
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
	event.EohSyncObj_2(31, "p01_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p02_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-1")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-2")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-3")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-4")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-5")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-6")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p04_i03h02a-7")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p05_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p06_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p07_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p08_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p11_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p13_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p14_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p15_i03h02a")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p10_i03h02a-1")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p10_i03h02a-2")
	event.EohSetShow(31, 1)
	event.EohSyncObj_2(31, "p10_i03h02a-3")
	event.EohSetShow(31, 1)
	event.SetActiveLight(0)
	event.CharaActive(0)
end

--- Helper function.
local function helper_eef0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		event.SetMesWindowMode(0, 7)
		event.CharaActive(0, 0)
		event.AssignStack(4)
		event.ClearStack(4)
		event.AssignStack(5)
		event.ClearStack(5)
		var0 = event.SndLoadSound_2(1214) or var0
		event.LoadChara(5, "event/opening/p2/p2_erephant.gltf", "info", 13)
		event.CharaActive(13)
		event.EohSyncChara(5, 13)
		event.EohSetSoundId(5, var0)
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetPos(5, 279.22, 0.0, 581.89)
		event.ObjsSetRot(5, 0.0, -1.68, 0.0)
		event.ObjsSetMotion(5, "立ち", 4)
		event.LoadChara(5, "event/opening/p2/p2_ball.gltf", "info", 14)
		event.CharaActive(14)
		event.EohSyncChara(6, 14)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetPos(6, 0.0, -100.0, 0.0)
		event.ObjsSetRot(6, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(6, "玉持ち上げ", 5)
		event.LoadChara(5, "event/opening/p2/p2_myrene.gltf", "info", 15)
		event.CharaActive(15)
		event.EohSyncChara(7, 15)
		event.EohSetSoundId(7, var0)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.ObjsSetPos(7, 15.06, -111.23, -91.33)
		event.ObjsSetRot(7, 0.0, -1.8, 0.0)
		event.ObjsTexAnime(7, 0)
		event.LoadChara(5, "event/opening/p2/p2_erephant_bup.gltf", "info", 16)
		event.CharaActive(0, 16)
		event.EohSyncChara(8, 16)
		event.ObjsInit(8)
		event.ObjsSyncObj(8, 8)
		event.ObjsSetPos(8, 6.14, 0.0, 4.14)
		event.ObjsSetRot(8, 0.0, -2.88, 0.0)
		event.LoadChara(5, "event/opening/p2/p2_kiran.gltf", "info", 17)
		event.CharaActive(0, 17)
		event.EohSyncChara(9, 17)
		event.ObjsInit(9)
		event.ObjsSyncObj(9, 9)
		event.ObjsSetPos(9, -5.37, 38.44, -29.5)
		event.ObjsSetRot(9, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(9, "キラーン", 5)
		event.AssignStack(6)
		event.ClearStack(6)
		event.LoadChara(6, "event/opening/p2/p2_macho.gltf", "info", 8)
		event.CharaActive(8)
		event.EohSyncChara(0, 8)
		event.EohSetSoundId(0, var0)
		event.EohSetFrameShow(0, "sphere1", 0)
		event.EohSetFrameShow(0, "sphere1_1", 0)
		event.EohSetFrameShow(0, "sphere1_2", 0)
		event.EohSetFrameShow(0, "sphere1_3", 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, 11.23, 0.0)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.SetLoadbgFile_1("event/opening/p2/p2_pierrot.gltf")
		at = 1
		vm.wait(1)
		at = 2
		helper_479dc9e9()
		event.LoadChara(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
		event.CharaActive(9)
		event.EohSyncChara(1, 9)
		event.EohSetSoundId(1, var0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetPos(1, 0.0, 0.0, 0.0)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.LoadChara(6, "event/opening/p2/p2_pierrot.gltf", "info", 10)
		event.CharaActive(10)
		event.EohSyncChara(2, 10)
		event.EohSetSoundId(2, var0)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetPos(2, 0.0, 0.0, 0.0)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.LoadChara(6, "event/opening/p2/p2_pierrot.gltf", "info", 11)
		event.CharaActive(11)
		event.EohSyncChara(3, 11)
		event.EohSetSoundId(3, var0)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 0.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.LoadChara(6, "event/opening/p2/p2_pierrot.gltf", "info", 12)
		event.CharaActive(12)
		event.EohSyncChara(4, 12)
		event.EohSetSoundId(4, var0)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.0, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "投げ4回", 4)
		event.ObjsSetMotion(1, "回転1", 4)
		event.SetReference(8, "sphere1", 9)
		event.ObjsSetMotion(2, "回転1", 4)
		event.SetReference(8, "sphere1_1", 10)
		event.ObjsSetMotion(3, "回転1", 4)
		event.SetReference(8, "sphere1_2", 11)
		event.ObjsSetMotion(4, "回転1", 4)
		event.SetReference(8, "sphere1_3", 12)
		event.CmrsInit()
		event.CmrsSetPos(0.0, 125.0, -120.0)
		event.CmrsSetRef(0.0, 125.0, 0.0)
		event.CmrsMove(0.0, 30.0, -120.0, 0.0, 30.0, 0.0, 220)
		event.CmrsFadeInit()
		event.CmrsFadeIn(30)
		at = 3
		helper_c624bc16()
		event.CmrsSetPos(0.0, 30.0, -180.0)
		event.CmrsSetRef(0.0, 30.0, 0.0)
		event.ObjsSetMotion(0, "投げ４回からTポーズ", 6)
		event.ObjsNextMotion(0, "Tポーズ", 4)
		at = 4
		helper_888ab2a3(26)
		event.DelReference(9)
		event.DelReference(10)
		event.DelReference(11)
		event.DelReference(12)
		event.ObjsSetPos(1, -60.0, 11.23, -30.0)
		event.ObjsSetRot(1, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(1, "着地", 5, 0.5)
		event.EohSetShadow(1, 0)
		event.ObjsSetPos(2, -20.0, 11.23, -30.0)
		event.ObjsSetRot(2, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(2, "着地", 5, 0.5)
		event.EohSetShadow(2, 0)
		event.ObjsSetPos(3, 20.0, 11.23, -30.0)
		event.ObjsSetRot(3, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(3, "着地", 5, 0.5)
		event.EohSetShadow(3, 0)
		event.ObjsSetPos(4, 60.0, 11.23, -30.0)
		event.ObjsSetRot(4, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(4, "着地", 5, 0.5)
		event.EohSetShadow(4, 0)
		event.ObjsSePlay(1, var0, 5)
		event.ObjsSetMotion(1, "着地", 6)
		event.ObjsNextMotion(1, "着地ループ", 4)
		at = 5
		helper_888ab2a3(10)
		event.ObjsSetMotion(2, "着地", 6)
		event.ObjsNextMotion(2, "着地ループ", 4)
		at = 6
		helper_888ab2a3(10)
		event.ObjsSetMotion(3, "着地", 6)
		event.ObjsNextMotion(3, "着地ループ", 4)
		at = 7
		helper_888ab2a3(10)
		event.ObjsSetMotion(4, "着地", 6)
		event.ObjsNextMotion(4, "着地ループ", 4)
		event.EohSetShadow(1, 1)
		at = 8
		helper_888ab2a3(12)
		event.EohSetShadow(2, 1)
		at = 9
		helper_888ab2a3(12)
		event.EohSetShadow(3, 1)
		at = 10
		helper_888ab2a3(12)
		event.EohSetShadow(4, 1)
		event.ObjsSetMotion(0, "Tポーズから決め", 6)
		event.ObjsNextMotion(0, "決めループ", 6)
		event.ObjsMotionWait(0)
		at = 11
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "決めからおじぎ", 6)
		event.ObjsNextMotion(0, "おじぎループ", 6)
		event.ObjsNextMotion(0, "おじぎから立ち", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "着地ループからおじぎ", 6)
		event.ObjsNextMotion(1, "おじぎループ", 6)
		event.ObjsNextMotion(1, "おじぎから立ち", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsSetMotion(2, "着地ループからおじぎ", 6)
		event.ObjsNextMotion(2, "おじぎループ", 6)
		event.ObjsNextMotion(2, "おじぎから立ち", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		event.ObjsSetMotion(3, "着地ループからおじぎ", 6)
		event.ObjsNextMotion(3, "おじぎループ", 6)
		event.ObjsNextMotion(3, "おじぎから立ち", 6)
		event.ObjsNextMotion(3, "立ち", 4)
		event.ObjsSetMotion(4, "着地ループからおじぎ", 6)
		event.ObjsNextMotion(4, "おじぎループ", 6)
		event.ObjsNextMotion(4, "おじぎから立ち", 6)
		event.ObjsNextMotion(4, "立ち", 4)
		event.ObjsSetMotion(5, "歩き", 4)
		event.ObjsInitPas(5)
		event.ObjsSetPasFrm(5, 280)
		event.ObjsAddPas(5, 279.22, 0.0, 581.89)
		event.ObjsAddPas(5, 178.82, 0.0, 562.97)
		event.ObjsAddPas(5, 117.49, 0.0, 543.89)
		event.ObjsAddPas(5, 66.41, 0.0, 514.73)
		event.ObjsStartPas(5)
		event.ObjsSeDelay(5, 120)
		event.ObjsSePlay(5, var0, 6)
		event.ObjsSeDelay(5, 120)
		event.ObjsSePlay(5, var0, 6)
		at = 12
		helper_0958ca60(0)
		at = 13
		helper_0958ca60(1)
		at = 14
		helper_0958ca60(2)
		at = 15
		helper_0958ca60(3)
		at = 16
		helper_0958ca60(4)
		event.EohSetSoundId(1, -1)
		event.EohSetSoundId(2, var0)
		event.EohSetSoundId(3, var0)
		event.EohSetSoundId(4, -1)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -43.35, 11.23, -155.32, 120)
		event.ObjsRotation(0, 0.0, -2.9, 0.0, 10)
		event.ObjsSetMotion(2, "走り")
		event.ObjsMove(2, -90.31, 11.23, -38.89, 30)
		event.ObjsRotation(2, 0.0, -2.18, 0.0, 10)
		at = 17
		helper_888ab2a3(3)
		event.ObjsSetMotion(3, "走り")
		event.ObjsMove(3, 90.31, 11.23, -38.89, 30)
		event.ObjsRotation(3, 0.0, 2.18, 0.0, 10)
		at = 18
		helper_888ab2a3(2)
		event.ObjsSetMotion(1, "走り")
		event.ObjsMove(1, -90.31, 11.23, -38.89, 15)
		event.ObjsRotation(1, 0.0, -2.18, 0.0, 10)
		event.ObjsSetMotion(4, "走り")
		event.ObjsMove(4, 90.31, 11.23, -38.89, 15)
		event.ObjsRotation(4, 0.0, 2.18, 0.0, 10)
		at = 19
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "立ち")
		at = 20
		helper_0958ca60(4)
		event.ObjsSetMotion(4, "立ち")
		at = 21
		helper_0958ca60(2)
		event.ObjsSetMotion(2, "立ち")
		at = 22
		helper_0958ca60(3)
		event.ObjsSetMotion(3, "立ち")
		at = 23
		helper_0958ca60(5)
		event.CmrsSetPos(-107.78, 17.46, -52.75)
		event.CmrsSetRef(-0.22, 62.14, -20.34)
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
		event.CharaActive(0, 11)
		event.CharaActive(0, 12)
		event.ObjsSetPos(5, 0.0, 11.23, 80.0)
		event.ObjsSetRot(5, 0.0, 3.14, 0.0)
		event.ObjsMove(5, 0.0, 11.23, -30.0, 160)
		event.ObjsSeDelay(5, 30)
		event.ObjsSePlay(5, var0, 6)
		event.ObjsSeDelay(5, 90)
		event.ObjsSePlay(5, var0, 6)
		at = 24
		helper_0958ca60(5)
		event.ObjsSetMotion(5, "パオーン", 2)
		event.ObjsNextMotion(5, "立ち", 4)
		event.ObjsSeDelay(5, 20)
		event.ObjsSePlay(5, var0, 7)
		event.ObjsSeDelay(5, 30)
		event.ObjsSePlay(5, var0, 8)
		at = 25
		helper_888ab2a3(62)
		event.CmrsQuake(0.0, 4.0, 0.0, 25)
		at = 26
		helper_0958ca60(5)
		at = 27
		helper_c624bc16()
		event.SetLoadbgFile_2("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
		event.ObjsSetMotion(7, "歩き", 4)
		event.ObjsSetPos(7, 15.06, 11.23, -91.33)
		event.ObjsSetRot(7, 0.0, -0.96, 0.0)
		event.ObjsRotDelay(7, 80)
		event.ObjsRotation(7, 0.0, -1.8, 0.0, 10)
		event.ObjsMove(7, -68.07, 11.23, -40.78, 90)
		at = 28
		helper_0958ca60(7)
		event.ObjsSetMotion(7, "登場ポーズ", 2)
		event.ObjsMotionWait(7)
		event.CmrsMove(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
		at = 29
		helper_c624bc16()
		at = 30
		helper_0958ca60(7)
		event.ObjsSetMotion(7, "歩き")
		event.ObjsMove(7, -31.47, 11.23, -3.92, 60)
		event.ObjsRotation(7, 0.0, 0.72, 0.0, 10)
		at = 31
		helper_0958ca60(7)
		event.ObjsSetMotion(5, "ごにょごごにょ", 2)
		event.ObjsNextMotion(5, "ごにょごにょループ", 4)
		event.ObjsRotation(7, 0.0, 1.32, 0.0, 20)
		event.ObjsSetMotion(7, "ごにょごにょ", 2)
		event.ObjsNextMotion(7, "ごにょごにょL", 6)
		event.ObjsMotionWait(7)
		event.ObjsSeDelay(7, 10)
		event.ObjsSePlay(7, var0, 9)
		at = 32
		helper_0958ca60(7)
		event.CmrsSetPos(-40.25, 30.96, -47.72)
		event.CmrsSetRef(-5.49, 44.23, -27.58)
		event.CharaActive(0, 13)
		event.CharaActive(1, 16)
		event.ObjsSePlay(5, var0, 10)
		at = 33
		helper_888ab2a3(60)
		event.CmrsSetPos(0.0, 95.44, -190.42)
		event.CmrsSetRef(0.0, 62.65, 0.0)
		event.CharaActive(1, 13)
		event.CharaActive(0, 16)
		event.ObjsSetMotion(5, "玉持ち上げ", 6)
		event.ObjsNextMotion(5, "玉持ち上げループ", 4)
		event.ObjsSePlay(5, var0, 11)
		event.ObjsSeDelay(5, 30)
		event.ObjsSePlay(5, var0, 12)
		event.ObjsSetPos(6, 0.0, 11.23, -30.0)
		event.ObjsSetMotion(6, "玉持ち上げ", 6)
		event.ObjsNextMotion(6, "玉持ち上げループ", 4)
		event.ObjsSetRot(7, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(7, "歩き", 4)
		event.ObjsRotation(7, 0.0, -1.57, 0.0, 20)
		event.ObjsMove(7, -132.5, 11.23, 0.93, 90)
		at = 34
		helper_0958ca60(7)
		event.CharaActive(0, 15)
		event.CmrsSetPos(0.4, 14.44, -179.22)
		event.CmrsSetRef(0.0, 67.37, 0.0)
		event.ObjsSetMotion(5, "バイシクルシュート", 6)
		event.ObjsSetMotion(6, "バイシクルシュート", 6)
		at = 35
		helper_888ab2a3(70)
		event.CmrsQuake(0.0, 4.0, 0.0, 25)
		at = 36
		helper_888ab2a3(29)
		event.ObjsSetMotion(5, "バイシクルシュート", 1)
		event.ObjsSetMotion(6, "バイシクルシュート", 1)
		event.CmrsSetPos(-10.4, 37.62, -49.49)
		event.CmrsSetRef(-1.23, 39.37, -21.13)
		event.CharaActive(0, 13)
		event.CharaActive(1, 16)
		event.ObjsSetPos(8, -2.78, -2.07, 15.89)
		event.ObjsSetRot(8, 0.0, 3.02, 0.0)
		var1 = 0
		var2 = vm.f32(0.8)
		var3 = vm.f32(-2.07)
		while var1 < 10 do
			var2 = vm.f32(var2 * vm.f32(0.8))
			var3 = vm.f32(var3 - var2)
			event.ObjsSetPos(8, -2.78, var3, 15.89)
			var1 = var1 + 1
			print(var3, "\n")
			at = 37
			vm.wait(37)
		end
		event.CharaActive(17)
		event.ObjsSetMotion(9, "キラーン", 6)
		event.ObjsSePlay(5, var0, 13)
		at = 38
		helper_888ab2a3(10)
		event.CharaActive(0, 17)
		at = 39
		helper_888ab2a3(10)
		event.CmrsSetPos(-168.96, 18.9, -103.54)
		event.CmrsSetRef(-5.14, 75.4, 8.39)
		event.CharaActive(1, 13)
		event.CharaActive(0, 16)
		event.ObjsSetMotion(5, "バイシクルシュート", 2)
		event.ObjsSetMotion(6, "バイシクルシュート", 2)
		event.ObjsSePlay(5, var0, 14)
		at = 40
		helper_888ab2a3(9)
		event.ObjsSetStep(5, 0.01)
		event.ObjsSetStep(6, 0.01)
		event.CmrsSetPos(-197.04, 171.4, 0.74)
		event.CmrsSetRef(0.0, 121.4, 0.0)
		event.CmrsMoveAhd(1.57, 0.0, 197.04, 100)
		event.CmrsMoveAhd(3.14, -25.0, 197.04, 50)
		event.CmrsMoveAhd(-1.57, -50.0, 197.04, 50)
		at = 41
		helper_c624bc16()
		event.ObjsSetStep(5, 0.6)
		event.ObjsSetStep(6, 0.6)
		event.ObjsMotionWait(5)
		event.ObjsSePlay(5, var0, 15)
		at = 42
		helper_888ab2a3(5)
		event.CmrsQuake(0.0, 4.0, 0.0, 25)
		at = 43
		helper_c624bc16()
		at = 44
		helper_0958ca60(5)
		event.CmrsSetPos(-120.33, 279.87, -18.7)
		event.CmrsSetRef(138.46, 217.78, 141.95)
		event.ObjsSetPos(6, 0.0, 0.0, 0.0)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(6, "右のピエロ", 6)
		event.ObjsSeDelay(6, 10)
		event.ObjsSePlay(6, var0, 16)
		at = 45
		helper_888ab2a3(20)
		event.CmrsSetPos(87.54, 42.85, 80.82)
		event.CmrsSetRef(-204.62, 211.5, 188.69)
		event.ObjsSetMotion(6, "左のピエロ", 6)
		event.ObjsSeDelay(6, 10)
		event.ObjsSePlay(6, var0, 16)
		at = 46
		helper_888ab2a3(20)
		event.CmrsSetPos(37.29, 24.91, -191.53)
		event.CmrsSetRef(5.05, 69.55, -9.71)
		event.ObjsSetMotion(5, "キャッチ＆決め入り", 6)
		event.ObjsNextMotion(5, "決めループ", 4)
		event.ObjsSeDelay(5, 24)
		event.ObjsSePlay(5, var0, 17)
		event.ObjsSetPos(6, 0.0, 11.23, -30.0)
		event.ObjsSetRot(6, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(6, "キャッチ＆決め入り", 6)
		event.ObjsNextMotion(6, "決めループ", 4)
		at = 47
		helper_888ab2a3(50)
		event.CmrsQuake(0.0, 4.0, 0.0, 25)
		at = 48
		helper_0958ca60(5)
		event.ObjsSePlay(5, var0, 18)
		event.CmrsSetPos(-55.0, 150.0, 230.0)
		event.CmrsSetRef(0.0, 50.0, -30.0)
		event.CmrsMove(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
		at = 49
		helper_c624bc16()
		event.CmrsSetPos(37.29, 24.91, -191.53)
		event.CmrsSetRef(5.05, 69.55, -9.71)
		event.ObjsSetMotion(6, "キャッチ＆決め終わり", 6)
		event.ObjsSetMotion(5, "キャッチ＆決め終わり", 6)
		event.ObjsNextMotion(5, "立ち", 4)
		at = 50
		helper_888ab2a3(30)
		event.CmrsQuake(0.0, 4.0, 0.0, 20)
		at = 51
		helper_c624bc16()
		at = 52
		helper_0958ca60(5)
		at = 53
		helper_479dc9e9()
		event.CharaActive(0, 14)
		event.SndSePlay(var0, 19)
		event.CmrsMove2(245.05, 229.37, -124.72, 308.65, 198.37, -0.0, 90, 0, 0.3)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.ObjsInit(2)
		event.ObjsInit(3)
		event.ObjsInit(4)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.ClearStack(6)
		event.LoadChara(6, "event/opening/p2/p2_bura_pie.gltf", "info", 8)
		event.CharaActive(8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, 0.0, 0.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "待機", 4)
		event.LoadChara(6, "event/opening/p2/p2_buranko.gltf", "info", 9)
		event.CharaActive(9)
		event.EohSyncChara(1, 9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetPos(1, 0.0, 0.0, 0.0)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(1, "待機", 4)
		at = 54
		helper_c624bc16()
		event.CharaActive(0, 13)
		event.CmrsSyncObj(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
		at = 55
		helper_888ab2a3(60)
		event.SndSeStop(var0, 19)
		event.SndSePlay(var0, 20)
		event.ObjsSetMotion(0, "ピエロブランコ", 6)
		event.ObjsSetMotion(1, "ピエロブランコ", 6)
		event.ObjsSeDelay(0, 30)
		event.ObjsSePlay(0, var0, 21)
		event.ObjsSeDelay(0, 50)
		event.ObjsSePlay(0, var0, 21)
		at = 56
		helper_888ab2a3(60)
		at = 57
		helper_888ab2a3(40)
		event.CmrsMoveAhd(-3.14, 0.0, 140.0, 60)
		at = 58
		helper_888ab2a3(90)
		event.EohSyncObj_2(31, "p10_i03h02")
		event.EohSetShow(31, 0)
		event.CmrsReleaseObj()
		event.ObjsSePlay(0, var0, 25)
		event.CmrsMove(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
		at = 59
		helper_c624bc16()
		event.CmrsSetPos(0.0, 237.95, -275.71)
		event.CmrsSetRef(0.0, 212.96, -32.39)
		event.ObjsSetPos(0, 170.0, 0.0, 0.0)
		event.ObjsSetPos(1, 170.0, 0.0, 0.0)
		at = 60
		helper_888ab2a3(20)
		event.CharaActive(1, 15)
		event.ObjsSetPos(7, 0.0, 11.23, 0.0)
		event.ObjsSetRot(7, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(7, "ムーンサルト", 6)
		event.ObjsNextMotion(7, "ムーンサルトL", 4)
		event.ObjsSeDelay(7, 20)
		event.ObjsSePlay(7, var0, 26)
		event.ObjsSeDelay(7, 45)
		event.ObjsSePlay(7, var0, 27)
		at = 61
		helper_888ab2a3(50)
		event.EohSetShow(31, 1)
		at = 62
		helper_c624bc16()
		event.CmrsSetPos(0.0, 53.51, -115.19)
		event.CmrsSetRef(0.0, 35.43, 0.41)
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
		at = 63
		helper_0958ca60(7)
		event.CmrsSetPos(-27.17, 57.91, -13.37)
		event.CmrsSetRef(1.6, 40.06, 1.5)
		event.ObjsSetMotion(7, "ウィンク", 6)
		event.ObjsNextMotion(7, "ウィンクL", 4)
		event.ObjsTexAnime(7, 0)
		event.ObjsTexAnime(7, 1, "ウインク")
		event.ObjsTexAnime(7, 1, "決めの口")
		event.ObjsSePlay(7, var0, 28)
		event.ObjsSeDelay(7, 20)
		event.ObjsSePlay(7, var0, 29)
		at = 64
		helper_0958ca60(7)
		at = 65
		helper_888ab2a3(30)
		event.CmrsMove2(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
		at = 66
		helper_c624bc16()
		event.CmrsFadeInit()
		event.CmrsFadeOut(30)
		at = 67
		helper_c624bc16()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_038a2e4d(26)
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_038a2e4d(10)
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_038a2e4d(12)
		end
		if at <= 8 then
			helper_038a2e4d(12)
		end
		if at <= 9 then
			helper_038a2e4d(12)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_238b5abc(2)
		end
		if at <= 14 then
			helper_238b5abc(3)
		end
		if at <= 15 then
			helper_238b5abc(4)
		end
		if at <= 16 then
			helper_038a2e4d(3)
		end
		if at <= 17 then
			helper_038a2e4d(2)
		end
		if at <= 18 then
			helper_238b5abc(1)
		end
		if at <= 19 then
			helper_238b5abc(4)
		end
		if at <= 20 then
			helper_238b5abc(2)
		end
		if at <= 21 then
			helper_238b5abc(3)
		end
		if at <= 22 then
			helper_238b5abc(5)
		end
		if at <= 23 then
			helper_238b5abc(5)
		end
		if at <= 24 then
			helper_038a2e4d(62)
		end
		if at <= 25 then
			helper_238b5abc(5)
		end
		if at <= 26 then
			helper_344d6cd8()
		end
		if at <= 27 then
			helper_238b5abc(7)
		end
		if at <= 28 then
			helper_344d6cd8()
		end
		if at <= 29 then
			helper_238b5abc(7)
		end
		if at <= 30 then
			helper_238b5abc(7)
		end
		if at <= 31 then
			helper_238b5abc(7)
		end
		if at <= 32 then
			helper_038a2e4d(60)
		end
		if at <= 33 then
			helper_238b5abc(7)
		end
		if at <= 34 then
			helper_038a2e4d(70)
		end
		if at <= 35 then
			helper_038a2e4d(29)
		end
		if at <= 36 then
			var1 = 0
			var2 = vm.f32(0.8)
			var3 = vm.f32(-2.07)
			var2 = vm.f32(var2 * vm.f32(0.8))
			var3 = vm.f32(var3 - var2)
			local _ = var1 < 10
			var1 = var1 + 1
			print(var3, "\n")
		end
		if at <= 37 then
			helper_038a2e4d(10)
		end
		if at <= 38 then
			helper_038a2e4d(10)
		end
		if at <= 39 then
			helper_038a2e4d(9)
		end
		if at <= 40 then
			helper_344d6cd8()
		end
		if at <= 41 then
			helper_038a2e4d(5)
		end
		if at <= 42 then
			helper_344d6cd8()
		end
		if at <= 43 then
			helper_238b5abc(5)
		end
		if at <= 44 then
			helper_038a2e4d(20)
		end
		if at <= 45 then
			helper_038a2e4d(20)
		end
		if at <= 46 then
			helper_038a2e4d(50)
		end
		if at <= 47 then
			helper_238b5abc(5)
		end
		if at <= 48 then
			helper_344d6cd8()
		end
		if at <= 49 then
			helper_038a2e4d(30)
		end
		if at <= 50 then
			helper_344d6cd8()
		end
		if at <= 51 then
			helper_238b5abc(5)
		end
		if at <= 52 then
			helper_344d6cd8()
		end
		if at <= 53 then
			helper_344d6cd8()
		end
		if at <= 54 then
			helper_038a2e4d(60)
		end
		if at <= 55 then
			helper_038a2e4d(60)
		end
		if at <= 56 then
			helper_038a2e4d(40)
		end
		if at <= 57 then
			helper_038a2e4d(90)
		end
		if at <= 58 then
			helper_344d6cd8()
		end
		if at <= 59 then
			helper_038a2e4d(20)
		end
		if at <= 60 then
			helper_038a2e4d(50)
		end
		if at <= 61 then
			helper_344d6cd8()
		end
		if at <= 62 then
			helper_238b5abc(7)
		end
		if at <= 63 then
			helper_238b5abc(7)
		end
		if at <= 64 then
			helper_038a2e4d(30)
		end
		if at <= 65 then
			helper_344d6cd8()
		end
		if at <= 66 then
			helper_344d6cd8()
		end
		return true
	end)
	event.CancelDramaScene()
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.DeleteChara(17)
	event.SndSeStop(var0, 19)
	event.SndSeStop(var0, 28)
	event.SndSeStop(var0, 29)
	event.StopEnvBgm()
	at = 68
	helper_888ab2a3(6)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_b8ac()
	helper_eef0()
	event.LoadScript("i03h02/i03h02_2.stb", 151)
end

return script
