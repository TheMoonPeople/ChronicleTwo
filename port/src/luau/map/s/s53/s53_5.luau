--!strict
-- map/s/s53/s53_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41af55f1 = require("@lib/event/helper_41af55f1")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_41af55f1

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_41af55f1()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s37", 500)
	vm.wait(2)
end

return script
