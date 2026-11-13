--!strict
--- Plays the train chapter intro and moves on to map s31.

local vm = require("@lib/vm")
local subdimension = require("@lib/event/subdimension")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = subdimension.play_train_chapter_intro

--- Plays the train chapter intro and moves on to map s31.
function script.cutscene_train_chapter_intro()
	subdimension.play_train_chapter_intro()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s31", 500)
	vm.wait(2)
end
script[500] = script.cutscene_train_chapter_intro

return script
