--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22e34d28 = require("@lib/event/helper_22e34d28")
local helper_ac6949ab = require("@lib/event/helper_ac6949ab")
local helper_c758eb34 = require("@lib/event/helper_c758eb34")
local helper_d759a0ab = require("@lib/event/helper_d759a0ab")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f9fe2856 = require("@lib/event/helper_f9fe2856")

--- Helper function.
local function helper_8cce5119()
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 53 then
			if at <= 1 then
				helper_f9fe2856()
			end
			if at <= 2 then
				helper_ed0a80b8(4)
			end
			if at <= 3 then
				helper_e2d04ed9(6)
			end
			if at <= 4 then
				helper_e2d04ed9(7)
			end
			if at <= 5 then
				helper_e2d04ed9(8)
			end
			if at <= 6 then
				helper_ed0a80b8(15)
			end
			if at <= 7 then
				helper_e2d04ed9(0)
			end
			if at <= 8 then
				helper_e2d04ed9(0)
			end
			if at <= 9 then
				helper_e2d04ed9(0)
			end
			if at <= 10 then
				helper_ed0a80b8(90)
			end
			if at <= 11 then
				helper_c758eb34(1)
			end
			if at <= 12 then
				helper_e2d04ed9(0)
			end
			if at <= 13 then
				helper_22e34d28(0, -1, 8, 0, 0)
				helper_ed0a80b8(130)
			end
			if at <= 14 then
				helper_d759a0ab(0)
				helper_e2d04ed9(0)
			end
			if at <= 15 then
				helper_e2d04ed9(0)
			end
			if at <= 16 then
				helper_ed0a80b8(3)
			end
			if at <= 17 then
				helper_ed0a80b8(18)
			end
			if at <= 18 then
				helper_e2d04ed9(1)
			end
			if at <= 19 then
				helper_ed0a80b8(20)
			end
			if at <= 20 then
				helper_ed0a80b8(10)
			end
			if at <= 21 then
				helper_ed0a80b8(10)
			end
			if at <= 22 then
				helper_e2d04ed9(0)
			end
			if at <= 23 then
				helper_ed0a80b8(20)
			end
			if at <= 24 then
				helper_ed0a80b8(30)
			end
			if at <= 25 then
				helper_ed0a80b8(20)
			end
			if at <= 26 then
				helper_ed0a80b8(4)
			end
			if at <= 27 then
				helper_ed0a80b8(30)
			end
			if at <= 28 then
				helper_e2d04ed9(0)
			end
			if at <= 29 then
				helper_f9fe2856()
			end
			if at <= 30 then
				helper_ed0a80b8(20)
			end
			if at <= 31 then
				helper_ed0a80b8(4)
			end
			if at <= 32 then
				helper_e2d04ed9(0)
			end
			if at <= 33 then
				helper_ed0a80b8(4)
			end
			if at <= 34 then
				helper_ed0a80b8(4)
			end
			if at <= 35 then
				helper_ed0a80b8(36)
			end
			if at <= 36 then
				helper_ed0a80b8(20)
			end
			if at <= 37 then
				helper_ed0a80b8(30)
			end
			if at <= 38 then
				helper_e2d04ed9(0)
			end
			if at <= 39 then
				helper_ed0a80b8(20)
			end
			if at <= 40 then
				helper_f9fe2856()
			end
			if at <= 41 then
				helper_ed0a80b8(20)
			end
			if at <= 42 then
				helper_ed0a80b8(20)
			end
			if at <= 43 then
				helper_ed0a80b8(14)
			end
			if at <= 44 then
				helper_ed0a80b8(6)
			end
			if at <= 45 then
				helper_ed0a80b8(2)
			end
			if at <= 46 then
				helper_ed0a80b8(4)
			end
			if at <= 47 then
				helper_ed0a80b8(12)
			end
			if at <= 48 then
				helper_e2d04ed9(0)
			end
			if at <= 49 then
				helper_ed0a80b8(6)
			end
			if at <= 50 then
				helper_e2d04ed9(0)
			end
			if at <= 51 then
				helper_ed0a80b8(30)
			end
			if at <= 52 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(54)
			end
			return part2()
		end
		helper_ac6949ab(vm.f32(-255.23), vm.f32(-0.17), vm.f32(130.23), vm.f32(-1.01))
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
		helper_ac6949ab(vm.f32(-255.23), vm.f32(-0.17), vm.f32(130.23), vm.f32(-1.01))
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
	helper_ed0a80b8(4)
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
	event.LoadMes(0, 5, "e50_1.txt")
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
	helper_f9fe2856()
	if vm.skipping() then
		return skip(2)
	end
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(3)
	end
	helper_e2d04ed9(6)
	if vm.skipping() then
		return skip(4)
	end
	helper_e2d04ed9(7)
	if vm.skipping() then
		return skip(5)
	end
	helper_e2d04ed9(8)
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
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(7)
	end
	event.PlayBgm(0)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSyncObj(0, 0.0, 23.0, -4.0, -0.6, -3.0, 36.0, "", 1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(0, "振り返り走り", 6)
	event.ObjsNextMotion(0, "走りノーマル", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 50)
	event.ObjsAddPas(0, -692.07, -0.17, 990.78)
	event.ObjsAddPas(0, -683.94, -0.17, 726.33)
	event.ObjsStartPas(0)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(9)
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
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(10)
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
	helper_ed0a80b8(90)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamOpen3(1, 500010)
	helper_c758eb34(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(13)
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
	helper_22e34d28(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_ed0a80b8(130)
	if vm.skipping() then
		return skip(14)
	end
	helper_d759a0ab(0)
	event.StreamClose(1)
	event.ObjsTexAnime(0, 0, "通常口パク")
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(15)
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
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(16)
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
	helper_ed0a80b8(3)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var1, 4)
	helper_ed0a80b8(18)
	if vm.skipping() then
		return skip(18)
	end
	event.CharaActive(1, 15)
	event.SetCharaPos(15, -313.12, 60.82, 67.65)
	event.SetCharaRot(15, 0.0, 0.39, 0.0)
	event.SetMotion(15, "割れ", 6)
	event.EohSetShow(5, 0)
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(19)
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
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(20)
	end
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var1, 5)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(22)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(24)
	end
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
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsMoveAhd2(2.84, -5.37, 71.78, 40, 0, 1.0)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "振り返り1", 2)
	event.ObjsNextMotion(0, "振り返り1L", 4)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSePlay(var1, 7)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(28)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(29)
	end
	helper_f9fe2856()
	if vm.skipping() then
		return skip(30)
	end
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-440.29, 24.47, 235.66)
	event.CmrsSetRef(-439.17, 22.16, 264.83)
	event.ObjsSetRot(0, 0.0, -1.15, 0.0)
	event.ObjsSetMotion(0, "振り返り2", 6, -1.0, 1)
	event.ObjsNextMotion(0, "2から身構え", 6)
	event.ObjsMotionWait(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(32)
	end
	event.SndSePlay(var1, 8)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(-481.43, 27.13, 301.91)
	event.CmrsSetRef(-425.22, 21.28, 264.03)
	event.SndSePlay(var1, 10)
	event.ObjsSetRot(0, 0.0, 2.37, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "構えL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "攻撃２", 6)
	event.ObjsPosDelay(2, 6)
	event.ObjsMove(2, -436.52, -0.17, 280.2, 20)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -423.21, -0.17, 254.95, 20)
	event.ObjsSetMotion(0, "横飛び", 2)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var1, 9)
	helper_ed0a80b8(36)
	if vm.skipping() then
		return skip(36)
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
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsMove(0, -486.59, 0.0, 162.88, 80)
	event.ObjsSetMotion(0, "壁歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsNextMotion(0, "像見る", 6)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-497.34, 28.69, 213.66)
	event.CmrsSetRef(-477.84, 8.8, 140.63)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(39)
	end
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsMove2(-497.34, 28.69, 213.66, -477.84, 34.1, 140.63, 20, 0, 0.4)
	event.ObjsSetMotion(0, "像上見る", 6)
	event.ObjsNextMotion(0, "像上見るL", 4)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(41)
	end
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsSetPos(-418.89, 26.37, 155.17)
	event.CmrsSetRef(-478.71, 27.36, 152.48)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "左向き目パチ")
	event.ObjsSetMotion(0, "像見戻り", 6)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(-468.82, 19.71, 169.71)
	event.CmrsSetRef(-415.85, 25.05, 200.94)
	event.SndSePlay(var1, 11)
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsSetPos(1, -389.81, -0.17, 218.14)
	event.ObjsSetRot(1, 0.0, -2.15, 0.0)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -423.64, -0.17, 198.07, 8)
	helper_ed0a80b8(14)
	if vm.skipping() then
		return skip(44)
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
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "攻撃２", 6)
	event.ObjsSetPos(1, -389.81, -0.17, 218.14)
	event.ObjsSetRot(1, 0.0, -2.15, 0.0)
	event.ObjsPosDelay(1, 6)
	event.ObjsMove(1, -462.48, -0.17, 175.0, 20)
	helper_ed0a80b8(2)
	if vm.skipping() then
		return skip(46)
	end
	event.SndSePlay(var1, 12)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(47)
	end
	helper_ed0a80b8(12)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsRotation(5, 0.0, 0.0, -1.57, 10)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(49)
	end
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
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(50)
	end
	event.SndSePlay(var1, 13)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(51)
	end
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(52)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(53)
	end
	return part2()
end

return helper_8cce5119
