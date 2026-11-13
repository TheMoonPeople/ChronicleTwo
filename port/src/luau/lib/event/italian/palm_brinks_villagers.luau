--!strict
--- Dialogue and scripted conversations of the Palm Brinks townspeople in the Italian version of the game.

local vm = require("@lib/vm")
local cook = vm.module("@lib/event/italian/cook")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local party = vm.module("@lib/event/party")
local party_recruit = vm.module("@lib/event/italian/party_recruit")
local quest_dialogue = vm.module("@lib/event/italian/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/italian/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local palm_brinks_villagers = {}

--- Runs the request in which a villager asks for escalating sums of Gilda for an auction bid and returns 600 Gilda after winning it.
function palm_brinks_villagers.lend_auction_money(character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local handover_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	auction_stage = event.get_save_counter(9) or auction_stage
	money = event.get_money() or money
	if auction_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Questa cifra non mi permetter[UNI00e0]\ndi partecipare all'asta.<page>Ho bisogno di 1000 Gilda.\nCercate di non sbagliare!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(0, "Non ci crederete!<page>Il prezzo [UNI00e8] salito\na 1200 Gilda.")
			message.say_bubble(0, -1, character, player_character, 0)
			event.open_message_window_2(0, "Scusate tanto, vi dispiacerebbe\nprocurarmi 1500 Gilda?")
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nsar[UNI00e0] venduto a qualcun altro.<page>Portatemi 1500 Gilda, presto!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"[UNI00c8] terribile!\nQualcuno ha offerto 1800 Gilda!<page>Se non offro almeno 2000 Gilda,\nnon riuscir[UNI00f2] ad aggiudicarmelo."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nverr[UNI00e0] venduto a qualcun altro.<page>Portatemi 2000 Gilda, presto!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Figliolo, sei riuscito a\nracimolare i miei 2000 Gilda?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.set_character_motion(character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Che posso farci, [UNI00e8] tuo.\nPer[UNI00f2] che spreco!")
		handover_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if handover_choice ~= 0 then
			event.open_message_window_2(
				0,
				"Gi[UNI00e0], 2000 Gilda sono molti soldi.\nDev'essere duro separarsene.\nAnche per un damerino come te...<page>Va bene allora, non importa!\nMa l'asta non [UNI00e8] ancora finita.\nAspetter[UNI00f2] anche in eterno!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Grazie tante.<page>Andr[UNI00f2] subito all'asta!")
		message.say_bubble(0, -1, character, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, character)
		event.set_character_active(0, character)
		event.delete_villager(character)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Grazie tante.\nLa mia era l’offerta migliore.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Alzata l'offerta, si sono ritirati\ntutti: l'ho avuto per 1400 Gilda!")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Quindi posso ridarvene 600.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "E d'ora in poi, lavorer[UNI00f2] sodo per\nrestituirvi il resto del prestito.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "So di avervi messo nei guai.\nVi devo un favore.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Greets the shopkeeper that was talked to, then opens that shop's menu once the conversation ends.
function palm_brinks_villagers.open_shop_after_greeting()
	local npc_type: s32 = 0
	local npc_character: s32 = 0
	local baker_greeted: s32 = 0
	local weapon_shop_greeted: s32 = 0
	local priest_greeted: s32 = 0
	print("IN go_shop_up()\n")
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	npc_character = event.get_triggered_event_data_2(13) or npc_character
	print("talk_chara=", npc_type, "talk_chara_id=", npc_character, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Benvenuti.")
	if npc_type == 18 then
		event.open_message_window_2(
			0,
			"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
		)
	end
	if npc_type == 4 then
		event.open_message_window_2(
			0,
			"Si lavora sodo, vedo!\nTi serve qualcosa?<page>Per[UNI00f2], niente omaggi.\nNeanche per te, Max."
		)
	end
	if npc_type == 34 then
		event.open_message_window_2(
			0,
			"Vi servono altri elementi\nDiorama?<page>Se non avete tempo di cercarli\nda soli, i soldi potrebbero\nrisolvere i vostri problemi."
		)
	end
	if npc_type == 1012 then
		baker_greeted = event.get_save_flag(45) or baker_greeted
		if baker_greeted == 0 then
			event.open_message_window_2(
				0,
				"Salve. Sono apprendista fornaia.\nSostituisco Polly al forno\nquando non c'[UNI00e8].<page>Sono un po' nervosa, ma fa parte\nanche questo dell'apprendistato.\nFar[UNI00f2] del mio meglio!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_type == 1015 then
		weapon_shop_greeted = event.get_save_flag(46) or weapon_shop_greeted
		if weapon_shop_greeted == 0 then
			event.open_message_window_2(
				0,
				"Forse non ci somigliamo molto...\nMa sono la sorellina di Milane.<page>Mi ha lasciata qui a badare al\nnegozio, ma non mi intendo d'armi!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_type == 1018 then
		priest_greeted = event.get_save_flag(47) or priest_greeted
		if priest_greeted == 0 then
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
	if npc_character ~= -1 then
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_type == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_type == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_type == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_type == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_type == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_type == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_type == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_type == 1018 then
		menu.open_type_6_alt(37)
	end
end

--- Has the seamstress decline to join the party for lack of confidence and registers request 7 to restore it.
function palm_brinks_villagers.request_adel_confidence(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(
		0,
		"Capisco...vorrei\npotervi aiutare... davvero!\nPi[UNI00f9] di qualsiasi altra cosa.<page>Ma non ho alcuna\nfiducia in me stessa."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mi arrendo sempre a met[UNI00e0] strada e\nnon porto mai a termine nulla.<page>Da bambina, sognavo di fare la\nsarta, ma iniziavo sempre a fare\nvestiti, senza mai finirli."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Sono sicura che se venissi con\nvoi, sarei solo d'impaccio.<page>Quindi, mi spiace: dico di no."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh, Adel non ha fiducia in\n   s[UNI00e9], e non va bene. Facciamole\n   tornare la voglia di cucire!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Asks the player to find Chestnuts for the Castagnaccio sweet and registers the request.
function palm_brinks_villagers.request_chestnuts(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Ah, capitate a proposito!\nVolevo parlarvi di una cosa.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Sicuramente sapete che sto\npreparando dolci esotici da tutto\nil mondo, per la mia ricerca.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Pare che esista un dolce chiamato\nCastagnaccio.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "fatto con una certa Castagna.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Ho scoperto che la Castagna cresce\nsu alberi chiamati Castagni.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Pensavo di usare le Castagne,\nma stranamente...\nnon se ne trovano pi[UNI00f9] in citt[UNI00e0]!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Il Sindaco se le [UNI00e8] accaparrate tutte.\nNon [UNI00e8] che potreste darmi una mano?")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Poses the church candle puzzle to the player and registers request 13.
function palm_brinks_villagers.request_extinguish_candles(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Davvero? Hai bisogno di una mano?<page>Lascia che ti ponga un quesito.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Le candele nella chiesa sono\ngestite da un piccolo meccanismo.<page>Se sono accese le spegne\ne se sono spente le accende.<page>Se una di loro cambia,\nanche le candele accanto cambiano."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Se sarai cos[UNI00ec] saggio da spegnere\ntutte le candele, verr[UNI00f2] con te.<page>Se ci riesci, bene! Senn[UNI00f2], cerca\ndi capire: non posso aiutarti!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ecco un altro enigma. Fai\n   qualche tentativo e sfrutta\n   quel che apprendi ogni volta."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Se rientri in chiesa, le\n   candele tornano come prima.\n   Quindi non temere, se sbagli.\n   La risposta [UNI00e8] semplice."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Has the Scoop Memo villager review the player's Scoop Memos, announcing new scoops, and returns nonzero when a reward can be claimed.
function palm_brinks_villagers.review_scoop_memos(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local memo_count: s32 = 0
	local collected_scoops: s32 = 0
	local total_scoops: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Andresti a prendermi\nun Blocchetto Scoop?")
			if current_map == 22 then
				resume_step = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			collected_scoops = out1 or collected_scoops
			total_scoops = out2 or total_scoops
		end
		if collected_scoops == total_scoops then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Sembra non ci siano\naltri scoop.")
			if current_map == 22 then
				resume_step = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
			resume_step = 5
			return npc_chatter.explain_photography_scoops(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Ho trovato ancora [Numero1] scoop.")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(window, "Allora, amico! Non startene\nimpalato! Dove sono i tuoi scoop?")
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Wow! Hai ottenuto [Number1] scoop!\nSapevo che ce l'avevi nel sangue!")
		end
		if current_map == 22 then
			resume_step = 7
			message.say_bubble(window, -1, npc_character, player_character, 0)
		else
			resume_step = 8
			message.show(window, -1, 3, 256, 208)
		end
		resume_step = 9
		return npc_chatter.explain_photography_scoops(window)
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_step <= 9 then
			if resume_step <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_step <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Remarks on the player's trips out of town, or hands over to the girl's greeting when the playable character is the girl.
function palm_brinks_villagers.talk_about_leaving_town(character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Sei stato fuori citt[UNI00e0] ultimamente,\nvero Max?<page>Non negarlo.\nSo che [UNI00e8] cos[UNI00ec]!"
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the remark that Max is hardly ever seen since the player arrived.
function palm_brinks_villagers.talk_about_max_absence(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Da quando sei arrivata,\nnon ho pi[UNI00f9] visto Max.\nNon so cos'hai in mente, ma<page>spero tu non lo stia sfruttando."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the baker's remark about the girl travelling with Max, with a different line in chapter 8.
function palm_brinks_villagers.talk_baker_about_max(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Sei tu la ragazza che\ngira con Max ultimamente!<page>Riconosco un bravo ragazzo\nquando ne vedo uno."
		)
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Se solo fossi un po' pi[UNI00f9] giovane,\nnon me lo lascerei scappare!")
	else
		event.open_message_window_2(0, "Se mai ti venisse voglia\ndi pane, sai dove trovarmi.")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Plays the blade shopkeeper's remark about the shop's specialty.
function palm_brinks_villagers.talk_blade_shopkeeper(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Il mio negozio [UNI00e8] specializzato\nin lame.<page>Ho delle armi da fuoco,\nma in realt[UNI00e0] non sono\naffatto il mio genere."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the church candle puzzle giver from the progress of the main request chain and of request 13.
function palm_brinks_villagers.talk_candle_puzzle_giver(character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_extinguish_candles(character, player_character)
		return
	end
	if request_status == 1 then
		party_recruit.recruit_partner(character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(character, player_character)
		return
	end
end

--- Asks about discoveries and describes the villager's cooking experiments.
function palm_brinks_villagers.talk_cooking_experiments(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Hai fatto qualche nuova scoperta?<page>Sai, mentre tu fai esperimenti\nsu macchine e strumenti,\nio faccio esperimenti di cucina.<page>Ogni giorno provo dei\npiatti deliziosi, che nessuno\nha mai assaggiato prima."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the neighbour's reminder about sorting garbage, with a warning about Zelmite Mine in chapter 8.
function palm_brinks_villagers.talk_garbage_neighbor(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Differenzia sempre i rifiuti e\nportali fuori nei giorni giusti!")
	else
		event.open_message_window_2(
			0,
			"Detto tra noi, [UNI00e8] bene che tu\nsappia che la Miniera di Zelmite [UNI00e8]\npericolosa. Non fare sciocchezze."
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the hard-of-hearing villager's greeting asking the player to speak slowly.
function palm_brinks_villagers.talk_hard_of_hearing_villager(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Salve!\nSono un po' sorda, ultimamente.<page>Non riesco a capire cosa dici\nse non parli lentamente."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the villager's complaint that the town is too peaceful to find work.
function palm_brinks_villagers.talk_peaceful_town(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Questa citt[UNI00e0] [UNI00e8] troppo tranquilla,\nnon c'[UNI00e8] lavoro per me.<page>Non che mi lamenti,\neppure..."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the request 9 giver from the playable character, the character's position and the progress of request 9.
function palm_brinks_villagers.talk_request_9_giver(character: s32, player_character: s32)
	local playable_character: s32 = 0
	local request_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.chat_armed_women(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_peaceful_town(character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_chatter.talk_busy_with_materials(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 9) or request_status
	if request_status == 0 then
		npc_dialogue.explain_boat_run_test(character, player_character)
		return
	end
	if request_status == 1 then
		npc_dialogue.check_boat_run_time(character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_surprised_by_speed(character, player_character)
		return
	end
end

--- Plays the sword enthusiast's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_sword_fan(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Il bagliore di una spada\nben fatta [UNI00e8] cos[UNI00ec] accecante!<page>Ti toglie il fiato!"
		)
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Come si pu[UNI00f2] essere felici\nlucidando pietre?")
	else
		event.open_message_window_2(0, "Allora, novit[UNI00e0]? Hai gi[UNI00e0] incontrato\nqualche osso duro nella miniera?")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Starts the conversation with a villager by dispatching on the villager's character type to that villager's own dialogue.
function palm_brinks_villagers.talk_to_npc(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_type: s32 = 0
	local current_submap: s32 = 0
	local state_flag: s32 = 0
	local shop_or_scoop_choice: any = 0
	local friend_or_scoop_choice: any = 0
	local request_0_status: s32 = 0
	local request_8_status: s32 = 0
	local greeting_choice: any = 0
	local request_0_status_2: s32 = 0
	local request_10_status: s32 = 0
	local greeting_choice_2: any = 0
	local request_0_status_3: s32 = 0
	local request_13_status: s32 = 0
	local greeting_choice_3: any = 0
	local request_8_status_2: s32 = 0
	local playable_character: s32 = 0
	local greeting_choice_4: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	chapter = event.get_chapter() or chapter
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	event.get_current_map()
	current_submap = event.get_current_submap() or current_submap
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, npc_character)
	if npc_type == 3 then
		npc_dialogue.talk_to_gardener(npc_character, player_character)
	end
	if npc_type == 5 then
		npc_dialogue.talk_to_magical_artist(npc_character, player_character)
	end
	if npc_type == 4 then
		state_flag = event.get_save_flag(104) or state_flag
		if state_flag == 0 then
			event.open_message_window_2(0, "Fammi far compere\nIndaga per uno scoop")
			shop_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if shop_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if shop_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				palm_brinks_villagers.open_shop_after_greeting()
			end
		else
			event.open_message_window_2(0, "Benvenuto!\nIndaga per uno scoop")
			friend_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if friend_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if friend_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				villager_dialogue.talk_quest_2_villager(npc_character, player_character)
			end
		end
	end
	if npc_type == 7 then
		cook.start_conversation(npc_character, player_character)
	end
	if npc_type == 8 then
		villager_dialogue.talk_quest_4_villager(npc_character, player_character)
	end
	if npc_type == 10 then
		quest_dialogue.talk_book_servant(npc_character, player_character)
	end
	if npc_type == 11 then
		npc_dialogue.talk_to_adel(npc_character, player_character)
	end
	if npc_type == 12 then
		request_0_status = event.get_quest_request_status(0, 0) or request_0_status
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if request_0_status == 2 and request_8_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			greeting_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice == 1 then
				quest_dialogue.talk_baker(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_baker(npc_character, player_character)
		end
	end
	if npc_type == 14 then
		palm_brinks_villagers.talk_request_9_giver(npc_character, player_character)
	end
	if npc_type == 15 then
		request_0_status_2 = event.get_quest_request_status(0, 0) or request_0_status_2
		request_10_status = event.get_quest_request_status(0, 10) or request_10_status
		if request_0_status_2 == 2 and request_10_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			greeting_choice_2 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_2 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_2 == 1 then
				quest_dialogue.talk_swordsmith(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_swordsmith(npc_character, player_character)
		end
	end
	if npc_type == 16 then
		villager_dialogue.talk_quest_11_villager(npc_character, player_character)
	end
	if npc_type == 17 then
		npc_dialogue.talk_to_safe_owner(npc_character, player_character)
	end
	if npc_type == 18 then
		request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if request_0_status_3 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			greeting_choice_3 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_3 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_3 == 1 then
				palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 33 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
		end
	end
	if npc_type == 19 then
		quest_dialogue.talk_rufio(npc_character, player_character)
	end
	if npc_type == 20 then
		villager_dialogue.talk_quest_15_villager(npc_character, player_character)
	end
	if npc_type == 21 then
		npc_dialogue.talk_to_fisherman(npc_character, player_character)
	end
	if npc_type == 23 then
		npc_dialogue.talk_to_mena(npc_character, player_character)
	end
	if npc_type == 24 then
		quest_dialogue.talk_hide_and_seek_hider(npc_character, player_character)
	end
	if npc_type == 25 then
		quest_dialogue.talk_grandmother(npc_character, player_character)
	end
	if npc_type == 33 then
		request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_2 == 1 and playable_character == 0 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Fammi far compere\nSalve")
			greeting_choice_4 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_4 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_4 == 1 then
				quest_dialogue.talk_bread_delivery_recipient(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		palm_brinks_villagers.open_shop_after_greeting()
	end
	if npc_type == 1 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Ultimamente faccio fatica\na vedere le cose piccole.<page>Mmmh... sto\ninvecchiando...")
		else
			event.open_message_window_2(
				0,
				"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Se non tengo le mani\ncontinuamente occupate,\nvado fuori di testa!")
		else
			event.open_message_window_2(
				0,
				"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.open_message_window_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
			)
		else
			event.open_message_window_2(0, "Ti piace proprio\nl'avventura, eh?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.open_message_window_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc_character)
end

--- Starts the ordinary villager conversation when the talked-to character type is outside the special 100 to 1000 range.
function palm_brinks_villagers.talk_to_ordinary_villager()
	local npc_type: s32 = 0
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	if npc_type < 100 or 1000 < npc_type then
		npc_chatter.talk_to_villager()
	end
end

--- Plays a worried villager's remark about the player, with a prayer for the player's safety in chapter 8.
function palm_brinks_villagers.talk_worried_villager(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Che ne dici?<page>Dimmi la verit[UNI00e0]!")
	else
		event.open_message_window_2(0, "Pregher[UNI00f2] per la tua incolumit[UNI00e0]...")
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

return palm_brinks_villagers
