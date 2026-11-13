--!strict
--- Holds the French dialogue and events of the town residents who can join the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local max_concern = vm.module("@lib/event/french/max_concern")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local object = vm.module("@lib/event/object")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local quest_dialogue = vm.module("@lib/event/french/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local npc_dialogue = {}

--- Has the villager greet Max or Monica by name and ask to be taken along on trips outside town.
function npc_dialogue.ask_to_join_party(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.open_message_window_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays the baker's chatter about travelling together and bread, depending on the chapter.
function npc_dialogue.chat_about_bread(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Allez Max,\non y va.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	else
		event.open_message_window_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter saying the shop is closed and pointing to the pumpkins at the speaker's father's shop.
function npc_dialogue.chat_about_closed_shop(npc_slot: s32, player_slot: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Le magasin est ferm[UNI00e9]. Tu dois donc\naller au magasin de mon p[UNI00e8]re. Cherche<page>les citrouilles, tu ne peux pas les\nrater. C'est en haut de la colline."
	)
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter about women wielding swords and an offer of help, depending on the chapter.
function npc_dialogue.chat_about_swords(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Je n'aime pas trop voir les femmes\nmanier des [UNI00e9]p[UNI00e9]es. Pour moi, une<page>femme doit [UNI00ea]tre plus f[UNI00e9]minine.\nComme Ad[UNI00e8]le, par exemple."
		)
	else
		event.open_message_window_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
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
		event.open_message_window_2(
			0,
			"Je n'y crois pas. Je n'ai jamais\nvraiment cru que tu les trouverais.<page>T'as fait tr[UNI00e8]s fort Max !"
		)
	else
		event.open_message_window_2(
			0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Has the villager say they are busy gathering materials for the town's safety and ask the player to wait until tomorrow.
function npc_dialogue.chat_busy_with_materials(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Salut, Max.\nExcuse-moi, mais je suis\nun peu pris pour l'instant.<page>Je suis en train de r[UNI00e9]cup[UNI00e9]rer des\nmat[UNI00e9]riaux importants qui aideront [UNI00e0]\npr[UNI00e9]server la s[UNI00e9]curit[UNI00e9] de la ville."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Si [UNI00e7]a n'est pas urgent,\n[UNI00e7]a peut attendre jusqu'[UNI00e0] demain ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager talk about fishing as a hobby and the dream of catching a giant fish.
function npc_dialogue.chat_fishing_hobby(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mon hobby [UNI00e0] moi, c'est la p[UNI00ea]che.<page>Je r[UNI00ea]ve de p[UNI00ea]cher un Mardan Garayan.<page>Il faut p[UNI00ea]cher gros pour m'[UNI00e9]pater."
	)
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
			"Um, [UNI00e7]a peut attendre bien s[UNI00fb]r,\nmais un jour, j'aimerais que tu\nm'expliques ta technique de p[UNI00ea]che."
		)
	else
		event.open_message_window_2(
			0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say they are hard of hearing and can only follow slow speech.
function npc_dialogue.chat_hard_of_hearing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah ! Bonjour !\nJe suis un peu dure d'oreille.<page>Je ne comprends pas ce qu'on me\ndit, sauf quand on parle lentement."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager advise the player to learn the basics of mining.
function npc_dialogue.chat_mining_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Tu es dou[UNI00e9] avec les machines, mais\nil serait temps d'apprendre le b.a.\n-ba de l'exploitation mini[UNI00e8]re..."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager wonder why the moon is so missed and if the villager came from there.
function npc_dialogue.chat_moon_longing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Pourquoi la lune me manque-t-elle<page>tant ? Je me demande si je ne\nviendrais pas de l[UNI00e0]-bas des fois..."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager mutter number sequences while ignoring the player, then shows a hint to come back later.
function npc_dialogue.chat_muttering_numbers(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Ronchonnements...")
	message.wait_facing_character(npc_character)
	event.open_message_window_2(
		0,
		"...1212,<page>Mais non, c'[UNI00e9]tait 2211, c'est certain.<page>Ou peut-[UNI00ea]tre bien 1010."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ronchonnements...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]S'il ne te remarque m[UNI00ea]me pas quand \n   tu dis \"Bonjour\", c'est qu'il \n   doit avoir de gros, gros probl[UNI00e8]mes.<page>[(!)]Pourquoi ne pas r[UNI00e9]essayer plus tard\n   Tu pourras peut-[UNI00ea]tre l'aider, ou\n   l'[UNI00e9]couter se plaindre, au pire !"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has the magical artist offer the use of his new power, with a remark about the world of pictures in the final chapter.
function npc_dialogue.chat_new_power(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
	else
		event.open_message_window_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the old woman wonder what use she could be and wish to see the Ends of the Earth, depending on the chapter.
function npc_dialogue.chat_old_woman_ends_of_earth(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "[UNI00c0] quoi pourrait servir une\ngrand-m[UNI00e8]re comme moi ?")
	else
		event.open_message_window_2(
			0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager talk about wanting a podium finish, with a different line in the final chapter.
function npc_dialogue.chat_podium_dream(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "J'esp[UNI00e8]re un jour pouvoir moi\naussi occuper la plus haute\nmarche du podium.")
	else
		event.open_message_window_2(
			0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
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
		event.open_message_window_2(0, "Je prie pour que le monde vive\nenfin en paix.")
	else
		event.open_message_window_2(0, "Quand tu travailles dur pour une\nbonne cause, tu dois savoir\nr[UNI00e9]fl[UNI00e9]chir.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the maid say she dreams of becoming a seamstress although dreams rarely come true.
function npc_dialogue.chat_seamstress_dream(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Je travaille ici comme\ngouvernante, mais je r[UNI00ea]ve depuis\nl'enfance de devenir couturi[UNI00e8]re."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais les r[UNI00ea]ves ne se r[UNI00e9]alisent\npas, c'est pourquoi ils restent\ndes r[UNI00ea]ves."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager admit to owning a book without reading it, with a warning about Zelmite Mine in the final chapter.
function npc_dialogue.chat_unread_book(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Le livre que j'ai achet[UNI00e9] ?\nEn fait, je ne l'ai pas encore lu.<page>Le poss[UNI00e9]der suffit [UNI00e0] mon\nbonheur."
		)
	else
		event.open_message_window_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
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
		event.open_message_window_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if run_state == 1 then
		event.open_message_window_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "H[UNI00e9], on ne triche pas !")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, hundredths)
	if beat_record == 0 then
		event.open_message_window_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
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
		event.open_message_window_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
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
			"As-tu photographi[UNI00e9] une fleur ?<page>J'en connais plein alors elle devra\n[UNI00ea]tre tr[UNI00e8]s sp[UNI00e9]ciale pour m'int[UNI00e9]resser."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "As-tu photographi[UNI00e9] une fleur\ninhabituelle ?\nMontre-moi, montre-moi vite !")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ouaah ! [UNI00c9]tonnant ! Voici donc le\ngenre de fleur qu'on trouve [UNI00e0]\nl'ext[UNI00e9]rieur."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Humm... Que dois-je faire ?<page>Bon d'accord ! Emm[UNI00e8]ne-moi avec toi !")
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
		"Max, soigner cet arbre est ma\ngrande priorit[UNI00e9].<page>Mais pour cela, il me\nfaudrait..."
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
		event.open_message_window_2(
			0,
			"Max, [UNI00e7]a ne marchera pas.<page>Ce qu'il me faut, c'est de l'Eau\nsacr[UNI00e9]e du P[UNI00e8]re Bruno."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ouais ! Max tu as r[UNI00e9]ussi ! Je vais\npouvoir soigner cet arbre !<page>Merci, Max.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"J'ai fait tout ce que je devais\nfaire pour un bon moment.<page>Je peux donc t'accompagner dans\nton aventure !<page>Oh, et ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon s'est joint [UNI00e0] ton aventure.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux utiliser ses talents\n   [UNI00e0] partir de la commande Statut, dans\n   Personnages (Menu principal).<page>[(!)]Si tu recrutes une autre\n   personne pour tes aventures,\n   celle-ci montera dans le train."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Parle [UNI00e0] cette personne dans le\n   train pour en faire le 3e\n   membre de ton groupe.<page>[(!)]Pour d[UNI00e9]placer un ami du train\n   vers une maison, choisis Installer\n   quelqu'un (menu de la porte)."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Il est possible que d'autres personnes\n   souhaitent participer [UNI00e0] l'aventure.\n   Surtout, ne les manque pas !"
	)
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
			event.open_message_window_2(0, "Je me sens toujours aussi mal.")
			checkpoint = 2
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.open_message_window_2(
				0,
				"J'ai peut-[UNI00ea]tre quelque\nchose de tr[UNI00e8]s grave ?<page>Peut-[UNI00ea]tre que m[UNI00ea]me le Dr Dell ne\npeut plus rien faire pour moi..."
			)
			checkpoint = 3
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.set_character_motion(npc_slot, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Bonjour !<page>Comment je vais ? Super bien !")
		checkpoint = 4
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Je me sens tellement mieux !<page>Le monde semble [UNI00e0] nouveau normal.")
		checkpoint = 5
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Ah oui. Tu voulais un service.<page>Je ferai tout pour t'aider.<page>Tu l'as fait pour moi, alors je\ndois aussi te venir en aide."
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
	event.open_message_window_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
	)
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
		event.open_message_window_2(
			0,
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
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
		event.open_message_window_2(0, "Une fois, je lui ai offert une\nbroche avec son signe astrologique.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"C'est Holly qui l'avait achet[UNI00e9]e\npour moi, mais je crois me souvenir\nque c'[UNI00e9]tait un animal [UNI00e0] 4 pattes..."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Quel genre de cadeaux\nd'anniversaire je lui offre ?<page>Humm... beaucoup de manteaux et\nd'[UNI00e9]charpes il me semble.<page>Je ne sais jamais quoi lui offrir.\nEt tous les ans, c'est pire."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Ah [UNI00e7]a ! Son anniversaire, c'est\ntoujours p[UNI00e9]nible. C'est un jour de\nramassage des d[UNI00e9]chets combustibles<page>et non-combustibles. C'est moi qui\nsort les poubelles chez nous."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Les d[UNI00e9]chets non-combustibles sont\nramass[UNI00e9]s les jours divisibles par 7<page>et les d[UNI00e9]chets combustibles, les\njours divisibles par 3."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Tu n'oublierais quand m[UNI00ea]me pas [UNI00e7]a,\nhein ?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.open_message_window_2(
			0,
			"J'ai compris ! Myst[UNI00e8]re r[UNI00e9]solu !\nLa combinaison est...<page>Je ne sais pas... Attends un peu."
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
	event.set_menu_value(0, "Saisis le num[UNI00e9]ro du code secret.", "2112", 0)
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
		event.open_message_window_2(
			0,
			"Humm, [UNI00e7]a s'ouvre pas. Oh la la...<page>Il y a des documents vraiment\nimportants l[UNI00e0]-dedans..."
		)
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
	event.open_message_window_2(0, "Euh... Mmm...\n2,<page>1,<page>1,<page>2...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Ouaaaaouh !<page>Formidable,\n[UNI00e7]a a march[UNI00e9] !")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.attach_object_handle_to_character(0, npc_slot)
	event.clear_object_sequence(0, npc_slot)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Formidable ! Je peux enfin\nsortir mes documents importants !<page>Oh, merci !")
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
		"Quels documents ? Des dossiers<page>qui aideront Morton, mon adjoint,\n[UNI00e0] me remplacer en mon absence.<page>[UNI00c7]a m'inqui[UNI00e8]te un peu,\nmais je suis s[UNI00fb]r que [UNI00e7]a ira."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Je suis pr[UNI00ea]t [UNI00e0] quitter la ville.<page>C[UNI00e9]dric m'a tout expliqu[UNI00e9].<page>Allez, on y va."
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
			"Sans mat[UNI00e9]riaux, je ne\npeux rien faire. Il me faut du<page>tissu r[UNI00e9]sistant, du cuir [UNI00e9]pais\net un morceau de cuivre.<page>Je suis d[UNI00e9]sol[UNI00e9]e de te cr[UNI00e9]er\ntant de soucis."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Tiens, prends [UNI00e7]a !\n[UNI00c7]a sera perdu autrement.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Sans mat[UNI00e9]riaux,\nje ne peux rien faire.")
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
		"Merci ! Maintenant, je vais\nessayer de coudre des v[UNI00ea]tements !<page>Rien de tout cela ne sera jet[UNI00e9]."
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
	event.open_message_window_2(0, "H[UNI00e9] Max, tu es venu me chercher ?<page>Je t'attendais.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Gr[UNI00e2]ce aux remparts, cette ville\nest bien prot[UNI00e9]g[UNI00e9]e. Nous devrions<page>maintenant en sortir."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"C'est bien de passer son temps\n[UNI00e0] bricoler comme tu le fais,\nmais fais-tu assez d'exercice ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Au combat, tout est dans la\nrapidit[UNI00e9] et le jeu de jambes.<page>Si tu es plus lent que moi, c'est\nm[UNI00ea]me pas la peine d'insister."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Tiens, on va voir ! Cours jusqu'au\nbateau sur le lac et reviens. Mon<page>record est de 2 minutes 1 seconde.\nSi tu es plus lent que [UNI00e7]a,\npas la peine d'insister."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "Alors, tu veux essayer ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	npc_dialogue.offer_boat_run(npc_character, player_character)
end

--- Has the moon-loving villager say a moon must exist where the player goes and explain that a photo of the moon would convince him.
function npc_dialogue.explain_moon_photo_condition(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Je veux bien venir avec toi,\nmais y aura-t-il une lune l[UNI00e0]-bas ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "C'est vrai ? Dois-je te croire sur\nparole. Les hommes mentent parfois.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "En fait, j'ai chang[UNI00e9] d'avis. Je\nvais attendre que la lune se\nmontre ici.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]C'est peut-[UNI00ea]tre li[UNI00e9] [UNI00e0] son histoire\n   pass[UNI00e9]e... Quoi qu'il en soit, Rufio\n   ne fait pas confiance aux hommes."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Il faut que Rufio te croie.\n   Si tu lui donnes une photo\n   de la lune, [UNI00e7]a marchera peut-[UNI00ea]tre."
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
	event.open_message_window_2(0, "Salut ! Tu es la copine de\nMax ?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Tes cheveux ont une couleur tr[UNI00e8]s\noriginale. Je les trouve<page>magnifiques, ils brillent\ncomme des bijoux."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.finish_event()
end

--- Plays the remark about the ailing tree and the hint that Monica must talk to Gordon to get his attention.
function npc_dialogue.hint_talk_to_gordon(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_slot, "立ち")
	event.open_message_window_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Apparemment il faut parler [UNI00e0]\n   Gordon pour attirer son attention.")
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
	event.open_message_window_2(0, "Oui, je vais essayer.\nJe n'en suis pas capable.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "OK...<page>OK, si tu veux r[UNI00e9]essayer plus tard,\nfais-le moi savoir. Je serai ici.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "[UNI00c0] vos marques, pr[UNI00ea]t,\npartez !")
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
		event.open_message_window_2(0, "Tel poisson, tel ma[UNI00ee]tre, para[UNI00ee]t-il.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Pas question que je parle au \npropri[UNI00e9]taire d'un poisson si nul.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"J'ai bien regard[UNI00e9], tu sais.\nC'[UNI00e9]tait une course superbe.<page>Je ne pense pas que j'aurais pu\ndresser un aussi bon poisson.<page>Tu peux m'emmener avec toi et\nm'apprendre tout ce que tu sais ?"
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
		event.open_message_window_2(0, "Oh ! Tu m'as trouv[UNI00e9]e !<page>Mais y arriveras-tu encore ?")
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
		"Oh ! Tu m'as trouv[UNI00e9]e...<page>Je commence [UNI00e0] en avoir assez.<page>Se cacher, en fait, c'est\nplut[UNI00f4]t ennuyeux.<page>Bon ! Allez, on part [UNI00e0]\nl'aventure !"
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
	event.open_message_window_2(0, "Qu'est-ce que tu as dit ?<page>Peux-tu parler plus lentement?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Saisis : "Partons ensemble."', "Partons ensemble.", 0)
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
		event.open_message_window_2(0, "Que veux-tu dire par l[UNI00e0] ?\nJe n'y comprends rien...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Une aventure ?\n[UNI00c7]a me tenterait bien...<page>Mais [UNI00e0] quoi pourrait servir\nune vieille femme comme moi ?"
	)
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
	event.open_message_window_2(0, "Tu as trouv[UNI00e9] des marrons ?")
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
		event.open_message_window_2(
			0,
			"Alors, tu ne peux pas m'aider...<page>Tant pis, je ne ferai pas\nde castagnaccio, voil[UNI00e0] tout."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oui, c'est [UNI00e7]a ! Merci beaucoup ! Je<page>vais pouvoir faire un castagnaccio.<page>Je te ferai go[UNI00fb]ter si tu veux."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Comment te remercier... ?<page>Quoi, te suivre dans une aventure ?<page>Ha ha ! Mais bien s[UNI00fb]r...<page>Il fallait le dire tout de suite."
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
			"Je te croyais diff[UNI00e9]rent, mais non,\nles hommes sont les hommes.<page>Peu importe, je suis habitu[UNI00e9] [UNI00e0] ce\nqu'on me raconte des mensonges."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Il y a une lune sur cette photo !<page>Je pourrai la voir quand je veux !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Venir avec toi ?<page>Mais oui, bien s[UNI00fb]r.\nJe n'ai nulle part ailleurs o[UNI00f9]\naller."
	)
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
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if fish_length < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(fish_length * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Parle autant que tu veux !")
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
			"Quoi ? Ah, les pi[UNI00e8]ces de monnaie ?<page>Je cherche la Pi[UNI00e8]ce de sacrifice\net la Pi[UNI00e8]ce de solidit[UNI00e9].<page>Tu ne les trouveras jamais, j'ai\nd[UNI00e9]j[UNI00e0] cherch[UNI00e9] partout."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Quoi ? Tu les as ? Incroyable !<page>Allez vite, donne-les-moi !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Bon.\nQu'est-ce que je dois faire ?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Aaah ! Si tu me casses les pieds,\nje ne t'aiderai certainement pas.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Ouaah, je les ai toutes !\nJe n'y croyais plus...<page>Bon, je n'ai plus le choix hein ?\nJe vais venir avec toi !"
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
	event.open_message_window_2(
		0,
		"J'aimerais bien t'aider, mais j'ai\ntr[UNI00e8]s peur de me battre et je\nrisquerais de me salir."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Et j'ai horreur d'[UNI00ea]tre un poids\npour les autres. D[UNI00e9]sol[UNI00e9]e, mais...\nje vais devoir dire non."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Il y a plein de trucs bizarres\nhors de la ville, je parie !<page>Je me demande comment sont les\narbres, et quelles fleurs il y a."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Si tu vois une fleur [UNI00e9]trange, tu\npeux la prendre en photo pour moi\nMax ? J'aimerais tant en voir une."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Elle a dit non cette fois-ci, mais\n   si tu lui montres une photo qui\n   l'int[UNI00e9]resse, elle capitulera s[UNI00fb]rement."
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
		event.open_message_window_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "H[UNI00e9] Max.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Personne ne peut dessiner la vie.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
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
		"Tu devrais conna[UNI00ee]tre ma r[UNI00e9]ponse [UNI00e0]\n[UNI00e7]a : PAS QUESTION !<page>C'est pas mon genre de travailler\npour le compte des autres !"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00c7]a ne m'apporte pas grand-chose et\nen plus, c'est trop dangereux.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mais puisque c'est toi, je pense\nque je vais y r[UNI00e9]fl[UNI00e9]chir.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mais bon, je suis fils de\ncommer[UNI00e7]ant et chez nous, rien\nn'est gratuit.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je collectionne les pi[UNI00e8]ces de<page>monnaie, le symbole du commerce. Et\nje r[UNI00ea]ve de compl[UNI00e9]ter ma collection."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais je n'arrive pas [UNI00e0] mettre la\nmain sur la Pi[UNI00e8]ce de sacrifice et\nla Pi[UNI00e8]ce de Solidit[UNI00e9].<page>Si tu les trouves pour moi, je\nt'aiderai peut-[UNI00ea]tre [UNI00e0] mon tour."
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
		"Tu veux que je\nvienne avec toi ?<page>Je ne suis qu'une femme qui fait\ndu pain, mais si je peux t'aider,\nje le ferai avec plaisir."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Oh, mais d'abord, j'ai quelque chose\n[UNI00e0] faire livrer [UNI00e0] Morton.<page>[UNI00c7]a t'emb[UNI00ea]terait d'emporter pour moi\n20 pains [UNI00e0] son magasin ?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Pendant ce temps-l[UNI00e0], je vais\nfaire mes bagages pour le voyage.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Je me demande ce qu'il peut bien\nvouloir faire avec 20 pains ?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- The fisherman says Firbits only help those better than them, boasts of his fish knowledge, hints at the fish race beginner class and starts request 16.
function npc_dialogue.start_fisherman_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Personnellement, je m'y connais\nen poissons.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"J'ai entendu dire que des hommes\norganisaient un concours o[UNI00f9]\ns'affrontaient leurs poissons.<page>Si tu en as un, pourquoi ne pas\nessayer de finir premier ?<page>Si tu [UNI00e9]choues, je saurais que tu \nne m[UNI00e9]rites pas mon aide."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Il doit s'agir de la Course de poissons.\n   Pourquoi ne pas tenter la cat[UNI00e9]gorie\n   D[UNI00e9]butants ? Elle t'aidera peut-[UNI00ea]tre."
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
	event.open_message_window_2(0, "D'apr[UNI00e8]s C[UNI00e9]dric,\ntu es toujours tr[UNI00e8]s\nactif en ce moment.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Tu es dou[UNI00e9] dans plein de domaines,<page>mais d'un autre c[UNI00f4]t[UNI00e9], tu ne\ntermines jamais rien."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Alors quand tu demandes de\nl'aide, j'ai un peu de mal [UNI00e0]\nte prendre au s[UNI00e9]rieux."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Je sais ! Essaie de transformer ce\npistolet trompette en pistolet cloche !<page>Tu crois que tu peux y arriver ?"
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
		"[(!)]Pour que G[UNI00e9]rald t'aide,\n   tu vas devoir lui rapporter\n   un pistolet cloche.<page>[(!)]Tu peux d[UNI00e9]velopper l'arme qu'il t'a\n   donn[UNI00e9]e, en acheter une ou en rapporter\n   une trouv[UNI00e9]e dans les d[UNI00e9]dales."
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
		"Je ne suis pas tr[UNI00e8]s en forme.<page>Je ne peux pas partir en voyage.<page>Le Dr Dell est venu me voir, mais\nil m'a dit que tout allait bien."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Pourtant, quand je suis debout, j'ai\nl'impression que je vais tomber.<page>C'est dur [UNI00e0] expliquer. C'est un peu\ncomme si le monde avait [UNI00e9]t[UNI00e9] d[UNI00e9]form[UNI00e9]."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(
			0,
			"Mmm... Si le Dr Dell ne sait pas ce\nqui ne va pas, je ne vois pas bien\nce que je peux faire moi-m[UNI00ea]me..."
		)
		message.say_bubble(0, -1, player_slot, npc_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00c7]a me rappelle quelque chose.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"[UNI00c0] l'[UNI00e9]poque o[UNI00f9] je suis n[UNI00e9], le\nmonde [UNI00e9]tait dans un [UNI00e9]tat d[UNI00e9]plorable,\navec un nombre incalculable de\ndistorsions temporelles."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Cela avait un impact sur les gens\n[UNI00e0] la sant[UNI00e9] fragile.<page>Les plus l[UNI00e9]gers avaient le tournis\net les plus lourds ne tenaient\nplus debout."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Tu es peut-[UNI00ea]tre particuli[UNI00e8]rement\nsensible [UNI00e0] ce genre de chose.<page>M[UNI00ea]me les rares distorsions qu'on\na ici suffisent [UNI00e0] t'affecter."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Si on pouvait [UNI00e9]liminer les plus\nproches d'entre elles, tu te\nsentirais peut-[UNI00ea]tre mieux."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Comment [UNI00e9]liminer une distorsion...\n   Le Spheda ! Termine environ 10 niveaux\n   et Mena ira peut-[UNI00ea]tre mieux."
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
		max_concern.chat_about_max(npc_slot, player_slot)
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
		npc_chatter.talk_tailor_done(npc_slot, player_slot)
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
		palm_brinks_villagers.explain_firbit_favours(npc_slot, player_slot)
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
		npc_dialogue.chat_podium_dream(npc_slot, player_slot)
		return
	end
end

--- Chooses the fisherman's dialogue from the state of the main request and his own quest request. It uses quest request 15.
function npc_dialogue.talk_to_fisherman_by_request_15(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_fishing_hobby(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_nonky_challenge(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_nonky_catch(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_fishing_spots(npc_character, player_character)
		return
	end
end

--- Routes Gordon's conversation by story flag and the status of request 0.
function npc_dialogue.talk_to_gordon(npc_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local request_status: s32 = 0
	story_flag = event.get_save_flag(42) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status == 0 then
		villager_dialogue.start_gordon_quest(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_gordon_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_slot, player_slot)
		return
	end
end

--- Routes the grandmother's conversation by request 0 and 19 status.
function npc_dialogue.talk_to_grandmother(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_hard_of_hearing(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 19) or request_status
	if request_status == 0 then
		npc_dialogue.recruit_hard_of_hearing_woman(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_grandmother(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_old_woman_ends_of_earth(npc_slot, player_slot)
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
		event.open_message_window_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "H[UNI00e9], Max.<page>Comment tu fais pour toujours\navoir l'air en forme ?!")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Chooses the unwell villager's dialogue from the story flag and the state of the matching quest request.
function npc_dialogue.talk_to_unwell_villager(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_sick_villager(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 17) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_mena_request(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_mena_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_bug_averse_villager(npc_character, player_character)
		return
	end
end

return npc_dialogue
