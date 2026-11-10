--!strict
-- map/s/s29/s29_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4896492a = require("@lib/event/helper_4896492a")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 0.0, 2721.0, -500.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_4896492a

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_4896492a()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s30", 605)
end

return script
