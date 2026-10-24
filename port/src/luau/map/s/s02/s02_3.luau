--!strict
-- map/s/s02/s02_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_075f4942 = require("@lib/event/helper_075f4942")
local helper_07ea621b = require("@lib/event/helper_07ea621b")
local helper_0ba263f7 = require("@lib/event/helper_0ba263f7")
local helper_0c95681b = require("@lib/event/helper_0c95681b")
local helper_0e678234 = require("@lib/event/helper_0e678234")
local helper_2ddedb3b = require("@lib/event/helper_2ddedb3b")
local helper_3fe18432 = require("@lib/event/helper_3fe18432")
local helper_535758bd = require("@lib/event/helper_535758bd")
local helper_5be1f3fa = require("@lib/event/helper_5be1f3fa")
local helper_68811019 = require("@lib/event/helper_68811019")
local helper_77f8061a = require("@lib/event/helper_77f8061a")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")
local helper_8834eba9 = require("@lib/event/helper_8834eba9")
local helper_965e9542 = require("@lib/event/helper_965e9542")
local helper_97594088 = require("@lib/event/helper_97594088")
local helper_9f92098d = require("@lib/event/helper_9f92098d")
local helper_ab048abf = require("@lib/event/helper_ab048abf")
local helper_c3fd0843 = require("@lib/event/helper_c3fd0843")
local helper_c776923d = require("@lib/event/helper_c776923d")
local helper_d14df93d = require("@lib/event/helper_d14df93d")
local helper_d4172c24 = require("@lib/event/helper_d4172c24")
local helper_ecb662ce = require("@lib/event/helper_ecb662ce")
local helper_ed22addb = require("@lib/event/helper_ed22addb")
local helper_f8047a1c = require("@lib/event/helper_f8047a1c")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_2627c()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_s0201", "s0208-m0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(1, "p01_s0201", "s0208-m1")
	event.EohSetShow(1, 0)
	event.EohSyncObj(2, "p01_s0201", "s0208-m2")
	event.EohSetShow(2, 0)
	event.EohSyncObj(3, "p01_s0201", "s0208-m3")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, "p01_s0201", "s0213-m0")
	event.EohSetShow(4, 0)
end

--- Helper function.
local function helper_45554()
	local flag: s32 = 0
	print("map_init-------------------------\n")
	flag = event.GetFlag(280) or flag
	if flag ~= 0 then
		helper_2627c()
	end
	helper_075f4942()
	helper_ed22addb()
	helper_d4172c24()
end

--- Helper function.
local function helper_3fdd4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 38)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(3, 36)
	event.ObjsSyncObj(3, 4)
	event.LoadMes(0, 5, "event/e200/e254/e254.txt")
end

--- Helper function.
local function helper_3fa60()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(38)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(38)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(36)
end

--- Helper function.
local function helper_40b08()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_0c95681b(4)
			end
			if at <= 2 then
				helper_3fdd4()
				helper_ecb662ce(0, 1)
				helper_0c95681b(30)
			end
			if at <= 3 then
				helper_0c95681b(135)
			end
			if at <= 4 then
				helper_8834eba9(0, -1, 2, 256, 416)
			end
			if at <= 5 then
				helper_0c95681b(15)
			end
			if at <= 6 then
				helper_8834eba9(0, -1, 7, 341, 208)
			end
			if at <= 7 then
				helper_8834eba9(0, -1, 8, 341, 208)
			end
			if at <= 8 then
				helper_0c95681b(45)
			end
			if at <= 9 then
				helper_0c95681b(45)
			end
			if at <= 10 then
				helper_0c95681b(8)
			end
			if at <= 11 then
				helper_0c95681b(22)
			end
			if at <= 12 then
				helper_0c95681b(30)
			end
			if at <= 13 then
				helper_0c95681b(30)
			end
			if at <= 14 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		helper_3fa60()
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, global0, 8, 0)
		event.SetStatus(1, global1, 8, 0)
		helper_3fa60()
		event.Finish()
		event.BgmLoadCancel()
	end
	event.SetFlag(254, 1)
	event.Initialize()
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_0c95681b(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(49)
	helper_3fdd4()
	helper_ecb662ce(0, 1)
	event.InitDramaScene()
	event.PlayBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(-585.93, 175.94, -940.12)
	event.CmrsSetRef(-702.67, 128.67, -892.92)
	event.CmrsMove(-565.48, 108.18, -866.56, -690.38, 73.25, -848.03, 165)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 36)
	event.SetStatus(1, global0, 8, 1)
	event.SetStatus(1, global1, 8, 1)
	event.ObjsSetPos(0, -1285.55, 14.1, -942.2)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsReference(0, -749.29, 0.0, -826.86, 1)
	event.ObjsMove(0, -749.29, 0.0, -826.86, 165, 1)
	event.EohSetFootSoundId(0, 1)
	event.SetFadeIn(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetPos(1, -1285.55, 14.1, -942.2)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsReference(1, -767.89, 0.0, -768.84, 1)
	event.ObjsMove(1, -767.89, 0.0, -768.84, 135, 1)
	event.EohSetFootSoundId(1, 1)
	helper_0c95681b(135)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(0, -1)
	event.EohSetFootSoundId(1, -1)
	event.SetStatus(1, global0, 8, 0)
	event.SetStatus(1, global1, 8, 0)
	event.CmrsInit()
	event.CmrsSetPos(-350.28, 3.09, -880.0)
	event.CmrsSetRef(-237.75, 35.02, -880.0)
	event.ObjsSetPos(3, -246.0, 0.0, -880.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "おーい", 4)
	event.MesMake_2(0, "Hallooo!")
	helper_8834eba9(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-269.42, 43.82, -641.43)
	event.CmrsSetRef(-355.67, 8.13, -699.39)
	event.ObjsSetPos(0, -424.81, 0.0, -640.72)
	event.ObjsReference(0, -354.91, 0.0, -694.75, 1)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 1)
	event.ObjsSetPos(1, -399.05, 0.0, -634.81)
	event.ObjsReference(1, -359.19, 0.0, -671.7, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(1, 1)
	event.ObjsSetPos(3, -321.61, 0.0, -694.6)
	event.ObjsSetRot(3, 0.0, -1.61, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsMove(0, -354.91, 0.0, -694.75, 45)
	event.ObjsRotDelay(0, 45)
	event.ObjsRotation(0, 0.0, 1.16, 0.0, 5)
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(1, -359.19, 0.0, -671.7, 60)
	event.ObjsRotDelay(1, 60)
	event.ObjsRotation(1, 0.0, 1.87, 0.0, 5)
	event.ObjsMotionDelay(1, 65)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(
		0,
		"Oh, ihr habt ein paar Geosteine\ngefunden.<page>Bauen wir den Wald mit\ndem Schreinerium wieder auf!"
	)
	helper_8834eba9(0, -1, 7, 341, 208)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Kommt mit.")
	helper_8834eba9(0, -1, 8, 341, 208)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetFootSoundId(4, 1)
	event.ObjsSetMotion(3, "歩き２")
	event.ObjsReference(3, -306.48, 0.0, -624.02, 45)
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsMove(3, -306.48, 0.0, -624.02, 90)
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsReference(0, -305.78, 0.0, -632.54, 8)
	helper_0c95681b(8)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsMove(0, -305.78, 0.0, -632.54, 45)
	helper_0c95681b(22)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, -351.88, 0.0, -630.2, 30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(1, -351.88, 0.0, -630.2, 45)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_2c5f8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0c95681b(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CmrsSetPos(-625.66, 104.24, -868.06)
	event.CmrsSetRef(-903.96, 23.48, -831.72)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -1023.6, 0.0, -838.96)
	event.ObjsSetRot(0, 0.0, 1.58, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMove(0, -778.4, 0.0, -836.7, 60)
	event.CmrsMove2(-625.66, 104.24, -868.06, -778.4, 20.0, -836.7, 48, 2, 0.4)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_453b4()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(207) or flag
	if flag == 0 then
		if vm.wait() then
			return skip(1)
		end
		event.LoadScript("s02/s02b_1.stb", 501)
		return
	end
end

--- Helper function.
local function helper_2c170()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	event.CmrsInit()
	event.CmrsSetPos(-971.07, 66.21, -121.97)
	event.CmrsSetRef(-826.79, 21.3, 58.4)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -949.3, 0.0, 34.7)
	event.ObjsSetRot(0, 0.0, 1.36, 0.0)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, -806.69, 0.0, 85.01, 60)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_26e50()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
end

--- Helper function.
local function helper_26d64()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
end

--- Helper function.
local function helper_29970()
	local flag: s32 = 0
	local time: f32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_97594088()
			end
			if at <= 2 then
				helper_26e50()
				helper_2ddedb3b(1)
			end
			if at <= 3 then
				helper_0c95681b(10)
			end
			if at <= 4 then
				helper_075f4942()
				helper_0c95681b(15)
			end
			if at <= 5 then
				helper_0c95681b(15)
			end
			if at <= 6 then
				helper_0c95681b(40)
			end
			if at <= 7 then
				helper_0c95681b(10)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		helper_68811019(-130.0, 0.0, -366.0, vm.f32(-1.57))
		helper_075f4942()
		helper_26d64()
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.CmrsInit()
		event.SndSeStop(var2, 0)
		event.EsmClear()
		event.EohSetPos(1, 1.3, 8.0, 700.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(7, 0.0, 0.0, 0.0)
		event.EohSetShow(9, 1)
		event.CharaActive(1, 0)
		helper_68811019(-130.0, 0.0, -366.0, vm.f32(-1.57))
		event.SetCameraRef(-130.0, 30.0, -366.0)
		event.SetCameraPos(-270.0, 40.0, -366.0)
		flag = event.GetFlag(30) or flag
		if flag == 0 then
			helper_075f4942()
		end
		helper_26d64()
		event.SetFadeIn(15)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFlag(30, 0)
	helper_97594088()
	if vm.skipping() then
		return skip(2)
	end
	helper_26e50()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var2
	event.SndSePlay(var2, 0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 6)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CharaActive(0, 0)
	time = event.GetTime() or time
	if time > 0.0 and time < 5.5 then
		event.EohSetShadow(0, 0)
	end
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 1.3, 8.0, 500.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncObj(9, "p01_shadow-0")
	event.EohSetShow(9, 0)
	event.EohSyncObj(2, "p01_train01", "train08-m6")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "train08-m7")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "train10-m18")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "train10-m19")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_train01", "train10-m6")
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "train10-m7")
	event.ObjsSyncObj(7, 7)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsInit()
	event.CmrsSetPos(-185.19, 68.62, 1049.53)
	event.CmrsSetRef(140.3, 63.52, 109.43)
	event.SetFadeIn(30)
	event.InitDramaScene()
	event.ObjsMove2(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	helper_2ddedb3b(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	helper_075f4942()
	event.SetFlag(30, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CmrsSetPos(-254.85, 60.24, -455.84)
	event.CmrsSetRef(-89.19, 67.53, -382.63)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -40.0, 45.6, -366.0)
	event.ObjsSetRot(0, 0.0, -1.56, 0.0)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(5)
	end
	var3 = event.GetSndId(2) or var3
	event.SndSePlay(var3, 106)
	event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, 1.5, 0.0, 30)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "走り", 0, -1.0, 1)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -68.89, 43.64, -366.0, 10)
	event.ObjsMove(0, -131.89, 0.0, -366.0, 30)
	helper_0c95681b(40)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_28590()
	local var0: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_26e50()
			helper_2ddedb3b(1)
		end
		if at <= 2 then
			helper_0c95681b(10)
		end
		if at <= 3 then
			helper_0c95681b(30)
		end
		if at <= 4 then
			helper_0c95681b(20)
		end
		if at <= 5 then
			helper_2ddedb3b(0)
		end
		if at <= 6 then
			helper_0c95681b(10)
		end
		helper_68811019(-130.0, 0.0, -365.0, vm.f32(-1.57))
		helper_26d64()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	helper_26e50()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	time = event.GetTime() or time
	if time > 0.0 and time < 5.5 then
		event.EohSetShadow(0, 0)
	end
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 1.3, 8.0, 500.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_shadow-0")
	event.EohSetShow(6, 0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-185.19, 68.62, 1049.53)
	event.CmrsSetRef(140.3, 63.52, 109.43)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_2ddedb3b(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-254.85, 60.24, -455.84)
	event.CmrsSetRef(-89.19, 67.53, -382.63)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -20.0, 40.0, -365.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	var5 = event.GetSndId(2) or var5
	event.SndSePlay(var5, 92)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -130.0, 0.0, -365.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(6, 1)
	event.CharaActive(0)
	helper_68811019(-130.0, 0.0, -365.0, vm.f32(-1.57))
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.SetCameraRef(-130.0, 30.0, -366.0)
	event.SetCameraPos(-270.0, 40.0, -366.0)
	helper_26d64()
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_26f3c()
	local var0: any = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_0c95681b(30)
			end
			if at <= 2 then
				helper_0c95681b(30)
			end
			return 1
		end
		var6 = var6 + 1
		return 0
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	var0 = helper_d14df93d(5, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.ObjsSetPos(0, -936.47, 0.0, -23.84)
		event.ObjsSetRot(0, 0.0, -1.65, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsInit()
		event.CmrsSetPos(-751.82, 79.08, -27.15)
		event.CmrsSetRef(-928.2, 36.53, -26.64)
		flag = event.GetFlag(207) or flag
		flag_2 = event.GetFlag(208) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.BgmLoadCancel()
		end
		event.ObjsMove(0, -1142.09, 0.0, -28.24, 60)
		event.CmrsMove(-751.82, 79.08, -27.15, -921.16, 65.58, -20.12, 60)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.sin(vm.f32(1.57))))
	var5 = vm.f32(var5 + vm.f32(30.0 * vm.cos(vm.f32(1.57))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 1.57, 0.0, 15)
	event.ObjsMove(0, var3, var4, var5, 45)
	var6 = 0
	while var6 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		event.CmrsSetRef(var3, var4 + 30.0, var5)
		if vm.wait() then
			return skip(4)
		end
		var6 = var6 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_27a44()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local angle: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_0c95681b(30)
			end
			if at <= 2 then
				helper_0c95681b(30)
			end
			return 1
		end
		var8 = var8 + 1
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	var0 = helper_d14df93d(5, 57)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -836.17, 0.0, -823.5)
		event.ObjsSetRot(0, 0.0, -1.66, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsInit()
		event.CmrsSetPos(-668.11, 97.09, -886.72)
		event.CmrsSetRef(-839.94, 44.81, -838.79)
		event.ObjsMove(0, -1044.71, 0.0, -836.63, 60)
		event.CmrsMove(-668.11, 97.09, -886.72, -881.32, 61.14, -861.93, 60)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き", 4)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	angle = vm.f32(vm.f32(3.1415927) + var5)
	angle = event.AngleLimit(angle) or angle
	angle = vm.f32(1.5707964)
	var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(angle)))
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(angle)))
	event.ObjsRotation(0, var4, angle, var6, 15)
	event.ObjsMove(0, var1, var2, var3, 45)
	var8 = 0
	while var8 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1, var2 + 30.0, var3)
		if vm.wait() then
			return skip(4)
		end
		var8 = var8 + 1
	end
	return 0
end

--- Helper function.
local function helper_2cafc()
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2c5f8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetStageId(1)
	event.GotoMenu(3, 1)
	if vm.wait() then
		return skip(2)
	end
	do
		local _, _, out3, _ = event.GetMenuParam_4()
		var2 = out3 or var2
	end
	if vm.wait() then
		return skip(3)
	end
	if var2 == 0 then
		helper_2c5f8()
		if vm.skipping() then
			return skip(4)
		end
	else
		if var2 == 6 then
			event.MapJump(-1, "s05", 100)
			if vm.wait() then
				return skip(5)
			end
			return
		end
		flag = event.GetFlag(212) or flag
		if var2 == 2 and flag == 0 or var2 == 14 then
			event.BgmLoadCancel()
		end
		event.GotoDng(1, var2, 1010)
	end
end

--- Helper function.
local function helper_1d000()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ecb662ce(0, 1)
			return 0
		end
		if at <= 3 then
			helper_0c95681b(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_ecb662ce(0, 4)
	event.MesMake_2(0, "Hineingehen\nVerlassen")
	var0 = helper_c776923d(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_ecb662ce(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_0c95681b(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_0c95681b(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1d3ac(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Die Welt der Bilder ist gro[UNI00df].\nMalen zu lernen mag ein Leben\ndauern, doch es ist die Zeit wert."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, wie l[UNI00e4]uft's?\nBei mir l[UNI00e4]uft's super!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Ich bete, dass die Welt ab\nheute ewigen Frieden genie[UNI00df]t.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Mir machst du nichts vor. Ich\nwei[UNI00df], dass du alle m[UNI00f6]glichen tollen\nSachen gemacht hast. Erz[UNI00e4]hl mal!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
end

--- Helper function.
local function helper_1f770(arg0: s32, arg1: s32)
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
local function helper_20bc8(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_0ba263f7(1)
		helper_1f770(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_0ba263f7(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1f770(arg0, argc)
	end
end

--- Helper function.
local function helper_20e70(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0c95681b(30)
		end
		helper_20bc8(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_20bc8(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1fa64(arg0: s32)
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
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
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
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(
			arg0,
			"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
		)
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_200dc(arg0: s32)
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
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return helper_1fa64(arg0)
		end
		if at <= 5 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		return helper_1fa64(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
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
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_1fa64(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_ecb662ce(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
		event.SetMesDrawspeed(arg0, 0)
		helper_8834eba9(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_ecb662ce(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
	end
	if now_map_no == 22 then
		helper_85ab2618(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_8834eba9(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_1fa64(arg0)
end

--- Helper function.
local function helper_1e6f4()
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
		event.MesMake_2(3, "Tolle Arbeit! Menschen\nsind doch nicht so nutzlos!<page>Ich hatte Unrecht!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Das ist es. Es ist fast zu Ende.\nWir m[UNI00fc]ssen ihn nur besiegen.<page>Dann kann die Welt wieder\naufleben."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ich glaube, ich wei[UNI00df], wie es Griffon\ngeht, aber trotzdem kann ich ihm nie\nverzeihen, was er getan hat."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Bringe den Garten wieder in seinen\nalten Zustand und enth[UNI00fc]lle Griffons -\nich meine Sirus' - Geheimnis."
		)
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			'Was meint sie mit "Sirus\' Erinnerungen"?\nWir m[UNI00fc]ssen wohl in den Palast,\num es herauszufinden.'
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Griffon kommt davon, wenn wir nur\nherumstehen. Schnell, zum Mondblumen-Palast!")
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(
			3,
			"Wir haben wohl alle Edelsteine.\nJetzt m[UNI00fc]ssen wir schnell nach\nKazarov Stonehenge."
		)
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Egal, was hier los ist - wir brauchen\ndie Edelsteine, bevor es\nzu sp[UNI00e4]t ist.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "In diesem Palast fing alles an, was?\nNa egal - auf in den Garten.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Wir sollten lieber bald zum Mond-\nlabor zur[UNI00fc]ckkehren. Sie k[UNI00f6]nnten den\nIxion schon fertig gestellt haben."
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Wir m[UNI00fc]ssen uns endlich gegen\nGriffon wehren. Auf zum\nPaznos-St[UNI00fc]tzpunkt.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Steh nicht nur rum!\nWir m[UNI00fc]ssen Monica retten, schnell!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Wei[UNI00df]t du noch? Galen Agaris hat gesagt, wenn\nman das Feuerhorn bl[UNI00e4]st, [UNI00f6]ffnet\nsich der Weg."
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Steh nicht nur rum!\nWir m[UNI00fc]ssen Monica retten, schnell!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Muss diese Feuer-B[UNI00f6]e erledigen.<page>Sie ist also am Gipfel des\nGundorbergs, ja?")
		return
	end
	event.MesMake_2(
		3,
		"Wenn wir nur warten,\n[UNI00e4]ndert sich nichts.<page>Es muss Orte geben, an\ndenen wir noch nicht waren."
	)
end

--- Helper function.
local function helper_20fa4(arg0: s32, arg1: s32)
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
				helper_ecb662ce(3, 1)
				helper_1d3ac(3, argc)
				var25 = -1
				helper_965e9542(3, var25, 3, 256, 208)
				helper_ecb662ce(1, 8)
				helper_965e9542(1, 1, 1, 0, 0)
				helper_ecb662ce(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_c776923d(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_0ba263f7(3)
				helper_0c95681b(30)
			end
			helper_20bc8(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_ecb662ce(3, 8)
				helper_8834eba9(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_8834eba9(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_20bc8(arg0, arg1)
				helper_20e70(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20e70(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20e70(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20e70(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20e70(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20e70(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20e70(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20e70(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20e70(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20e70(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20e70(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20e70(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20e70(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20e70(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20e70(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20e70(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20e70(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20e70(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20e70(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20e70(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20e70(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20e70(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20e70(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e6f4()
			helper_8834eba9(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_20bc8(arg0, arg1)
			helper_0c95681b(30)
		end
		helper_20bc8(arg0, arg1)
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
		helper_ecb662ce(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1d3ac(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_965e9542(3, var25, 3, 256, 208)
		helper_ecb662ce(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_965e9542(1, 1, 1, 0, 0)
		helper_ecb662ce(2, 2)
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
		var24 = helper_c776923d(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_0ba263f7(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_0c95681b(30)
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
				helper_20bc8(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_ecb662ce(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Das geht jetzt nicht. Du musst\nerst Lin zum Leuchtturm bringen!")
			helper_8834eba9(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_ecb662ce(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_8834eba9(3, var25, 9, 0, 0)
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
						event.MesMake_2(3, "Na gut, die Reparaturen\nsind abgeschlossen!")
						helper_8834eba9(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_20bc8(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20e70(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20e70(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_200dc(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20e70(arg0, arg1, 33)
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
						helper_20e70(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20e70(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20e70(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20e70(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20e70(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20e70(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20e70(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20e70(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20e70(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20e70(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20e70(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20e70(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20e70(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20e70(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20e70(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20e70(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20e70(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20e70(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20e70(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20e70(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20e70(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e6f4()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_8834eba9(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_20bc8(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_0c95681b(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_20bc8(arg0, arg1)
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
	helper_20bc8(arg0, arg1)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_25134()
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
				helper_85ab2618(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_c776923d(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_3fe18432(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_20fa4(var17, 1)
		end
		return 0
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
		helper_ecb662ce(0, 1)
		var9 = helper_77f8061a(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "Willst du gehen?")
		helper_85ab2618(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Ja!\nIch will noch etwas bleiben.")
		var11 = helper_c776923d(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "Hrmpf, schnapp sie dir, ja?")
			helper_85ab2618(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_3fe18432(var0, var9, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
		if var11 == 0 then
			return 1
		else
			return 0
		end
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 1 then
		helper_ecb662ce(0, 1)
		event.MesMake_2(0, "Seid vorsichtig da drau[UNI00df]en,\nihr zwei.")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "Wir sind noch nicht bereit ...\nGib mir noch etwas Zeit.")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "Wir sind noch nicht bereit ...\nGib mir noch etwas Zeit.")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "Wir sind noch nicht bereit ...\nGib mir noch etwas Zeit.")
		end
		helper_0e678234(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_20fa4(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_43b40()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_0c95681b(45)
			end
			if at <= 2 then
				helper_f8047a1c(2830010)
			end
			if at <= 3 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 2290.27, 0.0, 1646.13)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(283, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2237)
	var0 = event.SndLoadSound(2237) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e200/e283/")
	event.LoadMes(0, 5, "e283_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e283_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e283_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e283_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e200/e283/e283_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e200/e283/e283_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.EohSetPos(0, -160.79, 0.0, -340.48)
	event.EohSetRot(0, 0.0, 2.9, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 3)
	event.EohSetPos(1, -187.76, 0.0, -348.73)
	event.EohSetRot(1, 0.0, 2.18, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 3)
	event.EohSetPos(2, -143.76, 0.0, -369.25)
	event.EohSetRot(2, 0.0, -1.46, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-254.7, 9.64, -441.04)
	event.CmrsSetRef(-145.97, 41.38, -347.02)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	event.StopBgm(0)
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SndSePlay(var0, 2)
	helper_f8047a1c(2830010)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_2b2e8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_0c95681b(30)
			end
			if at <= 2 then
				helper_2627c()
				helper_97594088()
			end
			if at <= 3 then
				helper_0c95681b(30)
			end
			if at <= 4 then
				helper_2ddedb3b(0)
			end
			if at <= 5 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EsmClear()
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.EohSetShadow(0, 1)
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(2237)
	var0 = event.SndLoadSound(2237) or var0
	event.CharaActive(0, 0)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	helper_2627c()
	helper_97594088()
	if vm.skipping() then
		return skip(3)
	end
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 400.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(1, "p01_shadow-0")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(2, 32)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(3, 33)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(0, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-304.68, 110.91, -288.45)
	event.CmrsSetRef(-158.49, 89.18, -46.7)
	event.SetFadeIn(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(1, 32)
	event.ObjsSetPos(2, 30.0, 20.0, 380.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "ぶしゅー", 6)
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, -30.0, 20.0, 380.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "ぶしゅー", 6)
	event.ObjsMove2(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.SndSePlay(var0, 3)
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_24650()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ecb662ce(0, 1)
			helper_0e678234(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_20fa4(var4, 2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_ecb662ce(0, 1)
		event.MesMake_2(0, "Wenn ich nicht immer\nwas zu tun habe,\nwerde ich unausstehlich.")
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(448) or flag
		if var2 == 4 and flag == 0 then
			event.MesMake_2(
				0,
				"Die Stra[UNI00df]en und Br[UNI00fc]cken sind\nalle kaputt! Was dachtest\ndu denn? Oh Mann ..."
			)
		end
		if var2 == 3 then
			event.MesMake_2(
				0,
				"Du wei[UNI00df]t doch, dass man immer ver-\nsteift, wenn man zu selten trainiert.\nDas gilt f[UNI00fc]r Maschinen auch."
			)
		end
		helper_0e678234(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_20fa4(var4, 2)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_24afc()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ecb662ce(0, 1)
			helper_0e678234(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_20fa4(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_ecb662ce(0, 1)
		event.MesMake_2(
			0,
			"Ich liebe Schwarzpulver-Duft!\nDas ist echt mein Traumjob.<page>Aber mein Boss ist ziemlich\nstur und altmodisch.\nAch, na ja."
		)
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(280) or flag
		if var2 == 2 and flag == 0 then
			event.MesMake_2(0, "Eine Ultima-Bombe, und ein\nFels wie dieser w[UNI00e4]re Staub.")
		end
		flag_2 = event.GetFlag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.MesMake_2(
				0,
				"Sprengungen sind auch kein\nKinderspiel. Ein Fehler, und\ndie ganze Bude st[UNI00fc]rzt ein."
			)
		end
		flag_3 = event.GetFlag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.MesMake_2(
				0,
				"Ich bin vielleicht Sprengmeister,\naber was Reparaturen angeht,\nhab ich zwei linke H[UNI00e4]nde!"
			)
		end
		helper_0e678234(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_20fa4(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_26034()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ecb662ce(0, 1)
			helper_0e678234(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_ecb662ce(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Ich warte hier auf dich.\nHoffentlich geht alles gut.")
	else
		event.MesMake_2(0, "Ich warte hier.\nSchnapp ihn dir.")
	end
	helper_0e678234(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = function()
	event.Initialize()
	helper_45554()
	event.SetCameraPos(-368.0, 50.0, 62.1)
	event.SetCameraRef(-368.0, 30.0, -57.9)
	event.SetCharaPos(0, -368.0, 0.0, -57.9)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetFadeIn(15)
end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_c3fd0843()
			helper_29970()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 5 then
			helper_28590()
		end
	end
	function part2() end
	function landing1()
		event.SetMotion(0, "立ち")
		return part2()
	end
	event.Initialize()
	helper_45554()
	print("start_event--------------------------------------------\n")
	flag = event.GetFlag(31) or flag
	flag_2 = event.GetFlag(254) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		helper_40b08()
		if vm.skipping() then
			return skip(1)
		end
		event.MapJump(-1, "s47", 505)
		return
	end
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -750.0, 0.0, -75.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var4 = event.GetMapType(old_map_no) or var4
		if var4 ~= -1 then
			if var4 == 7 or var4 == 8 then
				helper_2c5f8()
				if vm.skipping() then
					return skip(2)
				end
				event.SetMotion(0, "立ち")
				return
			else
				if old_map_no == 53 then
					helper_453b4()
					if vm.skipping() then
						return skip(3)
					end
					return
				end
				if old_map_no == 0 then
					helper_2c170()
					if vm.skipping() then
						return skip(4)
					end
				else
					var5 = event.GetCnt(1) or var5
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var5 == 2
					then
						helper_c3fd0843()
						event.SetFadeIn(15)
						event.ResetCamera(1, 0.0)
					else
						var6 = event.GetChapter() or var6
						if var6 ~= 6 and var6 ~= 7 then
							helper_29970()
							if vm.skipping() then
								return skip(5)
							end
						else
							helper_28590()
							if vm.skipping() then
								return skip(6)
							end
						end
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesStr(0, 16, "なかみ")
	event.MesMake_2(0, "ここから[文字列１６]ここまで")
	helper_8834eba9(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ab048abf(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_ab048abf(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 209.
script[209] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_26f3c()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.SetFadeOut(0)
		if vm.wait() then
			return skip(2)
		end
		flag = event.GetFlag(208) or flag
		if flag == 0 then
			event.BgmPlayCancel()
		end
		event.MapJump(-1, "g01")
		return
	end
end

--- Program 210.
script[210] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2cafc()
		end
	end
	local t0 = helper_27a44()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		helper_2cafc()
		if vm.skipping() then
			return skip(2)
		end
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
			helper_9f92098d()
		end
		if at <= 6 then
			helper_07ea621b(1)
		end
		if at <= 7 then
			helper_5be1f3fa()
		end
	end
	var0 = helper_1d000()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 2)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_9f92098d()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_9f92098d()
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
		helper_07ea621b(1)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_5be1f3fa()
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
	helper_535758bd()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 499.
script[499] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29970()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b_1.stb", 501)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b_1.stb", 502)
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b_1.stb", 503)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	helper_45554()
	helper_2c170()
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_43b40()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_2b2e8()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 4 then
			helper_24650()
		end
		if at <= 5 then
			helper_24afc()
		end
		if at <= 6 then
			helper_26034()
		end
	end
	function part2()
		if var0 == 2 then
			helper_24650()
			if vm.skipping() then
				return skip(5)
			end
		end
		if var0 == 13 then
			helper_24afc()
			if vm.skipping() then
				return skip(6)
			end
		end
		if var0 == 301 then
			helper_26034()
			if vm.skipping() then
				return skip(7)
			end
		end
	end
	function landing1()
		helper_2b2e8()
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s04")
		return part2()
	end
	function landing2()
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s04")
		return part2()
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		var1 = helper_25134()
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			helper_43b40()
			if vm.skipping() then
				return skip(2)
			end
			helper_2b2e8()
			if vm.skipping() then
				return skip(3)
			end
			event.GotoMenu(13, 4)
			if vm.wait() then
				return skip(4)
			end
			event.MapJump(-1, "s04")
		end
	end
	return part2()
end

--- Program 12070.
script[12070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b_1.stb", 501)
end

--- Program 12541.
script[12541] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFloorInfo(1, 7, 5, 256)
	helper_40b08()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s47", 505)
end

--- Program 12830.
script[12830] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2b2e8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s04")
	end
	helper_43b40()
	if vm.skipping() then
		return skip(1)
	end
	helper_2b2e8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
