--!strict
-- map/s/s33/s33_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_160a3046 = require("@lib/event/helper_160a3046")
local helper_455f6141 = require("@lib/event/helper_455f6141")
local helper_8ee6cf94 = require("@lib/event/helper_8ee6cf94")
local helper_9c882551 = require("@lib/event/helper_9c882551")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a6113d19 = require("@lib/event/helper_a6113d19")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(600) or flag
	flag_2 = event.GetFlag(604) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_a6113d19()
	else
		if flag_2 == 1 then
			event.EohSyncObj_3(0, "p01_s3302-0", "s330208-m0")
			event.EohSyncObj_3(1, "p01_s3302-0", "s330208-m1")
			event.EohSetRot(0, 0.0, 0.61, 0.0)
			event.EohSetRot(1, 0.0, -0.61, 0.0)
		end
		helper_9dafbc83(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_455f6141

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_8ee6cf94() ~= 0 then
		event.BgmLoadCancel()
		event.GotoDng(5, -1, 500)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	if helper_9c882551() ~= 0 then
		event.MapJump_2(-1, "s31")
	end
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_160a3046()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "f02", 510)
	vm.wait(2)
end

--- Event 16040, which map data, a script or the engine runs by number.
script.event_16040 = helper_a6113d19

return script
