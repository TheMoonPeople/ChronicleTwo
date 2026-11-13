--!strict
--- Spanish dialogue for the NPC that joins the party once the i01h07 map parts are cleared.

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
		event.open_message_window_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return party_recruit
