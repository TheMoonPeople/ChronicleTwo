--!strict
-- map/i/i04/h01/i04h01a.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_7b829e53 = require("@lib/event/helper_7b829e53")
local helper_cce4ecf1 = require("@lib/event/helper_cce4ecf1")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_7b829e53(0)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_cce4ecf1

return script
