--!strict
--- Plays the flashback scenes that lead from the town into dungeon floor d05b01.

local vm = require("@lib/vm")
local gaspard_flashback_scene = require("@lib/event/gaspard_flashback_scene")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the mother's deathbed flashback after a short pause.
function script.default_event()
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		wait.frames(30)
		checkpoint = 2
		gaspard_flashback_scene.play_mother_deathbed_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				gaspard_flashback_scene.play_mother_deathbed_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = gaspard_flashback_scene.play_mother_deathbed_scene

--- Plays the mother's deathbed scene and loads dungeon d05b01.
function script.cutscene_mother_deathbed()
	gaspard_flashback_scene.play_mother_deathbed_scene()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 561)
end
script[500] = script.cutscene_mother_deathbed

--- Plays the door scene and loads dungeon d05b01.
function script.cutscene_door_scene()
	gaspard_flashback_scene.play_door_scene()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 571)
end
script[510] = script.cutscene_door_scene

return script
