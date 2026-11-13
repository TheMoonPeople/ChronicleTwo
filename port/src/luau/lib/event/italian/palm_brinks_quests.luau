--!strict
--- Italian recruitment and request conversations of Palm Brinks NPCs.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local villager_recruitment = vm.module("@lib/event/italian/villager_recruitment")

local palm_brinks_quests = {}

--- Reads the stopwatch for the boat race and has the NPC join the party if the time is fast enough.
function palm_brinks_quests.check_boat_race_time(npc: s32, player: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local seconds_fraction: s32 = 0
	local is_fast_enough: s32 = 0
	local race_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		seconds_fraction = out3 or seconds_fraction
		is_fast_enough = out4 or is_fast_enough
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	race_state = event.get_save_counter(7) or race_state
	if race_state == 0 then
		event.open_message_window_2(0, "Ehi, Max.\nVieni a provarci di nuovo?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(0, "Ohi! Non sei arrivato alla barca,\nvero? Hai cercato di fregarmi.\nNon imbrogliare!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "Ehi, niente scherzi!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh, sei tornato!\nBene,<page>Controlliamo\nil tuo tempo!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, seconds_fraction)
	if is_fast_enough == 0 then
		event.open_message_window_2(0, "Oh mio Dio!\n[数値１] minuti [数値２].[数値３] secondi [UNI00e8]\ntroppo.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] minuti [数値２] secondi [数値３]\nnon [UNI00e8] niente male!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Sei pi[UNI00f9] veloce di quanto sembra.\nOK, combattiamo i cattivi insieme!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- Has the flower expert check the player has photographed any unusual flower and, if so, join the party.
function palm_brinks_quests.check_flower_photos(npc: s32, player: s32)
	local playable_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	photo_count_2009 = event.get_photo_count_of_subject(2009) or photo_count_2009
	photo_count_52 = event.get_photo_count_of_subject(52, 3) or photo_count_52
	photo_count_53 = event.get_photo_count_of_subject(53, 3) or photo_count_53
	photo_count_54 = event.get_photo_count_of_subject(54, 3) or photo_count_54
	photo_count_55 = event.get_photo_count_of_subject(55, 3) or photo_count_55
	if vm.i32(vm.i32(vm.i32(vm.i32(photo_count_2009 + photo_count_52) + photo_count_53) + photo_count_54) + photo_count_55) <= 0 then
		event.open_message_window_2(
			0,
			"Hai fotografato un fiore insolito?<page>So tutto sui fiori... se non [UNI00e8]\ndavvero speciale non mi interessa!"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hai fotografato un fiore insolito?\nVediamo, vediamo!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Wow! [UNI00c8] incredibile! Allora,\nsi trovano fiori cos[UNI00ec] l[UNI00e0] fuori!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Mmh... cosa dovrei fare?<page>Oh, va bene! Portatemi con voi!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Has the NPC pose the church-candle puzzle as the condition for joining the party and starts the candle request.
function palm_brinks_quests.explain_candle_puzzle(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Davvero? Hai bisogno di una mano?<page>Lascia che ti ponga un quesito.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Le candele nella chiesa sono\ngestite da un piccolo meccanismo.<page>Se sono accese le spegne\ne se sono spente le accende.<page>Se una di loro cambia,\nanche le candele accanto cambiano."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Se sarai cos[UNI00ec] saggio da spegnere\ntutte le candele, verr[UNI00f2] con te.<page>Se ci riesci, bene! Senn[UNI00f2], cerca\ndi capire: non posso aiutarti!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ecco un altro enigma. Fai\n   qualche tentativo e sfrutta\n   quel che apprendi ogni volta."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Se rientri in chiesa, le\n   candele tornano come prima.\n   Quindi non temere, se sbagli.\n   La risposta [UNI00e8] semplice."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Has Mena describe her dizziness and, for Monica, explain time distortions, record the cleared-stage count and start the distortion request.
function palm_brinks_quests.explain_time_distortions(npc: s32, player: s32)
	local playable_character: s32 = 0
	local cleared_stage_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Ultimamente, non mi sento in forma.<page>Non mi va di fare un viaggio.<page>Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Anche solo stare in piedi mi\nfa venire le vertigini.<page>[UNI00c8] difficile da spiegare. [UNI00c8] come\nse il mondo fosse deformato."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Mmh... se il Dottor Dell\nnon capisce di che si tratta,\nallora io non posso fare molto...")
		message.say_bubble(0, -1, player, npc, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ricordo quei sintomi.")
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Quando sono nata, il mondo\nera in pessimo stato, con molte\npi[UNI00f9] distorsioni temporali\ndi quanto voi possiate immaginare."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Di questo ne risentivano le\npersone pi[UNI00f9] deboli e fragili.<page>I pi[UNI00f9] esili lamentavano vertigini,\ni pi[UNI00f9] grossi non si reggevano in piedi."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Forse sei troppo sensibile\na questo genere di cose.<page>Senti persino le poche distorsioni\ntemporali che abbiamo qui!"
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(0, "Se eliminassimo le distorsioni pi[UNI00f9]\nvicine, forse staresti meglio.")
	message.say_bubble(0, -1, player, npc, 0)
	event.set_character_motion(player, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Eliminare distorsioni temporali, Spheda!\n   Se completi circa 10 livelli,\n   forse Mena star[UNI00e0] meglio."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	cleared_stage_count = event.get_menu_value_2(0) or cleared_stage_count
	event.set_save_counter(19, cleared_stage_count)
	event.set_quest_request(0, 17, 1)
end

--- Has a preoccupied NPC mutter guesses at a safe combination and shows a hint to come back later.
function palm_brinks_quests.mutter_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Mpfffff...")
	message.wait_facing_character(npc)
	event.open_message_window_2(0, "...1212,<page>No, no, era proprio 1122.<page>O forse 1010...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Mpfffff...")
	message.say_bubble(0, -1, npc, player, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Se non ti ha neppure sentito\n   dire "Salve." allora deve\n   avere dei problemi seri.<page>[(!)]Perch[UNI00e9] non provi pi[UNI00f9] tardi?\n   Potresti dargli una mano, o\n   un orecchio o qualcos\'altro.'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has Gerald hand over a Trumpet Gun and challenge the player to build it up into a Bell Trigger.
function palm_brinks_quests.offer_bell_trigger_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Secondo Cedric,\nhai combinato\nqualcosa di recente.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Sai fare un sacco di cose,<page>ma, a quanto pare, non\nconcludi molto.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Quindi, quando chiedi aiuto,\nper me [UNI00e8] difficile prenderti\nveramente sul serio.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Prova a potenziare questa Pistola-\ntrombetta in Pistola-campana?<page>Pensi di potercela fare?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(24)
	inventory.show_obtained_message_for_item_id(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Per farti accettare da\n   Gerald, devi portargli\n   una Pistola-campana.<page>[(!)]Puoi potenziare la tua arma,\n   comprarne una o\n   recuperarne una nei labirinti."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Has the coin collector take the Dark Coin and Indestructible Coin from the player and join the party.
function palm_brinks_quests.recruit_coin_collector(npc: s32, player: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"Come? Ah, la numismatica?<page>Sto cercando la Moneta oscura\ne la Moneta eterna.<page>Non le troverai mai. Le ho cercate\novunque, ma sono cos[UNI00ec] rare!"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Eh? Le hai trovate? Incredibile!<page>Forza! Dammele, dammele, dammele!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Bene.\nCosa devo fare?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Argh! Se mi fai perdere tempo,\nnon ti aiuter[UNI00f2] di certo.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, le ho tutte! E io che\npensavo fosse impossibile...<page>Bene, immagino di non avere\naltra scelta ora. Verr[UNI00f2] con te!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has Gordon ask Max for Holy Water to fix the tree and, once it is handed over, join the party.
function palm_brinks_quests.recruit_gordon(npc: s32, player: s32)
	local playable_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Max, sistemare quest'albero\n[UNI00e8] ci[UNI00f2] che mi preme di pi[UNI00f9].<page>Allora, per rimetterlo in sesto,\nmi serve..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, non funzioner[UNI00e0]...<page>Mi serve l'Acqua Sacra\ndi Don Bruno.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"S[UNI00ec]! Max, ce l'hai fatta! Ora\nposso prendermi cura dell'albero!<page>Ti ringrazio, Max."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Bene, sembra che abbia sbrigato\ntutte le mie faccende.<page>Ora posso seguirti\nnella tua avventura!<page>Oh, e mi raccomando, non parlare\na tuo padre dell'Acqua Sacra, OK?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon si [UNI00e8] unito al gruppo.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi sfruttare le sue capacit[UNI00e0]\n   con il comando Stato sotto\n   Personaggi, nel Menu principale.<page>[(!)]Se recluti qualcun altro\n   nella tua avventura, quella\n   persona salir[UNI00e0] sul treno."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Parla alla persona sul treno\n   per inserirla nel gruppo\n   come terzo membro.<page>[(!)]Per trasferire uno dei tuoi amici\n   in una casa, scegli Alloggia persone\n   dal Menu sulla porta della casa."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Molti altri potrebbero\n   voler venire con te.\n   Mi raccomando, cercali!")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Has Milane check that the player owns item 67 or 69 and, if so, join the party.
function palm_brinks_quests.recruit_milane(npc: s32, player: s32)
	local sword_67_count: s32 = 0
	local sword_69_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	sword_67_count = event.get_item_count(67) or sword_67_count
	sword_69_count = event.get_item_count(69) or sword_69_count
	if sword_67_count <= 0 and sword_69_count <= 0 then
		event.open_message_window_2(
			0,
			"Che razza di spada [UNI00e8] quella?\nMa allora erano solo chiacchiere?<page>Vattene!\nPerdo solo tempo con te."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wow, una spada\ndavvero impressionante!<page>Scusa se ti ho\nmesso alla prova.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Combattere con un principiante\n[UNI00e8] pericoloso anche per me.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ma immagino di non dovermi\npreoccupare di questo con te.<page>Bene, andiamo\na combattere!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

--- Has Polly ask about the bread delivery to Morton, then once the order is cancelled trade the 20 delivery loaves for 20 of item 299 and join the party.
function palm_brinks_quests.recruit_polly(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(0, "Mi spiace, non sono\nancora pronta.<page>Puoi concedermi\naltro tempo?")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "A proposito, hai gi[UNI00e0] fatto\nquella consegna a Morton?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Cosa! Come pu[UNI00f2] essere\ncos[UNI00ec] sconsiderato?<page>Oh, va bene:\nprendile tu.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Lascia perdere,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Has Rufio check the player has photographed the moon and, if so, join the party.
function palm_brinks_quests.recruit_rufio_with_moon_photo(npc: s32, player: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Pensavo tu fossi diverso,\ninvece no: gli Umani sono Umani.<page>Non importa. Ci sono abituato\na voi Umani: dite sempre bugie."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Fantastico! [UNI00c8] una foto della luna!<page>Ora potr[UNI00f2] portarla sempre con me!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Venire con te?<page>Certo!\nNon saprei dove altro andare!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

return palm_brinks_quests
