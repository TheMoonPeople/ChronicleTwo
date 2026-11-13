--!strict
--- Italian dialogue for the NPC that joins the party once the i01h07 map parts are cleared.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local party = vm.module("@lib/event/party")

local party_recruit = {}

--- Refuses to join while any of the 14 i01h07 map parts is still visible, otherwise accepts and joins the party.
function party_recruit.recruit_partner(npc_character: s32, player_character: s32)
	local visible_part_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	visible_part_count = object.count_visible_map_parts()
	if 0 < visible_part_count then
		event.open_message_window_2(0, "Sembra che tu non sia\nancora abbastanza bravo.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Nutro molte speranze per te nel\nfuturo, ma al momento, purtroppo,\nnon posso aiutarti.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ben fatto.\nMagnifico.<page>Sono certo che\nnon mi deluderai.<page>Te lo avevo promesso, no?\nVerr[UNI00f2] con te."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return party_recruit
