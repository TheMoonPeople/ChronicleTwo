--!strict
--- English dialogue for the swordsmith whose sword request makes her join the party.

local vm = require("@lib/vm")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")

local swordsmith = {}

--- Starts the conversation with the swordsmith NPC, choosing the dialogue from the player character and the quest request status.
function swordsmith.start_conversation(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		npc_dialogue.chat_about_circus(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_blade_shopkeeper(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_sword_upgrade(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_sword_for_recruit(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_sword_fan(npc_character, player_character)
		return
	end
end

return swordsmith
