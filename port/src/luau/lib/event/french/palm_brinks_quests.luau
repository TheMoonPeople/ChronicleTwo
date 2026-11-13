--!strict
--- French recruitment and request conversations of Palm Brinks NPCs.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local villager_recruitment = vm.module("@lib/event/french/villager_recruitment")

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
		event.open_message_window_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "H[UNI00e9], on ne triche pas !")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, seconds_fraction)
	if is_fast_enough == 0 then
		event.open_message_window_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
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
			"As-tu photographi[UNI00e9] une fleur ?<page>J'en connais plein alors elle devra\n[UNI00ea]tre tr[UNI00e8]s sp[UNI00e9]ciale pour m'int[UNI00e9]resser."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "As-tu photographi[UNI00e9] une fleur\ninhabituelle ?\nMontre-moi, montre-moi vite !")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ouaah ! [UNI00c9]tonnant ! Voici donc le\ngenre de fleur qu'on trouve [UNI00e0]\nl'ext[UNI00e9]rieur."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Humm... Que dois-je faire ?<page>Bon d'accord ! Emm[UNI00e8]ne-moi avec toi !")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Has Rufio ask whether the destination has a moon, decide to wait for the moon here, and starts the moon request.
function palm_brinks_quests.explain_moon_condition(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Je veux bien venir avec toi,\nmais y aura-t-il une lune l[UNI00e0]-bas ?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "C'est vrai ? Dois-je te croire sur\nparole. Les hommes mentent parfois.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "En fait, j'ai chang[UNI00e9] d'avis. Je\nvais attendre que la lune se\nmontre ici.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]C'est peut-[UNI00ea]tre li[UNI00e9] [UNI00e0] son histoire\n   pass[UNI00e9]e... Quoi qu'il en soit, Rufio\n   ne fait pas confiance aux hommes."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Il faut que Rufio te croie.\n   Si tu lui donnes une photo\n   de la lune, [UNI00e7]a marchera peut-[UNI00ea]tre."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Has Mena describe her dizziness and, for Monica, explain time distortions, record the cleared-stage count and start the distortion request.
function palm_brinks_quests.explain_time_distortions(npc: s32, player: s32)
	local playable_character: s32 = 0
	local cleared_stage_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Je ne suis pas tr[UNI00e8]s en forme.<page>Je ne peux pas partir en voyage.<page>Le Dr Dell est venu me voir, mais\nil m'a dit que tout allait bien."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Pourtant, quand je suis debout, j'ai\nl'impression que je vais tomber.<page>C'est dur [UNI00e0] expliquer. C'est un peu\ncomme si le monde avait [UNI00e9]t[UNI00e9] d[UNI00e9]form[UNI00e9]."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"Mmm... Si le Dr Dell ne sait pas ce\nqui ne va pas, je ne vois pas bien\nce que je peux faire moi-m[UNI00ea]me..."
		)
		message.say_bubble(0, -1, player, npc, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00c7]a me rappelle quelque chose.")
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"[UNI00c0] l'[UNI00e9]poque o[UNI00f9] je suis n[UNI00e9], le\nmonde [UNI00e9]tait dans un [UNI00e9]tat d[UNI00e9]plorable,\navec un nombre incalculable de\ndistorsions temporelles."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Cela avait un impact sur les gens\n[UNI00e0] la sant[UNI00e9] fragile.<page>Les plus l[UNI00e9]gers avaient le tournis\net les plus lourds ne tenaient\nplus debout."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Tu es peut-[UNI00ea]tre particuli[UNI00e8]rement\nsensible [UNI00e0] ce genre de chose.<page>M[UNI00ea]me les rares distorsions qu'on\na ici suffisent [UNI00e0] t'affecter."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Si on pouvait [UNI00e9]liminer les plus\nproches d'entre elles, tu te\nsentirais peut-[UNI00ea]tre mieux."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.set_character_motion(player, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Comment [UNI00e9]liminer une distorsion...\n   Le Spheda ! Termine environ 10 niveaux\n   et Mena ira peut-[UNI00ea]tre mieux."
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
	event.open_message_window_2(0, "Ronchonnements...")
	message.wait_facing_character(npc)
	event.open_message_window_2(
		0,
		"...1212,<page>Mais non, c'[UNI00e9]tait 2211, c'est certain.<page>Ou peut-[UNI00ea]tre bien 1010."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ronchonnements...")
	message.say_bubble(0, -1, npc, player, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]S'il ne te remarque m[UNI00ea]me pas quand \n   tu dis \"Bonjour\", c'est qu'il \n   doit avoir de gros, gros probl[UNI00e8]mes.<page>[(!)]Pourquoi ne pas r[UNI00e9]essayer plus tard\n   Tu pourras peut-[UNI00ea]tre l'aider, ou\n   l'[UNI00e9]couter se plaindre, au pire !"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has Gerald hand over a Trumpet Gun and challenge the player to build it up into a Bell Trigger.
function palm_brinks_quests.offer_bell_trigger_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "D'apr[UNI00e8]s C[UNI00e9]dric,\ntu es toujours tr[UNI00e8]s\nactif en ce moment.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Tu es dou[UNI00e9] dans plein de domaines,<page>mais d'un autre c[UNI00f4]t[UNI00e9], tu ne\ntermines jamais rien."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Alors quand tu demandes de\nl'aide, j'ai un peu de mal [UNI00e0]\nte prendre au s[UNI00e9]rieux."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Je sais ! Essaie de transformer ce\npistolet trompette en pistolet cloche !<page>Tu crois que tu peux y arriver ?"
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
		"[(!)]Pour que G[UNI00e9]rald t'aide,\n   tu vas devoir lui rapporter\n   un pistolet cloche.<page>[(!)]Tu peux d[UNI00e9]velopper l'arme qu'il t'a\n   donn[UNI00e9]e, en acheter une ou en rapporter\n   une trouv[UNI00e9]e dans les d[UNI00e9]dales."
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
			"Quoi ? Ah, les pi[UNI00e8]ces de monnaie ?<page>Je cherche la Pi[UNI00e8]ce de sacrifice\net la Pi[UNI00e8]ce de solidit[UNI00e9].<page>Tu ne les trouveras jamais, j'ai\nd[UNI00e9]j[UNI00e0] cherch[UNI00e9] partout."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Quoi ? Tu les as ? Incroyable !<page>Allez vite, donne-les-moi !")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Bon.\nQu'est-ce que je dois faire ?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Aaah ! Si tu me casses les pieds,\nje ne t'aiderai certainement pas.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Ouaah, je les ai toutes !\nJe n'y croyais plus...<page>Bon, je n'ai plus le choix hein ?\nJe vais venir avec toi !"
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
		"Max, soigner cet arbre est ma\ngrande priorit[UNI00e9].<page>Mais pour cela, il me\nfaudrait..."
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
		event.open_message_window_2(
			0,
			"Max, [UNI00e7]a ne marchera pas.<page>Ce qu'il me faut, c'est de l'Eau\nsacr[UNI00e9]e du P[UNI00e8]re Bruno."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ouais ! Max tu as r[UNI00e9]ussi ! Je vais\npouvoir soigner cet arbre !<page>Merci, Max.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"J'ai fait tout ce que je devais\nfaire pour un bon moment.<page>Je peux donc t'accompagner dans\nton aventure !<page>Oh, et ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon s'est joint [UNI00e0] ton aventure.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux utiliser ses talents\n   [UNI00e0] partir de la commande Statut, dans\n   Personnages (Menu principal).<page>[(!)]Si tu recrutes une autre\n   personne pour tes aventures,\n   celle-ci montera dans le train."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Parle [UNI00e0] cette personne dans le\n   train pour en faire le 3e\n   membre de ton groupe.<page>[(!)]Pour d[UNI00e9]placer un ami du train\n   vers une maison, choisis Installer\n   quelqu'un (menu de la porte)."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Il est possible que d'autres personnes\n   souhaitent participer [UNI00e0] l'aventure.\n   Surtout, ne les manque pas !"
	)
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
			"Qu'est-ce que c'est que [UNI00e7]a ?\nAlors c'[UNI00e9]tait juste du pipeau ?<page>Sors d'ici !\nTu g[UNI00ea]nes [UNI00e0] tra[UNI00ee]ner dans le coin."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ouaah, c'est une [UNI00e9]p[UNI00e9]e\nplut[UNI00f4]t impressionnante.<page>Je m'excuse, mais\nje devais te tester."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Car tu sais, se battre avec un\namateur, c'est dangereux pour moi\naussi.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Mais j'ai l'impression que je n'ai\npas [UNI00e0] m'inqui[UNI00e9]ter de [UNI00e7]a avec toi.<page>Tr[UNI00e8]s bien, allons\ncombattre ensemble."
	)
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
		event.open_message_window_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
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
			"Je te croyais diff[UNI00e9]rent, mais non,\nles hommes sont les hommes.<page>Peu importe, je suis habitu[UNI00e9] [UNI00e0] ce\nqu'on me raconte des mensonges."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Il y a une lune sur cette photo !<page>Je pourrai la voir quand je veux !")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Venir avec toi ?<page>Mais oui, bien s[UNI00fb]r.\nJe n'ai nulle part ailleurs o[UNI00f9]\naller."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

return palm_brinks_quests
