--!strict
-- map/f/f04/i03/f04i03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_5c6fab98 = require("@lib/event/helper_5c6fab98")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_5c6fab98

return script
