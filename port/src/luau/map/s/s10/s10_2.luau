--!strict
-- map/s/s10/s10_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0735ac92 = require("@lib/event/helper_0735ac92")
local helper_1187f90e = require("@lib/event/helper_1187f90e")
local helper_19c9cbe6 = require("@lib/event/helper_19c9cbe6")
local helper_25e7cf9e = require("@lib/event/helper_25e7cf9e")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_6f401970 = require("@lib/event/helper_6f401970")
local helper_8b19a097 = require("@lib/event/helper_8b19a097")
local helper_91082b0b = require("@lib/event/helper_91082b0b")
local helper_92392c83 = require("@lib/event/helper_92392c83")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b2531e2e = require("@lib/event/helper_b2531e2e")
local helper_b90e1607 = require("@lib/event/helper_b90e1607")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")
local helper_c8ff2a87 = require("@lib/event/helper_c8ff2a87")
local helper_dae791fd = require("@lib/event/helper_dae791fd")
local helper_e1d7eb5a = require("@lib/event/helper_e1d7eb5a")
local helper_f4bde801 = require("@lib/event/helper_f4bde801")
local helper_fb70dad4 = require("@lib/event/helper_fb70dad4")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")
local helper_fed3fe0a = require("@lib/event/helper_fed3fe0a")

--- Helper function.
local function helper_261b8()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(500) or flag
	if flag == 0 then
		return
	end
	event.AssignStack(4)
	event.ClearStack(4)
	var1 = event.GetChapter() or var1
	if var1 ~= 6 and var1 ~= 7 then
		event.LoadChara(4, "chara/p01_03a.gltf", "info", 8)
		event.CharaActive(8)
		event.SetCharaPos(8, 2340.0, 0.0, 1645.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetCharaNo(8, 1)
		event.RegisterVillager(8, 1)
	else
		event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
		event.CharaActive(8)
		event.SetCharaPos(8, 2340.0, 0.0, 1645.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetCharaNo(8, 301)
		event.RegisterVillager(8, 301)
	end
end

--- Program 99.
local function program_99()
	helper_4337dd96()
	helper_c8ff2a87()
	helper_261b8()
end

--- Helper function.
local function helper_270a0()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(15)
		end
		helper_e1d7eb5a(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 16)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 70)
	event.ObjsAddPas(0, 2730.28, 163.23, 630.94)
	event.ObjsAddPas(0, 2674.4, 138.96, 765.84)
	event.ObjsAddPas(0, 2616.58, 125.16, 846.91)
	event.ObjsStartPas(0)
	event.CmrsInit()
	event.CmrsSetPos(2590.33, 108.76, 1218.81)
	event.CmrsSetRef(2591.54, 130.16, 1030.59)
	event.SetFadeIn(15)
	helper_a8b5d854(40)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 0)
	helper_e1d7eb5a(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	event.ResetCamera(1, 3.1415927, 10.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_29fc8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 26 then
			if at <= 1 then
				helper_a8b5d854(90)
			end
			if at <= 2 then
				helper_a8b5d854(30)
			end
			if at <= 3 then
				helper_40ca6466(2)
			end
			if at <= 4 then
				helper_a8b5d854(75)
			end
			if at <= 5 then
				helper_a8b5d854(20)
			end
			if at <= 7 then
				helper_a8b5d854(30)
			end
			if at <= 8 then
				helper_a8b5d854(5)
			end
			if at <= 9 then
				helper_a8b5d854(25)
			end
			if at <= 10 then
				helper_a8b5d854(30)
			end
			if at <= 11 then
				helper_a8b5d854(30)
			end
			if at <= 12 then
				helper_a8b5d854(30)
			end
			if at <= 13 then
				helper_8b19a097(5000020, 60)
			end
			if at <= 14 then
				helper_a8b5d854(30)
			end
			if at <= 15 then
				helper_a8b5d854(30)
			end
			if at <= 16 then
				helper_8b19a097(5000030, 150)
			end
			if at <= 17 then
				helper_8b19a097(5000040, 135)
			end
			if at <= 18 then
				helper_19c9cbe6(5000045)
			end
			if at <= 19 then
				helper_19c9cbe6(5000050)
			end
			if at <= 20 then
				helper_40ca6466(0)
			end
			if at <= 21 then
				helper_19c9cbe6(5000060)
			end
			if at <= 22 then
				helper_19c9cbe6(5000070)
			end
			if at <= 23 then
				helper_19c9cbe6(5000080)
			end
			if at <= 24 then
				helper_fb70dad4(1, 4)
				helper_b2531e2e(1, -1, 8, 0, 0)
			end
			if at <= 25 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(27)
			end
			return part2()
		end
		helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetPos(2, 2837.4, 6.0, 1289.1)
		event.EohSetRot(2, 0.0, 2.4260077, 0.0)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EohSetShow(21, 1)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.SetStatus(1, 0, 8, 0)
		event.SetStatus(1, 32, 8, 0)
		event.SetStatus(1, 8, 8, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.CharaActive(1, 122)
		event.CharaActive(1, 123)
		event.SndSeStop(var0, 6)
		event.SndSeStop(var0, 7)
		event.EsmClear()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(8)
		event.LoadMes(0, -1)
		event.SetSavedataEtc(0, 7)
		helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(500, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(5200)
	var0 = event.SndLoadSound(5200) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e500/")
	event.LoadMes(0, 5, "e500_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e500_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e500_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "steam_slow_l.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(17, 34)
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.ObjsSetPos(17, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "steam_slow_r.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(18, 35)
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.ObjsSetPos(18, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "train_hibana.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(19, 36)
	event.ObjsInit(19)
	event.ObjsSyncObj(19, 19)
	event.CopyChara(5, 36, 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(20, 37)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e500/e500_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e500/e500/e500_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.LoadChara(5, "chara/p01_03a.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(10, 8)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.LoadChara(5, "event/e500/e500/e207_vorneo.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(11, 9)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.LoadChara(5, "event/e500/e500/e207_tom.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(12, 10)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(2, "p01_train01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01", "train08-m0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "train08-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "train10-m0")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "train10-m1")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "train07-m3")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_train01", "train07-m4")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p01_train01", "train07-m5")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(13, "p01_train01", "train05-m17")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p01_train01", "train05-m16")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p01_train01", "train06-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(16, "p01_train01", "train06-m0")
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.EohSyncObj(21, "p01_shadow-0")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.EohSetPos(0, 2382.27, 41.01, 1705.74)
	event.EohSetRot(0, 0.0, -2.3, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, 2384.06, 42.55, 1716.02)
	event.EohSetRot(1, 0.0, -2.3, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 6)
	event.EohSetPos(10, 2397.6, 43.23, 1711.52)
	event.EohSetRot(10, 0.0, -2.3, 0.0)
	event.EohSetMotion(10, "立ち", 4)
	event.EohSetFootSoundId(10, 6)
	event.EohSetPos(2, 2128.3, 9.0, 2080.6)
	event.EohSetRot(2, 0.0, 2.495821, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetRot(13, 0.0, 0.0, 0.0)
	event.EohSetRot(14, 0.0, 0.0, 0.0)
	event.EohSetRot(15, 0.0, 0.0, 0.0)
	event.EohSetRot(16, 0.0, 0.0, 0.0)
	event.EohSetShow(7, 0)
	event.EohSetShow(8, 0)
	event.EohSetShow(9, 0)
	event.EohSetShow(21, 0)
	event.EohSetPos(17, 2128.3, 9.0, 2080.6)
	event.EohSetPos(18, 2128.3, 9.0, 2080.6)
	event.SetStatus(1, 0, 8, 1)
	event.SetStatus(1, 32, 8, 1)
	event.SetStatus(1, 8, 8, 1)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsInit()
	event.CmrsSetPos(3045.82, 154.0, 603.5)
	event.CmrsSetRef(2536.0, 67.0, 2000.0)
	event.ObjsSetPos(17, 2105.42, 31.57, 2072.94)
	event.ObjsSetRot(17, 0.0, 2.44, 0.0)
	event.ObjsSetPos(18, 2136.76, 22.97, 2082.99)
	event.ObjsSetRot(18, 0.0, 2.44, 0.0)
	event.ObjsSetRot(19, 0.0, 2.44, 0.0)
	event.ObjsSetPos(19, 2136.76, 22.97, 2082.99)
	event.ObjsSetRot(19, 0.0, 2.44, 0.0)
	event.ObjsSetPos(20, 2136.76, 22.97, 2082.99)
	event.ObjsSetRot(20, 0.0, 2.2, 0.0)
	event.CmrsMove2(2704.05, 126.34, 969.56, 3385.02, 64.22, 713.94, 110, 2, 1.0)
	event.ObjsMove2(2, 3139.7, 6.0, 918.2, 90, 2, 1.0)
	event.ObjsMove2(17, 3031.0, 44.52, 961.3, 90, 2, 1.0)
	event.ObjsMove2(18, 3155.72, 91.2, 940.8, 90, 2, 1.0)
	event.ObjsMove2(19, 3113.06, 16.05, 850.16, 90, 2, 1.0)
	event.ObjsMove2(20, 3066.8, 16.05, 937.56, 90, 2, 1.0)
	event.ObjsRotDelay(13, 70)
	event.ObjsRotation2(13, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.ObjsRotDelay(14, 70)
	event.ObjsRotation2(14, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.ObjsRotDelay(15, 70)
	event.ObjsRotation2(15, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.ObjsRotDelay(16, 70)
	event.ObjsRotation2(16, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(10, 0)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(2, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 2)
	event.SetFadeIn(30)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var0, 6)
	helper_a8b5d854(90)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetShow(19, 1)
	event.EohSetShow(20, 1)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetMotion(19, "ｴﾌｪｸﾄ_火花", 4)
	event.ObjsSetMotion(20, "ｴﾌｪｸﾄ_火花", 4)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaShow(36, 0, 1, 0.1)
	event.SetCharaShow(37, 0, 1, 0.1)
	event.CharaActive(34)
	event.CharaActive(35)
	event.EohSetShow(17, 1)
	event.EohSetShow(18, 1)
	event.ObjsSetMotion(17, "ぶしゅー", 6)
	event.ObjsSetMotion(18, "ぶしゅー", 6)
	event.ObjsMotionWait(17)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_a8b5d854(75)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SetFadeOut(20)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(5)
	if vm.wait() then
		return skip(7)
	end
	event.SndInReverb(1)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(8)
	end
	event.InitDramaScene()
	event.SetFadeIn(20)
	event.EohSetShow(7, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.EohSetShow(21, 1)
	event.ObjsSetPos(2, 2786.4, 6.0, 1333.3)
	event.EohSetRot(2, 0.0, 2.422517, 0.0)
	event.StopBgm(0)
	event.LoadBgm(4)
	event.PlayBgm(0)
	event.CmrsSetPos(2066.31, 175.05, 1569.8)
	event.CmrsSetRef(2394.41, 50.17, 1680.51)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(8)
	helper_a8b5d854(5)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 7)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	helper_a8b5d854(25)
	if vm.skipping() then
		return skip(10)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 2374.17, 41.99, 1697.89, 30)
	event.ObjsPosDelay(1, 30)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 2362.0, 42.55, 1698.53, 45)
	event.ObjsPosDelay(10, 90)
	event.ObjsMotionDelay(10, 90)
	event.ObjsSetMotion(10, "歩き")
	event.ObjsMove(10, 2370.1, 42.05, 1695.1, 50)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(2287.78, 88.48, 1626.22)
	event.CmrsSetRef(2356.53, 39.11, 1685.03)
	event.CmrsMove2(2290.62, 70.54, 1629.19, 2345.8, 32.47, 1678.44, 90, 2, 1.0)
	event.ObjsSetMotion(0, "上見歩き", 4)
	event.ObjsMove(0, 2315.09, 0.0, 1657.75, 180)
	event.ObjsMove(0, 2279.82, 0.0, 1641.44, 60)
	event.ObjsSetMotion(1, "上見歩き", 4)
	event.ObjsPosDelay(1, 15)
	event.ObjsMotionDelay(1, 15)
	event.ObjsMove(1, 2327.23, 0.0, 1646.23, 175)
	event.ObjsMove(1, 2299.73, 0.0, 1624.52, 90)
	event.ObjsPosDelay(10, 50)
	event.ObjsMotionDelay(10, 50)
	event.ObjsMove(10, 2317.79, 0.0, 1657.54, 160)
	event.ObjsMotionDelay(10, 160)
	event.ObjsNextMotion(10, "立ち")
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_8b19a097(5000020, 60)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(2276.95, 8.29, 1699.56)
	event.CmrsSetRef(2299.83, 22.14, 1634.76)
	event.CmrsMove2(2284.38, 11.92, 1696.16, 2289.11, 21.16, 1630.83, 90, 2, 1.0)
	event.EohSetFootSoundId(0, 16)
	event.ObjsNextMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsNextMotion(0, "立ち")
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 135)
	event.ObjsNextMotion(1, "立ち")
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SetStatus(1, 0, 8, 0)
	event.SetStatus(1, 32, 8, 0)
	event.SetStatus(1, 8, 8, 0)
	event.EohSetFootSoundId(1, 16)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_8b19a097(5000030, 150)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_8b19a097(5000040, 135)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_19c9cbe6(5000045)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_19c9cbe6(5000050)
	if vm.skipping() then
		return skip(20)
	end
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetCharaPos(9, 2428.11, 1.16, 1553.04)
	event.SetCharaRot(9, 0.0, -1.07, 0.0)
	event.SetCharaPos(10, 2407.91, 0.0, 1529.52)
	event.SetCharaRot(10, 0.0, -1.08, 0.0)
	event.ObjsSetPos(0, 2290.27, 0.0, 1646.13)
	event.ObjsSetRot(0, 0.0, -2.3, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 2307.29, 0.0, 1634.49)
	event.ObjsSetRot(1, 0.0, -2.42, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetRot(10, 0.0, -2.78, 0.0)
	event.CmrsSetPos(2182.37, 51.29, 1680.81)
	event.CmrsSetRef(2393.77, -7.42, 1580.11)
	event.ObjsSetMotion(10, "会話", 6)
	event.ObjsNextMotion(10, "立ち", 4)
	event.ObjsTexAnime(10, 0)
	event.ObjsTexAnime(10, 1, "デフォルト顔")
	event.ObjsTexAnime(10, 1, "通常目パチ")
	event.SetPakuAnim(10, "通常口パク")
	helper_19c9cbe6(5000060)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(11, "会話")
	event.ObjsMotionDelay(11, 30)
	event.ObjsNextMotion(11, "立ち", 4)
	event.ObjsMotionDelay(1, 15)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsTexAnime(11, 0)
	event.ObjsTexAnime(11, 1, "目パチ")
	event.SetPakuAnim(11, "口パク")
	helper_19c9cbe6(5000070)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(12, "会話", 6)
	event.ObjsNextMotion(12, "立ち", 4)
	event.ObjsTexAnime(12, 0)
	event.ObjsTexAnime(12, 1, "目パチ")
	event.SetPakuAnim(12, "口パク")
	helper_19c9cbe6(5000080)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	event.SetMesPreset(1, 4)
	helper_fb70dad4(1, 4)
	event.MesMake_2(1, "Born[UNI00e9]o et [UNI00c9]rik peuvent [UNI00ea]tre mis dans le G[UNI00e9]orama.")
	helper_b2531e2e(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(25)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(26)
	end
	return part2()
end

--- Helper function.
local function helper_289f8()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			angle = vm.f32(rot_y - vm.f32(3.1415927))
			var1 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z)
			helper_40ca6466(1)
		end
		if at <= 2 then
			helper_c8ff2a87()
			helper_a8b5d854(30)
		end
		if at <= 3 then
			helper_a8b5d854(46)
		end
		if at <= 4 then
			helper_a8b5d854(15)
		end
		helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var0
	helper_0735ac92()
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(2, "p01_train01", "train08-m4")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01", "train08-m5")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "train10-m4")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "train10-m5")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, 2101.51, 40.82, 2060.52)
	event.EohSetRot(0, 0.0, -2.26, 0.0)
	event.EohResetDaPosition(0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = event.EohGetRot(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var1 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x)
	var2 = pos_y
	var3 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z)
	event.EohSetPos(1, var1, var2, var3)
	event.ObjsMove2(1, pos_x, pos_y, pos_z, 40, 2, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(1514.63, 208.98, 2402.32)
	event.CmrsSetRef(1792.39, 155.32, 2165.78)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(1, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 1)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_40ca6466(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	helper_c8ff2a87()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CmrsSetPos(1899.12, 13.68, 1889.27)
	event.CmrsSetRef(1958.62, 31.92, 1939.67)
	var11 = event.GetSndId(2) or var11
	event.SndSePlay(var11, 106)
	event.CharaActive(0)
	event.EohSetPos(1, pos_x, pos_y, pos_z)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 56)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 2087.08, 40.82, 2048.3, 14)
	event.ObjsMove(0, 2037.85, 0.0, 2005.99, 32)
	event.ObjsMove(0, 2017.4, 0.0, 1988.67, 10)
	helper_a8b5d854(46)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(0, 16)
	event.SetFadeOut(15)
	helper_a8b5d854(15)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.EohSetFootSoundId(0, 0)
	event.CharaActive(0)
	helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.ResetCamera(1, 3.1415927, 10.0)
	event.EsmClear()
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_27580()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			angle = vm.f32(rot_y - vm.f32(3.1415927))
			var4 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_2)
			var5 = pos_y_2
			var6 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_2)
			helper_40ca6466(1)
		end
		if at <= 2 then
			helper_a8b5d854(30)
		end
		if at <= 3 then
			helper_a8b5d854(20)
		end
		if at <= 4 then
			helper_40ca6466(0)
		end
		if at <= 5 then
			helper_a8b5d854(10)
		end
		helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = event.EohGetRot(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var4 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_2)
	var5 = pos_y_2
	var6 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_2)
	event.EohSetPos(1, var4, var5, var6)
	event.ObjsMove2(1, pos_x_2, pos_y_2, pos_z_2, 40, 2, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(1514.63, 208.98, 2402.32)
	event.CmrsSetRef(1792.39, 155.32, 2165.78)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_40ca6466(1)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(1890.88, 13.68, 2033.57)
	event.CmrsSetRef(1970.25, 31.92, 2037.52)
	event.CharaActive(0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsSetPos(0, 2125.0, 40.0, 2080.0)
	event.ObjsSetRot(0, 0.0, -2.26, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	var14 = event.GetSndId(2) or var14
	event.SndSePlay(var14, 92)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(5, pos_x + 11.25, pos_y - 4.75, pos_z, 30)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, 2050.0, 0.0, 2015.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.EohSetRot(1, 0.0, rot_y, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(0)
	helper_e1d7eb5a(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.ResetCamera(1, 3.1415927, 10.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_1ce5c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb70dad4(0, 1)
			return 0
		end
		if at <= 3 then
			helper_a8b5d854(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_fb70dad4(0, 4)
	event.MesMake_2(0, "Entrer\nPartir")
	var0 = helper_25e7cf9e(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_fb70dad4(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_a8b5d854(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_a8b5d854(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2ffd4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_a8b5d854(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_26680()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_a8b5d854(50)
			end
			if at <= 2 then
				helper_a8b5d854(20)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_f4bde801(5, 3)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 16)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(2590.33, 108.76, 1218.81)
		event.CmrsSetRef(2591.54, 130.16, 1030.59)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 70)
		event.ObjsAddPas(0, 2616.58, 125.16, 846.91)
		event.ObjsAddPas(0, 2674.4, 138.96, 765.84)
		event.ObjsAddPas(0, 2730.28, 163.23, 630.94)
		event.ObjsStartPas(0)
		helper_a8b5d854(50)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(20)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(-0.42)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(-0.42)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	event.EohSetFootSoundId(0, 0)
	return 0
end

--- Helper function.
local function helper_1d208(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(
			arg0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "H[UNI00e9], [UNI00e7]a roule ? Moi, c'est l'top !")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Je prie pour que le monde vive\nenfin en paix.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
end

--- Helper function.
local function helper_1f62c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = vm.f32(var7 * -1.0)
		var3 = var7
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetNpcTrainEtc(1, arg1) or var2
	do
		local out1, out2, out3, _ = event.GetTrainNpcPos(var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = event.GetNpcTrainEtc(2, arg1) or var7
	if var3 < 0 then
		var3 = vm.f32(var7 * -1.0)
	else
		var3 = var7
	end
	event.SetCharaPos(arg0, var3, var4, var5)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "待機", 4)
end

--- Helper function.
local function helper_20a64(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b90ffbb8(1)
		helper_1f62c(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_b90ffbb8(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1f62c(arg0, argc)
	end
end

--- Helper function.
local function helper_20d0c(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(30)
		end
		helper_20a64(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_20a64(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f920(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_b2531e2e(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_fb70dad4(arg0, 1)
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_b2531e2e(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_fb70dad4(arg0, 1)
		event.MesMake_2(arg0, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
		if now_map_no == 22 then
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_b2531e2e(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_fb70dad4(arg0, 1)
		event.MesMake_2(
			arg0,
			"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
		)
		if now_map_no == 22 then
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_b2531e2e(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1ffa8(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b2531e2e(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_b2531e2e(arg0, -1, 3, 256, 208)
			end
			return helper_1f920(arg0)
		end
		if at <= 5 then
			helper_fb70dad4(arg0, 1)
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_b2531e2e(arg0, -1, 3, 256, 208)
		end
		return helper_1f920(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_fb70dad4(arg0, 1)
		event.MesMake_2(arg0, "Va me chercher un\nM[UNI00e9]mo de scoops, tu veux bien ?")
		if now_map_no == 22 then
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_b2531e2e(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_fb70dad4(arg0, 1)
		event.MesMake_2(arg0, "On dirait qu'il n'y\na plus de scoops.")
		if now_map_no == 22 then
			helper_91082b0b(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_b2531e2e(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_1f920(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_fb70dad4(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "J'ai trouv[UNI00e9] [Number1] nouveau(x) scoop(s).")
		event.SetMesDrawspeed(arg0, 0)
		helper_b2531e2e(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_fb70dad4(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allez ! Arr[UNI00ea]te de lambiner !\nIls sont o[UNI00f9] tes super scoops ?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ouah ! Tu as [Number1] nouveau(x)\nscoop(s) ! Je savais que tu y\narriverais.")
	end
	if now_map_no == 22 then
		helper_91082b0b(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_b2531e2e(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_1f920(arg0)
end

--- Helper function.
local function helper_1e630()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Bravo ! Les hommes ne sont\npas si mauvais apr[UNI00e8]s tout !<page>J'avais tort !")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00c7]a y est. C'est presque termin[UNI00e9].\nIl ne reste plus qu'[UNI00e0] le vaincre.<page>Apr[UNI00e8]s [UNI00e7]a, le monde pourra revivre."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Je crois comprendre Griffon, mais\nje ne pourrai jamais lui pardonner.")
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Reconstruis le jardin, et d[UNI00e9]couvre\nle secret de Griffon, euh... Sirus.")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Qu'est-ce que [UNI00e7]a veut dire les\n\"souvenirs de Sirus\"?\nJe suppose qu'il\nfaut entrer au palais pour comprendre."
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Vite, Griffon va s'[UNI00e9]chapper, allons\nau Palais de fleur-lune !")
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Les pierres semblent toutes l[UNI00e0].\nAllons vite [UNI00e0] Stonehenge Kazarov.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Peu importe, trouvons vite les\npierres, ou il sera trop tard.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Tout a d[UNI00e9]but[UNI00e9] dans ce palais,\nhein. Bon, allons dans le jardin.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Rentrons au Labo psy. Peut-[UNI00ea]tre\nauront-ils fini l'Ixion ?")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Il est temps de riposter contre\nGriffon. Allons au QG de Paznos.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Galen Agaris a dit que jouer de la\nCorne de feu t'ouvrirait la route.")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Il faut pulv[UNI00e9]riser ce Lance-feu.<page>Il serait au sommet du Mt Gundor.")
		return
	end
	event.MesMake_2(
		3,
		"Attendre ici ne changera rien.<page>Il y a s[UNI00fb]rement un lieu o[UNI00f9] on\nn'est pas encore all[UNI00e9]s."
	)
end

--- Helper function.
local function helper_20e40(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			argc = 1
			argc = 2
			argc = 13
			return
		end
		if at <= 5 then
			if at <= 2 then
				var24 = 0
				helper_fb70dad4(3, 1)
				helper_1d208(3, argc)
				var25 = -1
				helper_fdffeda5(3, var25, 3, 256, 208)
				helper_fb70dad4(1, 8)
				helper_fdffeda5(1, 1, 1, 0, 0)
				helper_fb70dad4(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_25e7cf9e(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_b90ffbb8(3)
				helper_a8b5d854(30)
			end
			helper_20a64(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_fb70dad4(3, 8)
				helper_b2531e2e(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_b2531e2e(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_20a64(arg0, arg1)
				helper_20d0c(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20d0c(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20d0c(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20d0c(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20d0c(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20d0c(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20d0c(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20d0c(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20d0c(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20d0c(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20d0c(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20d0c(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20d0c(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20d0c(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20d0c(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20d0c(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20d0c(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20d0c(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20d0c(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20d0c(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20d0c(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20d0c(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20d0c(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e630()
			helper_b2531e2e(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_20a64(arg0, arg1)
			helper_a8b5d854(30)
		end
		helper_20a64(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.GetLocalCnt(arg0) or argc
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if argc == 18 then
		var4 = 20
	end
	if argc == 25 then
		var4 = 24
	end
	if argc == 12 or argc == 17 then
		var4 = 28
	end
	if argc == 7 then
		var4 = 32
	end
	if argc == 10 or argc == 6 or argc == 24 then
		var4 = 40
	end
	if argc == 8 or argc == 1 or argc == 2 or argc == 3 or argc == 15 or argc == 16 or argc == 21 then
		var4 = 44
	end
	if argc == 4 or argc == 19 or argc == 20 or argc == 22 then
		var4 = 48
	end
	if argc == 5 or argc == 11 or argc == 23 or argc == 13 then
		var4 = 52
	end
	if argc == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	event.EyeViewDrawOnOff(1)
	if arg1 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.EohGetRot(0)
			var9 = out2 or var9
		end
	else
		var11 = event.GetNpcTrainEtc(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.GetTrainNpcPos(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.EohSyncChara(0, arg0)
		event.EohSetPos(0, var5, var6, var7)
		event.EohSetRot(0, 0.0, var9, 0.0)
		event.SetMotion(arg0, "立ち", 4)
	end
	var12 = vm.f32(vm.sin(var9) * 75.0)
	var12 = vm.f32(var12 + var5)
	var13 = vm.f32(var6 + 45.0)
	var14 = vm.f32(vm.cos(var9) * 75.0)
	var14 = vm.f32(var14 + var7)
	event.SetCameraPos(var12, var13, var14)
	var15 = var5
	var16 = vm.f32(var6 + 30.0)
	var17 = var7
	event.SetCameraRef(var15, var16, var17)
	var18 = vm.f32(vm.sin(var9) * 30.0)
	var18 = vm.f32(var18 + var5)
	var19 = var6
	var20 = vm.f32(vm.cos(var9) * 30.0)
	var20 = vm.f32(var20 + var7)
	event.SetCharaPos(0, var18, var19, var20)
	var21 = 0
	var22 = vm.f32(var9 + vm.f32(3.1415927))
	if var22 > vm.f32(3.1415927) then
		var22 = vm.f32(var22 - vm.f32(6.2831855))
	end
	var23 = 0
	event.SetCharaRot(0, var21, var22, var23)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_fb70dad4(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1d208(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_fdffeda5(3, var25, 3, 256, 208)
		helper_fb70dad4(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_fdffeda5(1, 1, 1, 0, 0)
		helper_fb70dad4(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.SetMesItemDirect(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.SetMesItemDirect(2, 1, var25)
			event.SetMesItemDirect(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_25e7cf9e(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_b90ffbb8(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_a8b5d854(30)
				if vm.skipping() then
					return skip(4)
				end
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_20a64(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_fb70dad4(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]Tu ne peux pas faire [UNI00e7]a maintenant. Tu\ndois d'abord emmener Lin au phare !"
			)
			helper_b2531e2e(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_fb70dad4(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_b2531e2e(3, var25, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Tr[UNI00e8]s bien, on a termin[UNI00e9]\nles r[UNI00e9]parations !")
						helper_b2531e2e(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_20a64(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20d0c(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20d0c(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1ffa8(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20d0c(arg0, arg1, 33)
							if vm.skipping() then
								return skip(12)
							end
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_20d0c(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20d0c(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20d0c(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20d0c(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20d0c(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20d0c(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20d0c(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20d0c(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20d0c(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20d0c(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20d0c(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20d0c(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20d0c(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20d0c(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20d0c(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20d0c(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20d0c(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20d0c(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20d0c(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20d0c(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20d0c(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e630()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_b2531e2e(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_20a64(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_a8b5d854(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_20a64(arg0, arg1)
						event.SetFadeIn(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_20a64(arg0, arg1)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_25050()
	local var0: s32 = 0
	local var1: s32 = 0
	local now_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local var9: f32 = 0
	local player_chara: s32 = 0
	local var11: any = 0
	local now_party_chara_id: s32 = 0
	local now_map_no_2: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local var17: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_91082b0b(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_25e7cf9e(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_91082b0b(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_92392c83(var0, var9, 0, 0)
			end
			return
		end
		if at <= 6 then
			helper_20e40(var17, 1)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	var1 = 0
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no == 16 then
		flag = event.GetFlag(280) or flag
		flag_2 = event.GetFlag(283) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 54 then
		flag_3 = event.GetFlag(372) or flag_3
		flag_4 = event.GetFlag(360) or flag_4
		if flag_3 ~= 0 and flag_4 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 83 then
		flag_5 = event.GetFlag(448) or flag_5
		flag_6 = event.GetFlag(452) or flag_6
		if flag_5 ~= 0 and flag_6 == 0 then
			var1 = 1
		end
	end
	if var1 == 1 then
		helper_fb70dad4(0, 1)
		var9 = helper_1187f90e(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "Tu veux partir ?")
		helper_91082b0b(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Ouais !\nJe veux rester encore un peu.")
		var11 = helper_25e7cf9e(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "Uumf allez, vas-y, fonce !")
			helper_91082b0b(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_92392c83(var0, var9, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
		if var11 == 0 then
			return
		else
			return
		end
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 1 then
		helper_fb70dad4(0, 1)
		event.MesMake_2(0, "Faites attention l[UNI00e0]-bas.")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
		end
		helper_dae791fd(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_20e40(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
end

--- Helper function.
local function helper_25f60()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb70dad4(0, 1)
			helper_dae791fd(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_fb70dad4(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Je vous attendrai ici.\nJ'esp[UNI00e8]re que tout ira bien.")
	else
		event.MesMake_2(0, "Je vous attendrai ici.\nNe le ratez pas !")
	end
	helper_dae791fd(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_29fc8()
				if not vm.skipping() then
					return landing1()
				end
			end
			helper_261b8()
			return
		end
		if at <= 3 then
			helper_27580()
		end
	end
	function part2() end
	function landing1()
		helper_261b8()
		event.SetNpcStatus(2, 130)
		event.SetNpcStatus(13, 130)
	end
	program_99()
	old_map_no = event.GetOldMapNo() or old_map_no
	var1 = event.GetMapType() or var1
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_e1d7eb5a(vm.f32(2373.8), 0.0, vm.f32(1497.9), vm.f32(-2.17))
		event.ResetCamera(1, 0.0, 20.0)
	elseif var1 ~= -1 then
		if old_map_no == 3 then
			helper_270a0()
			if vm.skipping() then
				return skip(1)
			end
		else
			flag = event.GetFlag(452) or flag
			flag_2 = event.GetFlag(500) or flag_2
			if flag == 1 and flag_2 == 0 then
				helper_29fc8()
				if vm.skipping() then
					return skip(2)
				end
				helper_261b8()
				event.SetNpcStatus(2, 130)
				event.SetNpcStatus(13, 130)
				return
			end
			var5 = event.GetCnt(1) or var5
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var5 == 5 then
				helper_946c0402()
				event.SetFadeIn(15)
				event.ResetCamera(1, 0.0)
			else
				var6 = event.GetChapter() or var6
				if var6 ~= 6 and var6 ~= 7 then
					helper_289f8()
					if vm.skipping() then
						return skip(3)
					end
				else
					helper_27580()
					if vm.skipping() then
						return skip(4)
					end
				end
			end
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27580()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_b90e1607()
		end
		if at <= 6 then
			helper_6f401970(1)
		end
		if at <= 7 then
			helper_fed3fe0a()
		end
	end
	var0 = helper_1ce5c()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 5)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_b90e1607()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_b90e1607()
			if vm.skipping() then
				return skip(4)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(5)
			end
			event.MapJump(-1, "s37")
		end
		if vm.wait() then
			return skip(6)
		end
	elseif var1 ~= 6 and var1 ~= 7 then
		helper_6f401970(1)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_fed3fe0a()
		if vm.skipping() then
			return skip(8)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2ffd4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	program_99()
	helper_e1d7eb5a(2288.0, 0.0, 1488.0, vm.f32(0.87))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- Program 550.
script[550] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_26680()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(504) or flag
		if flag == 0 then
			event.MapJump(-1, "s41", 501)
			if vm.wait() then
				return skip(2)
			end
		else
			event.MapJump(-1, "g04")
			if vm.wait() then
				return skip(3)
			end
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_25f60()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		helper_25050()
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 301 then
		helper_25f60()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 15000.
script[15000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_261b8()
	end
	event.SetFlag(500, 0)
	program_99()
	helper_29fc8()
	if vm.skipping() then
		return skip(1)
	end
	helper_261b8()
end

return script
