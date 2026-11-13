--!strict
--- Paznos observatory arrival and exit scene.

local vm = require("@lib/vm")
local paznos_observatory = require("@lib/event/paznos_observatory")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Places the player at the observatory entrance and fades in.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 0.0, 2721.0, -500.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = paznos_observatory.play_event_e540

--- Plays the observatory scene and jumps to s30.
function script.cutscene_observatory_to_s30()
	paznos_observatory.play_event_e540()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s30", 605)
end
script[600] = script.cutscene_observatory_to_s30

return script
