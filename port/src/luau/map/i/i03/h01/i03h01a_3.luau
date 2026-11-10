--!strict
-- map/i/i03/h01/i03h01a_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0325c60e = require("@lib/event/helper_0325c60e")
local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_82f852f5 = require("@lib/event/helper_82f852f5")
local helper_fe0f3321 = require("@lib/event/helper_fe0f3321")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.reset_follow_camera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_0325c60e

--- Event 152, which map data, a script or the engine runs by number.
script.event_152 = helper_82f852f5

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_0325c60e()
	event.go_to_dungeon(0, -1, 1000)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_82f852f5()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i02h01", 500)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_fe0f3321

--- Event 11091, which map data, a script or the engine runs by number.
script.event_11091 = helper_0325c60e

--- Event 11092, which map data, a script or the engine runs by number.
function script.event_11092()
	event.set_character_active(0, 8)
	helper_82f852f5()
	event.set_character_active(1, 8)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i02h01", 500)
	vm.wait(2)
end

return script
