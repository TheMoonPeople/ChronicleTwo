--!strict
--- Plays the golem march, stampede, night map and cannon barrage scenes of the Paznos battle.

local vm = require("@lib/vm")
local paznos_event_battle = require("@lib/event/paznos_event_battle")
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

--- Plays the golem stampede from the left, the center and the right in turn.
function script.key_open()
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		wait.frames(30)
		checkpoint = 2
		paznos_event_battle.play_golem_stampede_left()
		checkpoint = 3
		paznos_event_battle.play_golem_stampede_center()
		checkpoint = 4
		paznos_event_battle.play_golem_stampede_right()
		return
	end, function(received: { any })
		if checkpoint <= 4 then
			if checkpoint <= 1 then
				checkpoint = 2
				paznos_event_battle.play_golem_stampede_left()
				return vm.continue_with(function()
					checkpoint = 3
					paznos_event_battle.play_golem_stampede_center()
					checkpoint = 4
					paznos_event_battle.play_golem_stampede_right()
					return
				end)
			end
			if checkpoint <= 2 then
				checkpoint = 3
				paznos_event_battle.play_golem_stampede_center()
				return vm.continue_with(function()
					checkpoint = 4
					paznos_event_battle.play_golem_stampede_right()
					return
				end)
			end
			if checkpoint <= 3 then
				checkpoint = 4
				paznos_event_battle.play_golem_stampede_right()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the golem march and moves on to map f30.
function script.cutscene_golem_march()
	paznos_event_battle.play_golem_march()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 601)
end
script[600] = script.cutscene_golem_march

--- Plays the full golem stampede and moves on to map f30.
function script.cutscene_golem_stampede()
	paznos_event_battle.play_golem_stampede_full()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 602)
end
script[601] = script.cutscene_golem_stampede

--- Shows the night map view and moves on to map f30.
function script.cutscene_night_map_view()
	paznos_event_battle.show_night_map_view()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 603)
end
script[602] = script.cutscene_night_map_view

--- Plays the cannon barrage and moves on to map f30.
function script.cutscene_cannon_barrage()
	paznos_event_battle.play_cannon_barrage()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 604)
end
script[603] = script.cutscene_cannon_barrage

return script
