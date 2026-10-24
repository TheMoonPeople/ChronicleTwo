--!strict
-- map/s/s04/s04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0695b715 = require("@lib/event/helper_0695b715")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_1537d275 = require("@lib/event/helper_1537d275")
local helper_23a302d6 = require("@lib/event/helper_23a302d6")
local helper_23ac133f = require("@lib/event/helper_23ac133f")
local helper_3a9ba306 = require("@lib/event/helper_3a9ba306")
local helper_3c965b5b = require("@lib/event/helper_3c965b5b")
local helper_42b7a2cf = require("@lib/event/helper_42b7a2cf")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_5b643440 = require("@lib/event/helper_5b643440")
local helper_7cc2d5a1 = require("@lib/event/helper_7cc2d5a1")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")
local helper_9538e344 = require("@lib/event/helper_9538e344")
local helper_ad3cd17a = require("@lib/event/helper_ad3cd17a")
local helper_c746120b = require("@lib/event/helper_c746120b")
local helper_ec8cddc5 = require("@lib/event/helper_ec8cddc5")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_f830()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01", "train02-a0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a1")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a2")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a3")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a4")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a5")
	event.EohSetShow(0, 0)
end

--- Helper function.
local function helper_257c4()
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
local function helper_2607c()
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
local function helper_2640c()
	local var0: s32 = 0
	var0 = event.GetChapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		helper_ad3cd17a()
	else
		helper_4337dd96()
	end
	helper_f830()
	helper_257c4()
	helper_23ac133f()
	helper_2607c()
end

--- Helper function.
local function helper_265ac()
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
local function helper_2ac28()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 28 then
			if at <= 1 then
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_c746120b(90)
			end
			if at <= 3 then
				helper_c746120b(80)
			end
			if at <= 4 then
				helper_5b643440(6)
			end
			if at <= 5 then
				helper_c746120b(10)
			end
			if at <= 6 then
				helper_c746120b(4)
			end
			if at <= 7 then
				helper_c746120b(60)
			end
			if at <= 8 then
				helper_42b7a2cf(3000010)
			end
			if at <= 9 then
				helper_42b7a2cf(3000020)
			end
			if at <= 10 then
				helper_5b643440(1)
			end
			if at <= 11 then
				helper_c746120b(10)
			end
			if at <= 12 then
				helper_42b7a2cf(3000030)
			end
			if at <= 13 then
				helper_5b643440(2)
			end
			if at <= 14 then
				helper_42b7a2cf(3000040)
			end
			if at <= 15 then
				helper_42b7a2cf(3000045)
			end
			if at <= 16 then
				helper_5b643440(2)
			end
			if at <= 17 then
				helper_42b7a2cf(3000050)
			end
			if at <= 18 then
				helper_5b643440(0)
			end
			if at <= 19 then
				helper_c746120b(4)
			end
			if at <= 20 then
				helper_c746120b(40)
			end
			if at <= 21 then
				helper_42b7a2cf(3000060)
			end
			if at <= 22 then
				helper_5b643440(2)
			end
			if at <= 23 then
				helper_c746120b(4)
			end
			if at <= 24 then
				helper_42b7a2cf(3000070)
			end
			if at <= 25 then
				helper_c746120b(2)
			end
			if at <= 26 then
				helper_c746120b(30)
			end
			if at <= 27 then
				helper_c746120b(20)
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
	event.LoadMes(0, 5, "e300.txt")
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
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 8)
	event.ObjsMove(5, 0.0, 0.0, -1000.0, 90)
	helper_c746120b(90)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-748.03, 60.33, -205.79)
	event.CmrsSetRef(-473.11, 63.96, -161.07)
	event.ObjsSetPos(5, 0.0, 0.0, 200.0)
	event.ObjsMove2(5, 0.0, 0.0, 400.0, 40, 2, 1.0)
	helper_c746120b(80)
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
	helper_5b643440(6)
	if vm.skipping() then
		return skip(5)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-256.14, 103.33, -318.65)
	event.CmrsSetRef(-109.39, 73.39, -128.41)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -104.57, 36.0, -146.0, 64)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -91.13, 36.0, -165.21, 60)
	helper_c746120b(60)
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
	helper_42b7a2cf(3000010)
	if vm.skipping() then
		return skip(9)
	end
	helper_42b7a2cf(3000020)
	if vm.skipping() then
		return skip(10)
	end
	helper_5b643440(1)
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
	helper_c746120b(10)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(2, 2)
	event.SetPakuAnim(2, "口パク")
	helper_42b7a2cf(3000030)
	if vm.skipping() then
		return skip(13)
	end
	helper_5b643440(2)
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
	helper_42b7a2cf(3000040)
	if vm.skipping() then
		return skip(15)
	end
	helper_42b7a2cf(3000045)
	if vm.skipping() then
		return skip(16)
	end
	helper_5b643440(2)
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
	helper_42b7a2cf(3000050)
	if vm.skipping() then
		return skip(18)
	end
	helper_5b643440(0)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "回転左180度ＰＧ", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, 2.87, 0.0, 40)
	helper_c746120b(40)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_42b7a2cf(3000060)
	if vm.skipping() then
		return skip(22)
	end
	helper_5b643440(2)
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
	helper_c746120b(4)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42b7a2cf(3000070)
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
	helper_c746120b(2)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 20)
	event.ObjsRotation(0, 0.0, -1.71, 0.0, 10)
	event.ObjsMove(0, -303.46, 0.0, -165.04, 50, 1)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(27)
	end
	event.SetFadeOut(20)
	helper_c746120b(20)
	if vm.skipping() then
		return skip(28)
	end
	return part2()
end

--- Helper function.
local function helper_28938()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_5b643440(1)
			end
			if at <= 2 then
				helper_c746120b(10)
			end
			if at <= 3 then
				helper_c746120b(15)
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_5b643440(0)
			end
			if at <= 6 then
				helper_c746120b(10)
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
	helper_5b643440(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c746120b(10)
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
	helper_c746120b(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -130.0, 36.0, -154.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 2)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_c746120b(10)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_279ac()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5b643440(1)
		end
		if at <= 2 then
			helper_c746120b(10)
		end
		if at <= 3 then
			helper_c746120b(15)
		end
		if at <= 4 then
			helper_5b643440(0)
		end
		if at <= 5 then
			helper_c746120b(10)
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
	helper_5b643440(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c746120b(10)
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
	helper_c746120b(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -130.0, 36.0, -154.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c746120b(10)
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
local function helper_1a868(arg0: s32, arg1: s32, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
		var3 = -220.0
		var4 = vm.f32(35.8)
		var5 = vm.f32(-1570.4)
		var6 = vm.f32(-1.57)
		var5 = vm.f32(-1251.8)
		var5 = vm.f32(-737.4)
		var5 = vm.f32(-219.7)
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		var5 = 150.0
		var5 = -365.0
		var5 = -880.0
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		var5 = vm.f32(-9.6)
		var5 = -526.5
		var5 = vm.f32(-1042.8)
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		var3 = vm.f32(-1472.9)
		var3 = vm.f32(-1993.4)
		var3 = -2506.0
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		var3 = 2370.0
		var5 = 1610.0
		var3 = 2037.0
		var5 = 2000.0
		var3 = 1694.0
		var5 = 2389.0
		var3 = 690.0
		var3 = vm.f32(347.8)
		var3 = vm.f32(-168.4)
		var3 = -687.5
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
		var3 = 590.0
		var3 = 240.0
		var3 = -270.0
		var3 = -790.0
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if vm.skipping() then
		return skip(1)
	end
	print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
	var3 = -220.0
	var4 = vm.f32(35.8)
	var5 = vm.f32(-1570.4)
	var6 = vm.f32(-1.57)
	if arg1 == 1 then
		var5 = vm.f32(-1251.8)
	end
	if arg1 == 2 then
		var5 = vm.f32(-737.4)
	end
	if arg1 == 3 then
		var5 = vm.f32(-219.7)
	end
	if arg0 == 2 then
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		if arg1 == 1 then
			var5 = 150.0
		end
		if arg1 == 2 then
			var5 = -365.0
		end
		if arg1 == 3 then
			var5 = -880.0
		end
	end
	if arg0 == 3 then
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		if arg1 == 1 then
			var5 = vm.f32(-9.6)
		end
		if arg1 == 2 then
			var5 = -526.5
		end
		if arg1 == 3 then
			var5 = vm.f32(-1042.8)
		end
	end
	if arg0 == 4 then
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		if arg1 == 1 then
			var3 = vm.f32(-1472.9)
		end
		if arg1 == 2 then
			var3 = vm.f32(-1993.4)
		end
		if arg1 == 3 then
			var3 = -2506.0
		end
	end
	if arg0 == 5 then
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		if arg1 == 1 then
			var3 = 2370.0
			var5 = 1610.0
		end
		if arg1 == 2 then
			var3 = 2037.0
			var5 = 2000.0
		end
		if arg1 == 3 then
			var3 = 1694.0
			var5 = 2389.0
		end
	end
	if arg0 == 6 then
		var3 = 690.0
		if arg1 == 2 then
			var3 = vm.f32(347.8)
		end
		if arg1 == 2 then
			var3 = vm.f32(-168.4)
		end
		if arg1 == 3 then
			var3 = -687.5
		end
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 7 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 8 then
		var3 = 590.0
		if arg1 == 1 then
			var3 = 240.0
		end
		if arg1 == 2 then
			var3 = -270.0
		end
		if arg1 == 3 then
			var3 = -790.0
		end
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 9 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	event.SetCharaPos(0, var3, var4, var5)
	event.SetCharaRot(0, 0.0, var6, 0.0)
end

--- Helper function.
local function helper_1c028()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_1a868(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_1a868(var0, var1, var2)
end

--- Helper function.
local function helper_1c96c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(0, 1)
			return 0
		end
		if at <= 3 then
			helper_c746120b(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_7ee99e81(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_0695b715(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_7ee99e81(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_127ac()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = vm.f32(-3.1415927)
			helper_c746120b(10)
		end
		if at <= 2 then
			helper_c746120b(20)
		end
		if at <= 3 then
			helper_c746120b(18)
		end
		if at <= 4 then
			helper_c746120b(12)
		end
		if at <= 5 then
			helper_c746120b(30)
		end
		if at <= 6 then
			helper_c746120b(10)
		end
		if at <= 7 then
			helper_c746120b(20)
		end
		if at <= 8 then
			helper_c746120b(18)
		end
		if at <= 9 then
			helper_c746120b(12)
		end
		if at <= 10 then
			helper_c746120b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var8 = event.GetSndId(1) or var8
	var7 = event.GetEventData_2(3) or var7
	event.GetEventData_2(4)
	event.Ext(1035, 8, var0, var1, var2, var6) -- retail: the handler rejects 5 arguments
	event.SetWorldCoord(var0, var1, var2, var6)
	if vm.imod(var7, 2) ~= 1 then
		var6 = vm.f32(-3.1415927)
	end
	if var7 == 0 then
		event.EohSyncObj(1, "p01_train01", "train11-m0")
		event.EohSyncObj(2, "p01_train01", "train12-m0")
		event.EohSyncObj(3, "p01_train01", "train12-m2")
		event.SetCnt(0, 0)
	end
	if var7 == 1 then
		event.EohSyncObj(1, "p01_train01", "train11-m1")
		event.EohSyncObj(2, "p01_train01", "train12-m1")
		event.EohSyncObj(3, "p01_train01", "train12-m3")
		event.SetCnt(0, 0)
	end
	var8 = event.GetSndId(2) or var8
	event.SndSePlay(var8, 66)
	if vm.imod(var7, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -14.25, 1.38, 0.55)
		event.ObjsSetRot(0, 0.0, -1.5, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 22.53, -74.18)
		event.CmrsSetRef(-3.0, 27.21, 0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 3)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(6)
		end
		event.EohSetMotion(0, "歩き", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 14.25, 1.38, -0.55)
		event.ObjsSetRot(0, 0.0, -4.641593, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 22.53, 74.18)
		event.CmrsSetRef(3.0, 27.21, -0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 3)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(11)
		end
		event.EohSetMotion(0, "歩き", 4)
	end
	event.SetMotion(0, "立ち", 4)
	if vm.imod(var7, 2) ~= 1 then
		event.SetCharaPos(0, 47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_13efc(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var14: s32 = 0
	local now_map_no: s32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("train_id=", var11, "----------------\n")
			print("fpos[0]=", string.format("%f", var1), "---------------\n")
			print("fpos[1]=", string.format("%f", var2), "---------------\n")
			print("fpos[2]=", string.format("%f", var3), "---------------\n")
			print("train_id=", var11, "---------------\n")
			var4 = vm.f32(5.51)
			var5 = vm.f32(19.05)
			var6 = vm.f32(19.05)
			var14 = 6
			var4 = 19.75
			var5 = 19.75
			var6 = 19.75
			var14 = 2
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			var14 = 3
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
			var7 = vm.f32(-3.1415927)
			helper_c746120b(10)
		end
		if at <= 2 then
			helper_c746120b(20)
		end
		if at <= 3 then
			helper_c746120b(18)
		end
		if at <= 4 then
			helper_c746120b(12)
		end
		if at <= 5 then
			helper_c746120b(30)
		end
		if at <= 6 then
			helper_c746120b(10)
		end
		if at <= 7 then
			helper_c746120b(20)
		end
		if at <= 8 then
			helper_c746120b(18)
		end
		if at <= 9 then
			helper_c746120b(12)
		end
		if at <= 10 then
			helper_c746120b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.GetSndId(1)
	var11 = event.GetEventData_2(3) or var11
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var7) -- retail: the handler rejects 5 arguments
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", string.format("%f", var1), "---------------\n")
	print("fpos[1]=", string.format("%f", var2), "---------------\n")
	print("fpos[2]=", string.format("%f", var3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	event.SetWorldCoord(var1, var2, var3, var7)
	event.EohSyncObj(0, "p01_train01")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg0 ~= 0 then
		var4 = vm.f32(5.51)
		var5 = vm.f32(19.05)
		var6 = vm.f32(19.05)
		var14 = 6
	else
		var4 = 19.75
		var5 = 19.75
		var6 = 19.75
		var14 = 2
		now_map_no = event.GetNowMapNo() or now_map_no
		if now_map_no == 83 then
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			event.EohSetPos(0, pos_x, pos_y - 2.0, pos_z)
			var14 = 3
		end
		if now_map_no == 54 then
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
		end
	end
	if vm.imod(var11, 2) ~= 1 then
		var7 = vm.f32(-3.1415927)
	end
	if var11 == 2 then
		event.EohSyncObj(1, "p01_train01", "train08-m0")
		event.EohSyncObj(2, "p01_train01", "train08-m1")
		event.EohSyncObj(3, "p01_train01", "train10-m0")
		event.EohSyncObj(4, "p01_train01", "train10-m1")
		event.EohSyncObj(5, "p01_train01", "train10-m12")
		event.EohSyncObj(6, "p01_train01", "train10-m13")
		event.SetCnt(0, 1)
	end
	if var11 == 3 then
		event.EohSyncObj(1, "p01_train01", "train08-m2")
		event.EohSyncObj(2, "p01_train01", "train08-m3")
		event.EohSyncObj(3, "p01_train01", "train10-m3")
		event.EohSyncObj(4, "p01_train01", "train10-m2")
		event.EohSyncObj(5, "p01_train01", "train10-m15")
		event.EohSyncObj(6, "p01_train01", "train10-m14")
		event.SetCnt(0, 1)
	end
	if var11 == 4 then
		event.EohSyncObj(1, "p01_train01", "train08-m4")
		event.EohSyncObj(2, "p01_train01", "train08-m5")
		event.EohSyncObj(3, "p01_train01", "train10-m4")
		event.EohSyncObj(4, "p01_train01", "train10-m5")
		event.EohSyncObj(5, "p01_train01", "train10-m16")
		event.EohSyncObj(6, "p01_train01", "train10-m17")
		event.SetCnt(0, 2)
	end
	if var11 == 5 then
		event.EohSyncObj(1, "p01_train01", "train08-m6")
		event.EohSyncObj(2, "p01_train01", "train08-m7")
		event.EohSyncObj(3, "p01_train01", "train10-m6")
		event.EohSyncObj(4, "p01_train01", "train10-m7")
		event.EohSyncObj(5, "p01_train01", "train10-m18")
		event.EohSyncObj(6, "p01_train01", "train10-m19")
		event.SetCnt(0, 2)
	end
	if var11 == 6 then
		event.EohSyncObj(1, "p01_train01", "train08-m8")
		event.EohSyncObj(2, "p01_train01", "train08-m9")
		event.EohSyncObj(3, "p01_train01", "train10-m8")
		event.EohSyncObj(4, "p01_train01", "train10-m9")
		event.EohSyncObj(5, "p01_train01", "train10-m20")
		event.EohSyncObj(6, "p01_train01", "train10-m21")
		event.SetCnt(0, 3)
	end
	if var11 == 7 then
		event.EohSyncObj(1, "p01_train01", "train08-m10")
		event.EohSyncObj(2, "p01_train01", "train08-m11")
		event.EohSyncObj(3, "p01_train01", "train10-m10")
		event.EohSyncObj(4, "p01_train01", "train10-m11")
		event.EohSyncObj(5, "p01_train01", "train10-m22")
		event.EohSyncObj(6, "p01_train01", "train10-m23")
		event.SetCnt(0, 3)
	end
	var16 = event.GetSndId(2) or var16
	event.SndSePlay(var16, 66)
	if vm.imod(var11, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 12.08, var4, 0.42)
		event.ObjsSetRot(0, 0.0, -1.5015928, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 46.06, -74.18)
		event.CmrsSetRef(-3.0, 50.74, 0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 4)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(6)
		end
		event.EohSetMotion(0, "立ち", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -12.08, var4, -0.42)
		event.ObjsSetRot(0, 0.0, 1.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 46.06, 74.18)
		event.CmrsSetRef(3.0, 50.74, -0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 4)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(11)
		end
		event.EohSetMotion(0, "立ち", 4)
	end
	if vm.imod(var11, 2) ~= 1 then
		event.SetCharaPos(0, 65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSyncObj(0, "p01_train01")
	event.EohSetPos(0, pos_x, pos_y, pos_z)
end

--- Helper function.
local function helper_16eac()
	local now_map_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("train_id=", var5, "----------------\n")
			print("fpos[0]=", string.format("%f", var1), "---------------\n")
			print("fpos[1]=", string.format("%f", var2), "---------------\n")
			print("fpos[2]=", string.format("%f", var3), "---------------\n")
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(3.1415927)
			var8 = vm.f32(2.3561945)
			var8 = vm.f32(1.5707964)
			var9 = 0
			var9 = 1
			var14 = 0.0
			var15 = 46.0
			var14 = vm.f32(35.8)
			var14 = vm.f32(-7.86)
			var14 = 36.0
			var14 = vm.f32(29.22)
			var14 = -6.0
			var14 = vm.f32(-13.87)
			var15 = 30.0
			var14 = vm.f32(0.09)
			var15 = 30.0
			var14 = vm.f32(0.09)
			var15 = 30.0
			var14 = vm.f32(0.09)
			helper_c746120b(10)
		end
		if at <= 2 then
			helper_c746120b(20)
		end
		if at <= 3 then
			helper_c746120b(30)
		end
		if at <= 4 then
			helper_c746120b(20)
		end
		if at <= 5 then
			helper_c746120b(10)
		end
		if at <= 6 then
			helper_c746120b(20)
		end
		if at <= 7 then
			helper_c746120b(30)
		end
		if at <= 8 then
			helper_c746120b(20)
		end
		if at <= 9 then
			helper_c746120b(10)
		end
		if at <= 10 then
			var16 = 0
			print("てつのあしおと\n")
			var16 = 6
			print("いしのあしおと\n")
			var16 = 2
			helper_c746120b(30)
		end
		if at <= 11 then
			helper_c746120b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	now_map_no = event.GetNowMapNo() or now_map_no
	event.Initialize()
	event.GetSndId(1)
	var5 = event.GetEventData_2(3) or var5
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	print("train_id=", var5, "----------------\n")
	print("fpos[0]=", string.format("%f", var1), "---------------\n")
	print("fpos[1]=", string.format("%f", var2), "---------------\n")
	print("fpos[2]=", string.format("%f", var3), "---------------\n")
	if var3 < 4500.0 then
		var8 = vm.f32(1.5707964)
	else
		var8 = vm.f32(-1.5707964)
	end
	if now_map_no == 76 then
		if var3 < 3600.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
	end
	if now_map_no == 72 then
		if var3 < 4500.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
	end
	if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
		var8 = vm.f32(3.1415927)
	end
	if now_map_no == 87 then
		var8 = vm.f32(2.3561945)
	end
	if now_map_no == 83 or now_map_no == 103 then
		var8 = vm.f32(1.5707964)
	end
	event.SetWorldCoord(var1, var2, var3, var8)
	var9 = 0
	if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
		var9 = 1
	end
	if var5 == 4 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		event.SetCnt(0, 1)
	end
	if var5 == 5 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m7")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		event.SetCnt(0, 1)
	end
	if var5 == 2 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m3")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		event.SetCnt(0, 2)
	end
	if var5 == 3 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m11")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		event.SetCnt(0, 2)
	end
	if var5 == 6 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m5")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m8")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		event.SetCnt(0, 3)
	end
	if var5 == 7 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m4")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m9")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
		event.SetCnt(0, 3)
	end
	var10 = event.GetSndId(2) or var10
	event.SndSePlay(var10, 92)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	var14 = 0.0
	var15 = 46.0
	if now_map_no == 34 then
		var14 = vm.f32(35.8)
	end
	if now_map_no == 16 then
		var14 = vm.f32(-7.86)
	end
	if now_map_no == 54 then
		var14 = 36.0
	end
	if now_map_no == 83 then
		var14 = vm.f32(29.22)
	end
	if now_map_no == 87 then
		var14 = -6.0
	end
	if now_map_no == 103 then
		var14 = vm.f32(-13.87)
	end
	if now_map_no == 72 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	if now_map_no == 76 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	if now_map_no == 155 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	event.ObjsSetPos(0, var15, var14, 0.0)
	event.ObjsSetRot(0, 0.0, -1.5707964, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(148.0, 23.45, -118.4)
	event.CmrsSetRef(5.11, 26.65, 8.6)
	if now_map_no == 34 or now_map_no == 54 then
		event.CmrsSetPos(106.46, 47.9, -133.32)
		event.CmrsSetRef(5.11, 77.95, 8.6)
	end
	if now_map_no == 83 then
		event.CmrsSetPos(148.0, 35.52, -118.4)
		event.CmrsSetRef(5.11, 77.95, 8.6)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_c746120b(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_c746120b(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_c746120b(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_c746120b(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_c746120b(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_c746120b(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_c746120b(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_c746120b(10)
				if vm.skipping() then
					return skip(10)
				end
			end
		end
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -50.0, 30.0, 0.0, 45)
	var16 = 0
	if
		now_map_no == 16
		or now_map_no == 83
		or now_map_no == 87
		or now_map_no == 103
		or now_map_no == 72
		or now_map_no == 76
		or now_map_no == 155
	then
		print("てつのあしおと\n")
		var16 = 6
	end
	if now_map_no == 34 or now_map_no == 54 then
		print("いしのあしおと\n")
		var16 = 2
	end
	event.EohSetFootSoundId(0, var16)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSetMotion(0, "立ち", 4)
	if vm.imod(var5, 2) ~= 1 then
		event.SetCharaPos(0, 50.0, -14.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -50.0, -14.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
end

--- Helper function.
local function helper_31f50()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c746120b(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_26be8()
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
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_c746120b(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『てんびん谷』に移動しますか？")
	var0 = helper_0695b715(0, -1, 8, 256, 208, 2, 1)
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
		helper_c746120b(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
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
local function helper_2f668()
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
	event.LoadMes(0, 5, "event/e300/e372/e372.txt")
	event.SetStatus(1, global0, 256, 1)
	event.SetStatus(1, global1, 256, 1)
end

--- Helper function.
local function helper_2f3b4()
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
local function helper_30460()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_5b643440(0)
			end
			if at <= 2 then
				helper_9538e344(3720500, 60)
			end
			if at <= 3 then
				helper_42b7a2cf(3720505)
			end
			if at <= 4 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		helper_2f3b4()
	end
	function part2()
		event.CancelDramaScene()
		if global0 == 0 then
			event.SetCharaPos(0, -155.54, 36.0, -140.71)
		else
			event.SetCharaPos(0, -153.89, 36.0, -159.09)
		end
		helper_2f3b4()
		event.CharaActive(1, 24)
		event.SetFadeIn(30)
	end
	event.CharaActive(0, 24)
	event.SetFlag(372, 1)
	event.Initialize()
	event.EohSyncObj(20, "p01_train01")
	event.EohSetPos(20, 0.0, 0.0, 400.0)
	helper_2f668()
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.StopBgm(0)
	helper_c746120b(4)
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
	helper_5b643440(0)
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
	helper_9538e344(3720500, 60)
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
	helper_42b7a2cf(3720505)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_24074()
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
				helper_ec8cddc5(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_0695b715(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_ec8cddc5(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_3c965b5b(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_3a9ba306(var17, 1)
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
		helper_7ee99e81(0, 1)
		var9 = helper_7cc2d5a1(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "出発するか？")
		helper_ec8cddc5(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "うん！\nもう少しここにいるよ。")
		var11 = helper_0695b715(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "うむ、しっかりがんばるんじゃぞ。")
			helper_ec8cddc5(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_3c965b5b(var0, var9, 0, 0)
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
		helper_7ee99e81(0, 1)
		event.MesMake_2(0, "二人とも気をつけてな。")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		helper_1537d275(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_3a9ba306(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_316fc()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_c746120b(45)
			end
			if at <= 2 then
				helper_42b7a2cf(3600010)
			end
			if at <= 3 then
				helper_c746120b(30)
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
	event.LoadMes(0, 5, "e360.txt")
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
	helper_c746120b(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42b7a2cf(3600010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_29de8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_257c4()
				helper_c746120b(30)
			end
			if at <= 3 then
				helper_5b643440(0)
			end
			if at <= 4 then
				helper_c746120b(30)
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
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(3223)
	var0 = event.SndLoadSound(3223) or var0
	event.CharaActive(0, 0)
	event.CharaActive(0, 24)
	event.CharaActive(0, 25)
	event.CharaActive(0, 26)
	helper_257c4()
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
	helper_c746120b(30)
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
	helper_5b643440(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_23590()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(0, 1)
			helper_1537d275(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_3a9ba306(var4, 2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_7ee99e81(0, 1)
		event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(448) or flag
		if var2 == 4 and flag == 0 then
			event.MesMake_2(
				0,
				"線路や橋がめちゃくちゃじゃねえか。\nひでぇことしやがるぜ、まったく・・・"
			)
		end
		if var2 == 3 then
			event.MesMake_2(
				0,
				"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
			)
		end
		helper_1537d275(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_3a9ba306(var4, 2)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_23a3c()
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
			helper_7ee99e81(0, 1)
			helper_1537d275(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_3a9ba306(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_7ee99e81(0, 1)
		event.MesMake_2(
			0,
			"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
		)
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(280) or flag
		if var2 == 2 and flag == 0 then
			event.MesMake_2(
				0,
				"こんな岩、ファイナルボムなら\n一発で吹っ飛ばせるんだけどなぁ。"
			)
		end
		flag_2 = event.GetFlag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.MesMake_2(
				0,
				"ちびちび削るしかないなんて、\n性に合わない仕事だぜ。<page>でも、下手に爆破して、\n崩れちまったら大変だからな。"
			)
		end
		flag_3 = event.GetFlag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.MesMake_2(
				0,
				"正直言って、俺は何かを作ったり、\n修理したりするのって苦手なんだよな。"
			)
		end
		helper_1537d275(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_3a9ba306(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_24f44()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(0, 1)
			helper_1537d275(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_7ee99e81(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_1537d275(var0, -1, 0, 0)
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
			helper_2ac28()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_2607c()
			helper_28938()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 3 then
			helper_279ac()
		end
		if at <= 4 then
			helper_1c028()
			helper_28938()
			if not vm.skipping() then
				return landing3()
			end
		end
		if at <= 5 then
			helper_279ac()
		end
		print("------  <START EVENT> OLD MAP ERR   ------\n")
	end
	function part2() end
	function landing1()
		helper_2607c()
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
	helper_2640c()
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
				helper_265ac()
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
					helper_2ac28()
					if vm.skipping() then
						return skip(2)
					end
					helper_2607c()
					event.SetAi(1, 24)
					event.SetAi(1, 25)
					event.SetAi(1, 26)
				else
					event.CharaActive(0, 25)
					var5 = event.GetChapter() or var5
					if var5 ~= 6 and var5 ~= 7 then
						helper_28938()
						if vm.skipping() then
							return skip(3)
						end
					else
						helper_279ac()
						if vm.skipping() then
							return skip(4)
						end
					end
					event.CharaActive(25)
				end
			else
				var6 = event.GetCnt(1) or var6
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var6 == 3 then
					helper_1c028()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var7 = event.GetChapter() or var7
					if var7 ~= 6 and var7 ~= 7 then
						helper_28938()
						if vm.skipping() then
							return skip(5)
						end
					else
						helper_279ac()
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
			helper_23a302d6(32)
		end
		if at <= 3 then
			helper_23a302d6(32)
		end
	end
	event.Initialize()
	var0 = event.SndLoadSound(3200) or var0
	if vm.wait() then
		return skip(1)
	end
	helper_23a302d6(32)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 8)
	if vm.wait() then
		return skip(3)
	end
	helper_23a302d6(32)
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
			helper_127ac()
		end
		if at <= 6 then
			helper_13efc(0)
		end
		if at <= 7 then
			helper_16eac()
		end
	end
	var0 = helper_1c96c()
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
			helper_127ac()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_127ac()
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
		helper_13efc(0)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_16eac()
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
	helper_31f50()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_26be8()
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
	helper_2640c()
	helper_30460()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2607c()
	end
	helper_0c718064(3)
	helper_2640c()
	event.SetAi(0, 24)
	event.SetAi(0, 25)
	event.SetAi(0, 26)
	helper_2ac28()
	if vm.skipping() then
		return skip(1)
	end
	helper_2607c()
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
			helper_316fc()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_29de8()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 4 then
			helper_23590()
		end
		if at <= 5 then
			helper_23a3c()
		end
		if at <= 6 then
			helper_24f44()
		end
	end
	function part2()
		if var0 == 2 then
			helper_23590()
			if vm.skipping() then
				return skip(5)
			end
		end
		if var0 == 13 then
			helper_23a3c()
			if vm.skipping() then
				return skip(6)
			end
		end
		if var0 == 301 then
			helper_24f44()
			if vm.skipping() then
				return skip(7)
			end
		end
	end
	function landing1()
		helper_29de8()
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
		var1 = helper_24074()
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			helper_316fc()
			if vm.skipping() then
				return skip(2)
			end
			helper_29de8()
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
		helper_2607c()
	end
	helper_2640c()
	event.SetAi(0, 24)
	event.SetAi(0, 25)
	event.SetAi(0, 26)
	helper_2ac28()
	if vm.skipping() then
		return skip(1)
	end
	helper_2607c()
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
			helper_29de8()
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
	helper_2640c()
	helper_316fc()
	if vm.skipping() then
		return skip(1)
	end
	helper_29de8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
