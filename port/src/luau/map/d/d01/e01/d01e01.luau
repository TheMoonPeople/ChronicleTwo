--!strict
-- map/d/d01/e01/d01e01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_1b06d86e = require("@lib/event/helper_1b06d86e")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_3c8e2192 = require("@lib/event/helper_3c8e2192")
local helper_3dd465f9 = require("@lib/event/helper_3dd465f9")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_8a56995e = require("@lib/event/helper_8a56995e")
local helper_8d58a537 = require("@lib/event/helper_8d58a537")
local helper_b7c85616 = require("@lib/event/helper_b7c85616")
local helper_b8bc5976 = require("@lib/event/helper_b8bc5976")
local helper_d1f370f3 = require("@lib/event/helper_d1f370f3")
local helper_d3df4ea5 = require("@lib/event/helper_d3df4ea5")
local helper_e304888c = require("@lib/event/helper_e304888c")
local helper_eb838ef8 = require("@lib/event/helper_eb838ef8")
local helper_f96a9d1b = require("@lib/event/helper_f96a9d1b")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")
local helper_fff7b413 = require("@lib/event/helper_fff7b413")

--- Helper function.
local function helper_35ba0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetTimeStepEnable(0)
	event.SetAi(0, 8)
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("event/opening/p6/")
	event.LoadChara(4, "p6_donnie.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 124.7, 104.0, 183.68)
	event.SetCharaRot(8, 0.0, 0.85, 0.0)
	event.SetMotion(8, "立ち", 4)
	event.ChangeDir("")
	event.LoadBgm(108)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_35e90()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc >= 1 then
		event.FuncPointShow("", "memo", 0)
		event.EohSyncObj(0, "memo")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_36004()
	local flag: s32 = 0
	event.SetFlag(40, 1)
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_35ba0()
	end
	helper_35e90()
end

--- Helper function.
local function helper_37a40()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(20)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 1000.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.SetCameraRef(0.0, 30.0, 820.0)
	event.SetCameraPos(0.0, 66.0, 700.0)
	event.SetFadeIn(30)
	event.ObjsMove(0, 0.0, 0.0, 820.0, 40)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 6)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_ff0edc1d(2)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_377a0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCharaPos(0, -380.0, 104.0, 0.0)
	event.SetCharaRot(0, 0.0, 1.57, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.SetCameraRef(-380.0, 134.0, 0.0)
	event.SetCameraPos(-260.0, 134.0, 0.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_37e84()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 39 then
			if at <= 1 then
				helper_b7c85616(0, 7)
				helper_ff0edc1d(6)
			end
			if at <= 2 then
				helper_35ba0()
				helper_8a56995e(1)
			end
			if at <= 3 then
				helper_076280e8()
			end
			if at <= 4 then
				helper_ff0edc1d(16)
			end
			if at <= 5 then
				helper_ff0edc1d(100)
			end
			if at <= 6 then
				helper_ff0edc1d(20)
			end
			if at <= 7 then
				helper_b8bc5976(60010, 280)
			end
			if at <= 8 then
				helper_b8bc5976(60020, 40)
			end
			if at <= 9 then
				helper_b8bc5976(60030, 60)
			end
			if at <= 10 then
				helper_ff0edc1d(50)
			end
			if at <= 11 then
				helper_b8bc5976(60040, 140)
			end
			if at <= 12 then
				helper_650bfa16(0)
			end
			if at <= 13 then
				helper_b8bc5976(60050, 40)
			end
			if at <= 14 then
				helper_b8bc5976(60055, 110)
			end
			if at <= 15 then
				helper_b8bc5976(60060, 60)
			end
			if at <= 16 then
				helper_b8bc5976(60070, 90)
			end
			if at <= 17 then
				helper_650bfa16(1)
			end
			if at <= 18 then
				helper_b8bc5976(60080, 120)
			end
			if at <= 19 then
				helper_b8bc5976(60090, 60)
			end
			if at <= 20 then
				helper_b8bc5976(60095, 90)
			end
			if at <= 21 then
				helper_b8bc5976(60100, 40)
			end
			if at <= 22 then
				helper_650bfa16(1)
			end
			if at <= 23 then
				helper_b8bc5976(60110, 100)
			end
			if at <= 24 then
				helper_650bfa16(0)
			end
			if at <= 25 then
				helper_b8bc5976(60120, 150)
			end
			if at <= 26 then
				helper_b8bc5976(60130, 100)
			end
			if at <= 27 then
				helper_076280e8()
			end
			if at <= 28 then
				helper_b8bc5976(60140, 140)
			end
			if at <= 29 then
				helper_b8bc5976(60150, 120)
			end
			if at <= 30 then
				helper_076280e8()
			end
			if at <= 31 then
				helper_8a56995e(1)
			end
			if at <= 32 then
				helper_e304888c(0, -1, 8, 0, 0)
				helper_ff0edc1d(80)
			end
			if at <= 33 then
				helper_ff0edc1d(30)
			end
			if at <= 34 then
				helper_ff0edc1d(90)
			end
			if at <= 35 then
				helper_38448da1(0)
				helper_ff0edc1d(30)
			end
			if at <= 36 then
				helper_b8bc5976(60170, 40)
			end
			if at <= 37 then
				helper_076280e8()
			end
			if at <= 38 then
				helper_076280e8()
			end
			if vm.skip_end() then
				return skip(40)
			end
			return part2()
		end
		if at <= 40 then
			helper_ff0edc1d(30)
		end
		if at <= 41 then
			helper_b7c85616(0, 4)
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		helper_b7c85616(0, 1)
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.CharaActive(0)
		event.EohSetFootSoundId(0, -1)
		event.EohSetFootSoundId(1, 3)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.SetCharaPos(0, 103.83, 104.0, 195.7)
		event.SetCharaRot(0, 0.0, 0.85, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.SetCharaPos(8, 124.7, 104.0, 183.68)
		event.SetCharaRot(8, 0.0, 0.85, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.CmrsInit()
		event.SetCameraPos(22.1, 160.44, 138.08)
		event.SetCameraRef(103.83, 133.97, 195.7)
		event.ResetCamera(0)
		event.SetProjection(524.9)
		event.SetFadeIn(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(41)
		end
		event.SetMesPreset(0, 4)
		helper_b7c85616(0, 4)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, 9000000)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
		event.LoadMes(0, -1)
		helper_b7c85616(0, 1)
		event.SetMesDrawspeed(0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_b7c85616(0, 7)
	event.SetProjection(618.0)
	event.LoadSound(1800)
	event.StopBgm(0)
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(108)
	event.PlayBgm(0)
	event.InitDramaScene()
	var0 = event.SndLoadSound(1800) or var0
	helper_35ba0()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p6/op6.txt")
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/opening/p6/p6_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 12)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -464.39, 100.52, 0.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "はあはあ目")
	event.ObjsTexAnime(0, 1, "はあはあ口")
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.EohSetFootSoundId(1, -1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -443.0, 100.52, 8.0)
	event.ObjsSetRot(1, 0.0, -1.57, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "口閉じ")
	event.StreamOpen3(1, 60005)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "はしご降り", 6)
	event.ObjsSetMotion(1, "はしご降り", 6)
	event.ObjsSePlay(1, var0, 8)
	event.CmrsInit()
	event.CmrsSetPos(-173.98, 180.32, 173.33)
	event.CmrsSetRef(-478.87, 162.2, -4.22)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60)
	helper_076280e8()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var0, 9)
	helper_ff0edc1d(16)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamPlay(1)
	helper_ff0edc1d(100)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamClose(1)
	event.SetCrossfade(60)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.CmrsSetPos(-383.51, 121.05, 34.45)
	event.CmrsSetRef(-455.56, 111.89, -1.44)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "はあはあL", 4, -1, 1)
	event.ObjsSetPos(0, -447.2, 100.52, -9.2)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(1, -434.79, 100.52, 18.22)
	event.ObjsSetRot(1, 0.0, -2.89, 0.0)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(7)
	end
	helper_b8bc5976(60010, 280)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60020, 40)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_b8bc5976(60030, 60)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "深呼吸目")
	event.ObjsTexAnime(0, 1, "深呼吸口")
	event.ObjsSetMotion(0, "深呼吸", 6)
	event.ObjsNextMotion(0, "立ち2", 4)
	helper_ff0edc1d(50)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(0, 0, "深呼吸口")
	event.SetPakuAnim(0, "通常口パク", "デフォルト口")
	helper_b8bc5976(60040, 140)
	if vm.skipping() then
		return skip(12)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60050, 40)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60055, 110)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "会話2", 2)
	event.ObjsNextMotion(0, "立ち2", 4)
	event.SetPakuAnim(0, "通常口パク", "デフォルト口")
	helper_b8bc5976(60060, 60)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-416.96, 123.15, -56.77)
	event.CmrsSetRef(-445.66, 113.41, 7.28)
	event.ObjsSetMotion(1, "指差し会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60070, 90)
	if vm.skipping() then
		return skip(17)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(0, "会話2", 2)
	event.ObjsNextMotion(0, "立ち2", 4)
	helper_b8bc5976(60080, 120)
	if vm.skipping() then
		return skip(19)
	end
	helper_b8bc5976(60090, 60)
	if vm.skipping() then
		return skip(20)
	end
	helper_b8bc5976(60095, 90)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "立ち2")
	event.ObjsSetMotion(1, "腰に手", 2)
	event.ObjsMotionWait(1)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60100, 40)
	if vm.skipping() then
		return skip(22)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-306.09, 121.28, -6.32)
	event.CmrsSetRef(-334.81, 124.2, -6.72)
	event.ObjsMove(0, -334.72, 100.52, -7.62, 140)
	event.ObjsRotation(0, 0.0, 1.57, 0.0, 10)
	event.ObjsSetMotion(0, "きょろきょろ歩き", 2)
	event.ObjsNextMotion(0, "きょろきょろ歩き・上")
	event.ObjsSetMotion(1, "振り返る", 6)
	event.ObjsNextMotion(1, "振り返るL", 4)
	event.ObjsRotation(1, 0.0, -1.21, 0.0, 30)
	event.ObjsTexaDelay(0, 100)
	event.ObjsTexAnime(0, 0, "目パチ")
	event.ObjsTexAnime(0, 1, "上目")
	event.SetPakuAnim(0, "通常口パク", "ポカーン")
	helper_b8bc5976(60110, 100)
	if vm.skipping() then
		return skip(24)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.CmrsSetPos(-82.68, 160.58, 85.07)
	event.CmrsSetRef(-54.97, 205.76, 261.35)
	event.CmrsMove(-82.68, 160.58, 85.07, 60.21, 145.99, 192.66, 300)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	helper_b8bc5976(60120, 150)
	if vm.skipping() then
		return skip(26)
	end
	helper_b8bc5976(60130, 100)
	if vm.skipping() then
		return skip(27)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(393.03, 191.08, 62.48)
	event.CmrsSetRef(89.13, 151.44, 51.64)
	event.CmrsMove(393.03, 191.08, 62.48, 125.13, 148.6, -81.82, 300)
	helper_b8bc5976(60140, 140)
	if vm.skipping() then
		return skip(29)
	end
	helper_b8bc5976(60150, 120)
	if vm.skipping() then
		return skip(30)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-316.41, 284.74, -17.35)
	event.CmrsSetRef(-8.6, 159.57, 242.62)
	event.CmrsMove(4.84, 184.71, 131.56, 106.14, 116.67, 193.96, 300)
	event.CmrsPrSlowing(0.96, 60)
	event.CmrsPrdelay(15)
	event.ObjsSetPos(0, -16.51, 104.0, 94.06)
	event.ObjsSetRot(0, 0.0, 0.85, 0.0)
	event.ObjsMove(0, 103.83, 104.0, 195.7, 200)
	event.ObjsSetMotion(0, "歩き", 4, -1, 1)
	event.ObjsMotionDelay(0, 200)
	event.ObjsSetMotion(0, "旧・立ち")
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsSetPos(1, -19.11, 104.0, 62.23)
	event.ObjsSetRot(1, 0.0, 0.85, 0.0)
	event.ObjsMove(1, 124.7, 104.0, 183.68, 230)
	event.ObjsMotionDelay(1, 230)
	event.ObjsSetMotion(1, "立ち")
	event.StreamOpen3(1, 60160)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(32)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 60160)
	helper_e304888c(0, -1, 8, 0, 0)
	helper_ff0edc1d(80)
	if vm.skipping() then
		return skip(33)
	end
	event.EohSetFootSoundId(0, 3)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(34)
	end
	event.EohSetFootSoundId(1, 3)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(35)
	end
	helper_38448da1(0)
	event.StreamClose(1)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(36)
	end
	helper_b8bc5976(60170, 40)
	if vm.skipping() then
		return skip(37)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_076280e8()
	if vm.skipping() then
		return skip(39)
	end
	return part2()
end

--- Helper function.
local function helper_3612c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_b7c85616(0, 5)
			var0 = helper_8d58a537(0, -1, 8, 0, 0, 2, 1)
		end
		if at <= 3 then
			helper_b7c85616(0, 1)
			helper_ff0edc1d(30)
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	if vm.wait() then
		return skip(2)
	end
	event.SetMesQuestionGyou(0, 0)
	helper_b7c85616(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『パームブリンクス』に移動しますか？")
	var0 = helper_8d58a537(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	helper_b7c85616(0, 1)
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(4)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_36f80()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(0, 1)
			helper_eb838ef8(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMesQuestionGyou(0, 0)
	helper_b7c85616(0, 5)
	event.SetMesDrawspeed(0, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var0)
	var4 = 0.0
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var2)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	helper_b7c85616(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(
		0,
		"この地下水路は、どこに続いているんだろう？\nドニーに聞いてみよう。"
	)
	helper_eb838ef8(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_36440()
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
		if at <= 5 then
			if at <= 1 then
				helper_b7c85616(0, 5)
				var0 = helper_8d58a537(0, -1, 8, 0, 0, 2, 1)
			end
			if at <= 2 then
				helper_b7c85616(0, 1)
				helper_ff0edc1d(10)
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ff0edc1d(2)
			end
			return 1
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMesQuestionGyou(0, 0)
	helper_b7c85616(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『地下水道』に移動しますか？")
	var0 = helper_8d58a537(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_b7c85616(0, 1)
	if var0 == 0 then
		event.ObjsSetPos(0, 0.0, 0.0, 820.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.SetCameraRef(0.0, 30.0, 820.0)
		event.SetCameraPos(0.0, 40.0, 760.0)
		event.ObjsMove(0, 0.0, 0.0, 1000.0, 40)
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(3)
		end
		event.EohSetFootSoundId(0, 2)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(4)
		end
		event.ObjsSetMotion(0, "立ち")
		helper_ff0edc1d(2)
		if vm.skipping() then
			return skip(5)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var3)
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
				return skip(6)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_c8f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b7c85616(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_eb838ef8(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3ae2c()
	local var0: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 104 then
			if at <= 1 then
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_b7c85616(0, 7)
			end
			if at <= 3 then
				helper_b8bc5976(60210, 100)
			end
			if at <= 4 then
				helper_b8bc5976(60215, 150)
			end
			if at <= 5 then
				helper_650bfa16(0)
			end
			if at <= 6 then
				helper_b8bc5976(60220, 80)
			end
			if at <= 7 then
				helper_b8bc5976(60230, 70)
			end
			if at <= 8 then
				helper_076280e8()
			end
			if at <= 9 then
				helper_ff0edc1d(60)
			end
			if at <= 10 then
				helper_b8bc5976(60240, 110)
			end
			if at <= 11 then
				helper_b8bc5976(60250, 80)
			end
			if at <= 12 then
				helper_b8bc5976(60260, 30)
			end
			if at <= 13 then
				helper_b8bc5976(60270, 120)
			end
			if at <= 14 then
				helper_b8bc5976(60280, 80)
			end
			if at <= 15 then
				helper_b8bc5976(60290, 60)
			end
			if at <= 16 then
				helper_b8bc5976(60300, 60)
			end
			if at <= 17 then
				helper_b8bc5976(60305, 150)
			end
			if at <= 18 then
				helper_b8bc5976(60310, 90)
			end
			if at <= 19 then
				helper_650bfa16(0)
			end
			if at <= 20 then
				helper_b8bc5976(60320, 60)
			end
			if at <= 21 then
				helper_b8bc5976(60330, 110)
			end
			if at <= 22 then
				helper_b8bc5976(60335, 130)
			end
			if at <= 23 then
				helper_b8bc5976(60340, 150)
			end
			if at <= 24 then
				helper_b8bc5976(60350, 160)
			end
			if at <= 25 then
				helper_ff0edc1d(30)
			end
			if at <= 26 then
				helper_b8bc5976(60360, 80)
			end
			if at <= 27 then
				helper_650bfa16(1)
			end
			if at <= 28 then
				helper_b8bc5976(60370, 40)
			end
			if at <= 29 then
				helper_650bfa16(0)
			end
			if at <= 30 then
				helper_b8bc5976(60380, 80)
			end
			if at <= 31 then
				helper_b8bc5976(60385, 50)
			end
			if at <= 32 then
				helper_650bfa16(1)
			end
			if at <= 33 then
				helper_b8bc5976(60390, 70)
			end
			if at <= 34 then
				helper_650bfa16(0)
			end
			if at <= 35 then
				helper_b8bc5976(60400, 200)
			end
			if at <= 36 then
				helper_ff0edc1d(10)
			end
			if at <= 38 then
				helper_b8bc5976(60410, 160)
			end
			if at <= 39 then
				helper_650bfa16(0)
			end
			if at <= 40 then
				helper_8a56995e(1)
			end
			if at <= 41 then
				helper_ff0edc1d(60)
			end
			if at <= 42 then
				helper_b8bc5976(60430, 170)
			end
			if at <= 43 then
				helper_650bfa16(1)
			end
			if at <= 44 then
				helper_8a56995e(1)
			end
			if at <= 45 then
				helper_ff0edc1d(15)
			end
			if at <= 46 then
				helper_650bfa16(1)
			end
			if at <= 47 then
				helper_8a56995e(1)
			end
			if at <= 48 then
				helper_ff0edc1d(80)
			end
			if at <= 49 then
				helper_8a56995e(1)
			end
			if at <= 50 then
				helper_ff0edc1d(20)
			end
			if at <= 51 then
				helper_650bfa16(0)
			end
			if at <= 52 then
				helper_650bfa16(1)
			end
			if at <= 53 then
				helper_8a56995e(1)
			end
			if at <= 54 then
				helper_ff0edc1d(100)
			end
			if at <= 55 then
				helper_650bfa16(1)
			end
			if at <= 56 then
				helper_650bfa16(1)
			end
			if at <= 57 then
				helper_8a56995e(1)
			end
			if at <= 58 then
				helper_650bfa16(1)
			end
			if at <= 59 then
				helper_b8bc5976(60450, 40)
			end
			if at <= 60 then
				helper_650bfa16(0)
			end
			if at <= 61 then
				helper_ff0edc1d(20)
			end
			if at <= 62 then
				helper_ff0edc1d(20)
			end
			if at <= 63 then
				helper_b8bc5976(60460, 40)
			end
			if at <= 64 then
				helper_b8bc5976(60470, 100)
			end
			if at <= 65 then
				helper_b8bc5976(60475, 120)
			end
			if at <= 66 then
				helper_650bfa16(0)
			end
			if at <= 68 then
				helper_b8bc5976(60480, 90)
			end
			if at <= 69 then
				helper_b8bc5976(60490, 50)
			end
			if at <= 70 then
				helper_b8bc5976(60500, 60)
			end
			if at <= 71 then
				helper_076280e8()
			end
			if at <= 72 then
				helper_650bfa16(0)
			end
			if at <= 73 then
				helper_650bfa16(2)
			end
			if at <= 74 then
				helper_c8f0(22, 1)
			end
			if at <= 75 then
				helper_b7c85616(0, 4)
				helper_eb838ef8(0, -1, 8, 0, 0)
			end
			if at <= 76 then
				helper_b7c85616(0, 7)
				helper_650bfa16(0)
			end
			if at <= 77 then
				helper_b8bc5976(60510, 160)
			end
			if at <= 78 then
				helper_650bfa16(1)
			end
			if at <= 79 then
				helper_ff0edc1d(14)
			end
			if at <= 80 then
				helper_650bfa16(0)
			end
			if at <= 81 then
				helper_b8bc5976(60520, 80)
			end
			if at <= 82 then
				helper_b8bc5976(60530, 40)
			end
			if at <= 83 then
				helper_c8f0(359, 1)
			end
			if at <= 84 then
				helper_b8bc5976(60540, 40)
			end
			if at <= 85 then
				helper_b8bc5976(60550, 30)
			end
			if at <= 86 then
				helper_650bfa16(0)
			end
			if at <= 87 then
				helper_b8bc5976(60560, 90)
			end
			if at <= 88 then
				helper_650bfa16(0)
			end
			if at <= 89 then
				helper_650bfa16(0)
			end
			if at <= 90 then
				helper_b8bc5976(60570, 200)
			end
			if at <= 91 then
				helper_b8bc5976(60580, 50)
			end
			if at <= 92 then
				helper_650bfa16(0)
			end
			if at <= 93 then
				helper_650bfa16(0)
			end
			if at <= 94 then
				helper_ff0edc1d(30)
			end
			if at <= 96 then
				helper_b8bc5976(60590, 60)
			end
			if at <= 97 then
				helper_b8bc5976(60595, 160)
			end
			if at <= 98 then
				helper_650bfa16(0)
			end
			if at <= 99 then
				helper_650bfa16(0)
			end
			if at <= 100 then
				helper_ff0edc1d(6)
			end
			if at <= 101 then
				helper_ff0edc1d(14)
			end
			if at <= 102 then
				helper_ff0edc1d(76)
			end
			if at <= 103 then
				helper_076280e8()
			end
			if vm.skip_end() then
				return skip(105)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.EohSetFootSoundId(0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.InitDramaScene()
	helper_b7c85616(0, 7)
	event.SetProjection(618.0)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1800) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.LoadMes(0, 5, "event/opening/p6/op6.txt")
	block = event.LoadImg_4(5, "textures/event/opening/p6/op06.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "op0601", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "op0602", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetAlphab(1, 0)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "op0603", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetAlphab(2, 0)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/opening/p6/p6_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 103.83, 104.0, 195.7)
	event.ObjsSetRot(0, 0.0, 0.85, 0.0)
	event.ObjsSetMotion(0, "考えポーズL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "考える目")
	event.ObjsTexAnime(0, 1, "考える口")
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.EohSetFootSoundId(1, 3)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 124.7, 104.0, 183.68)
	event.ObjsSetRot(1, 0.0, 0.85, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "口閉じ")
	event.LoadItem(5, 1, "info", 10)
	event.CharaActive(0, 10)
	event.SetReference(0, "ef00", 10)
	event.LoadItem(5, 22, "info", 11)
	event.CharaActive(0, 11)
	event.SetReference(8, "donnie_gun", 11)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(2, 12)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 110.0, 135.89, 193.52)
	event.ObjsSetRot(2, 0.0, 0.6, 0.0)
	event.ObjsSetMotion(2, "発動", 5)
	event.LoadItem(5, 359, "info", 13)
	event.SetCharaPos(13, 0.0, 0.0, 0.0)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.CharaActive(0, 13)
	event.SetReference(8, "donnie_receiver", 13)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	event.CmrsSetPos(103.9, 126.98, 225.65)
	event.CmrsSetRef(112.72, 126.94, 179.57)
	event.ObjsSetMotion(0, "ななめ前を見る", 6)
	event.ObjsNextMotion(0, "ななめ前を見るL", 4)
	event.ObjsSetMotion(1, "ミンツを見る", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目")
	if vm.wait() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60210, 100)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60215, 150)
	if vm.skipping() then
		return skip(5)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetPos(0, 103.83, -100.0, 195.7)
	event.CmrsSetPos(112.75, 131.05, 198.49)
	event.CmrsSetRef(163.01, 122.54, 302.27)
	event.CmrsMove(112.75, 131.05, 198.49, 87.37, 110.42, 341.57, 180)
	helper_b8bc5976(60220, 80)
	if vm.skipping() then
		return skip(7)
	end
	helper_b8bc5976(60230, 70)
	if vm.skipping() then
		return skip(8)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(124.82, 125.36, 251.04)
	event.CmrsSetRef(105.61, 114.01, 150.82)
	event.ObjsSetPos(0, 103.83, 104.0, 195.7)
	event.ObjsSetMotion(0, "考えポーズ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "考えポーズL", 4)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60240, 110)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60250, 80)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60260, 30)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "ドニーを見る", 2)
	event.ObjsNextMotion(0, "ドニーを見るL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60270, 120)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60280, 80)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "ドニーを見る会話", 2)
	event.ObjsNextMotion(0, "ドニーを見るL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60290, 60)
	if vm.skipping() then
		return skip(16)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60300, 60)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60305, 150)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.ObjsSetColor(10, 128, 128, 128, 0, 30)
	event.ObjsSetMotion(0, "考えポーズL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60310, 90)
	if vm.skipping() then
		return skip(19)
	end
	event.SpriteSetDraw(0, 0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60320, 60)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60330, 110)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60335, 130)
	if vm.skipping() then
		return skip(23)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(11, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60340, 150)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetColor(11, 128, 128, 128, 0, 30)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(12, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60350, 160)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetColor(12, 128, 128, 128, 0, 30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(26)
	end
	event.SpriteSetDraw(2, 0)
	event.ObjsSetMotion(1, "ミンツを見る戻り", 6)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60360, 80)
	if vm.skipping() then
		return skip(27)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "左を向く", 2)
	event.ObjsNextMotion(0, "左を向くL")
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 10)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60370, 40)
	if vm.skipping() then
		return skip(29)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSetMotion(1, "ミンツを見る", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60380, 80)
	if vm.skipping() then
		return skip(31)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60385, 50)
	if vm.skipping() then
		return skip(32)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60390, 70)
	if vm.skipping() then
		return skip(34)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60400, 200)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(1, "ミンツを見るL")
	event.ObjsSetMotion(0, "工具を出す", 2)
	event.ObjsNextMotion(0, "工具を出すL", 6)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "武器おろし", 6)
	event.ObjsNextMotion(0, "武器おろしL", 4)
	event.ObjsSePlay(0, var0, 11)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(37)
	end
	event.CharaActive(10)
	event.ObjsTexaDelay(1, 25)
	event.ObjsTexAnime(1, 1, "イィッ")
	event.ObjsTexAnime(0, 0, "真剣口")
	if vm.wait() then
		return skip(38)
	end
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_b8bc5976(60410, 160)
	if vm.skipping() then
		return skip(39)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsTexAnime(0, 0, "得意口")
	event.ObjsTexAnime(0, 1, "真剣口")
	event.ObjsTexAnime(1, 0, "イィッ")
	event.StreamOpen3(1, 60420)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(41)
	end
	event.StreamPlay(1)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(42)
	end
	event.StreamClose(1)
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60430, 170)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(1, "ミンツを見る戻り", 6)
	event.ObjsMotionWait(1)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(44)
	end
	event.StreamOpen3(1, 60433)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(45)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, 112.5, 104.0, 138.09, 25)
	event.ObjsRotation(1, 0.0, -2.91, 0.0, 10)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(46)
	end
	event.StreamClose(1)
	event.StreamOpen3(1, 60435)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(47)
	end
	event.EohSetFootSoundId(1, 2)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 112.5, 104.0, 138.09)
	event.ObjsAddPas(1, 101.97, 104.0, 102.83)
	event.ObjsAddPas(1, 89.86, 104.0, 69.5)
	event.ObjsAddPas(1, 68.34, 104.0, 21.46)
	event.ObjsAddPas(1, 31.72, 104.0, -50.16)
	event.ObjsAddPas(1, 5.79, 104.0, -85.32)
	event.ObjsAddPas(1, -6.62, 104.0, -126.94)
	event.ObjsAddPas(1, 2.98, 104.0, -174.2)
	event.ObjsAddPas(1, 8.78, 104.0, -191.0)
	event.ObjsAddPas(1, 10.66, 104.0, -225.67)
	event.ObjsStartPas(1)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(48)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "後ろを向く", 2)
	helper_ff0edc1d(80)
	if vm.skipping() then
		return skip(49)
	end
	event.StreamClose(1)
	event.StreamOpen3(1, 60440)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(50)
	end
	event.StreamPlay(1)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(51)
	end
	event.StreamClose(1)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(52)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(53)
	end
	event.SetCrossfade(60)
	event.ObjsSetMotion(0, "待ちくたびれ", 4, -1, 1)
	event.CharaActive(11)
	event.CharaActive(0, 10)
	event.CmrsSetPos(140.01, 119.16, 248.76)
	event.CmrsSetRef(99.95, 120.89, 177.35)
	event.ObjsSetRot(0, 0.0, 0.73, 0.0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 10.66, 104.0, -225.67)
	event.ObjsAddPas(1, 8.78, 104.0, -191.0)
	event.ObjsAddPas(1, 2.98, 104.0, -174.2)
	event.ObjsAddPas(1, -6.62, 104.0, -126.94)
	event.ObjsAddPas(1, 5.79, 104.0, -85.32)
	event.ObjsAddPas(1, 31.72, 104.0, -50.16)
	event.ObjsAddPas(1, 68.34, 104.0, 21.46)
	event.ObjsAddPas(1, 89.86, 104.0, 69.5)
	event.ObjsAddPas(1, 101.97, 104.0, 102.83)
	event.ObjsAddPas(1, 112.5, 104.0, 138.09)
	event.ObjsStartPas(1)
	event.StreamOpen3(1, 60437)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(54)
	end
	event.StreamPlay(1)
	helper_ff0edc1d(100)
	if vm.skipping() then
		return skip(55)
	end
	event.EohSetFootSoundId(1, 3)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsMove(1, 114.43, 104.0, 184.04, 25)
	event.ObjsRotation(1, 0.0, -0.78, 0.0, 25)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsNextMotion(1, "銃を渡す", 6)
	event.ObjsMotionWait(1)
	event.ObjsSeDelay(1, 60)
	event.ObjsSePlay(1, var0, 12)
	event.ObjsSetMotion(0, "右向け右", 6)
	event.ObjsNextMotion(0, "右向け右L", 4)
	event.StreamClose(1)
	event.StreamOpen3(1, 60445)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(58)
	end
	event.StreamPlay(1)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(59)
	end
	event.StreamClose(1)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60450, 40)
	if vm.skipping() then
		return skip(60)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsSetMotion(0, "銃を受け取る", 2)
	event.ObjsMotionDelay(0, 1)
	event.ObjsNextMotion(0, "銃を受け取るL", 6)
	event.ObjsNextMotion(0, "銃を受け取るL2", 4)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var0, 13)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(62)
	end
	event.DelReference(11)
	event.SetReference(0, "gun_hand", 11)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(63)
	end
	event.ObjsSetMotion(1, "銃を渡す戻り", 6)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60460, 40)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60470, 100)
	if vm.skipping() then
		return skip(65)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60475, 120)
	if vm.skipping() then
		return skip(66)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsSetMotion(0, "すごいよ", 6)
	event.ObjsNextMotion(0, "すごいよL", 4)
	event.ObjsTexAnime(0, 0, "真剣口")
	if vm.wait() then
		return skip(68)
	end
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_b8bc5976(60480, 90)
	if vm.skipping() then
		return skip(69)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60490, 50)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsSetMotion(1, "立ち")
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_b8bc5976(60500, 60)
	if vm.skipping() then
		return skip(71)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(72)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(73)
	end
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.CmrsSetPos(136.41, 122.25, 229.2)
	event.CmrsSetRef(102.5, 130.77, 197.18)
	event.CmrsMove(123.15, 123.01, 222.97, 110.99, 134.65, 195.81, 120)
	event.SetBgmVol(0)
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(0, "銃を掲げる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "銃を掲げるL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsSePlay(0, var0, 14)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 15)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(2, "発動", 6)
	event.ObjsMotionWait(2)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(74)
	end
	event.CharaActive(0, 12)
	helper_c8f0(22, 1)
	if vm.skipping() then
		return skip(75)
	end
	helper_b7c85616(0, 4)
	event.MesMake_2(
		0,
		"[(!)][l1]ボタンでかまえて(O)ボタンで攻撃できるぞ！\n   距離によって威力がかわるから\n   あまり遠くから撃つと効果が薄いぞ！"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(76)
	end
	helper_b7c85616(0, 7)
	event.SetMesDrawspeed(0, 0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(77)
	end
	event.SetBgmVol(-1)
	event.ObjsTexAnime(0, 1, "真剣目")
	event.ObjsTexAnime(0, 1, "真剣口")
	event.CharaActive(0, 12)
	event.CharaActive(0, 11)
	event.CmrsSetPos(140.01, 119.16, 248.76)
	event.CmrsSetRef(99.95, 120.89, 177.35)
	event.CharaActive(1, 13)
	event.ObjsSetPos(1, 114.41, 103.98, 185.73)
	event.ObjsSetMotion(0, "右向け右L", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(1, "レシーバーをあげる", 6)
	event.ObjsNextMotion(1, "レシーバーをあげるL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60510, 160)
	if vm.skipping() then
		return skip(78)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(0, "レシーバーをもらう", 6)
	event.ObjsNextMotion(0, "レシーバーをもらうL", 4)
	helper_ff0edc1d(14)
	if vm.skipping() then
		return skip(80)
	end
	event.SndSePlay(var0, 19)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(81)
	end
	event.DelReference(13)
	event.SetReference(0, "ef00", 13)
	event.ObjsSetMotion(0, "レシーバーを下ろす", 6)
	event.ObjsNextMotion(0, "レシーバーを下ろすL", 4)
	event.ObjsSetMotion(1, "レシーバーをあげる戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60520, 80)
	if vm.skipping() then
		return skip(82)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60530, 40)
	if vm.skipping() then
		return skip(83)
	end
	helper_c8f0(359, 1)
	if vm.skipping() then
		return skip(84)
	end
	event.CharaActive(0, 13)
	event.CmrsSetPos(0.0, 174.49, 49.35)
	event.CmrsSetRef(0.0, 126.26, 245.83)
	event.ObjsSetPos(0, 0.0, 48.0, 267.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 24.15, 104.0, 216.41)
	event.ObjsSetRot(1, 0.0, -0.2, 0.0)
	event.ObjsSetMotion(0, "はしご上立ち", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60540, 40)
	if vm.skipping() then
		return skip(85)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60550, 30)
	if vm.skipping() then
		return skip(86)
	end
	event.CmrsSetPos(-104.06, 146.74, 477.55)
	event.CmrsSetRef(16.01, 86.26, 244.13)
	event.ObjsSePlay(0, var0, 16)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 17)
	event.ObjsSetMotion(0, "飛び降りる", 6)
	event.ObjsMotionWait(0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(87)
	end
	event.CmrsSetPos(-45.88, 52.01, 341.35)
	event.CmrsSetRef(16.98, 101.86, 233.55)
	event.ObjsSetPos(1, 7.1, 104.0, 227.78)
	event.ObjsSetRot(1, 0.0, -0.08, 0.0)
	event.ObjsSetMotion(1, "下を見るL", 4)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_b8bc5976(60560, 90)
	if vm.skipping() then
		return skip(88)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(89)
	end
	event.ObjsSetMotion(0, "振り返る戻り", 6)
	event.ObjsMotionWait(0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(90)
	end
	event.ObjsSetMotion(0, "走り2")
	event.ObjsMove(0, 0.0, 48.0, 600.0, 140)
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "下を見る会話")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_b8bc5976(60570, 200)
	if vm.skipping() then
		return skip(91)
	end
	event.CmrsSetPos(-15.79, 151.18, 139.2)
	event.CmrsSetRef(4.88, 115.54, 302.4)
	event.ObjsSetPos(0, 0.0, 48.0, 400.0)
	event.ObjsMove(0, 0.0, 48.0, 600.0, 60)
	helper_b8bc5976(60580, 50)
	if vm.skipping() then
		return skip(92)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(93)
	end
	event.CmrsSetPos(0.0, 61.0, 700.0)
	event.CmrsSetRef(0.0, 29.0, 850.0)
	event.EohSetFootSoundId(0, 15)
	event.ObjsSetPos(0, 0.0, 0.0, 750.0)
	event.ObjsMove(0, 0.0, 0.0, 830.0, 30)
	event.ObjsResetDaPosition(0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(94)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(95)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-2.62, 29.33, 799.72)
	event.CmrsSetRef(-2.62, 22.33, 827.0)
	event.ObjsSetMotion(0, "心配ないさ", 2)
	event.ObjsNextMotion(0, "心配ないさL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	if vm.wait() then
		return skip(96)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(60590, 60)
	if vm.skipping() then
		return skip(97)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(60595, 160)
	if vm.skipping() then
		return skip(98)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(99)
	end
	event.ObjsSetMotion(0, "心配ないさ戻り", 2)
	event.ObjsNextMotion(0, "旧･立ち", 4)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(100)
	end
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(101)
	end
	event.ObjsMove(0, 0.0, 0.0, 1230.0, 120)
	event.ObjsSetMotion(0, "走り2")
	event.CmrsMove(-2.62, 26.75, 843.0, -2.62, 24.35, 939.2, 120)
	event.EohSetFootSoundId(0, 15)
	helper_ff0edc1d(14)
	if vm.skipping() then
		return skip(102)
	end
	event.EohSetFootSoundId(0, 2)
	helper_ff0edc1d(76)
	if vm.skipping() then
		return skip(103)
	end
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_076280e8()
	if vm.skipping() then
		return skip(104)
	end
	return part2()
end

--- Helper function.
local function helper_42318()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_8a56995e(1)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, 8, 0, 0)
			end
			if at <= 3 then
				helper_b7c85616(0, 1)
				var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 4 then
				helper_b7c85616(0, 7)
				helper_3ae2c()
				if not vm.skipping() then
					return landing1()
				end
			end
			return 1
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, 0, 8, 0)
		end
		if at <= 7 then
			helper_8a56995e(1)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_ff0edc1d(11)
		end
		return 0
	end
	function part2()
		event.ObjsRotation(1, 0.0, 0.85, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
		event.ObjsSetMotion(1, "立ち")
		helper_ff0edc1d(11)
		if vm.skipping() then
			return skip(10)
		end
		return 0
	end
	function landing1()
		return 1
	end
	event.Initialize()
	helper_b7c85616(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(8)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var11 = event.AngleCmp(var7, yaw, 0.1) or var11
	if var11 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "立ち")
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, 60180)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, "それでこれからどうするんだ？")
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	helper_3dd465f9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
	helper_b7c85616(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "もう少しここにいるよ。\n地下水路・・・")
	var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_b7c85616(0, 7)
	event.SetMesShippo(0, 1)
	if var12 == 1 then
		event.StreamClose(1)
		helper_3ae2c()
		if vm.skipping() then
			return skip(5)
		end
		return 1
	else
		event.StreamOpen3(1, 60190)
		helper_8a56995e(1)
		if vm.skipping() then
			return skip(6)
		end
		event.StreamPlay(1)
		event.MesMake_2(0, "もう少しここにいるよ。")
		helper_3dd465f9(0, -1, 0, 8, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.StreamClose(1)
		event.StreamOpen3(1, 60200)
		helper_8a56995e(1)
		if vm.skipping() then
			return skip(8)
		end
		event.StreamPlay(1)
		event.MesMake_2(0, "ああ、いくらでも、ゆっくりしていけ。")
		helper_3dd465f9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.StreamClose(1)
	end
	return part2()
end

--- Helper function.
local function helper_106e8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"おぉ、坊ちゃんでしたか、驚いた。\nちょうど木についた悪い虫を取っていたところです。<page>植物は勝手に育つ物ばかりじゃなく、こんな風に\n世話をしないと枯れてしまうのもあるんですよ。"
		)
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_103b4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_10a10(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_103b4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]グリンをシャーロットに移住させるためには、\n   まず、グリンを冒険に連れ出さねばなりません。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_11750(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_103b4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ユリス坊ちゃん。この木を\n治すのがアッシの仕事です。<page>この木を治すためには・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(
			0,
			"坊ちゃん、これじゃあ\nどうにもなりません。<page>やはり、ブルーノさんの\n「聖水」でないと。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"おお！坊ちゃん。これで\nこの木は助かります。<page>ありがとうございます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"さて、坊ちゃん。これで\nひとまず仕事は済みました。<page>坊ちゃんの冒険に\n同行させてもらいます。<page>あ、それと「聖水」のことは、\nダンナ様にはナイショですよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]グリンが仲間になった。\n   メインメニューの「キャラクター」から\n   「ステータスを見る」で能力が使えます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間がさらにふえた場合\n   列車の中に乗って、冒険に同行するので\n   話しかけてキャラを切り換えます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間を他の土地に移住させるためには、\n   建てた家の扉に出るメニューから\n   「移住させる」を選んでください。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]他にもいろいろな場所に、\n   仲間になってくれる人がいるかも\n   しれません。探してみましょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

--- Helper function.
local function helper_12390(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "お嬢さん、アッシに何かご用で？")
		else
			event.MesMake_2(0, "坊ちゃん、「聖水」のことは、\nダンナ様にはナイショですよ。")
		end
	else
		event.MesMake_2(
			0,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12690(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_106e8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_106e8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_10a10(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_11750(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_12390(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_14f68(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3c8e2192(arg0, 0, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_3c8e2192(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"やぁ、ユリス、\nこんにちは。<page>いつも元気そうで\nうらやましいよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_15374(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_eb838ef8(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_3c8e2192(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "・・・")
		helper_3dd465f9(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "やぁ、ユリス、\nこんにちは。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "・・・")
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]いにしえの巨木・・・\n   金の卵が宿っちゃうような、\n   そんなとんでもない木なんて、\n   どこに行けば生えているんでしょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_be18(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(1, 4)
			var1 = 50
			var1 = 51
			helper_eb838ef8(1, var1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b7c85616(1, 4)
	event.MesSetBuff(1, 1, 1)
	var2 = event.GetPartyCharaMesNo_3(arg0, 0) or var2
	event.SetMesItemDirect(1, 1, var2)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if true then
		var1 = 50
	else
		var4 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var4
		event.SetMesItemDirect(1, 2, var4)
		var1 = 51
	end
	helper_eb838ef8(1, var1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

--- Helper function.
local function helper_102d4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_be18(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_be18(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1648c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_102d4()
		end
		if at <= 8 then
			helper_be18(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 376 then
		event.MesMake_2(
			0,
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_be18(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_16c44(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
	else
		event.MesMake_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_16e6c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14f68(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_14f68(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_15374(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1648c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_16c44(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_dcbc(arg0: s32)
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
local function helper_ddc0()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_f96a9d1b(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_dcbc(15)
		end
		if at <= 3 then
			helper_dcbc(1)
		end
		if at <= 4 then
			helper_dcbc(6)
		end
		if at <= 5 then
			helper_dcbc(0)
		end
		if at <= 6 then
			helper_dcbc(4)
		end
		if at <= 7 then
			helper_dcbc(31)
		end
		if at <= 8 then
			helper_dcbc(35)
		end
		if at <= 9 then
			helper_dcbc(36)
		end
		if at <= 10 then
			helper_dcbc(37)
		end
	end
	if vm.skipping() then
		return skip(1)
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
		helper_f96a9d1b(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_dcbc(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_dcbc(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_dcbc(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_dcbc(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_dcbc(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_dcbc(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_dcbc(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_dcbc(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_dcbc(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_172e0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"もう店じまいだ。これからは\n親父の店で買ってくれ。<page>カボチャが目印だ。知ってるだろ。\nそこのはしごから出りゃすぐだから。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_17150(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_17470(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_17150(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"聞かなくてもわかるだろう、\nお、こ、と、わ、り、だ。<page>何で俺様が人様の為に\n働かなくちゃいけないんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "大してもうかりそうもないし\nおっかないのはごめんだよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でもなぁ、他ならぬ\nユリスの頼みだし、曲げて\n話を聞いても良いぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "でもよ、俺も商人のせがれ、\nもうからない事はやらない\n主義だ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"知ってるだろう、俺が\nコインを集めてるって事。<page>コインは商いの象徴だ。\nなんとしてもコンプリート\nしたいんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"でも、『鉄壁のコイン』\n『暗黒のコイン』が\nどうしても手に入らないんだ。<page>なんとかしてくれたら、\n俺もなんとかしてやるぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_17ba4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_102d4()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_17150(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"なんだよ、あぁ、\nコイン集めの話か？<page>『鉄壁のコイン』\n『暗黒のコイン』だぜ。\nなかなか手に入らないだろう。<page>なんせ俺が探しまくっても\nお目にかかれなかった\nシロモノだからな。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"え？\nコインを集めちまったのか、\nマジでか！<page>なにもったいぶってんだよ、\nくれくれくれー！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ。\nどうしようかな？")
	var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(
			0,
			"あぁ！そんないじわる\nするんなら、俺も仲間に\nなんかならないぜ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"すげぇ、本当にそろっちまった。\n絶対無理だと思ってたのに・・・<page>しょうがねぇ、めんどくさいけど\nいっしょに行ってやるよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_18634(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_17150(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"集められっこないと\n思って、ダメモトで\n言ったんだけどな。<page>やっぱ、ユリスは\nすごいぜ。"
		)
	else
		event.MesMake_2(
			0,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18944(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_172e0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_172e0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_17470(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_17ba4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_18634(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_18c28(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "こんにちは。\nモニカさんはどんな\n食べ物が好きですか？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"僕はもちろんおいしい物が\n好きですが、めずらしい\n食べ物にも目がないんですよ。"
		)
	else
		event.MesMake_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_18ff0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、「発明」の\n調子はどうですか？<page>坊ちゃんが機械や仕掛けを\n「発明」するように、私は\n料理を「発明」しています。<page>まだ誰も食べた事のない\n美味い食べ物を作るために、\n日々研究をしています。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_191d0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あ、坊ちゃん、ちょうど良い所へ。\nちょっと相談があるんですよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"僕が研究のために世界中の\nめずらしいお菓子を作って\nいるのはご存知ですよね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "なんでも、「カスタニャッチョ」\nというお菓子があるそうで、")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "それは「カスターニャ」という\n物を使って作るらしいんです。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"いろいろ調べてみて、その\n「カスターニャ」ってのは、<page>どうも『とんがりマロン』と\n同じ種類の木の実らしいと\nいう所までは突き止めました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そこで、とりあえず『とんがりマロン』を\n使って作って見ようと思ったのですが、<page>不思議な事に、町中の『とんがりマロン』が\n売り切れてしまっているのです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"なんでも、町長が\n買い占めてしまったとか。<page>坊ちゃん、なんとか\nなりませんか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1995c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "『とんがりマロン』は\n手に入りましたか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(
			0,
			"やっぱり無理ですか・・・\n仕方ないですね。<page>「カスタニャッチョ」は\nあきらめます。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"おお、これです。\nありがとうございます。<page>これで「カスタニャッチョ」を\n作ってみます。<page>出来たら真っ先に坊ちゃんに\n食べていただきますからね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、\n私に何かご用で？<page>へ、坊ちゃんの冒険に\nついて来いですって。<page>はは、そりゃもちろん\nついて行きますとも。<page>なんで最初にそう言って\n下さらなかったんですか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1a054(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "僕が坊ちゃんの頼みを\n断るわけないじゃないですか。")
	else
		event.MesMake_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1a29c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_18c28(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18c28(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_18ff0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_191d0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1995c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1a054(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1a628(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "こんにちは、ユリスの\nガールフレンドさん？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"めずらしい髪の色ですね。\nトムみたいな赤毛ともちがう、\nまるで宝石みたい。<page>ステキだわ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1a8e8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a628(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a628(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ユリス、最近町の外に\n出かけてるんでしょう？<page>隠したってだめよ、\n知ってるんだから。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1ab00(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a628(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"そうね、ユリスの頼みだから聞いて\nあげたいけど、戦うなんて物騒だし\nなんだか汚れちゃいそう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"何よりみんなの足手まといに\nなるのはいやだわ。悪いけど\nお断りします。ごめんなさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、町の外には、\n珍しい物がたくさん\nあるんでしょうね。<page>どんな木が生えてて、\nどんな花が\n咲いてるのかしら。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"ねぇユリス、めずらしい花を\n見つけたら、写真を撮って来て\nちょうだい。ぜひ見てみたいわ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]一度は断られましたが、あきらめるのは早そうです。\n   クレアが興味を持つような写真を見せれば、\n   いっしょに旅をしてくれるかも知れません。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1b264(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_102d4()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a628(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"めずらしい花の写真は\n撮れたのかしら？<page>私もいろいろな花を\n知ってるから、ちょっとや\nそっとじゃおどろかないわよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1ba74(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1a628(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.MesMake_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1bd34(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a8e8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_1a8e8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1ab00(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1b264(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1ba74(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1c018(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"そう思っているのは私だけかも\nしれませんが、モニカさんは、\nエイナ様に似てらっしゃいます。<page>雰囲気と言うかなんと言うか、\nお二人とも、この町の人とは\n何かが違うと思えてなりません。"
		)
	else
		event.MesMake_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1c2d0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、何か困った事が\nあれば、誰よりもまず\nこの私に相談してください。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c430(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"坊ちゃんの頼みとあらば、\n出来る限りの事をして\n差し上げます。<page>お任せください。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"引き受けてくれとは\n申しません・・・<page>ただ、私の話を聞いて\n頂きとうございます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"この家にお仕えして３０余年、\n真面目だけが取り得と\n今まで尽くしてまいりました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "そんな仕事しか取り得の\nない私の、唯一の趣味が\n読書なんです。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"すごく貴重で珍しい本が\nありまして、その本が今、\nオークションに出ているのです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"まさに競り合っている最中なのです。\n思うに、１０００ギルダもあれば\n落札出来ます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"でも、そんな大金、とても\n持ち合わせていませんし、<page>こんな事、だんな様に\nご相談したなら、呆れ果てて、\nお暇を頂く事になるでしょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"ですから、お頼みできるのは、\n坊ちゃんだけなのです。<page>決して、決して交換条件と\nいう訳ではございませんよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]なんだかんだ言って、１０００ギルダ渡さないと\n   スチュアートは仲間になってくれそうにないですね。\n   仕方ありません。お金を用意しましょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1cf1c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_ff0edc1d(30)
			end
			return
		end
		if at <= 13 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"坊ちゃん、そんな額では、\nオークションにすら\n出られませんよ。<page>１０００ギルダです。\nしっかりして下さい。"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>１５００ギルダ、\n急いでください。"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>２０００ギルダ、\n急いでください。"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		var4 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"そうですか・・・やはり２０００ギルダは\n大金ですから、惜しくなってしまうのですね。\nこんなに裕福な坊ちゃんと言えども・・・<page>わかりました。あきらめます！\nでも、オークションはまだ続いています。\n私は待っていますよ、いつまでも・・・"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(
			0,
			"あぁ、坊ちゃん、\nありがとうございます。<page>では、急いで\nオークショニアの所へ\n行って来ます！"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "坊ちゃん、\nありがとうございました。\n無事、落札できました。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_1e5a4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"落札した本ですか？\n実はまだ読んでないんです。<page>なんだか、手に入った事で、\n満足してしまったようです。"
		)
	else
		event.MesMake_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e80c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c018(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c018(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1c2d0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1c430(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1cf1c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1e5a4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1eb98(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "くれぐれも坊ちゃんを\n危ない目には\nあわせないで下さいね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"坊ちゃんにすりキズひとつでも\nつけたら、このルネが\nしょうちしませんから！"
		)
	else
		event.MesMake_2(0, "ご無事をお祈りします・・・")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1ef20(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"今はこうしてメイドをして\nますけど、洋服屋さんに\nなるのが小さい頃の夢でした。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "夢は実現しないから\n夢って言うんですよね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1f1d0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]あらら、ルネは完全に自信をなくしている\n   みたいですね。このままではいけません。\n   もう一度、洋服を作ってもらいましょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_1f7fc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね、もう一度洋服を作ってみて、\n今度こそ完成させられたら、また自分を\n信じる事が出来るかも知れません。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、洋服を作る材料なんて\n持っていません。<page>坊ちゃん、\n用意できないでしょうか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"服を作るには、『意外と丈夫な布』\n『銅のかたまり』それと\n『ぶあつい皮』があれば充分です。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_1fc0c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3c8e2192(arg0, 0, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_ff0edc1d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"材料がないと服は作れません。<page>『ぶあつい皮』『銅のかたまり』\nそれと『意外と丈夫な布』です。<page>甘えるようですが、\nお願いします。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "これで服を作ってみなよ！\nやっぱり、もったいないや")
	var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "材料がないと服は作れません。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(214)
	event.SubItem(245)
	event.SubItem(227)
	event.SetCnt(8, 2)
	event.MesMake_2(
		0,
		"ありがとうございます！\nこれで服を作ってみます。<page>坊ちゃんのお気持ち、\n決してむだにはしません。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_20610(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_c8f0(var2, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_102d4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_c8f0(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_20cfc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"洋服の着心地は\nどうですか？<page>正直な意見を\n聞かせてください。"
		)
	else
		event.MesMake_2(0, "ご無事をお祈りします・・・")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20f14(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1eb98(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_1fc0c(arg0, arg1)
			end
			if at <= 6 then
				helper_20610(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1eb98(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1ef20(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_1f1d0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_1f7fc(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_1fc0c(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_20610(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_20cfc(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_2219c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"最近、ユリスと\nいっしょにいる娘だね。<page>なかなか男を見る目が\nあるよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "私もあともうちょっと若けりゃ、\n放っておかないんだけどねぇ。")
	else
		event.MesMake_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_22534(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"商売はお客の\n信用が第一。<page>ないがしろにしちゃ\n絶対にいけないよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_22694(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c8f0(300, 20)
		end
		if at <= 5 then
			helper_1b06d86e(1)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "私はその間に旅の支度を\nしておくからさ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_c8f0(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_22c44(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"なんだって！モートンの奴、\n勝手なことばっかり言って。<page>もう、いいわ、\nそのパンは全部あげる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_102d4()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_23254(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"さぁ、ユリス、\n出発しましょう。<page>どこへだって\nついて行きますよ。"
		)
	else
		event.MesMake_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2348c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2219c(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_2219c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_22534(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_22694(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_22c44(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_23254(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1295c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"女の子が剣を振り回すなんて、\n私はあまり好きではないな。<page>例えばルネさんのような、\nおしとやかな女性が一番だよ。"
		)
	else
		event.MesMake_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12bc4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"この町は平和すぎて、\n私のかつやくする場が\n全然ない。<page>もちろん、それが\n良い事なのはわかって\nいるんだが・・・"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12d54(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_13024(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "やってみるよ。\nボクにはムリだ。")
	var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(
			0,
			"そうか・・・<page>じゃ、挑戦する気になったら\n来なさい。待っているよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "じゃ、用意ドン！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_13598(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_13024(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "やぁ、ユリス。私を\n呼びに来たのかい？<page>待っていたよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"城壁のおかげでこの町は\nとりあえず無事だ。<page>今度は我々が\n打って出る番だ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"しかし、ユリスは\n機械いじりばかりしてるけど、\n体力は大丈夫なんだろうね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"戦いの基本はスピードと\nフットワークだ。<page>私よりのろまだと\n話にならんよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そうだな、試しに\n池のボートまで行って\n戻って来てみろ。<page>私の記録は２分１秒だ。\nそれ以上かかるようなら\n話にならんね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "どうだ、挑戦してみるか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_13024(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_13bdc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_13024(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_13024(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_13024(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_13024(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_102d4()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_13024(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"こら、ボートまで行かなかった\nだろう。俺にはお見通しだぞ。\nインチキするな！"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_13024(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "こら、インチキするな！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_13024(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "お、戻ってきたな。\nじゃ、タイム発表！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "おいおい、\n[数値１]分[数値２]秒[数値３]なんて\n遅すぎるぞ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_13024(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(
		0,
		"お、[数値１]分[数値２]秒[数値３]とは\nなかなかのタイムじゃないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"見かけによらず、良い足を\nしている。わかった、\nいっしょに悪と戦おう！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_1489c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"見かけによらず、なかなかの\n足を持ってるじゃないか。\n見なおしたぞ。"
		)
	else
		event.MesMake_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14ad4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1295c(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1295c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_12bc4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 ~= vm.f32(1182.3) or var6 ~= vm.f32(210.6) then
		helper_12d54(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_13598(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_13bdc(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_1489c(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_23818(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"サーカスで見かけたって？\n結構、かっこよかったろう。<page>まぁ、アルバイトと言うか\n趣味みたいなもんかな。"
		)
	else
		event.MesMake_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_23a80(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"うちの店は刃物専門だよ。<page>一応、銃も扱ってはいるが、\nどうも飛び道具は\n性に合わなくってね。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23bf0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_c8f0(44, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_c8f0(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_24394(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"なんだよ、その剣は？\nけっきょく口だけかい。<page>なら、帰んな。\n商売のじゃまだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "ほう、なかなかの\n剣じゃないか。<page>試したみたいで\n悪かったな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "しろうとといっしょに戦うと、\nこっちも危なくなるからね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、あんたの腕なら\nそんな心配はなさそうだ。<page>わかった、いっしょに\n戦うよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_249d0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"よくきたえられた\n剣のかがやきは\n素晴らしいよ。<page>吸い込まれそうだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "石ころをみがいて\nありがたがっている\n奴の気が知れないね。")
	else
		event.MesMake_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_24d68(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_23818(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_23818(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_23a80(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_23bf0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_24394(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_249d0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_250f4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "ユリスのお友達かな？<page>まぁ、ゆっくりして\n行きなさい。")
	else
		event.MesMake_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2535c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "機械いじりも良いが、\nそろそろ鉱山の事も\n勉強したらどうだ。")
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_254ac(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_c8f0(24, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_c8f0(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_25be0(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"どうした、また\nあきらめるのか？<page>それも良かろう。\n部屋で機械いじりでも\nしていることだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"ほう、銃の扱いにも\nだいぶ慣れて来たようだな。<page>撃っている姿を見なくても、\n持ち方を見ればわかる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、力を貸してやろう。\nただし、これはおまえのためじゃない。<page>この町に良からぬ事が起きるのであれば、\nだまっているわけにいかないからな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_26120(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"銃は子供の\nおもちゃじゃない。<page>扱いに気をつけないと\n怪我をするぞ。"
		)
	else
		event.MesMake_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_26398(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_250f4(arg0, arg1)
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_250f4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2535c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_254ac(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25be0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_26120(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_26724(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d1f370f3(arg0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_d1f370f3(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"・・・１２１２、<page>いやいや、１１２２\nだったような気が。<page>それとも１０１０\nだったかな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]目の前で話しかけているのに気づかないなんて、\n   何やら大きな悩み事があるみたいですね。<page>   後でまた来てみましょう。もしかしたら、\n   力になってあげられるかもしれませんよ。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_26b84(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_fff7b413(arg0, arg1)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_fff7b413(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"何ぶつぶつ\n言ってるのかって？<page>金庫の暗証番号を\n思い出してるんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"どこの金庫かって？<page>町長室のがくぶちの裏に\n隠してある金庫に\n決まっているだろう・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_fff7b413(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"わぁ、おどかさないで\nくれよ。<page>あ、しまった！<page>町長の最大の秘密を\nしゃべってしまった！<page>でも、ここまで聞かれた\nのならしようがない。<page>たのむ、知恵を貸して\nくれないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "困った事に、金庫の\n暗証番号を忘れて\nしまったんだよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"４桁の数字なんだが、絶対\n忘れないようにと、クレアの\n誕生日にしておいたんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まさか、それを\n忘れてしまうなんて・・・<page>親として恥ずかしいやら、\n情けないやら。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]町長はとても困っているみたいです。\n   クレアの誕生日にまつわる話を聞いて、\n   そこから暗証番号を推理してみましょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_27504(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_ff0edc1d(30)
			end
			if at <= 11 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_ff0edc1d(15)
			end
			return
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_650bfa16(0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_ff0edc1d(15)
		end
		if at <= 18 then
			helper_ff0edc1d(15)
		end
		if at <= 19 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(
			0,
			"【手がかり１】昔、誕生日に\nちなんだ星座のブローチを\nあげた事があったっけ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ポリーに用意してもらったから\nよく覚えてないんだが、確か４本足の\n動物だったような気がする・・・"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"【手がかり２】\n今まであげた誕生日の\nプレゼント？<page>う～ん、コートとか\nマフラーとかが\n多いかなぁ。<page>どんなのが良いのか\nさっぱりわからんので、\n毎年苦労するんだよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"【手がかり３】そうそう、クレアの誕生日は、\n燃えるゴミを出す日と、燃えないゴミを出す日が\n重なってるんで、いつも大変なんだよ。<page>ああ、我が家でゴミを出すのは私の役目だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"燃えないゴミを出す日は\n日にちが７で割り切れる日、<page>燃えるゴミを出す日は\n３で割り切れる日だよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "まさか、忘れてたんじゃ\nないだろうね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"わかった、謎は解けたぞ！暗証番号は・・・\nわからない・・・もっと話を聞いてみよう。"
		)
		var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(8)
		end
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.Finish()
				return
			end
			event.SetMotion(arg0, "会話")
		end
	end
	event.SetMenuEtc(0, "暗証番号を入力してください", "１２２１", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.Finish()
		return
	end
	event.SetFadeOut(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(10)
	end
	var7 = event.GetSndId(2) or var7
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaRot(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.SetCharaPos(arg0, -100.0, 0.0, -110.0)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.Atan2f(-100.0 - var14, -110.0 - var16) or var20
	event.SetCharaRot(0, 0.0, var20, 0.0)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(64.64, 46.9, 92.64)
	event.SetCameraRef(-100.0, 20.0, -110.0)
	event.SetFadeIn(15)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(
			0,
			"う～ん、開かないな。\n困った・・・<page>とても大事な書類が\n入っているんだが。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_ff0edc1d(15)
		if vm.skipping() then
			return skip(13)
		end
		event.SetCharaRot(0, var17, var18, var19)
		event.SetCharaPos(arg0, var8, var9, var10)
		event.SetCharaRot(arg0, var11, var12, var13)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetFadeIn(15)
		event.Finish()
		return
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "え・・・と、\n１、<page>２、<page>２、<page>１・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "うわっ！<page>やった、\n開いたぞ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "おお、これで重要な\n書類が取り出せるよ。<page>ありがとう。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"重要な書類って\n何かって？<page>私がいない時は、副町長の\nモートンに、町長の仕事を\n代行してもらうための書類だよ。<page>いささか不安ではあるが、\nまぁ、大丈夫だろう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"よし、これで私もこの町を\n離れられるようになったぞ。<page>話はスターブルから\n聞いている。<page>さぁ、いっしょに\n連れて行ってくれ！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_29444(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "ゴミはきちんと分別\nして、決められた日に\n出すようにな。")
	else
		event.MesMake_2(
			0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2968c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26724(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_26724(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_26b84(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_27504(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_29444(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2a348(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "これから先も、永久に世界が\n平和でありますように。")
	else
		event.MesMake_2(0, "正しき事を成そうとするなら、\n賢くあらねばなりません。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2a594(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですか、私の力が\n必要ですか。<page>ならば、ひとつ\n問いを出しましょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"この教会のロウソクには、\nいささか仕掛けが\nしてありましてね。<page>点いていれば消え、\n消えていれば点く。<page>ひとつが変化すれば、\nその隣り合うロウソクにもまた、\n変化が訪れます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"うまく全てのロウソクを\n消す事が出来れば、賢者と認め、\n同行いたしましょう。<page>解ければ良し、解けなくば\n力は得られぬと心得なさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]これまたよくわからない問題ですね。\n   何回か挑戦してみて、決まりを知る事から\n   始めた方が良さそうです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]教会から外に出てまた入れば、ロウソクは全て\n   元に戻るみたいです。失敗を恐れずやってみましょう。\n   実は正解って、すごく簡単な事かも知れませんよ。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_29970()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var14 = 0
		var15 = 0
		var14 = var14 + 1
		var15 = var15 + 1
		return var14
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	var15 = 0
	while var15 < 14 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
		var15 = var15 + 1
	end
	return var14
end

--- Helper function.
local function helper_2acd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_29970()
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_29970()
	if 0 < var2 then
		event.MesMake_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"よく分かりましたね。\nすばらしい。<page>君なら私の期待にも\n答えてくれることでしょう。<page>約束でしたね。私も\n君と共に行きましょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2b1b0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2a348(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b248(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2a348(arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2a348(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2a594(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2acd0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2b1b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2b538(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"なんでこんなに月が恋しいんだろう。<page>もしかしたら、僕はあそこから\n来たのかも知れない・・・"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2b6a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "う～ん、いっしょに\n行ってあげても良いけど、\nそこに月はあるの？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "本当に？言葉だけじゃ\n信じられないよ。人間は\nうそをつくからね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "やっぱり、やめとく。\nここで月が出るのを\n待っているよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]過去に何があったのかわかりませんが、\n   ルーシオは、完全に人間を信じられなく\n   なっているようです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]とにかく、信じてもらう事が先決です。\n   そんなに月を見ていたいと言うなら、\n   写真を撮ってあげたらどうでしょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2bcf4(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"キミだけは違うような気がしてたんだけど、\nやっぱり人間には変わりないって事だね。<page>でも、いいんだ。人間はうそをつくんだって\nもうなれっこになってるからね。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"わぁ、すごい！まるで\nここにあるみたいだ。<page>これなら、いつでもどこでも\n月を見られるね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"いっしょに来いって\n言うんでしょ。<page>いいよ。他に\n行く所もないし。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2c224(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "キミは月の写真をとってくれた。\nキミは良い人間なんだね。")
	else
		event.MesMake_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところにいけるようになるね。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c45c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2b538(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2b538(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2b6a8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2bcf4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2c224(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2c740(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"俺の趣味は釣りだ。<page>俺の夢は\nマーダンガラヤンを\n釣る事だ。<page>俺が尊敬するのは、\nでっかい魚を\n釣った奴だけだ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2c8d0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "俺様に頼み事だって？<page>上等だ、聞いて\nやろうじゃねぇか。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ただし、俺は\n俺が尊敬する奴の\n言う事しか聞かねぇ。<page>俺が尊敬するのは、俺より\nでかい魚を釣った事が\nある奴だけだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ちなみに、俺様が釣った中で\n一番でっかいのは、\n６０センチのノンキーだ。<page>どうだ、びびったかい？\n挑戦するなら、いつでも\n受けて立つぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]彼を仲間にするには、６０センチ以上のノンキーを\n   釣るしかなさそうです。でも、そんなにいばるほど\n   大きくはないような・・・"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]とりあえず、パームブリンクスの池で\n   釣りをしてみましょう。")
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2cf8c(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "ぷぷっ、[数値１]センチのしか\n釣れてないでやんの。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"そんな腕前で\n俺様を使おうなんて\n１００年早い！<page>顔を洗って\n出直してきやがれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "・・・お、おみそれしました。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "よし、俺も男だ。\n男に二言はない。<page>約束通り\n言う事を聞くぜ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "さぁ、煮るなり焼くなり\n好きにしやがれ！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2d7e4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"あのさ、気が向いた時で\n良いから、釣りのコツってのを\n教えてくんねぇか。"
		)
	else
		event.MesMake_2(0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2da1c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2c740(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2c740(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2c8d0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2cf8c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2d7e4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2dd00(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2de60(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "私も魚については、\nいささか自信があります。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"聞く所によると、人間は\n魚に競争をさせて\nいるとかいないとか。<page>あなたも魚を飼って\nいるのなら、それで\n一番になってみなさい。<page>そうすれば、\n私もあなたを認め、\n力になりましょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]彼女はどうやらギョレースの事を言っているようです。\n   さしあたり、ビギナークラスで優勝してみましょう。\n   彼女の態度も変わるかも知れません。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_2e44c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "魚は飼い主に似ると言います。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_2e940(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "私もいつの日か、\n表彰台の真ん中に\n立ってみたいものです。")
	else
		event.MesMake_2(
			0,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2eb78(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2dd00(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_2dd00(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_2de60(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2e44c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2e940(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2eebc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "最近、身体の\n調子が悪いの。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ダック先生に診て頂いたけど、\n身体には何の問題もないって。<page>なぜかしら？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2f15c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"最近、身体の調子が悪いの。<page>旅なんてとてもじゃないけど\n無理だわ。<page>ダック先生に看て頂いたけど、\n何の問題もないって。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、普通に\n立っているだけでも\n倒れそうになるの。<page>なんて言うのかな、\n世界がゆがんでしまった\nような感じがするのよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"う～ん、ダック先生でも\nわからないんじゃ、ボクに\nわかりっこないなぁ・・・"
		)
		helper_3dd465f9(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "この症状には\n覚えがあるわ。")
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"私の生まれた時代では、世界がかなり\n崩壊していて、空間のゆがみも、こことは\n比べ物にならないくらいだったの。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そんな世界だったから、特に\n身体の弱い人や神経の細やかな\n人ほど影響をうけていたのね。<page>軽い人はめまいや立ちくらみ、\n重い人だと立っていられなく\nなるくらい。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"ミーナさんは、特に\nその影響をうけやすい\n体質なのかも。<page>この程度の空間の\nゆがみでも、体調を\n崩すくらいだから。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"せめて近い場所のゆがみだけでも\n減らせれば、少しは楽にして\nあげられるかも知れないわね。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]時空のゆがみを修復する方法・・・\n   そうです。スフィーダがありますよね。\n   １０ステージくらいクリアすれば、\n   ミーナの体調も良くなるのではないでしょうか。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

--- Helper function.
local function helper_2fd48(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "まだ体調はすぐれないわ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_304a8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"助けてもらったから\n協力するけど、虫がいる\n所には行きたくないわ。"
		)
	else
		event.MesMake_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_306f0(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2eebc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_2eebc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_2f15c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_2fd48(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_304a8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_309bc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_30d34(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_ff0edc1d(30)
		end
		if at <= 13 then
			helper_ff0edc1d(30)
		end
		if at <= 14 then
			helper_ff0edc1d(60)
		end
		if at <= 15 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ\nおことわり")
	var3 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "なによ、いじわる！\nけちんぼ！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"ほんとに連れて\n行ってくれるの？<page>ダメモトでも\n言ってみるものね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_31dd4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_ff0edc1d(30)
			end
			return
		end
		if at <= 4 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"あぁ、\n見つかっちゃった・・・<page>ふぅ、なんだか\nあきて来ちゃった。<page>なんか、かくれてるのって\n意外とつまんないものね。<page>いいわ、そろそろ冒険に\n出発しましょう！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_3234c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "かくれんぼなんて、\nしょせん\n子供の遊びよね。")
	else
		event.MesMake_2(
			0,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32584(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_309bc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_309bc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_30d34(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_31dd4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3234c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32868(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"・・・<page>ああ、こんにちは。\n最近、耳が遠くなっちまってねぇ。<page>ゆっくりしゃべってもらわないと、\n聞き取れないんだよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_329f8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_102d4()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"なんだって？<page>すまないけど、もっとゆっくり\n話してもらえんかね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(
		0,
		"「いっしょに冒険しよう」と入力してください",
		"いっしょに冒険しよう",
		0
	)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 0 then
		event.MesMake_2(0, "う～ん、何を言ってるのか\nよくわからないねぇ・・・")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"冒険にかい？\n良いですとも。<page>こんなおいぼれが何の役に\n立つのか知れないけど。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_102d4()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_330cc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_329f8(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33158(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "こんなおばあちゃんでも、\n何かの役に立つのかねぇ。")
	else
		event.MesMake_2(
			0,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33390(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32868(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_32868(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_329f8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_330cc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_33158(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2178c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "中止だって！？\nそいつは残念だな。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_33674(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: any = 0
	local var16: s32 = 0
	local active_chr_no: s32 = 0
	local var18: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_12690(arg0, arg1)
			end
			if at <= 2 then
				helper_16e6c(arg0, arg1)
			end
			if at <= 3 then
				helper_ddc0()
			end
			if at <= 4 then
				helper_18944(arg0, arg1)
			end
			if at <= 5 then
				helper_1a29c(arg0, arg1)
			end
			if at <= 6 then
				helper_1bd34(arg0, arg1)
			end
			if at <= 7 then
				helper_1e80c(arg0, arg1)
			end
			if at <= 8 then
				helper_20f14(arg0, arg1)
			end
			if at <= 9 then
				var9 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 11 then
			return
		end
		if at <= 15 then
			if at <= 12 then
				helper_2348c(arg0, arg1)
			end
			if at <= 13 then
				helper_14ad4(arg0, arg1)
			end
			if at <= 14 then
				var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 16 then
			return
		end
		if at <= 21 then
			if at <= 17 then
				helper_24d68(arg0, arg1)
			end
			if at <= 18 then
				helper_26398(arg0, arg1)
			end
			if at <= 19 then
				helper_2968c(arg0, arg1)
			end
			if at <= 20 then
				var15 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 22 then
			return
		end
		if at <= 31 then
			if at <= 23 then
				helper_2b248(arg0, arg1)
			end
			if at <= 24 then
				helper_2c45c(arg0, arg1)
			end
			if at <= 25 then
				helper_2da1c(arg0, arg1)
			end
			if at <= 26 then
				helper_2eb78(arg0, arg1)
			end
			if at <= 27 then
				helper_306f0(arg0, arg1)
			end
			if at <= 28 then
				helper_32584(arg0, arg1)
			end
			if at <= 29 then
				helper_33390(arg0, arg1)
			end
			if at <= 30 then
				var18 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 32 then
			return
		end
		if at <= 33 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 34 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 35 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 36 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 37 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_12690(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_16e6c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			helper_ddc0()
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_18944(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	if var3 == 7 then
		helper_1a29c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var3 == 8 then
		helper_1bd34(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var3 == 10 then
		helper_1e80c(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var3 == 11 then
		helper_20f14(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var3 == 12 then
		var7 = event.GetQuestEtc(0, 0) or var7
		var8 = event.GetQuestEtc(0, 8) or var8
		if var7 == 2 and var8 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var9 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(10)
			end
			if var9 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var9 == 1 then
				helper_2348c(arg0, arg1)
				if vm.skipping() then
					return skip(11)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_ddc0()
			if vm.skipping() then
				return skip(12)
			end
		else
			helper_2348c(arg0, arg1)
			if vm.skipping() then
				return skip(13)
			end
		end
	end
	if var3 == 14 then
		helper_14ad4(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 15 then
		var10 = event.GetQuestEtc(0, 0) or var10
		var11 = event.GetQuestEtc(0, 10) or var11
		if var10 == 2 and var11 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(15)
			end
			if var12 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var12 == 1 then
				helper_24d68(arg0, arg1)
				if vm.skipping() then
					return skip(16)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_ddc0()
			if vm.skipping() then
				return skip(17)
			end
		else
			helper_24d68(arg0, arg1)
			if vm.skipping() then
				return skip(18)
			end
		end
	end
	if var3 == 16 then
		helper_26398(arg0, arg1)
		if vm.skipping() then
			return skip(19)
		end
	end
	if var3 == 17 then
		helper_2968c(arg0, arg1)
		if vm.skipping() then
			return skip(20)
		end
	end
	if var3 == 18 then
		var13 = event.GetQuestEtc(0, 0) or var13
		var14 = event.GetQuestEtc(0, 13) or var14
		if var13 == 2 and var14 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var15 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(21)
			end
			if var15 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var15 == 1 then
				helper_2b248(arg0, arg1)
				if vm.skipping() then
					return skip(22)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_ddc0()
			if vm.skipping() then
				return skip(23)
			end
		else
			helper_2b248(arg0, arg1)
			if vm.skipping() then
				return skip(24)
			end
		end
	end
	if var3 == 19 then
		helper_2c45c(arg0, arg1)
		if vm.skipping() then
			return skip(25)
		end
	end
	if var3 == 20 then
		helper_2da1c(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 21 then
		helper_2eb78(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 23 then
		helper_306f0(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 24 then
		helper_32584(arg0, arg1)
		if vm.skipping() then
			return skip(29)
		end
	end
	if var3 == 25 then
		helper_33390(arg0, arg1)
		if vm.skipping() then
			return skip(30)
		end
	end
	if var3 == 33 then
		var16 = event.GetQuestEtc(0, 8) or var16
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var16 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "買い物させて\nこんにちは")
			var18 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(31)
			end
			if var18 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var18 == 1 then
				helper_2178c(arg0, arg1)
				if vm.skipping() then
					return skip(32)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_ddc0()
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
			)
		else
			event.MesMake_2(
				0,
				"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
			)
		end
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
		else
			event.MesMake_2(
				0,
				"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
			)
		end
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
		else
			event.MesMake_2(0, "ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。")
		end
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
			)
		else
			event.MesMake_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
		end
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
			)
		else
			event.MesMake_2(
				0,
				"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
			)
		end
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(38)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_ebb8()
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
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_ddc0()
			end
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
		if at <= 8 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
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
		helper_ddc0()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
		helper_f96a9d1b(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(109) or flag
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_f96a9d1b(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_101a0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ebb8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_ebb8()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_35a24()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_33674(var1, player_chara)
		end
		if at <= 2 then
			helper_101a0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_33674(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_101a0()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_36004

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377a0()
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_37a40()
		end
	end
	flag = event.GetFlag(103) or flag
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_36004()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -112.0, 104.0, -114.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var3 = event.GetMapType(old_map_no) or var3
		if var3 ~= -1 then
			if old_map_no == 15 or var3 == 7 or var3 == 8 then
				helper_37a40()
				if vm.skipping() then
					return skip(1)
				end
			else
				helper_377a0()
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_37a40()
			if vm.skipping() then
				return skip(2)
			end
		end
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_35e90()
	event.SetCnt(5, 3)
	helper_37e84()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		event.SetSavedataEtc(3, 1)
	end
	helper_d3df4ea5()
	if vm.skipping() then
		return skip(1)
	end
	if flag == 1 then
		event.SetSavedataEtc(3, 0)
	end
end

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_3612c()
		end
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(
			0,
			"まだポルカスが探してるかも知れない。\nパームブリンクスに戻るのはやめとこう。"
		)
		helper_eb838ef8(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_3612c()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.MapJump(-1, "m01", 100)
		end
	end
end

--- Program 530.
script[530] = function()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_36440()
		end
		if at <= 3 then
			helper_37a40()
		end
		var2 = 0
		var6 = var6 + 1
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_36f80()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_36440()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.DngSetStageId(0)
			event.GotoMenu(3, 0)
			if vm.wait() then
				return skip(3)
			end
			do
				local _, out2, out3, _ = event.GetMenuParam_4()
				var2 = out2 or var2
				var3 = out3 or var3
			end
			if var3 == 0 then
				helper_37a40()
				if vm.skipping() then
					return skip(4)
				end
			else
				flag_2 = event.GetFlag(102) or flag_2
				if var3 == 3 and flag_2 == 0 then
					var2 = 0
					var6 = event.GetFloorInfo(var2, var3, 7) or var6
					var6 = vm.i32(var6 + 1)
					event.SetFloorInfo(var2, var3, 7, var6)
					event.StopBgm(0)
					event.BgmPlayCancel()
					event.GotoEdit(41, 500)
					return
				end
				if var3 == 6 then
					event.BgmLoadCancel()
				end
				event.SetBitCtrl(1, 0)
				event.GotoDng(0, var3, 1010)
			end
		end
	end
end

--- Program 550.
script[550] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c8f0(386, 1)
		end
		if at <= 2 then
			helper_1b06d86e(1)
		end
	end
	event.Initialize()
	event.FuncPointShow("", "memo", 0)
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(1, "memo")
	event.EohSetShow(1, 0)
	event.AddItem(386)
	helper_c8f0(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 1000.
script[1000] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_35a24()
		end
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		local t0 = helper_42318()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			event.SetFlag(4, 0)
			event.SetSavedataEtc(0, 2)
			event.AddItem(22)
			event.SetCharaEquip(0, 22)
			event.AddItem(359)
			event.SetTimeStepEnable(1)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(1)
			if vm.wait() then
				return skip(2)
			end
			event.SndInReverb(1)
			event.SetBitCtrl(1, 0)
			event.GotoDng(0, -1, 1000)
			if vm.wait() then
				return skip(3)
			end
		end
	else
		helper_35a24()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 10070.
script[10070] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_35e90()
			helper_37e84()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(1)
	end
	helper_35e90()
	event.SetFlag(4, 1)
	helper_37e84()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
