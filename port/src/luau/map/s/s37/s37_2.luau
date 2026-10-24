--!strict
-- map/s/s37/s37_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_686403b1 = require("@lib/event/helper_686403b1")
local helper_9ccebff2 = require("@lib/event/helper_9ccebff2")
local helper_bfd97a38 = require("@lib/event/helper_bfd97a38")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_f5acf237 = require("@lib/event/helper_f5acf237")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_bfd97a38

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
		event.StopBgm(0)
		helper_5be5f988()
	else
		event.SndSePlay(var0, 108)
		helper_5fb66cb1()
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
		event.StopBgm(0)
		helper_5be5f988()
	else
		event.SndSePlay(var0, 108)
		helper_5fb66cb1()
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local var0: s32 = 0
	print("--------------------------event202-------------------------\n")
	helper_3300e99f(vm.f32(3.1415927))
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetCnt(0, 1)
	event.SetCharaPos(0, 0.0, -14.0, 235.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.StopBgm(0)
	event.MapJump_2(-1, "s38")
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_686403b1()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s59", 500)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_f5acf237()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s58", 500)
	vm.wait(2)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_9ccebff2()
	event.MapJump_3(-1, "s11", 520)
	vm.wait(2)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	helper_bfd97a38()
	event.MapJump_3(-1, "s11", 599)
	vm.wait(2)
end

--- Event 16480, which map data, a script or the engine runs by number.
function script.event_16480()
	helper_9ccebff2()
	event.MapJump_3(-1, "s11", 520)
	vm.wait(2)
end

return script
