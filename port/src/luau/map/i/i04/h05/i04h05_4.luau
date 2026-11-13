--!strict
--- Event script for the i04h05 house interior, which supports villager conversation and places the quest NPC on entry.

local i04_house_h05 = require("@lib/event/i04_house_h05")
local villager_dialogue = require("@lib/event/italian/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = i04_house_h05.place_quest_npc_if_ready

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button handler with nothing.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
