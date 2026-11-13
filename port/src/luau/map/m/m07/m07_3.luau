--!strict
--- Event script for map m07, which plays the rain run scene and jumps to map s42.

local vm = require("@lib/vm")
local palm_brinks_m07 = require("@lib/event/palm_brinks_m07")
local wait = require("@lib/event/wait")

--- Plays the rain run scene and jumps to map s42.
local function cutscene_rain_run()
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		vm.entry(1)
		event.fade_out_screen(0)
		stage = 2
		vm.wait(2)
		event.set_save_flag(4, 1)
		stage = 3
		palm_brinks_m07.play_rain_run_scene()
		event.jump_to_map_3(-1, "s42", 500)
		return
	end, function(received: { any })
		if stage <= 3 then
			if stage <= 2 then
				stage = 3
				palm_brinks_m07.play_rain_run_scene()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s42", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides entry handling with nothing.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = palm_brinks_m07.play_rain_run_scene

script.cutscene_rain_run = cutscene_rain_run
script[151] = script.cutscene_rain_run

--- Stops the music and runs the rain run scene.
function script.cutscene_rain_run_after_music_stop()
	local stage: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		stage = 1
		wait.frames(6)
		stage = 2
		cutscene_rain_run()
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage <= 1 then
				stage = 2
				cutscene_rain_run()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[10010] = script.cutscene_rain_run_after_music_stop

return script
