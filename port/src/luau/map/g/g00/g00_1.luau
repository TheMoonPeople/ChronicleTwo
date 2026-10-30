--!strict
-- map/g/g00/g00_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_1336b93f = require("@lib/event/helper_1336b93f")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_ffb740a9 = require("@lib/event/helper_ffb740a9")
local show_message = require("@lib/event/show_message")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_c6c63376

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_c6c63376()
	event.reset_follow_camera(1, 0.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(0, "お洒落")
	show_message(0, -1, 8, 0, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	helper_1336b93f()
	helper_ffb740a9()
end

return script
