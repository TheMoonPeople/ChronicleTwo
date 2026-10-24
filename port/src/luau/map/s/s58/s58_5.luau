--!strict
-- map/s/s58/s58_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b09f02b = require("@lib/event/helper_1b09f02b")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1b09f02b

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1b09f02b()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s31", 500)
	vm.wait(2)
end

return script
