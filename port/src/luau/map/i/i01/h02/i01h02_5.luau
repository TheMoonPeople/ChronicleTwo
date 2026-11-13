--!strict
--- Palm Brinks shop interior script that places the player on entry and handles talking to the shopkeeper.

local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local palm_brinks_villagers = require("@lib/event/spanish/palm_brinks_villagers")
local villager_dialogue = require("@lib/event/spanish/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Places the player just inside the entrance and fades in when the shop is entered.
function script.default_event()
	cutscene.noop()
	event.initialize_event()
	event.set_character_position(0, -5.0, 0.0, 82.0)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_character_motion(0, "立ち")
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 200, which map data, a script or the engine runs by number.
script[200] = map.enter_door_waiting_frames

--- Opens the shop greeting with the shopkeeper or shows the villager's regular dialogue depending on story progress.
function script.talk_to_shopkeeper()
	local shopkeeper_slot: s32 = 0
	local story_progress: s32 = 0
	event.set_event_data_field(14, 12)
	shopkeeper_slot = 24
	event.set_event_data_field(13, shopkeeper_slot)
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, shopkeeper_slot)
		return
	end
	villager_dialogue.talk_to_triggered_villager()
end
script[400] = script.talk_to_shopkeeper

--- Opens the shop greeting or shows the villager's regular dialogue for the character that was spoken to.
function script.on_talk()
	local villager_slot: s32 = 0
	local story_progress: s32 = 0
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, villager_slot)
		return
	end
	villager_dialogue.talk_to_triggered_villager()
end
script[1000] = script.on_talk

return script
