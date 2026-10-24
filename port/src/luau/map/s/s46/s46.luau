--!strict
-- map/s/s46/s46.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_2b01dbd7 = require("@lib/event/helper_2b01dbd7")
local helper_2e67f92b = require("@lib/event/helper_2e67f92b")
local helper_57c93eff = require("@lib/event/helper_57c93eff")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_afed7092 = require("@lib/event/helper_afed7092")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

local global0: s32 = 0

--- Helper function.
local function helper_1156c()
	local var0: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.SetFlag(406, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetStatusbarShow(0, 1.0)
		event.SoundAllStop()
		event.LoadBgm(58)
		event.PlayBgm(0)
		event.LoadSound(4801)
		var0 = event.SndLoadSound_2(4801) or var0
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
		helper_e34416e2(4060020)
		event.ObjsSetMotion(1, "本閉じる", 2)
		event.ObjsNextMotion(1, "ユリス見るL", 4)
		helper_888ab2a3(14)
		event.SndSePlay(var0, 0)
		helper_0958ca60(1)
		event.CmrsSetPos(62.04, 40.15, 70.68)
		event.CmrsSetRef(59.03, 34.16, 100.4)
		event.SetPakuAnim(0, "しんけん口パク")
		helper_e34416e2(4060030)
		event.ObjsSetMotion(0, "エイナを見る", 6)
		event.ObjsNextMotion(0, "エイナを見るL", 4)
		event.ObjsSetMotion(2, "エイナを見る", 6)
		event.ObjsNextMotion(2, "エイナを見るL", 4)
		event.SndSePlay(var0, 1)
		helper_0958ca60(0)
		helper_0958ca60(2)
		event.SetPakuAnim(0, "しんけん口パク")
		helper_e34416e2(4060035)
		helper_0958ca60(0)
		helper_0958ca60(2)
		event.CmrsSetPos(43.31, 40.29, 81.27)
		event.CmrsSetRef(72.59, 39.24, 71.2)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(4060040)
		event.CmrsSetPos(3.77, 60.04, 42.87)
		event.CmrsSetRef(71.41, 28.24, 86.89)
		event.ObjsSetMotion(1, "上を見る", 6)
		event.ObjsNextMotion(1, "上を見るL", 4)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(4060044)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(4060048)
		helper_0958ca60(1)
		event.CmrsSetPos(62.04, 40.15, 70.68)
		event.CmrsSetRef(59.03, 35.79, 100.4)
		event.SetPakuAnim(0, "しんけん口パク")
		helper_e34416e2(4060050)
		event.ObjsSetMotion(0, "起きる", 6)
		event.ObjsNextMotion(0, "起きるL", 4)
		event.ObjsSetMotion(2, "起きる", 6)
		event.ObjsNextMotion(2, "起きるL", 4)
		event.SndSePlay(var0, 2)
		helper_0958ca60(0)
		helper_0958ca60(2)
		event.SetPakuAnim(0, "しんけん口パク")
		helper_e34416e2(4060055)
		event.CmrsSetPos(48.78, 37.2, 87.09)
		event.CmrsSetRef(65.24, 40.1, 73.06)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "わらい目")
		event.ObjsSetMotion(1, "ユリス見るL", 4)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(4060060)
		event.CmrsSetPos(61.65, 38.17, 78.76)
		event.CmrsSetRef(58.54, 38.63, 100.33)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsSetMotion(0, "起きる会話", 6)
		event.ObjsNextMotion(0, "起きるL", 4)
		event.ObjsSetMotion(2, "起きる会話", 6)
		event.ObjsNextMotion(2, "起きるL", 4)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(4060070)
		helper_0958ca60(0)
		helper_0958ca60(2)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "目あき～目とじ")
		event.CmrsMove2(60.7, 40.1, 85.35, 58.54, 40.56, 100.33, 40, 0, 0.2)
		helper_c624bc16()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.SetTimeStepEnable(1)
	event.SetTime(time)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.LoadMes(0, -1)
	event.CharaActive(0)
	event.StopBgm(0)
	vm.wait(24)
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
	local at: number = 0
	return vm.guard(function()
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
			t0, var2 = helper_57c93eff(arg0, var2)
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
				at = 1
				vm.wait(1)
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
		return
	end, function(received: { any })
		if at <= 1 then
			var6 = var6 + 1
			local _ = global0 == 137
			global0 = vm.i32(global0 + 1)
			return var6
		end
		return nil
	end)
end

--- Helper function.
local function helper_21900000(arg0: s32)
	local var2: s32 = 0
	local var6: s32 = 0
	var2 = 0
	var6 = 0
	var2 = 2
	do
		local _: any
		_, var2 = helper_afed7092(arg0, var2)
	end
	var6 = var6 + 1
	var6 = var6 + 1
	local _ = global0 == 137
	global0 = vm.i32(global0 + 1)
end

--- Helper function.
local function helper_e3c8(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.StreamOpen3(1, arg0)
		while true do
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				at = 1
				vm.wait(1)
			end
		end
		event.StreamStandby(1)
		while true do
			stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				at = 2
				vm.wait(2)
			end
		end
		event.MesMake_2(0, arg0)
		helper_82705ce2(0, -1, 8, 0, 0)
		event.StreamPlay(1)
		at = 3
		helper_db20(0)
		helper_6992f518(0)
		event.StreamClose(1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 3 then
			end
			if at <= 2 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_21900000(0)
			end
			helper_d16eef1e(0)
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_21d00000(arg0: s32)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_21900000(0)
	helper_d16eef1e(0)
end

--- Helper function.
local function helper_ef44()
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		helper_2b01dbd7()
		global0 = 0
		event.StopBgm(0)
		at = 1
		helper_888ab2a3(4)
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
		at = 2
		helper_888ab2a3(120)
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
		at = 3
		helper_888ab2a3(60)
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
		at = 4
		helper_e3c8(2090590)
		at = 5
		helper_e3c8(2090593)
		at = 6
		helper_e3c8(2090595)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 7
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at == 4 then
		end
		if at == 5 then
		end
		if at == 6 then
		end
		if at <= 1 then
			helper_038a2e4d(120)
		end
		if at <= 2 then
			helper_038a2e4d(60)
		end
		if at <= 3 then
			helper_21d00000(2090590)
		end
		if at <= 4 then
			helper_21d00000(2090593)
		end
		if at <= 5 then
			helper_21d00000(2090595)
		end
		if at <= 6 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.CancelDramaScene()
	helper_2e67f92b()
	event.StopBgm(0)
	event.SetTimeStepEnable(1)
	event.SetTime(time)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_fff4()
	local time: f32 = 0
	vm.section(function()
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
		helper_0958ca60(1)
		event.CmrsSetPos(51.94, 47.84, 90.03)
		event.CmrsSetRef(64.5, 32.42, 98.98)
		event.SetPakuAnim(0, "苦しい口パク")
		helper_e34416e2(3070030)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(3070040)
		event.ObjsTexaDelay(0, 180)
		event.ObjsTexAnime(0, 1, "目あき～とじ")
		event.ObjsTexaDelay(0, 90)
		event.ObjsTexAnime(0, 1, "目とじ～目あき")
		event.ObjsTexaDelay(0, 30)
		event.ObjsTexAnime(0, 0, "目あき～とじ")
		event.ObjsTexAnime(0, 0, "目とじ～目あき")
		event.SetPakuAnim(0, "苦しい口パク")
		helper_e34416e2(3070050)
		event.ObjsSetMotion(1, "頭をなでる", 2)
		event.ObjsNextMotion(1, "頭をなでるL", 4)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(3070060)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(3070070)
		event.CmrsSetPos(35.28, 48.46, 114.2)
		event.CmrsSetRef(66.59, 39.0, 88.86)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(3070075)
		event.SetPakuAnim(0, "苦しい口パク")
		helper_e34416e2(3070080)
		event.CmrsSetPos(50.56, 35.76, 96.14)
		event.CmrsSetRef(69.63, 43.83, 87.3)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(3070090)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
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
	vm.wait(11)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1156c

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_ef44()
	event.BgmPlayCancel()
	event.MapJump_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_fff4()
	event.LoadDungeonMapFile("d03f01", "d03f01", 6)
	event.LoadScript("d03/d03.stb", 500)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_1156c()
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	event.LoadScript("d04/d04.stb", 500)
end

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_ef44

return script
