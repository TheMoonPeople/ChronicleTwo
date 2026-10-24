--!strict
-- map/s/s46/s46_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ea3c0d6 = require("@lib/event/helper_1ea3c0d6")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2e67f92b = require("@lib/event/helper_2e67f92b")
local helper_57c93eff = require("@lib/event/helper_57c93eff")
local helper_696c0345 = require("@lib/event/helper_696c0345")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_833c72c2 = require("@lib/event/helper_833c72c2")
local helper_afed7092 = require("@lib/event/helper_afed7092")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

local global0: s32 = 0

--- Helper function.
local function helper_e3c4(arg0: s32)
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
local function helper_ec6c(arg0: s32)
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
		helper_e3c4(0)
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
local function helper_f7e8()
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		helper_696c0345()
		global0 = 0
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
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
		helper_25abe6d2(120)
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
		helper_25abe6d2(60)
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
		helper_ec6c(2090590)
		at = 5
		helper_ec6c(2090593)
		at = 6
		helper_ec6c(2090595)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 7
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at == 4 then
		end
		if at == 5 then
		end
		if at == 6 then
		end
		if at <= 1 then
			helper_d3f20302(120)
		end
		if at <= 2 then
			helper_d3f20302(60)
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
			helper_d3f20302(30)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_833c72c2

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_f7e8()
	event.BgmPlayCancel()
	event.MapJump_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_1ea3c0d6()
	event.LoadDungeonMapFile("d03f01", "d03f01", 6)
	event.LoadScript("d03/d03.stb", 500)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_833c72c2()
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	event.LoadScript("d04/d04.stb", 500)
end

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_f7e8

return script
