--!strict
-- map/s/s43/s43b_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_372ba2bc = require("@lib/event/helper_372ba2bc")
local helper_ced7bb11 = require("@lib/event/helper_ced7bb11")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_372ba2bc

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_ced7bb11()
	helper_372ba2bc()
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.GotoEdit(17, 153)
end

--- Event 8000, which map data, a script or the engine runs by number.
script.event_8000 = helper_372ba2bc

return script
