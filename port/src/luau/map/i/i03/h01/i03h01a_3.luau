--!strict
-- map/i/i03/h01/i03h01a_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_670235cf = require("@lib/event/helper_670235cf")
local helper_c3116e48 = require("@lib/event/helper_c3116e48")
local helper_efbd172c = require("@lib/event/helper_efbd172c")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.ResetCamera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_670235cf

--- Event 152, which map data, a script or the engine runs by number.
script.event_152 = helper_efbd172c

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_670235cf()
	event.GotoDng(0, -1, 1000)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_efbd172c()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i02h01", 500)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_c3116e48

--- Event 11091, which map data, a script or the engine runs by number.
script.event_11091 = helper_670235cf

--- Event 11092, which map data, a script or the engine runs by number.
function script.event_11092()
	event.CharaActive(0, 8)
	helper_efbd172c()
	event.CharaActive(1, 8)
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i02h01", 500)
	vm.wait(2)
end

return script
