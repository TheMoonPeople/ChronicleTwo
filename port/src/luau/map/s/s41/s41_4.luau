--!strict
-- map/s/s41/s41_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c4f6430f = require("@lib/event/helper_c4f6430f")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = event_99

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_c4f6430f()
	event.jump_to_map_3(-1, "g04", 510)
	vm.wait(2)
end

--- Event 15040, which map data, a script or the engine runs by number.
function script.event_15040()
	helper_c4f6430f()
	event.jump_to_map_3(-1, "g04", 510)
	vm.wait(2)
end

return script
