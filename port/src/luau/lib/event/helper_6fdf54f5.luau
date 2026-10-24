--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_6fdf54f5()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_6018bc39()
			end
			if at <= 2 then
				helper_a8b5d854(30)
			end
			if at <= 3 then
				helper_a8b5d854(60)
			end
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(20)
			end
			if at <= 6 then
				helper_a8b5d854(41)
			end
			if at <= 7 then
				helper_a8b5d854(30)
			end
			if at <= 8 then
				helper_6018bc39()
			end
			if at <= 9 then
				helper_a8b5d854(30)
			end
			if at <= 10 then
				helper_40ca6466(4)
			end
			if at <= 11 then
				helper_a8b5d854(30)
			end
			if at <= 12 then
				helper_40ca6466(2)
			end
			if at <= 13 then
				helper_a8b5d854(30)
			end
			if at <= 14 then
				helper_a8b5d854(50)
			end
			if at <= 15 then
				helper_a8b5d854(40)
			end
			if at <= 16 then
				helper_a8b5d854(50)
			end
			if at <= 17 then
				helper_a8b5d854(15)
			end
			if at <= 18 then
				helper_a8b5d854(15)
			end
			if at <= 19 then
				helper_a8b5d854(45)
			end
			if at <= 20 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelReference(36)
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 7)
		event.BgmLoadCancel()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.DeleteChara(41)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6222)
	var0 = event.SndLoadSound(6222) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_paz2.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_pazeye.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e640_jet1.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e520_dsmoke.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e640_gekka_null.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e640_gcatch.gltf", "info", 39)
	event.CharaActive(39)
	event.EohSyncChara(8, 39)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "e640_dropsmoke.gltf", "info", 40)
	event.CharaActive(40)
	event.EohSyncChara(9, 40)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "e640_gareki.gltf", "info", 41)
	event.CharaActive(41)
	event.EohSyncChara(10, 41)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(3, "p01_s3202-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EsmInitialize(5)
	event.EsmLoadBase("砂煙2")
	event.EsmInitFix(5)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetPos(2, -4979.1, 1640.96, 51.62)
	event.EohSetRot(2, 0.0, 1.97, 0.0)
	event.EohSetPos(3, 300, 1500, -1300)
	event.EohSetRot(3, -0.08726646, -1.3962634, -0.08726646)
	event.EohSetShow(3, 1)
	event.EohSetPos(4, 126.44, 488.22, -1395.22)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 0)
	event.EohSetPos(6, -45.9, 1026.5, -828.85)
	event.EohSetRot(6, 0.0, 1.16, 0.0)
	event.EohSetShow(6, 1)
	event.EohSetShow(5, 0)
	event.EohSetShow(10, 0)
	event.EohSetShow(9, 0)
	event.EohSetShow(8, 0)
	event.InitDramaScene()
	event.CharaActive(34)
	event.CharaActive(35)
	event.CharaActive(36)
	event.CmrsInit()
	event.CmrsSetPos(-4404.98, 1570.53, -100.58)
	event.CmrsSetRef(-4930.23, 1587.54, 57.54)
	event.SetProjection(300.9)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetReference(34, "bj", 36)
	event.SndSePlay(var0, 0)
	event.EohSetShow(6, 1)
	event.SetFadeIn(30)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetAhd(1.86, -17.01, 548.53)
	event.CmrsMoveAhd2(-1.71, 47.67, 704.92, 120, 0, 1.0)
	helper_6018bc39()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(3, -300.0, 1100, -1500, 300)
	event.ObjsMove(6, -300.0, 1100, -1500, 300)
	event.SndSePlay(var0, 1)
	event.ObjsSetScale(5, 3.0, 3.0, 3.0)
	event.EohSetShow(5, 1)
	event.ObjsSetMotion(5, "発動", 6)
	event.ObjsNextMotion(5, "ループ", 4)
	event.ObjsSetMotion(2, "立ちから飛び", 6)
	event.ObjsNextMotion(2, "飛びL", 4)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove2(2, 1513.88, 598.13, -1096.51, 60, 0, 1.0)
	event.ObjsRotation(2, 0.0, 2.0, 0.0, 30)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(10)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(8, -75.9, 932.39, -1409.97)
	event.ObjsSetPos(3, -75.9, 2500.39, -1409.97)
	event.ObjsResetDaPosition(3)
	event.ObjsSetEohFramePos(10, 2, "gekka", -1)
	event.ObjsSetEohFramePos(3, 2, "gekka", -1)
	event.ObjsSetMotion(2, "受け止め前", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(2, -75.9, 932.39, -1409.97)
	event.ObjsSetRot(2, 0.0, -1.76, 0.0)
	event.CmrsSetPos(-370.9, 895.61, -1750.83)
	event.CmrsSetRef(-115.03, 884.3, -1452.48)
	event.EohSetShow(6, 0)
	event.EohSetShow(10, 1)
	event.CmrsPrdelay(15)
	event.CmrsMove2(-370.65, 183.49, -2277.09, 2.92, 642.26, -1398.94, 120, 2, 1.0)
	event.SndSeStop(var0, 0)
	event.SndSePlay(var0, 2)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetShow(8, 1)
	event.ObjsSetMotion(8, "受け止め2", 6)
	event.ObjsSeDelay(2, 15)
	event.ObjsSePlay(2, var0, 3)
	event.ObjsSetMotion(2, "受け止め2", 6)
	event.ObjsNextMotion(2, "受け止め2L", 4)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsQuake(1.0, 5.0, 3.0, 60)
	helper_a8b5d854(41)
	if vm.skipping() then
		return skip(7)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(8)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetShow(8, 0)
	event.SetCrossfade(10)
	event.CmrsSetPos(59.81, 458.89, -1445.3)
	event.CmrsSetRef(135.4, 492.0, -1379.85)
	event.ObjsSetMotion(2, "受け止めL", 4)
	event.ObjsSetMotion(2, "顔上げ", 6)
	event.ObjsNextMotion(2, "顔上げL", 4)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetShow(4, 1)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(4, "目光る", 6)
	event.ObjsMotionWait(4)
	helper_40ca6466(4)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetShow(4, 1)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSeStop(var0, 3)
	event.CmrsSetPos(1303.46, 38.33, -283.66)
	event.CmrsSetRef(820.22, 592.56, -1006.58)
	event.ObjsSetPos(7, 4600.0, 100.0, -1600.0)
	event.ObjsSetPos(2, -80.19, 1180.62, -1444.74)
	event.ObjsResetDaPosition(2)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var0, 5)
	event.ObjsSetMotion(2, "投げ2", 6)
	event.ObjsNextMotion(2, "投げ2Ｌ", 4)
	event.ObjsMotionWait(2)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetEohFramePos(3, 2, "gekka", -1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetEohFramePos(3, 7, "gekka", -1)
	event.ObjsSetMotion(7, "落ちる", 6)
	event.ObjsMove2(7, 2923.49, 105.13, -1814.72, 75, 2, 1.0)
	event.ObjsSetPos(9, 3061.59, 75.13, -1710.68)
	event.EohSetShow(10, 0)
	event.CmrsSetPos(3757.08, 62.26, -2734.23)
	event.CmrsSetRef(3567.51, 195.31, -2482.56)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(2, "降下中2", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(2, 4293.91, 515.2, -2041.48)
	event.ObjsSetRot(2, 0.0, -2.24, 0.0)
	event.SndSePlay(var0, 6)
	event.ObjsMove(2, 3544.41, 171.34, -2508.22, 180)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(14)
	end
	helper_a8b5d854(50)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetShow(9, 1)
	event.ObjsSetMotion(9, "落ちる", 6)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(5.0, 10.0, 1.0, 40)
	helper_a8b5d854(40)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(3846.75, 25.88, -2684.78)
	event.CmrsSetRef(3980.23, 196.04, -2962.11)
	event.SndSePlay(var0, 8)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 4001.12, 272.25, -3413.29)
	event.ObjsSetRot(2, 0.0, -0.08, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsMove2(2, 4022.53, 9.85, -2954.22, 50, 0, 0.5)
	helper_a8b5d854(50)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "着地L", 4)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(0.0, 6.0, 1.0, 60)
	event.ObjsMove2(2, 3965.6, 9.02, -2835.9, 60, 2, 1.0)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(18)
	end
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(3903.78, 22.87, -2873.81)
	event.EsmSetVect2(10.0, 10.0, 10.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(3996.95, 22.87, -2881.1)
	event.EsmSetVect2(10.0, 10.0, 20.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(4097.52, 22.87, -3043.58)
	event.EsmSetVect2(10.0, 20.0, 20.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(4189.22, 22.87, -3020.23)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(19)
	end
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(3903.78, 22.87, -2873.81)
	event.EsmSetVect2(10.0, 10.0, 10.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(3996.95, 22.87, -2881.1)
	event.EsmSetVect2(10.0, 10.0, 20.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(4097.52, 22.87, -3043.58)
	event.EsmSetVect2(10.0, 20.0, 20.0)
	event.EsmCreate("砂煙2")
	event.EsmSetVect1(4189.22, 22.87, -3020.23)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	helper_a8b5d854(45)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

return helper_6fdf54f5
