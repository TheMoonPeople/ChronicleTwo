--!strict
-- map/s/s29/s29.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c080e46 = require("@lib/event/helper_0c080e46")
local helper_48d40fdf = require("@lib/event/helper_48d40fdf")
local helper_816401eb = require("@lib/event/helper_816401eb")
local helper_9f003eee = require("@lib/event/helper_9f003eee")
local helper_a7469b08 = require("@lib/event/helper_a7469b08")

--- Helper function.
local function helper_2de0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = 1
		var3 = 0
		var3 = 0
		return 0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMesWindowMode(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	var4 = event.GetMesStatus(arg0) or var4
	if var4 == 0 then
		return 0, arg1
	end
	if var4 == 1 then
		return 0, arg1
	end
	if var4 == 4 then
		return 0, arg1
	end
	pressed = event.CheckButton(0) or pressed
	pressed_2 = event.CheckButton(1) or pressed_2
	if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
		end
		if var4 == 5 then
			event.MesNextpage(arg0)
		end
		if var4 == 3 then
			return 1, arg1
		end
		if var4 ~= 5 and var4 ~= 3 then
			event.SetMesDrawspeed(arg0, 0.0)
			event.TrgPakuMotion(2)
			arg1 = 2
		end
	end
	return 0, arg1
end

--- Helper function.
local function helper_3c08(arg0: s32)
	local var1: s32 = 0
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
			t1, var2 = helper_2de0(arg0, var2)
			var5 = t1
			var6 = var6 + 1
		end
		var6 = vm.i32(var6 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetSavedataEtc(5) or var1
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var2 = 0
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	while true do
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			var2 = 2
			if var1 ~= 0 then
				break
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
		local t0: s32
		t0, var2 = helper_2de0(arg0, var2)
		var5 = t0
		if var5 ~= 0 then
			var6 = vm.i32(var6 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var6 = vm.i32(var6 + 1)
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
local function helper_5c78(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_0c080e46(0, -1, 8, 0, 0)
			helper_3c08(0)
		end
		helper_9f003eee(0)
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
	helper_0c080e46(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c08(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_9f003eee(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5f68(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5c78(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5c78(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_deb4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 34 then
			if at <= 1 then
				helper_816401eb()
			end
			if at <= 2 then
				helper_48d40fdf(2)
			end
			if at <= 3 then
				helper_5f68(5400230)
			end
			if at <= 4 then
				helper_48d40fdf(0)
			end
			if at <= 5 then
				helper_5f68(5400240)
			end
			if at <= 6 then
				helper_5f68(5400245)
			end
			if at <= 7 then
				helper_5f68(5400250)
			end
			if at <= 8 then
				helper_48d40fdf(2)
			end
			if at <= 9 then
				helper_5f68(5400260)
			end
			if at <= 10 then
				helper_48d40fdf(0)
			end
			if at <= 11 then
				helper_5f68(5400270)
			end
			if at <= 12 then
				helper_48d40fdf(2)
			end
			if at <= 13 then
				helper_5f68(5400280)
			end
			if at <= 14 then
				helper_48d40fdf(2)
			end
			if at <= 15 then
				helper_5f68(5400290)
			end
			if at <= 16 then
				helper_5f68(5400295)
			end
			if at <= 17 then
				helper_5f68(5400300)
			end
			if at <= 18 then
				helper_5f68(5400310)
			end
			if at <= 19 then
				helper_48d40fdf(0)
			end
			if at <= 20 then
				helper_5f68(5400315)
			end
			if at <= 21 then
				helper_5f68(5400320)
			end
			if at <= 22 then
				helper_5f68(5400330)
			end
			if at <= 23 then
				helper_5f68(5400335)
			end
			if at <= 24 then
				helper_48d40fdf(0)
			end
			if at <= 25 then
				helper_48d40fdf(0)
			end
			if at <= 26 then
				helper_a7469b08(6)
			end
			if at <= 27 then
				helper_a7469b08(60)
			end
			if at <= 28 then
				helper_a7469b08(20)
			end
			if at <= 29 then
				helper_a7469b08(80)
			end
			if at <= 30 then
				helper_5f68(5400340)
			end
			if at <= 31 then
				helper_5f68(5400345)
			end
			if at <= 32 then
				helper_816401eb()
			end
			if at <= 33 then
				helper_a7469b08(30)
			end
			if vm.skip_end() then
				return skip(35)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_a7469b08(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(53)
	event.PlayBgm(0)
	event.LoadSound(5516)
	var0 = event.SndLoadSound(5516) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.CharaActive(0, 0)
	end
	event.LoadChara(5, "e540_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(32)
		event.CharaActive(33)
	end
	event.EohSetPos(0, 8.0, 2721.0, -500.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, -8.0, 2721.0, -500.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "うれし目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	time = event.GetTime() or time
	event.SetTime(21.5)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 2776.18, -303.79)
	event.CmrsSetRef(0.0, 2833.8, -501.13)
	event.CmrsMove2(0.0, 2734.28, -303.79, 0.0, 2760.06, -501.13, 120, 0, 1.0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_816401eb()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "ユリス見る", 6)
	event.ObjsNextMotion(2, "ユリス見るL", 4)
	helper_48d40fdf(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_5f68(5400230)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "エイナ見る", 6)
	event.ObjsNextMotion(0, "エイナ見るL", 4)
	helper_48d40fdf(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_5f68(5400240)
	if vm.skipping() then
		return skip(6)
	end
	helper_5f68(5400245)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくL", 4)
	helper_5f68(5400250)
	if vm.skipping() then
		return skip(8)
	end
	helper_48d40fdf(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "体ごと", 6)
	event.ObjsNextMotion(0, "体ごとL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f68(5400260)
	if vm.skipping() then
		return skip(10)
	end
	helper_48d40fdf(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "ユリス見る2", 6)
	event.ObjsNextMotion(2, "ユリス見るL", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_5f68(5400270)
	if vm.skipping() then
		return skip(12)
	end
	helper_48d40fdf(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-18.7, 2755.32, -500.47)
	event.CmrsSetRef(8.99, 2742.51, -500.09)
	event.CharaActive(0, 34)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "エイナ見立ち2", 4, -1.0, 1)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f68(5400280)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(27.43, 2727.2, -460.74)
	event.CmrsSetRef(4.32, 2740.45, -499.18)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "かなし顔")
	event.EohSetTexAnim(2, 1, "かなし目パチ")
	event.ObjsSetPos(0, 10.0, 2721.0, -500.0)
	event.ObjsSetMotion(0, "エイナ見立ち", 4, -1.0, 1)
	event.CharaActive(34)
	event.ObjsSetPos(2, 8.0, 2721.0, -500.0)
	event.ObjsSetRot(2, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(2, "天を仰ぐ", 6)
	event.ObjsNextMotion(2, "天を仰ぐL", 4)
	event.ObjsMotionWait(2)
	helper_48d40fdf(2)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "わかって、ユリス", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "わかって、ユリス", 6)
	event.ObjsNextMotion(2, "わかって、ユリスL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400290)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400295)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "うつむく2", 6)
	event.ObjsNextMotion(2, "うつむく2L", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400300)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-72.3, 2778.58, -418.63)
	event.CmrsSetRef(3.04, 2732.45, -500.46)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(0, "勝手だよ！！", 6)
	event.ObjsNextMotion(0, "勝手だよ！！L", 4)
	event.ObjsSetMotion(2, "うつむく2戻り", 6)
	event.ObjsNextMotion(2, "立ち3", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5f68(5400310)
	if vm.skipping() then
		return skip(19)
	end
	helper_48d40fdf(0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5f68(5400315)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400320)
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目～泣き目")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 1, "泣き目パチ")
	event.ObjsSetMotion(0, "うつむく", 6)
	event.ObjsNextMotion(0, "うつむくL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5f68(5400330)
	if vm.skipping() then
		return skip(23)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5f68(5400335)
	if vm.skipping() then
		return skip(24)
	end
	helper_48d40fdf(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(0)
	helper_48d40fdf(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_a7469b08(6)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -15.0, 2721.0, -423.71, 30)
	event.ObjsMove(0, -15.0, 2200.0, -423.71, 30)
	event.ObjsRotation(0, 0.0, -0.25, 0, 8)
	event.ObjsSetMotion(2, "右向く", 6)
	event.ObjsNextMotion(2, "右向くL", 4)
	helper_a7469b08(60)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var0, 9)
	helper_a7469b08(20)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -15.0, 1700.0, -423.71, 40)
	helper_a7469b08(80)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(0.0, 2745.96, -460.49)
	event.CmrsSetRef(0.0, 2745.96, -498.07)
	event.CmrsMove2(0.0, 2745.96, -471.49, 0.0, 2745.96, -498.07, 160, 2, 1.0)
	event.ObjsSetPos(2, 0.0, 2721.0, -500.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "うつむく3", 6)
	event.ObjsNextMotion(2, "うつむくL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400340)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(2, "うつむく会話", 2)
	event.ObjsNextMotion(2, "うつむくL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f68(5400345)
	if vm.skipping() then
		return skip(32)
	end
	helper_816401eb()
	if vm.skipping() then
		return skip(33)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a7469b08(30)
	if vm.skipping() then
		return skip(34)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 0.0, 2721.0, -500.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_deb4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_deb4()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s30", 605)
end

return script
