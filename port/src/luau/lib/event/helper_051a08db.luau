--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a344ece = require("@lib/event/helper_0a344ece")
local helper_75f3e820 = require("@lib/event/helper_75f3e820")
local helper_9b8126b9 = require("@lib/event/helper_9b8126b9")
local helper_a057a7e5 = require("@lib/event/helper_a057a7e5")
local helper_ae53acce = require("@lib/event/helper_ae53acce")
local helper_ffeb2648 = require("@lib/event/helper_ffeb2648")

--- Helper function.
local function helper_051a08db()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 26 then
			if at <= 1 then
				helper_ffeb2648()
			end
			if at <= 2 then
				helper_9b8126b9()
			end
			if at <= 3 then
				helper_ae53acce(0)
			end
			if at <= 4 then
				helper_75f3e820(30)
			end
			if at <= 5 then
				helper_75f3e820(30)
			end
			if at <= 6 then
				helper_75f3e820(200)
			end
			if at <= 7 then
				helper_0a344ece(0, 1033, 8, 200, 200)
			end
			if at <= 8 then
				helper_ae53acce(0)
			end
			if at <= 9 then
				helper_ae53acce(0)
			end
			if at <= 10 then
				helper_75f3e820(10)
			end
			if at <= 11 then
				helper_ae53acce(0)
			end
			if at <= 12 then
				helper_75f3e820(10)
			end
			if at <= 13 then
				helper_ae53acce(0)
			end
			if at <= 15 then
				helper_ae53acce(0)
			end
			if at <= 16 then
				helper_75f3e820(10)
			end
			if at <= 17 then
				helper_75f3e820(40)
			end
			if at <= 18 then
				helper_ae53acce(0)
			end
			if at <= 19 then
				helper_9b8126b9()
			end
			if at <= 20 then
				helper_a057a7e5(0, 1034, 8, 200, 200, 60)
			end
			if at <= 21 then
				helper_ae53acce(0)
			end
			if at <= 22 then
				helper_9b8126b9()
			end
			if at <= 23 then
				helper_9b8126b9()
			end
			if at <= 24 then
				helper_75f3e820(30)
			end
			if at <= 25 then
				helper_9b8126b9()
			end
			if vm.skip_end() then
				return skip(27)
			end
			return part2()
		end
	end
	function part2()
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
		event.EohSyncObj(31, "p01_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p02_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-1")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-2")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-3")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-4")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-5")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-6")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p04_i03h02a-7")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p05_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p06_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p07_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p08_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p11_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p13_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p14_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p15_i03h02a")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p10_i03h02a-1")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p10_i03h02a-2")
		event.EohSetShow(31, 1)
		event.EohSyncObj(31, "p10_i03h02a-3")
		event.EohSetShow(31, 1)
		event.SetActiveLight(0)
		event.CharaActive(0)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.InitDramaScene()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1213) or var0
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
	event.SetLoadbgFile("event/opening/p1/p2_pierrot.gltf")
	if vm.wait() then
		return skip(1)
	end
	helper_ffeb2648()
	if vm.skipping() then
		return skip(2)
	end
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
	event.EohSyncObj(31, "p01_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p02_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-1")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-2")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-3")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-4")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-5")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-6")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i03h02a-7")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p05_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p06_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p07_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p08_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p11_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p13_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p14_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p15_i03h02a")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p10_i03h02a-1")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p10_i03h02a-2")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p10_i03h02a-3")
	event.EohSetShow(31, 0)
	event.SetActiveLight(1)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 18.72, -581.27)
	event.CmrsSetRef(0.0, -0.38, -526.54)
	event.CmrsMove(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(3)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-17.16, 17.61, -542.92)
	event.CmrsSetRef(2.33, 20.36, -409.98)
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "見えないよ", 2)
	event.ObjsNextMotion(0, "見えないよL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 4)
	event.ObjsSeDelay(0, 110)
	event.ObjsSePlay(0, var0, 5)
	helper_75f3e820(200)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSePlay(0, var0, 6)
	helper_0a344ece(0, 1033, 8, 200, 200)
	if vm.skipping() then
		return skip(8)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "見えないよ戻り", 2)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(10)
	end
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(13)
	end
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
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetActiveLight(0)
	if vm.wait() then
		return skip(15)
	end
	event.CmrsSetPos(385.44, 20.74, -469.02)
	event.CmrsSetRef(478.52, 20.25, -405.79)
	event.ObjsSetPos(0, 431.02, 0.0, -509.53)
	event.ObjsSetRot(0, 0.0, 0.36, 0.0)
	event.ObjsMove(0, 457.0, 0.0, -428.0, 40)
	event.ObjsRotDelay(0, 35)
	event.ObjsRotation(0, 0.0, 0.72, 0.0, 5)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(0, "はしご登り", 2)
	helper_75f3e820(40)
	if vm.skipping() then
		return skip(18)
	end
	event.EohSetFootSoundId(0, 9)
	event.CmrsMove(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
	event.ObjsMotionWait(0)
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(19)
	end
	helper_9b8126b9()
	if vm.skipping() then
		return skip(20)
	end
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
	helper_a057a7e5(0, 1034, 8, 200, 200, 60)
	if vm.skipping() then
		return skip(21)
	end
	helper_ae53acce(0)
	if vm.skipping() then
		return skip(22)
	end
	helper_9b8126b9()
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsMove(492.91, 169.38, -343.35, 431.02, 155.35, -293.19, 200)
	event.CmrsPrSlowing(0.94, 30)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(24)
	end
	helper_75f3e820(30)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_9b8126b9()
	if vm.skipping() then
		return skip(26)
	end
	return part2()
end

return helper_051a08db
