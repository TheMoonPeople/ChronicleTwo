--!strict
-- map/i/i03/h01/i03h01_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_601a9055 = require("@lib/event/helper_601a9055")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	print("----200----------------------------------------\n")
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	print("----210----------------------------------------\n")
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_601a9055

return script
