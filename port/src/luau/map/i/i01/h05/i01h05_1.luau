--!strict
-- map/i/i01/h05/i01h05_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_0579a945 = require("@lib/event/helper_0579a945")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
local function default_event()
	helper_1ef0d4b2()
	event.Initialize()
	event.SetCharaPos(0, 43.5, 0.0, 135.0)
	event.SetCharaRot(0, 0, 3.14, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.default_event = default_event

--- Event 123, which map data, a script or the engine runs by number.
script.event_123 = default_event

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_0579a945

return script
