--!strict
-- map/i/i01/h06/i01h06.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0fc04819 = require("@lib/event/helper_0fc04819")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_4e319702 = require("@lib/event/helper_4e319702")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.set_character_position(0, 0.0, 9.0, 171.0)
	event.set_character_rotation(0, 0, 3.14, 0)
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0fc04819

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_4e319702

return script
