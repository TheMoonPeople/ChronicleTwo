--!strict
--- Holds the Italian conversations of the villagers of Luna Lab.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local luna_lab_villagers = {}

--- Plays the conversation of the Luna Lab villager that was talked to, choosing the line by villager type and story flags.
function luna_lab_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local lab_visit_flag: s32 = 0
	local aquarium_done_flag: s32 = 0
	local aquarium_quest_flag: s32 = 0
	local aquarium_invention_status: s32 = 0
	local electric_fish_state: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local griffon_hint_flag: s32 = 0
	local elena_attack_flag: s32 = 0
	local playable_character: s32 = 0
	local current_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle_degrees: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	closing_mode = 0
	if villager_type == 300 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			lab_visit_flag = event.get_save_flag(456) or lab_visit_flag
			if lab_visit_flag == 0 then
				event.open_message_window_2(
					0,
					"Eh? Chi siete...?\nIl Laboratorio di Scienza Lunatica\n[UNI00e8] il miglior centro di ricerca<page>del mondo. Non [UNI00e8] ancora un\ngranch[UNI00e9], ma dovremmo riuscire\na terminare i nostri studi."
				)
			else
				event.open_message_window_2(
					0,
					"Le parole non possono descrivere\nla maestosit[UNI00e0] del Lab-Lunatica.\nDovete vederlo con i vostri occhi."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Se la questione Grifone non viene\nrisolta, la storia non torner[UNI00e0]\nmai com'era prima.<page>La sola esistenza di Grifone\naltera il corso della storia."
			)
		end
	end
	if villager_type == 301 then
		aquarium_done_flag = event.get_save_flag(420) or aquarium_done_flag
		if aquarium_done_flag == 0 then
			aquarium_quest_flag = event.get_save_flag(408) or aquarium_quest_flag
			if aquarium_quest_flag == 0 then
				event.open_message_window_2(0, "Haahn, shooo, haahn, shooo.")
				closing_mode = 2
			else
				aquarium_invention_status = event.is_invention_created(309) or aquarium_invention_status
				if aquarium_invention_status < 0 then
					event.open_message_window_2(
						0,
						"Ecco delle dritte per inventare un\nacquario: Una Scatola di Legno,\nuna Finestra e una Fontana. Puoi\ntrovarli in citt[UNI00e0], capito?"
					)
				else
					electric_fish_state = event.get_save_data_value(2) or electric_fish_state
					if electric_fish_state == 0 then
						event.open_message_window_2(
							0,
							"Prima, dai un \"Verme elettrico\"\na un pesce dell'acquario\nper elettrificarlo.<page>Poi, dai il pesce allo Shigura.\nTutto chiaro, 'sta volta?"
						)
					else
						event.open_message_window_2(
							0,
							"Ooh, hai il pesce, vero?\nDallo da mangiare allo Shigura!\nNon dovrebbe essere difficile, no?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"Bene! Sembra ce l'abbiate fatta!\nA quanto pare, la mia invenzione\n[UNI00e8] stata proprio utile, eh?"
			)
		end
	end
	if villager_type == 302 then
		event.open_message_window_2(0, "Che sia Osmond o il capo del\nlaboratorio, ce n'[UNI00e8] di matti qui!")
	end
	if villager_type == 303 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				griffon_hint_flag = event.get_save_flag(600) or griffon_hint_flag
				if griffon_hint_flag == 0 then
					elena_attack_flag = event.get_save_flag(448) or elena_attack_flag
					if elena_attack_flag == 0 then
						event.open_message_window_2(
							0,
							"Badate alla Radioconchiglia.\n[UNI00c8] tra le invenzioni pi[UNI00f9]\nimportanti del Lab-Lunatica."
						)
					else
						event.open_message_window_2(
							0,
							"Presto, muovetevi! Le truppe\ndi Grifone stanno raggiungendo\nElena: non resisteranno a lungo..."
						)
					end
				else
					event.open_message_window_2(0, "Mi chiedo che uomo sia\nquesto Grifone...")
				end
			else
				event.open_message_window_2(
					0,
					"Cercate le gemme? Sono cristalli\ndi saggezza, forgiati dagli antichi.<page>Secondo l'analisi del computer del\nLab-Lunatica,si trovano nascoste\nin quattro luoghi:"
				)
				cutscene.face_each_other(player_slot, villager_id, 0)
				message.say_bubble(0, -1, villager_id, player_slot, 0)
				closing_mode = 1
				event.open_message_window_2(
					0,
					"il Bosco Farfalla Arcobaleno, il\nCanyon Stellare, la Caverna \nRuggente e il Monte Gundor.<page>Un simbolo a forma di stella\ndovrebbe trovarsi ad ogni entrata,\nquindi fate attenzione."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Bene, [UNI00e8] ora di sistemare Grifone\nper sempre! Il destino del mondo [UNI00e8]\nnelle vostre mani. Buona fortuna!"
			)
		end
	end
	if villager_type == 304 then
		event.open_message_window_2(
			0,
			"In questo laboratorio, anche un\nragazzino, con le giuste qualit[UNI00e0],\npu[UNI00f2] diventare un pezzo grosso."
		)
	end
	if villager_type == 305 then
		event.open_message_window_2(
			0,
			"Le Pietre Luna, portate dagli\nShigura, ci liberano la mente per\nmeglio concentrarci sulla ricerca.<page>Ma non saprei dirti cosa siano\nesattamente queste Pietre Luna..."
		)
	end
	if villager_type == 306 then
		event.open_message_window_2(
			0,
			"Un laboratorio sull'oceano, niente\nmale, eh? Sapete quanto ho dovuto\nfaticare per avere un posto qui?"
		)
	end
	if villager_type == 307 then
		event.open_message_window_2(
			0,
			"Che ne pensate del progetto del\nLab-Lunatica? Chiss[UNI00e0] chi ha ideato\nil parco dei divertimenti..."
		)
	end
	if villager_type == 308 then
		event.open_message_window_2(
			0,
			"Un giorno dimostrer[UNI00f2] a tutti\nquanto sono in gamba! Sapete,\nqui si tratta solo di abilit[UNI00e0]."
		)
	end
	if villager_type == 309 then
		event.open_message_window_2(
			0,
			'Sapete, io rispetto molto il capo.\n[UNI00c8] da ammirare uno che scrive\nun best seller di 40 volumi,<page>"La Bibbia del Super\nScienziato,", a quell\'et[UNI00e0] poi!'
		)
	end
	if villager_type == 310 then
		event.open_message_window_2(
			0,
			"Io sono ancora un pivellino qui.\nSto imparando molto e un giorno\ndiventer[UNI00f2] un grande ricercatore."
		)
	end
	if villager_type == 311 then
		event.open_message_window_2(
			0,
			"La vista del mare da questo\nlaboratorio [UNI00e8] incredibile.<page>Laggi[UNI00f9] all'orizzonte,\nl'oscurit[UNI00e0] del mare e del cielo\nsi fondono in un tutt'uno."
		)
	end
	if villager_type == 312 then
		event.open_message_window_2(
			0,
			"Questo [UNI00e8] il Laboratorio Numero 2.<page>Nel Lab-Lunatica, ogni\nsingolo laboratorio ha\nla sua area di ricerca."
		)
	end
	if villager_type == 313 then
		event.open_message_window_2(
			0,
			"Al Lab-Lunatica, viene simulato\nun ambiente notturno che amplifica\nil potere delle Pietre Luna."
		)
	end
	if villager_type == 314 then
		event.open_message_window_2(
			0,
			"Quando iniziai a lavorare qui, non\nriuscivo neanch'io a distinguere i\nlaboratori. Questo pu[UNI00f2] aiutarvi:<page>il laboratorio 1 [UNI00e8] rosso, il 2 [UNI00e8]\nblu, il 3 [UNI00e8] viola e il 4 [UNI00e8] verde.\nUn colore per ogni laboratorio!"
		)
	end
	if villager_type == 315 then
		event.open_message_window_2(0, "L'emblema sul Laboratorio Centrale\nha la forma della luna.")
	end
	if villager_type == 316 then
		event.open_message_window_2(
			0,
			"Ho saputo che il Laboratorio [UNI00e8]\nstato terminato grazie alle Pietre\nLuna portate dal drago Shingala.<page>A quanto pare, alcuni draghi\nmarini sanno essere in gamba, eh?"
		)
	end
	if villager_type == 317 then
		event.open_message_window_2(
			0,
			"Non dirglielo, ma ne abbiamo fin<page>sopra i capelli delle cosiddette\nbattute di Osmond.\nSono cos[UNI00ec] irritanti!"
		)
	end
	if villager_type == 318 then
		event.open_message_window_2(
			0,
			"Ebbene s[UNI00ec]: anch'io ho contribuito\nalla ricerca sul Verme elettrico.\nOra seguo un altro progetto.<page>Ehi, non posso rivelare quale!\nTop secret! Mica posso andare a\nspifferarlo ai quattro venti!"
		)
	end
	if villager_type == 319 then
		event.open_message_window_2(
			0,
			"Cosa? Anche voi ragazzi volete\ndiventare dei ricercatori?<page>Non penserete mica che sia una\npasseggiata entrare qui?!\nLa competizione [UNI00e8] spietata."
		)
	end
	if villager_type == 320 then
		event.open_message_window_2(
			0,
			"Alcuni ricercatori criticano i\nprogetti qui al Lab-Lunatica.\nIn effetti non sono un granch[UNI00e9]...<page>Ad ogni modo, [UNI00e8] solo\nuna piccola minoranza."
		)
	end
	if villager_type == 321 then
		event.open_message_window_2(
			0,
			"Siamo nel mezzo di una riunione\nsu ricerche di massima segretezza.<page>Vi spiacerebbe lasciarci\nsoli un momento?"
		)
	end
	if villager_type == 322 then
		event.open_message_window_2(
			0,
			"Mi spiace molto, ma siamo nel\nmezzo di una riunione su\nricerche di massima segretezza.<page>Non possiamo andare avanti\ncon voi qui, quindi..."
		)
	end
	if villager_type == 323 then
		event.open_message_window_2(
			0,
			"Il Dottor Nobb [UNI00e8] un vero genio,\ncerto, ma [UNI00e8] anche un\ngran lavoratore.<page>Io impallidisco a confronto...\nUn vero albino direi..."
		)
	end
	if villager_type == 324 then
		event.open_message_window_2(
			0,
			"Sei tu? Ho sentito dire che hai\nlitigato con il Dottor Osmond.<page>Ehi! Non sto criticando, anzi! Le\nscoperte avvengono quando si mette\nin discussione qualcosa."
		)
	end
	if villager_type == 325 then
		event.open_message_window_2(
			0,
			"Dite di non riuscire ad abituarvi\nalla luce intensa?<page>Ritengo che per voi\nvisitatori dal passato\nci voglia del tempo per adattarsi."
		)
	end
	if villager_type == 326 then
		event.open_message_window_2(
			0,
			"Beh, sto riprendendo\nfiato un attimo.<page>Bisogna far riposare il cervello\ndi quando in quando, altrimenti\nsi d[UNI00e0] fuori di matto!"
		)
	end
	if villager_type == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"So che sei bravino come inventore.\nChe ne dici? Ti andrebbe di venire\na lavorare con noi da grande?<page>Per allora, il Lab-Lunatica sar[UNI00e0]\nstato appena terminato. La tua\ncollaborazione sar[UNI00e0] apprezzata."
			)
		else
			event.open_message_window_2(
				0,
				"Non credi che gli inventori\nsiano veramente affascinanti?<page>Beh, vedi di non innamorarti di\nme, intesi? La ricerca [UNI00e8] la mia\nvita. Non funzionerebbe mai."
			)
		end
	end
	if villager_type == 328 then
		event.open_message_window_2(
			0,
			"Ho avuto un'idea rivoluzionaria:\nun sistema che permette ai mostri\ndi vivere al fianco degli Umani.<page>Realizzer[UNI00f2] una macchina che\ncomprende il linguaggio umano."
		)
	end
	if villager_type == 329 then
		event.open_message_window_2(
			0,
			"Le Pietre Luna sono la spina\ndorsale del Lab-Lunatica.<page>Senza, tutto il nostro\nsistema si paralizzerebbe."
		)
	end
	if closing_mode == 0 then
		cutscene.talk(villager_id, -1, 0, 0)
	end
	if closing_mode == 1 then
		message.say_bubble(0, -1, villager_id, player_slot, 0)
		event.set_character_motion(villager_id, "立ち")
		event.finish_event()
	end
	if closing_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		current_player_slot = event.get_player_character_slot() or current_player_slot
		do
			local out1, _, out3 = event.get_character_position(current_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_id)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle_degrees = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle_degrees
		character.turn_to_angle(current_player_slot, look_angle_degrees)
		event.set_character_rotation(current_player_slot, 0.0, look_angle_degrees, 0.0)
		event.set_character_motion(current_player_slot, "立ち")
		message.say_bubble(0, -1, villager_id, current_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_id)
end

return luna_lab_villagers
