--!strict
-- map/s/s59/s59_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3306dbdc = require("@lib/event/helper_3306dbdc")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_3306dbdc()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s37", 510)
	vm.wait(2)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_3306dbdc()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s37", 510)
	vm.wait(2)
end

return script
