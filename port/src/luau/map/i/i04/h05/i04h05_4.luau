--!strict
-- map/i/i04/h05/i04h05_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_5f59db59 = require("@lib/event/helper_5f59db59")
local helper_9c20c95c = require("@lib/event/helper_9c20c95c")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_9c20c95c

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_5f59db59

return script
