--!strict
--- Plays the evening speech scene and the ending movie with captions.

local vm = require("@lib/vm")
local palm_brinks_s60 = require("@lib/event/palm_brinks_s60")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs it in place of its default.
function script.do_nothing() end
script[99] = script.do_nothing

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine runs it in place of its default.
function script.default_event() end

--- Sets the evening time of day and plays the speech scene.
function script.key_open()
	local checkpoint: number = 0
	return vm.guard(function()
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		checkpoint = 1
		wait.frames(30)
		checkpoint = 2
		palm_brinks_s60.play_e824_speech_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				palm_brinks_s60.play_e824_speech_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the ending movie with captions and flags the scene to exit.
function script.cutscene_ending_movie()
	palm_brinks_s60.play_ending_movie_with_captions()
	event.set_scene_exit_flag(1)
end
script[500] = script.cutscene_ending_movie

return script
