--!strict
--- Italian dialogue for the cook behind the Castagnaccio quest request.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")

local cook = {}

--- Plays the cook's idle chat about food, with a different line in chapter 8.
function cook.chat_about_food(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Salve. Che tipo di cibo ti piace,\nMonica?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Certo, mi piace il cibo normale,\nma apprezzo anche quello esotico.")
	else
		event.open_message_window_2(
			0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Starts the conversation with the cook NPC, choosing the dialogue from the player character and the quest request status.
function cook.start_conversation(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		cook.chat_about_food(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_cooking_experiments(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 3) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_chestnuts(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_chestnut(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_aspiring_chef(npc_character, player_character)
		return
	end
end

return cook
