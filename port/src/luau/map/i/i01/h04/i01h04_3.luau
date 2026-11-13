--!strict
--- Palm Brinks house interior script that handles villager dialogue.

local cutscene = require("@lib/event/cutscene")
local villager_dialogue = require("@lib/event/german/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the map's default entry behavior is suppressed.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the square-button hook is suppressed.
function script.key_open() end

--- Starts the dialogue with the villager in character slot 15 unless the story has progressed past the point where they talk.
function script.talk_to_villager_15()
	local story_progress: s32 = 0
	local character_slot: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		cutscene.noop()
		return
	end
	event.set_event_data_field(14, 15)
	character_slot = event.get_character_slot_by_number(15) or character_slot
	event.set_event_data_field(13, character_slot)
	villager_dialogue.talk_to_triggered_villager()
end
script[550] = script.talk_to_villager_15

--- Starts the dialogue with the villager that was spoken to unless the story has progressed past the point where they talk.
function script.on_talk()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		cutscene.noop()
		return
	end
	villager_dialogue.talk_to_triggered_villager()
end
script[1000] = script.on_talk

return script
