--!strict
--- Holds the Italian recruitment of the old woman villager into the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local npc_recruit = vm.module("@lib/event/italian/npc_recruit")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/italian/palm_brinks_quests")
local palm_brinks_talk = vm.module("@lib/event/italian/palm_brinks_talk")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/italian/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/italian/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_recruitment = {}

--- Prompts the player for the invitation phrase and recruits the old woman villager when it is entered correctly.
function villager_recruitment.ask_phrase_to_join(villager: s32, player_character: s32)
	local entry_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Che hai detto?<page>Puoi parlare pi[UNI00f9] lentamente?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Scrivi "Andiamo insieme."', "Andiamo insieme.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if entry_result == 0 then
		event.open_message_window_2(0, "Cosa stai blaterando?\nNon capisco...")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Un'avventura?\nSarebbe carino.<page>Ma a cosa pu[UNI00f2] servirti\nuna vecchia come me?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Runs the butler's rising auction bids, taking 2000 Gilda once the player pays and returning 600 after the successful bid.
function villager_recruitment.collect_auction_funds(villager: s32, player_character: s32)
	local bid_stage: s32 = 0
	local money: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	bid_stage = event.get_save_counter(9) or bid_stage
	money = event.get_money() or money
	if bid_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Questa cifra non mi permetter[UNI00e0]\ndi partecipare all'asta.<page>Ho bisogno di 1000 Gilda.\nCercate di non sbagliare!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(0, "Non ci crederete!<page>Il prezzo [UNI00e8] salito\na 1200 Gilda.")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.open_message_window_2(0, "Scusate tanto, vi dispiacerebbe\nprocurarmi 1500 Gilda?")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nsar[UNI00e0] venduto a qualcun altro.<page>Portatemi 1500 Gilda, presto!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"[UNI00c8] terribile!\nQualcuno ha offerto 1800 Gilda!<page>Se non offro almeno 2000 Gilda,\nnon riuscir[UNI00f2] ad aggiudicarmelo."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nverr[UNI00e0] venduto a qualcun altro.<page>Portatemi 2000 Gilda, presto!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Figliolo, sei riuscito a\nracimolare i miei 2000 Gilda?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Che posso farci, [UNI00e8] tuo.\nPer[UNI00f2] che spreco!")
		choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if choice ~= 0 then
			event.open_message_window_2(
				0,
				"Gi[UNI00e0], 2000 Gilda sono molti soldi.\nDev'essere duro separarsene.\nAnche per un damerino come te...<page>Va bene allora, non importa!\nMa l'asta non [UNI00e8] ancora finita.\nAspetter[UNI00f2] anche in eterno!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Grazie tante.<page>Andr[UNI00f2] subito all'asta!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Grazie tante.\nLa mia era l’offerta migliore.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Alzata l'offerta, si sono ritirati\ntutti: l'ho avuto per 1400 Gilda!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Quindi posso ridarvene 600.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "E d'ora in poi, lavorer[UNI00f2] sodo per\nrestituirvi il resto del prestito.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "So di avervi messo nei guai.\nVi devo un favore.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Plays the villager's reaction to being found hiding, sending them off to hide again on the first find and recruiting them on the second.
function villager_recruitment.finish_hide_and_seek(villager: s32, player_character: s32)
	local found_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	found_count = event.get_save_counter(11) or found_count
	if found_count < 1 then
		event.open_message_window_2(0, "Oh! Mi hai trovato!<page>Riesci a trovarmi un'altra volta?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		event.set_save_counter(11, found_count + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Mi hai trovato...<page>Sto cominciando a stufarmi ora.<page>Nascondersi [UNI00e8]\ndavvero noioso!<page>Oh bene! Allora, partiamo\nper la nostra avventura!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- Has the villager challenge the player to win the Fish Race Beginners' Class before agreeing to help.
function villager_recruitment.give_fish_race_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "I Firbit concedono\nfavori solo a chi [UNI00e8]\npi[UNI00f9] in gamba di loro.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "So il fatto mio quando\nsi tratta di pesci.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ho sentito dire che gli Umani\norganizzano un evento in cui\nfanno competere i loro pesci.<page>Se hai un pesce, perch[UNI00e9]\nnon cerchi di arrivare primo?<page>Se ci riesci, sapr[UNI00f2]\nche sei degno del mio aiuto."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sembra che parli della Corsa dei\n   Pesci. Prova a vincere la Categoria\n   Principianti! Poi forse ti aiuter[UNI00e0]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Has the villager hand Monica a Gladius and challenge her to build it up by two levels before Milane will join.
function villager_recruitment.give_gladius_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Tu sei Monica,\ngiusto?<page>Ho sentito dire che\nnon sei niente male con la spada.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ma le spade non sono\ngiocattoli, lo sai.<page>Devi pensare a\ncosa hai davanti.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Se potenzi una spada di 2 livelli,\nmi convincer[UNI00f2] del tuo talento!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Perch[UNI00e9] non cominci\ncon il Gladio?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.add_inventory_item(44)
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Se vuoi farti accettare da\n   Milane, dovrai potenziare il\n   Gladio di 2 livelli.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi anche comprare o trovare le armi.\n   L'importante [UNI00e8] procurarsene di\n   potenti, cos[UNI00ec] Milane ti aiuter[UNI00e0]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Has the villager challenge the player to catch a Nonky over 60 cm before agreeing to help.
function villager_recruitment.give_nonky_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Vuoi che ti faccia un favore?<page>Ascoltami bene prima.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ascolto solo quelli che rispetto.<page>E rispetto solo chi riesce a\nprendere pesci pi[UNI00f9] grossi di me."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Il pesce pi[UNI00f9] grande che ho preso\n[UNI00e8] stato un Nonky di 60 cm.<page>Sei sorpreso, eh?\nSe te la senti di sfidarmi,\nper me, quando vuoi!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sembra che l'unico modo di averlo\n   dalla tua sia pescare un Nonky\n   di pi[UNI00f9] di 60 cm. Dai, puoi farcela!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Comunque, prova un po' a pescare\n   nel lago di Vallecatini.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Plays the villager's worry about a tree and hints that Gordon must be spoken to first.
function villager_recruitment.hint_talk_to_gordon(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Pare che tu debba parlare con Gordon\n   per attirare la sua attenzione.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Recruits the villager if the church candles are all out, otherwise turns the player away.
function villager_recruitment.join_after_candle_puzzle(villager: s32, player_character: s32)
	local visible_candle_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	visible_candle_count = object.count_visible_map_parts()
	if 0 < visible_candle_count then
		event.open_message_window_2(0, "Sembra che tu non sia\nancora abbastanza bravo.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Nutro molte speranze per te nel\nfuturo, ma al momento, purtroppo,\nnon posso aiutarti.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ben fatto.\nMagnifico.<page>Sono certo che\nnon mi deluderai.<page>Te lo avevo promesso, no?\nVerr[UNI00f2] con te."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Gives the player one of three garments depending on which they already own, then recruits the tailor villager.
function villager_recruitment.receive_garment_and_join(villager: s32, player_character: s32)
	local item_id: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Ah, Max! Ho finito un indumento!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Non volevo sprecare i materiali\nche mi avete dato e che mi hanno\npermesso di arrivare fino in fondo."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Non sono del tutto convinta,\nma lo proveresti intanto?")
	message.say_bubble(0, -1, villager, player_character, 0)
	item_id = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		item_id = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			item_id = 260
		end
	end
	event.add_inventory_item(item_id)
	inventory.show_obtained_message_for_item_id(item_id, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ah, che bello aver\nportato qualcosa a termine!<page>Ora mi sento molto\npi[UNI00f9] sicura di me.<page>Far[UNI00f2] del mio meglio...\nPer favore, portatemi con voi!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Starts the old woman villager's recruitment conversation by asking for the invitation phrase.
function villager_recruitment.recruit_old_woman(villager_slot: s32, player_slot: s32)
	villager_recruitment.ask_phrase_to_join(villager_slot, player_slot)
end

--- Has the tailor villager decline to join because of lost confidence and hint that she should sew again.
function villager_recruitment.refuse_for_lack_of_confidence(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Capisco...vorrei\npotervi aiutare... davvero!\nPi[UNI00f9] di qualsiasi altra cosa.<page>Ma non ho alcuna\nfiducia in me stessa."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Mi arrendo sempre a met[UNI00e0] strada e\nnon porto mai a termine nulla.<page>Da bambina, sognavo di fare la\nsarta, ma iniziavo sempre a fare\nvestiti, senza mai finirli."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Sono sicura che se venissi con\nvoi, sarei solo d'impaccio.<page>Quindi, mi spiace: dico di no."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh, Adel non ha fiducia in\n   s[UNI00e9], e non va bene. Facciamole\n   tornare la voglia di cucire!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Has the villager decline to join and ask Max for a flower photo, or defers to Monica's version of the talk.
function villager_recruitment.refuse_until_flower_photo(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Io vorrei aiutarvi, ma lottare\nfa paura... e poi ci si sporca!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Non vorrei essere di peso a\nnessuno. Devo dirvi di no.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ma devono esserci molte cose\ninsolite fuori citt[UNI00e0].<page>Mi chiedo come siano gli alberi\ne quali fiori sboccino."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Se vedi un fiore interessante, gli\nfaresti una foto per me, Max?\nMi piacerebbe tanto vederlo."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Questa volta ha detto no ma, se le\n   mostrassi una foto di qualcosa\n   che le piace, forse cederebbe."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the distrustful villager decline to join and hint that a photo of the moon would win their trust.
function villager_recruitment.refuse_until_moon_photo(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "S[UNI00ec], venire con te non mi dispiace,\nma ci sar[UNI00e0] una luna l[UNI00e0]?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Davvero? Magari lo dici cos[UNI00ec] per\ndire. Gli Umani sono bugiardi!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Veramente, ho cambiato idea.\nAspetter[UNI00f2] qui che la luna sorga.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Sar[UNI00e0] per qualcosa accaduto\n   in passato, ma Rufio non\n   crede agli Umani.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Devi far s[UNI00ec] che Rufio ti creda.\n   Se gli dessi una foto della\n   luna, forse lo farebbe."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Plays the butler's request for money to bid on a rare book at auction.
function villager_recruitment.request_book_auction_funds(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Qualunque cosa vi serva, far[UNI00f2]\ndel mio meglio per aiutarvi.<page>Lasciate fare a me.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Non so se potete aiutarmi...<page>Comunque ascoltate.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Sono 30 anni che lavoro\nsodo in questa casa.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Il lavoro [UNI00e8] la mia vita, ma\nun hobby ce l’ho: la lettura.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "C'[UNI00e8] un libro raro e prezioso,\nora in vendita all'asta.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "La gente fa a botte per averlo.\nCredo che un'offerta di circa\n1000 Gilda possa bastare.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Non ho tanto denaro e, se lo\nchiedessi al padrone, andrebbe su tutte\nle furie e io dovrei andarmene."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Siete la mia unica speranza.<page>Ma questo non significa che se\nnon mi aiutate io non aiuter[UNI00f2] voi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Malgrado le sue parole, Stewart non vi\n   aiuter[UNI00e0] se non gli darete 1000 Gilda.\n   Bisogner[UNI00e0] racimolare soldi!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Plays the magical artist Parn's introduction and his request for Golden Paint, with a shorter version for Monica.
function villager_recruitment.request_golden_paint(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(villager, 0, 0)
		event.open_message_window_2(0, "Ciao.\nMonica, giusto?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, villager, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica non [UNI00e8] molto brava in queste\n   situazioni. Forse pu[UNI00f2] fare qualcosa,\n   forse no. Meglio riprovare come Max."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Ehi, Max!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, villager, 0)
	event.open_message_window_2(
		0,
		"Certo, ridi pure!\nLo so che [UNI00e8] strano!<page>Chi si innamorerebbe della\nragazza di un quadro?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ma io sono un artista magico e\nposso dar vita ai miei quadri.<page>I miei soggetti esistono davvero,\nescluse le creature viventi..."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Neanche un artista magico pu[UNI00f2]\nricreare la vita")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "In realt[UNI00e0] un modo c'[UNI00e8]: un Uovo\nd'Oro in un grande albero antico.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Pare che la sua Vernice oro dia\nvita a qualunque disegno.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Max, stai andando fuori\ncitt[UNI00e0], vero?<page>Mi prenderesti della Vernice oro?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Non mi aspetto che lo faccia gratis.<page>Se mi dai una mano, user[UNI00f2] i miei\nnuovi poteri per aiutarti."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un grande albero antico...\n   con un Uovo d'Oro! Dove diavolo\n   lo trovi un albero simile?!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Routes a triggered NPC talk to the villager conversation for NPC ids up to 34 and to the generic handler otherwise.
function villager_recruitment.route_npc_talk()
	local npc_id: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if npc_id <= 34 then
			resume_point = 1
			palm_brinks_talk.talk_to_villager(villager, player_character)
		else
			resume_point = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 11, with a separate talk for Monica.
function villager_recruitment.route_request_11_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_gun_fighter_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_mining_advice(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		palm_brinks_quests.offer_bell_trigger_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.check_owned_weapon(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_weapons(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 14.
function villager_recruitment.route_request_14_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_missing_moon(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_until_moon_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_rufio_with_moon_photo(villager, player_character)
		return
	end
	if quest_status == 2 then
		villager_dialogue.thank_for_moon_photo(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 15.
function villager_recruitment.route_request_15_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_chatter.talk_angler_intro(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		villager_recruitment.give_nonky_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.judge_nonky_catch(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_fishing_spots(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 1.
function villager_recruitment.route_request_1_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		villager_recruitment.request_golden_paint(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.receive_golden_paint(villager, player_character)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_about_painting(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 7 and the garment progress counter, with a separate talk for Monica.
function villager_recruitment.route_request_7_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local garment_stage: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_tailor_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 7) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_for_lack_of_confidence(villager, player_character)
		return
	end
	if quest_status == 1 then
		garment_stage = event.get_save_counter(8) or garment_stage
		if garment_stage == 0 then
			quest_dialogue.request_tailor_materials(villager, player_character)
		end
		if garment_stage == 1 then
			npc_dialogue.deliver_tailoring_materials(villager, player_character)
		end
		if garment_stage == 2 then
			villager_recruitment.receive_garment_and_join(villager, player_character)
		end
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_worried_villager(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 8, with a separate talk for Monica.
function villager_recruitment.route_request_8_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_baker_about_max(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_business_trust(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_recruit.request_bread_delivery(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_polly(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_baker_done(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 9, once the villager stands at their post, with a separate talk for Monica.
function villager_recruitment.route_request_9_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.chat_armed_women(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_peaceful_town(villager, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(villager)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_chatter.talk_busy_with_materials(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 9) or quest_status
	if quest_status == 0 then
		npc_dialogue.explain_boat_run_test(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_boat_race_time(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_surprised_by_speed(villager, player_character)
		return
	end
end

return villager_recruitment
