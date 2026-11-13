--!strict
--- Fishing Town house interior script that plays the Pierrot raid and clown chase scenes.

local vm = require("@lib/vm")
local fishing_town_house_h02 = require("@lib/event/fishing_town_house_h02")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = fishing_town_house_h02.play_opening_clown_chase

--- Plays the Pierrot raid and the clown chase and jumps to the next map.
function script.cutscene_pierrot_raid()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		fishing_town_house_h02.play_pierrot_raid_scene()
		resume_step = 2
		fishing_town_house_h02.play_opening_clown_chase()
		event.jump_to_map_3(-1, "m06", 153)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				fishing_town_house_h02.play_opening_clown_chase()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "m06", 153)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_pierrot_raid

return script
