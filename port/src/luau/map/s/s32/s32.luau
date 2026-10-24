--!strict
-- map/s/s32/s32.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1281c23c = require("@lib/event/helper_1281c23c")
local helper_3a88f4ff = require("@lib/event/helper_3a88f4ff")
local helper_816cbf1e = require("@lib/event/helper_816cbf1e")
local helper_b01df685 = require("@lib/event/helper_b01df685")
local helper_c6124e13 = require("@lib/event/helper_c6124e13")
local helper_d779bb0d = require("@lib/event/helper_d779bb0d")

--- Helper function.
local function helper_1da24()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -687.4, 0.0, -77.8)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e1ac()
	local var0: s32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_d779bb0d(50)
			end
			if at <= 2 then
				helper_d779bb0d(25)
			end
			if at <= 3 then
				helper_d779bb0d(50)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		if at <= 5 then
			helper_d779bb0d(30)
		end
		if at <= 6 then
			helper_1da24()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(6)
		end
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		event.EsmClear()
		helper_1da24()
		if vm.skipping() then
			return skip(7)
		end
		event.SetProjection(projection)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	var0 = event.SndLoadSound(7200) or var0
	helper_c6124e13()
	projection = event.GetProjection() or projection
	event.SetProjection(500)
	event.InitDramaScene()
	event.EohSetScale(5, 0.125, 0.125, 0.125)
	event.EohSetScale(6, 2.0, 2.0, 2.0)
	event.ObjsSetPos(5, 275.8, 1361.59, 69.04)
	event.ObjsSetPos(6, 1553.99, 0.0, 55.85)
	event.ObjsSetPos(7, 275.8, 1361.59, 69.04)
	event.ObjsSetRot(7, 0.0, 1.32, 0.0)
	event.ObjsSetPos(4, 0.0, 1000.0, 0.0)
	event.CharaActive(0, 0)
	event.CmrsSetPos(832.39, 758.85, 3094.99)
	event.CmrsSetRef(811.41, 786.18, 1062.32)
	event.SetCrossfade(30)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 40)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(5, "入り", 6)
	event.ObjsNextMotion(5, "発射", 6)
	helper_d779bb0d(50)
	if vm.skipping() then
		return skip(2)
	end
	event.EsmCreate("Ｅ６１６月花ビームＡ")
	event.EsmSetVect1(275.8, 1361.59, 69.04)
	event.EsmSetVect2(0.0, 1.32, 0.0)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 42)
	event.SetMotion(42, "弾道", 6, -1, 1)
	helper_d779bb0d(25)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 5)
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.ObjsSetPos(5, 375.8, 1461.59, 69.04)
	event.ObjsSetPos(7, 375.8, 1461.59, 69.04)
	event.CharaActive(1, 40)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(5, "入り", 6)
	event.ObjsNextMotion(5, "発射", 6)
	helper_d779bb0d(50)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmCreate("Ｅ６１６月花ビームＡ")
	event.EsmSetVect1(375.8, 1461.59, 69.04)
	event.EsmSetVect2(0.0, 1.32, 0.0)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 42)
	event.SetMotion(42, "弾道", 6, -1, 1)
	return part2()
end

--- Helper function.
local function helper_dee4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_d779bb0d(40)
			end
			if at <= 2 then
				helper_b01df685(4)
			end
			if at <= 3 then
				helper_d779bb0d(30)
			end
			if at <= 4 then
				helper_d779bb0d(20)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SetMotionBlur(0)
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
		event.DeleteChara(37)
		event.LoadMes(0, -1)
		event.EsmClear()
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6209)
	var0 = event.SndLoadSound(6209) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
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
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_beamhajike_f.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e640_baria.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
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
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６４０月花ビーム")
	event.EsmInitFix(5, 40000)
	event.EohSyncObj(3, "p01_s3202-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetPos(2, -2358.27, 1170.91, -1391.1)
	event.EohSetRot(2, 0.0, 1.56, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 1000, -1300)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.EohSetPos(4, -391.37, 752.34, -1422.95)
	event.EohSetRot(4, 0.0, -1.44, 0.0)
	event.EohSetPos(6, -2567.95, 855.05, -1113.91)
	event.EohSetRot(6, 0.0, -1.57, 0.0)
	event.EohSetShow(4, 0)
	event.EohSetShow(6, 0)
	event.InitDramaScene()
	event.CharaActive(35)
	event.CharaActive(36)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-543.78, 1037.98, -1478.39)
	event.CmrsSetRef(-236.42, 1109.89, -1401.79)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetFadeIn(30)
	event.SetMotionBlur(64)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove2(-1419.31, 1011.75, -1755.49, -1184.96, 1017.66, -1628.77, 30, 2, 0.5)
	event.SndSePlay(var0, 2)
	event.EohSetShow(4, 1)
	event.ObjsSetMotion(4, "月花ビームはじけ（発動）", 6)
	helper_d779bb0d(40)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 3)
	event.EohSetShow(5, 1)
	event.EsmCreate("Ｅ６４０月花ビーム")
	event.EsmSetVect1(-391.37, 752.34, -1422.95)
	event.EsmSetVect2(0.0, -1.44, 0.0)
	helper_b01df685(4)
	if vm.skipping() then
		return skip(3)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(4, 0)
	event.CmrsInit()
	event.CmrsSetPos(-1817.78, 648.87, -1665.81)
	event.CmrsSetRef(-2324.89, 885.54, -1166.15)
	event.SndSePlay(var0, 4)
	event.ObjsSetPos(2, -2726.11, 818.82, -1113.25)
	event.ObjsSetRot(2, 0.0, 1.56, 0.0)
	event.CharaActive(37)
	event.EohSetShow(6, 1)
	event.ObjsSetMotion(6, "バリア", 6)
	event.ObjsSetStep(6, 0.25)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_ff1c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_d779bb0d(60)
			end
			if at <= 2 then
				helper_1281c23c()
			end
			if at <= 3 then
				helper_d779bb0d(30)
			end
			if at <= 4 then
				helper_d779bb0d(40)
			end
			if at <= 5 then
				helper_b01df685(4)
			end
			if at <= 6 then
				helper_1281c23c()
			end
			if at <= 7 then
				helper_d779bb0d(90)
			end
			if at <= 8 then
				helper_d779bb0d(32)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMotionBlur(0)
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_d779bb0d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(116)
	event.PlayBgm(0)
	event.LoadSound(6211)
	var0 = event.SndLoadSound(6211) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
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
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_canon_tame.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
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
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetPos(2, -2358.27, 1170.91, -1391.1)
	event.EohSetRot(2, 0.0, 1.56, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 1000, -1300)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.EohSetPos(4, -2232.61, 1234.98, -1416.46)
	event.EohSetRot(4, 0.0, -1.44, 0.0)
	event.EohSetShow(4, 0)
	event.InitDramaScene()
	event.SndSePlay(var0, 0)
	event.CharaActive(35)
	event.CharaActive(36)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-2291.89, 1284.15, -1406.93)
	event.CmrsSetRef(-2337.14, 1275.49, -1390.53)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetFadeIn(30)
	event.CmrsMove(-2285.0, 1284.15, -1409.43, -2337.14, 1275.49, -1390.53, 60)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(2)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotionBlur(80)
	event.CmrsMove2(-1614.03, 1599.88, -1752.72, -2376.45, 1138.55, -1294.4, 60, 0, 1.0)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(4, 1)
	event.SndSePlay(var0, 1)
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	event.SetCharaShow(35, 1, 1, 0.033333335)
	event.ObjsSetMotion(4, "溜めループ", 4)
	helper_d779bb0d(40)
	if vm.skipping() then
		return skip(5)
	end
	helper_b01df685(4)
	if vm.skipping() then
		return skip(6)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(7)
	end
	helper_d779bb0d(90)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(32)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_11b1c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_d779bb0d(60)
			end
			if at <= 2 then
				helper_1281c23c()
			end
			if at <= 3 then
				helper_d779bb0d(10)
			end
			if at <= 4 then
				helper_d779bb0d(30)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if at <= 6 then
				helper_b01df685(7)
			end
			if at <= 7 then
				helper_b01df685(6)
			end
			if at <= 8 then
				helper_d779bb0d(90)
			end
			if at <= 9 then
				helper_d779bb0d(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6214)
	var0 = event.SndLoadSound(6214) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
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
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_canon_tame.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e640_canon_f.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e640_canon_l.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e640_bakuha.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e520_dsmoke.gltf", "info", 39)
	event.CharaActive(39)
	event.EohSyncChara(8, 39)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "e640_canon_hit.gltf", "info", 40)
	event.CharaActive(40)
	event.EohSyncChara(9, 40)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
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
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetPos(2, -2358.27, 1170.91, -1391.1)
	event.EohSetRot(2, 0.0, 1.56, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 1370, -1300)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.EohSetPos(4, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(4, 0.0, -1.44, 0.0)
	event.EohSetShow(4, 1)
	event.EohSetPos(6, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(6, 0.0, 1.32, 0.0)
	event.EohSetPos(5, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(5, 0.0, 1.32, 0.0)
	event.EohSetPos(7, -325.09, 1202.56, -892.41)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetPos(9, -314.09, 1223.48, -967.31)
	event.EohSetRot(9, 0.0, -3.0, 0.0)
	event.EohSetPos(8, -45.9, 1026.5, -828.85)
	event.EohSetRot(8, 0.0, 0.52, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(5, 0)
	event.EohSetShow(7, 0)
	event.EohSetShow(9, 0)
	event.EohSetShow(8, 0)
	event.EohSetShow(4, 1)
	event.EohSetShow(2, 1)
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	event.InitDramaScene()
	event.CharaActive(35)
	event.CharaActive(36)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-1677.05, 1017.96, -1557.33)
	event.CmrsSetRef(-1863.01, 1063.39, -1486.17)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(4, "溜めループ", 4)
	event.SetCharaShow(35, 0, 1, 0.033333335)
	event.EohSetShow(6, 1)
	event.ObjsSetScale(6, 0.25, 0.25, 0.25)
	event.ObjsSetMotion(6, "入り", 6)
	event.ObjsNextMotion(6, "ループ", 4)
	event.EohSetShow(5, 1)
	event.ObjsSetScale(5, 0.25, 0.25, 0.25)
	event.ObjsSetMotion(5, "ループ", 6)
	event.ObjsMove2(2, -2463.39, 1170.91, -1448.84, 30, 1, 1.0)
	event.ObjsMove2(6, -2296.79, 1152.74, -1475.26, 30, 1, 1.0)
	event.ObjsMove2(5, -2463.39, 1170.91, -1448.84, 30, 1, 1.0)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-3044.87, 1164.83, -2170.89)
	event.CmrsSetRef(-3170.32, 1170.41, -2119.82)
	event.ObjsSetScale(6, 0.5, 0.5, 0.5)
	event.EohSetShow(2, 0)
	event.ObjsSetMotion(6, "入り", 6)
	event.ObjsNextMotion(6, "ループ", 4)
	event.ObjsSetPos(6, -6304.6, 1300.32, -2393.76)
	event.CmrsMove(-3421.59, 997.54, -2490.81, -2784.35, 1176.71, -2019.57, 30)
	helper_1281c23c()
	if vm.skipping() then
		return skip(3)
	end
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(9, 1)
	event.ObjsSetMotion(9, "ヒット", 6)
	event.SndSePlay(var0, 5)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 1)
	event.CmrsQuake(8.5, 10.0, 0.0, 30)
	event.EohSetShow(7, 1)
	event.ObjsSetMotion(7, "月花宮殿左爆破", 6)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetScale(8, 0.5, 0.5, 0.5)
	event.SetCharaShow(39, 1, 1, 0.033333335)
	event.ObjsSetMotion(8, "ｴﾌｪｸﾄ_ﾃﾞｽｱｰｸ煙")
	event.ObjsMotionDelay(6, 60)
	event.ObjsSetMotion(6, "戻り", 6)
	event.ObjsMove2(3, 0.0, 500, -1800, 300, 1, 1.0)
	event.ObjsRotation2(3, -0.19198622, -2.1991148, -0.21816616, 300, 2, 1.0)
	event.SndSePlay(var0, 2)
	event.ObjsMove2(8, 0.0, 500, -1800, 300, 1, 1.0)
	event.SetCrossfade(30)
	event.CmrsSetPos(-27.77, 739.23, -2227.49)
	event.CmrsSetRef(84.65, 1080.59, -1657.97)
	event.ObjsMotionWait(7)
	helper_b01df685(7)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetShow(7, 0)
	event.ObjsMotionWait(6)
	helper_b01df685(6)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetShow(6, 0)
	helper_d779bb0d(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_14c8c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 30 then
			if at <= 1 then
				helper_d779bb0d(40)
			end
			if at <= 2 then
				helper_d779bb0d(6)
			end
			if at <= 3 then
				helper_1281c23c()
			end
			if at <= 4 then
				helper_d779bb0d(30)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if at <= 6 then
				helper_d779bb0d(30)
			end
			if at <= 7 then
				helper_3a88f4ff(6400400, 70)
			end
			if at <= 8 then
				helper_3a88f4ff(6400410, 180)
			end
			if at <= 9 then
				helper_b01df685(2)
			end
			if at <= 10 then
				helper_1281c23c()
			end
			if at <= 11 then
				helper_d779bb0d(75)
			end
			if at <= 12 then
				helper_b01df685(2)
			end
			if at <= 13 then
				helper_1281c23c()
			end
			if at <= 14 then
				helper_d779bb0d(12)
			end
			if at <= 15 then
				helper_b01df685(2)
			end
			if at <= 16 then
				helper_d779bb0d(12)
			end
			if at <= 17 then
				helper_b01df685(2)
			end
			if at <= 18 then
				helper_d779bb0d(69)
			end
			if at <= 19 then
				helper_d779bb0d(41)
			end
			if at <= 20 then
				helper_b01df685(2)
			end
			if at <= 21 then
				helper_1281c23c()
			end
			if at <= 22 then
				helper_b01df685(3)
			end
			if at <= 23 then
				helper_d779bb0d(10)
			end
			if at <= 24 then
				helper_d779bb0d(2)
			end
			if at <= 25 then
				helper_d779bb0d(28)
			end
			if at <= 26 then
				helper_1281c23c()
			end
			if at <= 27 then
				helper_b01df685(3)
			end
			if at <= 28 then
				helper_d779bb0d(30)
			end
			if at <= 29 then
				helper_d779bb0d(30)
			end
			if vm.skip_end() then
				return skip(31)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.StopBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetMotionBlur(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_d779bb0d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(115)
	event.PlayBgm(0)
	event.LoadSound(6127)
	var0 = event.SndLoadSound(6217) or var0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
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
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_paz2.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_joint.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 5)
	event.CopyChara(5, 36, 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 6)
	event.LoadChara(5, "e640_pazeye.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 7)
	block = event.LoadImg_4(5, "e640.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e64001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 2)
	event.EohSyncSprite(8, 0)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 8)
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
	event.EohSyncObj(4, "p01_s3202-0")
	event.EohSetShow(4, 0)
	event.EohSetScale(5, 2.0, 2.0, 2.0)
	event.EohSetScale(6, 2.0, 2.0, 2.0)
	event.EohSetPos(2, 0.0, 1000.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "停止", 4)
	event.EohSetPos(3, 0.0, 1288.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "34_2", 4)
	event.EohSetShow(3, 0)
	var3 = event.EohGetFrameStatus(3, "eye--appcobyf2") or var3
	event.EohSetFrameStatus(3, "eye--appcobyf2", 0)
	event.EohSetFrameStatus(2, "udeli1--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli2--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli5--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli6--appc0f2z0", 0)
	event.EohSetPos(0, 23.34, -10000, 187.99)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 41.08, -10000, 186.05)
	event.EohSetRot(1, 0.0, -2.78, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetShow(0, 1)
	event.EohSetShow(1, 1)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-111.75, 911.17, 270.29)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	event.CmrsMove2(-140.06, 1514.42, 332.93, 0.0, 1253.54, 0.0, 60, 0, 0.8)
	helper_d779bb0d(40)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "26＿27", 6)
	event.ObjsMotionWait(2)
	helper_d779bb0d(6)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotionBlur(64)
	helper_1281c23c()
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotionBlur(0)
	event.CmrsInit()
	event.CmrsSetPos(-113.65, 1223.45, 218.04)
	event.CmrsSetRef(-1.11, 1286.35, -8.92)
	event.CmrsMoveAhd(-0.25, -62.9, 253.33, 54)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(0, 23.34, -12.5, 187.99)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 41.08, -11.08, 186.05)
	event.ObjsResetDaPosition(1)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetColor(7, 128, 128, 128, 128)
	event.EohSetShow(2, 0)
	event.CmrsSetPos(54.28, 1.22, 144.23)
	event.CmrsSetRef(22.48, 17.29, 208.69)
	event.SetProjection(524.9)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_3a88f4ff(6400400, 70)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_3a88f4ff(6400410, 180)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetColor(7, 128, 128, 128, 0)
	event.EohSetShow(2, 1)
	event.SetProjection(300.9)
	event.CmrsSetPos(193.62, 1333.67, 124.6)
	event.CmrsSetRef(93.29, 1343.08, 18.35)
	event.CmrsMove2(195.15, 1333.67, 68.97, 104.61, 1343.08, 9.78, 30, 2, 1.0)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(2, "29", 6, 0.9)
	event.ObjsMotionWait(2)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(10)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 1069.05, 466.47)
	event.CmrsSetRef(0.0, 1160.83, 96.08)
	event.CmrsMove(0.0, 1100.96, 396.56, 0.0, 1160.83, 96.08, 100)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "30", 6)
	event.ObjsMotionWait(2)
	helper_d779bb0d(75)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(36)
	event.ObjsSetPos(4, 114.76, 1281.45, -29.48)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.CharaActive(37)
	event.ObjsSetPos(5, -114.76, 1281.45, -29.48)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	event.CmrsQuake(0.0, 0.6, 0.0, 14)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(190.38, 1071.36, 114.36)
	event.CmrsSetRef(144.41, 1107.51, -36.76)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "31", 6)
	event.ObjsMotionWait(2)
	helper_d779bb0d(12)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotionBlur(64)
	event.HitEffect(0, 140.91, 1146.19, -9.4, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(1, 181.58, 1131.93, -25.69, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(2, 184.11, 1129.67, -49.68, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotionBlur(0)
	event.CmrsSetPos(-190.38, 1071.36, 114.36)
	event.CmrsSetRef(-144.41, 1107.51, -36.76)
	event.SndSePlay(var0, 3)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "31", 6)
	event.ObjsMotionWait(2)
	helper_d779bb0d(12)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotionBlur(64)
	event.HitEffect(0, -140.91, 1146.19, -9.4, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(1, -181.58, 1131.93, -25.69, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(2, -184.11, 1129.67, -49.68, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMotionBlur(0)
	event.CmrsSetPos(0.0, 1106.47, 385.24)
	event.CmrsSetRef(0.0, 1149.39, 96.08)
	event.CmrsMove(0.0, 1055.59, 385.24, 0.0, 1149.39, 96.08, 130)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(2, "33", 6)
	event.ObjsMotionWait(2)
	helper_d779bb0d(69)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsQuake(0.0, 1.0, 0.0, 20)
	event.ObjsSetPos(4, 42.33, 1231.79, -9.75)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.ObjsSetPos(5, -42.33, 1231.79, -9.75)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	helper_d779bb0d(41)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsQuake(0.0, 0.6, 0.0, 16)
	event.ObjsSetPos(4, 46.38, 1117.23, 34.1)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.ObjsSetPos(5, -46.38, 1117.23, 34.1)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	helper_b01df685(2)
	if vm.skipping() then
		return skip(21)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 1)
	event.CmrsSetPos(0.0, 1356.59, 38.54)
	event.CmrsSetRef(0.0, 1358.02, 15.88)
	event.CmrsMove2(0.0, 1356.15, 49.81, 0.0, 1358.02, 15.88, 30, 2, 0.4)
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(3, "34_2", 6)
	event.ObjsMotionWait(3)
	helper_b01df685(3)
	if vm.skipping() then
		return skip(23)
	end
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(1, 38)
	event.ObjsSetPos(6, 0.0, 1360.24, -11.53)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "目光る", 6)
	helper_d779bb0d(2)
	if vm.skipping() then
		return skip(25)
	end
	event.EohSetFrameStatus(3, "eye--appcobyf2", var3)
	helper_d779bb0d(28)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(3, "35", 6)
	event.ObjsNextMotion(3, "35_L", 4)
	event.SndSePlay(var0, 7)
	event.CmrsMove2(0.0, 1232.77, 438.43, 0.0, 1231.93, 403.93, 60, 0, 0.3)
	event.SetMotionBlur(84)
	helper_1281c23c()
	if vm.skipping() then
		return skip(27)
	end
	helper_b01df685(3)
	if vm.skipping() then
		return skip(28)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(29)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(30)
	end
	return part2()
end

--- Helper function.
local function helper_194cc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_1281c23c()
			end
			if at <= 2 then
				helper_d779bb0d(30)
			end
			if at <= 3 then
				helper_d779bb0d(60)
			end
			if at <= 4 then
				helper_d779bb0d(30)
			end
			if at <= 5 then
				helper_d779bb0d(20)
			end
			if at <= 6 then
				helper_d779bb0d(41)
			end
			if at <= 7 then
				helper_d779bb0d(30)
			end
			if at <= 8 then
				helper_1281c23c()
			end
			if at <= 9 then
				helper_d779bb0d(30)
			end
			if at <= 10 then
				helper_b01df685(4)
			end
			if at <= 11 then
				helper_d779bb0d(30)
			end
			if at <= 12 then
				helper_b01df685(2)
			end
			if at <= 13 then
				helper_d779bb0d(30)
			end
			if at <= 14 then
				helper_d779bb0d(50)
			end
			if at <= 15 then
				helper_d779bb0d(40)
			end
			if at <= 16 then
				helper_d779bb0d(50)
			end
			if at <= 17 then
				helper_d779bb0d(15)
			end
			if at <= 18 then
				helper_d779bb0d(15)
			end
			if at <= 19 then
				helper_d779bb0d(45)
			end
			if at <= 20 then
				helper_d779bb0d(30)
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
	event.LoadMes(0, 5, "e640.txt")
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
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetAhd(1.86, -17.01, 548.53)
	event.CmrsMoveAhd2(-1.71, 47.67, 704.92, 120, 0, 1.0)
	helper_1281c23c()
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove2(2, 1513.88, 598.13, -1096.51, 60, 0, 1.0)
	event.ObjsRotation(2, 0.0, 2.0, 0.0, 30)
	helper_d779bb0d(60)
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetShow(8, 1)
	event.ObjsSetMotion(8, "受け止め2", 6)
	event.ObjsSeDelay(2, 15)
	event.ObjsSePlay(2, var0, 3)
	event.ObjsSetMotion(2, "受け止め2", 6)
	event.ObjsNextMotion(2, "受け止め2L", 4)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsQuake(1.0, 5.0, 3.0, 60)
	helper_d779bb0d(41)
	if vm.skipping() then
		return skip(7)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(8)
	end
	helper_1281c23c()
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetShow(4, 1)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(4, "目光る", 6)
	event.ObjsMotionWait(4)
	helper_b01df685(4)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetShow(4, 1)
	helper_d779bb0d(30)
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
	helper_b01df685(2)
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(14)
	end
	helper_d779bb0d(50)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetShow(9, 1)
	event.ObjsSetMotion(9, "落ちる", 6)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(5.0, 10.0, 1.0, 40)
	helper_d779bb0d(40)
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
	helper_d779bb0d(50)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "着地L", 4)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(0.0, 6.0, 1.0, 60)
	event.ObjsMove2(2, 3965.6, 9.02, -2835.9, 60, 2, 1.0)
	helper_d779bb0d(15)
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
	helper_d779bb0d(15)
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
	helper_d779bb0d(45)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_816cbf1e(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.CmrsSetPos(0.0, 1000.0, -100.0)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ７３２光雨")
	event.EsmInitFix(5)
	event.EsmCreate("Ｅ７３２光雨")
	event.EsmSetVect1(0.0, 1000.0, 0.0)
	event.EsmSetVect2(100.0, 100.0, 100.0)
	event.EsmSetValue(0, 240)
	if vm.wait() then
		return skip(2)
	end
	helper_816cbf1e(32)
	if vm.skipping() then
		return skip(3)
	end
	event.EsmClear()
	event.Finish()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1e1ac()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s70", 530)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_dee4()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 620)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ff1c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11b1c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 620)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14c8c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 630)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 640.
script[640] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_194cc()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 650)
	if vm.wait() then
		return skip(2)
	end
end

return script
