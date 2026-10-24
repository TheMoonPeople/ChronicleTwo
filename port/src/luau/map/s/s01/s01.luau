--!strict
-- map/s/s01/s01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_23a302d6 = require("@lib/event/helper_23a302d6")
local helper_42b7a2cf = require("@lib/event/helper_42b7a2cf")
local helper_46e8aa48 = require("@lib/event/helper_46e8aa48")
local helper_5b643440 = require("@lib/event/helper_5b643440")
local helper_7bc11ce7 = require("@lib/event/helper_7bc11ce7")
local helper_b2a6ae08 = require("@lib/event/helper_b2a6ae08")
local helper_c746120b = require("@lib/event/helper_c746120b")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		event.Initialize()
		event.EohSyncObj(0, "p01_train01")
		event.EohSetPos(0, 0.0, 0.0, -2000.0)
	end
end

--- Helper function.
local function helper_ebc4()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_c746120b(285)
			end
			if at <= 2 then
				helper_c746120b(165)
			end
			if at <= 3 then
				helper_c746120b(90)
			end
			if at <= 4 then
				helper_c746120b(450)
			end
			if at <= 5 then
				helper_c746120b(30)
			end
			if at <= 6 then
				helper_c746120b(90)
			end
			if at <= 7 then
				helper_c746120b(190)
			end
			if at <= 8 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 11 then
			helper_c746120b(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.CmrsReleaseObj()
		event.SetCameraPos(-559.4, 187.73, -249.37)
		event.SetCameraRef(-556.51, 162.33, -127.3)
		event.SetCharaPos(0, -557.84, 132.17, -142.95)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		if vm.wait() then
			return skip(11)
		end
		event.EohSetFootSoundId(0, 0)
		event.StopBgm(0)
		helper_c746120b(4)
		if vm.skipping() then
			return skip(12)
		end
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(201, 1)
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMesWindowMode(0, 7)
	event.LoadMotion(5, "event/e200/e201/e201_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.CmrsSetPos(-560.0, 157.51, -568.46)
	event.CmrsSetRef(-560.0, 157.27, -483.32)
	event.SetFadeIn(30)
	event.InitDramaScene()
	event.EohSyncObj(10, "p01_train01")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 0.0, -24.0, -1000.0)
	event.ObjsSetPos(0, -560.0, 132.17, -500.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, -560.0, 132.17, -300.0, 270)
	helper_c746120b(285)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -300.0)
	event.ObjsMove(0, -560.0, 132.17, -100.0, 255)
	event.CmrsSyncObj(0, 0.0, 25.0, 0.0, 0.55, -1.91, 34.9)
	helper_c746120b(165)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, -1)
	event.CmrsFadeInit()
	event.CmrsFadeOut(90, 200, 200, 200)
	helper_c746120b(90)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsReleaseObj()
	event.CmrsInit()
	event.CmrsSetRef(-567.88, 154.74, -22.62)
	event.CmrsSetAhd(1.68, -0.34, 88.57)
	event.CmrsMoveAhd2(-1.72, -0.34, 88.57, 360, 0, 0.2)
	event.CmrsFadeIn(90, 200, 200, 200)
	helper_c746120b(450)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -200.0)
	event.ObjsMove(0, -560.0, 132.17, -100.0, 120)
	event.CmrsInit()
	event.CmrsSetPos(-785.67, 205.49, 52.24)
	event.CmrsSetRef(-512.83, 162.33, -212.01)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsMove2(-3101.09, 205.49, 1822.12, -512.83, 162.33, -212.01, 210, 0, 0.2)
	helper_c746120b(90)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -100.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_c746120b(190)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_16160()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c746120b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(15)
	event.CmrsSetPos(-564.69, 162.76, -362.47)
	event.CmrsSetRef(-556.95, 162.37, -243.12)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -558.43, 132.37, -264.95)
	event.ObjsSetRot(0, 0.0, 0.13, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, -556.95, 132.37, -243.12, 30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetCamera(0)
end

--- Helper function.
local function helper_16760()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		event.FuncPointShow("", "fc_event_202", 1)
	else
		event.FuncPointShow("", "fc_event_202", 0)
		event.EohSyncObj(0, "p01_train01")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_e52c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b2a6ae08()
		end
		if at <= 2 then
			helper_23a302d6(32)
		end
	end
	event.Initialize()
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -215.0, 12.66, 60.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "走り")
	event.ObjsTexAnime(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, -24.0, -1800.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.SetTime(7.0)
	event.SetTimeStepEnable(1)
	event.CmrsInit()
	event.CmrsSetPos(-746.57, 16.36, 156.44)
	event.CmrsSetRef(-199.21, 142.65, 471.29)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove(-701.67, 16.36, 428.3, -154.32, 142.65, 743.14, 400)
	event.ObjsMove(0, -215.0, 12.66, 1700.0, 460)
	event.ObjsMove(1, 0.0, -24.0, 5000.0, 260)
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(2)
	end
	helper_23a302d6(32)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_12278()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.CharaActive(0, 9)
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(10)
end

--- Helper function.
local function helper_fe20()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(2, 0.0, -24.0, -1000.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(10, "p01_train01", "train06-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p01_train01", "train06-m1")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p01_train01", "train05-m10")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p01_train01", "train05-m11")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p01_train01", "train05-m12")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p01_train01", "train05-m13")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(16, "p01_train01", "train05-m14")
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.EohSyncObj(17, "p01_train01", "train05-m15")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.EohSyncObj(18, "p01_train01", "train05-m16")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.EohSyncObj(19, "p01_train01", "train05-m17")
	event.ObjsInit(19)
	event.ObjsSyncObj(19, 19)
	event.EohSyncObj(20, "p01_train01", "train05-m18")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.EohSyncObj(21, "p01_train01", "train05-m19")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	var0 = 0
	while var0 < 12 do
		event.ObjsRotation(10 + var0, 0.1, 0.0, 0.0, -1)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_123a0()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_12278()
		helper_fe20()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_12278()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.LoadMotion(5, "event/e200/e202/e202_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e200/e202/e202_starbre.gltf", "info", 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 9)
	event.LoadChara(5, "event/e200/e202/e202_train_pika.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncObj(2, "p01_train01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01", "train07-m0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "train07-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "train08-m2")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "train08-m3")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "train08-m7")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_train01", "train08-m6")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p01_train01", "train10-m2")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(22, "p01_train01", "train10-m3")
	event.ObjsInit(22)
	event.ObjsSyncObj(22, 22)
	event.EohSyncObj(23, "p01_train01", "train10-m7")
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.EohSyncObj(24, "p01_train01", "train10-m6")
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	helper_fe20()
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(2, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 2)
	event.LoadMes(0, 5, "event/e200/e202/e202.txt")
end

--- Helper function.
local function helper_1122c(arg0: f32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(2, 0.0, -24.0, -1000.0 + arg0, arg1, 2, 0.4)
end

--- Helper function.
local function helper_11324(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(72)
		end
		if at <= 2 then
			helper_c746120b(20)
		end
		if at <= 3 then
			helper_c746120b(10)
		end
		if at <= 4 then
			helper_c746120b(15)
		end
		if at <= 5 then
			helper_c746120b(30)
		end
		if at <= 6 then
			helper_c746120b(60)
		end
		if at <= 7 then
			helper_c746120b(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSetPos(3, pos_x - 50.0, pos_y, pos_z)
	event.ObjsSetRot(3, 0.0, 0.0, 0.08726647)
	event.ObjsSetRot(5, 0.0, -1.5707964, 0.0)
	event.ObjsSetRot(6, 0.0, 1.5707964, 0.0)
	event.ObjsSetRot(22, 0.0, -1.5707964, 0.0)
	event.ObjsSetRot(9, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetFootSoundId(1, 6)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, -160.36, 2.7, 634.04)
	event.ObjsAddPas(0, -124.87, 2.7, 630.96)
	event.ObjsAddPas(0, -89.31, 4.88, 627.74)
	event.ObjsAddPas(0, -78.59, 9.51, 627.52)
	event.ObjsAddPas(0, -58.26, 12.02, 627.52)
	event.ObjsAddPas(0, -23.27, 22.08, 626.47)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -117.93, 2.01, 644.18)
	event.ObjsAddPas(1, -87.39, 5.06, 643.55)
	event.ObjsAddPas(1, -79.65, 10.25, 643.38)
	event.ObjsAddPas(1, -61.53, 13.02, 643.01)
	event.ObjsAddPas(1, -15.8, 26.38, 642.06)
	event.ObjsStartPas(1)
	helper_c746120b(72)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 4)
	event.EohSetFootSoundId(1, 4)
	event.SndSePlay(arg0, 12)
	event.ObjsRotation(6, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(22, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(9, 0.0, 0.0, 0.0, 30)
	helper_c746120b(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(0, 0.0, 3.03, 0.0, 30)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(4)
	end
	helper_c746120b(15)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 13)
	event.ObjsRotation(3, 0.0, 0.0, 0.0, 30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(arg0, 14)
	event.ObjsMove(3, pos_x, pos_y, pos_z, 60)
	helper_c746120b(60)
	if vm.skipping() then
		return skip(7)
	end
	helper_c746120b(15)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_10848(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			var1 = var1 + 1
			helper_c746120b(30)
		end
		if at <= 2 then
			helper_c746120b(75)
		end
		if at <= 3 then
			helper_c746120b(75)
		end
		if at <= 4 then
			helper_c746120b(150)
		end
		if at <= 5 then
			helper_c746120b(165)
		end
		if at <= 6 then
			helper_c746120b(180)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(3.45, 77.44, 1389.54)
	event.CmrsSetRef(3.0, 63.96, 1261.17)
	var1 = 0
	while var1 < 12 do
		event.ObjsRotation(10 + var1, 0.03, 0.0, 0.0, -1)
		var1 = var1 + 1
	end
	event.SndSePlay(arg0, 15)
	event.ObjsSetPos(2, 0.0, -24.0, 500.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CharaActive(1, 10)
	event.SetCharaPos(10, 1.55, 41.98, 824.64)
	event.SetMotion(10, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(0, 10)
	event.ObjsMove2(2, 0.0, -24.0, 5000.0, 360, 1, 0.7)
	event.SndSePlay(arg0, 16)
	event.CmrsSetPos(-423.7, 77.44, 613.24)
	event.CmrsSetRef(-149.56, 63.96, 588.35)
	helper_c746120b(75)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(3.45, 77.44, 1389.54)
	event.CmrsSetRef(3.0, 63.96, 1261.17)
	event.CmrsMove2(4.3, 77.44, 1631.73, 3.0, 63.96, 1261.17, 75, 2, 0.2)
	helper_c746120b(75)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-741.43, 330.34, 349.51)
	event.CmrsSetRef(-180.96, 187.05, 261.6)
	event.CmrsMove2(-741.43, 330.34, 349.51, -335.86, 187.05, 767.89, 90, 2, 0.4)
	helper_c746120b(150)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.CmrsFadeDelay(135)
	event.CmrsFadeOut(30, 0.0, 0.0)
	event.CmrsMove2(-1416.81, 608.29, -321.97, -333.28, 187.05, 759.45, 120, 0, 0.4)
	helper_c746120b(165)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	helper_c746120b(180)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_12050(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_120ac(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12108(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12164(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_121c0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1221c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_13074()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_123a0()
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_c746120b(90)
			end
			if at <= 3 then
				helper_c746120b(150)
			end
			if at <= 4 then
				helper_42b7a2cf(2020010)
			end
			if at <= 5 then
				helper_42b7a2cf(2020020)
			end
			if at <= 6 then
				helper_c746120b(15)
			end
			if at <= 7 then
				helper_42b7a2cf(2020030)
			end
			if at <= 8 then
				helper_c746120b(10)
			end
			if at <= 9 then
				helper_1122c(2200.0, 220)
				helper_c746120b(50)
			end
			if at <= 10 then
				helper_c746120b(70)
			end
			if at <= 11 then
				helper_c746120b(120)
			end
			if at <= 12 then
				helper_c746120b(60)
			end
			if at <= 13 then
				helper_c746120b(40)
			end
			if at <= 14 then
				pos_z = vm.f32(pos_z + vm.f32(-517.642))
				helper_c746120b(30)
			end
			if at <= 15 then
				helper_c746120b(30)
			end
			if at <= 16 then
				helper_c746120b(15)
			end
			if at <= 17 then
				helper_c746120b(75)
			end
			if at <= 18 then
				helper_42b7a2cf(2020040)
			end
			if at <= 19 then
				helper_5b643440(0)
			end
			if at <= 20 then
				helper_42b7a2cf(2020050)
			end
			if at <= 21 then
				helper_42b7a2cf(2020055)
			end
			if at <= 22 then
				helper_42b7a2cf(2020060)
			end
			if at <= 23 then
				helper_42b7a2cf(2020065)
			end
			if at <= 24 then
				helper_5b643440(1)
			end
			if at <= 25 then
				helper_11324(var0)
			end
			if at <= 26 then
				helper_10848(var0)
			end
			helper_12050(var0)
			helper_120ac(var0)
			helper_12108(var0)
			helper_12164(var0)
			helper_121c0(var0)
			helper_1221c(var0)
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
		helper_12278()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.SndSeStop(var0, 7)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		helper_12278()
		event.EsmClear()
		event.ResetCamera(1, 0.0, 20.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(202, 1)
	event.Initialize()
	var0 = event.SndLoadSound(1837) or var0
	helper_123a0()
	event.EohSetFootSoundId(0, 0)
	event.StopBgm(0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(1, 0)
	event.CmrsSetPos(-339.31, 136.54, 364.85)
	event.CmrsSetRef(-238.55, 35.08, 513.89)
	event.ObjsSetPos(0, -198.33, 13.59, 420.19)
	event.ObjsSetRot(0, 0.0, -0.35, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ぼうぜん顔")
	event.ObjsTexAnime(0, 1, "つうじょう目パチ")
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 160)
	event.ObjsAddPas(0, -198.33, 13.59, 420.19)
	event.ObjsAddPas(0, -203.12, 13.59, 502.05)
	event.ObjsAddPas(0, -216.28, 13.59, 545.08)
	event.ObjsAddPas(0, -238.62, 13.59, 586.39)
	event.ObjsStartPas(0)
	event.EohSetFootSoundId(0, 15)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 2)
	helper_c746120b(90)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CmrsSetPos(-157.69, 69.09, 657.85)
	event.CmrsSetRef(-309.71, 39.39, 635.31)
	event.ObjsSetPos(0, -218.73, 13.59, 644.79)
	event.ObjsSetRot(0, 0.0, -1.67, 0.0)
	event.ObjsMove(0, -301.77, 13.77, 637.45, 60)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-157.69, 69.09, 657.85, -309.71, 39.39, 635.31)
	event.CmrsAddPas(-182.29, 46.57, 654.2, -309.71, 39.39, 635.31)
	event.CmrsAddPas(-226.21, 39.3, 647.69, -309.71, 39.39, 635.31)
	event.CmrsStartPas()
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち", 0)
	helper_c746120b(150)
	if vm.skipping() then
		return skip(4)
	end
	helper_42b7a2cf(2020010)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-325.02, 31.34, 616.64)
	event.CmrsSetRef(-305.34, 35.79, 635.58)
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	helper_42b7a2cf(2020020)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.76, 40.57, 633.22)
	event.CmrsSetRef(-302.99, 37.72, 637.65)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目～うれし目")
	event.ObjsTexAnime(0, 1, "半口～うれし開き")
	helper_c746120b(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(0, 1, "きらきら目")
	event.CmrsMove2(-326.11, 40.57, 634.32, -302.99, 37.72, 637.65, 90, 2, 0.4)
	helper_42b7a2cf(2020030)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "まえ向き～左むき")
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(0, "振り返る", 6, -1.0, 1)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsInit()
	helper_1122c(2200.0, 220)
	event.CmrsSetPos(-331.99, 42.11, 682.27)
	event.CmrsSetRef(-281.67, 40.37, 620.78)
	event.SndSePlay(var0, 8)
	helper_c746120b(50)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "振り返るL", 6, -1.0, 1)
	helper_c746120b(70)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "列車を見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "列車を見るL", 0)
	helper_c746120b(120)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-704.28, 74.53, 644.02)
	event.CmrsSetRef(-229.0, 60.03, 630.45)
	event.EohSetShadow(0, 0)
	event.EohSetShadow(1, 0)
	helper_c746120b(60)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-272.98, 32.08, 611.38)
	event.CmrsSetRef(-292.01, 32.94, 630.57)
	event.ObjsSetRot(0, 0.0, 1.93, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsSetMotion(0, "キョロキョロ", 4, -1.0, 1)
	helper_c746120b(40)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.CharaActive(1, 9)
	event.CmrsSetPos(-344.7, 43.98, 674.78)
	event.CmrsSetRef(-270.62, 44.19, 558.35)
	event.ObjsSetRot(0, 0.0, 1.69, 0.0)
	event.ObjsSetPos(1, -57.93, 11.86, 130.81)
	event.ObjsSetRot(1, 0.0, -1.55, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_z = vm.f32(pos_z + vm.f32(-517.642))
	event.ObjsSetPos(4, pos_x - 50.0, pos_y, pos_z)
	event.ObjsSetRot(4, 0.0, 0.0, 0.08726647)
	event.SndSePlay(var0, 9)
	event.ObjsRotation(8, 0.0, -1.57, 0.0, 30)
	event.ObjsRotation(7, 0.0, 1.57, 0.0, 30)
	event.ObjsRotation(24, 0.0, -1.57, 0.0, 30)
	event.ObjsRotation(23, 0.0, 1.57, 0.0, 30)
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 0)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_c746120b(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 15)
	event.ObjsAddPas(1, -58.2, 12.83, 120.56)
	event.ObjsAddPas(1, -71.49, 12.83, 120.23)
	event.ObjsStartPas(1)
	helper_c746120b(15)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetPos(4, pos_x, pos_y, pos_z)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.ObjsSetRot(24, 0.0, 0.0, 0.0)
	event.ObjsSetRot(23, 0.0, 0.0, 0.0)
	event.CharaActive(1, 0)
	event.CharaActive(1, 9)
	event.CmrsSetPos(-429.29, 148.18, 653.31)
	event.CmrsSetRef(-322.93, 59.6, 619.28)
	event.ObjsSetRot(0, 0.0, 2.65, 0.0)
	event.ObjsSetPos(1, -223.19, 13.78, 510.23)
	event.ObjsSetRot(1, 0.0, -0.5, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, -268.59, 13.78, 585.68, 75)
	helper_c746120b(75)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(-291.41, 39.19, 607.31)
	event.CmrsSetRef(-299.71, 35.93, 634.94)
	event.EohSetShadow(0, 1)
	event.EohSetShadow(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "きらきら目")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(2020040)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_5b643440(0)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-315.4, 36.86, 675.88)
	event.CmrsSetRef(-291.69, 35.93, 632.9)
	event.ObjsSetRot(0, 0.0, 2.29, 0.0)
	event.ObjsSetPos(1, -271.9, 13.78, 616.69)
	event.ObjsSetRot(1, 0.0, -0.98, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "腰に手", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(2020050)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(2020055)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "乗れ", 6)
	event.ObjsNextMotion(1, "乗れL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(2020060)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(2020065)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_5b643440(1)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-264.17, 27.45, 662.14)
	event.CmrsSetRef(-203.38, 37.55, 662.68)
	event.ObjsSetPos(0, -269.3, 13.77, 637.92)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetPos(1, -273.23, 13.77, 651.56)
	event.ObjsSetRot(1, 0.0, 1.44, 0.0)
	helper_11324(var0)
	if vm.skipping() then
		return skip(26)
	end
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	helper_10848(var0)
	if vm.skipping() then
		return skip(27)
	end
	helper_12050(var0)
	helper_120ac(var0)
	helper_12108(var0)
	helper_12164(var0)
	helper_121c0(var0)
	helper_1221c(var0)
	return part2()
end

--- Helper function.
local function helper_16508()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_16160()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetStageId(0)
	event.GotoMenu(3, 0)
	if vm.wait() then
		return skip(2)
	end
	do
		local _, _, out3, _ = event.GetMenuParam_4()
		var2 = out3 or var2
	end
	if var2 == 0 then
		event.MapJump(-1, "d01e01")
		if vm.wait() then
			return skip(3)
		end
	elseif var2 == 8 then
		helper_16160()
		if vm.skipping() then
			return skip(4)
		end
	else
		event.GotoDng(0, var2, 1010)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_16160()
		end
		helper_16760()
	end
	program_99()
	flag = event.GetFlag(201) or flag
	if flag == 0 then
		event.SetFloorInfo(0, 8, 7, 1)
		event.SetFloorInfo(0, 8, 5, 2)
		helper_ebc4()
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_16160()
		if vm.skipping() then
			return skip(2)
		end
	end
	helper_16760()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e52c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(30, 255.0, 255.0, 255.0)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02")
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13074()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.MapJump(-1, "s08", 501)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_13074()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_16760()
	end
	helper_0c718064(2)
	helper_ebc4()
	if vm.skipping() then
		return skip(1)
	end
	helper_16760()
end

--- Program 600.
script[600] = function()
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_c746120b(15)
			end
			if at <= 2 then
				helper_c746120b(30)
			end
			if at <= 3 then
				helper_16508()
			end
			return 1
		end
		var5 = var5 + 1
		return 0
	end
	event.Initialize()
	event.GetMesWindowMode(0)
	event.SetMesWindowMode(0, 5)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	event.MesMake_2(0, "『地下水道』に移動しますか？")
	var1 = helper_7bc11ce7(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.CmrsSetPos(-637.75, 234.47, 94.15)
		event.CmrsSetRef(-573.29, 154.14, -234.77)
		event.ObjsSetPos(0, -571.45, 132.37, -243.31)
		event.ObjsSetRot(0, 0.0, -3.14, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsMove(-637.75, 234.47, 94.15, -561.56, 145.42, -381.61, 45)
		event.ObjsMove(0, -570.49, 132.37, -362.93, 45)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(3)
		end
		helper_16508()
		if vm.skipping() then
			return skip(4)
		end
		return 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.sin(0.0)))
	var4 = vm.f32(var4 + vm.f32(30.0 * vm.cos(0.0)))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 15)
	event.ObjsMove(0, var2, var3, var4, 45)
	var5 = 0
	while var5 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.CmrsSetRef(var2, var3 + 30.0, var4)
		if vm.wait() then
			return skip(5)
		end
		var5 = var5 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetMesWindowMode(0, 7)
	return 0
end

--- Program 601.
script[601] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = var3 + 1
			helper_46e8aa48(0, -1, 5, 0, 0)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var0 = vm.f32(var0 + vm.f32(30.0 * vm.sin(vm.f32(3.1415927))))
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.cos(vm.f32(3.1415927))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 15)
	event.ObjsMove(0, var0, var1, var2, 45)
	var3 = 0
	while var3 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		event.CmrsSetRef(var0, var1 + 30.0, var2)
		if vm.wait() then
			return skip(1)
		end
		var3 = var3 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "ここから先は危険だ\n列車で移動しよう。")
	helper_46e8aa48(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13074()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_13074()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 12010.
script[12010] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ebc4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12020.
script[12020] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13074()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_c746120b(30)
		end
	end
	function part2()
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(3)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s08", 501)
		if vm.wait() then
			return skip(4)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_13074()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
