--!strict
-- map/i/i04/h02/i04h02_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_02d91c01 = require("@lib/event/helper_02d91c01")
local helper_cb183627 = require("@lib/event/helper_cb183627")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_cb183627

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_02d91c01

return script
