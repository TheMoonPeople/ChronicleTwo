--!strict
--- Holds the English shopkeeper greetings.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")

local shop_greeting = {}

--- Speaks the shopkeeper's greeting, introducing the stand-in clerks on first visit, then faces the player and opens the shop menu for that shopkeeper.
function shop_greeting.greet_and_open_shop()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	local baker_apprentice_intro_flag: s32 = 0
	local weapon_shop_intro_flag: s32 = 0
	local church_stand_in_intro_flag: s32 = 0
	print("IN go_shop_up()\n")
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	print("talk_chara=", npc_id, "talk_chara_id=", character_slot, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Welcome.")
	if npc_id == 18 then
		event.open_message_window_2(
			0,
			"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
		)
	end
	if npc_id == 4 then
		event.open_message_window_2(
			0,
			"Working hard, I see?\nYou need something?<page>No freebies, though.\nNot even for you, Max."
		)
	end
	if npc_id == 34 then
		event.open_message_window_2(
			0,
			"You need some more Georama\nelements?<page>If you don't have the time to\ncollect them yourself, maybe\nmoney can solve your problems."
		)
	end
	if npc_id == 1012 then
		baker_apprentice_intro_flag = event.get_save_flag(45) or baker_apprentice_intro_flag
		if baker_apprentice_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Hello. I'm a baker's apprentice.\nI'm handling the bakery while\nPolly's away.<page>I'm a little nervous, but this is\nall part of my training, I guess.\nI'll do my best!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_id == 1015 then
		weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
		if weapon_shop_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"We may not look very much alike...\nBut I'm Milane's little sister.<page>Milane made me watch the shop while she's away.\nI don't know the first thing about weapons!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_id == 1018 then
		church_stand_in_intro_flag = event.get_save_flag(47) or church_stand_in_intro_flag
		if church_stand_in_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Surprise you, did I? I guess anyone\nwould be surprised to see someone\nstanding here dressed like this.<page>I'm a good friend of Priest Bruno. I'm\nfilling in for him while he's away on a trip.\nSo, is there anything I can help you with?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
			)
		end
	end
	if character_slot ~= -1 then
		cutscene.talk(character_slot, -1, 0, 0)
	end
	if npc_id == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_id == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_id == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_id == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_id == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_id == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_id == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_id == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_id == 1018 then
		menu.open_type_6_alt(37)
	end
end

return shop_greeting
