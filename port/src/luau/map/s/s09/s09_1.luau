--!strict
-- map/s/s09/s09_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13c3517e = require("@lib/event/helper_13c3517e")
local helper_14df340b = require("@lib/event/helper_14df340b")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_3d4fabfe = require("@lib/event/helper_3d4fabfe")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_5416a4d0 = require("@lib/event/helper_5416a4d0")
local helper_56273686 = require("@lib/event/helper_56273686")
local helper_5df5cbcf = require("@lib/event/helper_5df5cbcf")
local helper_667ee00c = require("@lib/event/helper_667ee00c")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_91fcd565 = require("@lib/event/helper_91fcd565")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b36a42db = require("@lib/event/helper_b36a42db")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_e610e615 = require("@lib/event/helper_e610e615")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_26980()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.SetCharaPos(0, -1918.94, 29.4, -453.91)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(-2033.1, 114.91, -255.29)
	event.SetFadeIn(30)
	event.ObjsMove(0, -1918.94, 29.22, -379.73, 30)
	var3 = 0
	while var3 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Helper function.
local function helper_2adc0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_8f31f334(2)
			end
			if at <= 2 then
				helper_aafd6a80(20)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_aafd6a80(10)
			end
			if at <= 5 then
				helper_aafd6a80(20)
			end
			if at <= 6 then
				helper_aafd6a80(10)
			end
			if at <= 7 then
				helper_aafd6a80(20)
			end
			if at <= 8 then
				helper_6c719c99(4000010)
			end
			if at <= 9 then
				helper_8f31f334(1)
			end
			if at <= 10 then
				helper_6c719c99(4000020)
			end
			if at <= 11 then
				helper_8f31f334(0)
			end
			if at <= 12 then
				helper_6c719c99(4000030)
			end
			if at <= 13 then
				helper_6c719c99(4000040)
			end
			if at <= 14 then
				helper_6c719c99(4000050)
			end
			if at <= 15 then
				helper_6c719c99(4000060)
			end
			if at <= 16 then
				helper_6c719c99(4000070)
			end
			if at <= 17 then
				helper_6c719c99(4000080)
			end
			if at <= 18 then
				helper_8f31f334(1)
			end
			if at <= 19 then
				helper_6c719c99(4000085)
			end
			if at <= 20 then
				helper_aafd6a80(6)
			end
			if at <= 21 then
				helper_8f31f334(0)
			end
			if at <= 22 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 5)
		event.EohSetPos(2, -912.1, 0.0, 0.0)
		event.EohSetRot(2, 0.0, 1.57, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		event.CharaActive(8)
		event.SetCharaPos(8, -2030.0, 30.0, -100.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetAi(1, 8)
		event.CharaActive(9)
		event.SetCharaPos(9, -1098.0, 29.2, -100.0)
		event.SetCharaRot(9, 0.0, -1.57, 0.0)
		event.SetAi(1, 9)
		event.CharaActive(10)
		event.SetCharaPos(10, -707.6, -10.0, -172.5)
		event.SetCharaRot(10, 0.0, 0.0, 0.0)
		event.SetAi(1, 10)
		event.CharaActive(0)
		event.SetCharaPos(0, -1880.1, 29.2, -299.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(4200) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e400/e400/")
	event.LoadMes(0, 5, "e400_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e400_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e400_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e400/e400_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e400/e400_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.SetAi(0, 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(7, 8)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.SetAi(0, 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(8, 9)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.SetAi(0, 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(9, 10)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
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
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "デフォルト顔")
	event.EohSetTexAnim(7, 1, "通常目パチ")
	event.EohSetPos(0, -1494.0, 42.31, -35.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, -1478.0, 42.31, -35.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 6)
	event.EohSetPos(7, -1485.0, 45.34, -9.42)
	event.EohSetRot(7, 0.0, 3.14, 0.0)
	event.EohSetMotion(7, "立ち", 4)
	event.EohSetPos(2, -2312.1, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 1.57, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1481.05, 64.34, -282.56)
	event.CmrsSetRef(-1949.42, 59.22, -91.09)
	event.CmrsMove2(-1481.05, 64.34, -282.56, -1473.02, 59.22, -83.94, 80, 2, 1.0)
	event.ObjsMove2(2, -912.1, 0.0, 0.0, 80, 2, 1.0)
	event.SndSePlay(var0, 4)
	event.SndSePlay(var0, 5)
	event.SetFadeIn(30)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(8)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -1493.51, 29.22, -100.0, 60)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -1478.51, 29.22, -90.0, 50)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 3)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetFootSoundId(1, 3)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(8)
	end
	event.EsmClear()
	event.CmrsSetPos(-1510.53, 52.11, -162.67)
	event.CmrsSetRef(-1480.38, 51.06, -136.4)
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsMove(1, -1478.51, 29.22, -145.0, 50)
	event.ObjsSetMotion(1, "潮歩き", 4)
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "潮立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_6c719c99(4000010)
	if vm.skipping() then
		return skip(9)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsMove(0, -1493.51, 29.22, -135.0, 50)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(4000020)
	if vm.skipping() then
		return skip(11)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "潮立ちから右", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(4000030)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(4000040)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(4000050)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-1482.95, 61.09, -180.61)
	event.CmrsSetRef(-1483.79, 47.79, -128.26)
	event.ObjsSetPos(7, -1483.61, 29.22, -91.35)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(1, "ふりかえり", 6)
	event.ObjsNextMotion(1, "ふりかえりＬ", 4)
	event.ObjsSetMotion(0, "振り返り", 6)
	event.ObjsNextMotion(0, "振り返りL", 4)
	event.SetPakuAnim(7, "口パク")
	helper_6c719c99(4000060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-1563.93, 73.34, -118.52)
	event.CmrsSetRef(-1483.1, 54.11, -118.91)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetCharaPos(9, -625.34, 29.22, -99.11)
	event.SetCharaPos(10, -627.43, 29.22, -126.82)
	event.ObjsSetPos(7, -1489.0, 29.22, -98.62)
	event.ObjsSetRot(7, 0.0, 1.58, 0.0)
	event.ObjsSetPos(0, -1496.36, 29.22, -129.63)
	event.ObjsSetRot(0, 0.0, 1.46, 0.0)
	event.ObjsSetMotion(0, "立ち", 6, -1.0, 1)
	event.ObjsSetPos(1, -1478.51, 29.22, -145.0)
	event.ObjsSetRot(1, 0.0, 0.98, 0.0)
	event.ObjsSetMotion(1, "立ち", 6, -1.0, 1)
	helper_6c719c99(4000070)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "手振り", 6)
	event.ObjsNextMotion(1, "手振りＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(4000080)
	if vm.skipping() then
		return skip(18)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-1522.27, 54.57, -147.64)
	event.CmrsSetRef(-1483.82, 49.34, -134.4)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 8)
	event.ObjsSetRot(0, 0.0, 1.82, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "手振りから左", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6c719c99(4000085)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var0, 8)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_28a44()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_8f31f334(1)
			end
			if at <= 2 then
				helper_aafd6a80(10)
			end
			if at <= 3 then
				helper_aafd6a80(15)
			end
			if at <= 4 then
				helper_aafd6a80(10)
			end
			if at <= 5 then
				helper_8f31f334(0)
			end
			if at <= 6 then
				helper_aafd6a80(10)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EsmClear()
		event.SetFadeIn(1)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EohSetPos(1, -912.1, 0.0, 0.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.EohSetShow(6, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1460.3, 29.22, -123.59)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.CharaActive(1, 8)
		if flag == 0 then
			event.CharaActive(1, 9)
			event.CharaActive(1, 10)
		end
		event.ResetCamera(1, 3.14, 10.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	flag = event.GetFlag(448) or flag
	event.CharaActive(0, 8)
	if flag == 0 then
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
	end
	var1 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var1
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -1512.1, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(6, "p01_shadow")
	event.EohSetShow(6, 0)
	event.EohSyncObj(2, "p01_train01", "train08-m0")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "train08-m1")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "train10-m0")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "train10-m1")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.SndSePlay(var1, 0)
	event.EohSetFootSoundId(0, 6)
	event.CmrsInit()
	event.CmrsSetPos(-363.94, 121.88, -75.09)
	event.CmrsSetRef(-643.14, 118.87, -58.01)
	event.SetFadeIn(30)
	event.ObjsMove2(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1664.28, 105.75, -222.05)
	event.CmrsSetRef(-1452.28, 75.37, -85.42)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 66)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -1460.3, 33.0, -45.39)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -1460.3, 29.22, -123.59, 30)
	event.ObjsSetMotion(0, "走り", 4)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 3)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_27a54()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_aafd6a80(10)
		end
		if at <= 3 then
			helper_aafd6a80(15)
		end
		if at <= 4 then
			helper_8f31f334(0)
		end
		if at <= 5 then
			helper_aafd6a80(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.GetFlag(448) or flag
	event.CharaActive(0, 8)
	if flag == 0 then
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
	end
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(4, "p01_shadow")
	event.EohSetShow(4, 0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -1512.1, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsMove2(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(-363.94, 121.88, -75.09)
	event.CmrsSetRef(-643.14, 118.87, -58.01)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1664.28, 105.75, -222.05)
	event.CmrsSetRef(-1452.28, 75.37, -85.42)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -1460.3, 33.0, -45.39)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 92)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -1460.3, 29.22, -123.59, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 3)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 1)
	event.CharaActive(1, 8)
	if flag == 0 then
		event.CharaActive(1, 9)
		event.CharaActive(1, 10)
	end
	event.CharaActive(0)
	event.SetCharaPos(0, -1460.3, 29.22, -123.59)
	event.SetCharaRot(0, 0.0, -1.57, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.1415927, 10.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_26eb4()
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
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_aafd6a80(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_b36a42db(5, 2)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(-1925.42, 97.53, -285.93)
		event.CmrsSetRef(-1921.75, 57.81, -472.01)
		event.ObjsSetPos(0, -1910.95, 21.58, -466.12)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, -1910.95, 21.58, -466.12)
		event.ObjsAddPas(0, -1907.45, 17.42, -496.67)
		event.ObjsAddPas(0, -1898.74, 13.2, -528.24)
		event.ObjsAddPas(0, -1878.93, 9.61, -555.9)
		event.ObjsAddPas(0, -1854.68, 5.12, -580.59)
		event.ObjsAddPas(0, -1828.07, 1.46, -591.28)
		event.ObjsStartPas(0)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_aafd6a80(30)
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
		var4 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var3)
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
	return 0
end

--- Helper function.
local function helper_1ce54()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(0, 1)
			return 0
		end
		if at <= 3 then
			helper_aafd6a80(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_c9057fa5(0, 4)
	event.MesMake_2(0, "Go inside\nLeave")
	var0 = helper_e610e615(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_c9057fa5(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_32de4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_aafd6a80(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_2f088()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "chara/p01_03a.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "chara/p01_06a.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadMes(0, 5, "event/e400/e448/e448_1.txt")
end

--- Helper function.
local function helper_2ecc0()
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
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.SetCharaPos(0, -1952.44, 29.22, -304.96)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
end

--- Helper function.
local function helper_2ffb8()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_8f31f334(1)
			end
			if at <= 2 then
				helper_8f31f334(0)
			end
			if at <= 3 then
				helper_8f31f334(1)
			end
			if at <= 4 then
				helper_6c719c99(4481130)
			end
			if at <= 5 then
				helper_6c719c99(4481140)
			end
			if at <= 6 then
				helper_6c719c99(4481150)
			end
			if at <= 7 then
				helper_aafd6a80(30)
			end
			if at <= 8 then
				helper_6c719c99(4481160)
			end
			if at <= 9 then
				helper_6c719c99(4481170)
			end
			if at <= 10 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		if at <= 12 then
			helper_aafd6a80(35)
		end
		helper_2ecc0()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_aafd6a80(35)
		if vm.skipping() then
			return skip(13)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_2ecc0()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4220)
	var6 = event.SndLoadSound(4220) or var6
	helper_2f088()
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.CmrsSetPos(-1979.65, 91.43, -121.02)
	event.CmrsSetRef(-1941.55, 74.53, -339.62)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsSetPos(1, -1838.01, 8.0, -560.01)
	event.ObjsSetRot(1, 0.0, -0.64, 0.0)
	event.ObjsSetPos(0, -1904.92, 17.42, -503.6)
	event.ObjsSetRot(0, 0.0, -0.64, 0.0)
	event.ObjsSetPos(2, -2186.89, 29.22, -198.9)
	event.ObjsSetRot(2, 0.0, 3.13, 0.0)
	event.ObjsSetPos(3, -2223.98, 29.22, -196.3)
	event.ObjsSetRot(3, 0.0, 3.13, 0.0)
	event.ObjsSetPos(4, -912.1, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.SetFadeIn(30)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 60)
	event.ObjsAddPas(0, -1904.92, 17.42, -503.6)
	event.ObjsAddPas(0, -1985.4, 29.22, -393.12)
	event.ObjsStartPas(0, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 60)
	event.ObjsAddPas(1, -1838.01, 8.0, -560.01)
	event.ObjsAddPas(1, -1922.88, 29.4, -436.71)
	event.ObjsStartPas(1, 1)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	event.InitDramaScene()
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(-2052.02, 160.14, -365.82)
	event.CmrsSetRef(-2179.63, 74.53, -268.32)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, -2199.24, 29.22, -360.0)
	event.ObjsAddPas(1, -2199.24, 29.22, -253.55)
	event.ObjsStartPas(1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, -2216.55, 29.22, -360.0)
	event.ObjsAddPas(0, -2216.55, 29.22, -253.55)
	event.ObjsStartPas(0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_6c719c99(4481130)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_6c719c99(4481140)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(3, "会話", 2)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_6c719c99(4481150)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(3, "立ち")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetPos(1, -1935.53, 29.22, -301.43)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetPos(0, -1952.44, 29.22, -304.96)
	event.ObjsSetRot(0, 0.0, 1.08, 0.0)
	event.CmrsSetPos(-1949.04, 34.26, -256.22)
	event.CmrsSetRef(-1934.01, 87.78, -397.48)
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6c719c99(4481160)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 25)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6c719c99(4481170)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_1d200(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, how ya doin'? I'm doin' great!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "I pray for your safety...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "You really like all this\nadventure, don't ya.")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "I pray that the world will\nfrom today forever be at peace.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
end

--- Helper function.
local function helper_1f4c4(arg0: s32, arg1: s32)
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
local function helper_2087c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_dd7a6f53(1)
		helper_1f4c4(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_dd7a6f53(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1f4c4(arg0, argc)
	end
end

--- Helper function.
local function helper_20b24(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(30)
		end
		helper_2087c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_2087c(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f7b8(arg0: s32)
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
			helper_c049c42a(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_c9057fa5(arg0, 1)
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_c049c42a(arg0, -1, 3, 256, 208)
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
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "If you don't bring me more scoops,\nI can't give ya nothin'!")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(
			arg0,
			"Your Photography level's determined\nby the number of ideas and scoops\nyou have.<page>And as your level goes up, you get\nmore cool items as rewards."
		)
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1fe00(arg0: s32)
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
				helper_c049c42a(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_c049c42a(arg0, -1, 3, 256, 208)
			end
			return helper_1f7b8(arg0)
		end
		if at <= 5 then
			helper_c9057fa5(arg0, 1)
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_c049c42a(arg0, -1, 3, 256, 208)
		end
		return helper_1f7b8(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
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
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_1f7b8(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_c9057fa5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
		event.SetMesDrawspeed(arg0, 0)
		helper_c049c42a(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_c9057fa5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
	end
	if now_map_no == 22 then
		helper_403f0e66(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_c049c42a(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_1f7b8(arg0)
end

--- Helper function.
local function helper_1e4e8()
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
		event.MesMake_2(3, "Great job! Humans\naren't so bad after all!<page>I was wrong!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"This is it. It's almost over.\nAll we have to do is defeat him.<page>And after that, the world can live again."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I guess I know how Griffon feels, but I don't\nthink I could ever forgive him for what he did."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Return the garden to its former state, and\nexpose the secret of Griffon, I mean, Sirus.")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I wonder what she means, \"Sirus' memories.\"\nI guess we'll have to enter the palace to find out."
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Griffon'll get away if we just stand around like\nthis. Let's get to the Moon Flower Palace, quick."
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Looks like we got all the gems. Now we\njust have to hurry to Kazarov Stonehenge.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Whatever it is, we better find the gems\nquick, before it's too late.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Everything started at this palace, huh.\nAnyway, let's head into the garden.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "We better head back to Luna Lab soon.\nThey may be finished with Ixion already.")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "It's about time to strike back against\nGriffon. Let's head over to the Paznos base.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Remember? Galen Agaris said that if you\nplay the Fire Horn the road will open up.")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Gotta blow that Firesquall to bits.<page>So it's up there on top of Mt. Gundor, huh?")
		return
	end
	event.MesMake_2(
		3,
		"Just waiting here won't change anything.<page>There's got to be some places we haven't been to yet."
	)
end

--- Helper function.
local function helper_20c58(arg0: s32, arg1: s32)
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
				helper_c9057fa5(3, 1)
				helper_1d200(3, argc)
				var25 = -1
				helper_27ff0b8f(3, var25, 3, 256, 208)
				helper_c9057fa5(1, 8)
				helper_27ff0b8f(1, 1, 1, 0, 0)
				helper_c9057fa5(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_e610e615(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_dd7a6f53(3)
				helper_aafd6a80(30)
			end
			helper_2087c(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_c9057fa5(3, 8)
				helper_c049c42a(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_c049c42a(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_2087c(arg0, arg1)
				helper_20b24(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20b24(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20b24(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20b24(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20b24(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20b24(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20b24(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20b24(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20b24(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20b24(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20b24(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20b24(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20b24(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20b24(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20b24(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20b24(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20b24(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20b24(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20b24(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20b24(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20b24(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20b24(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20b24(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e4e8()
			helper_c049c42a(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_2087c(arg0, arg1)
			helper_aafd6a80(30)
		end
		helper_2087c(arg0, arg1)
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
		helper_c9057fa5(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1d200(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_27ff0b8f(3, var25, 3, 256, 208)
		helper_c9057fa5(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_27ff0b8f(1, 1, 1, 0, 0)
		helper_c9057fa5(2, 2)
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
		var24 = helper_e610e615(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_dd7a6f53(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_aafd6a80(30)
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
				helper_2087c(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_c9057fa5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]You can't do that right now. You have\nto bring Lin to the lighthouse first!")
			helper_c049c42a(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_c9057fa5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_c049c42a(3, var25, 9, 0, 0)
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
						event.MesMake_2(3, "Alright, we're finished\nwith repairs!")
						helper_c049c42a(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_2087c(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20b24(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20b24(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1fe00(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20b24(arg0, arg1, 33)
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
						helper_20b24(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20b24(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20b24(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20b24(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20b24(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20b24(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20b24(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20b24(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20b24(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20b24(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20b24(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20b24(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20b24(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20b24(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20b24(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20b24(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20b24(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20b24(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20b24(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20b24(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20b24(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e4e8()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_c049c42a(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_2087c(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_aafd6a80(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_2087c(arg0, arg1)
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
	helper_2087c(arg0, arg1)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_24dc8()
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
				helper_403f0e66(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_e610e615(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_13c3517e(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_20c58(var17, 1)
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
		helper_c9057fa5(0, 1)
		var9 = helper_5df5cbcf(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "You want to leave?")
		helper_403f0e66(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Yeah!\nI want to stay a little longer.")
		var11 = helper_e610e615(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "Umph, you go get 'em, ya hear!")
			helper_403f0e66(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_13c3517e(var0, var9, 0, 0)
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
		helper_c9057fa5(0, 1)
		event.MesMake_2(0, "Be careful out there, you two.")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
		end
		helper_14df340b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_20c58(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_24314()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20c58(var4, 2)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_c9057fa5(0, 1)
		event.MesMake_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(448) or flag
		if var2 == 4 and flag == 0 then
			event.MesMake_2(0, "The roads and the bridges are\nall out of whack! What were\nyou thinking? Geez...")
		end
		if var2 == 3 then
			event.MesMake_2(
				0,
				"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
			)
		end
		helper_14df340b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_20c58(var4, 2)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_247a0()
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
			helper_c9057fa5(0, 1)
			helper_14df340b(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_20c58(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_c9057fa5(0, 1)
		event.MesMake_2(
			0,
			"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
		)
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(280) or flag
		if var2 == 2 and flag == 0 then
			event.MesMake_2(0, "One Final Bomb and a boulder\nlike this would be history.")
		end
		flag_2 = event.GetFlag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.MesMake_2(
				0,
				"Mind you, blastin' is no cakewalk\neither. One tiny slip-up and you\nbring the whole house down."
			)
		end
		flag_3 = event.GetFlag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.MesMake_2(0, "I may be a demolitions expert,\nbut when it comes to repairs,\nI'm all thumbs!")
		end
		helper_14df340b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_20c58(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_25ce8()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(0, 1)
			helper_14df340b(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_c9057fa5(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "I'll wait for you here.\nI hope it all goes well.")
	else
		event.MesMake_2(0, "I'll wait here.\nMake sure you get him.")
	end
	helper_14df340b(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_33e1c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_247a0()
		end
		if at <= 2 then
			helper_25ce8()
		end
		return 0
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		return helper_24dc8()
	end
	if var0 == 2 then
		helper_24314()
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 13 then
		helper_247a0()
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 301 then
		helper_25ce8()
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_31820()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_aafd6a80(45)
			end
			if at <= 2 then
				helper_6c719c99(4520010)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(452, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4223)
	var0 = event.SndLoadSound(4223) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadMes(0, 5, "event/e400/e452/e452_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/e400/e452/e452_mints.chr", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "event/e400/e452/e452_monica.chr", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "event/e200/e283/e283_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e452/e452_mints.chr", "info", 32)
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
		event.LoadMotion(5, "event/e400/e452/e452_monica.chr", "info", 32)
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
	event.EohSetPos(0, -1960.0, 29.22, -120.0)
	event.EohSetRot(0, 0.0, -0.7853982, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetPos(1, -2000.0, 29.22, -120.0)
	event.EohSetRot(1, 0.0, 0.7853982, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetPos(2, -1980.0, 29.22, -100.0)
	event.EohSetRot(2, 0.0, 3.1415927, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1980.0, 51.24, -291.47)
	event.CmrsSetRef(-1980.0, 91.37, -49.52)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SndSePlay(var0, 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_6c719c99(4520010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_29f30(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_aafd6a80(60)
			end
			if at <= 3 then
				helper_8f31f334(0)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 ~= 0 then
			event.StopBgm(0)
		end
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.EsmClear()
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(4223)
	var1 = event.SndLoadSound(4223) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.CharaActive(0, 8)
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -912.1, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 1.5707964, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -120.0, 0.0, -1690.0)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 0)
	event.EohSyncObj(1, "p01_shadow")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-480.06, 58.66, -117.78)
	event.CmrsSetRef(-569.61, 64.12, -98.79)
	event.SetFadeIn(30)
	event.SndSePlay(var1, 1)
	event.CharaActive(11)
	event.ObjsSetPos(2, -874.19, 10.0, 30.0)
	event.ObjsSetRot(2, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(2, "ぶしゅー", 6)
	event.CharaActive(12)
	event.ObjsSetPos(3, -874.19, 10.0, 30.0)
	event.ObjsSetRot(3, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(3, "ぶしゅー", 6)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove2(0, 4000.0, 0.0, 0.0, 180, 1, 1.0)
	event.ObjsMove2(1, 4500.0, 0.0, 0.0, 180, 1, 1.0)
	event.SndSePlay(var1, 2)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(4)
	end
	if arg0 ~= 0 then
		event.FadeOutBgm(30)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
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
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_56273686()
			helper_2adc0()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_28a44()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 3 then
			helper_27a54()
		end
		print("------  <START EVENT> OLD MAP ERR   ------\n")
	end
	function part2() end
	function landing1()
		return part2()
	end
	function landing2()
		event.CharaActive(1, 9)
		return part2()
	end
	print("START_EVENT----------------------------")
	helper_5416a4d0()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -1820.0, 29.2, -335.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType() or var2
		if var2 ~= -1 then
			if old_map_no == 2 or old_map_no == 75 then
				helper_26980()
				if vm.skipping() then
					return skip(1)
				end
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 4 then
					helper_56273686()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					flag = event.GetFlag(360) or flag
					flag_2 = event.GetFlag(400) or flag_2
					if flag == 1 and flag_2 == 0 then
						helper_2adc0()
						if vm.skipping() then
							return skip(2)
						end
					else
						event.CharaActive(0, 9)
						var6 = event.GetChapter() or var6
						if var6 ~= 6 and var6 ~= 7 then
							helper_28a44()
							if vm.skipping() then
								return skip(3)
							end
						else
							helper_27a54()
							if vm.skipping() then
								return skip(4)
							end
						end
						event.CharaActive(1, 9)
					end
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27a54()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_26eb4()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "g03")
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
			helper_3d4fabfe()
		end
		if at <= 6 then
			helper_667ee00c(0)
		end
		if at <= 7 then
			helper_91fcd565()
		end
	end
	var0 = helper_1ce54()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 4)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_3d4fabfe()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_3d4fabfe()
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
		helper_667ee00c(0)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_91fcd565()
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
	helper_32de4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5416a4d0()
	helper_2ffb8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_31820()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_29f30(1)
			if not vm.skipping() then
				return landing2()
			end
		end
	end
	function part2() end
	function landing1()
		helper_29f30(1)
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
		return part2()
	end
	function landing2()
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
		return part2()
	end
	var0 = helper_33e1c()
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 1 then
		helper_31820()
		if vm.skipping() then
			return skip(2)
		end
		helper_29f30(1)
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
	end
	return part2()
end

--- Program 14000.
script[14000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5416a4d0()
	helper_2adc0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14520.
script[14520] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29f30(1)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(3)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
	end
	helper_5416a4d0()
	helper_31820()
	if vm.skipping() then
		return skip(1)
	end
	helper_29f30(1)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
