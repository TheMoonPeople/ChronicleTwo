--!strict
--- Holds the Italian shopkeeper greetings.

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
	event.open_message_window_2(0, "Benvenuti.")
	if npc_id == 18 then
		event.open_message_window_2(
			0,
			"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
		)
	end
	if npc_id == 4 then
		event.open_message_window_2(
			0,
			"Si lavora sodo, vedo!\nTi serve qualcosa?<page>Per[UNI00f2], niente omaggi.\nNeanche per te, Max."
		)
	end
	if npc_id == 34 then
		event.open_message_window_2(
			0,
			"Vi servono altri elementi\nDiorama?<page>Se non avete tempo di cercarli\nda soli, i soldi potrebbero\nrisolvere i vostri problemi."
		)
	end
	if npc_id == 1012 then
		baker_apprentice_intro_flag = event.get_save_flag(45) or baker_apprentice_intro_flag
		if baker_apprentice_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Salve. Sono apprendista fornaia.\nSostituisco Polly al forno\nquando non c'[UNI00e8].<page>Sono un po' nervosa, ma fa parte\nanche questo dell'apprendistato.\nFar[UNI00f2] del mio meglio!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_id == 1015 then
		weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
		if weapon_shop_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Forse non ci somigliamo molto...\nMa sono la sorellina di Milane.<page>Mi ha lasciata qui a badare al\nnegozio, ma non mi intendo d'armi!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_id == 1018 then
		church_stand_in_intro_flag = event.get_save_flag(47) or church_stand_in_intro_flag
		if church_stand_in_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Sorpreso, vero? Immagino chiunque\nrimarrebbe meravigliato nel vedere\nqualcuno vestito cos[UNI00ec].<page>Sostituisco il mio amico Don Bruno\nche [UNI00e8] in viaggio. Allora, posso\nesserti d'aiuto in qualche modo?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
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
