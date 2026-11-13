--!strict
--- Holds the Italian villager small talk and post-request chatter events.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")

local npc_chatter = {}

--- Answers the photo shop menu choice with either a demand for more scoops or an explanation of how ideas and scoops set the Photography level.
function npc_chatter.explain_photography_scoops(window: s32)
	local talk_character_id: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local menu_status: s32 = 0
	local menu_selection: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_character_id = event.get_triggered_event_data_2(13) or talk_character_id
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		do
			local out1, out2 = event.get_menu_value_3(6)
			menu_status = out1 or menu_status
			menu_selection = out2 or menu_selection
		end
		if 0 < menu_status then
			return 1
		end
		if menu_selection == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Se non mi porti altri scoop,\nnon posso darti nulla!")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
		end
		if menu_selection == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Il numero di idee e di scoop\ndetermineranno il tuo Livello\nfotografico.<page>Salendo di livello, riceverai\nin premio altri oggetti magnifici."
			)
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_step <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, talk_character_id, player_slot, 0)
			end
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the angler small talk about his fishing hobby before any request.
function npc_chatter.talk_angler_intro(npc: s32, player: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Il mio hobby [UNI00e8] la pesca.<page>Vorrei prendere un Mardan Karayan!<page>Rispetto solo chi cattura pesci grossi."
	)
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the baker once she has joined the party.
function npc_chatter.talk_baker_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Forza Max,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	else
		event.open_message_window_2(0, "Se mai ti venisse voglia\ndi pane, sai dove trovarmi.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the servant after the book request is finished.
function npc_chatter.talk_book_servant_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Il libro?\nVeramente, non l'ho ancora letto.<page>Il solo averlo mi ha\ncomunque reso felice."
		)
	else
		event.open_message_window_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the book servant small talk addressed to Monica.
function npc_chatter.talk_book_servant_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Sar[UNI00f2] l'unico a pensarla cos[UNI00ec], ma\nqualcosa in te mi ricorda Elena.<page>Sei speciale rispetto agli altri\nabitanti di questa citt[UNI00e0]."
		)
	else
		event.open_message_window_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the villager too busy guarding important materials to talk.
function npc_chatter.talk_busy_with_materials(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Ehi, Max.\nMi spiace, sono un po'\npreso adesso.<page>Sto per entrare in possesso di\nmateriali essenziali alla\nsicurezza della citt[UNI00e0]."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Se non [UNI00e8] urgente, non\nsi pu[UNI00f2] aspettare fino a domani?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the gun fighter small talk addressed to Monica.
function npc_chatter.talk_gun_fighter_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Sei un'amica di Max?<page>Bene, attenta a quello che fai.")
	else
		event.open_message_window_2(
			0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who guards the Holy Water secret.
function npc_chatter.talk_holy_water_keeper(npc: s32, player: any)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.open_message_window_2(0, "Oh, salve, signorina.\nPosso fare qualcosa per lei?")
		else
			event.open_message_window_2(0, "Max, non fare parola a tuo padre\ndi quell'Acqua sacra, capito?")
		end
	else
		event.open_message_window_2(0, "Chiss[UNI00e0] quante piante l[UNI00e0] fuori,\nche non abbiamo ancora visto!")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the angler hoping to reach the winner podium.
function npc_chatter.talk_podium_hopeful(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Spero che un giorno salir[UNI00f2] anch'io\nsul podio del vincitore.")
	else
		event.open_message_window_2(0, "Vorrei solo che Fabio\ns'interessasse a qualcos'altro,\noltre che alla pesca.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who is excited about the Blackstone Railroad.
function npc_chatter.talk_railroad_fan(npc: s32, player: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc_dialogue.greet_monica_about_hair(npc, player)
			return
		end
		event.open_message_window_2(0, "Non andate in posti troppo\npericolosi!")
	else
		event.open_message_window_2(0, "Finalmente la Ferrovia Carbonero\n[UNI00e8] operativa in tutto il mondo.\nChe emozione!")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the swordsmith's small talk to Max, who remembers seeing her at the circus, differing by chapter.
function npc_chatter.talk_swordsmith_max(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Mi hai visto al circo?\nNiente male, vero?<page>Per me [UNI00e8] un hobby,\npi[UNI00f9] che un lavoro."
		)
	else
		event.open_message_window_2(0, "Allora, novit[UNI00e0]? Hai gi[UNI00e0] incontrato\nqualche osso duro nella miniera?")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the tailor's small talk to Monica, asking her not to put Max in danger, differing by chapter.
function npc_chatter.talk_tailor_monica(npc: s32, player: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Per favore smetti di cacciare Max\nin situazioni pericolose.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Se gli trovo anche solo un\ngraffio, te ne pentirai!")
	else
		event.open_message_window_2(0, "Pregher[UNI00f2] per la tua incolumit[UNI00e0]...")
	end
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the generic villager conversation selected by the villager, the chapter and the story flags.
function npc_chatter.talk_to_villager()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	local message_group: s32 = 0
	local message_page: s32 = 0
	local speaker_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local railway_running_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_character, "talk_chara=", villager_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, villager_id)
		message_group = out1 or message_group
		message_page = out2 or message_page
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		speaker_variant = 2
	else
		speaker_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_character)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if villager_id == 1012 or villager_id == 1015 or villager_id == 1018 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	if villager_id == 50 then
		event.open_message_window_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
		cutscene.talk_to_character(villager_character, -1, 0, 0)
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		railway_running_flag = event.get_save_flag(9) or railway_running_flag
		if villager_id == 2 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Dai un'occhiata qui! Difficile\ncredere che un tempo filava\nche era una bellezza, vero?<page>Proprio cos[UNI00ec]... molto tempo fa.<page>Il mio sogno [UNI00e8] di rifarci un bel\nviaggetto! Ecco perch[UNI00e9] cerco\ndi tenerlo in perfetta forma.<page>Cos[UNI00ec], appena possibile,\n"
				)
			else
				event.open_message_window_2(
					0,
					"Sai che devi fare esercizio tutti\ni giorni per restare in forma, no?\nLo stesso vale con le macchine."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 63 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Ehi salve, Max!\nLa ferrovia non funziona\nda parecchio tempo.<page>Ma io continuo a vigilare\nsulla stazione, tutti i giorni."
				)
			else
				event.open_message_window_2(
					0,
					"Il Sindaco si [UNI00e8] finalmente mosso:\nha fatto ripartire i treni.\nMa non sono aperti al pubblico!<page>Cavoli, non vedo l'ora di farci\nsalire gli abitanti della citt[UNI00e0]..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 65 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Ciao, Max. Sapevi che il\ncapostazione [UNI00e8] il mio pap[UNI00e0]?\nSorvegliamo la stazione insieme.<page>Aspettiamo che questa ferrovia\nriprenda a funzionare..."
				)
			else
				event.open_message_window_2(
					0,
					"Il treno funziona!\nMa ci vorr[UNI00e0] del tempo prima\nche la stazione torni com'era..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if villager_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Sono un ammiratore segreto\ndi Monica da tempo, ma\nnon la vedo da un po'.<page>Per questo non riesco a\nconcentrarmi sul lavoro!"
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(0, "Ehi, Max!\nSembra che Monica sia tornata.\nNe saranno tutti felici!")
				else
					event.open_message_window_2(0, "Monica! Dove sei stata?\nMi sei mancata tanto!")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Avevo appena trovato il coraggio\ndi parlare a Monica normalmente,\nquando [UNI00e8] scomparsa.<page>Dai, Max...\ndimmi dov'[UNI00e8]... ti prego!"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Monica [UNI00e8] tornata.\nCom'[UNI00e8] possibile?!?")
				else
					event.open_message_window_2(0, "Monica, sei tornata!\nCom'[UNI00e8] possibile?!?")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_page * 10)) + speaker_variant))
	cutscene.talk_to_character(villager_character, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_character)
end

--- Plays the gardener tending a sick tree, differing by playable character.
function npc_chatter.talk_tree_gardener(npc: s32, player: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.set_character_motion(player, "立ち")
		event.open_message_window_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
		message.say_bubble(0, -1, npc, player, 0)
	else
		event.open_message_window_2(
			0,
			"Oh, Max! Mi hai messo paura.\nStavo levando dei fastidiosi\nparassiti da quest'albero.<page>Non tutti gli alberi crescono bene\nda soli, sai. Alcuni, come questo,\nhanno bisogno di molte cure."
		)
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
end

return npc_chatter
