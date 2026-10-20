--!strict
-- map/s/s43/s43.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f2a6f5c = require("@lib/event/helper_0f2a6f5c")
local helper_1c81fece = require("@lib/event/helper_1c81fece")
local helper_338a95d5 = require("@lib/event/helper_338a95d5")
local helper_3a1f7832 = require("@lib/event/helper_3a1f7832")
local helper_5cadcbc1 = require("@lib/event/helper_5cadcbc1")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_ce122344 = require("@lib/event/helper_ce122344")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")
local helper_f7f0d19e = require("@lib/event/helper_f7f0d19e")

--- Helper function.
local function helper_129c(arg0: s32)
	local stream_open_state: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
		end
		if at <= 2 then
			var2 = vm.i32(var2 + 1)
		end
		var2 = vm.i32(var2 + 1)
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	while true do
		if vm.wait() then
			return skip(2)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	return var2
end

--- Helper function.
local function helper_b8dc()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_af3fca28(0)
			end
			if at <= 2 then
				var1 = helper_129c(1)
			end
			if at <= 3 then
				helper_690ecd8a(vm.i32(30 - var1))
			end
			if at <= 4 then
				helper_690ecd8a(30)
			end
			if at <= 5 then
				helper_690ecd8a(200)
			end
			if at <= 6 then
				helper_ce122344(10710, 50)
			end
			if at <= 7 then
				helper_ce122344(10715, 80)
			end
			if at <= 8 then
				helper_af3fca28(0)
			end
			if at <= 9 then
				helper_af3fca28(0)
			end
			if at <= 10 then
				helper_690ecd8a(10)
			end
			if at <= 11 then
				helper_af3fca28(0)
			end
			if at <= 12 then
				helper_690ecd8a(10)
			end
			if at <= 13 then
				helper_338a95d5(1)
			end
			if at <= 14 then
				helper_af3fca28(0)
			end
			if at <= 16 then
				helper_af3fca28(0)
			end
			if at <= 17 then
				helper_690ecd8a(10)
			end
			if at <= 18 then
				helper_690ecd8a(40)
			end
			if at <= 19 then
				helper_338a95d5(1)
			end
			if at <= 20 then
				helper_af3fca28(0)
			end
			if at <= 21 then
				helper_d4b8f712()
			end
			if at <= 22 then
				helper_ce122344(10720, 60)
			end
			if at <= 23 then
				helper_af3fca28(0)
			end
			if at <= 24 then
				helper_d4b8f712()
			end
			if at <= 25 then
				helper_690ecd8a(30)
			end
			if at <= 26 then
				helper_d4b8f712()
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
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
	event.LoadSound(1213)
	event.LoadBgm(103)
	event.PlayBgm(0)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch8.txt")
	var0 = event.SndLoadSound(1213) or var0
	event.LoadMotion(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, -540.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/opening/p1/p1_people.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p1/p1_onna1.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, 18.39, 0.0, -421.29)
	event.LoadChara(5, "event/opening/p1/p1_otoko1.gltf", "info", 10)
	event.CharaActive(10)
	event.SetCharaPos(10, 27.92, 0.0, -433.74)
	event.LoadChara(5, "event/opening/p1/p1_otoko2.gltf", "info", 11)
	event.CharaActive(11)
	event.SetCharaPos(11, -25.29, 0.0, -426.67)
	event.LoadChara(5, "event/opening/p1/p2_macho.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(5, 12)
	event.EohSetFrameShow(5, "sphere1", 0)
	event.EohSetFrameShow(5, "sphere1_1", 0)
	event.EohSetFrameShow(5, "sphere1_2", 0)
	event.EohSetFrameShow(5, "sphere1_3", 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 0.0, 11.23, 0.0)
	event.ObjsSetRot(5, 0.0, 3.14, 0.0)
	event.EohSetShadow(5, 0)
	event.LoadChara(5, "event/opening/p1/p2_pierrot.gltf", "info", 13)
	event.CharaActive(13)
	event.SetMotion(13, "回転1", 4)
	event.SetReference(12, "sphere1", 13)
	event.CopyChara(5, 13, 14)
	event.CharaActive(14)
	event.SetMotion(14, "回転1", 4)
	event.SetReference(12, "sphere1_1", 14)
	event.CopyChara(5, 13, 15)
	event.CharaActive(15)
	event.SetMotion(15, "回転1", 4)
	event.SetReference(12, "sphere1_2", 15)
	event.CopyChara(5, 13, 16)
	event.CharaActive(16)
	event.SetMotion(16, "回転1", 4)
	event.SetReference(12, "sphere1_3", 16)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, 0.0, 0.0, -440.0, 120)
	event.ObjsSetMotion(5, "投げ4回", 4)
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
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 18.72, -581.27)
	event.CmrsSetRef(0.0, -0.38, -526.54)
	event.CmrsMove(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(1)
	end
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	event.StreamOpen3(1, 10705)
	var1 = helper_129c(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_690ecd8a(vm.i32(30 - var1))
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-17.16, 17.61, -542.92)
	event.CmrsSetRef(2.33, 20.36, -409.98)
	event.StreamPlay(1)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "見えないよ", 2)
	event.ObjsNextMotion(0, "見えないよL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 4)
	event.ObjsSeDelay(0, 110)
	event.ObjsSePlay(0, var0, 5)
	helper_690ecd8a(200)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamClose(1)
	event.ObjsSePlay(0, var0, 6)
	helper_ce122344(10710, 50)
	if vm.skipping() then
		return skip(7)
	end
	helper_ce122344(10715, 80)
	if vm.skipping() then
		return skip(8)
	end
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "見えないよ戻り", 2)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(10)
	end
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamOpen3(1, 10716)
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(14)
	end
	event.StreamPlay(1)
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
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetActiveLight(0)
	if vm.wait() then
		return skip(16)
	end
	event.CmrsSetPos(385.44, 20.74, -469.02)
	event.CmrsSetRef(478.52, 20.25, -405.79)
	event.StreamClose(1)
	event.ObjsSetPos(0, 431.02, 0.0, -509.53)
	event.ObjsSetRot(0, 0.0, 0.36, 0.0)
	event.ObjsMove(0, 457.0, 0.0, -428.0, 40)
	event.ObjsRotDelay(0, 35)
	event.ObjsRotation(0, 0.0, 0.72, 0.0, 5)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(0, "はしご登り", 2)
	event.StreamOpen3(1, 10718)
	helper_690ecd8a(40)
	if vm.skipping() then
		return skip(19)
	end
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(20)
	end
	event.StreamPlay(1)
	event.EohSetFootSoundId(0, 9)
	event.CmrsMove(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
	event.ObjsMotionWait(0)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(21)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(499.02, 167.79, -314.86)
	event.CmrsSetRef(424.99, 140.47, -326.88)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.StreamClose(1)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.ObjsSetPos(0, 441.37, 133.45, -339.86)
	event.ObjsSetRot(0, 0.0, 0.41, 0.0)
	event.ObjsMove(0, 459.04, 133.45, -308.23, 40)
	event.EohSetShadow(5, 1)
	event.EohSetFootSoundId(0, 3)
	event.ObjsSetMotion(0, "右向き歩き", 6)
	event.ObjsNormalDrive(0)
	event.ObjsNextMotion(0, "右を向く", 6)
	event.ObjsNextMotion(0, "右を向くL", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 9)
	event.CmrsMove2(499.02, 167.79, -314.86, 407.46, 142.42, -261.94, 60, 2, 0.6)
	helper_ce122344(10720, 60)
	if vm.skipping() then
		return skip(23)
	end
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(25)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

--- Helper function.
local function helper_f354()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 66 then
			if at <= 1 then
				helper_d4b8f712()
			end
			if at <= 2 then
				helper_690ecd8a(26)
			end
			if at <= 3 then
				helper_690ecd8a(10)
			end
			if at <= 4 then
				helper_690ecd8a(10)
			end
			if at <= 5 then
				helper_690ecd8a(10)
			end
			if at <= 6 then
				helper_690ecd8a(12)
			end
			if at <= 7 then
				helper_690ecd8a(12)
			end
			if at <= 8 then
				helper_690ecd8a(12)
			end
			if at <= 9 then
				helper_af3fca28(0)
			end
			if at <= 10 then
				helper_af3fca28(0)
			end
			if at <= 11 then
				helper_af3fca28(1)
			end
			if at <= 12 then
				helper_af3fca28(2)
			end
			if at <= 13 then
				helper_af3fca28(3)
			end
			if at <= 14 then
				helper_af3fca28(4)
			end
			if at <= 15 then
				helper_690ecd8a(3)
			end
			if at <= 16 then
				helper_690ecd8a(2)
			end
			if at <= 17 then
				helper_af3fca28(1)
			end
			if at <= 18 then
				helper_af3fca28(4)
			end
			if at <= 19 then
				helper_af3fca28(2)
			end
			if at <= 20 then
				helper_af3fca28(3)
			end
			if at <= 21 then
				helper_af3fca28(5)
			end
			if at <= 22 then
				helper_af3fca28(5)
			end
			if at <= 23 then
				helper_690ecd8a(62)
			end
			if at <= 24 then
				helper_af3fca28(5)
			end
			if at <= 25 then
				helper_d4b8f712()
			end
			if at <= 26 then
				helper_af3fca28(7)
			end
			if at <= 27 then
				helper_d4b8f712()
			end
			if at <= 28 then
				helper_af3fca28(7)
			end
			if at <= 29 then
				helper_af3fca28(7)
			end
			if at <= 30 then
				helper_af3fca28(7)
			end
			if at <= 31 then
				helper_690ecd8a(60)
			end
			if at <= 32 then
				helper_af3fca28(7)
			end
			if at <= 33 then
				helper_690ecd8a(70)
			end
			if at <= 34 then
				helper_690ecd8a(29)
			end
			if at <= 35 then
				var1 = 0
				var2 = vm.f32(0.8)
				var3 = vm.f32(-2.07)
				var2 = vm.f32(var2 * vm.f32(0.8))
				var3 = vm.f32(var3 - var2)
				var1 = var1 + 1
				print(string.format("%f", var3), "\n")
			end
			if at <= 36 then
				helper_690ecd8a(10)
			end
			if at <= 37 then
				helper_690ecd8a(10)
			end
			if at <= 38 then
				helper_690ecd8a(9)
			end
			if at <= 39 then
				helper_d4b8f712()
			end
			if at <= 40 then
				helper_690ecd8a(5)
			end
			if at <= 41 then
				helper_d4b8f712()
			end
			if at <= 42 then
				helper_af3fca28(5)
			end
			if at <= 43 then
				helper_690ecd8a(20)
			end
			if at <= 44 then
				helper_690ecd8a(20)
			end
			if at <= 45 then
				helper_690ecd8a(50)
			end
			if at <= 46 then
				helper_af3fca28(5)
			end
			if at <= 47 then
				helper_d4b8f712()
			end
			if at <= 48 then
				helper_690ecd8a(30)
			end
			if at <= 49 then
				helper_d4b8f712()
			end
			if at <= 50 then
				helper_af3fca28(5)
			end
			if at <= 51 then
				helper_0f2a6f5c()
			end
			if at <= 52 then
				helper_d4b8f712()
			end
			if at <= 53 then
				helper_690ecd8a(60)
			end
			if at <= 54 then
				helper_690ecd8a(60)
			end
			if at <= 55 then
				helper_690ecd8a(40)
			end
			if at <= 56 then
				helper_690ecd8a(90)
			end
			if at <= 57 then
				helper_d4b8f712()
			end
			if at <= 58 then
				helper_690ecd8a(20)
			end
			if at <= 59 then
				helper_690ecd8a(50)
			end
			if at <= 60 then
				helper_d4b8f712()
			end
			if at <= 61 then
				helper_af3fca28(7)
			end
			if at <= 62 then
				helper_af3fca28(7)
			end
			if at <= 63 then
				helper_690ecd8a(30)
			end
			if at <= 64 then
				helper_d4b8f712()
			end
			if at <= 65 then
				helper_d4b8f712()
			end
			if vm.skip_end() then
				return skip(67)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.LoadMes(0, -1)
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
		event.DeleteChara(18)
		event.SndSeStop(var0, 19)
		event.SndSeStop(var0, 28)
		event.SndSeStop(var0, 29)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(1214)
	var0 = event.SndLoadSound(1214) or var0
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
	event.LoadChara(5, "event/opening/p1/p1_people.gltf", "info", 18)
	event.CharaActive(18)
	event.SetCharaPos(18, 0.0, 0.0, -405.0)
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
	event.LoadChara(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetSoundId(1, var0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.CopyChara(6, 9, 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetSoundId(2, var0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.CopyChara(6, 9, 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CopyChara(6, 9, 12)
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
	helper_d4b8f712()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 30.0, -180.0)
	event.CmrsSetRef(0.0, 30.0, 0.0)
	event.ObjsSetMotion(0, "投げ４回からTポーズ", 6)
	event.ObjsNextMotion(0, "Tポーズ", 4)
	helper_690ecd8a(26)
	if vm.skipping() then
		return skip(3)
	end
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
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "着地ループ", 4)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "着地ループ", 4)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "着地ループ", 4)
	event.EohSetShadow(1, 1)
	helper_690ecd8a(12)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetShadow(2, 1)
	helper_690ecd8a(12)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetShadow(3, 1)
	helper_690ecd8a(12)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetShadow(4, 1)
	event.ObjsSetMotion(0, "Tポーズから決め", 6)
	event.ObjsNextMotion(0, "決めループ", 6)
	event.ObjsMotionWait(0)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(10)
	end
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
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(11)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(14)
	end
	helper_af3fca28(4)
	if vm.skipping() then
		return skip(15)
	end
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
	helper_690ecd8a(3)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "走り")
	event.ObjsMove(3, 90.31, 11.23, -38.89, 30)
	event.ObjsRotation(3, 0.0, 2.18, 0.0, 10)
	helper_690ecd8a(2)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, -90.31, 11.23, -38.89, 15)
	event.ObjsRotation(1, 0.0, -2.18, 0.0, 10)
	event.ObjsSetMotion(4, "走り")
	event.ObjsMove(4, 90.31, 11.23, -38.89, 15)
	event.ObjsRotation(4, 0.0, 2.18, 0.0, 10)
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_af3fca28(4)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(4, "立ち")
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "立ち")
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(3, "立ち")
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(22)
	end
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
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(5, "パオーン", 2)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsSeDelay(5, 20)
	event.ObjsSePlay(5, var0, 7)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 8)
	helper_690ecd8a(62)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 25)
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(25)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(26)
	end
	event.SetLoadbgFile("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
	event.ObjsSetMotion(7, "歩き", 4)
	event.ObjsSetPos(7, 15.06, 11.23, -91.33)
	event.ObjsSetRot(7, 0.0, -0.96, 0.0)
	event.ObjsRotDelay(7, 80)
	event.ObjsRotation(7, 0.0, -1.8, 0.0, 10)
	event.ObjsMove(7, -68.07, 11.23, -40.78, 90)
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(7, "登場ポーズ", 2)
	event.ObjsMotionWait(7)
	event.CmrsMove(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(28)
	end
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(7, "歩き")
	event.ObjsMove(7, -31.47, 11.23, -3.92, 60)
	event.ObjsRotation(7, 0.0, 0.72, 0.0, 10)
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSetMotion(5, "ごにょごごにょ", 2)
	event.ObjsNextMotion(5, "ごにょごにょループ", 4)
	event.ObjsRotation(7, 0.0, 1.32, 0.0, 20)
	event.ObjsSetMotion(7, "ごにょごにょ", 2)
	event.ObjsNextMotion(7, "ごにょごにょL", 6)
	event.ObjsMotionWait(7)
	event.ObjsSeDelay(7, 10)
	event.ObjsSePlay(7, var0, 9)
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-40.25, 30.96, -47.72)
	event.CmrsSetRef(-5.49, 44.23, -27.58)
	event.CharaActive(0, 13)
	event.CharaActive(1, 16)
	event.ObjsSePlay(5, var0, 10)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(0.0, 95.44, -190.42)
	event.CmrsSetRef(0.0, 62.65, 0.0)
	event.CharaActive(1, 13)
	event.CharaActive(0, 16)
	event.ObjsSetMotion(5, "玉持ち上げ", 6)
	event.ObjsNextMotion(5, "玉持ち上げループ", 4)
	event.ObjsSeDelay(5, 4)
	event.ObjsSePlay(5, var0, 11)
	event.ObjsSetPos(6, 0.0, 11.23, -30.0)
	event.ObjsSetMotion(6, "玉持ち上げ", 6)
	event.ObjsNextMotion(6, "玉持ち上げループ", 4)
	event.ObjsSetRot(7, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(7, "歩き", 4)
	event.ObjsRotation(7, 0.0, -1.57, 0.0, 20)
	event.ObjsMove(7, -132.5, 11.23, 0.93, 90)
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(33)
	end
	event.CharaActive(0, 15)
	event.CmrsSetPos(0.4, 14.44, -179.22)
	event.CmrsSetRef(0.0, 67.37, 0.0)
	event.ObjsSetMotion(5, "バイシクルシュート", 6)
	event.ObjsSetMotion(6, "バイシクルシュート", 6)
	event.ObjsSeDelay(5, 62)
	event.ObjsSePlay(5, var0, 12)
	helper_690ecd8a(70)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 25)
	helper_690ecd8a(29)
	if vm.skipping() then
		return skip(35)
	end
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
		print(string.format("%f", var3), "\n")
		if vm.wait() then
			return skip(36)
		end
	end
	event.CharaActive(17)
	event.ObjsSetMotion(9, "キラーン", 6)
	event.ObjsSePlay(5, var0, 13)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(37)
	end
	event.CharaActive(0, 17)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-168.96, 18.9, -103.54)
	event.CmrsSetRef(-5.14, 75.4, 8.39)
	event.CharaActive(1, 13)
	event.CharaActive(0, 16)
	event.ObjsSetMotion(5, "バイシクルシュート", 2)
	event.ObjsSetMotion(6, "バイシクルシュート", 2)
	event.ObjsSePlay(5, var0, 14)
	helper_690ecd8a(9)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetStep(5, 0.01)
	event.ObjsSetStep(6, 0.01)
	event.CmrsSetPos(-197.04, 171.4, 0.74)
	event.CmrsSetRef(0.0, 121.4, 0.0)
	event.CmrsMoveAhd(1.57, 0.0, 197.04, 100)
	event.CmrsMoveAhd(3.14, -25.0, 197.04, 50)
	event.CmrsMoveAhd(-1.57, -50.0, 197.04, 50)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetStep(5, 0.6)
	event.ObjsSetStep(6, 0.6)
	event.ObjsMotionWait(5)
	event.ObjsSePlay(5, var0, 15)
	helper_690ecd8a(5)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 25)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(42)
	end
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(-120.33, 279.87, -18.7)
	event.CmrsSetRef(138.46, 217.78, 141.95)
	event.ObjsSetPos(6, 0.0, 0.0, 0.0)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "右のピエロ", 6)
	event.ObjsSeDelay(6, 10)
	event.ObjsSePlay(6, var0, 16)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(87.54, 42.85, 80.82)
	event.CmrsSetRef(-204.62, 211.5, 188.69)
	event.ObjsSetMotion(6, "左のピエロ", 6)
	event.ObjsSeDelay(6, 10)
	event.ObjsSePlay(6, var0, 16)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(45)
	end
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
	helper_690ecd8a(50)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 25)
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSePlay(5, var0, 18)
	event.CmrsSetPos(-55.0, 150.0, 230.0)
	event.CmrsSetRef(0.0, 50.0, -30.0)
	event.CmrsMove(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(37.29, 24.91, -191.53)
	event.CmrsSetRef(5.05, 69.55, -9.71)
	event.ObjsSetMotion(6, "キャッチ＆決め終わり", 6)
	event.ObjsSetMotion(5, "キャッチ＆決め終わり", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(50)
	end
	helper_af3fca28(5)
	if vm.skipping() then
		return skip(51)
	end
	helper_0f2a6f5c()
	if vm.skipping() then
		return skip(52)
	end
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
	helper_d4b8f712()
	if vm.skipping() then
		return skip(53)
	end
	event.CharaActive(0, 13)
	event.CmrsSyncObj(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(54)
	end
	event.SndSeStop(var0, 19)
	event.SndSePlay(var0, 20)
	event.ObjsSetMotion(0, "ピエロブランコ", 6)
	event.ObjsSetMotion(1, "ピエロブランコ", 6)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 21)
	event.ObjsSeDelay(0, 50)
	event.ObjsSePlay(0, var0, 21)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(55)
	end
	helper_690ecd8a(40)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsMoveAhd(-3.14, 0.0, 140.0, 60)
	helper_690ecd8a(90)
	if vm.skipping() then
		return skip(57)
	end
	event.EohSyncObj(31, "p10_i03h02")
	event.EohSetShow(31, 0)
	event.CmrsReleaseObj()
	event.ObjsSePlay(0, var0, 25)
	event.CmrsMove(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(58)
	end
	event.CmrsSetPos(0.0, 237.95, -275.71)
	event.CmrsSetRef(0.0, 212.96, -32.39)
	event.ObjsSetPos(0, 170.0, 0.0, 0.0)
	event.ObjsSetPos(1, 170.0, 0.0, 0.0)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(59)
	end
	event.CharaActive(1, 15)
	event.ObjsSetPos(7, 0.0, 11.23, 0.0)
	event.ObjsSetRot(7, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(7, "ムーンサルト", 6)
	event.ObjsNextMotion(7, "ムーンサルトL", 4)
	event.ObjsSeDelay(7, 20)
	event.ObjsSePlay(7, var0, 26)
	event.ObjsSeDelay(7, 45)
	event.ObjsSePlay(7, var0, 27)
	helper_690ecd8a(50)
	if vm.skipping() then
		return skip(60)
	end
	event.EohSetShow(31, 1)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(61)
	end
	event.CmrsSetPos(0.0, 53.51, -115.19)
	event.CmrsSetRef(0.0, 35.43, 0.41)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(62)
	end
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
	helper_af3fca28(7)
	if vm.skipping() then
		return skip(63)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(64)
	end
	event.CmrsMove2(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(66)
	end
	return part2()
end

--- Helper function.
local function helper_16e0c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_338a95d5(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
end

--- Helper function.
local function helper_16ee0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_690ecd8a(30)
			end
			if at <= 2 then
				helper_338a95d5(1)
			end
			if at <= 3 then
				helper_1c81fece(0, -1, 8, 0, 0)
				helper_3a1f7832(0, 30)
			end
			if at <= 4 then
				helper_5cadcbc1(0)
				helper_af3fca28(6)
			end
			if at <= 5 then
				helper_690ecd8a(14)
			end
			if at <= 6 then
				helper_690ecd8a(10)
			end
			if at <= 7 then
				helper_690ecd8a(5)
			end
			if at <= 8 then
				helper_16e0c(40062)
			end
			if at <= 9 then
				helper_af3fca28(2)
			end
			if at <= 10 then
				helper_af3fca28(0)
			end
			if at <= 11 then
				helper_16e0c(40064)
			end
			if at <= 12 then
				helper_af3fca28(0)
			end
			if at <= 13 then
				helper_d4b8f712()
			end
			if at <= 14 then
				helper_690ecd8a(6)
			end
			if at <= 15 then
				helper_690ecd8a(4)
			end
			if at <= 16 then
				helper_690ecd8a(3)
			end
			if at <= 17 then
				helper_690ecd8a(20)
			end
			if at <= 18 then
				helper_ce122344(40080, 30)
			end
			if at <= 19 then
				helper_690ecd8a(10)
			end
			if at <= 20 then
				var2 = helper_129c(1)
			end
			if at <= 21 then
				helper_690ecd8a(vm.i32(40 - var2))
			end
			if at <= 22 then
				helper_690ecd8a(46)
			end
			if at <= 23 then
				helper_af3fca28(0)
			end
			if at <= 24 then
				helper_690ecd8a(30)
			end
			if at <= 25 then
				helper_16e0c(40083)
			end
			if at <= 26 then
				helper_af3fca28(0)
			end
			if at <= 27 then
				helper_690ecd8a(30)
			end
			if at <= 28 then
				helper_d4b8f712()
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
		if at <= 30 then
			var3 = 0
			var3 = var3 + 1
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 33)
		event.SndSeStop(var1, 27)
		event.SndSeStop(var1, 28)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.LoadSound(1217)
		event.SndSeAllStop(4)
		var3 = 0
		while var3 < 32 do
			event.ObjsInit(var3)
			var3 = var3 + 1
		end
		event.SetCameraRef(0.0, 33.8, 6.0)
		event.SetCameraPos(0.0, 38.8, 86.0)
		event.ResetCamera(0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.DeleteChara(8)
		event.CharaActive(1, 0)
		event.DelReference(0)
		event.SetCharaPos(0, 0.0, 8.8, 6.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "バトル立ち", 4)
		event.CharaResetDa(0)
		event.EohSyncChara(21, 1)
		event.EohSetShow(21, 1)
		event.EohSyncChara(21, 2)
		event.EohSetShow(21, 0)
		event.SndInitPort(4)
		event.AssignStack(3)
		event.ClearStack(3)
		event.LoadMonsterFile(600, 1)
		event.AutoSetMonster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
		event.AutoSetMonster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
		event.AutoSetMonster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
		event.AutoSetMonster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
		var0 = event.SndLoadSound(4, "snd2/event/ev_200_000.sound.json") or var0
		event.SndSePlay(var0, 0)
		if vm.wait() then
			return skip(31)
		end
		event.DngPause(16384, 1)
		var4 = event.GetSndId(4) or var4
		event.SetCharaExSoundid(0, var4)
		event.ActchrSoundInfoCopy(0)
		event.DngPause(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.DngPause(1, 1)
	event.SetStatusbarShow(0, 0.033333335)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(2)
	end
	event.DelMonster(-1)
	event.DngPause(16384, 0)
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	event.AddHpRate(1.0, 0)
	event.AddWhp(0, 999)
	var1 = event.SndLoadSound(1216) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p4/op4ch1.txt")
	event.LoadMotion(5, "event/opening/p4/p4_mints3.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(0, 0)
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 0)
	event.EohSyncChara(21, 2)
	event.EohSetShow(21, 0)
	event.LoadChara(5, "event/opening/p4/light.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetFrameShow(2, "kusari", 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncChrobj(7, 10, "light_rot")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsRotation(7, 0.01, 0.0, 0.0, -1)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.LoadMotion(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p4/up_kusari.gltf", "info", 18)
	event.CharaActive(18)
	event.SetReference(10, "up_kusari", 18)
	event.LoadChara(5, "event/opening/p4/shuchusen.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(6, 8)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/opening/p4/p4_kemuri.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.SetCharaPos(20, 0.0, 10.0, 0.0)
	event.ObjsSetMotion(4, "つかまりL", 4)
	event.SetReference(10, "pierrot2", 12)
	event.ObjsSetMotion(5, "つかまりL", 4)
	event.SetReference(10, "pierrot3", 13)
	event.ObjsSetMotion(3, "つかまりL", 4)
	event.SetReference(10, "pierrot1", 11)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetReference(10, "mints", 0)
	event.ObjsSetMotion(0, "見上げるL", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.StreamOpen3(1, 40060)
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(10, "落下", 6, 0.3)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CmrsInit()
	event.CmrsSyncObj(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
	event.SndSePlay(var1, 33)
	event.CmrsCharaAttach(8, 60.0, 30)
	event.CharaActive(8)
	event.CharaActive(18)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	event.StreamPlay(1)
	event.MesMake_2(0, 40060)
	helper_1c81fece(0, -1, 8, 0, 0)
	helper_3a1f7832(0, 30)
	if vm.skipping() then
		return skip(4)
	end
	helper_5cadcbc1(0)
	event.SetMesPos(0, 0)
	helper_af3fca28(6)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamClose(1)
	event.CmrsReleaseObj()
	event.CharaActive(0, 8)
	event.CmrsSetPos(0.0, 18.46, -95.54)
	event.CmrsSetRef(0.0, 194.33, 107.78)
	event.CmrsMove(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(0, 18)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "落下", 6, 0.3)
	event.ObjsNextMotion(2, "停止", 4)
	event.SndSePlay(var1, 27)
	helper_690ecd8a(14)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "飛び降りる", 2)
	event.ObjsNextMotion(0, "飛び降りるL", 6, 0.2)
	event.ObjsNextMotion(0, "ライトから着地", 6)
	event.ObjsMotionWait(0)
	event.ObjsMotionDelay(0, 10)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(7)
	end
	event.DelReference(0)
	event.ObjsSetPos(0, 0.0, 65.81, 94.16)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsJump(0, 0.0, 10.6, 6.0, -0.2, 30)
	helper_690ecd8a(5)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(20)
	event.SetMotion(20, "けむり", 6)
	helper_16e0c(40062)
	if vm.skipping() then
		return skip(9)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsInit(7)
	event.DelReference(11)
	event.ObjsSetPos(3, -46.01, 150.0, 50.48)
	event.ObjsSetRot(3, 0.0, 2.42, 0.0)
	event.DelReference(12)
	event.ObjsSetPos(4, -48.62, 150.0, 60.52)
	event.ObjsSetRot(4, 0.0, -2.42, 0.0)
	event.DelReference(13)
	event.ObjsSetPos(5, -35.87, 150.0, -54.34)
	event.ObjsSetRot(5, 0.0, 0.38, 0.0)
	event.CharaActive(14)
	event.EohSyncChara(20, 14)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsSetPos(20, 30.12, 150.0, -61.93)
	event.ObjsSetRot(20, 0.0, -0.6, 0.0)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(1.17, 26.95, -26.03)
	event.CmrsSetRef(1.17, 33.68, 4.49)
	event.ObjsSetPos(0, 0.0, 10.0, 6.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "舞台上キョロキョロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "開きからにこり")
	event.ObjsSePlay(0, var1, 28)
	event.StreamClose(1)
	helper_16e0c(40064)
	if vm.skipping() then
		return skip(12)
	end
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetRef(0.0, 33.68, 4.49)
	event.CmrsSetAhd(0.9, 9.0, 50.0)
	event.CmrsMoveAhd(-0.9, 9.0, 50.0, 180)
	event.ObjsSetMotion(0, "手を振る", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "感動（３）")
	event.ObjsTexAnime(0, 1, "うれし口（３）")
	helper_d4b8f712()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.61, 45.86, -150.28)
	event.CmrsSetRef(0.57, 21.14, 5.95)
	event.CharaActive(0, 10)
	event.ObjsSetMotion(20, "落下中", 6, 0.15)
	event.ObjsNextMotion(20, "着地", 6)
	event.ObjsNextMotion(20, "立ち", 4)
	event.ObjsJump(20, 30.12, 8.8, -61.93, -0.2, 30)
	event.ObjsSeDelay(20, 30)
	event.ObjsSePlay(20, var1, 34)
	helper_690ecd8a(6)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -46.01, 8.8, 50.48, -0.2, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var1, 34)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, -35.87, 8.8, -54.34, -0.2, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var1, 34)
	helper_690ecd8a(3)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, 48.62, 8.8, 60.52, -0.2, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var1, 34)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(0, "キョロキョロ立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.StreamClose(1)
	helper_ce122344(40080, 30)
	if vm.skipping() then
		return skip(19)
	end
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-20.61, 33.01, -18.61)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(0, "レンチを取り出す", 6)
	event.ObjsNextMotion(0, "レンチを取り出すL", 4)
	event.StreamClose(1)
	event.StreamOpen3(1, 40082)
	var2 = helper_129c(1)
	if vm.skipping() then
		return skip(21)
	end
	event.StreamPlay(1)
	helper_690ecd8a(vm.i32(40 - var2))
	if vm.skipping() then
		return skip(22)
	end
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 1)
	helper_690ecd8a(46)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSePlay(0, var1, 35)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-4.51, 25.29, -32.6)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(0, 4)
	event.ObjsSePlay(0, var1, 36)
	event.StreamClose(1)
	helper_16e0c(40083)
	if vm.skipping() then
		return skip(26)
	end
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(27)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

--- Helper function.
local function helper_1b4e4()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_690ecd8a(30)
			end
			if at <= 2 then
				helper_690ecd8a(16)
			end
			if at <= 3 then
				helper_690ecd8a(20)
			end
			if at <= 4 then
				helper_690ecd8a(60)
			end
			if at <= 5 then
				helper_f7f0d19e(0, -1, 8, 0, 0)
			end
			if at <= 6 then
				helper_690ecd8a(10)
			end
			if at <= 7 then
				helper_af3fca28(0)
			end
			if at <= 8 then
				helper_690ecd8a(20)
			end
			if at <= 9 then
				helper_690ecd8a(40)
			end
			if at <= 11 then
				helper_ce122344(40090, 120)
			end
			if at <= 12 then
				helper_16e0c(40100)
			end
			if at <= 13 then
				helper_690ecd8a(12)
			end
			if at <= 14 then
				helper_690ecd8a(10)
			end
			if at <= 15 then
				helper_af3fca28(0)
			end
			if at <= 16 then
				helper_af3fca28(0)
			end
			if at <= 17 then
				helper_af3fca28(0)
			end
			if at <= 18 then
				helper_690ecd8a(20)
			end
			if at <= 19 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		if at <= 21 then
			helper_690ecd8a(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaDaEnable(0, 1)
		event.AddHpRate(1.0, 0)
		event.AddWhp(0, 999)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_690ecd8a(4)
		if vm.skipping() then
			return skip(22)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	event.Initialize()
	event.SetStatusbarShow(0, 0.033333335)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	event.SetMotion(0, "バトル立ち")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.SetMesWindowMode(0, 7)
	event.InitDramaScene()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p4/op4ch2.txt")
	event.LoadSound(1218)
	var0 = event.SndLoadSound(1216) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.LoadMotion(5, "event/opening/p4/p4_mints4.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 10.0, -80.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 1)
	event.EohSyncChara(21, 2)
	event.EohSetShow(21, 0)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko1.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, 20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko2.gltf", "info", 10)
	event.CharaActive(10)
	event.SetCharaPos(10, -20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.LoadMotion(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -50.82, 150.0, -15.75)
	event.ObjsSetRot(3, 0.0, 2.2, 0.0)
	event.CopyChara(5, 11, 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 47.49, 150.0, -2.37)
	event.ObjsSetRot(4, 0.0, -2.64, 0.0)
	event.CopyChara(5, 11, 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, -28.7, 150.0, 70.26)
	event.ObjsSetRot(5, 0.0, 2.8, 0.0)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(6, 14)
	event.EohSetSoundId(6, var0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 1.79, 150.0, 28.91)
	event.ObjsSetRot(6, 0.0, 2.92, 0.0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(7, 15)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 42.0, -84.0)
	event.ObjsSetRot(7, 1.57, 0.0, 0.0)
	event.ObjsSetMotion(7, "発動", 5)
	event.CmrsSetPos(-2.8, 29.02, -36.61)
	event.CmrsSetRef(0.85, 26.87, -88.33)
	event.SetFadeIn(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(0, "かかげる", 6)
	event.ObjsNextMotion(0, "かかげるL", 4)
	event.ObjsSePlay(0, var0, 37)
	helper_690ecd8a(16)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(7, "発動", 6)
	event.CmrsMove2(-0.86, 81.13, -64.1, 0.85, 26.87, -88.33, 12, 2, 1.0)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSePlay(0, var0, 38)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 0)
	event.MesMake_2(0, 40085)
	helper_f7f0d19e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 7)
	event.SetMesDrawspeed(0, 1)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "気がつく", 6)
	event.ObjsNextMotion(0, "気がつくL", 4)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(14)
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -50.82, 8.8, -15.75, -0.1, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsMotionDelay(4, 3)
	event.ObjsPosDelay(4, 3)
	event.ObjsSeDelay(4, 3)
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, 47.49, 8.8, -2.37, -0.1, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 29)
	event.ObjsMotionDelay(5, 9)
	event.ObjsPosDelay(5, 9)
	event.ObjsSeDelay(5, 9)
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, -28.7, 8.8, 70.26, -0.1, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsMotionDelay(6, 15)
	event.ObjsPosDelay(6, 15)
	event.ObjsSeDelay(6, 15)
	event.ObjsSetMotion(6, "落下中", 6, 0.15)
	event.ObjsNextMotion(6, "着地", 6)
	event.ObjsNextMotion(6, "立ち", 4)
	event.ObjsJump(6, 1.79, 8.8, 28.91, -0.1, 30)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 29)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 0)
	event.CmrsSetPos(-12.49, 56.75, -150.16)
	event.CmrsSetRef(-0.59, 13.56, -3.76)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "かまえ立ち", 4, -1.0, 1)
	helper_690ecd8a(40)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.CmrsSetPos(-27.38, 36.23, -86.69)
	event.CmrsSetRef(29.33, 26.13, -60.27)
	event.CharaDaEnable(0, 0)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "かまえ立ち", 4, -1.0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	if vm.wait() then
		return skip(11)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口（３）")
	helper_ce122344(40090, 120)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_16e0c(40100)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "出口を見る", 6)
	event.ObjsNextMotion(0, "出口を見るL", 6)
	helper_690ecd8a(12)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "→走り", 2)
	event.ObjsNextMotion(0, "走り", 4)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsMove(0, 0.0, 10.0, -120.0, 20)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(0.0, 41.13, -104.26)
	event.CmrsSetRef(0.0, 20.2, -217.19)
	event.ObjsSetPos(0, 0.0, 0.0, -200.0)
	event.ObjsMove(0, 0.0, 0.0, -350.0, 30)
	event.ObjsResetDaPosition(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-60.96, 9.43, -525.19)
	event.CmrsSetRef(0.0, 28.11, -410.09)
	event.CmrsMove(-60.96, 9.43, -525.19, 0.0, 28.11, -451.39, 35)
	event.ObjsSetMotion(0, "客を飛び超える", 6)
	event.ObjsMove(0, 0.0, 0.0, -470.0, 35)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 30)
	event.SetMotion(9, "振り向き", 2)
	event.SetMotion(10, "振り向き", 2)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-107.5, 71.31, -471.79)
	event.CmrsSetRef(21.82, 28.11, -671.17)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetPos(0, -40.33, 0.0, -525.86)
	event.ObjsSetRot(0, 0.0, 2.7, 0.0)
	event.ObjsMove(0, 29.23, 5.07, -691.14, 50)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f354()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.LoadScript("s43/s43b.stb", 151)
	end
	event.SetTimeStepEnable(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	helper_b8dc()
	if vm.skipping() then
		return skip(1)
	end
	helper_f354()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 152.
script[152] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.AssignStack(3)
	event.ClearStack(3)
	event.LoadMonsterFile(600, 1)
	event.AutoSetMonster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.AutoSetMonster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.AutoSetMonster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.AutoSetMonster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	var0 = event.SndLoadSound(4, "snd2/event/ev_200_000.sound.json") or var0
	event.SndSePlay(var0, 0)
	event.DngPause(16384, 1)
	event.SetCnt(5, 2)
	if vm.wait() then
		return skip(1)
	end
	event.SetStatusbarShow(1, 0.033333335)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16ee0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1b4e4()
	if vm.skipping() then
		return skip(1)
	end
	event.AddItem(1)
	event.SetCharaEquip(0, 1)
	event.SubItem(387)
	event.SetBitCtrl(1, 0)
	event.DngPause(256, 0)
	event.GotoEdit(17, 153)
end

--- Program 8000.
script[8000] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f354()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_690ecd8a(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1213)
	event.LoadBgm(103)
	event.PlayBgm(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	helper_f354()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 8001.
script[8001] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_690ecd8a(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1213)
	event.LoadBgm(103)
	event.PlayBgm(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadScript("s43/s43b.stb", 151)
end

--- Program 8002.
script[8002] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadScript("s43/s43b.stb", 8000)
end

return script
