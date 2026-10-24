--!strict
-- map/s/s53/s53_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03b67047 = require("@lib/event/helper_03b67047")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_03b67047

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_03b67047()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s37", 500)
	vm.wait(2)
end

return script
