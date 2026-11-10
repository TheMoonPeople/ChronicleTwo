--!strict
-- map/i/i04/h02/i04h02a_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02d91c01 = require("@lib/event/helper_02d91c01")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	event.set_villager_ai_enabled(0, 8)
	event.set_character_active(0, 8)
	event.set_camera_position(19.51, 30.7, -34.38)
	event.set_camera_look_at(49.07, 14.1, 12.65)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_position(0, 30.65, 0.0, -2.05)
	event.set_character_rotation(0, 0.0, 1.3, 0.0)
	event.set_character_motion(0, "立ち")
	event.load_character(5, "chara/tp01_16a.gltf", "info", 8)
	event.set_character_active(1, 8)
	event.set_character_position(8, 48.62, 0.0, 3.43)
	event.set_character_rotation(8, 0.0, -1.78, 0.0)
	event.set_character_motion(8, "待機")
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_02d91c01

return script
