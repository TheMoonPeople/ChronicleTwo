--!strict
-- map/s/s46/s46.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1a1e22c8 = require("@lib/event/helper_1a1e22c8")
local helper_2b01dbd7 = require("@lib/event/helper_2b01dbd7")
local helper_57e8417c = require("@lib/event/helper_57e8417c")
local helper_651b7701 = require("@lib/event/helper_651b7701")
local helper_7430440d = require("@lib/event/helper_7430440d")
local helper_b412abf3 = require("@lib/event/helper_b412abf3")
local helper_b502ec5d = require("@lib/event/helper_b502ec5d")
local helper_f3d064c4 = require("@lib/event/helper_f3d064c4")

local global0: s32 = 0

--- Helper function.
local function helper_1156c()
	local var0: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_b502ec5d(14)
			end
			if at <= 2 then
				helper_651b7701(1)
			end
			if at <= 3 then
				helper_7430440d(4060030)
			end
			if at <= 4 then
				helper_651b7701(0)
			end
			if at <= 5 then
				helper_651b7701(2)
			end
			if at <= 6 then
				helper_7430440d(4060035)
			end
			if at <= 7 then
				helper_651b7701(0)
			end
			if at <= 8 then
				helper_651b7701(2)
			end
			if at <= 9 then
				helper_7430440d(4060040)
			end
			if at <= 10 then
				helper_7430440d(4060044)
			end
			if at <= 11 then
				helper_7430440d(4060048)
			end
			if at <= 12 then
				helper_651b7701(1)
			end
			if at <= 13 then
				helper_7430440d(4060050)
			end
			if at <= 14 then
				helper_651b7701(0)
			end
			if at <= 15 then
				helper_651b7701(2)
			end
			if at <= 16 then
				helper_7430440d(4060055)
			end
			if at <= 17 then
				helper_7430440d(4060060)
			end
			if at <= 18 then
				helper_7430440d(4060070)
			end
			if at <= 19 then
				helper_651b7701(0)
			end
			if at <= 20 then
				helper_651b7701(2)
			end
			if at <= 21 then
				helper_f3d064c4()
			end
			if at <= 22 then
				helper_b502ec5d(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTimeStepEnable(1)
		event.SetTime(time)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.StopBgm(0)
		if vm.wait() then
			return skip(25)
		end
	end
	event.SetFlag(406, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.LoadBgm(58)
	event.PlayBgm(0)
	event.LoadSound(4801)
	var0 = event.SndLoadSound(4801) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e400/e406/")
	event.LoadMes(0, 5, "e406.txt")
	event.LoadChara(5, "e406_minchu.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e406_eina.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e406_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.SetReference(10, "minchu", 8)
	event.EohSetSoundId(0, var0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 64.33, 13.21, 70.24)
	event.EohSetRot(1, 0.0, -1.48, 0.0)
	event.EohSetMotion(1, "本読む", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目パチ")
	event.SetCharaPos(10, 58.0, 13.0, 108.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.SetMotion(10, "寝てる", 4)
	time = event.GetTime() or time
	event.SetTime(22.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-25.28, 87.45, 28.6)
	event.CmrsSetRef(68.06, 28.91, 95.45)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.SetPakuAnim(1, "口パク")
	helper_7430440d(4060020)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "本閉じる", 2)
	event.ObjsNextMotion(1, "ユリス見るL", 4)
	helper_b502ec5d(14)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 0)
	helper_651b7701(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(62.04, 40.15, 70.68)
	event.CmrsSetRef(59.03, 34.16, 100.4)
	event.SetPakuAnim(0, "しんけん口パク")
	helper_7430440d(4060030)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "エイナを見る", 6)
	event.ObjsNextMotion(0, "エイナを見るL", 4)
	event.ObjsSetMotion(2, "エイナを見る", 6)
	event.ObjsNextMotion(2, "エイナを見るL", 4)
	event.SndSePlay(var0, 1)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_651b7701(2)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "しんけん口パク")
	helper_7430440d(4060035)
	if vm.skipping() then
		return skip(7)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_651b7701(2)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(43.31, 40.29, 81.27)
	event.CmrsSetRef(72.59, 39.24, 71.2)
	event.SetPakuAnim(1, "口パク")
	helper_7430440d(4060040)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(3.77, 60.04, 42.87)
	event.CmrsSetRef(71.41, 28.24, 86.89)
	event.ObjsSetMotion(1, "上を見る", 6)
	event.ObjsNextMotion(1, "上を見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_7430440d(4060044)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "口パク")
	helper_7430440d(4060048)
	if vm.skipping() then
		return skip(12)
	end
	helper_651b7701(1)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(62.04, 40.15, 70.68)
	event.CmrsSetRef(59.03, 35.79, 100.4)
	event.SetPakuAnim(0, "しんけん口パク")
	helper_7430440d(4060050)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "起きる", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSetMotion(2, "起きる", 6)
	event.ObjsNextMotion(2, "起きるL", 4)
	event.SndSePlay(var0, 2)
	helper_651b7701(0)
	if vm.skipping() then
		return skip(15)
	end
	helper_651b7701(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(0, "しんけん口パク")
	helper_7430440d(4060055)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(48.78, 37.2, 87.09)
	event.CmrsSetRef(65.24, 40.1, 73.06)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい目")
	event.ObjsSetMotion(1, "ユリス見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_7430440d(4060060)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(61.65, 38.17, 78.76)
	event.CmrsSetRef(58.54, 38.63, 100.33)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "起きる会話", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSetMotion(2, "起きる会話", 6)
	event.ObjsNextMotion(2, "起きるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_7430440d(4060070)
	if vm.skipping() then
		return skip(19)
	end
	helper_651b7701(0)
	if vm.skipping() then
		return skip(20)
	end
	helper_651b7701(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.CmrsMove2(60.7, 40.1, 85.35, 58.54, 40.56, 100.33, 40, 0, 0.2)
	helper_f3d064c4()
	if vm.skipping() then
		return skip(22)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_db20(arg0: s32)
	local get_now_frame_wait: f32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var6 = 0
			loud = 0
			argc_2 = argc
			var2 = 2
			var7 = loud
			local t1: s32
			t1, var2 = helper_b412abf3(arg0, var2)
			var5 = t1
			var6 = var6 + 1
		end
		var6 = vm.i32(var6 + 1)
		global0 = vm.i32(global0 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var2 = 0
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	while true do
		get_now_frame_wait = event.GetMotNowWait(32) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(0.01) then
			event.ObjsTexAnime(0, 0, "パクパク")
			event.ObjsTexAnime(0, 1, "パクパク")
		end
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			var2 = 2
		end
		var7 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var7 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var7 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		local t0: s32
		t0, var2 = helper_b412abf3(arg0, var2)
		var5 = t0
		if var5 ~= 0 then
			var6 = vm.i32(var6 + 1)
			break
		else
			if global0 == 137 then
				event.ObjsTexAnime(0, 0)
				event.ObjsTexAnime(0, 1, "デフォルト顔")
				event.ObjsTexAnime(0, 1, "通常目パチ")
			end
			if vm.wait() then
				return skip(2)
			end
			var6 = vm.i32(var6 + 1)
			global0 = vm.i32(global0 + 1)
		end
	end
	if var2 == 0 then
		event.TrgPakuMotion(2)
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
end

--- Helper function.
local function helper_e3c8(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_57e8417c(0, -1, 8, 0, 0)
			helper_db20(0)
		end
		helper_1a1e22c8(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.MesMake_2(0, arg0)
	helper_57e8417c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_db20(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1a1e22c8(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_e6e8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.CharaActive(1, 0)
end

--- Helper function.
local function helper_ef44()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_b502ec5d(120)
			end
			if at <= 2 then
				helper_b502ec5d(60)
			end
			if at <= 3 then
				helper_e3c8(2090590)
			end
			if at <= 4 then
				helper_e3c8(2090593)
			end
			if at <= 5 then
				helper_e3c8(2090595)
			end
			if at <= 6 then
				helper_b502ec5d(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_e6e8()
	end
	function part2()
		event.CancelDramaScene()
		helper_e6e8()
		event.StopBgm(0)
		event.SetTimeStepEnable(1)
		event.SetTime(time)
		event.SetFadeIn(30)
	end
	event.Initialize()
	helper_2b01dbd7()
	global0 = 0
	event.StopBgm(0)
	helper_b502ec5d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(58)
	event.PlayBgm(0)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.SetReference(33, "pie", 34)
	event.SetReference(33, "pie", 35)
	event.CmrsSetPos(-22.48, 31.6, -71.45)
	event.CmrsSetRef(74.99, 21.39, -133.6)
	event.ObjsSetPos(0, 71.93, 0.0, -137.17)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(1, -32.7, 0.0, -81.53)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.ObjsSetMotion(0, "座り", 4)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 0)
	event.ObjsSetMotion(1, "ポテトパイ歩き", 4)
	event.ObjsMove(1, 29.44, 0.0, -115.61, 120)
	helper_b502ec5d(120)
	if vm.skipping() then
		return skip(2)
	end
	event.DelReference(34)
	event.DelReference(35)
	event.CharaActive(0, 33)
	event.CharaActive(1, 36)
	event.SetReference(32, "pie", 36)
	event.CmrsSetPos(15.46, 33.35, -97.19)
	event.CmrsSetRef(39.19, 15.77, -110.22)
	event.ObjsSetPos(0, 45.12, 0.0, -113.39)
	event.ObjsSetRot(0, 0.0, -1.08, 0.0)
	event.ObjsSetMotion(0, "喜ぶ", 6)
	event.ObjsNextMotion(0, "喜ぶL", 0)
	helper_b502ec5d(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 33)
	event.CmrsSetPos(25.57, 23.79, -65.13)
	event.CmrsSetRef(36.95, 20.17, -110.66)
	event.ObjsSetPos(0, 45.12, 0.0, -113.39)
	event.ObjsSetRot(0, 0.0, -1.08, 0.0)
	event.ObjsSetPos(1, 28.93, 0.0, -101.8)
	event.ObjsSetRot(1, 0.0, 2.04, 0.0)
	event.ObjsTexAnime(0, 1, "パクパク")
	event.ObjsSetMotion(0, "食べる", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 6)
	event.ObjsNextMotion(0, "食べる", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.ObjsSetMotion(1, "ユリス見立ち", 4)
	helper_e3c8(2090590)
	if vm.skipping() then
		return skip(4)
	end
	helper_e3c8(2090593)
	if vm.skipping() then
		return skip(5)
	end
	helper_e3c8(2090595)
	if vm.skipping() then
		return skip(6)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_fff4()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_7430440d(3070030)
			end
			if at <= 2 then
				helper_7430440d(3070040)
			end
			if at <= 3 then
				helper_7430440d(3070050)
			end
			if at <= 4 then
				helper_7430440d(3070060)
			end
			if at <= 5 then
				helper_7430440d(3070070)
			end
			if at <= 6 then
				helper_7430440d(3070075)
			end
			if at <= 7 then
				helper_7430440d(3070080)
			end
			if at <= 8 then
				helper_7430440d(3070090)
			end
			if at <= 9 then
				helper_b502ec5d(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.StopBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		if vm.wait() then
			return skip(12)
		end
	end
	event.SetFlag(307, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.LoadBgm(58)
	event.PlayBgm(0)
	event.LoadSound(3801)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e300/e307/")
	event.LoadMes(0, 5, "e307.txt")
	event.LoadChara(5, "e307_minchu.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e307_eina.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e307_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.LoadChara(5, "e307_senmen.gltf", "info", 11)
	event.CharaActive(11)
	event.ChangeDir("")
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.SetReference(10, "minchu", 8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "苦しい顔")
	event.EohSetTexAnim(0, 1, "苦しい目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "座り", 4)
	event.SetReference(10, "eina", 9)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "目パチ")
	event.SetCharaPos(10, 58.0, 13.0, 108.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.SetMotion(10, "寝てる", 4)
	event.SetCharaPos(11, 56.65, 13.0, 71.33)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-25.28, 87.45, 28.6)
	event.CmrsSetRef(68.06, 28.91, 95.45)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsSetMotion(1, "頭を冷やす", 6)
	event.ObjsNextMotion(1, "座り", 4)
	helper_651b7701(1)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(51.94, 47.84, 90.03)
	event.CmrsSetRef(64.5, 32.42, 98.98)
	event.SetPakuAnim(0, "苦しい口パク")
	helper_7430440d(3070030)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_7430440d(3070040)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexaDelay(0, 180)
	event.ObjsTexAnime(0, 1, "目あき～とじ")
	event.ObjsTexaDelay(0, 90)
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0, "目あき～とじ")
	event.ObjsTexAnime(0, 0, "目とじ～目あき")
	event.SetPakuAnim(0, "苦しい口パク")
	helper_7430440d(3070050)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "頭をなでる", 2)
	event.ObjsNextMotion(1, "頭をなでるL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_7430440d(3070060)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_7430440d(3070070)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(35.28, 48.46, 114.2)
	event.CmrsSetRef(66.59, 39.0, 88.86)
	event.SetPakuAnim(1, "わらい口パク")
	helper_7430440d(3070075)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "苦しい口パク")
	helper_7430440d(3070080)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(50.56, 35.76, 96.14)
	event.CmrsSetRef(69.63, 43.83, 87.3)
	event.SetPakuAnim(1, "わらい口パク")
	helper_7430440d(3070090)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b502ec5d(30)
	if vm.skipping() then
		return skip(10)
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
	helper_1156c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ef44()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmPlayCancel()
	event.MapJump(-1, "g01i07", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fff4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d03f01", "d03f01", 6)
	event.LoadScript("d03/d03.stb", 500)
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1156c()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	event.LoadScript("d04/d04.stb", 500)
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ef44()
	if vm.skipping() then
		return skip(1)
	end
end

return script
