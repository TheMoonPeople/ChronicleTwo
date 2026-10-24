--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_46f8aa3e = require("@lib/event/helper_46f8aa3e")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_a518823a = require("@lib/event/helper_a518823a")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_cb265f35 = require("@lib/event/helper_cb265f35")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")

--- Helper function.
local function helper_1357d5dd()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		event.SetMesWindowMode(0, 7)
		event.SetTimeStepEnable(0)
		event.SetTime(24)
		event.SetProjection(618.0)
		event.CharaActive(0, 0)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(102)
		event.LoadSound(1204)
		event.PlayEnvBgm(3)
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadMes(0, 5, "event/opening/p1/op1ch4_1.txt")
		var0 = event.SndLoadSound_2(1204) or var0
		event.LoadChara(5, "event/opening/p1/p1_polcurse.gltf", "info", 8)
		event.CharaActive(8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 2201.47, -17.0, 2087.45)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(0, "立ち")
		event.SetLoadbgFile_1("event/opening/p1/p1_pierrot.gltf")
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
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
		event.SetLoadbgFile_1("")
		event.CmrsInit()
		event.CmrsSetPos(1240.09, 218.04, 1303.05)
		event.CmrsSetRef(1240.68, 300.58, 1344.23)
		event.CmrsFadeInit()
		event.CmrsFadeIn(200)
		at = 4
		helper_c624bc16()
		at = 5
		helper_25abe6d2(30)
		event.SetCrossfade(120)
		event.PlayBgm(0, -1)
		event.CmrsSetPos(2199.29, 81.59, 2071.01)
		event.CmrsSetRef(2199.55, 105.83, 2098.65)
		event.CmrsMove(2199.29, 29.61, 2071.01, 2199.55, 28.79, 2098.65, 300)
		event.StreamOpen3(1, 10240)
		at = 6
		var1 = helper_f616ba9e(1)
		at = 7
		helper_25abe6d2(vm.i32(294 - var1))
		event.ObjsSePlay(0, var0, 26)
		event.ObjsMove(0, 2201.47, 0.0, 2087.45, 6)
		event.SetPakuAnim(0, "口パク")
		event.StreamPlay(1)
		event.MesMake_2(0, 10240)
		helper_82705ce2(0, -1, 8, 0, 0)
		at = 8
		helper_46f8aa3e(0, 30)
		helper_6992f518(0)
		event.SetMesPos(0, 0)
		event.StreamClose(1)
		event.ResetPakuAnim()
		event.CmrsMove2(2198.18, 29.61, 1953.27, 2199.55, 28.79, 2098.65, 120, 2, 0.4)
		at = 9
		helper_25abe6d2(10)
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
		at = 10
		helper_cb265f35(10250, -1, 10)
		event.ResetPakuAnim()
		at = 11
		helper_c624bc16()
		at = 12
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "回転", 6)
		event.ObjsNextMotion(0, "回転L", 4)
		event.ObjsSeDelay(0, 10)
		event.ObjsSePlay(0, var0, 28)
		event.SetPakuAnim(0, "口パク")
		at = 13
		helper_cb265f35(10253, -1, 10)
		event.ResetPakuAnim()
		at = 14
		helper_0958ca60(0)
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
		at = 15
		helper_cb265f35(10256, -1, 0)
		event.ResetPakuAnim()
		at = 16
		helper_0958ca60(1)
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
		at = 17
		helper_cb265f35(10260, -1, 10)
		event.ResetPakuAnim()
		at = 18
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "杖まわす", 2)
		event.ObjsNextMotion(0, "杖まわすL", 4)
		event.ObjsMotionDelay(0, 56)
		event.ObjsSetMotion(0, "回転", 6)
		event.ObjsNextMotion(0, "回転L", 6)
		event.ObjsMotionDelay(0, 16)
		event.ObjsSetMotion(0, "決め", 2)
		event.ObjsNextMotion(0, "決めL", 4)
		at = 19
		helper_cb265f35(10270, -1, 10)
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
		at = 20
		helper_25abe6d2(240)
		event.FadeOutBgm(60)
		event.CmrsFadeInit()
		event.CmrsFadeOut(60)
		at = 21
		helper_c624bc16()
	end, function(received: { any }): boolean
		if at == 6 then
			var1 = received[1] :: number
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_d3f20302(30)
		end
		if at <= 5 then
			var1 = helper_523109b8(1)
		end
		if at <= 6 then
			helper_d3f20302(vm.i32(294 - var1))
		end
		if at <= 7 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 30)
		end
		if at <= 8 then
			helper_d16eef1e(0)
			helper_d3f20302(10)
		end
		if at <= 9 then
			helper_a518823a(10250, -1, 10)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_a518823a(10253, -1, 10)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_a518823a(10256, -1, 0)
		end
		if at <= 15 then
			helper_238b5abc(1)
		end
		if at <= 16 then
			helper_a518823a(10260, -1, 10)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_a518823a(10270, -1, 10)
		end
		if at <= 19 then
			helper_d3f20302(240)
		end
		if at <= 20 then
			helper_344d6cd8()
		end
		return true
	end)
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

return helper_1357d5dd
