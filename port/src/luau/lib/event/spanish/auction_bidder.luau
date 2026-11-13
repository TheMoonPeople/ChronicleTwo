--!strict
--- Spanish dialogue for the auction bidder behind quest request 6.

local vm = require("@lib/vm")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/spanish/quest_dialogue")

local auction_bidder = {}

--- Starts the conversation with the auction bidder NPC, choosing the dialogue from the player character and the quest request status.
function auction_bidder.start_conversation(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.compare_player_to_elena(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.offer_help_with_problems(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_book_funds(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_villagers.lend_auction_money(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_book_servant_done(npc_character, player_character)
		return
	end
end

return auction_bidder
