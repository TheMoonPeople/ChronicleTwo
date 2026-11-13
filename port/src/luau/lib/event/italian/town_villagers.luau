--!strict
--- Holds the Italian conversations of the villagers living in the player's town.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local partner_talk = vm.module("@lib/event/italian/partner_talk")

local town_villagers = {}

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
function town_villagers.say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	local villager_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"Ora vivo qui,\nma sono preoccupato\nper Carbonero Uno.<page>Sar[UNI00f2] io a far funzionare\nil treno, proprio come\nai vecchi tempi."
				)
				villager_id = event.get_triggered_event_data_2(13) or villager_id
				cutscene.talk(villager_id, -1, 0, 0)
				event.open_message_window_2(
					window,
					"Borneo [UNI00e8] un po' dispotico,\nmentre Erik [UNI00e8] solo un ragazzo.<page>Per quelli come me, non c'[UNI00e8] altro\nche casa, lavoro, casa e ancora\nlavoro, tutti i giorni.<page>Ma cos[UNI00ec] [UNI00e8] la vita, eh..."
				)
			else
				event.open_message_window_2(window, "Come procede con Steve?")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "Non sopporto di restare in\ncasa a rigirarmi i pollici!")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"Fiori e piante crescono solo\nse ti prendi cura di loro. Non\ntrascurerei mai le mie piccole!"
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"Chiss[UNI00e0] se [UNI00e8] tutto a posto alla\nbase segreta. Vorrei chiedere\ndi controllare ma, sai, [UNI00e8] segreta."
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"Il viola [UNI00e8] un bel colore.\nHa un suo fascino avvolgente\ne un'oscurit[UNI00e0] brillante."
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "Andrei ovunque per\naiutare chi soffre!")
		end
		if villager_type == 7 then
			event.open_message_window_2(window, "Solo un vero chef riesce a\npreparare qualcosa di delizioso\novunque si trovi.")
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "Quando si tratta di case: pi[UNI00f9]\nsolide sono, meglio [UNI00e8], vero?")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"Le noci non sono niente male, ma\nquelle cose rosse erano ottime.\nMe ne porteresti ancora?"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"L'umidit[UNI00e0] [UNI00e8] il peggior nemico dei\nlibri. Non potrei sopportare di\nvivere vicino all'acqua."
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(
				window,
				"Non sono n[UNI00e9] belli n[UNI00e9] alla moda,\nma confeziono vestiti come\nnessun altro al mondo."
			)
		end
		if villager_type == 12 then
			event.open_message_window_2(window, "Posto nuovo, vita nuova.\nMi sento ringiovanita!")
		end
		if villager_type == 13 then
			event.open_message_window_2(window, "Voglio rompere in mille\npezzi qualcosa...\nnon importa cosa!")
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "Se trovi un nuovo mostro,\nvedi di riferirlo immediatamente.")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"Alcuni dicono che non [UNI00e8] cosa da\ndonne, ma alla spada non importa\nchi la impugna. Vinca il migliore!"
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "Questa casetta non [UNI00e8] niente male\nper tirar su una famiglia.")
		end
		if villager_type == 17 then
			event.open_message_window_2(window, "Mi chiedo se Morton sia in gamba.\nMi fa stare sulle spine...")
		end
		if villager_type == 18 then
			event.open_message_window_2(
				window,
				"Se c'[UNI00e8] una citt[UNI00e0] a cui serve una\nchiesa, sono il prete che fa per\nte. Devi solo farmelo sapere!"
			)
		end
		if villager_type == 19 then
			event.open_message_window_2(window, "Grazie ai miei nuovi amici,\nnon ho pi[UNI00f9] pensato alla\nluna ultimamente.")
		end
		if villager_type == 20 then
			event.open_message_window_2(
				window,
				"Altro luogo, altro pesce.\nDevi cambiare il tuo modo di\npensare per adattarti alla zona."
			)
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "Qui sembra perfetto per pescare.")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"Parn ha iniziato un altro ritratto\ndi donna. Dice che sar[UNI00e0]\nancora pi[UNI00f9] bella di me."
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(
				window,
				"Chiss[UNI00e0] perch[UNI00e9] gli insetti hanno\nun aspetto cos[UNI00ec] rivoltante..."
			)
		end
		if villager_type == 24 then
			event.open_message_window_2(
				window,
				"Puoi rendere la mia casa pi[UNI00f9]\ncarina? Sai, una casa non [UNI00e8] mai\nabbastanza carina!"
			)
		end
		if villager_type == 25 then
			event.open_message_window_2(window, "Non avrei mai immaginato di dover\ntraslocare alla mia et[UNI00e0]!")
		end
	else
		partner_talk.show_npc_remark(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
function town_villagers.talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	town_villagers.say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

return town_villagers
