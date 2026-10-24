--!strict
-- map/i/i03/h02/i03h02_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_4bb71a3e = require("@lib/event/helper_4bb71a3e")
local helper_8f404f80 = require("@lib/event/helper_8f404f80")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_4bb71a3e()
	helper_8f404f80()
	event.LoadScript("i03h02/i03h02_2.stb", 151)
end

return script
