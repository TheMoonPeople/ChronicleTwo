--!strict
-- map/m/m06/m06b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0eb5b2c8 = require("@lib/event/helper_0eb5b2c8")
local helper_12d10110 = require("@lib/event/helper_12d10110")
local helper_4303896d = require("@lib/event/helper_4303896d")
local helper_52c7aaa9 = require("@lib/event/helper_52c7aaa9")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_774ccd87 = require("@lib/event/helper_774ccd87")
local helper_95c04986 = require("@lib/event/helper_95c04986")
local helper_c6c17732 = require("@lib/event/helper_c6c17732")
local helper_d5f09cbd = require("@lib/event/helper_d5f09cbd")
local helper_d764167e = require("@lib/event/helper_d764167e")
local helper_f79a127e = require("@lib/event/helper_f79a127e")

--- Helper function.
local function helper_128c(arg0: s32)
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
local function helper_d01c()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 2 then
				helper_0eb5b2c8()
			end
			if at <= 3 then
				helper_c6c17732()
			end
			if at <= 4 then
				helper_774ccd87(30)
			end
			if at <= 5 then
				var1 = helper_128c(1)
			end
			if at <= 6 then
				helper_774ccd87(vm.i32(294 - var1))
			end
			if at <= 7 then
				helper_d5f09cbd(0, -1, 8, 0, 0)
				helper_95c04986(0, 30)
			end
			if at <= 8 then
				helper_d764167e(0)
				helper_774ccd87(10)
			end
			if at <= 9 then
				helper_f79a127e(10250, 300)
			end
			if at <= 10 then
				helper_c6c17732()
			end
			if at <= 11 then
				helper_4303896d(0)
			end
			if at <= 12 then
				helper_f79a127e(10253, 50)
			end
			if at <= 13 then
				helper_4303896d(0)
			end
			if at <= 14 then
				helper_f79a127e(10256, 90)
			end
			if at <= 15 then
				helper_4303896d(1)
			end
			if at <= 16 then
				helper_f79a127e(10260, 60)
			end
			if at <= 17 then
				helper_4303896d(0)
			end
			if at <= 18 then
				helper_f79a127e(10270, 100)
			end
			if at <= 19 then
				helper_774ccd87(240)
			end
			if at <= 20 then
				helper_c6c17732()
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.CharaActive(1, 0)
		event.StopEnvBgm()
		event.StopBgm(0)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetTimeStepEnable(0)
	event.SetTime(24)
	event.SetProjection(618.0)
	event.CharaActive(0, 0)
	event.StopBgm(0)
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(102)
	event.LoadSound(1204)
	event.PlayEnvBgm(3)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch4.txt")
	var0 = event.SndLoadSound(1204) or var0
	event.LoadChara(5, "event/opening/p1/p1_polcurse.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2201.47, -17.0, 2087.45)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.SetLoadbgFile("event/opening/p1/p1_pierrot.gltf")
	if vm.wait() then
		return skip(2)
	end
	helper_0eb5b2c8()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadChara(5, "event/opening/p1/p1_pierrot.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 2165.77, 0.0, 2124.68)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.LoadChara(5, "event/opening/p1/p1_pierrot.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 2239.05, 0.0, 2124.68)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.LoadChara(5, "event/opening/p1/p1_pierrot.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 2137.24, 0.0, 2163.89)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.LoadChara(5, "event/opening/p1/p1_pierrot.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2270.23, 0.0, 2168.7)
	event.ObjsSetRot(4, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.SetLoadbgFile("")
	event.CmrsInit()
	event.CmrsSetPos(1240.09, 218.04, 1303.05)
	event.CmrsSetRef(1240.68, 300.58, 1344.23)
	event.CmrsFadeInit()
	event.CmrsFadeIn(200)
	helper_c6c17732()
	if vm.skipping() then
		return skip(4)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(120)
	event.PlayBgm(0, -1)
	event.CmrsSetPos(2199.29, 81.59, 2071.01)
	event.CmrsSetRef(2199.55, 105.83, 2098.65)
	event.CmrsMove(2199.29, 29.61, 2071.01, 2199.55, 28.79, 2098.65, 300)
	event.StreamOpen3(1, 10240)
	var1 = helper_128c(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_774ccd87(vm.i32(294 - var1))
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSePlay(0, var0, 26)
	event.ObjsMove(0, 2201.47, 0.0, 2087.45, 6)
	event.SetPakuAnim(0, "口パク")
	event.StreamPlay(1)
	event.MesMake_2(0, 10240)
	helper_d5f09cbd(0, -1, 8, 0, 0)
	helper_95c04986(0, 30)
	if vm.skipping() then
		return skip(8)
	end
	helper_d764167e(0)
	event.SetMesPos(0, 0)
	event.StreamClose(1)
	event.ResetPakuAnim()
	event.CmrsMove2(2198.18, 29.61, 1953.27, 2199.55, 28.79, 2098.65, 120, 2, 0.4)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "杖まわす", 2)
	event.ObjsNextMotion(0, "杖まわすL", 4)
	event.ObjsSePlay(0, var0, 27)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 27)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 27)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 27)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 27)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 27)
	event.SetPakuAnim(0, "口パク")
	helper_f79a127e(10250, 300)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_c6c17732()
	if vm.skipping() then
		return skip(11)
	end
	helper_4303896d(0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "回転", 6)
	event.ObjsNextMotion(0, "回転L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 28)
	event.SetPakuAnim(0, "口パク")
	helper_f79a127e(10253, 50)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_4303896d(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "回転", 6)
	event.ObjsNextMotion(1, "回転L", 4)
	event.ObjsSetMotion(2, "回転", 6)
	event.ObjsNextMotion(2, "回転L", 4)
	event.ObjsSetMotion(3, "回転", 6)
	event.ObjsNextMotion(3, "回転L", 4)
	event.ObjsSetMotion(4, "回転", 6)
	event.ObjsNextMotion(4, "回転L", 4)
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var0, 29)
	event.ObjsSeDelay(1, 15)
	event.ObjsSePlay(1, var0, 30)
	event.SetPakuAnim(0, "口パク")
	helper_f79a127e(10256, 90)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_4303896d(1)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "決め", 6)
	event.ObjsNextMotion(0, "決めL", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 31)
	event.ObjsSetMotion(1, "決め", 6)
	event.ObjsNextMotion(1, "決めL", 4)
	event.ObjsSetMotion(2, "決め", 6)
	event.ObjsNextMotion(2, "決めL", 4)
	event.ObjsSetMotion(3, "決め", 6)
	event.ObjsNextMotion(3, "決めL", 4)
	event.ObjsSetMotion(4, "決め", 6)
	event.ObjsNextMotion(4, "決めL", 4)
	event.SetPakuAnim(0, "口パク")
	helper_f79a127e(10260, 60)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_4303896d(0)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(0, "杖まわす", 2)
	event.ObjsNextMotion(0, "杖まわすL", 4)
	event.ObjsMotionDelay(0, 56)
	event.ObjsSetMotion(0, "回転", 6)
	event.ObjsNextMotion(0, "回転L", 6)
	event.ObjsMotionDelay(0, 16)
	event.ObjsSetMotion(0, "決め", 2)
	event.ObjsNextMotion(0, "決めL", 4)
	helper_f79a127e(10270, 100)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetFootSoundId(1, 2)
	event.EohSetFootSoundId(2, 2)
	event.EohSetFootSoundId(3, -1)
	event.EohSetFootSoundId(4, -1)
	event.ObjsMove(1, 1819.42, 0.0, 1997.77, 120)
	event.ObjsMove(1, 1819.42, -2000.0, 1997.77, 180)
	event.ObjsRotation(1, 0.0, -1.94, 0.0, 10)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(2, 2521.02, 0.0, 1952.71, 120)
	event.ObjsMove(2, 2521.02, -2000.0, 1952.71, 180)
	event.ObjsRotation(2, 0.0, 2.06, 0.0, 10)
	event.ObjsSetMotion(2, "走り")
	event.ObjsMove(3, 1403.9, 0.0, 2435.27, 300)
	event.ObjsRotation(3, 0.0, -1.22, 0.0, 10)
	event.ObjsSetMotion(3, "走り")
	event.ObjsMove(4, 3065.93, 0.0, 2381.79, 300)
	event.ObjsRotation(4, 0.0, 1.34, 0.0, 10)
	event.ObjsSetMotion(4, "走り")
	event.CmrsMove(2198.18, 81.59, 1953.27, 2199.55, 165.83, 2098.65, 300)
	helper_774ccd87(240)
	if vm.skipping() then
		return skip(20)
	end
	event.FadeOutBgm(60)
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_c6c17732()
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

--- Helper function.
local function helper_c084()
	local argc: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(8)
	event.SetCharaPos(8, 2260.0, 0.0, 2233.0)
	event.SetCharaRot(8, 0.0, 3.14, 0.0)
	event.EohSyncChara(31, 8)
	event.EohSetFrameShow(31, "R_yaiba", 0)
	event.EohSetFrameShow(31, "obj11", 0)
	event.EohSetFrameShow(31, "L_yaiba", 0)
	event.EohSetFrameShow(31, "obj4", 0)
	event.SetNearDist(8, 15.0)
	event.CharaActive(9)
	event.SetCharaPos(9, 1522.37, 4.0, 2978.08)
	event.SetCharaRot(9, 0.0, 1.94, 0.0)
	event.SetNearDist(9, 15.0)
	event.CharaActive(10)
	event.SetCharaPos(10, 2100.0, 0.0, 3200.0)
	event.SetCharaRot(10, 0.0, 3.14, 0.0)
	event.SetNearDist(10, 15.0)
	event.CharaActive(11)
	event.SetCharaPos(11, 2713.25, 4.0, 2224.2)
	event.SetCharaRot(11, 0.0, -0.34, 0.0)
	event.SetNearDist(11, 15.0)
	event.CharaActive(12)
	event.SetCharaPos(12, 2575.78, 4.0, 2107.88)
	event.SetCharaRot(12, 0.0, -0.34, 0.0)
	event.SetMotion(12, "ゆれて飛ぶ", 5)
	event.SetNearDist(12, 15.0)
	argc = event.GetItemHaveNum(353) or argc
	flag = event.GetFlag(2) or flag
	flag_2 = event.GetFlag(3) or flag_2
	if flag == 1 and flag_2 == 1 and argc >= 1 then
		event.EohSyncChara(31, 12)
		event.EohSetFrameShow(31, "himonet", 0)
		event.EohSetFrameShow(31, "f2--A01C0S1", 0)
	end
	event.CharaActive(13)
	event.SetCharaPos(13, 1883.89, 0.0, 3101.53)
	event.SetCharaRot(13, 0.0, -0.58, 0.0)
	event.SetMotion(13, "立ち", 4)
	event.SetNearDist(13, 15.0)
	event.CharaActive(14)
	event.SetCharaPos(14, 3067.0, 4.0, 2354.0)
	event.SetCharaRot(14, 0.0, -0.13, 0.0)
	event.SetMotion(14, "立ち", 4)
	event.SetNearDist(14, 15.0)
	event.CharaActive(15)
	event.SetCharaPos(15, 2415.5, 4.0, 2015.94)
	event.SetCharaRot(15, 0.0, -0.74, 0.0)
	event.SetMotion(15, "立ち", 4)
	event.SetNearDist(15, 15.0)
	event.CharaActive(16)
	event.SetCharaPos(16, 2297.96, 0.0, 3228.8)
	event.SetCharaRot(16, 0.0, -2.88, 0.0)
	event.SetMotion(16, "立ち", 4)
	event.SetNearDist(16, 15.0)
	event.CharaActive(17)
	event.SetCharaPos(17, 1817.39, 4.0, 2034.82)
	event.SetCharaRot(17, 0.0, 0.02, 0.0)
	event.SetMotion(17, "立ち", 4)
	event.SetNearDist(17, 15.0)
	event.CharaActive(18)
	event.SetCharaPos(18, 1527.49, 4.0, 2385.88)
	event.SetCharaRot(18, 0.0, 2.06, 0.0)
	event.SetMotion(18, "立ち", 4)
	event.SetNearDist(18, 15.0)
end

--- Helper function.
local function helper_fa78()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_774ccd87(130)
			end
			if at <= 2 then
				helper_c6c17732()
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
		helper_c084()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, -1)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.ObjsInit(2)
		event.ObjsInit(3)
		event.ObjsInit(4)
		event.ObjsInit(5)
		event.ObjsInit(6)
		event.ObjsInit(7)
		event.ObjsInit(8)
		event.ObjsInit(9)
		event.ObjsInit(10)
		event.ObjsInit(11)
		event.CharaActive(9)
		event.CharaActive(10)
		event.CharaActive(11)
		event.SetMotion(0, "立ち", 4)
		helper_c084()
		event.SetCharaPos(0, 2200.51, 0.0, 2062.16)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.CharaActive(0)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.SetCameraPos(2200.87, 39.52, 1932.16)
		event.SetCameraRef(2200.51, 30.0, 2062.16)
		event.ResetCamera(0)
		event.Finish()
		event.LoadSound(1208)
		event.SetFadeIn(10)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetTimeStepEnable(0)
	event.SetTime(24)
	event.SetProjection(618.0)
	event.LoadSound(1207)
	event.CharaActive(8)
	event.SetCharaPos(8, 2260.0, 0.0, 2233.0)
	event.SetCharaRot(8, 0.0, 3.14, 0.0)
	event.SetMotion(8, "立ち")
	event.EohSyncChara(0, 8)
	event.EohSetFrameShow(0, "R_yaiba", 0)
	event.EohSetFrameShow(0, "obj11", 0)
	event.EohSetFrameShow(0, "L_yaiba", 0)
	event.EohSetFrameShow(0, "obj4", 0)
	event.CharaActive(0, 9)
	event.SetCharaPos(9, 1522.37, 4.0, 2978.08)
	event.SetCharaRot(9, 0.0, 1.94, 0.0)
	event.CharaActive(0, 10)
	event.SetCharaPos(10, 2108.0, 0.0, 3231.65)
	event.SetCharaRot(10, 0.0, 3.14, 0.0)
	event.CharaActive(0, 11)
	event.SetCharaPos(11, 2713.25, 4.0, 2224.2)
	event.SetCharaRot(11, 0.0, -0.34, 0.0)
	event.CharaActive(12)
	event.SetCharaPos(12, 2575.78, 4.0, 2107.88)
	event.SetCharaRot(12, 0.0, -0.34, 0.0)
	event.SetMotion(12, "ゆれて飛ぶ", 5)
	event.CharaActive(13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 2356.99, 0.0, 2165.63)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "歩き")
	event.CharaActive(14)
	event.EohSyncChara(2, 14)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 2133.14, 0.0, 1632.04)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "歩き")
	event.CharaActive(15)
	event.EohSyncChara(3, 15)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 2258.71, 0.0, 1849.84)
	event.ObjsSetRot(3, 0.0, -1.1, 0.0)
	event.ObjsSetMotion(3, "立ち")
	event.CharaActive(16)
	event.EohSyncChara(4, 16)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2148.07, 0.0, 1632.04)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "歩き")
	event.CharaActive(17)
	event.EohSyncChara(5, 17)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 2215.91, 0.0, 1567.22)
	event.ObjsSetRot(5, 0.0, 1.34, 0.0)
	event.ObjsSetMotion(5, "会話")
	event.CharaActive(18)
	event.EohSyncChara(6, 18)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 2224.72, 0.0, 1598.72)
	event.ObjsSetRot(6, 0.0, 2.66, 0.0)
	event.ObjsSetMotion(6, "会話")
	event.InitDramaScene()
	event.AssignStack(5)
	event.ClearStack(5)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2181.14, 0.0, 1491.45)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.SetMarker(30)
	event.CmrsInit()
	event.CmrsSetPos(2202.0, 271.0, 1419.0)
	event.CmrsSetRef(2202.0, 271.0, 1806.0)
	event.CmrsMove(2202.0, 52.0, 1419.0, 2202.0, 52.0, 1806.0, 300)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 400)
	event.ObjsAddPas(1, 2356.99, 0.0, 2165.63)
	event.ObjsAddPas(1, 2324.21, 0.0, 2166.75)
	event.ObjsAddPas(1, 2294.14, 0.0, 2152.14)
	event.ObjsAddPas(1, 2273.08, 0.0, 2088.6)
	event.ObjsAddPas(1, 2260.07, 0.0, 2028.27)
	event.ObjsAddPas(1, 2253.46, 0.0, 1967.56)
	event.ObjsAddPas(1, 2247.69, 0.0, 1917.81)
	event.ObjsStartPas(1)
	event.ObjsMove(2, 2133.14, 0.0, 1832.04, 400)
	event.ObjsMove(4, 2148.07, 0.0, 1832.04, 400)
	helper_774ccd87(240)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 160)
	event.ObjsAddPas(0, 2181.14, 0.0, 1491.45)
	event.ObjsAddPas(0, 2190.49, 0.0, 1560.16)
	event.ObjsAddPas(0, 2199.03, 0.0, 1630.16)
	event.ObjsAddPas(0, 2200.51, 0.0, 1690.16)
	event.ObjsAddPas(0, 2200.51, 0.0, 1762.16)
	event.ObjsAddPas(0, 2200.51, 0.0, 1862.16)
	event.ObjsAddPas(0, 2200.51, 0.0, 2062.16)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(0, "走り")
	helper_774ccd87(130)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_11838()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_c6c17732()
			end
			if at <= 2 then
				helper_4303896d(1)
			end
			if at <= 3 then
				helper_774ccd87(10)
			end
			if at <= 4 then
				helper_774ccd87(20)
			end
			if at <= 5 then
				helper_f79a127e(10300, 20)
			end
			if at <= 6 then
				helper_4303896d(1)
			end
			if at <= 7 then
				helper_774ccd87(15)
			end
			if at <= 9 then
				helper_f79a127e(10310, 20)
			end
			if at <= 10 then
				helper_4303896d(1)
			end
			if at <= 11 then
				helper_f79a127e(10320, 50)
			end
			if at <= 12 then
				helper_774ccd87(20)
			end
			if at <= 13 then
				helper_4303896d(1)
			end
			if at <= 14 then
				helper_4303896d(1)
			end
			if at <= 15 then
				helper_4303896d(1)
			end
			if at <= 16 then
				helper_774ccd87(30)
			end
			if at <= 18 then
				helper_f79a127e(10330, 180)
			end
			if at <= 19 then
				helper_4303896d(1)
			end
			if at <= 20 then
				helper_f79a127e(10340, 60)
			end
			if at <= 21 then
				helper_4303896d(1)
			end
			if at <= 22 then
				helper_c6c17732()
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		if at <= 24 then
			helper_c6c17732()
		end
		if at <= 25 then
			helper_12d10110(0, -1, 8, 0, 0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.EohSetFootSoundId(1, -1)
		event.DelExtMotion(0)
		event.DeleteChara(20)
		event.DeleteChara(21)
		event.SetCharaPos(0, 1699.68, 0.0, 2409.28)
		event.SetCharaRot(0, 0.0, -0.67, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.SetMotion(8, "立ち", 4)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.ObjsInit(2)
		event.ObjsInit(3)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.SetCameraPos(1780.41, 40.0, 2307.38)
		event.SetCameraRef(1699.68, 30.0, 2409.28)
		event.ResetCamera(0)
		event.Finish()
		event.LoadSound(1210)
		event.CmrsFadeInit()
		event.CmrsFadeIn(10)
		helper_c6c17732()
		if vm.skipping() then
			return skip(25)
		end
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, 9000030)
		helper_12d10110(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(26)
		end
		event.SetMesWindowMode(0, 7)
		event.SetMesDrawspeed(0, 0)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	event.SetMotion(0, "立ち")
	helper_c6c17732()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1209)
	var0 = event.SndLoadSound(1209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1_5.txt")
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2260.0, 0.0, 2233.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.LoadMotion(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
	event.EohSyncChara(1, 0)
	event.EohSetFootSoundId(1, 2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 2260.0, 0.0, 2160.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "旧・立ち")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsTexAnime(1, 1, "うれし口")
	event.LoadChara(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(2, 20)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 2260.0, 0.0, 2204.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "チケットを渡す", 5)
	event.LoadChara(5, "event/opening/p1/p1_5_boy.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(3, 21)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 2342.84, 0.0, 2225.88)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(3, "ひったくり走り", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, 2260.0, 0.0, 2204.0, 40)
	event.CmrsInit()
	event.CmrsSetPos(2316.32, 55.34, 2082.86)
	event.CmrsSetRef(2255.09, 19.29, 2223.48)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(2)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(2335.02, 32.15, 2225.77)
	event.CmrsSetRef(2254.69, 19.29, 2220.02)
	event.ObjsSetMotion(1, "旧・立ち")
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "チケットを渡す", 6)
	event.ObjsNextMotion(1, "チケットを渡すL", 4)
	event.CharaActive(20)
	event.ObjsSetMotion(2, "チケットを渡す", 6)
	event.ObjsNextMotion(2, "チケットを渡すL", 4)
	event.ObjsSePlay(0, var0, 4)
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク", "うれし口")
	helper_f79a127e(10300, 20)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_4303896d(1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "もぎり", 6)
	event.ObjsNextMotion(0, "もぎりL", 4)
	event.CharaActive(21)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 160)
	event.ObjsAddPas(3, 2342.84, 0.0, 2225.88)
	event.ObjsAddPas(3, 2265.2, 0.0, 2220.33)
	event.ObjsAddPas(3, 2145.86, 0.0, 2211.81)
	event.ObjsAddPas(3, 2114.11, 0.0, 2211.45)
	event.ObjsAddPas(3, 2009.12, 0.0, 2222.65)
	event.ObjsAddPas(3, 1912.97, 0.0, 2256.82)
	event.ObjsAddPas(3, 1821.43, 0.0, 2302.92)
	event.ObjsAddPas(3, 1716.38, 0.0, 2374.01)
	event.ObjsAddPas(3, 1661.85, 0.0, 2462.44)
	event.ObjsStartPas(3)
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(0, 20)
	event.ObjsSetMotion(1, "チケットを取られる", 6)
	event.ObjsNextMotion(1, "チケットを取られるL", 4)
	event.ObjsSePlay(0, var0, 5)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsSetMotion(0, "少年を見る", 6)
	event.ObjsNextMotion(0, "少年を見るL", 4)
	if vm.wait() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク", "口パク大")
	helper_f79a127e(10310, 20)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_4303896d(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク", "口パク大")
	helper_f79a127e(10320, 50)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(2237.85, 16.17, 2229.34)
	event.CmrsSetRef(2261.06, 22.16, 2203.21)
	event.CharaActive(0, 21)
	event.ObjsSetRot(1, 0.0, -1.2, 0.0)
	event.ObjsSetMotion(1, "立ち2", 6, -1.0, 1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "口パク小")
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, 2230.82, 0.0, 2208.96, 10)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "怒り口")
	helper_4303896d(1)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(1699.32, 73.27, 2202.85)
	event.CmrsSetRef(1973.4, 44.98, 2268.33)
	event.CmrsMove(1699.32, 73.27, 2202.85, 1862.18, 11.38, 2316.42, 100)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 100)
	event.ObjsAddPas(1, 2146.75, 0.0, 2208.56)
	event.ObjsAddPas(1, 2052.61, 0.0, 2224.84)
	event.ObjsAddPas(1, 1947.63, 0.0, 2244.64)
	event.ObjsAddPas(1, 1840.32, 0.0, 2274.25)
	event.ObjsAddPas(1, 1724.36, 0.0, 2317.09)
	event.ObjsStartPas(1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "怒り口")
	helper_4303896d(1)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(1834.95, 35.66, 2229.37)
	event.CmrsSetRef(1697.59, 7.87, 2411.67)
	event.ObjsSetPos(1, 1798.09, 0.0, 2277.17)
	event.ObjsSetRot(1, 0.0, -0.67, 0.0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, 1699.68, 0.0, 2409.28, 40)
	event.ObjsMotionDelay(1, 38)
	event.ObjsSetMotion(1, "旧・立ち", 0)
	helper_4303896d(1)
	if vm.skipping() then
		return skip(16)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(1671.69, 14.08, 2425.85)
	event.CmrsSetRef(1699.11, 20.51, 2408.48)
	event.ObjsSetMotion(1, "キョロキョロ立ち", 2)
	event.ObjsNextMotion(1, "立ち2", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "困った目")
	if vm.wait() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク", "怒り口")
	helper_f79a127e(10330, 180)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_4303896d(1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "ため息", 2)
	event.ObjsNextMotion(1, "立ち2", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "閉じる目（半目）")
	event.ObjsTexAnime(1, 1, "ため息")
	helper_f79a127e(10340, 60)
	if vm.skipping() then
		return skip(21)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_1432c()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 110 then
			if at <= 1 then
				helper_c6c17732()
			end
			if at <= 2 then
				helper_f79a127e(10420, 90)
			end
			if at <= 3 then
				helper_774ccd87(10)
			end
			if at <= 4 then
				helper_f79a127e(10430, 60)
			end
			if at <= 5 then
				helper_f79a127e(10440, 40)
			end
			if at <= 6 then
				helper_774ccd87(20)
			end
			if at <= 7 then
				helper_4303896d(4)
			end
			if at <= 8 then
				helper_774ccd87(10)
			end
			if at <= 9 then
				helper_f79a127e(10450, 30)
			end
			if at <= 11 then
				helper_52c7aaa9(1)
			end
			if at <= 12 then
				helper_4303896d(4)
			end
			if at <= 13 then
				helper_4303896d(4)
			end
			if at <= 14 then
				helper_774ccd87(10)
			end
			if at <= 15 then
				helper_4303896d(4)
			end
			if at <= 16 then
				helper_4303896d(5)
			end
			if at <= 17 then
				helper_52c7aaa9(1)
			end
			if at <= 18 then
				helper_4303896d(5)
			end
			if at <= 19 then
				helper_52c7aaa9(1)
			end
			if at <= 20 then
				helper_4303896d(4)
			end
			if at <= 21 then
				helper_4303896d(5)
			end
			if at <= 23 then
				helper_f79a127e(10460, 30)
			end
			if at <= 24 then
				helper_4303896d(4)
			end
			if at <= 25 then
				helper_4303896d(5)
			end
			if at <= 26 then
				helper_4303896d(4)
			end
			if at <= 27 then
				helper_4303896d(5)
			end
			if at <= 28 then
				var0 = helper_128c(1)
			end
			if at <= 29 then
				helper_774ccd87(vm.i32(16 - var0))
			end
			if at <= 30 then
				helper_4303896d(4)
			end
			if at <= 31 then
				helper_4303896d(5)
			end
			if at <= 32 then
				helper_774ccd87(40)
			end
			if at <= 33 then
				helper_4303896d(4)
			end
			if at <= 34 then
				helper_4303896d(5)
			end
			if at <= 36 then
				helper_f79a127e(10470, 40)
			end
			if at <= 37 then
				helper_c6c17732()
			end
			if at <= 38 then
				helper_52c7aaa9(1)
			end
			if at <= 39 then
				helper_774ccd87(12)
			end
			if at <= 40 then
				helper_4303896d(4)
			end
			if at <= 41 then
				helper_4303896d(5)
			end
			if at <= 42 then
				helper_f79a127e(10480, 60)
			end
			if at <= 43 then
				helper_4303896d(4)
			end
			if at <= 44 then
				helper_f79a127e(10490, 164)
			end
			if at <= 45 then
				helper_4303896d(5)
			end
			if at <= 46 then
				helper_4303896d(6)
			end
			if at <= 48 then
				helper_f79a127e(10500, 60)
			end
			if at <= 49 then
				helper_4303896d(4)
			end
			if at <= 50 then
				helper_4303896d(5)
			end
			if at <= 51 then
				helper_4303896d(6)
			end
			if at <= 52 then
				helper_4303896d(5)
			end
			if at <= 53 then
				helper_52c7aaa9(1)
			end
			if at <= 54 then
				helper_774ccd87(30)
			end
			if at <= 55 then
				helper_f79a127e(10520, 120)
			end
			if at <= 56 then
				helper_4303896d(5)
			end
			if at <= 57 then
				helper_4303896d(4)
			end
			if at <= 59 then
				helper_f79a127e(10530, 140)
			end
			if at <= 60 then
				helper_4303896d(4)
			end
			if at <= 61 then
				helper_f79a127e(10540, 30)
			end
			if at <= 62 then
				helper_4303896d(5)
			end
			if at <= 63 then
				helper_f79a127e(10550, 40)
			end
			if at <= 65 then
				helper_f79a127e(10560, 30)
			end
			if at <= 66 then
				helper_4303896d(5)
			end
			if at <= 67 then
				helper_f79a127e(10570, 120)
			end
			if at <= 69 then
				helper_f79a127e(10580, 70)
			end
			if at <= 70 then
				helper_4303896d(5)
			end
			if at <= 71 then
				helper_f79a127e(10590, 80)
			end
			if at <= 72 then
				helper_f79a127e(10600, 56)
			end
			if at <= 73 then
				helper_4303896d(5)
			end
			if at <= 74 then
				helper_774ccd87(20)
			end
			if at <= 75 then
				helper_c6c17732()
			end
			if at <= 76 then
				helper_4303896d(4)
			end
			if at <= 77 then
				helper_774ccd87(20)
			end
			if at <= 78 then
				helper_f79a127e(10610, 60)
			end
			if at <= 79 then
				helper_4303896d(4)
			end
			if at <= 80 then
				helper_4303896d(5)
			end
			if at <= 81 then
				helper_774ccd87(30)
			end
			if at <= 82 then
				helper_4303896d(4)
			end
			if at <= 83 then
				helper_4303896d(5)
			end
			if at <= 84 then
				helper_774ccd87(60)
			end
			if at <= 85 then
				helper_f79a127e(10625, 60)
			end
			if at <= 88 then
				helper_774ccd87(10)
			end
			if at <= 89 then
				helper_774ccd87(4)
			end
			if at <= 90 then
				helper_774ccd87(22)
			end
			if at <= 92 then
				helper_f79a127e(10630, 70)
			end
			if at <= 93 then
				helper_4303896d(4)
			end
			if at <= 94 then
				helper_f79a127e(10640, 180)
			end
			if at <= 95 then
				helper_f79a127e(10650, 180)
			end
			if at <= 97 then
				helper_4303896d(8)
			end
			if at <= 98 then
				helper_774ccd87(30)
			end
			if at <= 99 then
				helper_f79a127e(10660, 30)
			end
			if at <= 100 then
				helper_4303896d(4)
			end
			if at <= 101 then
				helper_4303896d(4)
			end
			if at <= 102 then
				helper_774ccd87(15)
			end
			if at <= 103 then
				helper_4303896d(4)
			end
			if at <= 104 then
				helper_774ccd87(30)
			end
			if at <= 105 then
				helper_774ccd87(30)
			end
			if at <= 106 then
				helper_4303896d(4)
			end
			if at <= 107 then
				helper_4303896d(4)
			end
			if at <= 108 then
				helper_774ccd87(30)
			end
			if at <= 109 then
				helper_c6c17732()
			end
			if vm.skip_end() then
				return skip(111)
			end
			return part2()
		end
		if at <= 111 then
			helper_774ccd87(6)
		end
		if at <= 112 then
			helper_c6c17732()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 10)
		event.SndSeStop(var1, 14)
		event.StreamClose(1)
		event.EohSetFrameShow(7, "himonet", 0)
		event.EohSetFrameShow(7, "f2--A01C0S1", 0)
		event.SetActiveLight(5)
		event.EohSetFootSoundId(4, -1)
		event.DelExtMotion(0)
		event.DeleteChara(20)
		event.DeleteChara(21)
		event.DeleteChara(22)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 2643.5, 0.0, 2316.9)
		event.SetCharaRot(0, 0.0, -2.5, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.StopBgm(0)
		helper_774ccd87(6)
		if vm.skipping() then
			return skip(112)
		end
		event.LoadBgm(102)
		event.PlayBgm(0, -1)
		event.LoadSound(1212)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.SetCameraPos(2721.3, 40.0, 2421.05)
		event.SetCameraRef(2643.5, 30.0, 2316.9)
		event.ResetCamera(0)
		event.Finish()
		event.CmrsFadeInit()
		event.CmrsFadeIn(10)
		helper_c6c17732()
		if vm.skipping() then
			return skip(113)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(1211)
	var1 = event.SndLoadSound(1211) or var1
	event.LoadMes(0, 5, "event/opening/p1/op1_5.txt")
	event.EohSyncChara(0, 11)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
	event.EohSyncChara(4, 0)
	event.EohSetFootSoundId(4, 2)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2698.72, 4.0, 2252.22)
	event.ObjsSetRot(4, 0.0, 2.76, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.LoadChara(5, "event/opening/p1/p1_5_boy.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(5, 20)
	event.EohSetSoundId(5, var1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 2565.75, 4.0, 2081.64)
	event.ObjsSetRot(5, 0.0, -0.36, 0.0)
	event.ObjsSetMotion(5, "立ち")
	event.ObjsTexAnime(5, 0)
	event.LoadChara(5, "event/opening/p1/p1_5_ticket.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(6, 21)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 2732.64, 0.0, 2456.06)
	event.ObjsSetRot(6, 0.0, -3.1, 0.0)
	event.EohSyncChara(7, 12)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSetFrameShow(7, "himonet", 1)
	event.EohSetFrameShow(7, "f2--A01C0S1", 1)
	event.LoadChara(5, "event/opening/p1/p1_5_kirakira.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.EohSyncChara(8, 22)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ObjsSetPos(8, 2199.6, -10000.0, 2617.93)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(8, "キラキラ", 5)
	event.CmrsSetPos(2737.66, 29.82, 2342.9)
	event.CmrsSetRef(2670.87, 30.6, 2198.83)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(4, "会話", 2)
	event.ObjsNextMotion(4, "旧・立ち")
	helper_f79a127e(10420, 90)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(4)
	end
	helper_f79a127e(10430, 60)
	if vm.skipping() then
		return skip(5)
	end
	helper_f79a127e(10440, 40)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(7, "ゆれて飛ぶ", 6)
	event.ObjsMotionWait(7)
	event.ObjsSePlay(7, var1, 6)
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(4, "左を見る", 6)
	event.ObjsNextMotion(4, "左を見るL", 4)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(8)
	end
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(2681.3, 19.18, 2231.06)
	event.CmrsSetRef(2697.39, 26.81, 2253.46)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "真剣目")
	event.ObjsTexAnime(4, 1, "口パク小")
	helper_f79a127e(10450, 30)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetFrameShow(7, "himonet", 0)
	event.EohSetFrameShow(7, "f2--A01C0S1", 0)
	event.CmrsSetPos(2687.25, 43.11, 2323.13)
	event.CmrsSetRef(2666.93, 22.05, 2225.82)
	event.ObjsSetMotion(4, "旧・立ち", 4)
	if vm.wait() then
		return skip(11)
	end
	event.StreamOpen3(1, 10453)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(12)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(4, "走り")
	event.ObjsPosDelay(4, 4)
	event.ObjsMove(4, 2654.2, 4.0, 2208.09, 20)
	event.ObjsRotation(4, 0.0, -2.32, 0.0, 10)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(2536.27, 35.1, 2224.26)
	event.CmrsSetRef(2573.27, 24.36, 2106.49)
	event.ObjsSetPos(4, 2592.3, 4.0, 2180.9)
	event.ObjsMove(4, 2561.21, 4.0, 2137.12, 20)
	event.ObjsRotDelay(4, 14)
	event.ObjsRotation(4, 0.0, 2.76, 0.0, 6)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(4, "旧・立ち")
	event.ObjsMotionDelay(4, 4)
	event.ObjsSetMotion(4, "キョロキョロ立ち", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(15)
	end
	event.StreamClose(1)
	event.CharaActive(20)
	event.ObjsSetMotion(5, "のぞく", 6)
	event.ObjsNextMotion(5, "のぞくL", 4)
	event.ObjsSePlay(5, var1, 7)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(16)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(17)
	end
	event.StreamOpen3(1, 10457)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(18)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(4, "かがみ歩き", 2)
	event.ObjsMotionWait(4)
	event.ObjsSetMotion(5, "ひっこむ", 2)
	event.ObjsMotionWait(5)
	event.ObjsSePlay(5, var1, 8)
	helper_4303896d(5)
	if vm.skipping() then
		return skip(19)
	end
	event.StreamClose(1)
	event.CmrsSetPos(2419.08, 78.17, 2101.42)
	event.CmrsSetRef(2563.13, 24.36, 2105.26)
	event.ObjsRotation(5, 0.0, 1.2, 0.0, 20)
	event.ObjsMove(5, 2592.35, 4.0, 2089.42, 132)
	event.ObjsSetMotion(5, "隠れ移動", 4)
	event.StreamOpen3(1, 10458)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(20)
	end
	event.StreamPlay(1)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(21)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(22)
	end
	event.StreamClose(1)
	event.CmrsSetPos(2507.18, 51.78, 2103.29)
	event.CmrsSetRef(2570.79, 20.66, 2091.49)
	event.ObjsSetPos(4, 2542.51, 4.0, 2091.34)
	event.ObjsSetRot(4, 0.0, 1.68, 0.0)
	event.ObjsSetMotion(4, "指差す", 6)
	event.ObjsNextMotion(4, "指差すL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "真剣目")
	event.ObjsSetMotion(5, "びっくり", 6)
	event.ObjsNextMotion(5, "びっくりL", 4)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "びっくり")
	event.ObjsSePlay(5, var1, 9)
	if vm.wait() then
		return skip(23)
	end
	event.SetPakuAnim(4, "通常口パク", "怒り口")
	helper_f79a127e(10460, 30)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_4303896d(4)
	if vm.skipping() then
		return skip(25)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsSetMotion(4, "走り")
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 30)
	event.ObjsAddPas(4, 2542.51, 4.0, 2091.34)
	event.ObjsAddPas(4, 2552.74, 4.0, 2082.34)
	event.ObjsAddPas(4, 2568.64, 4.0, 2077.28)
	event.ObjsAddPas(4, 2585.94, 4.0, 2080.83)
	event.ObjsAddPas(4, 2604.01, 4.0, 2092.89)
	event.ObjsStartPas(4)
	event.ObjsSetMotion(5, "走り")
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 30)
	event.ObjsAddPas(5, 2592.35, 4.0, 2089.42)
	event.ObjsAddPas(5, 2604.06, 4.0, 2096.07)
	event.ObjsAddPas(5, 2622.54, 4.0, 2108.53)
	event.ObjsAddPas(5, 2625.01, 4.0, 2129.26)
	event.ObjsAddPas(5, 2618.08, 4.0, 2166.48)
	event.ObjsStartPas(5)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(27)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(2732.49, 83.6, 2321.91)
	event.CmrsSetRef(2590.66, 25.91, 2100.32)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 30)
	event.ObjsAddPas(4, 2604.01, 4.0, 2092.89)
	event.ObjsAddPas(4, 2615.74, 4.0, 2103.53)
	event.ObjsAddPas(4, 2626.24, 4.0, 2132.0)
	event.ObjsAddPas(4, 2632.92, 4.0, 2161.62)
	event.ObjsAddPas(4, 2638.67, 4.0, 2195.37)
	event.ObjsAddPas(4, 2646.65, 4.0, 2219.67)
	event.ObjsStartPas(4)
	event.ObjsSetPos(5, 2635.12, 4.0, 2186.57)
	event.ObjsSetRot(5, 0.0, 0.36, 0.0)
	event.ObjsMove(5, 2670.06, 0.0, 2284.25, 30)
	event.StreamOpen3(1, 10467)
	var0 = helper_128c(1)
	if vm.skipping() then
		return skip(29)
	end
	helper_774ccd87(vm.i32(16 - var0))
	if vm.skipping() then
		return skip(30)
	end
	event.StreamPlay(1)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(31)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(2714.93, 21.09, 2355.09)
	event.CmrsSetRef(2657.01, 19.42, 2296.64)
	event.CmrsMove(2769.08, 21.09, 2473.49, 2711.16, 19.42, 2415.04, 40)
	event.ObjsSetPos(4, 2651.53, 0.0, 2235.87)
	event.ObjsMove(4, 2737.55, 0.0, 2429.95, 40)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetPos(5, 2690.44, 0.0, 2333.07)
	event.ObjsMove(5, 2746.37, 0.0, 2453.89, 40)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "走り", 4)
	helper_774ccd87(40)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(2771.11, 13.16, 2406.61)
	event.CmrsSetRef(2657.95, 16.41, 2307.49)
	event.CmrsMove(2771.11, 13.16, 2406.61, 2719.85, 16.41, 2408.57, 30)
	event.CmrsSetPos(2704.73, 13.16, 2468.9)
	event.CmrsSetRef(2719.85, 16.41, 2408.57)
	event.CmrsMove(2704.73, 13.16, 2468.9, 2728.51, 7.46, 2434.51, 15)
	event.ObjsSetPos(4, 2656.59, 0.0, 2298.73)
	event.ObjsSetRot(4, 0.0, 0.5, 0.0)
	event.ObjsSetMotion(4, "つかまえる", 6)
	event.ObjsNextMotion(4, "つかまえるL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "怒り目")
	event.ObjsSePlay(4, var1, 10)
	event.ObjsSetPos(5, 2656.59, 0.0, 2298.73)
	event.ObjsSetRot(5, 0.0, 0.5, 0.0)
	event.ObjsSetMotion(5, "つかまえる", 6)
	event.ObjsNextMotion(5, "つかまえるL", 4)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(34)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(35)
	end
	event.StreamClose(1)
	if vm.wait() then
		return skip(36)
	end
	event.SetPakuAnim(4, "通常口パク", "捕まえた！！")
	helper_f79a127e(10470, 40)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_c6c17732()
	if vm.skipping() then
		return skip(38)
	end
	event.StreamOpen3(1, 10475)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(39)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(4, "自由にする", 6)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "怒り目")
	event.ObjsTexAnime(4, 1, "怒り口")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "口小")
	helper_774ccd87(12)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(2722.6, 24.07, 2468.94)
	event.CmrsSetRef(2723.04, 20.49, 2423.97)
	event.ObjsSetPos(4, 2730.11, 0.0, 2439.37)
	event.ObjsSetRot(4, 0.0, -2.38, 0.0)
	event.ObjsSetMotion(4, "立ち上がる", 6)
	event.ObjsNextMotion(4, "立ち2")
	event.ObjsSetPos(5, 2713.88, 0.0, 2419.11)
	event.ObjsSetRot(5, 0.0, 0.66, 0.0)
	event.ObjsSetMotion(5, "立ち上がる", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsTexAnime(5, 0)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(41)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(42)
	end
	event.StreamClose(1)
	event.ObjsSetMotion(4, "チケット返して", 2)
	event.ObjsNextMotion(4, "チケット返してL", 4)
	event.ObjsTexaDelay(4, 14)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.SetPakuAnim(4, "通常口パク", "怒り口")
	helper_f79a127e(10480, 60)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	helper_4303896d(4)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(2667.51, 26.85, 2432.26)
	event.CmrsSetRef(2719.84, 16.79, 2426.86)
	event.ObjsSetPos(5, 2730.11, 0.0, 2439.37)
	event.ObjsSetRot(5, 0.0, -2.38, 0.0)
	event.ObjsSetPos(6, 2730.11, 0.0, 2439.37)
	event.ObjsSetRot(6, 0.0, -2.38, 0.0)
	event.ObjsSetMotion(5, "チケット返す", 6)
	event.ObjsNextMotion(5, "チケット返すL", 4)
	event.ObjsSePlay(5, var1, 11)
	event.CharaActive(21)
	event.ObjsSetMotion(6, "チケット返す", 6)
	event.ObjsNextMotion(6, "チケット返すL", 4)
	event.SetPakuAnim(5, "口パク")
	helper_f79a127e(10490, 164)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(46)
	end
	helper_4303896d(6)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetMotion(4, "チケット受け取る", 6)
	event.ObjsNextMotion(4, "チケット受け取るL", 4)
	event.ObjsSetMotion(6, "チケット受け取る", 6)
	event.ObjsNextMotion(6, "チケット受け取るL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト目（瞬有）")
	event.ObjsSetMotion(5, "チケット返す戻り", 6)
	event.ObjsNextMotion(5, "下見立ち", 4)
	if vm.wait() then
		return skip(48)
	end
	event.SetPakuAnim(4, "通常口パク", "すまし口")
	helper_f79a127e(10500, 60)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	helper_4303896d(4)
	if vm.skipping() then
		return skip(50)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(51)
	end
	helper_4303896d(6)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotion(5, "うなづく", 6)
	event.ObjsNextMotion(5, "下見立ち", 4)
	helper_4303896d(5)
	if vm.skipping() then
		return skip(53)
	end
	event.StreamOpen3(1, 10510)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(54)
	end
	event.StreamPlay(1)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(55)
	end
	event.StreamClose(1)
	event.ObjsSetMotion(5, "あやまる", 6)
	event.ObjsNextMotion(5, "下見立ち", 4)
	event.SetPakuAnim(5, "口パク")
	helper_f79a127e(10520, 120)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(4, "なやむ", 6)
	event.ObjsNextMotion(4, "なやむL", 4)
	event.ObjsSetMotion(6, "なやむ", 6)
	event.ObjsNextMotion(6, "なやむL", 4)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsMotionDelay(6, 80)
	event.ObjsSetMotion(6, "チケットあげる", 6)
	event.ObjsNextMotion(6, "チケットあげるL", 4)
	event.ObjsMotionDelay(4, 80)
	event.ObjsSetMotion(4, "チケットあげる", 6)
	event.ObjsNextMotion(4, "チケットあげるL", 4)
	event.ObjsTexaDelay(4, 80)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsSeDelay(4, 80)
	event.ObjsSePlay(4, var1, 12)
	if vm.wait() then
		return skip(59)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_f79a127e(10530, 140)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	helper_4303896d(4)
	if vm.skipping() then
		return skip(61)
	end
	event.CmrsSetPos(2733.02, 29.86, 2442.53)
	event.CmrsSetRef(2711.0, 18.68, 2417.08)
	event.CharaActive(0, 0)
	event.ObjsSetMotion(5, "ミンツを見る", 6)
	event.ObjsNextMotion(5, "ミンツを見るL", 4)
	event.SetPakuAnim(5, "口パク")
	helper_f79a127e(10540, 30)
	if vm.skipping() then
		return skip(62)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(63)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_f79a127e(10550, 40)
	if vm.skipping() then
		return skip(64)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "チケットもらう", 6)
	event.ObjsNextMotion(5, "チケットもらうL", 4)
	event.ObjsTexAnime(5, 0)
	event.ObjsSeDelay(5, 10)
	event.ObjsSePlay(5, var1, 13)
	if vm.wait() then
		return skip(65)
	end
	event.SetPakuAnim(5, "口パク", "口小")
	helper_f79a127e(10560, 30)
	if vm.skipping() then
		return skip(66)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(67)
	end
	helper_f79a127e(10570, 120)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "ありがとう", 6)
	event.ObjsNextMotion(5, "ありがとうL", 4)
	event.ObjsSetMotion(6, "ありがとう", 6)
	event.ObjsNextMotion(6, "ありがとうL", 4)
	event.ObjsTexAnime(5, 0)
	if vm.wait() then
		return skip(69)
	end
	event.SetPakuAnim(5, "笑い口パク", "笑い閉じ")
	helper_f79a127e(10580, 70)
	if vm.skipping() then
		return skip(70)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsTexAnime(5, 0)
	event.CmrsSetPos(2667.51, 26.85, 2432.26)
	event.CmrsSetRef(2719.84, 16.79, 2426.86)
	event.CharaActive(0)
	event.ObjsSetMotion(4, "少年見立ち", 4, -1, 1)
	event.CharaActive(0, 21)
	event.ObjsSetPos(5, 2714.52, 0.0, 2418.25)
	event.ObjsSetRot(5, 0.0, 0.66, 0.0)
	event.ObjsSetMotion(5, "立ち", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_f79a127e(10590, 80)
	if vm.skipping() then
		return skip(72)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "うなづく2", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.SetPakuAnim(5, "口パク", "笑み")
	helper_f79a127e(10600, 56)
	if vm.skipping() then
		return skip(73)
	end
	event.ResetPakuAnim()
	helper_4303896d(5)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsSetMotion(5, "走り")
	event.ObjsRotation(5, 0.0, -2.86, 0.0, 10)
	event.ObjsMove(5, 2707.03, 0.0, 2390.53, 20)
	event.ObjsMove(5, 2707.03, -1000.0, 2390.53, 80)
	event.ObjsSetMotion(4, "見送る", 6)
	event.ObjsNextMotion(4, "見送るL", 4)
	event.ObjsTexAnime(4, 0)
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(75)
	end
	event.CmrsMove2(2697.7, 21.72, 2425.94, 2730.54, 21.26, 2439.46, 60, 0, 0.2)
	helper_c6c17732()
	if vm.skipping() then
		return skip(76)
	end
	helper_4303896d(4)
	if vm.skipping() then
		return skip(77)
	end
	event.ObjsSetMotion(4, "ため息", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "閉じる目（半目）２")
	event.ObjsTexAnime(4, 1, "ため息２")
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(78)
	end
	helper_f79a127e(10610, 60)
	if vm.skipping() then
		return skip(79)
	end
	helper_4303896d(4)
	if vm.skipping() then
		return skip(80)
	end
	helper_4303896d(5)
	if vm.skipping() then
		return skip(81)
	end
	event.ObjsSetMotion(5, "立ち")
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(82)
	end
	event.ObjsSetMotion(4, "はっとする", 2)
	event.ObjsNextMotion(4, "はっとするL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "口パク小")
	helper_4303896d(4)
	if vm.skipping() then
		return skip(83)
	end
	event.CmrsSetPos(2761.08, 44.84, 2484.29)
	event.CmrsSetRef(2714.37, 23.72, 2415.71)
	event.ObjsSetMotion(5, "歩き", 4)
	event.ObjsSetPos(5, 2642.36, 0.0, 2314.3)
	event.ObjsSetRot(5, 0.0, -2.5, 0.0)
	event.ObjsMove(5, 2626.57, 0.0, 2291.63, 30)
	event.ObjsRotDelay(5, 20)
	event.ObjsRotation(5, 0.0, 0.66, 0.0, 16)
	helper_4303896d(5)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetMotion(5, "立ち")
	helper_774ccd87(60)
	if vm.skipping() then
		return skip(85)
	end
	event.CmrsSyncObj(4, 0.0, 15.0, 0.0, 0.56, 14.87, 54.88, "ground", 1)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "口パク大")
	helper_f79a127e(10625, 60)
	if vm.skipping() then
		return skip(86)
	end
	event.FadeOutBgm(10)
	event.StopEnvBgm()
	event.SetCrossfade(10)
	if vm.wait() then
		return skip(87)
	end
	event.ObjsSetPos(4, 2200.16, -10000.0, 2784.02)
	event.ObjsSetRot(4, 0.0, -3.1, 0.0)
	event.ObjsResetDaPosition(4)
	event.SetActiveLight(8)
	if vm.wait() then
		return skip(88)
	end
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(89)
	end
	event.StopBgm(0)
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(90)
	end
	event.LoadBgm(104)
	event.PlayBgm(0, -1)
	helper_774ccd87(22)
	if vm.skipping() then
		return skip(91)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(2220.92, -9977.47, 2767.01)
	event.CmrsSetRef(2201.97, -9985.02, 2636.05)
	event.ObjsSetPos(5, 2199.6, -10000.0, 2617.93)
	event.ObjsSetRot(5, 0.0, 0.06, 0.0)
	event.CmrsSetPos(2199.79, -9989.26, 2736.2)
	event.CmrsSetRef(2200.22, -9977.21, 2785.19)
	event.ObjsSetMotion(4, "不思議キョロキョロ", 6)
	event.ObjsNextMotion(4, "立ち2")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	if vm.wait() then
		return skip(92)
	end
	event.SetPakuAnim(4, "通常口パク", "怒り口")
	helper_f79a127e(10630, 70)
	if vm.skipping() then
		return skip(93)
	end
	event.ResetPakuAnim()
	helper_4303896d(4)
	if vm.skipping() then
		return skip(94)
	end
	event.CmrsSetPos(2220.92, -9977.47, 2767.01)
	event.CmrsSetRef(2201.97, -9985.02, 2636.05)
	event.SetPakuAnim(5, "口パク")
	helper_f79a127e(10640, 180)
	if vm.skipping() then
		return skip(95)
	end
	helper_f79a127e(10650, 180)
	if vm.skipping() then
		return skip(96)
	end
	event.ResetPakuAnim()
	event.CharaActive(22)
	event.ObjsSetMotion(8, "キラキラ", 6)
	event.ObjsMotionWait(8)
	event.ObjsSePlay(8, var1, 14)
	event.SetCrossfade(30)
	if vm.wait() then
		return skip(97)
	end
	event.CharaActive(0, 20)
	helper_4303896d(8)
	if vm.skipping() then
		return skip(98)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(99)
	end
	event.CmrsSyncObj(4, 0.0, 15.0, 0.0, 0.56, 14.87, 54.88, "ground", 1)
	event.ObjsSetMotion(4, "ちょっと待ってポーズ", 6)
	event.ObjsNextMotion(4, "ちょっと待ってポーズL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "怒り口")
	event.ObjsTexaDelay(4, 20)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト（瞬有）２")
	event.ObjsTexAnime(4, 1, "口パク小")
	helper_f79a127e(10660, 30)
	if vm.skipping() then
		return skip(100)
	end
	helper_4303896d(4)
	if vm.skipping() then
		return skip(101)
	end
	event.FadeOutBgm(30)
	event.SetActiveLight(5)
	event.SetCrossfade(30)
	event.CmrsReleaseObj()
	event.CmrsSetPos(2676.93, 29.87, 2425.83)
	event.CmrsSetRef(2730.11, 15.0, 2439.37)
	event.ObjsSetPos(4, 2730.11, 0.0, 2439.37)
	event.ObjsSetRot(4, 0.0, -2.38, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(4, "ちょっと待ってポーズ戻り", 6)
	event.ObjsNextMotion(4, "不思議キョロキョロ", 6)
	event.ObjsNextMotion(4, "立ち2", 2)
	event.ObjsTexaDelay(4, 20)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "左→中→右")
	event.ObjsTexAnime(4, 1, "怒り口")
	helper_4303896d(4)
	if vm.skipping() then
		return skip(102)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト目（瞬有）")
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(103)
	end
	event.ObjsSetMotion(4, "はっとする", 2)
	event.ObjsNextMotion(4, "はっとするL", 4)
	event.ObjsTexAnime(4, 1, "開閉口")
	helper_4303896d(4)
	if vm.skipping() then
		return skip(104)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(105)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(4, "歩き2")
	event.ObjsMove2(4, 2643.5, 0.0, 2316.9, 110, 1, 0.1)
	event.ObjsRotation(4, 0.0, -2.5, 0.0, 20)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "口パク小")
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(106)
	end
	event.CharaActive(1, 21)
	event.ObjsSetPos(6, 2626.57, 0.0, 2291.63)
	event.ObjsSetRot(6, 0.0, 0.66, 0.0)
	event.ObjsSetMotion(6, "チケットを拾う", 5)
	event.CmrsSetPos(2832.0, 103.46, 2584.07)
	event.CmrsSetRef(2683.35, 17.47, 2369.67)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(107)
	end
	event.CmrsSetPos(2587.9, 10.29, 2286.73)
	event.CmrsSetRef(2643.19, 14.66, 2311.47)
	event.ObjsSetMotion(4, "チケットを拾う", 6)
	event.ObjsNextMotion(4, "チケットを拾うL", 6)
	event.ObjsNextMotion(4, "顔を上げる", 6)
	event.ObjsNextMotion(4, "顔を上げるL", 4)
	event.ObjsTexaDelay(4, 144)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "デフォルト目（瞬有）")
	event.ObjsSetPos(6, 2643.5, 0.0, 2316.9)
	event.ObjsSetRot(6, 0.0, -2.5, 0.0)
	event.ObjsSetMotion(6, "チケットを拾う", 6)
	event.ObjsNextMotion(6, "チケットを拾うL", 6)
	event.ObjsNextMotion(6, "顔を上げる", 6)
	event.ObjsNextMotion(6, "顔を上げるL", 4)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(108)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(109)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(110)
	end
	return part2()
end

--- Helper function.
local function helper_1c464(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_52c7aaa9(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
end

--- Helper function.
local function helper_1c538()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_1c464(50005)
			end
			if at <= 2 then
				helper_c6c17732()
			end
			if at <= 3 then
				helper_4303896d(0)
			end
			if at <= 4 then
				helper_4303896d(1)
			end
			if at <= 5 then
				helper_774ccd87(4)
			end
			if at <= 6 then
				helper_4303896d(2)
			end
			if at <= 7 then
				helper_4303896d(3)
			end
			if at <= 8 then
				helper_774ccd87(20)
			end
			if at <= 9 then
				helper_774ccd87(94)
			end
			if at <= 10 then
				helper_c6c17732()
			end
			if at <= 11 then
				helper_c6c17732()
			end
			if at <= 12 then
				var1 = 0
			end
			if at <= 13 then
				var1 = var1 + 1
				helper_774ccd87(30)
			end
			if at <= 14 then
				helper_52c7aaa9(1)
			end
			if at <= 15 then
				helper_4303896d(4)
			end
			if at <= 16 then
				helper_774ccd87(30)
			end
			if at <= 17 then
				helper_774ccd87(6)
			end
			if at <= 18 then
				helper_d5f09cbd(0, -1, 8, 0, 0)
				helper_774ccd87(30)
			end
			if at <= 19 then
				helper_774ccd87(10)
			end
			if at <= 20 then
				helper_95c04986(0, -1)
			end
			if at <= 21 then
				helper_d764167e(0)
				helper_4303896d(5)
			end
			if at <= 22 then
				helper_774ccd87(10)
			end
			if at <= 23 then
				helper_4303896d(4)
			end
			if at <= 24 then
				helper_c6c17732()
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.PlayBgm(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.ObjsInit(6)
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetProjection(618.0)
	event.StopBgm(0)
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1219)
	event.PlayEnvBgm(0)
	event.LoadBgm(107)
	event.InitDramaScene()
	var0 = event.SndLoadSound(1219) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/opening/p5/")
	event.LoadMes(0, 5, "op5.txt")
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2198.2, 0.0, 2227.47)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.LoadChara(5, "p5_pierrot.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetFootSoundId(1, 2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 2195.08, 0.0, 2575.62)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.CopyChara(5, 9, 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetFootSoundId(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 2229.28, 0.0, 2598.0)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.CopyChara(5, 9, 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetFootSoundId(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 2173.22, 0.0, 2657.79)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.LoadChara(5, "p5_halloween.gltf", "p00_10a", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2200.0, 0.0, 3021.4)
	event.ObjsSetRot(4, 0.0, 3.14, 0.0)
	event.LoadChara(5, "p5_polcurse.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetFrameShow(5, "sashi", 0)
	event.EohSetFrameShow(5, "cube61_8", 1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "立ち", 4)
	event.SetReference(12, "polcurse", 13)
	event.ObjsTexAnime(5, 0, "口パク")
	event.ChangeDir("")
	event.EohSyncChrobj(6, 12, "cube39")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsRotation(6, 0.0, -0.02, 0.0, -1)
	helper_1c464(50005)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, 2198.2, 0.0, 1839.29, 90)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, 2195.08, 0.0, 1839.62, 140)
	event.ObjsSetMotion(2, "走り", 4, 0.9)
	event.ObjsSetMotionNowTime(2, 4.5)
	event.ObjsMove(2, 2229.28, 0.0, 1839.62, 150)
	event.ObjsSetMotion(3, "走り", 4, 0.9)
	event.ObjsSetMotionNowTime(3, 9.9)
	event.ObjsMove(3, 2173.22, 0.0, 1839.62, 160)
	event.CmrsInit()
	event.CmrsSetPos(1834.01, 105.83, 2170.98)
	event.CmrsSetRef(2138.28, 60.96, 2221.1)
	event.CmrsMove(1833.59, 105.83, 2170.07, 2114.57, 60.96, 2042.3, 90)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(3)
	end
	helper_4303896d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(5)
	end
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(6)
	end
	event.PlayBgm(0, -1)
	helper_4303896d(2)
	if vm.skipping() then
		return skip(7)
	end
	helper_4303896d(3)
	if vm.skipping() then
		return skip(8)
	end
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.SetCrossfade(30)
	event.CmrsSetPos(2200.0, 13.0, 1761.66)
	event.CmrsSetRef(2200.0, 250.08, 3021.4)
	event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 250.08, 3021.4, 120)
	helper_774ccd87(94)
	if vm.skipping() then
		return skip(10)
	end
	event.StreamClose(1)
	event.ObjsSePlay(4, var0, 9)
	helper_c6c17732()
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsJump(4, 2200.0, 0.0, 2100.0, -1.2, 60)
	event.ObjsSetMotion(4, "ジャンプ上昇", 6)
	event.ObjsNextMotion(4, "ジャンプ下降")
	event.ObjsChengeStep(4, 0.08)
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち")
	event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 539.39, 2576.05, 30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(1736.02, 386.45, 2011.23)
	var1 = 0
	while var1 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(12)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.CmrsSetRef(var2, var3 + 20.0, var4)
		if vm.wait() then
			return skip(13)
		end
		var1 = var1 + 1
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(2201.44, 61.26, 1712.51)
	event.CmrsSetRef(2201.87, 89.26, 2115.81)
	event.ObjsSetMotion(4, "きょろきょろカメラ目線", 6)
	event.ObjsNextMotion(4, "ポル持ち立ち", 4)
	event.ObjsSePlay(4, var0, 10)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 10)
	event.ObjsSeDelay(4, 22)
	event.ObjsSePlay(4, var0, 10)
	event.StreamOpen3(1, 50010)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(15)
	end
	helper_4303896d(4)
	if vm.skipping() then
		return skip(16)
	end
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(2189.74, 124.48, 1971.11)
	event.CmrsSetRef(2182.94, 127.74, 2019.16)
	event.ObjsTexAnime(5, 1, "にやり口")
	event.ObjsSetMotion(5, "帽子直し", 6)
	event.ObjsNextMotion(5, "帽子直しL", 4)
	event.ObjsTexaDelay(5, 40)
	event.ObjsTexAnime(5, 0, "目パチ")
	event.ObjsTexAnime(5, 1, "怒り目（目パチ）")
	helper_774ccd87(6)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(5, "口パク", "にやり口")
	event.MesMake_2(0, 50010)
	helper_d5f09cbd(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	event.EohSetTexAnim(5, 0, "にやり口")
	event.EohSetTexAnim(5, 1, "口パク")
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetTexAnim(5, 0, "口パク")
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetFrameShow(5, "sashi", 1)
	event.EohSetFrameShow(5, "cube61_8", 0)
	helper_95c04986(0, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_d764167e(0)
	event.SetMesPos(0, 0)
	helper_4303896d(5)
	if vm.skipping() then
		return skip(22)
	end
	event.StreamClose(1)
	event.CmrsSetPos(1903.57, 177.35, 2408.27)
	event.CmrsSetRef(2208.66, 112.3, 1994.07)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(4, "歩き")
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsMove(4, 2200.0, 0.0, 1500.0, 60)
	helper_4303896d(4)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_c6c17732()
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d01c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d01c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s42", 502)
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7334e9f5()
	helper_fa78()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11838()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.AddItem(353)
	helper_1432c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c538()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.MapJump(-1, "m08", 152)
end

return script
