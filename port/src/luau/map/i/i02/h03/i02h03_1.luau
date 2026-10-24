--!strict
-- map/i/i02/h03/i02h03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_0579a945 = require("@lib/event/helper_0579a945")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.SetCharaPos(0, 5.0, -0.54, 25.0)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_0579a945

return script
