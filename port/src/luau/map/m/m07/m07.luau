--!strict
-- map/m/m07/m07.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0af90df5 = require("@lib/event/helper_0af90df5")
local helper_73e34c5a = require("@lib/event/helper_73e34c5a")

--- Helper function.
local function helper_d68(arg0: s32)
	local stream_open_state: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if vm.wait() then
			return skip(2)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

--- Helper function.
local function helper_2774(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_3(arg0, arg1)
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
end

--- Helper function.
local function helper_310c(arg0: s32, arg1: any, arg2: any)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = 0
			loud = 0
			var9 = 1
			argc_2 = argc
			var9 = 0
			var7 = loud
		end
		var6 = vm.i32(var6 + 1)
		var9 = 0
		helper_0af90df5(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesOkuri(arg0, 0)
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	var9 = 1
	while var9 ~= 0 do
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			if arg1 == -1 then
				var9 = 0
			end
		end
		var7 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var7 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var7 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		if vm.wait() then
			return skip(2)
		end
		var6 = vm.i32(var6 + 1)
		if arg1 ~= -1 then
			if arg1 <= var6 then
				var9 = 0
			end
		end
		if arg2 == var6 then
			helper_0af90df5(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3810(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_310c(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_310c(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_b578(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d68(1)
		end
		if at <= 2 then
			helper_2774(0, -1, 5, 0, 0)
			helper_3810(0, arg1)
		end
		helper_0af90df5(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_d68(1)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, arg0)
	helper_2774(0, -1, 5, 0, 0)
	event.StreamPlay(1)
	helper_3810(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	helper_0af90df5(0)
end

--- Helper function.
local function helper_24bc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_25cc(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var1 = event.ObjsCheck(arg0) or var1
		if var1 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_b730()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_b578(10010, 160)
			end
			if at <= 2 then
				helper_b578(10020, 110)
			end
			if at <= 3 then
				helper_b578(10025, 120)
			end
			if at <= 4 then
				helper_b578(10030, 210)
			end
			if at <= 5 then
				helper_24bc()
			end
			if at <= 6 then
				helper_d68(1)
			end
			if at <= 7 then
				helper_24bc()
			end
			if at <= 8 then
				helper_25cc(0)
			end
			if at <= 9 then
				helper_25cc(0)
			end
			if at <= 10 then
				helper_73e34c5a(60)
			end
			if at <= 11 then
				helper_73e34c5a(70)
			end
			if at <= 12 then
				helper_73e34c5a(60)
			end
			if at <= 13 then
				helper_25cc(0)
			end
			if at <= 14 then
				helper_73e34c5a(60)
			end
			if at <= 15 then
				helper_24bc()
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_73e34c5a(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndInReverb(1)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DelExtMotion(0)
		event.CharaActive(1, 0)
		event.SetRain(0)
		event.StopEnvBgm()
		event.StopBgm(0)
		helper_73e34c5a(4)
		if vm.skipping() then
			return skip(18)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetTimeStepEnable(0)
	event.SetTime(24)
	event.SetMesWindowMode(0, 0)
	event.LoadSound(1200)
	event.LoadBgm(100)
	event.StopBgm(0)
	event.StopEnvBgm()
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/opening/p1/")
	event.LoadMes(0, 5, "op1ch1.txt")
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ChangeDir("")
	event.EohSetPos(0, -548.51, 0.0, 56.09)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 22)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "真剣目")
	event.EohSetTexAnim(0, 1, "口半開き")
	event.EohSetFootSoundId(1, -1)
	event.EohSetFootSoundId(2, -1)
	event.EohSetFootSoundId(3, -1)
	event.EohSetFootSoundId(4, -1)
	event.EohSetFootSoundId(5, -1)
	event.SetRain(0)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 10000.0, 0.0)
	event.CmrsSetRef(0.0, 10000.0, 0.0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(1)
	event.SndInReverb(0)
	helper_b578(10010, 160)
	if vm.skipping() then
		return skip(2)
	end
	helper_b578(10020, 110)
	if vm.skipping() then
		return skip(3)
	end
	helper_b578(10025, 120)
	if vm.skipping() then
		return skip(4)
	end
	helper_b578(10030, 210)
	if vm.skipping() then
		return skip(5)
	end
	event.SndInReverb(1)
	event.SpriteSetDraw(0, 0)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(1)
	helper_24bc()
	if vm.skipping() then
		return skip(6)
	end
	event.StreamOpen3(1, 10040)
	helper_d68(1)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamPlay(1)
	event.SetRainCharaNo(0)
	event.SetRain(1)
	event.PlayBgm(0)
	event.PlayEnvBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(152.13, 71.52, -25.06)
	event.CmrsSetRef(-217.76, 200.86, -36.82)
	event.CmrsMove(152.13, 71.52, -25.06, -217.76, 28.14, -36.82, 350)
	event.CmrsFadeInit()
	event.CmrsFadeIn(300)
	event.ObjsSetMotion(0, "走り")
	event.ObjsPosDelay(0, 60)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 260)
	event.ObjsAddPas(0, -548.51, 0.0, 56.09)
	event.ObjsAddPas(0, -353.41, 0.0, 2.28)
	event.ObjsAddPas(0, -186.76, 0.0, -36.95)
	event.ObjsAddPas(0, -68.92, 0.0, -47.91)
	event.ObjsAddPas(0, 64.69, 0.0, -50.33)
	event.ObjsAddPas(0, 99.26, 0.0, -48.9)
	event.ObjsStartPas(0)
	helper_24bc()
	if vm.skipping() then
		return skip(8)
	end
	helper_25cc(0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(60)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 64.69, 0.0, -50.33)
	event.ObjsAddPas(0, 195.57, 0.0, -50.59)
	event.ObjsAddPas(0, 314.04, 0.0, -37.39)
	event.ObjsStartPas(0)
	event.CmrsSyncObj(0, 5.0, 20.0, 0.0, 1.88, -15.0, 45.0)
	helper_25cc(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsReleaseObj()
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 200)
	event.ObjsAddPas(0, 314.04, 0.0, -37.39)
	event.ObjsAddPas(0, 467.75, 0.0, -7.6)
	event.ObjsAddPas(0, 521.55, 0.0, 26.4)
	event.ObjsAddPas(0, 544.99, 0.0, 49.43)
	event.ObjsAddPas(0, 549.06, 3.84, 89.43)
	event.ObjsAddPas(0, 543.57, 4.07, 127.02)
	event.ObjsAddPas(0, 527.1, 4.07, 147.59)
	event.ObjsAddPas(0, 505.16, 19.83, 153.79)
	event.ObjsAddPas(0, 463.28, 49.29, 156.8)
	event.ObjsAddPas(0, 357.41, 52.0, 153.32)
	event.ObjsStartPas(0, 1)
	event.CmrsSetPos(716.83, 119.9, -60.37)
	event.CmrsSetRef(504.52, 49.88, 41.63)
	event.SetRainCharaNo(0)
	helper_73e34c5a(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsMove2(716.83, 119.9, -60.37, 476.49, 49.88, 99.17, 200, 1, 1.0)
	helper_73e34c5a(70)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(0, 2)
	helper_73e34c5a(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SetRainCharaNo(-1)
	helper_25cc(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "ドア開け", 2)
	helper_73e34c5a(60)
	if vm.skipping() then
		return skip(15)
	end
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 66)
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_24bc()
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Program 151.
local function program_151()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_b730()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "s42", 500)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFlag(4, 1)
	helper_b730()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

script[151] = program_151

--- Program 10010.
script[10010] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			program_151()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_73e34c5a(6)
	if vm.skipping() then
		return skip(1)
	end
	program_151()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
