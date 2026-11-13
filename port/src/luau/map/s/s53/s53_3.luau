--!strict
--- Plays the central lab scene and moves on to map s37.

local vm = require("@lib/vm")
local central_lab_event = require("@lib/event/central_lab_event")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = central_lab_event.play_lab_scene

--- Plays the lab scene and moves on to map s37.
function script.cutscene_central_lab()
	central_lab_event.play_lab_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s37", 500)
	vm.wait(2)
end
script[500] = script.cutscene_central_lab

return script
