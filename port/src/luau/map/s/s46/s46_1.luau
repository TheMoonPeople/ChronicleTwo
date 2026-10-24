--!strict
-- map/s/s46/s46_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_21022081 = require("@lib/event/helper_21022081")
local helper_22e34d28 = require("@lib/event/helper_22e34d28")
local helper_539fc416 = require("@lib/event/helper_539fc416")
local helper_696c0345 = require("@lib/event/helper_696c0345")
local helper_96ce5dc0 = require("@lib/event/helper_96ce5dc0")
local helper_d759a0ab = require("@lib/event/helper_d759a0ab")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f374414d = require("@lib/event/helper_f374414d")

local global0: s32 = 0

--- Helper function.
local function helper_e3b4(arg0: s32)
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
			t1, var2 = helper_f374414d(arg0, var2)
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
		t0, var2 = helper_f374414d(arg0, var2)
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
local function helper_ec5c(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_22e34d28(0, -1, 8, 0, 0)
			helper_e3b4(0)
		end
		helper_d759a0ab(0)
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
	helper_22e34d28(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_e3b4(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_d759a0ab(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_f7d8()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_ed0a80b8(120)
			end
			if at <= 2 then
				helper_ed0a80b8(60)
			end
			if at <= 3 then
				helper_ec5c(2090590)
			end
			if at <= 4 then
				helper_ec5c(2090593)
			end
			if at <= 5 then
				helper_ec5c(2090595)
			end
			if at <= 6 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_539fc416()
	end
	function part2()
		event.CancelDramaScene()
		helper_539fc416()
		event.StopBgm(0)
		event.SetTimeStepEnable(1)
		event.SetTime(time)
		event.SetFadeIn(30)
	end
	event.Initialize()
	helper_696c0345()
	global0 = 0
	event.StopBgm(0)
	helper_ed0a80b8(4)
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
	helper_ed0a80b8(120)
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
	helper_ed0a80b8(60)
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
	helper_ec5c(2090590)
	if vm.skipping() then
		return skip(4)
	end
	helper_ec5c(2090593)
	if vm.skipping() then
		return skip(5)
	end
	helper_ec5c(2090595)
	if vm.skipping() then
		return skip(6)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(7)
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
	helper_21022081()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f7d8()
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
	helper_96ce5dc0()
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
	helper_21022081()
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
	helper_f7d8()
	if vm.skipping() then
		return skip(1)
	end
end

return script
