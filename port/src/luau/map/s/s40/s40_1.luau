--!strict
--- Veniccio demo with battleship scenes.

local veniccio_demo = require("@lib/event/veniccio_demo")

--- Does nothing.
local function initialize_map() end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = initialize_map

--- Plays the battleship flyover and sighting scenes.
function script.key_open()
	veniccio_demo.play_noon_battleship_flyover()
	veniccio_demo.play_night_battleship_sighting()
end

--- Plays the battleship arrival and jumps to g03.
function script.cutscene_battleship_arrival()
	veniccio_demo.play_battleship_arrival_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g03", 510)
end
script[500] = script.cutscene_battleship_arrival

return script
