--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_433a4cf2 = require("@lib/event/helper_433a4cf2")
local helper_5c123176 = require("@lib/event/helper_5c123176")
local helper_7bb034a7 = require("@lib/event/helper_7bb034a7")
local helper_7eebaa1d = require("@lib/event/helper_7eebaa1d")
local helper_b534299b = require("@lib/event/helper_b534299b")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_c570169b = require("@lib/event/helper_c570169b")
local helper_db98deda = require("@lib/event/helper_db98deda")
local helper_eb354717 = require("@lib/event/helper_eb354717")

--- Helper function.
local function helper_2c14343e()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 2 then
				helper_b534299b()
			end
			if at <= 3 then
				helper_db98deda()
			end
			if at <= 4 then
				helper_bdbefa67(30)
			end
			if at <= 5 then
				var1 = helper_433a4cf2(1)
			end
			if at <= 6 then
				helper_bdbefa67(vm.i32(294 - var1))
			end
			if at <= 7 then
				helper_eb354717(0, -1, 8, 0, 0)
				helper_c570169b(0, 30)
			end
			if at <= 8 then
				helper_5c123176(0)
				helper_bdbefa67(10)
			end
			if at <= 9 then
				helper_7bb034a7(10250, -1, 10)
			end
			if at <= 10 then
				helper_db98deda()
			end
			if at <= 11 then
				helper_7eebaa1d(0)
			end
			if at <= 12 then
				helper_7bb034a7(10253, -1, 10)
			end
			if at <= 13 then
				helper_7eebaa1d(0)
			end
			if at <= 14 then
				helper_7bb034a7(10256, -1, 0)
			end
			if at <= 15 then
				helper_7eebaa1d(1)
			end
			if at <= 16 then
				helper_7bb034a7(10260, -1, 10)
			end
			if at <= 17 then
				helper_7eebaa1d(0)
			end
			if at <= 18 then
				helper_7bb034a7(10270, -1, 10)
			end
			if at <= 19 then
				helper_bdbefa67(240)
			end
			if at <= 20 then
				helper_db98deda()
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
	helper_bdbefa67(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(102)
	event.LoadSound(1204)
	event.PlayEnvBgm(3)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch4_1.txt")
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
	helper_b534299b()
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
	helper_db98deda()
	if vm.skipping() then
		return skip(4)
	end
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(120)
	event.PlayBgm(0, -1)
	event.CmrsSetPos(2199.29, 81.59, 2071.01)
	event.CmrsSetRef(2199.55, 105.83, 2098.65)
	event.CmrsMove(2199.29, 29.61, 2071.01, 2199.55, 28.79, 2098.65, 300)
	event.StreamOpen3(1, 10240)
	var1 = helper_433a4cf2(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_bdbefa67(vm.i32(294 - var1))
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSePlay(0, var0, 26)
	event.ObjsMove(0, 2201.47, 0.0, 2087.45, 6)
	event.SetPakuAnim(0, "口パク")
	event.StreamPlay(1)
	event.MesMake_2(0, 10240)
	helper_eb354717(0, -1, 8, 0, 0)
	helper_c570169b(0, 30)
	if vm.skipping() then
		return skip(8)
	end
	helper_5c123176(0)
	event.SetMesPos(0, 0)
	event.StreamClose(1)
	event.ResetPakuAnim()
	event.CmrsMove2(2198.18, 29.61, 1953.27, 2199.55, 28.79, 2098.65, 120, 2, 0.4)
	helper_bdbefa67(10)
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
	helper_7bb034a7(10250, -1, 10)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_db98deda()
	if vm.skipping() then
		return skip(11)
	end
	helper_7eebaa1d(0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "回転", 6)
	event.ObjsNextMotion(0, "回転L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 28)
	event.SetPakuAnim(0, "口パク")
	helper_7bb034a7(10253, -1, 10)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(0)
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
	helper_7bb034a7(10256, -1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(1)
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
	helper_7bb034a7(10260, -1, 10)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(0)
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
	helper_7bb034a7(10270, -1, 10)
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
	helper_bdbefa67(240)
	if vm.skipping() then
		return skip(20)
	end
	event.FadeOutBgm(60)
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_db98deda()
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

return helper_2c14343e
