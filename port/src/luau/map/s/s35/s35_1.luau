--!strict
-- map/s/s35/s35_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2fb9721e = require("@lib/event/helper_2fb9721e")
local helper_63218706 = require("@lib/event/helper_63218706")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_2fb9721e()
	event.load_dungeon_map("d06e01")
	event.load_event_script("d06e01/d06e01.stb", 506)
	vm.wait(2)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_63218706()
	event.load_dungeon_map("d06e01")
	event.load_event_script("d06e01/d06e01.stb", 508)
	vm.wait(2)
end

return script
