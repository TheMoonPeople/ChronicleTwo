--!strict
-- map/s/s38/s38_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_266c0283 = require("@lib/event/helper_266c0283")
local helper_2ddb5a7a = require("@lib/event/helper_2ddb5a7a")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_94e331d8 = require("@lib/event/helper_94e331d8")
local helper_c462bcd5 = require("@lib/event/helper_c462bcd5")
local helper_db8bc11a = require("@lib/event/helper_db8bc11a")
local helper_df4094fb = require("@lib/event/helper_df4094fb")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.Initialize()
	print("##IN_START_EVENT################################\n")
	helper_db8bc11a()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(1, 3)
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event200-------------------------\n")
	helper_3300e99f(vm.f32(-1.5707964))
	var0 = event.GetSndId(2) or var0
	var1 = helper_df4094fb(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetCnt(15, 1)
		helper_94e331d8()
		event.StopBgm(0)
		helper_5be5f988()
	else
		helper_2ddb5a7a()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event201-------------------------\n")
	helper_3300e99f(vm.f32(1.5707964))
	var0 = event.GetSndId(2) or var0
	var1 = helper_df4094fb(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetCnt(15, 0)
		helper_94e331d8()
		event.StopBgm(0)
		helper_5be5f988()
	else
		helper_2ddb5a7a()
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event202-------------------------\n")
	helper_3300e99f(0.0)
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	helper_94e331d8()
	var1 = event.GetCnt(0) or var1
	if var1 == 1 then
		event.SetCnt(0, 0)
		event.SetCharaPos(0, 0.0, -22.4, -207.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.MapJump_2(-1, "s37")
	else
		var1 = vm.i32(var1 - 1)
		event.SetCnt(0, var1)
		helper_db8bc11a()
		event.SetCharaPos(0, 0.0, -14.0, -235.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event203-------------------------\n")
	helper_3300e99f(vm.f32(3.1415927))
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = event.GetCnt(0) or var1
	if var1 ~= 3 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		helper_94e331d8()
		var1 = vm.i32(var1 + 1)
		event.SetCnt(0, var1)
		helper_db8bc11a()
		event.SetCharaPos(0, 0.0, -14.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_2ddb5a7a()
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local argc: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		event.SetMesEtc(1, 10, 0)
		helper_c462bcd5()
		event.SetMesEtc(1, 10, 128)
	else
		helper_266c0283(var0, 0)
	end
end

return script
