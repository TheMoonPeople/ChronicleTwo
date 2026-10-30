--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_83896a01 = require("@lib/event/helper_83896a01")

--- Helper function.
local function helper_beac909d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"Ora vivo qui,\nma sono preoccupato\nper Carbonero Uno.<page>Sar[UNI00f2] io a far funzionare\nil treno, proprio come\nai vecchi tempi."
				)
				var4 = event.get_triggered_event_data_2(13) or var4
				helper_1c04a0eb(var4, -1, 0, 0)
				event.open_message_window_2(
					arg0,
					"Borneo [UNI00e8] un po' dispotico,\nmentre Erik [UNI00e8] solo un ragazzo.<page>Per quelli come me, non c'[UNI00e8] altro\nche casa, lavoro, casa e ancora\nlavoro, tutti i giorni.<page>Ma cos[UNI00ec] [UNI00e8] la vita, eh..."
				)
			else
				event.open_message_window_2(arg0, "Come procede con Steve?")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "Non sopporto di restare in\ncasa a rigirarmi i pollici!")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"Fiori e piante crescono solo\nse ti prendi cura di loro. Non\ntrascurerei mai le mie piccole!"
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"Chiss[UNI00e0] se [UNI00e8] tutto a posto alla\nbase segreta. Vorrei chiedere\ndi controllare ma, sai, [UNI00e8] segreta."
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"Il viola [UNI00e8] un bel colore.\nHa un suo fascino avvolgente\ne un'oscurit[UNI00e0] brillante."
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "Andrei ovunque per\naiutare chi soffre!")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "Solo un vero chef riesce a\npreparare qualcosa di delizioso\novunque si trovi.")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "Quando si tratta di case: pi[UNI00f9]\nsolide sono, meglio [UNI00e8], vero?")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"Le noci non sono niente male, ma\nquelle cose rosse erano ottime.\nMe ne porteresti ancora?"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"L'umidit[UNI00e0] [UNI00e8] il peggior nemico dei\nlibri. Non potrei sopportare di\nvivere vicino all'acqua."
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(
				arg0,
				"Non sono n[UNI00e9] belli n[UNI00e9] alla moda,\nma confeziono vestiti come\nnessun altro al mondo."
			)
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "Posto nuovo, vita nuova.\nMi sento ringiovanita!")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "Voglio rompere in mille\npezzi qualcosa...\nnon importa cosa!")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "Se trovi un nuovo mostro,\nvedi di riferirlo immediatamente.")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"Alcuni dicono che non [UNI00e8] cosa da\ndonne, ma alla spada non importa\nchi la impugna. Vinca il migliore!"
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "Questa casetta non [UNI00e8] niente male\nper tirar su una famiglia.")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "Mi chiedo se Morton sia in gamba.\nMi fa stare sulle spine...")
		end
		if arg1 == 18 then
			event.open_message_window_2(
				arg0,
				"Se c'[UNI00e8] una citt[UNI00e0] a cui serve una\nchiesa, sono il prete che fa per\nte. Devi solo farmelo sapere!"
			)
		end
		if arg1 == 19 then
			event.open_message_window_2(arg0, "Grazie ai miei nuovi amici,\nnon ho pi[UNI00f9] pensato alla\nluna ultimamente.")
		end
		if arg1 == 20 then
			event.open_message_window_2(
				arg0,
				"Altro luogo, altro pesce.\nDevi cambiare il tuo modo di\npensare per adattarti alla zona."
			)
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "Qui sembra perfetto per pescare.")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"Parn ha iniziato un altro ritratto\ndi donna. Dice che sar[UNI00e0]\nancora pi[UNI00f9] bella di me."
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(
				arg0,
				"Chiss[UNI00e0] perch[UNI00e9] gli insetti hanno\nun aspetto cos[UNI00ec] rivoltante..."
			)
		end
		if arg1 == 24 then
			event.open_message_window_2(
				arg0,
				"Puoi rendere la mia casa pi[UNI00f9]\ncarina? Sai, una casa non [UNI00e8] mai\nabbastanza carina!"
			)
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "Non avrei mai immaginato di dover\ntraslocare alla mia et[UNI00e0]!")
		end
	else
		helper_83896a01(arg0, arg1)
	end
end

return helper_beac909d
