--!strict
--- Holds the Italian quest dialogue events for requests, recruits and request-progress routing.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local palm_brinks_quests = vm.module("@lib/event/italian/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/italian/villager_dialogue")

local quest_dialogue = {}

--- Plays the scene where the tailor hands over her first finished garment and joins the party.
function quest_dialogue.receive_tailor_garment(npc: s32, player: s32)
	local garment_item: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Ah, Max! Ho finito un indumento!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Non volevo sprecare i materiali\nche mi avete dato e che mi hanno\npermesso di arrivare fino in fondo."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Non sono del tutto convinta,\nma lo proveresti intanto?")
	message.say_bubble(0, -1, npc, player, 0)
	garment_item = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		garment_item = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			garment_item = 260
		end
	end
	event.add_inventory_item(garment_item)
	inventory.announce_received(garment_item, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ah, che bello aver\nportato qualcosa a termine!<page>Ora mi sento molto\npi[UNI00f9] sicura di me.<page>Far[UNI00f2] del mio meglio...\nPer favore, portatemi con voi!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Has the servant explain his need for money to bid on a rare book, then starts that request.
function quest_dialogue.request_book_funds(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Qualunque cosa vi serva, far[UNI00f2]\ndel mio meglio per aiutarvi.<page>Lasciate fare a me.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Non so se potete aiutarmi...<page>Comunque ascoltate.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Sono 30 anni che lavoro\nsodo in questa casa.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Il lavoro [UNI00e8] la mia vita, ma\nun hobby ce l’ho: la lettura.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "C'[UNI00e8] un libro raro e prezioso,\nora in vendita all'asta.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "La gente fa a botte per averlo.\nCredo che un'offerta di circa\n1000 Gilda possa bastare.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Non ho tanto denaro e, se lo\nchiedessi al padrone, andrebbe su tutte\nle furie e io dovrei andarmene."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Siete la mia unica speranza.<page>Ma questo non significa che se\nnon mi aiutate io non aiuter[UNI00f2] voi."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Malgrado le sue parole, Stewart non vi\n   aiuter[UNI00e0] se non gli darete 1000 Gilda.\n   Bisogner[UNI00e0] racimolare soldi!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Has the angler set a Nonky fishing challenge, then starts that request.
function quest_dialogue.request_nonky_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Vuoi che ti faccia un favore?<page>Ascoltami bene prima.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ascolto solo quelli che rispetto.<page>E rispetto solo chi riesce a\nprendere pesci pi[UNI00f9] grossi di me."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Il pesce pi[UNI00f9] grande che ho preso\n[UNI00e8] stato un Nonky di 60 cm.<page>Sei sorpreso, eh?\nSe te la senti di sfidarmi,\nper me, quando vuoi!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sembra che l'unico modo di averlo\n   dalla tua sia pescare un Nonky\n   di pi[UNI00f9] di 60 cm. Dai, puoi farcela!"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Comunque, prova un po' a pescare\n   nel lago di Vallecatini.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Has the mayor ask the player to work out his forgotten safe combination, then starts that request.
function quest_dialogue.request_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player, npc)
	event.open_message_window_2(0, "Mpfffff...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Che vuoi dire con\n'cosa sto blaterando'?<page>Sto tentando di ricordare\nla combinazione della cassaforte."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Come sarebbe\n'quale cassaforte'?<page>La cassaforte nascosta dietro\nil quadro nel mio ufficio, no?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	character.face_toward(npc, player)
	event.set_character_motion(npc, "会話")
	event.open_message_window_2(
		0,
		"Ah, mi hai messo una paura!<page>Oh, maledizione!<page>Mi son lasciato scappare il\nmio segreto pi[UNI00f9] grande!<page>Oh bene, ora lo sai.<page>Forse puoi darmi una mano\na risolvere il problema."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ho un grosso problema:\nnon riesco a ricordare\nla combinazione della cassaforte.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] un numero a 4 cifre. Ho usato\nla data di nascita di Claire,\nconvinto di ricordarmela sempre."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Come posso essermela dimenticata?<page>Che padre snaturato sono!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pare che il Sindaco sia nei guai.\n   Ascolta cosa dice del compleanno\n   di Claire e scopri la combinazione."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Hands Monica a Gladius and asks her to build it up two levels, then starts that request.
function quest_dialogue.request_sword_upgrade(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Tu sei Monica,\ngiusto?<page>Ho sentito dire che\nnon sei niente male con la spada.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ma le spade non sono\ngiocattoli, lo sai.<page>Devi pensare a\ncosa hai davanti.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Se potenzi una spada di 2 livelli,\nmi convincer[UNI00f2] del tuo talento!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Perch[UNI00e9] non cominci\ncon il Gladio?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Se vuoi farti accettare da\n   Milane, dovrai potenziare il\n   Gladio di 2 livelli.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi anche comprare o trovare le armi.\n   L'importante [UNI00e8] procurarsene di\n   potenti, cos[UNI00ec] Milane ti aiuter[UNI00e0]."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Has the would-be tailor ask the player to fetch cloth, hide and copper, then starts that request.
function quest_dialogue.request_tailor_materials(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"S[UNI00ec], se ci riprovassi e portassi\na termine qualcosa, forse\ntornerei a credere in me stessa."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ma mi mancano i materiali.<page>Potreste procurarmeli?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Mi servono: Stoffa robusta,\nCuoio spesso e un Pezzo di Rame.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
	event.set_save_counter(8, 1)
end

--- Routes the baker conversation by playable character and request progress.
function quest_dialogue.talk_baker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_baker_about_max(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_business_trust(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_baker_request(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_baker_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_baker_done(npc, player)
		return
	end
end

--- Routes the book servant conversation by playable character and request progress.
function quest_dialogue.talk_book_servant(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_book_servant_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		villager_dialogue.offer_help(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_book_funds(npc, player)
		return
	end
	if quest_status == 1 then
		palm_brinks_villagers.lend_auction_money(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_book_servant_done(npc, player)
		return
	end
end

--- Plays the bread-delivery recipient dialogue for the current delivery stage.
function quest_dialogue.talk_bread_delivery_recipient(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage == 0 then
		event.open_message_window_2(0, "Oh, stai\naiutando Polly?<page>Grandioso.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Che me ne faccio\ndi 20 pagnotte?<page>Beh, dar[UNI00f2] un\nfonduta-party oggi!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			'Per fare un parallelo con le tue famose\n"invenzioni", [UNI00e8] una combo culinaria di<page>formaggio, pane e vino!'
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"[UNI00c8] buono. Ne mangiano a tonnellate,\nper questo mi serve tanto pane.<page>Ma veramente non volevo che\nmi venisse consegnato qui."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Scusa Max, potresti portarmele\na casa, per favore?<page>Sai dov'[UNI00e8], vero?\nVicino al campo di zucche."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_stage == 1 then
		event.open_message_window_2(0, "Sai dov'[UNI00e8], vero?\nVicino al campo di zucche.")
		message.say_bubble(0, -1, npc, player, 0)
	end
	if delivery_stage == 2 then
		event.open_message_window_2(0, "Niente pi[UNI00f9] party?!\nChe peccato!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "In tal caso, il pane non mi serve.\nLo riporteresti a Polly per me?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_stage == 3 then
		event.open_message_window_2(0, "Scusa, riporteresti il\npane a Polly per me?")
		message.say_bubble(0, -1, npc, player, 0)
	end
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Picks the resident's conversation from the progress of the coin collector's rare coin request, speaking an idle line before the requests open.
function quest_dialogue.talk_by_request_status(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_shop_closed(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 2) or request_status
	if request_status == 0 then
		npc_dialogue.request_rare_coins(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_coin_collector(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(npc_character, player_character)
		return
	end
end

--- Routes the grandmother conversation by request progress.
function quest_dialogue.talk_grandmother(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_hard_of_hearing_villager(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		npc_dialogue.recruit_hard_of_hearing_woman(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_grandmother(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_old_woman_ends_of_earth(npc, player)
		return
	end
end

--- Routes the hide-and-seek conversation by request progress.
function quest_dialogue.talk_hide_and_seek_hider(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.ask_to_join_party(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_corinne_hide_and_seek(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_after_hide_and_seek(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_hide_and_seek(npc, player)
		return
	end
end

--- Routes the Rufio conversation by request progress.
function quest_dialogue.talk_rufio(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_missing_moon(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		npc_dialogue.explain_moon_photo_condition(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_moon_photo(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.thank_for_moon_photo(npc, player)
		return
	end
end

--- Routes the swordsmith conversation by playable character and request progress.
function quest_dialogue.talk_swordsmith(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		npc_chatter.talk_swordsmith_max(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_blade_shopkeeper(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_sword_upgrade(npc, player)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_sword_for_recruit(npc, player)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_sword_fan(npc, player)
		return
	end
end

--- Checks that the player owns the required gun and, if so, recruits the gun fighter and completes the request.
function quest_dialogue.test_gun_for_recruit(npc: s32, player: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"Che c'[UNI00e8] che non va?\nTi arrendi di nuovo?<page>Mi deludi!\n[UNI00c8] questo che succede ad armeggiare\ntroppo con le macchine?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Sembra che tu sia diventato\nbravo anche con le armi!<page>Non serve guardarti sparare:\nsi vede gi[UNI00e0] da come la tieni."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"OK, ti aiuter[UNI00f2].\nMa non lo faccio per te.<page>Se questa citt[UNI00e0] [UNI00e8] in pericolo,\nnon posso stare con\nle mani in mano."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Checks that the player owns one of the required swords and, if so, recruits the swordsman and completes the request.
function quest_dialogue.test_sword_for_recruit(npc: s32, player: s32)
	local first_item_count: s32 = 0
	local second_item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	first_item_count = event.get_item_count(67) or first_item_count
	second_item_count = event.get_item_count(69) or second_item_count
	if first_item_count <= 0 and second_item_count <= 0 then
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

return quest_dialogue
