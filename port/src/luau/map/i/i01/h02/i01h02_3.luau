--!strict
-- map/i/i01/h02/i01h02_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_6b19ac13 = require("@lib/event/helper_6b19ac13")
local helper_c3116e48 = require("@lib/event/helper_c3116e48")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.Initialize()
	event.SetCharaPos(0, -5.0, 0.0, 82.0)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetMotion(0, "立ち")
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	local var1: s32 = 0
	event.SetEventData(14, 12)
	var0 = 24
	event.SetEventData(13, var0)
	var1 = event.GetSavedataEtc(0) or var1
	if var1 == 100 then
		helper_6b19ac13()
		event.SetAi(1, var0)
		return
	end
	helper_c3116e48()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetSavedataEtc(0) or var1
	if var1 == 100 then
		helper_6b19ac13()
		event.SetAi(1, var0)
		return
	end
	helper_c3116e48()
end

return script
