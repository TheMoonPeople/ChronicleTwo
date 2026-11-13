--!strict
--- Holds the Italian dialogue and events of the town residents who can join the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local object = vm.module("@lib/event/object")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local quest_dialogue = vm.module("@lib/event/italian/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/italian/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local npc_dialogue = {}

--- Has the villager greet Max or Monica by name and ask to be taken along on trips outside town.
function npc_dialogue.ask_to_join_party(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Oh, Max! Ho sentito dire che\nsei stato fuori citt[UNI00e0] ultimamente.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ho sentito dire che\nsei stata fuori citt[UNI00e0] ultimamente.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grandioso! Perch[UNI00e9] non\nmi porti con te?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays the hide-and-seek child's chatter, depending on the chapter.
function npc_dialogue.chat_about_hide_and_seek(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Nascondino [UNI00e8] un\ngioco da bambini.")
	else
		event.open_message_window_2(
			0,
			"Non mi freghi! Lo so che sei\nstato in giro a divertirti. Quando\nhai tempo, raccontami tutto!"
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter wondering why the speaker misses the moon.
function npc_dialogue.chat_about_missing_moon(npc_slot: s32, player_slot: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Perch[UNI00e9] mi manca tanto la luna?<page>Magari [UNI00e8] da l[UNI00ec] che\nvengo...")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter about handling weapons and rebuilding the world, depending on the chapter.
function npc_dialogue.chat_about_weapons(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Le armi non sono giocattoli.<page>Attento a come le usi o\nrischi di farti male.")
	else
		event.open_message_window_2(
			0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the prayer for world peace in chapter 8 and otherwise the remark that a good cause needs wisdom.
function npc_dialogue.chat_about_world_peace(npc_slot: s32, player_slot: s32)
	npc_dialogue.chat_prayer_for_peace(npc_slot, player_slot, 1)
end

--- Plays amazed praise for Max outside chapter 8 (deferring to a separate remark when Monica leads) and asks how the Zelmite hunt is going in chapter 8.
function npc_dialogue.chat_about_zelmite_hunt(npc_slot: s32, player_slot: s32)
	local chapter: s32 = 0
	local active_character: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		active_character = event.get_playable_character() or active_character
		if active_character == 1 then
			palm_brinks_villagers.talk_about_max_absence(npc_slot, player_slot)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(0, "Incredibile! Non pensavo che\nsaresti riuscito a trovarle.<page>Niente male, Max!")
	else
		event.open_message_window_2(
			0,
			"Ehi! Come procede la ricerca di\nZelmite? Se c'[UNI00e8] qualcosa che\nposso fare, fammi un fischio."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Has the villager dislike women wielding swords and praise ladylike women, with an offer of help in the final chapter.
function npc_dialogue.chat_armed_women(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Non mi piace vedere una donna\ncon una spada in mano.<page>Le donne migliori sono aggraziate.\nPrendi Adel, per esempio."
		)
	else
		event.open_message_window_2(0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager talk about becoming the world's best chef, with a different line once the story reaches the final chapter.
function npc_dialogue.chat_aspiring_chef(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Certo che non vi rifiuterei\nmai niente.")
	else
		event.open_message_window_2(
			0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager stress that a customer's trust matters in business.
function npc_dialogue.chat_business_trust(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] fondamentale negli affari\navere la fiducia dei tuoi clienti.<page>Non devi mai darla\nper scontata!"
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager complain of feeling unwell although the doctor finds nothing wrong.
function npc_dialogue.chat_feeling_unwell(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Ultimamente, non mi sento in forma.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene.<page>Strano, eh?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager explain that Firbits only grant favors to those who are cleverer than them.
function npc_dialogue.chat_firbit_favors(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "I Firbit concedono\nfavori solo a chi [UNI00e8]\npi[UNI00f9] in gamba di loro.")
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager ask for the player's fishing tricks and look forward to new fishing spots, with a different line in the final chapter.
function npc_dialogue.chat_fishing_spots(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Um, magari non subito, per[UNI00f2] un\ngiorno potresti svelarmi\ni tuoi trucchetti di pesca!"
		)
	else
		event.open_message_window_2(
			0,
			"Non vedo l'ora di scovare i luoghi\nmigliori per pescare in giro\nper il mondo. Sar[UNI00e0] divertente!"
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager advise the player to learn the basics of mining.
function npc_dialogue.chat_mining_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Sei in gamba con le macchine,\nma non credi sia giunto il momento\nd'imparare qualcosa sulle miniere?"
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager mutter number sequences while ignoring the player, then shows a hint to come back later.
function npc_dialogue.chat_muttering_numbers(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Mpfffff...")
	message.wait_facing_character(npc_character)
	event.open_message_window_2(0, "...1212,<page>No, no, era proprio 1122.<page>O forse 1010...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mpfffff...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Se non ti ha neppure sentito\n   dire "Salve." allora deve\n   avere dei problemi seri.<page>[(!)]Perch[UNI00e9] non provi pi[UNI00f9] tardi?\n   Potresti dargli una mano, o\n   un orecchio o qualcos\'altro.'
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has the old woman wonder what use she could be and wish to see the Ends of the Earth, depending on the chapter.
function npc_dialogue.chat_old_woman_ends_of_earth(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "A cosa pu[UNI00f2] servirti una\ndonna anziana come me?")
	else
		event.open_message_window_2(
			0,
			'Quando la Ferrovia Carbonero sar[UNI00e0]\nterminata, mi piacerebbe tanto\nandare ai "Confini della Terra".'
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager pray for world peace or speak of wisdom, depending on the chapter and whether the villager's own request is completed.
function npc_dialogue.chat_prayer_for_peace(npc_character: s32, player_character: any, request_completed: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if request_completed ~= 0 and chapter == 8 then
		event.open_message_window_2(0, "Prego che ci sia sempre\nla pace nel mondo.")
	else
		event.open_message_window_2(0, "Se combatti per una giusta causa,\ndevi possedere la saggezza.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the maid say she dreams of becoming a seamstress although dreams rarely come true.
function npc_dialogue.chat_seamstress_dream(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Lavoro qui come domestica,\nma sin da bambina avevo\nun sogno: diventare sarta!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "I sogni non diventano mai realt[UNI00e0],\necco perch[UNI00e9] si chiamano sogni.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager say the shop is closed and direct the player to the family shop up the stairs.
function npc_dialogue.chat_shop_closed(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Il negozio [UNI00e8] chiuso. Dovrai andare\nin quello del mio vecchio.<page>Cerca le zucche, non puoi sbagliare!\n[UNI00c8] proprio in cima a quella scala."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager admit surprise at how fast the player is, with an offer of help in the final chapter.
function npc_dialogue.chat_surprised_by_speed(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Sei molto pi[UNI00f9] veloce\ndi quanto pensassi.\nMi hai sorpreso!")
	else
		event.open_message_window_2(0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Checks the stopwatch time of the player's run to the boat and recruits the villager when it beats the record.
function npc_dialogue.check_boat_run_time(npc_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local hundredths: s32 = 0
	local beat_record: s32 = 0
	local run_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		hundredths = out3 or hundredths
		beat_record = out4 or beat_record
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	run_state = event.get_save_counter(7) or run_state
	if run_state == 0 then
		event.open_message_window_2(0, "Ehi, Max.\nVieni a provarci di nuovo?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if run_state == 1 then
		event.open_message_window_2(0, "Ohi! Non sei arrivato alla barca,\nvero? Hai cercato di fregarmi.\nNon imbrogliare!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "Ehi, niente scherzi!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh, sei tornato!\nBene,<page>Controlliamo\nil tuo tempo!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, hundredths)
	if beat_record == 0 then
		event.open_message_window_2(0, "Oh mio Dio!\n[数値１] minuti [数値２].[数値３] secondi [UNI00e8]\ntroppo.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] minuti [数値２] secondi [数値３]\nnon [UNI00e8] niente male!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Sei pi[UNI00f9] veloce di quanto sembra.\nOK, combattiamo i cattivi insieme!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- The baker checks whether the bread delivery to Morton is done, trades the 20 loaves for 20 of another item and joins the party.
function npc_dialogue.complete_baker_request(npc_slot: s32, player_slot: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(0, "Mi spiace, non sono\nancora pronta.<page>Puoi concedermi\naltro tempo?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "A proposito, hai gi[UNI00e0] fatto\nquella consegna a Morton?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Cosa! Come pu[UNI00f2] essere\ncos[UNI00ec] sconsiderato?<page>Oh, va bene:\nprendile tu.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Lascia perdere,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Greets Monica with the hair greeting when she leads, otherwise checks Max's flower photos, then praises them and joins the party or asks to see an unusual flower.
function npc_dialogue.complete_flower_photo_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
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
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hai fotografato un fiore insolito?\nVediamo, vediamo!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Wow! [UNI00c8] incredibile! Allora,\nsi trovano fiori cos[UNI00ec] l[UNI00e0] fuori!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Mmh... cosa dovrei fare?<page>Oh, va bene! Portatemi con voi!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Gordon asks Max for Holy Water to fix the tree, joins the party, explains party and train management and completes request 0.
function npc_dialogue.complete_gordon_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.hint_talk_to_gordon(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Max, sistemare quest'albero\n[UNI00e8] ci[UNI00f2] che mi preme di pi[UNI00f9].<page>Allora, per rimetterlo in sesto,\nmi serve..."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, non funzioner[UNI00e0]...<page>Mi serve l'Acqua Sacra\ndi Don Bruno.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"S[UNI00ec]! Max, ce l'hai fatta! Ora\nposso prendermi cura dell'albero!<page>Ti ringrazio, Max."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Bene, sembra che abbia sbrigato\ntutte le mie faccende.<page>Ora posso seguirti\nnella tua avventura!<page>Oh, e mi raccomando, non parlare\na tuo padre dell'Acqua Sacra, OK?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon si [UNI00e8] unito al gruppo.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi sfruttare le sue capacit[UNI00e0]\n   con il comando Stato sotto\n   Personaggi, nel Menu principale.<page>[(!)]Se recluti qualcun altro\n   nella tua avventura, quella\n   persona salir[UNI00e0] sul treno."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Parla alla persona sul treno\n   per inserirla nel gruppo\n   come terzo membro.<page>[(!)]Per trasferire uno dei tuoi amici\n   in una casa, scegli Alloggia persone\n   dal Menu sulla porta della casa."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Molti altri potrebbero\n   voler venire con te.\n   Mi raccomando, cercali!")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Mena reports whether enough stages were cleared since request 17 began and joins the party once ten were cleared.
function npc_dialogue.complete_mena_request(npc_slot: s32, player_slot: s32)
	local current_clear_count: s32 = 0
	local start_clear_count: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		checkpoint = 1
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		current_clear_count = event.get_menu_value_2(0) or current_clear_count
		start_clear_count = event.get_save_counter(19) or start_clear_count
		print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", vm.i32(current_clear_count - start_clear_count), "\n")
		if vm.i32(current_clear_count - start_clear_count) < 10 then
			event.open_message_window_2(0, "Ancora non mi sento bene.")
			checkpoint = 2
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.open_message_window_2(
				0,
				"Sar[UNI00e0] qualcosa\ndi grave?<page>Forse neppure il Dottor Dell\npu[UNI00f2] aiutarmi ormai..."
			)
			checkpoint = 3
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.set_character_motion(npc_slot, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Salve!<page>Come mi sento? Benissimo!")
		checkpoint = 4
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "[UNI00c8] incredibile, sto molto meglio.<page>Il mondo [UNI00e8] tornato a posto.")
		checkpoint = 5
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Oh s[UNI00ec], volevate un favore...<page>Far[UNI00f2] il possibile per aiutarvi.<page>Voi mi avete aiutato,\nquindi io aiuter[UNI00f2] voi."
		)
		checkpoint = 6
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		checkpoint = 7
		party.add_talked_npc()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", current_clear_count - start_clear_count, "\n")
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 2 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			return 0
		end
		if checkpoint <= 7 then
			if checkpoint <= 4 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 5 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Parn takes the Golden Paint from Max, joins the party and completes request 1.
function npc_dialogue.complete_parn_request(npc_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Ti stavo aspettando.<page>Forza, dammi la Vernice, cos[UNI00ec]\nposso dar vita al mio quadro!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(0, "Starai scherzando!<page>Mi serve la Vernice oro.\nNon sbagliare!")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Cos[UNI00ec] [UNI00e8] questa la Vernice oro...\nLa provo subito.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Lei, lei... [UNI00e8] vera...<page>Incredibile, [UNI00e8] perfetta!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Grazie, Max. Non ho dimenticato\nla mia promessa. Usa pure il\nmio nuovo potere quando vuoi!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.set_npc_party_status(22, 130)
	party.announce_member_joined(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Walks through the safe's secret code puzzle, tests the code Max enters and joins the party once the safe opens.
function npc_dialogue.complete_safe_code_request(npc_slot: s32, player_slot: s32)
	local selection: any = 0
	local code_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_y: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local angle_toward_safe: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	while true do
		event.open_message_window_2(0, "Tempo fa, le regalai una spilla\ncon il suo segno zodiacale.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Holly se ne era occupata per me.\nNon ricordo bene, ma son certo\nche fosse un animale a 4 zampe..."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Che regali le ho fatto?<page>Mmh... molte giacche\ne sciarpe, credo.<page>Non so mai cosa prenderle.\nOgni anno [UNI00e8] una tragedia!"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Il compleanno di Claire [UNI00e8] sempre un\ndramma! [UNI00c8] il giorno in cui c’[UNI00e8] la\nraccolta dei rifiuti combustibili e non.<page>A casa nostra [UNI00e8] compito mio\nportar fuori la spazzatura."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"I rifiuti non combustibili vengono\nraccolti i giorni divisibili per 7<page>e quelli combustibili\nnei giorni divisibili per 3."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Ma tu non lo scorderesti,\nvero?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.open_message_window_2(
			0,
			"Trovato! Mistero svelato!\nLa combinazione [UNI00e8]...<page>Non so... Stiamo ad ascoltare..."
		)
		selection = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if selection == 0 then
			break
		else
			if selection == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_slot, "会話")
		end
	end
	event.set_menu_value(0, "Inserisci il codice segreto.", "2112", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		code_result = out1 or code_result
	end
	if code_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_y = out2 or npc_rotation_y
		npc_rotation_z = out3 or npc_rotation_z
	end
	event.set_character_position(npc_slot, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_slot, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_slot, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_y = out2 or player_rotation_y
		player_rotation_z = out3 or player_rotation_z
	end
	angle_toward_safe = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or angle_toward_safe
	event.set_character_rotation(0, 0.0, angle_toward_safe, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if code_result == 0 then
		event.set_character_motion(npc_slot, "会話")
		event.open_message_window_2(0, "Mmh, non si apre. Oh cielo...<page>Ci sono documenti\nimportanti l[UNI00ec] dentro...")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
		event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
		event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Er...Mmh...\n2,<page>1,<page>1,<page>2...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Evviva!<page>Grandioso,\nfunziona!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.attach_object_handle_to_character(0, npc_slot)
	event.clear_object_sequence(0, npc_slot)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Bene! Ora posso prendere\ni miei documenti importanti!<page>Oh, grazie!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
	event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(
		0,
		"Quali documenti importanti?<page>Serviranno al Vicesindaco Morton\nper sostituirmi quando sar[UNI00f2] via.<page>Sono un po’ in pensiero,\nma sento che andr[UNI00e0] tutto bene."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Sono pronto anch’io a lasciare la<page>citt[UNI00e0]. Cedric mi ha detto tutto.<page>Forza, andiamo."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Takes sturdy cloth, thick hide and a copper lump from the player so the seamstress can start making clothes, then removes her from the scene.
function npc_dialogue.deliver_tailoring_materials(npc_character: s32, player_character: s32)
	local sturdy_cloth_count: s32 = 0
	local thick_hide_count: s32 = 0
	local copper_lump_count: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	sturdy_cloth_count = event.get_item_count(214) or sturdy_cloth_count
	thick_hide_count = event.get_item_count(245) or thick_hide_count
	copper_lump_count = event.get_item_count(227) or copper_lump_count
	if sturdy_cloth_count <= 0 or thick_hide_count <= 0 or copper_lump_count <= 0 then
		event.open_message_window_2(
			0,
			"Senza materiali,\nnon posso fare nulla.<page>Mi servono: Stoffa robusta,\nCuoio spesso e un Pezzo di Rame.<page>Mi spiace\nessere di peso!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Ecco, prendi questi!\nChe spreco per[UNI00f2]!")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Senza materiali,\nnon posso fare nulla.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(
		0,
		"Grazie di cuore!\nOra prover[UNI00f2] a fare dei vestiti!<page>Niente di questo andr[UNI00e0] sprecato!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.finish_event()
	event.fade_in_screen(30)
end

--- Has the villager explain the speed test of running to the boat and back, then offers an attempt.
function npc_dialogue.explain_boat_run_test(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Ehi Max, sei venuto a cercare me?<page>Ti stavo aspettando.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Grazie alle mura del castello,\nquesta citt[UNI00e0] [UNI00e8] abbastanza sicura.<page>[UNI00c8] giunto il momento di uscire."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] un bene che tu stia sempre\nad armeggiare con le macchine,\nma mi chiedo quanto forte tu sia."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Combattere significa velocit[UNI00e0]\ne lavoro di gambe.<page>Se sei pi[UNI00f9] lento di me,\nnon va affatto bene."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Facciamo una prova! Corri alla\nbarca sul lago e torna indietro.<page>Il mio record [UNI00e8] 2 minuti e\n1 secondo. Se non lo superi,\nnon va affatto bene."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "Che ne dici, vuoi provare?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	npc_dialogue.offer_boat_run(npc_character, player_character)
end

--- Has the moon-loving villager say a moon must exist where the player goes and explain that a photo of the moon would convince him.
function npc_dialogue.explain_moon_photo_condition(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "S[UNI00ec], venire con te non mi dispiace,\nma ci sar[UNI00e0] una luna l[UNI00e0]?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Davvero? Magari lo dici cos[UNI00ec] per\ndire. Gli Umani sono bugiardi!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Veramente, ho cambiato idea.\nAspetter[UNI00f2] qui che la luna sorga.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Sar[UNI00e0] per qualcosa accaduto\n   in passato, ma Rufio non\n   crede agli Umani.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Devi far s[UNI00ec] che Rufio ti creda.\n   Se gli dessi una foto della\n   luna, forse lo farebbe."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Greets Monica as Max's girlfriend and compliments her hair.
function npc_dialogue.greet_monica_about_hair(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Ciao! Sei la fidanzata\ndi Max?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Hai i capelli di un colore strano.\nCome quelli di Erik, ma diversi...<page>I tuoi sono veramente belli:\nbrillano come gioielli!"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.finish_event()
end

--- Plays the remark about the ailing tree and the hint that Monica must talk to Gordon to get his attention.
function npc_dialogue.hint_talk_to_gordon(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_slot, "立ち")
	event.open_message_window_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Pare che tu debba parlare con Gordon\n   per attirare la sua attenzione.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Asks whether the player wants to try the boat run and starts the stopwatch when accepted.
function npc_dialogue.offer_boat_run(npc_character: s32, player_character: s32)
	local answer: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Certo, ci prover[UNI00f2].\nNon me la sento.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "OK...<page>OK, se vuoi riprovarci pi[UNI00f9] avanti,\nfammelo sapere. Ti aspetto.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "Pronti, partenza,\nvia!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

--- Checks whether the player has won the fish race and recruits the fish keeper if so.
function npc_dialogue.recruit_after_fish_race(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	story_flag = event.get_save_flag(41) or story_flag
	if story_flag == 0 then
		event.open_message_window_2(0, "Un pesce rispecchia il padrone.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Non parler[UNI00f2] mai col padrone \ndi un pesce tanto imbranato!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Stavo guardando, sai.\n[UNI00c8] stata una bella corsa.<page>Non avrei mai potuto allevare\nun pesce simile!<page>Ti prego, portami con te.\nTi prego, insegnami quel che sai!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Counts how often the hiding villager is found and recruits the villager once the game of hide-and-seek is over.
function npc_dialogue.recruit_after_hide_and_seek(npc_character: s32, player_character: s32)
	local times_found: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	times_found = event.get_save_counter(11) or times_found
	if times_found < 1 then
		event.open_message_window_2(0, "Oh! Mi hai trovato!<page>Riesci a trovarmi un'altra volta?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, times_found + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, npc_character)
		event.set_character_active(0, npc_character)
		event.delete_villager(npc_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Mi hai trovato...<page>Sto cominciando a stufarmi ora.<page>Nascondersi [UNI00e8]\ndavvero noioso!<page>Oh bene! Allora, partiamo\nper la nostra avventura!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- The hard-of-hearing grandmother starts request 19, asks Max to enter "Let's go together." and joins the party when he does.
function npc_dialogue.recruit_grandmother(npc_slot: s32, player_slot: s32)
	npc_dialogue.recruit_hard_of_hearing_woman(npc_slot, player_slot)
end

--- Asks the hard-of-hearing old woman to join through a "go together" menu choice and recruits her on the right answer.
function npc_dialogue.recruit_hard_of_hearing_woman(npc_character: s32, player_character: s32)
	local menu_selection: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Che hai detto?<page>Puoi parlare pi[UNI00f9] lentamente?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Scrivi "Andiamo insieme."', "Andiamo insieme.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		menu_selection = out1 or menu_selection
	end
	if menu_selection == -1 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if menu_selection == 0 then
		event.open_message_window_2(0, "Cosa stai blaterando?\nNon capisco...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Un'avventura?\nSarebbe carino.<page>Ma a cosa pu[UNI00f2] servirti\nuna vecchia come me?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Asks the player to hand over a chestnut and recruits the villager when the right item is used.
function npc_dialogue.recruit_with_chestnut(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Avete trovato delle Castagne?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(0, "Allora non potete aiutarmi...<page>Oh beh, meglio lasciar\nperdere il Castagnaccio.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ah, eccole! Grazie tante.<page>Prover[UNI00f2] a fare il Castagnaccio.<page>Ve lo far[UNI00f2] assaggiare appena pronto!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Posso fare qualcosa in cambio?<page>Cosa? Un'avventura al vostro fianco?<page>Ah ah! Certo che verr[UNI00f2].<page>Ma potevate dirlo subito!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Checks whether the player has photographed the moon and, if so, recruits the moon-loving villager into the party.
function npc_dialogue.recruit_with_moon_photo(npc_character: s32, player_character: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Pensavo tu fossi diverso,\ninvece no: gli Umani sono Umani.<page>Non importa. Ci sono abituato\na voi Umani: dite sempre bugie."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Fantastico! [UNI00c8] una foto della luna!<page>Ora potr[UNI00f2] portarla sempre con me!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Venire con te?<page>Certo!\nNon saprei dove altro andare!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Checks the length of the player's caught Nonky and recruits the fisherman if it is long enough.
function npc_dialogue.recruit_with_nonky_catch(npc_character: s32, player_character: s32)
	local fish_length: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	fish_length = vm.bits_float(event.get_menu_value(2, 322)) or fish_length
	if fish_length <= 0 then
		event.open_message_window_2(
			0,
			"Ehi, scommetto che non hai\nmai preso un Nonky per davvero!<page>Ah ah ah! Fai pena\ncome pescatore!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if fish_length < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(fish_length * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ah ah ah! Hai preso\nun pescetto di [数値１] cm!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Non sei degno del mio aiuto!<page>Ricomincia pure da capo!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, ti avevo sottovalutato.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Non mi rimanger[UNI00f2] la parola data:<page>ti ascolter[UNI00f2], come avevo promesso.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Parla quanto vuoi!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Asks for the Dark Coin and the Indestructible Coin, takes them after confirmation and recruits the coin collector.
function npc_dialogue.recruit_with_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"Come? Ah, la numismatica?<page>Sto cercando la Moneta oscura\ne la Moneta eterna.<page>Non le troverai mai. Le ho cercate\novunque, ma sono cos[UNI00ec] rare!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Eh? Le hai trovate? Incredibile!<page>Forza! Dammele, dammele, dammele!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Bene.\nCosa devo fare?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Argh! Se mi fai perdere tempo,\nnon ti aiuter[UNI00f2] di certo.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, le ho tutte! E io che\npensavo fosse impossibile...<page>Bene, immagino di non avere\naltra scelta ora. Verr[UNI00f2] con te!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has a fearful villager refuse to fight, ask Max for a flower photo and start the photo request, while Monica takes the alternate dialogue.
function npc_dialogue.request_flower_photo(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Io vorrei aiutarvi, ma lottare\nfa paura... e poi ci si sporca!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Non vorrei essere di peso a\nnessuno. Devo dirvi di no.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ma devono esserci molte cose\ninsolite fuori citt[UNI00e0].<page>Mi chiedo come siano gli alberi\ne quali fiori sboccino."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Se vedi un fiore interessante, gli\nfaresti una foto per me, Max?\nMi piacerebbe tanto vederlo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Questa volta ha detto no ma, se le\n   mostrassi una foto di qualcosa\n   che le piace, forse cederebbe."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the magical artist introduce his painted fiancee and ask the player to bring Golden Paint, or says the player should try as Max when Monica talks.
function npc_dialogue.request_golden_paint(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		event.open_message_window_2(0, "Ciao.\nMonica, giusto?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica non [UNI00e8] molto brava in queste\n   situazioni. Forse pu[UNI00f2] fare qualcosa,\n   forse no. Meglio riprovare come Max."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Ehi, Max!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"Certo, ridi pure!\nLo so che [UNI00e8] strano!<page>Chi si innamorerebbe della\nragazza di un quadro?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ma io sono un artista magico e\nposso dar vita ai miei quadri.<page>I miei soggetti esistono davvero,\nescluse le creature viventi..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Neanche un artista magico pu[UNI00f2]\nricreare la vita")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "In realt[UNI00e0] un modo c'[UNI00e8]: un Uovo\nd'Oro in un grande albero antico.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Pare che la sua Vernice oro dia\nvita a qualunque disegno.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Max, stai andando fuori\ncitt[UNI00e0], vero?<page>Mi prenderesti della Vernice oro?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Non mi aspetto che lo faccia gratis.<page>Se mi dai una mano, user[UNI00f2] i miei\nnuovi poteri per aiutarti."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un grande albero antico...\n   con un Uovo d'Oro! Dove diavolo\n   lo trovi un albero simile?!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Has the coin collector refuse to help without payment and ask for the Dark Coin and the Indestructible Coin, or says the player should try as Max when Monica talks.
function npc_dialogue.request_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Dovresti gi[UNI00e0] sapere la risposta:\nNEANCHE PER SOGNO!<page>Perch[UNI00e9] dovrei faticare per\nfare un favore a qualcun altro?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "A me non ne viene niente\ned [UNI00e8] troppo pericoloso.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Comunque, siccome sei tu, potrei\nanche farci un pensierino.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Sono figlio di un commerciante io,\nnon faccio certo favori gratis!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Saprai che colleziono monete.<page>Sono il perno degli affari. Come\nvorrei completare la collezione!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Non riesco mai a mettere\nle mani sulla Moneta oscura\ne sulla Moneta eterna.<page>Se mi aiutassi,\nforse io potrei aiutare te."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

--- The baker agrees to join once Max delivers 20 loaves of bread to Morton, hands over the bread and starts request 8.
function npc_dialogue.start_baker_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Vuoi che venga\ncon voi?<page>Sono solo una fornaia,\nma se posso essere utile,\nvengo volentieri."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Oh, ma prima c'[UNI00e8] una cosa che\ndev'essere consegnata a Morton.<page>Ti spiacerebbe portare 20 pagnotte\nal negozio di Morton per me?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Mentre vai,\npreparo i bagagli.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Mi chiedo perch[UNI00e9] diavolo\nvoglia 20 pagnotte!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- The fisherman says Firbits only help those better than them, boasts of his fish knowledge, hints at the fish race beginner class and starts request 16.
function npc_dialogue.start_fisherman_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "I Firbit concedono\nfavori solo a chi [UNI00e8]\npi[UNI00f9] in gamba di loro.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "So il fatto mio quando\nsi tratta di pesci.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ho sentito dire che gli Umani\norganizzano un evento in cui\nfanno competere i loro pesci.<page>Se hai un pesce, perch[UNI00e9]\nnon cerchi di arrivare primo?<page>Se ci riesci, sapr[UNI00f2]\nche sei degno del mio aiuto."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sembra che parli della Corsa dei\n   Pesci. Prova a vincere la Categoria\n   Principianti! Poi forse ti aiuter[UNI00e0]."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Gerald hands Max a Trumpet Gun, asks him to build it up into a Bell Trigger and starts request 11.
function npc_dialogue.start_gerald_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Secondo Cedric,\nhai combinato\nqualcosa di recente.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Sai fare un sacco di cose,<page>ma, a quanto pare, non\nconcludi molto.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Quindi, quando chiedi aiuto,\nper me [UNI00e8] difficile prenderti\nveramente sul serio.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Prova a potenziare questa Pistola-\ntrombetta in Pistola-campana?<page>Pensi di potercela fare?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(24)
	inventory.announce_received(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Per farti accettare da\n   Gerald, devi portargli\n   una Pistola-campana.<page>[(!)]Puoi potenziare la tua arma,\n   comprarne una o\n   recuperarne una nei labirinti."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Mena describes her dizziness; when Monica leads she recognises it as an effect of time distortions, a hint explains how to fix them, and request 17 starts with the current clear count saved.
function npc_dialogue.start_mena_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local clear_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Ultimamente, non mi sento in forma.<page>Non mi va di fare un viaggio.<page>Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Anche solo stare in piedi mi\nfa venire le vertigini.<page>[UNI00c8] difficile da spiegare. [UNI00c8] come\nse il mondo fosse deformato."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(0, "Mmh... se il Dottor Dell\nnon capisce di che si tratta,\nallora io non posso fare molto...")
		message.say_bubble(0, -1, player_slot, npc_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ricordo quei sintomi.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Quando sono nata, il mondo\nera in pessimo stato, con molte\npi[UNI00f9] distorsioni temporali\ndi quanto voi possiate immaginare."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Di questo ne risentivano le\npersone pi[UNI00f9] deboli e fragili.<page>I pi[UNI00f9] esili lamentavano vertigini,\ni pi[UNI00f9] grossi non si reggevano in piedi."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Forse sei troppo sensibile\na questo genere di cose.<page>Senti persino le poche distorsioni\ntemporali che abbiamo qui!"
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(0, "Se eliminassimo le distorsioni pi[UNI00f9]\nvicine, forse staresti meglio.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Eliminare distorsioni temporali, Spheda!\n   Se completi circa 10 livelli,\n   forse Mena star[UNI00e0] meglio."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	clear_count = event.get_menu_value_2(0) or clear_count
	event.set_save_counter(19, clear_count)
	event.set_quest_request(0, 17, 1)
end

--- Routes Adel's conversation by whether Monica leads, the status of requests 0 and 7 and the tailoring progress.
function npc_dialogue.talk_to_adel(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	local tailoring_progress: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_chatter.talk_tailor_monica(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 7) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_adel_confidence(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		tailoring_progress = event.get_save_counter(8) or tailoring_progress
		if tailoring_progress == 0 then
			quest_dialogue.request_tailor_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 1 then
			npc_dialogue.deliver_tailoring_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 2 then
			quest_dialogue.receive_tailor_garment(npc_slot, player_slot)
		end
		return
	end
	if request_status == 2 then
		palm_brinks_villagers.talk_worried_villager(npc_slot, player_slot)
		return
	end
end

--- Routes the fisherman's conversation by request 0 and 16 status and a story flag.
function npc_dialogue.talk_to_fisherman(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	local story_flag: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	story_flag = event.get_save_flag(424) or story_flag
	if request_status ~= 2 or story_flag == 0 then
		npc_dialogue.chat_firbit_favors(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 16) or request_status
	if request_status == 0 then
		npc_dialogue.start_fisherman_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_after_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_podium_hopeful(npc_slot, player_slot)
		return
	end
end

--- Chooses the gardener's dialogue from the story flag and the state of his quest request.
function npc_dialogue.talk_to_gardener(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(42) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_gordon_quest(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_gordon_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Chooses the magical artist's dialogue from the state of the main request and his own quest request.
function npc_dialogue.talk_to_magical_artist(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_golden_paint(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_parn_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_about_painting(npc_character, player_character)
		return
	end
end

--- Routes Mena's conversation by story flag and the status of request 17.
function npc_dialogue.talk_to_mena(npc_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local request_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_dialogue.chat_feeling_unwell(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 17) or request_status
	if request_status == 0 then
		npc_dialogue.start_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_villager_23_after_quest(npc_slot, player_slot)
		return
	end
end

--- Parn introduces himself to Monica or greets Max.
function npc_dialogue.talk_to_parn(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		event.open_message_window_2(0, "Ciao.\nMonica, giusto?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Ehi, Max!<page>Come fai ad essere\nsempre cos[UNI00ec] in forma?!")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Routes the safe owner's conversation by request 0 and 12 status.
function npc_dialogue.talk_to_safe_owner(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_muttering_numbers(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 12) or request_status
	if request_status == 0 then
		quest_dialogue.request_safe_combination(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_safe_code_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		palm_brinks_villagers.talk_garbage_neighbor(npc_slot, player_slot)
		return
	end
end

return npc_dialogue
