--!strict
-- map/s/s40/s40_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_038e8061 = require("@lib/event/helper_038e8061")
local helper_31cdc3de = require("@lib/event/helper_31cdc3de")
local helper_91523f96 = require("@lib/event/helper_91523f96")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = event_99

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_038e8061()
	helper_31cdc3de()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_91523f96()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "g03", 510)
end

return script
