--!strict
--- Girard House town house interior script that places the quest NPC on entry and handles villager dialogue.

local i04_house_h02 = require("@lib/event/i04_house_h02")
local villager_dialogue = require("@lib/event/english/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = i04_house_h02.place_quest_npc_if_requested

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the square-button hook is suppressed.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
