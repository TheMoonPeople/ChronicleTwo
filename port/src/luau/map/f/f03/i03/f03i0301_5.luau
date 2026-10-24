--!strict
-- map/f/f03/i03/f03i0301_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2891f2af = require("@lib/event/helper_2891f2af")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b3aed52d = require("@lib/event/helper_b3aed52d")
local helper_daeaeed0 = require("@lib/event/helper_daeaeed0")
local helper_e211c72f = require("@lib/event/helper_e211c72f")
local helper_f23f3848 = require("@lib/event/helper_f23f3848")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	helper_daeaeed0()
	flag = event.GetFlag(400) or flag
	flag_2 = event.GetFlag(408) or flag_2
	if flag == 1 then
		if flag_2 == 0 then
			flag_3 = event.GetFlag(414) or flag_3
			if flag_3 == 0 then
				helper_e211c72f()
				return
			end
		else
			flag_4 = event.GetFlag(412) or flag_4
			if flag_4 == 0 then
				event.AddItem(360)
				helper_b3aed52d()
				return
			end
		end
	end
	helper_9dafbc83(0.0, vm.f32(69.1), -200.0, vm.f32(-1.57))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_b3aed52d

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	helper_3300e99f(vm.f32(3.1415927))
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.MapJump_2(-1, "f03")
	vm.wait(3)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	helper_daeaeed0()
	event.AddItem(154)
	helper_2891f2af()
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_f23f3848

--- Event 14120, which map data, a script or the engine runs by number.
function script.event_14120()
	event.SetFlag(408, 1)
	helper_daeaeed0()
	helper_b3aed52d()
end

--- Event 14140, which map data, a script or the engine runs by number.
function script.event_14140()
	event.SetFlag(408, 0)
	helper_daeaeed0()
	helper_e211c72f()
end

--- Event 14680, which map data, a script or the engine runs by number.
function script.event_14680()
	helper_daeaeed0()
	helper_2891f2af()
end

return script
