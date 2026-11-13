--!strict
--- Palm Brinks house interior script that handles villager dialogue.

local cutscene = require("@lib/event/cutscene")
local npc = require("@lib/event/npc")

--- Tells the player that Claire is probably drinking tea at the square.
local function tell_claire_location()
	local chara_no: s32 = 0
	event.stop_camera_control_movement()
	chara_no = 24
	event.set_villager_ai_enabled(0, chara_no)
	event.open_message_window_2(0, "Claire? I don't know.<page>She might be at the \nsquare drinking tea.")
	cutscene.talk(chara_no, -1, 0, 0)
	event.set_villager_ai_enabled(1, chara_no)
end

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
		tell_claire_location()
		return
	end
	event.set_event_data_field(14, 15)
	character_slot = event.get_character_slot_by_number(15) or character_slot
	event.set_event_data_field(13, character_slot)
	npc.talk_to_triggered_npc()
end
script[550] = script.talk_to_villager_15

--- Starts the dialogue with the villager that was spoken to unless the story has progressed past the point where they talk.
function script.on_talk()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		tell_claire_location()
		return
	end
	npc.talk_to_triggered_npc()
end
script[1000] = script.on_talk

return script
