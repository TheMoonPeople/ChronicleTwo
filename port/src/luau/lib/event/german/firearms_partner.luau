--!strict
--- German dialogue for the firearms-minded villager behind quest request 11.

local vm = require("@lib/vm")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local quest_dialogue = vm.module("@lib/event/german/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/german/villager_dialogue")

local firearms_partner = {}

--- Starts the conversation with the firearms partner NPC, choosing the dialogue from the player character and the quest request status.
function firearms_partner.start_conversation(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_gun_fighter_monica(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_mining_advice(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_gerald_request(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_gun_for_recruit(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_villager_16_as_monica(npc_character, player_character)
		return
	end
end

return firearms_partner
