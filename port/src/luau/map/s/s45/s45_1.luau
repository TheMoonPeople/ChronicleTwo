--!strict
-- map/s/s45/s45_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06597f83 = require("@lib/event/helper_06597f83")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_2164b10b = require("@lib/event/helper_2164b10b")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_84162341 = require("@lib/event/helper_84162341")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b1f88208 = require("@lib/event/helper_b1f88208")
local helper_b4492b0b = require("@lib/event/helper_b4492b0b")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_cb265f35 = require("@lib/event/helper_cb265f35")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_cdc4()
	local var0: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.EohSyncObj_2(0, "p06_e03h03-0")
		event.EohSyncObj_2(1, "p07_e03h03-0")
		event.EohSetShow(0, 0)
		event.EohSetShow(1, 1)
		event.SetFlag(344, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetStatusbarShow(0, 1.0)
		event.SoundAllStop()
		event.StopBgm(0)
		helper_25abe6d2(4)
		event.LoadBgm(0)
		event.PlayBgm(0)
		event.LoadSound(1251)
		var0 = event.SndLoadSound_2(1251) or var0
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
		helper_84162341()
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
		helper_c624bc16()
		helper_25abe6d2(10)
		event.EohSetShadow(0, 0)
		event.EohSetShadow(1, 0)
		vm.wait(4)
		event.SetCrossfade(30)
		event.CmrsSetPos(2162.71, 15.34, 2193.63)
		event.CmrsSetRef(2193.59, 20.71, 2166.19)
		event.ObjsSetMotion(1, "右向き", 6)
		event.ObjsNextMotion(1, "右向き会話", 6)
		event.ObjsNextMotion(1, "右向きＬ", 4)
		helper_25abe6d2(30)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(3440010)
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "後ろ手会話", 2)
		event.ObjsNextMotion(0, "後ろ手立ち", 4)
		event.SetPakuAnim(0, "口パク")
		helper_e34416e2(3440020)
		event.SetPakuAnim(0, "口パク")
		helper_e34416e2(3440030)
		helper_0958ca60(0)
		event.ObjsSetMotion(1, "右向き会話", 2)
		event.ObjsNextMotion(1, "右向きＬ", 4)
		event.SetPakuAnim(1, "口パク")
		helper_e34416e2(3440040)
		helper_0958ca60(1)
		event.SndSePlay(var0, 4)
		helper_25abe6d2(12)
		event.ObjsSetMotion(0, "見上げ", 2)
		event.ObjsNextMotion(0, "見上げＬ", 4)
		helper_25abe6d2(10)
		event.ObjsSetMotion(1, "見上げ", 2)
		event.ObjsNextMotion(1, "見上げＬ", 4)
		helper_0958ca60(1)
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
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "花火", 4)
		event.ObjsMotionDelay(2, 56)
		event.ObjsSetMotion(2, "花火", 6)
		event.ObjsPosDelay(2, 56)
		event.ObjsSetPos(2, 2129.58, 169.43, 2213.1)
		event.ObjsSetRot(2, 0.0, 2.04, 0.0)
		helper_25abe6d2(6)
		event.ObjsSetMotion(3, "花火B", 4)
		event.ObjsMotionDelay(3, 56)
		event.ObjsSetMotion(3, "花火B", 6)
		event.ObjsPosDelay(3, 56)
		event.ObjsSetPos(3, 2175.47, 334.69, 2328.55)
		event.ObjsSetRot(3, 0.0, -2.52, 0.0)
		helper_25abe6d2(10)
		event.ObjsSetMotion(4, "花火", 4)
		event.ObjsMotionDelay(4, 56)
		event.ObjsSetMotion(4, "花火", 6)
		event.ObjsPosDelay(4, 56)
		event.ObjsSetPos(4, 2298.38, 266.92, 2276.97)
		event.ObjsSetRot(4, 0.0, -2.0, 0.0)
		helper_25abe6d2(2)
		event.SndSePlay(var0, 4)
		helper_c624bc16()
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]From now on, Fishing Contests will be\n   held at fixed intervals (in game time)\n   in Palm Brinks town square.<page>   When one contest ends, the next one\n   will begin after a 10 day interval.<page>   Whenever a Fishing Contest is being\n   held, it will be so indicated at the\n   top left of the Main Menu."
		)
		helper_9e7d1511(0, -1, 8, 0, 0)
		event.SetMesPreset(0, 0)
		helper_25abe6d2(30)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
	end)
	event.CancelDramaScene()
	event.SndSeStop(var0, 4)
	event.SetTime(time)
	event.SetTimeStepEnable(1)
	helper_06597f83()
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.LoadMes(0, -1)
	event.CharaActive(0)
	event.SetStatusbarShow(1, 1.0)
end

--- Helper function.
local function helper_11c40()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.SetMotion(0, "立ち", 4)
		event.SetMesWindowMode(0, 5)
		event.MesMake_2(0, "Move to Main Street?")
		at = 1
		var0 = helper_b1f88208(0, -1, 8, 256, 208, 2, 1)
		if var0 == 0 then
			event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
			event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 15)
			do
				local out1, out2, _ = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
			end
			event.ObjsMove(0, var1, var2, 1700.0, 60)
			at = 2
			helper_25abe6d2(15)
			event.SetFadeOut(30)
			at = 3
			helper_25abe6d2(30)
			return 1
		end
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsRotation(0, 0.0, 0.0, 0.0, 15)
		at = 4
		helper_25abe6d2(15)
		do
			local out1, out2, _ = event.GetCharaPos(0)
			var4 = out1 or var4
			var5 = out2 or var5
		end
		event.ObjsMove(0, var4, var5, 2000.0, 45)
		at = 5
		helper_25abe6d2(45)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(15)
			end
			if at <= 2 then
				helper_d3f20302(30)
			end
			return 1
		end
		if at <= 5 then
			if at <= 4 then
				helper_d3f20302(45)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_f3fc()
	vm.section(function()
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
		event.EohSyncObj_2(10, "p06_e03h03-0")
		event.EohSyncObj_2(11, "p07_e03h03-0")
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
		helper_c624bc16()
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
		helper_cb265f35(4240010, -1, 4)
		event.SetPakuAnim(0, "口パク")
		helper_cb265f35(4240020, -1, 4)
		event.SetPakuAnim(1, "口パク")
		helper_cb265f35(4240030, -1, 4)
		event.SetPakuAnim(0, "口パク")
		helper_cb265f35(4240040, -1, 4)
		helper_25abe6d2(30)
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
		helper_c28d4a31(4240050, -1)
		helper_c28d4a31(4240055, -1)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
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
		helper_9e7d1511(0, -1, 8, 0, 0)
		event.SetMesPreset(0, 0)
	end)
	event.CancelDramaScene()
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SpriteSetDraw(0, 0)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.LoadMes(0, -1)
	event.ResetCamera(1, 0.0, 20.0)
	event.SetFadeIn(30)
	event.CharaActive(0)
	event.SetStatusbarShow(1, 1.0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
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

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_cdc4

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	if helper_11c40() ~= 0 then
		event.SetFadeOut(0)
		vm.wait(2)
		event.MapJump_2(-1, "m01")
		return
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local var0: s32 = 0
	local var1: any = 0
	event.SetMotion(0, "立ち", 4)
	var0 = event.GetMenuEtc_2(1) or var0
	if var0 == 0 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "Currently Closed.\nAuthorised Personnel Only.")
		helper_9e7d1511(0, -1, 8, 0, 0)
		event.SetMesPreset(0, 0)
		return
	end
	event.SetMesWindowMode(0, 5)
	if var0 == 1 then
		event.MesMake_2(0, "Enter Fishing Contest Grounds?")
	else
		event.MesMake_2(0, "Enter Finny Frenzy Races?")
	end
	var1 = helper_b1f88208(0, -1, 8, 256, 208, 2, 1)
	if var1 ~= 0 then
		return
	end
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	if var0 == 1 then
		event.MapJump_2(-1, "i03h03")
	else
		event.MapJump_2(-1, "i03h04")
	end
	vm.wait(4)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_b4492b0b()
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i03h01a", 500)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_cdc4()
	event.LoadDungeonMapFile("d03f03", "d03f03", 6)
	event.LoadScript("d03/d03.stb", 500)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_f3fc()
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	event.LoadScript("d04/d04.stb", 500)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_b4492b0b()
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i03h01a", 500)
end

--- Event 13440, which map data, a script or the engine runs by number.
script.event_13440 = helper_cdc4

--- Event 14240, which map data, a script or the engine runs by number.
script.event_14240 = helper_f3fc

return script
