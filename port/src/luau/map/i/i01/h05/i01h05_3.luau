--!strict
--- Palm Brinks house interior script that places the player on entry and handles villager dialogue.

local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local villager_dialogue = require("@lib/event/german/villager_dialogue")

--- Places the player at the entrance when the interior is entered.
local function default_event()
	cutscene.noop()
	event.initialize_event()
	event.set_character_position(0, 43.5, 0.0, 135.0)
	event.set_character_rotation(0, 0, 3.14, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

script.default_event = default_event

--- Event 123, which map data, a script or the engine runs by number.
script[123] = default_event

--- Event 200, which map data, a script or the engine runs by number.
script[200] = map.enter_door_waiting_frames

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
