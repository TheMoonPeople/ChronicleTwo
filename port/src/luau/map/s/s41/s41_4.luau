--!strict
--- Heim Rada event with the Ark shadow scene.

local vm = require("@lib/vm")
local heim_rada_event = require("@lib/event/heim_rada_event")

--- Does nothing.
local function initialize_map() end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = initialize_map

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Plays the Ark shadow scene and jumps to g04.
function script.cutscene_ark_shadow()
	heim_rada_event.play_ark_shadow_scene()
	event.jump_to_map_3(-1, "g04", 510)
	vm.wait(2)
end
script[501] = script.cutscene_ark_shadow

--- Replays the Ark shadow scene and jumps to g04.
function script.replay_ark_shadow()
	heim_rada_event.play_ark_shadow_scene()
	event.jump_to_map_3(-1, "g04", 510)
	vm.wait(2)
end
script[15040] = script.replay_ark_shadow

return script
