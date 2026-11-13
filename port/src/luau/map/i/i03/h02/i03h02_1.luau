--!strict
--- Fishing Town house interior script that plays the opening crowd and clown show scene.

local vm = require("@lib/vm")
local fishing_town_house_h02 = require("@lib/event/fishing_town_house_h02")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the map's default entry behavior is suppressed.
function script.default_event() end

--- Plays the crowd arrival and the clown show and loads the next part of the scene.
function script.cutscene_opening_clown_show()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		fishing_town_house_h02.play_opening_crowd_arrival()
		resume_step = 2
		fishing_town_house_h02.play_opening_clown_show()
		event.load_event_script("i03h02/i03h02_2.stb", 151)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				fishing_town_house_h02.play_opening_clown_show()
				return vm.continue_with(function()
					event.load_event_script("i03h02/i03h02_2.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_opening_clown_show

return script
