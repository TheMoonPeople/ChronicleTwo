--!strict
--- German dialogue for the NPC that joins the party once the i01h07 map parts are cleared.

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
		event.open_message_window_2(0, "Du scheinst noch nicht gut\ngenug zu sein.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Ich setze gro[UNI00df]e Hoffnungen in dich,\naber ich f[UNI00fc]rchte, momentan kann\nich dir nicht helfen."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Gut gemacht.\nWunderbar.<page>Du wirst meine Erwartungen\nsicher nicht entt[UNI00e4]uschen.<page>Ich hab's versprochen, nicht wahr?\nIch begleite dich."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return party_recruit
