--!strict
-- map/i/i04/h02/i04h02b_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_959b4d0c = require("@lib/event/helper_959b4d0c")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_959b4d0c(0)
end

return script
