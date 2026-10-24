--!strict
-- map/i/i04/h01/i04h01b_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_141169f3 = require("@lib/event/helper_141169f3")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.ResetCamera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_141169f3

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_141169f3()
	event.GotoDng(0, -1, 1000)
end

--- Event 11010, which map data, a script or the engine runs by number.
script.event_11010 = helper_141169f3

return script
