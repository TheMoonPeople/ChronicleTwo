--!strict
--- Plays the train departure scene at the Luna lab and moves on to map s37.

local vm = require("@lib/vm")
local luna_lab = require("@lib/event/luna_lab")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the train departure scene and moves on to map s37.
function script.key_open()
	luna_lab.play_train_departure_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s37", 510)
	vm.wait(2)
end

--- Plays the train departure scene and moves on to map s37.
function script.cutscene_train_departure()
	luna_lab.play_train_departure_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s37", 510)
	vm.wait(2)
end
script[500] = script.cutscene_train_departure

return script
