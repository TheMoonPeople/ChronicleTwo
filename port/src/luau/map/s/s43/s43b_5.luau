--!strict
--- Circus tent trapeze chase and curse scenes.

local vm = require("@lib/vm")
local circus_tent = require("@lib/event/circus_tent")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = circus_tent.play_part4_chapter1_trapeze_chase

--- Plays the curse scene then the trapeze chase.
function script.cutscene_curse_then_trapeze_chase()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		circus_tent.play_opening_curse_scene()
		resume_step = 2
		circus_tent.play_part4_chapter1_trapeze_chase()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				circus_tent.play_part4_chapter1_trapeze_chase()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_curse_then_trapeze_chase

--- Goes to Georama edit.
function script.enter_georama_edit()
	event.go_to_georama_edit(17, 153)
end
script[152] = script.enter_georama_edit

--- Event 8000, which map data, a script or the engine runs by number.
script[8000] = circus_tent.play_part4_chapter1_trapeze_chase

return script
