--!strict
-- map/s/s45/s45_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_2164b10b = require("@lib/event/helper_2164b10b")
local helper_36526538 = require("@lib/event/helper_36526538")
local helper_6874346e = require("@lib/event/helper_6874346e")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_9a6fd52f = require("@lib/event/helper_9a6fd52f")
local helper_9d3aacf6 = require("@lib/event/helper_9d3aacf6")
local helper_a03e568e = require("@lib/event/helper_a03e568e")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_d7ca8cd7 = require("@lib/event/helper_d7ca8cd7")

--- Helper function.
local function helper_cdc4()
	local var0: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_d7ca8cd7()
				helper_184013af()
			end
			if at <= 2 then
				helper_aafd6a80(10)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if at <= 5 then
				helper_6c719c99(3440010)
			end
			if at <= 6 then
				helper_8f31f334(1)
			end
			if at <= 7 then
				helper_6c719c99(3440020)
			end
			if at <= 8 then
				helper_6c719c99(3440030)
			end
			if at <= 9 then
				helper_8f31f334(0)
			end
			if at <= 10 then
				helper_6c719c99(3440040)
			end
			if at <= 11 then
				helper_8f31f334(1)
			end
			if at <= 12 then
				helper_aafd6a80(12)
			end
			if at <= 13 then
				helper_aafd6a80(10)
			end
			if at <= 14 then
				helper_8f31f334(1)
			end
			if at <= 15 then
				helper_aafd6a80(30)
			end
			if at <= 16 then
				helper_aafd6a80(6)
			end
			if at <= 17 then
				helper_aafd6a80(10)
			end
			if at <= 18 then
				helper_aafd6a80(2)
			end
			if at <= 19 then
				helper_184013af()
			end
			if at <= 20 then
				helper_36526538(0, -1, 8, 0, 0)
			end
			if at <= 21 then
				helper_aafd6a80(30)
			end
			if at <= 22 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		helper_6874346e()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 4)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		helper_6874346e()
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetStatusbarShow(1, 1.0)
	end
	event.EohSyncObj(0, "p06_e03h03-0")
	event.EohSyncObj(1, "p07_e03h03-0")
	event.EohSetShow(0, 0)
	event.EohSetShow(1, 1)
	event.SetFlag(344, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(0)
	event.PlayBgm(0)
	event.LoadSound(1251)
	var0 = event.SndLoadSound(1251) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e300/e344/")
	event.LoadMes(0, 5, "e344_1.txt")
	event.LoadChara(5, "e344_need.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e344_morton.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e344_hanabi.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e344_hanabi1.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e344_hanabi.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSetPos(0, 2190.0, 0.0, 2160.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "後ろ手立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 2210.0, 0.0, 2160.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 2146.83, 245.98, 2255.25)
	event.EohSetRot(2, 0.0, 0.72, 0.0)
	event.EohSetMotion(2, "花火", 5)
	event.EohSetPos(3, 2276.07, 265.14, 2324.42)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "花火B", 5)
	event.EohSetPos(4, 2245.48, 221.91, 2338.94)
	event.EohSetRot(4, 0.0, -1.8, 0.0)
	event.EohSetMotion(4, "花火", 5)
	helper_d7ca8cd7()
	event.InitDramaScene()
	time = event.GetTime() or time
	event.SetTimeStepEnable(0)
	event.SetTime(12.0)
	event.CmrsInit()
	event.CmrsSetPos(2164.39, 99.38, 1857.36)
	event.CmrsSetRef(2188.71, 85.83, 2173.89)
	event.CmrsMove2(2175.94, 58.96, 2007.92, 2188.71, 45.97, 2173.89, 80, 2, 1.0)
	event.SetFadeIn(30)
	event.CharaActive(0, 18)
	event.ObjsMove(7, 2063.4, 0.0, 2269.49, 300)
	event.ObjsMove(8, 2368.37, 0.0, 2200.11, 180)
	helper_184013af()
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetShadow(0, 0)
	event.EohSetShadow(1, 0)
	if vm.wait() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(2162.71, 15.34, 2193.63)
	event.CmrsSetRef(2193.59, 20.71, 2166.19)
	event.ObjsSetMotion(1, "右向き", 6)
	event.ObjsNextMotion(1, "右向き会話", 6)
	event.ObjsNextMotion(1, "右向きＬ", 4)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "口パク")
	helper_6c719c99(3440010)
	if vm.skipping() then
		return skip(6)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "後ろ手会話", 2)
	event.ObjsNextMotion(0, "後ろ手立ち", 4)
	event.SetPakuAnim(0, "口パク")
	helper_6c719c99(3440020)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "口パク")
	helper_6c719c99(3440030)
	if vm.skipping() then
		return skip(9)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "右向き会話", 2)
	event.ObjsNextMotion(1, "右向きＬ", 4)
	event.SetPakuAnim(1, "口パク")
	helper_6c719c99(3440040)
	if vm.skipping() then
		return skip(11)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 4)
	helper_aafd6a80(12)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "見上げ", 2)
	event.ObjsNextMotion(0, "見上げＬ", 4)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "見上げ", 2)
	event.ObjsNextMotion(1, "見上げＬ", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(0, 15)
	event.CharaActive(0, 16)
	event.CharaActive(1, 18)
	event.ObjsSetMotion(6, "会話", 4)
	event.ObjsMove(10, 2210.66, 0.0, 2067.07, 150)
	event.EohSetShadow(0, 1)
	event.EohSetShadow(1, 1)
	event.CmrsSetPos(2200.0, 22.0, 2000.0)
	event.CmrsSetRef(2200.0, 32.0, 2060.0)
	event.CmrsMove2(2200.0, 64.0, 2000.0, 2200.0, 92.0, 2060.0, 60, 0, 1.0)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(2, "花火", 4)
	event.ObjsMotionDelay(2, 56)
	event.ObjsSetMotion(2, "花火", 6)
	event.ObjsPosDelay(2, 56)
	event.ObjsSetPos(2, 2129.58, 169.43, 2213.1)
	event.ObjsSetRot(2, 0.0, 2.04, 0.0)
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(3, "花火B", 4)
	event.ObjsMotionDelay(3, 56)
	event.ObjsSetMotion(3, "花火B", 6)
	event.ObjsPosDelay(3, 56)
	event.ObjsSetPos(3, 2175.47, 334.69, 2328.55)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(4, "花火", 4)
	event.ObjsMotionDelay(4, 56)
	event.ObjsSetMotion(4, "花火", 6)
	event.ObjsPosDelay(4, 56)
	event.ObjsSetPos(4, 2298.38, 266.92, 2276.97)
	event.ObjsSetRot(4, 0.0, -2.0, 0.0)
	helper_aafd6a80(2)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 4)
	helper_184013af()
	if vm.skipping() then
		return skip(20)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]From now on, Fishing Contests will be\n   held at fixed intervals (in game time)\n   in Palm Brinks town square.<page>   When one contest ends, the next one\n   will begin after a 10 day interval.<page>   Whenever a Fishing Contest is being\n   held, it will be so indicated at the\n   top left of the Main Menu."
	)
	helper_36526538(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMesPreset(0, 0)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(22)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_11c40()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_aafd6a80(15)
			end
			if at <= 2 then
				helper_aafd6a80(30)
			end
			return 1
		end
		if at <= 4 then
			helper_aafd6a80(45)
		end
		return 0
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetMesWindowMode(0, 5)
	event.MesMake_2(0, "Move to Main Street?")
	var0 = helper_9d3aacf6(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 15)
		do
			local out1, out2, _ = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
		end
		event.ObjsMove(0, var1, var2, 1700.0, 60)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 15)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(4)
	end
	do
		local out1, out2, _ = event.GetCharaPos(0)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	event.ObjsMove(0, var4, var5, 2000.0, 45)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_f3fc()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_a03e568e(4240010, -1, 4)
			end
			if at <= 2 then
				helper_a03e568e(4240020, -1, 4)
			end
			if at <= 3 then
				helper_a03e568e(4240030, -1, 4)
			end
			if at <= 4 then
				helper_a03e568e(4240040, -1, 4)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if at <= 6 then
				helper_1f9a3afd(4240050, -1)
			end
			if at <= 7 then
				helper_1f9a3afd(4240055, -1)
			end
			if at <= 8 then
				helper_aafd6a80(30)
			end
			if at <= 9 then
				helper_36526538(0, -1, 8, 0, 0)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		if at <= 11 then
			helper_aafd6a80(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SpriteSetDraw(0, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
		event.CharaActive(0)
		event.SetStatusbarShow(1, 1.0)
	end
	event.SetFlag(424, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.StopBgm(0)
	event.LoadSound(1253)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.LoadMes(0, 5, "event/e400/e424/e424_1.txt")
	event.LoadChara(5, "event/e300/e344/e344_need.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/e400/e424/e424_morton.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(10, "p06_e03h03-0")
	event.EohSyncObj(11, "p07_e03h03-0")
	event.EohSetShow(10, 1)
	event.EohSetShow(11, 0)
	event.EohSetPos(0, 2190.0, 0.0, 2160.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "後ろ手立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.EohSetPos(1, 2210.0, 0.0, 2160.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目パチ")
	event.StopBgm(0)
	event.InitDramaScene()
	event.EohSetFootSoundId(1, 2)
	event.EohSetFootSoundId(0, 2)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(80)
	event.CmrsAddPas(2200.29, 143.98, 1871.42, 2199.34, 111.2, 2162.75)
	event.CmrsAddPas(2199.85, 143.98, 2007.37, 2199.34, 111.2, 2162.75)
	event.CmrsStartPas()
	event.SetFadeIn(30)
	helper_184013af()
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.ObjsSetMotion(1, "右向き歩き", 4)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 800)
	event.ObjsAddPas(1, 2649.81, 0.0, 2745.79)
	event.ObjsAddPas(1, 2569.46, 0.0, 2431.71)
	event.ObjsAddPas(1, 2359.06, 0.0, 2278.55)
	event.ObjsStartPas(1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 800)
	event.ObjsAddPas(0, 2670.81, 0.0, 2739.61)
	event.ObjsAddPas(0, 2585.76, 0.0, 2406.99)
	event.ObjsAddPas(0, 2368.7, 0.0, 2242.24)
	event.ObjsStartPas(0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(800)
	event.CmrsAddPas(2707.18, 23.28, 2717.95, 2587.81, 30.11, 2773.32)
	event.CmrsAddPas(2609.31, 23.28, 2381.58, 2519.89, 30.11, 2465.71)
	event.CmrsAddPas(2365.94, 23.28, 2198.82, 2363.56, 30.11, 2299.54)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "口パク")
	helper_a03e568e(4240010, -1, 4)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(0, "口パク")
	helper_a03e568e(4240020, -1, 4)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "口パク")
	helper_a03e568e(4240030, -1, 4)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(0, "口パク")
	helper_a03e568e(4240040, -1, 4)
	if vm.skipping() then
		return skip(5)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	event.ObjsInit(1)
	event.ObjsInit(0)
	event.ObjsSyncObj(1, 1)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2192.6, 0.0, 2256.59)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 2218.18, 0.0, 2250.95)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.CmrsSetPos(2318.18, 63.77, 2144.79)
	event.CmrsSetRef(2246.72, 30.11, 2277.0)
	event.ObjsMove(0, 2188.39, 18.0, 2374.73, 240, 1)
	event.ObjsMove(1, 2213.69, 18.0, 2374.73, 240, 1)
	helper_1f9a3afd(4240050, -1)
	if vm.skipping() then
		return skip(7)
	end
	helper_1f9a3afd(4240055, -1)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetMotion(1, "立ち", 4)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Finny Frenzies will be held in\n   Palm Brinks town square.<page>   From now on, Fishing Contests and Finny\n   Frenzies will be held alternately at\n   fixed intervals (in game time)."
	)
	helper_36526538(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	helper_2164b10b()
	old_map_no = event.GetOldMapNo() or old_map_no
	if old_map_no == 99 or old_map_no == 95 then
		event.SetCharaPos(0, 2200.0, 18.0, 2350.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.SetFadeIn(30)
		event.ResetCamera(1, 0.0, 10.0)
	elseif old_map_no == -1 then
		event.SetCharaPos(0, 2085.0, 65.0, 3470.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.SetFadeIn(30)
		event.ResetCamera(1, 0.0, 10.0)
	else
		event.SetCharaPos(0, 2200.0, 0.0, 2000.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetFadeIn(30)
		event.ResetCamera(1, 3.1415927, 10.0)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cdc4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 202.
script[202] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_11c40()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.SetFadeOut(0)
		if vm.wait() then
			return skip(2)
		end
		event.MapJump(-1, "m01")
		return
	end
end

--- Program 203.
script[203] = function()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
	end
	event.SetMotion(0, "立ち", 4)
	var0 = event.GetMenuEtc_2(1) or var0
	if var0 == 0 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "Currently Closed.\nAuthorised Personnel Only.")
		helper_36526538(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesPreset(0, 0)
		return
	end
	event.SetMesWindowMode(0, 5)
	if var0 == 1 then
		event.MesMake_2(0, "Enter Fishing Contest Grounds?")
	else
		event.MesMake_2(0, "Enter Finny Frenzy Races?")
	end
	var1 = helper_9d3aacf6(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	if var1 ~= 0 then
		return
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(3)
	end
	if var0 == 1 then
		event.MapJump(-1, "i03h03")
	else
		event.MapJump(-1, "i03h04")
	end
	if vm.wait() then
		return skip(4)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_9a6fd52f()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump(-1, "i03h01a", 500)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cdc4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d03f03", "d03f03", 6)
	event.LoadScript("d03/d03.stb", 500)
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f3fc()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	event.LoadScript("d04/d04.stb", 500)
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_9a6fd52f()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump(-1, "i03h01a", 500)
end

--- Program 13440.
script[13440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cdc4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14240.
script[14240] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f3fc()
	if vm.skipping() then
		return skip(1)
	end
end

return script
