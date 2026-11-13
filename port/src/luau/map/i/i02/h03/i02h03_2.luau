--!strict
--- Train Town house interior script that places the player on entry and handles villager dialogue.

local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local villager_dialogue = require("@lib/event/french/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Places the player at the entrance and resets the follow camera when the interior is entered.
function script.default_event()
	cutscene.noop()
	event.set_character_position(0, 5.0, -0.54, 25.0)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Event 200, which map data, a script or the engine runs by number.
script[200] = map.enter_door_waiting_frames

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
