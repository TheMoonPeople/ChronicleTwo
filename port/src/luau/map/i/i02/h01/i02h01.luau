--!strict
-- map/i/i02/h01/i02h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_34727ca1 = require("@lib/event/helper_34727ca1")
local helper_3dd465f9 = require("@lib/event/helper_3dd465f9")
local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_868b9caa = require("@lib/event/helper_868b9caa")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_a19b3926 = require("@lib/event/helper_a19b3926")
local helper_ad3cd17a = require("@lib/event/helper_ad3cd17a")
local helper_b7c85616 = require("@lib/event/helper_b7c85616")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_c8aaaa54 = require("@lib/event/helper_c8aaaa54")
local helper_d3df4ea5 = require("@lib/event/helper_d3df4ea5")
local helper_fc624989 = require("@lib/event/helper_fc624989")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

--- Helper function.
local function helper_11f1c()
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
local function helper_1f110()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.Initialize()
	event.SetFlag(40, 1)
	var0 = event.GetChapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		helper_ad3cd17a()
	else
		helper_4337dd96()
	end
	helper_11f1c()
	flag = event.GetFlag(9) or flag
	flag_2 = event.GetFlag(202) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.EohSyncObj(0, "p01_train01")
		event.EohSetShow(0, 0)
		helper_40e84721(2, 0)
	end
end

--- Helper function.
local function helper_1ff90()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(20)
		end
		if at <= 2 then
			helper_ff0edc1d(10)
		end
		if at <= 3 then
			helper_ff0edc1d(10)
		end
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 6)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -119.0, 0.0, -2000.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.EohSyncObj(2, "p01_train01", "train08-m0")
	event.EohSyncObj(3, "p01_train01", "train08-m1")
	event.EohSyncObj(4, "p01_train01", "train10-m0")
	event.EohSyncObj(5, "p01_train01", "train10-m1")
	event.EohSyncObj(6, "p01_train01", "train10-m12")
	event.EohSyncObj(7, "p01_train01", "train10-m13")
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
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 66)
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.SetFadeIn(30)
	event.CharaActive(0)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, -1.5, 0.0, 30)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 2)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 0)
	event.ResetCamera(1, 3.14, 28.0)
end

--- Helper function.
local function helper_1f404()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(60)
		end
		if at <= 2 then
			helper_ff0edc1d(15)
		end
		if at <= 3 then
			helper_650bfa16(0)
		end
		if at <= 4 then
			helper_ff0edc1d(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.SetFadeIn(30)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 92)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 28.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_ba60(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(4)
		end
	end
	event.SetCrossfade(1, 1, 60)
	event.CmrsSetPos(14.46, 268.16, 737.45)
	event.CmrsSetRef(-30.4, 237.84, 510.02)
	event.CmrsMove2(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	helper_076280e8()
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(193)
end

--- Helper function.
local function helper_bc9c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090250)
		end
		if at <= 2 then
			helper_1d96573f(1090260)
		end
		if at <= 3 then
			helper_1d96573f(1090270)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-281.2, 51.82, -2024.16)
	event.CmrsSetRef(-258.93, 59.56, -1963.26)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, -0.08, 0.0)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "会話", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(3, "会話", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090250)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_1d96573f(1090260)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_1d96573f(1090270)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_c268(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(3)
		end
		if at <= 2 then
			helper_1d96573f(1090280)
		end
		if at <= 3 then
			helper_1d96573f(1090290)
		end
		if at <= 4 then
			helper_1d96573f(1090300)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-271.29, 59.56, -1912.06)
	event.CmrsSetRef(-269.4, 60.62, -1886.34)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(3, "ボルネオを見る", 6)
	event.ObjsNextMotion(3, "ボルネオを見るL", 0)
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(3, "口パク")
	helper_1d96573f(1090280)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "トムを見る", 2)
	event.ObjsNextMotion(2, "トムを見るL")
	event.SetPakuAnim(2, "口パク")
	helper_1d96573f(1090290)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "了解っす", 6)
	event.SetPakuAnim(3, "口パク")
	helper_1d96573f(1090300)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_c87c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090310)
		end
		if at <= 2 then
			helper_650bfa16(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-245.6, 62.76, -1902.65)
	event.CmrsSetRef(-246.75, 59.85, -1937.73)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, 0.04, 0.0)
	event.PlayBgm(1)
	event.ObjsSetMotion(1, "出発じゃ！", 6)
	event.ObjsNextMotion(1, "出発じゃ！L", 2)
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090310)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_cbbc(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_650bfa16(2)
		end
		if at <= 3 then
			helper_650bfa16(3)
		end
		if at <= 4 then
			helper_076280e8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-337.21, 57.28, -2006.87)
	event.CmrsSetRef(-278.59, 71.17, -1908.74)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, 0.04, 0.0)
	event.ObjsSetMotion(1, "走り", 4)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "走り", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsMove(1, -264.97, 36.87, -1753.54, 80)
	event.ObjsRotation(1, 0.0, 0.04, 0.0, 150)
	event.ObjsMotionDelay(1, 95)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsRotation(2, 0.0, 0.06, 0.0, 10)
	event.ObjsPosDelay(2, 10)
	event.ObjsMove(2, -221.09, 36.72, -1531.87, 80)
	event.ObjsMotionDelay(2, 95)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsRotation(3, 0.0, 0.16, 0.0, 10)
	event.ObjsPosDelay(3, 10)
	event.ObjsMove(3, -272.59, 36.72, -1640.34, 80)
	event.ObjsMotionDelay(3, 95)
	event.ObjsSetMotion(3, "立ち", 4)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(45)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_d514(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_076280e8()
		end
		if at <= 2 then
			helper_ff0edc1d(30)
		end
		if at <= 3 then
			helper_ff0edc1d(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-130.02, 67.35, -2138.26)
	event.CmrsSetRef(-120.37, 83.46, -1843.2)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 6)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_076280e8()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 9)
	event.SndSePlay(arg0, 10)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -116.18, 50.38, -1787.14)
	event.SetMotion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.ObjsSetMotion(6, "ぶしゅー", 6)
	event.ObjsSetMotion(7, "ぶしゅー", 6)
	event.ObjsSetPos(6, -114.25, 13.26, -1653.54)
	event.ObjsSetRot(6, 0.0, 3.04, 0.0)
	event.ObjsSetPos(7, -126.53, 32.32, -1662.93)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 11)
	helper_ff0edc1d(45)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0, 40)
end

--- Helper function.
local function helper_dc7c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(11)
		end
		if at <= 2 then
			helper_650bfa16(12)
		end
		if at <= 3 then
			helper_ff0edc1d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-326.52, 113.91, -1579.31)
	event.CmrsSetRef(-22.58, 118.56, -2134.59)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 10)
	event.SndSePlay(arg0, 12)
	event.ObjsMove(11, -200.0, 0.0, 0.0, 285)
	event.ObjsMove(12, 200.0, 0.0, 0.0, 285)
	helper_650bfa16(11)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(12)
	if vm.skipping() then
		return skip(3)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_dfa8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.13, 124.81, -2141.66)
	event.CmrsSetRef(-142.51, 84.44, -1891.87)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSePlay(arg0, 13)
	event.ObjsMove2(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e270(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	event.CmrsSetPos(-127.04, 86.04, -2182.12)
	event.CmrsSetRef(-120.48, 84.44, -1718.57)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.CmrsMove2(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.ObjsMove(10, -120.0, 0.0, -2100.0, 45)
	helper_ff0edc1d(45)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e584(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(90)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-292.76, 173.19, -1582.23)
	event.CmrsSetRef(-228.24, 151.8, -1773.02)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.ObjsMove(10, -120.0, 0.0, -3050.0, 90)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e7cc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(30)
		end
		if at <= 2 then
			helper_076280e8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(57.23, 251.57, 242.48)
	event.CmrsSetRef(21.23, 241.82, 43.83)
	event.CharaActive(1, 36)
	event.SetCharaPos(36, 266.91, 197.74, 696.65)
	event.SetCharaRot(36, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	event.ObjsMove(10, -120.0, 0.0, -6000.0, 120)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsMoveAhd2(-2.57, 9.27, 80.0, 120, 0, 0.4)
	helper_076280e8()
	if vm.skipping() then
		return skip(3)
	end
	event.SndSeStop(arg0, 9)
end

--- Helper function.
local function helper_eafc(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(4)
		end
		if at <= 2 then
			helper_1d96573f(1090320)
		end
		if at <= 3 then
			helper_076280e8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(212.25, 205.2, 623.4)
	event.CmrsSetRef(236.71, 212.83, 651.45)
	event.ObjsSetPos(4, 258.83, 197.74, 677.01)
	event.ObjsSetRot(4, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	helper_650bfa16(4)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(4, "口パク")
	helper_1d96573f(1090320)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsFadeOut(100, 0.0, 0.0, 0.0)
	helper_076280e8()
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_edd0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_bc9c(var0)
			end
			if at <= 2 then
				helper_c268(var0)
			end
			if at <= 3 then
				helper_c87c(var0)
			end
			if at <= 4 then
				helper_cbbc(var0)
			end
			if at <= 5 then
				helper_d514(var0)
			end
			if at <= 6 then
				helper_dc7c(var0)
			end
			if at <= 7 then
				helper_dfa8(var0)
			end
			if at <= 8 then
				helper_e270(var0)
			end
			if at <= 9 then
				helper_e584(var0)
			end
			if at <= 10 then
				helper_e7cc(var0)
			end
			if at <= 11 then
				helper_eafc(var0)
			end
			if at <= 12 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.StopBgm(1)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.SndSeStop(var0, 6)
		event.SndSeStop(var0, 9)
		event.SndSeStop(var0, 10)
		event.CharaActive(1, 0)
		event.EsmClear()
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.SetFadeIn(30)
	end
	event.SetFlag(109, 1)
	event.SetFlag(9, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1246)
	var0 = event.SndLoadSound(1246) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(33, -251.33, 36.72, -1629.09)
	event.SetCharaRot(33, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_vorneo.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(34, -251.33, 36.72, -1629.09)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_tom.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(35, -251.33, 36.72, -1629.09)
	event.SetCharaRot(35, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_need.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.SetCharaPos(36, -251.33, 36.72, -1629.09)
	event.SetCharaRot(36, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e200/e202/e202_train_pika.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, -120.0, 0.0, -1690.0)
	event.EohSyncObj(10, "p01_train01")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.EohSyncObj(11, "p41_i02h01", "i02h01_41-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.ObjsSetPos(11, 0.0, 0.0, 0.0)
	event.EohSyncObj(12, "p42_i02h01", "i02h01_42-m")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetPos(12, 0.0, 0.0, 0.0)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e100/e109/e109b.txt")
	event.StopBgm(0)
	event.SndSePlay(var0, 6)
	event.EohSetSoundId(1, var0)
	event.EohSetSoundId(2, var0)
	event.EohSetSoundId(3, var0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.InitDramaScene()
	helper_ba60(var0)
	if vm.skipping() then
		return skip(1)
	end
	helper_bc9c(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_c268(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_c87c(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_cbbc(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_d514(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_dc7c(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_dfa8(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_e270(var0)
	if vm.skipping() then
		return skip(9)
	end
	helper_e584(var0)
	if vm.skipping() then
		return skip(10)
	end
	helper_e7cc(var0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	helper_eafc(var0)
	if vm.skipping() then
		return skip(12)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_1af0(arg0: any, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var5 = out2 or var5
	end
	var6 = vm.f32(arg1 - var5)
	if var6 < vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if -0.5 < var6 and var6 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	var7 = 0.0
	var8 = vm.f32(helper_05ce8bed(var6) * 8.0)
	while var7 < var8 do
		var9 = helper_a19b3926(0.0, var6, var7, var8)
		var9 = vm.f32(var9 + var5)
		event.SetCharaRot(arg0, 0.0, var9, 0.0)
		var7 = vm.f32(var7 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.GetCharaRot(arg0) -- retail: argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded; argument 4 is a value where the handler writes an output; the output is discarded
	event.SetMotion(arg0, "立ち")
end

--- Helper function.
local function helper_1ed64()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(0, 1)
			return 0
		end
		if at <= 3 then
			helper_ff0edc1d(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_b7c85616(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_c8aaaa54(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_b7c85616(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_ff0edc1d(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_ff0edc1d(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_14e98()
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
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(18)
		end
		if at <= 4 then
			helper_ff0edc1d(12)
		end
		if at <= 5 then
			helper_ff0edc1d(30)
		end
		if at <= 6 then
			helper_ff0edc1d(10)
		end
		if at <= 7 then
			helper_ff0edc1d(20)
		end
		if at <= 8 then
			helper_ff0edc1d(18)
		end
		if at <= 9 then
			helper_ff0edc1d(12)
		end
		if at <= 10 then
			helper_ff0edc1d(30)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 3)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 3)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
local function helper_165e8(arg0: s32)
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
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(18)
		end
		if at <= 4 then
			helper_ff0edc1d(12)
		end
		if at <= 5 then
			helper_ff0edc1d(30)
		end
		if at <= 6 then
			helper_ff0edc1d(10)
		end
		if at <= 7 then
			helper_ff0edc1d(20)
		end
		if at <= 8 then
			helper_ff0edc1d(18)
		end
		if at <= 9 then
			helper_ff0edc1d(12)
		end
		if at <= 10 then
			helper_ff0edc1d(30)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 4)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 4)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
local function helper_19598()
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
	local var15: s32 = 0
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
			var14 = vm.f32(35.8)
			var14 = 36.0
			var14 = vm.f32(29.22)
			var14 = vm.f32(-13.87)
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(30)
		end
		if at <= 4 then
			helper_ff0edc1d(20)
		end
		if at <= 5 then
			helper_ff0edc1d(10)
		end
		if at <= 6 then
			helper_ff0edc1d(20)
		end
		if at <= 7 then
			helper_ff0edc1d(30)
		end
		if at <= 8 then
			helper_ff0edc1d(20)
		end
		if at <= 9 then
			helper_ff0edc1d(10)
		end
		if at <= 10 then
			var15 = 0
			print("てつのあしおと\n")
			var15 = 6
			print("いしのあしおと\n")
			var15 = 2
			helper_ff0edc1d(30)
		end
		if at <= 11 then
			helper_ff0edc1d(30)
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
	if now_map_no == 34 then
		var14 = vm.f32(35.8)
	end
	if now_map_no == 54 then
		var14 = 36.0
	end
	if now_map_no == 83 then
		var14 = vm.f32(29.22)
	end
	if now_map_no == 103 then
		var14 = vm.f32(-13.87)
	end
	event.ObjsSetPos(0, 46.0, var14, 0.0)
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
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_ff0edc1d(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_ff0edc1d(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_ff0edc1d(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_ff0edc1d(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_ff0edc1d(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_ff0edc1d(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_ff0edc1d(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_ff0edc1d(10)
				if vm.skipping() then
					return skip(10)
				end
			end
		end
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -50.0, 30.0, 0.0, 45)
	var15 = 0
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
		var15 = 6
	end
	if now_map_no == 34 or now_map_no == 54 then
		print("いしのあしおと\n")
		var15 = 2
	end
	event.EohSetFootSoundId(0, var15)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
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
local function helper_8d38(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_a19b3926(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_a19b3926(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a26c(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return rot_y
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8d38(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
	return rot_y
end

--- Helper function.
local function helper_a52c(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_fc624989(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_a26c(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_3dd465f9(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_fc624989(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_21104(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_21208()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_21104(15)
		end
		if at <= 2 then
			helper_21104(1)
		end
		if at <= 3 then
			helper_21104(6)
		end
		if at <= 4 then
			helper_21104(0)
		end
		if at <= 5 then
			helper_21104(4)
		end
		if at <= 6 then
			helper_21104(31)
		end
		if at <= 7 then
			helper_21104(35)
		end
		if at <= 8 then
			helper_21104(36)
		end
		if at <= 9 then
			helper_21104(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	language_code = event.GetLanguage() or language_code
	if language_code ~= 0 then
		event.MesMake_2(0, "Welcome.")
	else
		event.MesMake_2(0, "いらっしゃい。")
		if var0 == 18 then
			event.MesMake_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if var0 == 4 then
			event.MesMake_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if var0 == 34 then
			event.MesMake_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if var0 == 1012 then
			flag = event.GetFlag(45) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.SetFlag(45, 1)
			end
		end
		if var0 == 1015 then
			flag_2 = event.GetFlag(46) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.SetFlag(46, 1)
			end
		end
		if var0 == 1018 then
			flag_3 = event.GetFlag(47) or flag_3
			if flag_3 == 0 then
				event.MesMake_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.SetFlag(47, 1)
			else
				event.MesMake_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if var1 ~= -1 then
		helper_a52c(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_21104(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_21104(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_21104(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_21104(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_21104(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_21104(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_21104(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_21104(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_21104(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_22000()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
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
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_21208()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
		helper_a52c(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"見てみろよ、こんなでっかい物が\n動いてたなんて、信じられないだろう。\nでもな、昔は本当に動いてたんだぜ。<page>また、こいつに乗って旅するのがオレの夢だ。\nだから、今でも整備にぬかりはねぇ。\n許しが出たら、いつでも動かせるようにな。"
				)
			else
				event.MesMake_2(
					0,
					"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
				)
			end
			helper_a52c(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"やあ、ユリス。\n鉄道が廃止されて\nどれだけの時間が流れたかのう。<page>私はたとえ、鉄道が動かずとも\nこうやって毎日駅を見回っているのだよ。"
				)
			else
				event.MesMake_2(
					0,
					"ようやく町長が、重い腰を上げたのじゃな。\n列車は走っているとはいえ、まだまだ\n一般開放できる状態ではない。<page>早く町のみんなを乗せて\nあげたいのじゃが・・・"
				)
			end
			helper_a52c(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"こんにちは、ユリス。\nそこにいる駅長、うちのパパなの。\nこうやって親子で駅を守っているの。<page>いつの日か、鉄道が復活する日まで・・・"
				)
			else
				event.MesMake_2(
					0,
					"列車が動いたわ！\nだけど、まだ駅が元通りになるのは、\n時間がかかりそうね・・・"
				)
			end
			helper_a52c(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"おっちゃん、モニカちゃんの\n隠れファンだったんだけど、\n最近モニカちゃんの姿が見えねーな。<page>おかげで、仕事のやる気が出ねーよ。"
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"よお、ユリス。\nモニカが帰って来たらしいな。\n町のみんなも喜ぶぞー！"
					)
				else
					event.MesMake_2(
						0,
						"モニカー！元気だったか？\nおっちゃん、寂しかったよー。"
					)
				end
			end
			helper_a52c(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"やっとモニカちゃんと普通に\nしゃべれるようになったのに\n突然いなくなるんだもんな。<page>ユリス、一体モニカちゃん、\nどこに行ったんだ？"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "モニカが帰ってきたんだね。\n一体、どうやって？？")
				else
					event.MesMake_2(0, "モニカ、帰ってきたんだね。\n一体、どうやって？？")
				end
			end
			helper_a52c(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_a52c(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1f110

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1f404()
		end
	end
	event.Initialize()
	helper_1f110()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -240.0, 35.8, 140.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 10 or old_map_no == 22 or old_map_no == 121 then
				event.SetCharaPos(0, 0.0, 198.8, 1450.0)
				event.SetCharaRot(0, 0.0, 3.14, 0.0)
				event.ResetCamera(1, 3.14)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 1 then
					helper_946c0402()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var4 = event.GetChapter() or var4
					if var4 ~= 6 and var4 ~= 7 then
						helper_1ff90()
						if vm.skipping() then
							return skip(1)
						end
					else
						helper_1f404()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1f404()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_edd0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("pos[0]=", string.format("%f", pos_x), "-----------\n")
			print("pos[1]=", string.format("%f", pos_y), "-----------\n")
			print("pos[2]=", string.format("%f", pos_z), "-----------\n")
		end
		if at <= 2 then
			helper_868b9caa(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01")
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	print("pos[0]=", string.format("%f", pos_x), "-----------\n")
	print("pos[1]=", string.format("%f", pos_y), "-----------\n")
	print("pos[2]=", string.format("%f", pos_z), "-----------\n")
	event.EohSetPos(0, pos_x, pos_y, 0.0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.CharaActive(0, 0)
	event.SetCameraPos(-345.21, 89.08, 234.02)
	event.SetCameraRef(-238.57, 83.73, 148.63)
	if vm.wait() then
		return skip(2)
	end
	helper_868b9caa(32)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 122)
	event.CharaActive(1, 123)
	event.CharaActive(1, 0)
	event.EohSetPos(0, pos_x, pos_y, -1800.0)
	event.EohSetRot(0, 0.0, 3.1415927, 0.0)
	event.ResetCamera(0)
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.MapJump(-1, "m02")
	if vm.wait() then
		return skip(2)
	end
	event.Ext(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.Ext(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Program 250.
script[250] = function()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b7c85616(0, 1)
				helper_34727ca1(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_34727ca1(0, -1, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 6 then
			helper_14e98()
		end
		if at <= 9 then
			helper_165e8(0)
		end
		if at <= 10 then
			helper_19598()
		end
	end
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		helper_1af0(0, vm.f32(1.57))
		if vm.skipping() then
			return skip(1)
		end
		helper_b7c85616(0, 1)
		event.MesMake_2(
			0,
			"これは「列車」という機械だと\nスターブルは言ってたっけ・・・<page>今はトムとボルネオさんのお家に\nなってるけど、ボクが生まれる前は\n動いてたんだって。ホントかな？"
		)
		helper_34727ca1(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "本当にこんな大きな物が\n動くなら、見てみたいな。")
		helper_34727ca1(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var1 = helper_1ed64()
	if vm.skipping() then
		return skip(4)
	end
	if var1 ~= 1 then
		return
	end
	event.SetCnt(1, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(3) or var3
	if var3 <= 1 then
		if var2 ~= 6 and var2 ~= 7 then
			helper_14e98()
			if vm.skipping() then
				return skip(5)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(6)
			end
			event.MapJump(-1, "s08")
		else
			helper_14e98()
			if vm.skipping() then
				return skip(7)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(8)
			end
			event.MapJump(-1, "s37")
		end
		if vm.wait() then
			return skip(9)
		end
	elseif var2 ~= 6 and var2 ~= 7 then
		helper_165e8(0)
		if vm.skipping() then
			return skip(10)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_19598()
		if vm.skipping() then
			return skip(11)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d3df4ea5()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.SearchCharaNo(2) or var0
	event.CharaActive(0, var0)
	event.SetAi(0, var0)
	helper_edd0()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22000()
	if vm.skipping() then
		return skip(1)
	end
end

return script
