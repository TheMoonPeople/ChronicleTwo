--!strict
-- map/s/s51/s51.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0349c0c2 = require("@lib/event/helper_0349c0c2")
local helper_15bb1635 = require("@lib/event/helper_15bb1635")
local helper_1a1e22c8 = require("@lib/event/helper_1a1e22c8")
local helper_2428aed6 = require("@lib/event/helper_2428aed6")
local helper_57e8417c = require("@lib/event/helper_57e8417c")
local helper_651b7701 = require("@lib/event/helper_651b7701")
local helper_80f23453 = require("@lib/event/helper_80f23453")
local helper_b502ec5d = require("@lib/event/helper_b502ec5d")
local helper_cb55229d = require("@lib/event/helper_cb55229d")
local helper_d79574b8 = require("@lib/event/helper_d79574b8")
local helper_e7ec5c04 = require("@lib/event/helper_e7ec5c04")
local helper_f3d064c4 = require("@lib/event/helper_f3d064c4")

--- Helper function.
local function helper_1284(arg0: s32)
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
local function helper_ff10()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 58 then
			if at <= 1 then
				helper_f3d064c4()
			end
			if at <= 2 then
				helper_b502ec5d(4)
			end
			if at <= 3 then
				helper_651b7701(6)
			end
			if at <= 4 then
				helper_651b7701(7)
			end
			if at <= 5 then
				helper_651b7701(8)
			end
			if at <= 6 then
				helper_b502ec5d(15)
			end
			if at <= 7 then
				helper_15bb1635(1)
			end
			if at <= 8 then
				helper_651b7701(0)
			end
			if at <= 9 then
				helper_651b7701(0)
			end
			if at <= 10 then
				helper_651b7701(0)
			end
			if at <= 11 then
				helper_b502ec5d(90)
			end
			if at <= 12 then
				helper_15bb1635(1)
			end
			if at <= 13 then
				helper_651b7701(0)
			end
			if at <= 14 then
				helper_57e8417c(0, -1, 8, 0, 0)
				helper_b502ec5d(130)
			end
			if at <= 15 then
				helper_1a1e22c8(0)
				helper_651b7701(0)
			end
			if at <= 16 then
				helper_651b7701(0)
			end
			if at <= 17 then
				helper_b502ec5d(3)
			end
			if at <= 18 then
				helper_b502ec5d(18)
			end
			if at <= 19 then
				helper_651b7701(1)
			end
			if at <= 20 then
				var0 = helper_1284(1)
			end
			if at <= 21 then
				helper_b502ec5d(vm.i32(20 - var0))
			end
			if at <= 22 then
				helper_b502ec5d(10)
			end
			if at <= 23 then
				helper_b502ec5d(10)
			end
			if at <= 24 then
				helper_651b7701(0)
			end
			if at <= 25 then
				helper_b502ec5d(20)
			end
			if at <= 26 then
				helper_b502ec5d(30)
			end
			if at <= 27 then
				helper_b502ec5d(20)
			end
			if at <= 28 then
				helper_b502ec5d(4)
			end
			if at <= 29 then
				var0 = helper_1284(1)
			end
			if at <= 30 then
				helper_b502ec5d(vm.i32(30 - var0))
			end
			if at <= 31 then
				helper_651b7701(0)
			end
			if at <= 32 then
				helper_f3d064c4()
			end
			if at <= 33 then
				helper_b502ec5d(20)
			end
			if at <= 34 then
				helper_b502ec5d(4)
			end
			if at <= 35 then
				helper_15bb1635(1)
			end
			if at <= 36 then
				helper_651b7701(0)
			end
			if at <= 37 then
				helper_b502ec5d(4)
			end
			if at <= 38 then
				helper_b502ec5d(4)
			end
			if at <= 39 then
				helper_b502ec5d(36)
			end
			if at <= 40 then
				helper_b502ec5d(20)
			end
			if at <= 41 then
				helper_b502ec5d(30)
			end
			if at <= 42 then
				helper_651b7701(0)
			end
			if at <= 43 then
				helper_b502ec5d(20)
			end
			if at <= 44 then
				helper_f3d064c4()
			end
			if at <= 45 then
				helper_b502ec5d(20)
			end
			if at <= 46 then
				helper_b502ec5d(20)
			end
			if at <= 47 then
				var0 = helper_1284(1)
			end
			if at <= 48 then
				helper_b502ec5d(vm.i32(14 - var0))
			end
			if at <= 49 then
				helper_b502ec5d(6)
			end
			if at <= 50 then
				helper_b502ec5d(2)
			end
			if at <= 51 then
				helper_b502ec5d(4)
			end
			if at <= 52 then
				helper_b502ec5d(12)
			end
			if at <= 53 then
				helper_651b7701(0)
			end
			if at <= 54 then
				helper_b502ec5d(6)
			end
			if at <= 55 then
				helper_651b7701(0)
			end
			if at <= 56 then
				helper_b502ec5d(30)
			end
			if at <= 57 then
				helper_b502ec5d(30)
			end
			if vm.skip_end() then
				return skip(59)
			end
			return part2()
		end
		helper_d79574b8(vm.f32(-255.23), vm.f32(-0.17), vm.f32(130.23), vm.f32(-1.01))
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.EohSetScale(0, 1.0, 1.0, 1.0)
		event.EohSetShow(13, 0)
		event.EohSetShow(18, 0)
		event.EohSetShow(8, 0)
		event.EohSetPos(7, 0.0, -1000.0, 826.974)
		event.SetStatus(1, 0, 256, 0)
		event.SetStatus(1, 8, 256, 0)
		event.SetStatus(1, 8, 512, 0)
		event.EohSetShow(5, 0)
		event.EohSetShow(17, 1)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "通常目パチ")
		event.EohSetFootSoundId(0, 0)
		event.EohSetShow(9, 1)
		event.EohSetShow(10, 1)
		event.CharaActive(1, 0)
		event.SndSeStop(var1, 4)
		event.SndSeStop(var1, 5)
		event.SndSeStop(var1, 6)
		event.SndSeStop(var1, 7)
		event.SndSeStop(var1, 8)
		event.SndSeStop(var1, 9)
		event.SndSeStop(var1, 10)
		event.SndSeStop(var1, 11)
		event.SndSeStop(var1, 12)
		event.SndSeStop(var1, 13)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		helper_d79574b8(vm.f32(-255.23), vm.f32(-0.17), vm.f32(130.23), vm.f32(-1.01))
		event.SetCameraPos(-136.84, 51.17, 55.65)
		event.SetCameraRef(-255.23, 29.83, 130.23)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.Initialize()
	event.SetProjection(524.9)
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(194)
	event.LoadSound(800)
	var1 = event.SndLoadSound(800) or var1
	event.AtramiriaOnOff(1, 0, 0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e00/e50/")
	event.LoadMes(0, 5, "e50.txt")
	event.LoadMotion(5, "e50_monica.gltf", "info", 0)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetStatus(1, 0, 256, 1)
	event.LoadChara(5, "e50_soldier.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(1, 11)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CopyChara(5, 11, 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CopyChara(5, 11, 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(4, 14)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e50_soldier_s.gltf", "info", 16)
	event.CharaActive(16)
	event.EohSyncChara(15, 16)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 15)
	event.SetStatus(1, 16, 512, 1)
	event.CopyChara(5, 16, 17)
	event.CharaActive(17)
	event.EohSyncChara(16, 17)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 16)
	event.SetStatus(1, 17, 512, 1)
	event.LoadChara(5, "e50_glassware.gltf", "info", 15)
	event.SetStatus(1, 15, 64, 1)
	event.CharaActive(0, 15)
	event.ChangeDir("")
	event.LoadChara(5, "event/e00/e50/c02_base_e50.gltf", "info", 8)
	event.LoadEquip(5, 1, 4, "info", 8)
	event.LoadEquip(5, 1, 3, "info", 8)
	event.LoadMotion(5, "event/e00/e50/e50_monica.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(14, 8)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 14)
	event.SetStatus(1, 8, 256, 1)
	event.SetStatus(1, 8, 512, 1)
	event.LoadEquip(5, 1, 0, "info", 0, 10)
	event.CharaActive(0, 10)
	event.EohSyncObj(5, "p01_s5102-0", "s510206-m0")
	event.EohSyncObj(7, "p11_s5102-0")
	event.EohSyncObj(6, "p07_s5102-0")
	event.EohSyncObj(8, "p08_s5102-0", "s510208-m0")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 8)
	event.EohSyncChara(9, 1)
	event.EohSyncChara(10, 2)
	event.EohSyncObj(11, "p10_s5102-0")
	event.EohSyncObj(12, "p10_s5102-1")
	event.EohSyncObj(13, "p12_s5102-0")
	event.EohSyncObj(18, "p14_s5102-0")
	event.EohSyncObj(17, "p01_s5102-0", "s510213-m0")
	event.EohSetShow(9, 0)
	event.EohSetShow(10, 0)
	event.EohSetShow(8, 1)
	event.EohSetRot(8, 0.0, 0.0, 0.0)
	event.EohSetShow(5, 1)
	event.EohSetShow(7, 1)
	event.EohSetPos(7, 0.0, 0.0, 826.974)
	event.EohSetShow(6, 1)
	event.EohSetShow(13, 1)
	event.EohSetShow(18, 1)
	event.EohSetRot(11, 0.0, -0.2, 0.0)
	event.EohSetRot(12, 0.0, 0.2, 0.0)
	event.EohSetShow(17, 0)
	event.EohSetMotion(0, "走りノーマル", 4)
	event.EohSetFootSoundId(0, -1)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(14, -1200.0, -300.0, 260.0)
	event.EohSetRot(14, 0.0, 1.93, 0.0)
	event.EohSetScale(14, 1.2, 1.2, 1.2)
	event.EohSetMotion(14, "走り", 4)
	event.EohSetFootSoundId(14, 21)
	event.EohSetPos(15, -1280.0, -300.0, 310.0)
	event.EohSetRot(15, 0.0, 1.93, 0.0)
	event.EohSetScale(15, 1.2, 1.2, 1.2)
	event.EohSetMotion(15, "走り", 4)
	event.EohSetPos(16, -1290.0, -300.0, 300.0)
	event.EohSetRot(16, 0.0, 1.93, 0.0)
	event.EohSetScale(16, 1.2, 1.2, 1.2)
	event.EohSetMotion(16, "走り", 4)
	event.EohSetSoundId(1, var1)
	event.EohSetSoundId(2, -1)
	event.EohSetSoundId(3, -1)
	event.EohSetSoundId(4, -1)
	event.EohSetSoundId(15, var1)
	event.EohSetSoundId(16, -1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(15.3, -241.0, 171.19)
	event.CmrsSetRef(0.41, -250.55, 204.26)
	event.CmrsMove2(15.53, -241.0, 153.53, 0.63, -250.55, 186.6, 100, 0, 1.0)
	event.ObjsMove(6, 100.0, -300.0, 210.0, 240)
	event.ObjsMove(7, 100.0, -300.0, 210.0, 260)
	event.ObjsMove(8, 100.0, -300.0, 200.0, 270)
	event.SetFadeIn(30)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(2)
	end
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(3)
	end
	helper_651b7701(6)
	if vm.skipping() then
		return skip(4)
	end
	helper_651b7701(7)
	if vm.skipping() then
		return skip(5)
	end
	helper_651b7701(8)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(1, 0)
	event.CharaActive(0, 8)
	event.EohSetScale(15, 1.0, 1.0, 1.0)
	event.SetStatus(1, 16, 512, 0)
	event.EohSetScale(16, 1.0, 1.0, 1.0)
	event.SetStatus(1, 17, 512, 0)
	event.EohSetShow(13, 0)
	event.EohSetShow(18, 0)
	event.CmrsSetPos(-575.02, 45.19, 363.88)
	event.CmrsSetRef(-599.81, 35.7, 424.09)
	event.EohSetMotion(14, "立ち", 4)
	event.EohSetFootSoundId(14, -1)
	event.EohSetFootSoundId(0, 21)
	event.CharaActive(0, 16)
	event.CharaActive(0, 17)
	event.CharaActive(1, 11)
	event.CharaActive(1, 12)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 70)
	event.ObjsAddPas(0, -692.07, -0.36, 990.78)
	event.ObjsAddPas(0, -689.4, -0.36, 780.32)
	event.ObjsAddPas(0, -662.72, -0.36, 615.33)
	event.ObjsAddPas(0, -627.87, -0.36, 503.76)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 70)
	event.ObjsAddPas(1, -633.39, -0.17, 1210.41)
	event.ObjsAddPas(1, -698.31, -0.17, 1037.39)
	event.ObjsAddPas(1, -732.28, -0.17, 924.78)
	event.ObjsAddPas(1, -729.93, -0.17, 758.07)
	event.ObjsStartPas(1)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 70)
	event.ObjsAddPas(2, -618.92, -0.17, 1090.21)
	event.ObjsAddPas(2, -655.87, -0.17, 965.4)
	event.ObjsAddPas(2, -667.3, -0.17, 891.14)
	event.ObjsAddPas(2, -667.67, -0.17, 710.72)
	event.ObjsAddPas(2, -666.43, -1.11, 671.43)
	event.ObjsStartPas(2)
	helper_b502ec5d(15)
	if vm.skipping() then
		return skip(7)
	end
	event.PlayBgm(0)
	event.StreamOpen3(1, 500003)
	helper_15bb1635(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSyncObj(0, 0.0, 23.0, -4.0, -0.6, -3.0, 36.0, "", 1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "振り返り走り", 6)
	event.ObjsNextMotion(0, "走りノーマル", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 50)
	event.ObjsAddPas(0, -692.07, -0.17, 990.78)
	event.ObjsAddPas(0, -683.94, -0.17, 726.33)
	event.ObjsStartPas(0)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(-666.42, 40.0, 654.32)
	event.CmrsSetRef(-678.61, 23.25, 716.14)
	event.CharaActive(1, 11)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(0, "走りノーマル", 4)
	event.ObjsInitPas(0)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 50)
	event.ObjsAddPas(0, -689.4, -0.36, 780.32)
	event.ObjsAddPas(0, -662.72, -0.36, 615.33)
	event.ObjsAddPas(0, -627.87, -0.36, 503.76)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 50)
	event.ObjsAddPas(1, -698.31, -0.17, 1037.39)
	event.ObjsAddPas(1, -732.28, -0.17, 924.78)
	event.ObjsAddPas(1, -729.93, -0.17, 758.07)
	event.ObjsStartPas(1)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 50)
	event.ObjsAddPas(2, -655.87, -0.17, 965.4)
	event.ObjsAddPas(2, -667.3, -0.17, 891.14)
	event.ObjsAddPas(2, -667.67, -0.17, 710.72)
	event.ObjsAddPas(2, -666.43, -1.11, 671.43)
	event.ObjsStartPas(2)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSyncObj(0, 3.0, 6.0, -3.0, 3.14, 0.0, 0.1, "kao", 1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 100)
	event.ObjsAddPas(0, -710.53, -0.17, 707.3)
	event.ObjsAddPas(0, -659.55, -0.17, 588.15)
	event.ObjsAddPas(0, -599.01, -0.17, 474.25)
	event.ObjsAddPas(0, -544.19, -0.17, 394.69)
	event.ObjsAddPas(0, -487.18, -0.17, 335.72)
	event.ObjsStartPas(0)
	helper_b502ec5d(90)
	if vm.skipping() then
		return skip(12)
	end
	event.StreamClose(1)
	event.StreamOpen3(1, 500010)
	helper_15bb1635(1)
	if vm.skipping() then
		return skip(13)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsReleaseObj()
	event.CmrsSyncObj(0, 0.0, 23.0, -4.0, -0.6, -3.0, 36.0, "", 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 140)
	event.ObjsAddPas(0, -710.53, -0.17, 707.3)
	event.ObjsAddPas(0, -659.55, -0.17, 588.15)
	event.ObjsAddPas(0, -599.01, -0.17, 474.25)
	event.ObjsAddPas(0, -544.19, -0.17, 394.69)
	event.ObjsAddPas(0, -493.18, -0.17, 329.72)
	event.ObjsStartPas(0)
	event.ObjsTexAnime(0, 1, "通常口パク")
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, 500010)
	helper_57e8417c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_b502ec5d(130)
	if vm.skipping() then
		return skip(15)
	end
	helper_1a1e22c8(0)
	event.StreamClose(1)
	event.ObjsTexAnime(0, 0, "通常口パク")
	helper_651b7701(0)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(-555.36, 48.77, 420.75)
	event.CmrsSetRef(-439.22, 30.11, 269.93)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 40)
	event.ObjsAddPas(0, -504.43, -0.17, 353.14)
	event.ObjsAddPas(0, -456.02, -0.17, 290.98)
	event.ObjsAddPas(0, -432.13, -0.17, 263.55)
	event.ObjsAddPas(0, -394.89, -0.17, 226.72)
	event.ObjsStartPas(0)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-258.12, 43.64, 195.63)
	event.CmrsSetRef(-309.59, 52.1, 75.71)
	event.EohSetPos(7, 0.0, -1000.0, 826.974)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(1, -399.79, 36.97, -132.89)
	event.ObjsSetRot(1, 0.0, 0.42, 0.0)
	event.ObjsJump(1, -282.94, -0.17, 139.36, -0.3, 30)
	event.ObjsSetMotion(1, "飛び", 4)
	helper_b502ec5d(3)
	if vm.skipping() then
		return skip(18)
	end
	event.SndSePlay(var1, 4)
	helper_b502ec5d(18)
	if vm.skipping() then
		return skip(19)
	end
	event.CharaActive(1, 15)
	event.SetCharaPos(15, -313.12, 60.82, 67.65)
	event.SetCharaRot(15, 0.0, 0.39, 0.0)
	event.SetMotion(15, "割れ", 6)
	event.EohSetShow(5, 0)
	helper_651b7701(1)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-410.63, 15.99, 277.48)
	event.CmrsSetRef(-459.98, 22.57, 269.05)
	event.EohSetShow(17, 1)
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetPos(0, -478.12, -0.17, 293.36)
	event.ObjsSetRot(0, 0.0, 2.09, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove2(0, -438.61, -0.17, 269.74, 20, 2, 1.0)
	event.ObjsSetMotion(0, "止まる", 6)
	event.ObjsNextMotion(0, "止まるL", 4)
	event.StreamOpen3(1, 500020)
	var0 = helper_1284(1)
	if vm.skipping() then
		return skip(21)
	end
	helper_b502ec5d(vm.i32(20 - var0))
	if vm.skipping() then
		return skip(22)
	end
	helper_b502ec5d(10)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var1, 5)
	event.StreamPlay(1)
	helper_b502ec5d(10)
	if vm.skipping() then
		return skip(24)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(25)
	end
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(26)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-505.04, 34.04, 374.96)
	event.CmrsSetRef(-456.55, 22.99, 297.9)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CharaActive(1, 11)
	event.CharaActive(1, 12)
	event.CharaActive(1, 13)
	event.CharaActive(1, 14)
	event.SndSePlay(var1, 6)
	event.ObjsSetPos(1, -310.02, 28.2, 76.61)
	event.ObjsSetRot(1, 0.0, 0.25, 0.0)
	event.ObjsJump(1, -287.81, -0.17, 136.28, -0.1, 10)
	event.ObjsRotation(1, 0.0, -0.83, 0.0, 10)
	event.ObjsSetMotion(1, "着地", 6)
	event.ObjsNextMotion(1, "立ち")
	event.ObjsSetPos(2, -320.56, -0.17, 224.94)
	event.ObjsSetRot(2, 0.0, -1.19, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(3, -590.45, -0.17, 410.34)
	event.ObjsSetRot(3, 0.0, 2.28, 0.0)
	event.ObjsSetPos(4, -534.81, -0.17, 411.26)
	event.ObjsSetRot(4, 0.0, 2.53, 0.0)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsMoveAhd2(2.84, -5.37, 71.78, 40, 0, 1.0)
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "振り返り1", 2)
	event.ObjsNextMotion(0, "振り返り1L", 4)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSePlay(var1, 7)
	event.StreamOpen3(1, 500021)
	var0 = helper_1284(1)
	if vm.skipping() then
		return skip(30)
	end
	helper_b502ec5d(vm.i32(30 - var0))
	if vm.skipping() then
		return skip(31)
	end
	event.StreamPlay(1)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(32)
	end
	helper_f3d064c4()
	if vm.skipping() then
		return skip(33)
	end
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(34)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-440.29, 24.47, 235.66)
	event.CmrsSetRef(-439.17, 22.16, 264.83)
	event.ObjsSetRot(0, 0.0, -1.15, 0.0)
	event.ObjsSetMotion(0, "振り返り2", 6, -1.0, 1)
	event.ObjsNextMotion(0, "2から身構え", 6)
	event.ObjsMotionWait(0)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var1, 8)
	event.StreamOpen3(1, 500032)
	helper_15bb1635(1)
	if vm.skipping() then
		return skip(36)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(-481.43, 27.13, 301.91)
	event.CmrsSetRef(-425.22, 21.28, 264.03)
	event.StreamPlay(1)
	event.SndSePlay(var1, 10)
	event.ObjsSetRot(0, 0.0, 2.37, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "構えL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "攻撃２", 6)
	event.ObjsPosDelay(2, 6)
	event.ObjsMove(2, -436.52, -0.17, 280.2, 20)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -423.21, -0.17, 254.95, 20)
	event.ObjsSetMotion(0, "横飛び", 2)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(39)
	end
	event.SndSePlay(var1, 9)
	helper_b502ec5d(36)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(-455.8, 119.67, 409.21)
	event.CmrsSetRef(-473.73, 21.28, 211.42)
	event.EohSetFootSoundId(0, 2)
	event.ObjsSetPos(0, -500.6, 0.0, 175.97)
	event.ObjsSetRot(0, 0.0, 1.0, 0.0)
	event.ObjsSetMotion(0, "壁立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(1, -385.55, -0.17, 226.77)
	event.ObjsSetRot(1, 0.0, -1.67, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(2, -408.67, -0.17, 288.74)
	event.ObjsSetRot(2, 0.0, -2.39, 0.0)
	event.ObjsSetPos(3, -470.36, -0.17, 321.58)
	event.ObjsSetRot(3, 0.0, -3.04, 0.0)
	event.ObjsSetPos(4, -531.85, -0.17, 295.06)
	event.ObjsSetRot(4, 0.0, 2.77, 0.0)
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsMove(0, -486.59, 0.0, 162.88, 80)
	event.ObjsSetMotion(0, "壁歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsNextMotion(0, "像見る", 6)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(42)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-497.34, 28.69, 213.66)
	event.CmrsSetRef(-477.84, 8.8, 140.63)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(43)
	end
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsMove2(-497.34, 28.69, 213.66, -477.84, 34.1, 140.63, 20, 0, 0.4)
	event.ObjsSetMotion(0, "像上見る", 6)
	event.ObjsNextMotion(0, "像上見るL", 4)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(45)
	end
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-418.89, 26.37, 155.17)
	event.CmrsSetRef(-478.71, 27.36, 152.48)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "左向き目パチ")
	event.ObjsSetMotion(0, "像見戻り", 6)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(-468.82, 19.71, 169.71)
	event.CmrsSetRef(-415.85, 25.05, 200.94)
	event.SndSePlay(var1, 11)
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsSetPos(1, -389.81, -0.17, 218.14)
	event.ObjsSetRot(1, 0.0, -2.15, 0.0)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -423.64, -0.17, 198.07, 8)
	event.StreamOpen3(1, 500034)
	var0 = helper_1284(1)
	if vm.skipping() then
		return skip(48)
	end
	helper_b502ec5d(vm.i32(14 - var0))
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(-418.89, 26.37, 155.17)
	event.CmrsSetRef(-478.71, 27.36, 152.48)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "左向き～前向き")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexaDelay(0, 10)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "前向き～右向き")
	event.ObjsTexaDelay(0, 10)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "右向き～左向き")
	event.ObjsSetPos(0, -486.59, 0.0, 162.88)
	event.ObjsSetRot(0, 0.0, 1.0, 0.0)
	event.ObjsSetMotion(0, "剣飛び", 6)
	event.ObjsMotionWait(0)
	helper_b502ec5d(6)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsSetPos(1, -389.81, -0.17, 218.14)
	event.ObjsSetRot(1, 0.0, -2.15, 0.0)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -462.48, -0.17, 175.0, 20)
	helper_b502ec5d(2)
	if vm.skipping() then
		return skip(51)
	end
	event.SndSePlay(var1, 12)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(52)
	end
	event.StreamPlay(1)
	helper_b502ec5d(12)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsRotation(5, 0.0, 0.0, -1.57, 10)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(54)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-393.47, 16.73, 206.96)
	event.CmrsSetRef(-383.04, 20.81, 172.7)
	event.CmrsMove2(-397.16, 14.0, 219.08, -383.04, 20.81, 172.7, 60, 2, 1.0)
	event.EohSetFootSoundId(0, 21)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CharaActive(10)
	event.ObjsSetPos(0, -369.4, 0.0, 171.56)
	event.ObjsSetRot(0, 0.0, -1.04, 0.0)
	event.ObjsSetMotion(0, "起きあがり", 6, -1.0, 1)
	event.ObjsNextMotion(0, "起きあがりL", 4)
	helper_b502ec5d(6)
	if vm.skipping() then
		return skip(55)
	end
	event.SndSePlay(var1, 13)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(56)
	end
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(57)
	end
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(58)
	end
	return part2()
end

--- Helper function.
local function helper_84c0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_57e8417c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_0349c0c2(arg0, 0, var6)
		end
		helper_1a1e22c8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_57e8417c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_0349c0c2(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_1a1e22c8(arg0)
end

--- Helper function.
local function helper_18074()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_651b7701(0)
			end
			if at <= 2 then
				helper_b502ec5d(10)
			end
			if at <= 3 then
				helper_b502ec5d(12)
			end
			if at <= 4 then
				helper_651b7701(0)
			end
			if at <= 5 then
				helper_b502ec5d(10)
			end
			if at <= 6 then
				helper_b502ec5d(40)
			end
			if at <= 7 then
				helper_b502ec5d(30)
			end
			if at <= 8 then
				helper_cb55229d(500045, 100)
			end
			if at <= 9 then
				helper_f3d064c4()
			end
			if at <= 10 then
				helper_651b7701(2)
			end
			if at <= 11 then
				helper_b502ec5d(40)
			end
			if at <= 12 then
				helper_15bb1635(1)
			end
			if at <= 13 then
				helper_f3d064c4()
			end
			if at <= 14 then
				helper_651b7701(2)
			end
			if at <= 15 then
				helper_b502ec5d(10)
			end
			if at <= 16 then
				helper_b502ec5d(30)
			end
			if at <= 17 then
				helper_b502ec5d(30)
			end
			if at <= 18 then
				helper_b502ec5d(30)
			end
			if at <= 19 then
				var1 = 1.0
				var2 = vm.f32(0.01)
				var3 = vm.f32(-0.002)
				var4 = 0
				var1 = vm.f32(var1 + var2)
				var2 = vm.f32(var2 + var3)
				var4 = var4 + 1
			end
			if at <= 20 then
				helper_b502ec5d(30)
			end
			if at <= 21 then
				helper_f3d064c4()
			end
			if at <= 22 then
				helper_b502ec5d(20)
			end
			if at <= 23 then
				helper_651b7701(1)
			end
			if at <= 24 then
				helper_b502ec5d(40)
			end
			if at <= 25 then
				helper_b502ec5d(90)
			end
			if at <= 26 then
				helper_b502ec5d(30)
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "通常目パチ")
		event.EohSetFootSoundId(0, 0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.SndSeStop(var0, 14)
		event.SndSeStop(var0, 15)
		event.SndSeStop(var0, 16)
		event.SndSeStop(var0, 17)
		event.SndSeStop(var0, 18)
		event.SndSeStop(var0, 19)
		event.SndSeStop(var0, 20)
		event.DelExtMotion(0)
		event.DeleteChara(18)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	var0 = event.SndLoadSound(802) or var0
	event.SetStatus(1, 0, 256, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e00/e50/")
	event.LoadMes(0, 5, "e50.txt")
	event.LoadMotion(5, "e50_monica.gltf", "info", 0)
	event.LoadMotion(5, "e50_monica2.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e50_guiltoni.gltf", "info", 18)
	event.CharaActive(18)
	event.EohSyncChara(2, 18)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e50_timegate_f.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.LoadChara(5, "e50_ou.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.ChangeDir("")
	event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(7, 9)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.LoadEquip(5, 1, 0, "info", 0, 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSyncObj(3, "p10_s5102-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p10_s5102-1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	event.EohSetPos(0, -494.38, -0.17, 247.95)
	event.EohSetRot(0, 0.0, 2.01, 0.0)
	event.EohSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 21)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, -250.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetSoundId(2, var0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.EohSetRot(3, 0.0, -0.2, 0.0)
	event.EohSetRot(4, 0.0, 0.2, 0.0)
	event.EohSetPos(7, 0.0, 30.0, -300.0)
	event.SetCharaPos(11, 0.0, 30.0, -300.0)
	event.SetCharaPos(13, 18.0, 0.0, -220.0)
	event.SetCharaRot(13, 0.0, -1.57, 0.0)
	event.SetMotion(13, "倒れ", 4)
	event.InitDramaScene()
	event.ObjsMove(0, -368.53, -0.17, 185.7, 50)
	event.CmrsInit()
	event.CmrsSetPos(-467.79, 15.29, 271.35)
	event.CmrsSetRef(-445.52, 25.45, 209.11)
	event.SetFadeIn(30)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-134.51, 100.78, 136.35)
	event.CmrsSetRef(-54.64, 52.81, 37.61)
	event.ObjsSetPos(0, -117.35, -0.17, 66.54)
	event.ObjsMove(0, -9.29, -0.17, 0.77, 30)
	event.ObjsRotDelay(0, 22)
	event.ObjsRotation(0, 0.0, 0.12, 0.0, 8)
	event.ObjsMotionDelay(0, 28)
	event.ObjsSetMotion(0, "壁立ち")
	helper_b502ec5d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 2)
	helper_b502ec5d(12)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 14)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_b502ec5d(10)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "像見る", 2)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_b502ec5d(40)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetFootSoundId(0, 21)
	event.CmrsSetPos(-95.58, 18.43, -157.01)
	event.CmrsSetRef(0.23, 35.57, -22.29)
	event.SndSePlay(var0, 15)
	event.ObjsRotation(3, 0.0, -1.8, 0.0, 16)
	event.ObjsRotation2(3, 0.0, -1.7, 0.0, 20, 2, 1.0)
	event.ObjsRotation(4, 0.0, 1.8, 0.0, 16)
	event.ObjsRotation2(4, 0.0, 1.7, 0.0, 20, 2, 1.0)
	event.ObjsSetPos(0, 0.0, -0.17, 0.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "あたりドア開け", 6)
	event.ObjsNextMotion(0, "構え", 4)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-12.11, 17.82, -20.43)
	event.CmrsSetRef(1.71, 21.68, 0.96)
	event.SndSePlay(var0, 16)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "ショック", 6)
	event.ObjsNextMotion(0, "ショックL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_cb55229d(500045, 100)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(0.0, 20.0, -80.0)
	event.CmrsSetRef(0.0, 20.0, -160.0)
	event.CmrsMove(0.0, 20.0, -120.0, 0.0, 20.0, -200.0, 120.0)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(10)
	end
	event.SetCrossfade(40)
	event.CmrsSetPos(0.0, 30.0, -210.0)
	event.CmrsSetRef(0.0, 30.0, -245.0)
	event.CmrsMoveAhd2(-1.2, 0.0, 35.0, 90, 0, 1.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ショック顔")
	event.ObjsTexAnime(0, 1, "ショック目パチ")
	event.ObjsSetMotion(0, "立ちN", 4, -1.0, 1)
	event.SndSePlay(var0, 17)
	event.ObjsSetMotion(2, "振り返り", 6)
	event.ObjsNextMotion(2, "振り返りL", 4)
	helper_651b7701(2)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamOpen3(1, 500050)
	helper_b502ec5d(40)
	if vm.skipping() then
		return skip(12)
	end
	helper_15bb1635(1)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamPlay(1)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 30.0, -210.0)
	event.CmrsSetRef(0.0, 30.0, -290.0)
	event.CmrsMove2(0.0, 20.0, -160.0, 0.0, 20.0, -280.0, 120, 0, 0.4)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(2, "振り返り戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_651b7701(2)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var0, 19)
	event.CharaActive(1, 11)
	event.SetMotion(11, "発生", 6)
	helper_b502ec5d(10)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(1, 9)
	event.SetCharaShow(9, 1, 1, 0.1)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, 0.0, 0.0, -300.0, 60)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaShow(18, 0, 1, 0.033333335)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(19)
	end
	event.SetCharaShow(9, 0, 1, 0.05)
	var1 = 1.0
	var2 = vm.f32(0.01)
	var3 = vm.f32(-0.002)
	var4 = 0
	while var4 < 20 do
		var1 = vm.f32(var1 + var2)
		var2 = vm.f32(var2 + var3)
		event.SetScale(9, var1, var1, var1)
		var4 = var4 + 1
		if vm.wait() then
			return skip(20)
		end
	end
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(21)
	end
	event.StreamClose(1)
	event.CmrsSetPos(0.0, 23.0, -34.0)
	event.CmrsSetRef(0.0, 23.0, 0.0)
	event.CmrsMove2(0.0, 23.0, -24.0, 0.0, 23.0, 0.0, 60, 2, 1.0)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(22)
	end
	helper_b502ec5d(20)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 23.0, -297.58)
	event.CmrsSetRef(0.0, 23.0, -273.58)
	event.SndSePlay(var0, 20)
	event.DelReference(12)
	event.ObjsSetPos(1, 10.0, 8.0, 0.0)
	event.ObjsSetRot(1, 0.4, 2.88, 0.0)
	event.ObjsMove(1, 10.0, 1.0, 0.0, 10)
	event.ObjsRotation(1, 0.0, 2.88, 0.0, 8)
	event.ObjsRotation(1, 0.0, 2.88, 0.3, 6)
	event.ObjsRotation(1, 0.0, 2.88, -0.2, 4)
	event.ObjsRotation(1, 0.0, 2.88, 0.1, 3)
	event.ObjsRotation(1, 0.0, 2.88, -0.05, 2)
	event.ObjsRotation(1, 0.0, 2.88, 0.0, 2)
	helper_651b7701(1)
	if vm.skipping() then
		return skip(24)
	end
	helper_b502ec5d(40)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(0, "ヨロあるき")
	event.ObjsChengeStep(0, 0.05)
	event.ObjsMove(0, 0.0, -0.17, -80.0, 120)
	helper_b502ec5d(90)
	if vm.skipping() then
		return skip(26)
	end
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

--- Helper function.
local function helper_6028(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_15bb1635(1)
		end
		if at <= 2 then
			helper_80f23453(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_15bb1635(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_80f23453(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_e2c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.ChkPadCtrl(arg0) or var1
	return var1
end

--- Helper function.
local function helper_c614(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2428aed6(1, 4)
			helper_84c0(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2428aed6(1, 4)
	helper_84c0(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db20(arg0: any, arg1: any)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_e7ec5c04()
			end
			if at <= 2 then
				helper_b502ec5d(30)
			end
			if at <= 3 then
				helper_6028(arg1, -1)
			end
			if at <= 4 then
				helper_b502ec5d(10)
			end
			if at <= 5 then
				helper_b502ec5d(30)
			end
			if at <= 6 then
				helper_b502ec5d(120)
			end
			if at <= 7 then
				local _ = helper_e2c(0)
			end
			if at <= 8 then
				helper_c614(1)
			end
			if at <= 9 then
				helper_c614(4)
			end
			if at <= 10 then
				helper_c614(active_chr_no)
			end
			if at <= 11 then
				helper_c614(1)
			end
			if at <= 12 then
				helper_b502ec5d(30)
			end
			if at <= 14 then
				helper_b502ec5d(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.DngCheckPause(16384) or var2
	if var2 ~= 16384 then
		event.DngPause(16384, 1)
	end
	boss_map = event.DngCheckBossMap() or boss_map
	event.GetActiveBgmStatus(-1)
	if var2 ~= 16384 and boss_map ~= 1 then
		var4 = event.GetEventInfoSndid(4) or var4
		argc = event.GetSeStatus(var4, 0) or argc
		battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
		event.SndSeStop(var4, 0)
		print("---------------------------------------------BATTLE BGM STOP\n")
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 or active_chr_no == 1 then
		event.SetTexAnim(0, 0, "目パチ")
		event.SetTexAnim(0, 1, "死に")
	end
	if active_chr_no == 2 then
		event.ActchrSetMotion(0, "故障", 6)
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
		event.EsmCreate("ロボ故障")
	end
	var8 = 0
	if active_chr_no == 2 then
		var8 = event.CheckEnableCharaChange(0) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(1) or var8
		end
	end
	if active_chr_no == 0 then
		var8 = event.CheckEnableCharaChange(1) or var8
	end
	if active_chr_no == 1 then
		var8 = event.CheckEnableCharaChange(0) or var8
	end
	if active_chr_no == 3 then
		var8 = event.CheckEnableCharaChange(1) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(0) or var8
		end
	end
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_e7ec5c04()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6028(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_b502ec5d(10)
			if vm.skipping() then
				return skip(5)
			end
			event.PlayBgm(0)
		end
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "gameover1", block)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetUvsize(0, 0, 0, 576, 128)
		event.SpriteSetPutsize(0, 576, 128)
		event.SpriteSetPos(0, -320, 208)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsMove(0, 288, 208, 0.0, 20)
		helper_b502ec5d(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SpriteInit(1)
		event.SpriteSetType(1, 0)
		event.SpriteSetTexture(1, "gameover1", block)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetUvsize(1, 0, 128, 576, 64)
		event.SpriteSetPutsize(1, 576, 64)
		event.SpriteSetPos(1, 256, 208)
		event.SpriteSetDraw(1, 1)
		event.EohSyncSprite(1, 1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetColor(1, 128, 128, 128, 128, 120)
		helper_b502ec5d(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_e2c(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c614(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_c614(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c614(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_c614(1)
		if vm.skipping() then
			return skip(12)
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.AddWhp(0, 999)
		event.AddWhp(1, 999)
		if active_chr_no == 2 then
			event.EsmClear()
		end
		if active_chr_no == 0 or active_chr_no == 1 then
			event.SetTexAnim(0, 0, "死に")
			event.SetTexAnim(0, 1, "目パチ")
		end
		event.ActchrSetDefMotion(0, 4)
	elseif var8 == 1 then
		event.SetFadeOut(30)
		helper_b502ec5d(30)
		if vm.skipping() then
			return skip(13)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(14)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_b502ec5d(30)
		if vm.skipping() then
			return skip(15)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(1)
		if arg0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(16)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
	print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
	print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
	if var2 ~= 16384 and boss_map ~= 1 then
		if argc == 1 then
			print("---------------------------------------------BATTLE BGM PLAY\n")
			event.SndSePlay(var4, 0)
			event.SndSetSeVol(var4, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(10)
	end
	if var2 ~= 16384 then
		event.DngPause(16385, 0)
	else
		event.DngPause(1, 0)
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_fdec(arg0: s32)
	return helper_db20(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_84c0(0, -1, 8, 0, 0)
		end
	end
	helper_ff10()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadMonsterFile(523, 1)
	event.AutoSetMonster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.AutoSetMonster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.AutoSetMonster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.AutoSetMonster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	if vm.wait() then
		return skip(2)
	end
	event.DngPause(16385, 1)
	event.SetFadeIn(20)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"(O)ボタン・・・攻撃\n[r1]ボタン・・・ガード\n(X)ボタン・・・ロックオン\n[l1]＋(O)ボタン・・・魔法"
	)
	helper_84c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18074()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.CheckEquepChange(1)
		event.SetActiveChrNo(0)
		event.ExtTyped(1078, "ii", 0, 1)
		event.ExtTyped(1078, "ii", 1, 0)
		event.AddItem(353)
		event.AddItem(311)
		event.AddItem(268, 5)
		event.AddItem(294, 3)
		event.AddItem(298, 3)
		event.AddItem(425, 3)
		event.AddItem(275, 2)
		event.SetFlag(54, 1)
		event.BgmLoadCancel()
		event.GotoEdit(19, 151)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	helper_18074()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fdec(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 10500.
script[10500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.AddItem(110)
	event.AddItem(127)
	event.AddItem(133)
	event.AddItem(266)
	event.SetCharaEquip(1, 110)
	event.SetCharaEquip(1, 127)
	event.SetCharaEquip(1, 133)
	event.SetCharaEquip(1, 266)
	event.DngSetupMainUnit(1)
	helper_ff10()
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(16384, 1)
	event.LoadMonsterFile(523, 1)
	event.AutoSetMonster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.AutoSetMonster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.AutoSetMonster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.AutoSetMonster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(20)
	event.Finish()
end

return script
