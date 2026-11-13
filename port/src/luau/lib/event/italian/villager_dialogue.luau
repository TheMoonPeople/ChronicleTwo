--!strict
--- Italian villager conversations triggered from the town and dungeon scripts.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/italian/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_dialogue = {}

--- Speaks a villager's offer to help with any problem.
function villager_dialogue.offer_help(villager: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Per qualsiasi problema,\nvenite subito da me!")
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Plays Corinne's request to join the player, her hide-and-seek challenge and her disappearance.
function villager_dialogue.start_corinne_hide_and_seek(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Oh, Max! Ho sentito dire che\nsei stato fuori citt[UNI00e0] ultimamente.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ho sentito dire che\nsei stata fuori citt[UNI00e0] ultimamente.")
	end
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Grandioso! Perch[UNI00e9] non\nmi porti con te?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Scommetto che mi reputi inutile\nsolo perch[UNI00e9] sono una ragazza.<page>Ma in realt[UNI00e0], porto alla gente\nun sacco di fortuna!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Quando esco non piove mai\ne non ho mai perso\nalla lotteria!<page>Che ne pensi?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK allora.\nNo, mi spiace.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Perch[UNI00e9]? Non essere crudele!\nSei orribile!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Incapace!<page>Demente!<page>Idiota!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Mi porterai con te?<page>Non credevo lo avresti fatto!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Come mai devo chiedertelo io,\nmentre tu non fai che chiederlo\na tutti gli altri? <page>Se solo me l’avessi chiesto,\nti avrei aiutato subito."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Allora, se riesci a trovarmi,\nti aiuter[UNI00f2]. Che ne pensi?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Cio[UNI00e8]... giochiamo a nascondino!<page>Pronti, via!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, villager)
	event.set_character_active(0, villager)
	event.delete_villager(villager)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh bene... Forse faresti meglio a\n   trovare Corinne. Si sar[UNI00e0] nascosta\n   da qualche parte a Vallecatini."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Plays Gordon's explanation of his tree problem, his quest and the notebook that tracks it.
function villager_dialogue.start_gordon_quest(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local notebook_count: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.hint_talk_to_gordon(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Oh, Max! Hai avuto parecchi\npensieri ultimamente.\nTi stai riguardando?<page>Posso fare qualcosa per te?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Cosa! Vuoi che ti segua\nnella tua avventura?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Mmh... Vorrei venire con te...\nMa questo povero albero non\nsta mica tanto bene.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Prendermi cura degli alberi e dei\nfiori di questa tenuta [UNI00e8] ci[UNI00f2] che\nmi preme di pi[UNI00f9], lo sai.<page>Se me ne andassi a zonzo,\nperderei il mio lavoro!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"L'Acqua sacra che Don Bruno vende\nin chiesa sanerebbe quest'albero!<page>Ma, come sai, tuo padre e Don\nBruno non vanno molto d'accordo...<page>Tuo padre non mi darebbe mai soldi\nper comprare la sua Acqua Sacra!<page>Sono in un bel pasticcio!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Per portare Gordon a Sindain,\n   devi fare in modo che ti\n   segua in viaggio.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Se soddisfi la richiesta di Gordon,\n   ti seguir[UNI00e0] in viaggio\n   e salir[UNI00e0] sul treno."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Puoi controllare le richieste\n   leggendo il Taccuino,\n   nel Menu Oggetti.")
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(0, "[(!)]Oh, non hai un Taccuino?\n   Ce n'[UNI00e8] uno sul tavolo\n   nel Negozio di Cedric.")
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Ce ne [UNI00e8] un altro nella tana\n   di Donny. Vanno bene entrambi.\n   Prendine uno, sbrigati!"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Speaks a painter villager's lines about the world of painting, with different lines in chapter 8.
function villager_dialogue.talk_about_painting(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Usa pure il mio nuovo potere\nquando vuoi.")
	else
		event.open_message_window_2(
			0,
			"Il mondo della pittura [UNI00e8] sconfinato.\nPotrebbe volerci tutta la vita per\nconoscerlo ma ne varrebbe la pena!"
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Chooses the villager's conversation from the progress of quest request 11, using a default talk until quest request 0 is complete, with a separate talk while Monica is playable.
function villager_dialogue.talk_quest_11_villager(villager: s32, player_character: s32)
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
		npc_dialogue.start_gerald_request(villager, player_character)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_gun_for_recruit(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_weapons(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 15, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_15_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_chatter.talk_angler_intro(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_nonky_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_nonky_catch(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_fishing_spots(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 2, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_2_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_shop_closed(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_rare_coins(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 4, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_4_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_flower_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_flower_photo_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(villager, player_character)
		return
	end
end

--- Starts the conversation of the villager that triggered the event.
function villager_dialogue.talk_to_triggered_villager()
	local villager_type: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		villager_type = event.get_triggered_event_data_2(14) or villager_type
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if villager_type <= 34 then
			step = 1
			palm_brinks_villagers.talk_to_npc(villager, player_character)
		else
			step = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Speaks the lines of the villager of type 23 once their quest is complete, with different lines in chapter 8.
function villager_dialogue.talk_villager_23_after_quest(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Ricambier[UNI00f2] il vostro aiuto ma non\nportatemi dove ci sono insetti!")
	else
		event.open_message_window_2(
			0,
			"Se la Ferrovia Carbonero si\nespander[UNI00e0] in tutto il mondo, forse\npotr[UNI00f2] girare il mondo anch'io."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's thanks for the moon photo, with different lines in chapter 8.
function villager_dialogue.thank_for_moon_photo(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Mi hai dato la foto della luna.\nSei un bravo Umano.")
	else
		event.open_message_window_2(
			0,
			"Se la Ferrovia Carbonero viagger[UNI00e0]\nper tutto il mondo, potremo\nvisitare un sacco di bei posti."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

return villager_dialogue
