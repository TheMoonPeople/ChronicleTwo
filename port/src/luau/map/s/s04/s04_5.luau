--!strict
-- map/s/s04/s04_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_0d345d12 = require("@lib/event/helper_0d345d12")
local helper_2084e5f4 = require("@lib/event/helper_2084e5f4")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_23ac133f = require("@lib/event/helper_23ac133f")
local helper_377e162e = require("@lib/event/helper_377e162e")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_5203c0f2 = require("@lib/event/helper_5203c0f2")
local helper_540c04ee = require("@lib/event/helper_540c04ee")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_83f868da = require("@lib/event/helper_83f868da")
local helper_87aa4a59 = require("@lib/event/helper_87aa4a59")
local helper_a269bbe8 = require("@lib/event/helper_a269bbe8")
local helper_ad3cd17a = require("@lib/event/helper_ad3cd17a")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_d8b0d636 = require("@lib/event/helper_d8b0d636")
local helper_daa89e49 = require("@lib/event/helper_daa89e49")
local helper_dda46917 = require("@lib/event/helper_dda46917")
local helper_e44d9fc7 = require("@lib/event/helper_e44d9fc7")
local helper_f4cea3bb = require("@lib/event/helper_f4cea3bb")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_269c0()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(372) or flag
	if flag == 1 then
		event.EohSyncObj(0, "p09_s04")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_27278()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(24)
	event.SetCharaPos(24, -123.0, 36.0, -68.0)
	event.SetCharaRot(24, 0.0, -1.57, 0.0)
	event.SetMotion(24, "立ち", 4)
	event.CharaActive(25)
	event.SetCharaPos(25, -99.9, 36.0, 456.5)
	event.SetCharaRot(25, 0.0, -1.5, 0.0)
	event.SetMotion(25, "立ち", 4)
	event.CharaActive(26)
	event.SetCharaPos(26, -99.6, 36.0, 855.2)
	event.SetCharaRot(26, 0.0, -2.37, 0.0)
	event.SetMotion(26, "立ち", 4)
end

--- Helper function.
local function helper_27608()
	local var0: s32 = 0
	var0 = event.GetChapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		helper_ad3cd17a()
	else
		helper_4337dd96()
	end
	helper_f4cea3bb()
	helper_269c0()
	helper_23ac133f()
	helper_27278()
end

--- Helper function.
local function helper_277a8()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCameraPos(-1145.1, 60.0, 267.26)
	event.SetCameraRef(-1389.9, 59.36, 109.01)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 40)
	event.ObjsAddPas(0, -1389.9, 29.36, 109.01)
	event.ObjsAddPas(0, -1346.17, 17.95, 136.53)
	event.ObjsAddPas(0, -1295.63, 0.0, 159.4)
	event.ObjsAddPas(0, -1263.68, 0.0, 164.7)
	event.ObjsStartPas(0)
	var3 = 0
	while var3 < 40 do
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
	event.EohSetFootSoundId(0, 0)
end

--- Helper function.
local function helper_2bd2c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 28 then
			if at <= 1 then
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_c1c32f84(90)
			end
			if at <= 3 then
				helper_c1c32f84(80)
			end
			if at <= 4 then
				helper_2386f745(6)
			end
			if at <= 5 then
				helper_c1c32f84(10)
			end
			if at <= 6 then
				helper_c1c32f84(4)
			end
			if at <= 7 then
				helper_c1c32f84(60)
			end
			if at <= 8 then
				helper_42c67f56(3000010)
			end
			if at <= 9 then
				helper_42c67f56(3000020)
			end
			if at <= 10 then
				helper_2386f745(1)
			end
			if at <= 11 then
				helper_c1c32f84(10)
			end
			if at <= 12 then
				helper_42c67f56(3000030)
			end
			if at <= 13 then
				helper_2386f745(2)
			end
			if at <= 14 then
				helper_42c67f56(3000040)
			end
			if at <= 15 then
				helper_42c67f56(3000045)
			end
			if at <= 16 then
				helper_2386f745(2)
			end
			if at <= 17 then
				helper_42c67f56(3000050)
			end
			if at <= 18 then
				helper_2386f745(0)
			end
			if at <= 19 then
				helper_c1c32f84(4)
			end
			if at <= 20 then
				helper_c1c32f84(40)
			end
			if at <= 21 then
				helper_42c67f56(3000060)
			end
			if at <= 22 then
				helper_2386f745(2)
			end
			if at <= 23 then
				helper_c1c32f84(4)
			end
			if at <= 24 then
				helper_42c67f56(3000070)
			end
			if at <= 25 then
				helper_c1c32f84(2)
			end
			if at <= 26 then
				helper_c1c32f84(30)
			end
			if at <= 27 then
				helper_c1c32f84(20)
			end
			if vm.skip_end() then
				return skip(29)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EsmClear()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.SndSeStop(var0, 8)
		event.EohSetPos(5, 0.0, 0.0, 400.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(7, 0.0, 0.0, 0.0)
		event.EohSetRot(8, 0.0, 0.0, 0.0)
		event.EohSetRot(9, 0.0, 0.0, 0.0)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "通常目パチ")
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -382.56, 0.0, -156.89)
		event.SetCharaRot(0, 0.0, -1.59, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(300, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(3200)
	var0 = event.SndLoadSound(3200) or var0
	event.CharaActive(0, 25)
	event.CharaActive(0, 26)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e300/")
	event.LoadMes(0, 5, "e300_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e300_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e300_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(0, 24)
	event.EohSyncChara(2, 24)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.ChangeDir("event/e200/e207/")
	event.LoadChara(5, "e207_vorneo.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e207_tom.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e300/e300_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e300/e300_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.EohSyncObj(5, "p01_train01")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "train08-m2")
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "train08-m3")
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_train01", "train10-m14")
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p01_train01", "train10-m15")
	event.ObjsSyncObj(9, 9)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 5)
	event.EohSetPos(0, -51.32, 36.0, -146.5)
	event.EohSetRot(0, 0.0, -1.57, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -44.65, 36.0, -161.3)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -60.0, 36.0, -154.54)
	event.EohSetRot(2, 0.0, -1.57, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFootSoundId(2, 6)
	event.EohSetPos(3, -175.26, 36.0, 107.7)
	event.EohSetRot(3, 0.0, 2.8, 0.0)
	event.EohSetPos(4, -133.94, 36.0, 163.59)
	event.EohSetRot(4, 0.0, -3.12, 0.0)
	event.EohSetPos(5, 0.0, 0.0, -4200.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetRot(8, 0.0, 0.0, 0.0)
	event.EohSetRot(9, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-305.89, 188.66, -811.58)
	event.CmrsSetRef(-260.09, 165.4, -1011.0)
	event.SetFadeIn(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 8)
	event.ObjsMove(5, 0.0, 0.0, -1000.0, 90)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-748.03, 60.33, -205.79)
	event.CmrsSetRef(-473.11, 63.96, -161.07)
	event.ObjsSetPos(5, 0.0, 0.0, 200.0)
	event.ObjsMove2(5, 0.0, 0.0, 400.0, 40, 2, 1.0)
	helper_c1c32f84(80)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 9)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(8, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(9, 0.0, -1.5, 0.0, 30)
	helper_2386f745(6)
	if vm.skipping() then
		return skip(5)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-256.14, 103.33, -318.65)
	event.CmrsSetRef(-109.39, 73.39, -128.41)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -104.57, 36.0, -146.0, 64)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -91.13, 36.0, -165.21, 60)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-4.55, 266.85, -23.64)
	event.CmrsSetRef(-51.16, 197.71, -66.4)
	event.CmrsMove2(102.69, 266.85, -24.93, -51.16, 197.71, -66.4, 60, 0, 1.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.ObjsMove(0, -170.81, 36.0, -146.0, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, -161.13, 36.0, -165.21, 90)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	helper_42c67f56(3000010)
	if vm.skipping() then
		return skip(9)
	end
	helper_42c67f56(3000020)
	if vm.skipping() then
		return skip(10)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-205.34, 64.3, -154.56)
	event.CmrsSetRef(-144.49, 53.0, -154.43)
	event.CharaActive(24)
	event.ObjsMove(2, -114.8, 36.0, -154.66, 40)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(2, 2)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(3000030)
	if vm.skipping() then
		return skip(13)
	end
	helper_2386f745(2)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(-210.94, 73.59, -232.54)
	event.CmrsSetRef(-148.67, 56.48, -130.25)
	event.CmrsMove2(-210.94, 73.59, -232.54, -180.15, 61.97, -107.65, 20, 2, 1.0)
	event.CharaActive(35)
	event.CharaActive(36)
	event.ObjsSetMotion(0, "右向く戻り", 6, 0.6)
	event.ObjsNextMotion(0, "左向く", 6, 0.6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSetMotion(3, "会話2", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "スコップ会話2", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotDelay(1, 10)
	event.ObjsRotation(1, 0.0, 0.35, 0.0, 10)
	event.ObjsMove(1, -193.42, 36.0, -145.41, 20)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsRotation(2, 0.0, -1.93, 0.0, 10)
	event.ObjsMove(2, -183.47, 36.0, -185.25, 60)
	event.ObjsRotDelay(2, 30)
	event.ObjsRotation(2, 0.0, -0.01, 0.0, 20)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	helper_42c67f56(3000040)
	if vm.skipping() then
		return skip(15)
	end
	helper_42c67f56(3000045)
	if vm.skipping() then
		return skip(16)
	end
	helper_2386f745(2)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-181.22, 61.67, -107.35)
	event.CmrsSetRef(-185.03, 54.04, -201.62)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.ObjsSetRot(0, 0.0, 0.2, 0.0)
	event.ObjsSetMotion(0, "手を振る", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(3000050)
	if vm.skipping() then
		return skip(18)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "回転左180度ＰＧ", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, 2.87, 0.0, 40)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(3000060)
	if vm.skipping() then
		return skip(22)
	end
	helper_2386f745(2)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-180.14, 58.52, -189.12)
	event.CmrsSetRef(-181.13, 55.77, -139.14)
	event.CharaActive(0, 24)
	event.CharaActive(0, 35)
	event.CharaActive(0, 36)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetRot(0, 0.0, -2.91, 0.0)
	event.ObjsSetMotion(0, "うなづく", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(3000070)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-117.6, 87.58, -155.8)
	event.CmrsSetRef(-248.36, 57.62, -155.82)
	event.CharaActive(24)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsRotation(2, 0.0, -1.09, 0.0, 20)
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 20)
	event.ObjsRotation(1, 0.0, -1.61, 0.0, 10)
	event.ObjsMove(1, -315.35, 0.0, -143.13, 52, 1)
	helper_c1c32f84(2)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 20)
	event.ObjsRotation(0, 0.0, -1.71, 0.0, 10)
	event.ObjsMove(0, -303.46, 0.0, -165.04, 50, 1)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(27)
	end
	event.SetFadeOut(20)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(28)
	end
	return part2()
end

--- Helper function.
local function helper_29a3c()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_2386f745(1)
			end
			if at <= 2 then
				helper_c1c32f84(10)
			end
			if at <= 3 then
				helper_c1c32f84(15)
			end
			if at <= 4 then
				helper_c1c32f84(10)
			end
			if at <= 5 then
				helper_2386f745(0)
			end
			if at <= 6 then
				helper_c1c32f84(10)
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
		event.EohSetFootSoundId(0, 0)
		event.EohSetPos(1, 0.0, 0.0, 400.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CharaActive(0)
		event.SetCharaPos(0, -130.0, 36.0, -154.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.CharaActive(1, 24)
		if flag == 0 then
			event.CharaActive(1, 25)
			event.CharaActive(1, 26)
		end
		event.SetCameraPos(-79.74, 70.2, -154.0)
		event.SetCameraRef(-130.0, 66.0, -154.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	flag = event.GetFlag(372) or flag
	event.CharaActive(0, 24)
	if flag == 0 then
		event.CharaActive(0, 25)
		event.CharaActive(0, 26)
	end
	var1 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var1
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 200.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(2, "p01_train01", "train08-m2")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "train08-m3")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "train10-m14")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "train10-m15")
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
	event.EohSetFootSoundId(0, 6)
	event.SndSePlay(var1, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-266.11, 272.22, 848.56)
	event.CmrsSetRef(124.54, -133.73, -212.03)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-211.1, 66.53, -316.91)
	event.CmrsSetRef(-87.12, 61.79, -127.67)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 66)
	event.CharaActive(0)
	event.ObjsSetPos(0, -41.0, 36.0, -154.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -130.0, 36.0, -154.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 2)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_28ab0()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2386f745(1)
		end
		if at <= 2 then
			helper_c1c32f84(10)
		end
		if at <= 3 then
			helper_c1c32f84(15)
		end
		if at <= 4 then
			helper_2386f745(0)
		end
		if at <= 5 then
			helper_c1c32f84(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.GetFlag(372) or flag
	event.CharaActive(0, 24)
	if flag == 0 then
		event.CharaActive(0, 25)
		event.CharaActive(0, 26)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m7")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 0.0, 0.0, 200.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsMove2(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(-266.11, 272.22, 848.56)
	event.CmrsSetRef(124.54, -133.73, -212.03)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-211.1, 66.53, -316.91)
	event.CmrsSetRef(-87.12, 61.79, -127.67)
	event.EohSetPos(1, 0.0, 0.0, 400.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -41.0, 36.0, -154.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 92)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -130.0, 36.0, -154.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 0.0, 0.0, 400.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(1, 24)
	if flag == 0 then
		event.CharaActive(1, 25)
		event.CharaActive(1, 26)
	end
	event.CharaActive(0)
	event.SetCharaPos(0, -130.0, 36.0, -154.0)
	event.SetCharaRot(0, 0.0, -1.57, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.SetCameraPos(-79.74, 70.2, -154.0)
	event.SetCameraRef(-130.0, 66.0, -154.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_1ce6c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(0, 1)
			return 0
		end
		if at <= 3 then
			helper_c1c32f84(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_377e162e(0, 4)
	event.MesMake_2(0, "Entrar\nSalir")
	var0 = helper_83f868da(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_377e162e(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_33054()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c1c32f84(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_27e14()
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
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_c1c32f84(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_a269bbe8(5, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(-1159.24, 92.09, 269.02)
		event.CmrsSetRef(-1327.31, 55.37, 161.26)
		event.ObjsSetPos(0, -1386.18, 24.63, 115.22)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, -1386.18, 29.63, 115.22)
		event.ObjsAddPas(0, -1421.37, 37.04, 89.07)
		event.ObjsAddPas(0, -1441.04, 44.13, 68.02)
		event.ObjsAddPas(0, -1454.41, 52.15, 47.35)
		event.ObjsAddPas(0, -1465.6, 61.13, 26.8)
		event.ObjsAddPas(0, -1475.99, 68.270004, 2.68)
		event.ObjsAddPas(0, -1483.7, 77.97, -24.81)
		event.ObjsStartPas(0)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_c1c32f84(30)
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
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(1.44)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(1.44)) * 30.0) + var3)
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
local function helper_3076c()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e372/e372_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e372/e372_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "chara/p01_03a.gltf", "info", 35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 35)
	event.LoadMes(0, 5, "event/e300/e372/e372_1.txt")
	event.SetStatus(1, global0, 256, 1)
	event.SetStatus(1, global1, 256, 1)
end

--- Helper function.
local function helper_304b8()
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
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(35)
end

--- Helper function.
local function helper_31564()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_2386f745(0)
			end
			if at <= 2 then
				helper_07cf3e45(3720500, 60)
			end
			if at <= 3 then
				helper_42c67f56(3720505)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		helper_304b8()
	end
	function part2()
		event.CancelDramaScene()
		if global0 == 0 then
			event.SetCharaPos(0, -155.54, 36.0, -140.71)
		else
			event.SetCharaPos(0, -153.89, 36.0, -159.09)
		end
		helper_304b8()
		event.CharaActive(1, 24)
		event.SetFadeIn(30)
	end
	event.CharaActive(0, 24)
	event.SetFlag(372, 1)
	event.Initialize()
	event.EohSyncObj(20, "p01_train01")
	event.EohSetPos(20, 0.0, 0.0, 400.0)
	helper_3076c()
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(49)
	event.PlayBgm(0)
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 35)
	event.CmrsSetPos(-940.17, 88.71, -222.08)
	event.CmrsSetRef(-788.53, 51.39, -202.38)
	event.ObjsSetPos(0, -802.48, 0.0, -185.61)
	event.ObjsSetRot(0, 0.0, 1.5, 0.0)
	event.ObjsSetPos(1, -799.79, 0.0, -228.07)
	event.ObjsSetRot(1, 0.0, 1.32, 0.0)
	event.ObjsSetPos(2, -126.08, 36.0, -149.46)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.SetFadeIn(15)
	event.ObjsSetMotion(0, "走り", 0)
	event.ObjsSetMotion(1, "走り", 0)
	event.ObjsMove(0, -647.07, 0.0, -165.42, 60)
	event.ObjsMove(1, -636.31, 0.0, -204.74, 60)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-243.89, 55.02, -207.96)
	event.CmrsSetRef(-152.87, 61.42, -156.97)
	event.ObjsSetPos(0, -207.98, 36.0, -142.65)
	event.ObjsSetRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetPos(1, -209.43, 36.0, -161.14)
	event.ObjsSetRot(1, 0.0, 1.56, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsMove(0, -155.54, 36.0, -140.71, 75)
	event.ObjsMove(1, -153.89, 36.0, -159.09, 75)
	event.SetPakuAnim(2, "口パク")
	helper_07cf3e45(3720500, 60)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsSetPos(-196.14, 62.27, -152.87)
	event.CmrsSetRef(-156.04, 61.42, -151.29)
	event.ObjsSetPos(0, -155.54, 36.0, -140.71)
	event.ObjsSetRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetPos(1, -153.89, 36.0, -159.09)
	event.ObjsSetRot(1, 0.0, 1.56, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(3720505)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_251c0()
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
				helper_daa89e49(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_83f868da(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_daa89e49(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_0d345d12(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_540c04ee(var17, 1)
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
		helper_377e162e(0, 1)
		var9 = helper_dda46917(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "[UNI00bf]Quieres salir?")
		helper_daa89e49(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "[UNI00a1]Vale!\nMe quedo un poco m[UNI00e1]s.")
		var11 = helper_83f868da(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "Umm. [UNI00a1]A por ellos! [UNI00bf]Me oyes?")
			helper_daa89e49(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_0d345d12(var0, var9, 0, 0)
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
		helper_377e162e(0, 1)
		event.MesMake_2(0, "Tened mucho cuidado por ah[UNI00ed], vosotros dos.")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "Todav[UNI00ed]a no estamos listos...\nDame un poco m[UNI00e1]s de tiempo.")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "Todav[UNI00ed]a no estamos listos...\nDame un poco m[UNI00e1]s de tiempo.")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "Todav[UNI00ed]a no estamos listos...\nDame un poco m[UNI00e1]s de tiempo.")
		end
		helper_87aa4a59(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_540c04ee(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_32800()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_c1c32f84(45)
			end
			if at <= 2 then
				helper_42c67f56(3600010)
			end
			if at <= 3 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	event.SetFlag(360, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.ChangeDir("event/e300/e360/")
	event.LoadMes(0, 5, "e360_1.txt")
	event.LoadChara(5, "e360_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.CharaActive(0, 0)
	event.CharaActive(0, 24)
	event.EohSetPos(2, -145.89, 36.0, -6.26)
	event.EohSetRot(2, 0.0, -1.58, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-189.99, 47.8, 29.79)
	event.CmrsSetRef(-106.32, 74.01, -26.32)
	event.CharaActive(34)
	event.SetFadeIn(30)
	event.StopBgm(0)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(3600010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_2aeec()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_269c0()
				helper_c1c32f84(30)
			end
			if at <= 3 then
				helper_2386f745(0)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(6)
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
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(3223)
	var0 = event.SndLoadSound(3223) or var0
	event.CharaActive(0, 0)
	event.CharaActive(0, 24)
	event.CharaActive(0, 25)
	event.CharaActive(0, 26)
	helper_269c0()
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
	event.CmrsSetPos(-251.99, 110.91, -251.89)
	event.CmrsSetRef(-151.44, 89.18, -3.01)
	event.SetFadeIn(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
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
	event.SndSePlay(var0, 0)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_246ac()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(0, 1)
			helper_87aa4a59(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_540c04ee(var4, 2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_377e162e(0, 1)
		event.MesMake_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(448) or flag
		if var2 == 4 and flag == 0 then
			event.MesMake_2(
				0,
				"[UNI00a1]Ning[UNI00fa]n puente ni carretera\nest[UNI00e1] abierto! [UNI00bf]Qu[UNI00e9]\npensabas? Pero bueno..."
			)
		end
		if var2 == 3 then
			event.MesMake_2(
				0,
				"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
			)
		end
		helper_87aa4a59(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_540c04ee(var4, 2)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_24b68()
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
			helper_377e162e(0, 1)
			helper_87aa4a59(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_540c04ee(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_377e162e(0, 1)
		event.MesMake_2(
			0,
			"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
		)
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(280) or flag
		if var2 == 2 and flag == 0 then
			event.MesMake_2(0, "Con una Bomba final\nmandamos esta roca\na paseo.")
		end
		flag_2 = event.GetFlag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.MesMake_2(
				0,
				"Mucho ojo, porque las explosiones\nno son ning[UNI00fa]n juego. Un peque[UNI00f1]o error y\nechas abajo toda la casa. "
			)
		end
		flag_3 = event.GetFlag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.MesMake_2(0, "Soy experto en demoliciones,\npero cuando se trata de reparaciones\nsoy un manazas.")
		end
		helper_87aa4a59(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_540c04ee(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_26120()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(0, 1)
			helper_87aa4a59(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_377e162e(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Te esperar[UNI00e9] aqu[UNI00ed].\nEspero que salga todo bien.")
	else
		event.MesMake_2(0, "Esperar[UNI00e9] aqu[UNI00ed].\nEnc[UNI00e1]rgate de [UNI00e9]l.")
	end
	helper_87aa4a59(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
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
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	local landing3: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2bd2c()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_27278()
			helper_29a3c()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 3 then
			helper_28ab0()
		end
		if at <= 4 then
			helper_5203c0f2()
			helper_29a3c()
			if not vm.skipping() then
				return landing3()
			end
		end
		if at <= 5 then
			helper_28ab0()
		end
		print("------  <START EVENT> OLD MAP ERR   ------\n")
	end
	function part2() end
	function landing1()
		helper_27278()
		event.SetAi(1, 24)
		event.SetAi(1, 25)
		event.SetAi(1, 26)
		return part2()
	end
	function landing2()
		event.CharaActive(25)
		return part2()
	end
	function landing3()
		return part2()
	end
	helper_27608()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -357.0, 0.0, -206.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 1 then
				helper_277a8()
				if vm.skipping() then
					return skip(1)
				end
			elseif old_map_no ~= 18 and old_map_no ~= 23 and old_map_no ~= 120 and old_map_no ~= 108 then
				flag = event.GetFlag(283) or flag
				flag_2 = event.GetFlag(300) or flag_2
				if flag == 1 and flag_2 == 0 then
					event.SetAi(0, 24)
					event.SetAi(0, 25)
					event.SetAi(0, 26)
					helper_2bd2c()
					if vm.skipping() then
						return skip(2)
					end
					helper_27278()
					event.SetAi(1, 24)
					event.SetAi(1, 25)
					event.SetAi(1, 26)
				else
					event.CharaActive(0, 25)
					var5 = event.GetChapter() or var5
					if var5 ~= 6 and var5 ~= 7 then
						helper_29a3c()
						if vm.skipping() then
							return skip(3)
						end
					else
						helper_28ab0()
						if vm.skipping() then
							return skip(4)
						end
					end
					event.CharaActive(25)
				end
			else
				var6 = event.GetCnt(1) or var6
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var6 == 3 then
					helper_5203c0f2()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var7 = event.GetChapter() or var7
					if var7 ~= 6 and var7 ~= 7 then
						helper_29a3c()
						if vm.skipping() then
							return skip(5)
						end
					else
						helper_28ab0()
						if vm.skipping() then
							return skip(6)
						end
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
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f70f976(64)
		end
		if at <= 3 then
			helper_6f70f976(64)
		end
	end
	event.Initialize()
	var0 = event.SndLoadSound(3200) or var0
	if vm.wait() then
		return skip(1)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 8)
	if vm.wait() then
		return skip(3)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(4)
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
			helper_d8b0d636()
		end
		if at <= 6 then
			helper_e44d9fc7(0)
		end
		if at <= 7 then
			helper_2084e5f4()
		end
	end
	var0 = helper_1ce6c()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 3)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_d8b0d636()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_d8b0d636()
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
		helper_e44d9fc7(0)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_2084e5f4()
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
	helper_33054()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_27e14()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "g02", 100)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27608()
	helper_31564()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_27278()
	end
	helper_0c718064(3)
	helper_27608()
	event.SetAi(0, 24)
	event.SetAi(0, 25)
	event.SetAi(0, 26)
	helper_2bd2c()
	if vm.skipping() then
		return skip(1)
	end
	helper_27278()
	event.SetAi(1, 24)
	event.SetAi(1, 25)
	event.SetAi(1, 26)
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
			helper_32800()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_2aeec()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 4 then
			helper_246ac()
		end
		if at <= 5 then
			helper_24b68()
		end
		if at <= 6 then
			helper_26120()
		end
	end
	function part2()
		if var0 == 2 then
			helper_246ac()
			if vm.skipping() then
				return skip(5)
			end
		end
		if var0 == 13 then
			helper_24b68()
			if vm.skipping() then
				return skip(6)
			end
		end
		if var0 == 301 then
			helper_26120()
			if vm.skipping() then
				return skip(7)
			end
		end
	end
	function landing1()
		helper_2aeec()
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 8)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s09")
		return part2()
	end
	function landing2()
		event.GotoMenu(13, 8)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s09")
		return part2()
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		var1 = helper_251c0()
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			helper_32800()
			if vm.skipping() then
				return skip(2)
			end
			helper_2aeec()
			if vm.skipping() then
				return skip(3)
			end
			event.GotoMenu(13, 8)
			if vm.wait() then
				return skip(4)
			end
			event.MapJump(-1, "s09")
		end
	end
	return part2()
end

--- Program 13000.
script[13000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_27278()
	end
	helper_27608()
	event.SetAi(0, 24)
	event.SetAi(0, 25)
	event.SetAi(0, 26)
	helper_2bd2c()
	if vm.skipping() then
		return skip(1)
	end
	helper_27278()
	event.SetAi(1, 24)
	event.SetAi(1, 25)
	event.SetAi(1, 26)
end

--- Program 13600.
script[13600] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2aeec()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.GotoMenu(13, 8)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s09")
	end
	helper_27608()
	helper_32800()
	if vm.skipping() then
		return skip(1)
	end
	helper_2aeec()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
