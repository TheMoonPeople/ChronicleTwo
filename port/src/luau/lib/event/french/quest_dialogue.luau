--!strict
--- Holds the French quest dialogue events for requests, recruits and request-progress routing.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local npc_recruit = vm.module("@lib/event/french/npc_recruit")
local palm_brinks_quests = vm.module("@lib/event/french/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")

local quest_dialogue = {}

--- Plays the scene where the tailor hands over her first finished garment and joins the party.
function quest_dialogue.receive_tailor_garment(npc: s32, player: s32)
	local garment_item: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
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
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
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
	event.open_message_window_2(
		0,
		"Je ferai de mon mieux pour t'aider\nsi tu as besoin de quoi que ce<page>soit. Pas de probl[UNI00e8]me."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Je ne sais pas si tu peux<page>m'aider... Mais [UNI00e9]coute bien [UNI00e7]a.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Je travaille dur depuis pr[UNI00e8]s de 30\nans dans cette maison.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Je consacre tout mon temps libre\n[UNI00e0] mon seul et unique passe-temps,\nla lecture.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Un livre extr[UNI00ea]mement rare et\npr[UNI00e9]cieux est [UNI00e0] vendre aux ench[UNI00e8]res\nen ce moment."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Tout le monde se bat pour l'avoir.\nJe pense qu'une somme d'environ\n1000 Gildas devrait suffire."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Mais je n'ai pas une telle somme,\net mon ma[UNI00ee]tre serait outr[UNI00e9] si je\nlui demandais de me la pr[UNI00ea]ter."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Alors tu es mon seul espoir.<page>[UNI00c7]a ne veut pas dire que si tu ne\npeux pas m'aider, je ne ferai rien pour toi."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Malgr[UNI00e9] ses dires, Stewart ne t'aidera\n   s[UNI00fb]rement pas, sauf pour 1000 Gildas.\n   Bref, il va falloir trouver de l'argent."
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
	event.open_message_window_2(0, "Tu veux que je te rende service ?<page>Alors, [UNI00e9]coute-moi.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Pour cela, tu devras gagner mon<page>respect. Et je ne respecte que\nceux qui ont d[UNI00e9]j[UNI00e0] attrap[UNI00e9] de\nplus gros poissons que moi."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Le plus gros poisson que j'aie\nattrap[UNI00e9] [UNI00e9]tait un Nonky de 60 cm.<page>[UNI00c7]a t'impressionne ?\nSi le d[UNI00e9]fi te tente, je t'offre de\nte mesurer [UNI00e0] moi quand tu veux !"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Il semble que le seul moyen de le\n   faire venir soit de p[UNI00ea]cher un Nonky\n   de plus de 60 cm. Tu peux y arriver !"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Enfin, essaie d'aller p[UNI00ea]cher\n   dans le lac de Palm Brinks.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Has the mayor ask the player to work out his forgotten safe combination, then starts that request.
function quest_dialogue.request_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player, npc)
	event.open_message_window_2(0, "Ronchonnements...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	character.face_toward(npc, player)
	event.set_character_motion(npc, "会話")
	event.open_message_window_2(
		0,
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
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
	event.open_message_window_2(
		0,
		"Tu es Monica,\nc'est [UNI00e7]a ?<page>J'ai entendu dire que tu te\nd[UNI00e9]brouillais plut[UNI00f4]t bien [UNI00e0] l'[UNI00e9]p[UNI00e9]e."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Mais les [UNI00e9]p[UNI00e9]es ne sont\npas des jouets, tu sais.<page>Il faut faire preuve de jugeote\nface [UNI00e0] l'ennemi."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] faire [UNI00e9]voluer\nune [UNI00e9]p[UNI00e9]e de 2 niveaux, tu\nm'auras convaincue de ton talent."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Pourquoi ne pas commencer\navec ce Gladius ?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pour que Milane t'aide, il va\n   falloir faire [UNI00e9]voluer le\n   Gladius de 2 niveaux."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux aussi acheter ou r[UNI00e9]cup[UNI00e9]rer des\n   armes. Il te suffit de te procurer une\n   arme puissante et Milane t'aidera."
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
		"Oui, si j'essaie [UNI00e0] nouveau et je\ntermine quelque chose, peut-[UNI00ea]tre\nretrouverai-je confiance en moi."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Mais j'ai pas les mat[UNI00e9]riaux<page>n[UNI00e9]cessaires. Pourrais-tu te les\nprocurer pour moi ?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Il me faut du tissu r[UNI00e9]sistant,\ndu cuir [UNI00e9]pais et un morceau\nde cuivre.")
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
		palm_brinks_villagers.talk_customer_trust(npc, player)
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
		npc_dialogue.chat_about_bread(npc, player)
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
		event.open_message_window_2(0, "Oh, tu aides\nPolly ?<page>Super.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Ce que je vais faire\navec ces 20 pains ?<page>Eh bien, j'ai organis[UNI00e9] une soir[UNI00e9]e\nfondue savoyarde pour ce soir."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Pour l'\"inventeur\" que tu es,\nc'est une combinaison culinaire<page>de fromage, de pain et de vin !"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"C'est super bon. On en mange tant\nqu'il faut des tonnes de pain.<page>Mais je ne voulais pas\nqu'il soit livr[UNI00e9] ici."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"D[UNI00e9]sol[UNI00e9] Max, mais tu pourrais\nl'emporter chez moi ?<page>Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_stage == 1 then
		event.open_message_window_2(0, "Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles.")
		message.say_bubble(0, -1, npc, player, 0)
	end
	if delivery_stage == 2 then
		event.open_message_window_2(0, "Annul[UNI00e9]e ?!\nComme c'est dommage !")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Dans ce cas, je n'ai plus besoin\nde pain. Tu pourrais le rapporter\n[UNI00e0] Polly ?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_stage == 3 then
		event.open_message_window_2(0, "D[UNI00e9]sol[UNI00e9], mais tu peux rapporter\nle pain [UNI00e0] Polly pour moi ?")
		message.say_bubble(0, -1, npc, player, 0)
	end
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Picks the resident's conversation from the progress of the mayor's safe combination request, speaking an idle line before the requests open.
function quest_dialogue.talk_by_request_status(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_quests.mutter_safe_combination(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 12) or request_status
	if request_status == 0 then
		npc_recruit.explain_safe_problem(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.open_mayor_safe(npc_character, player_character)
		return
	end
	if request_status == 2 then
		villager_dialogue.warn_about_zelmite_mine(npc_character, player_character)
		return
	end
end

--- Routes the candy maker conversation by playable character and request progress.
function quest_dialogue.talk_candy_maker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_candy_maker_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		villager_dialogue.talk_about_cooking(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 3) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_chestnuts(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_chestnut(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_candy_maker_done(npc, player)
		return
	end
end

--- Routes the gun fighter conversation by playable character and request progress.
function quest_dialogue.talk_gun_fighter(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_gun_fighter_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_mining_advice(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_gerald_request(npc, player)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_gun_for_recruit(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_villager_16_as_monica(npc, player)
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
		npc_chatter.talk_hide_and_seek_hider_done(npc, player)
		return
	end
end

--- Routes the mayor conversation by request progress.
function quest_dialogue.talk_mayor(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_muttering_numbers(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_safe_combination(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_safe_code_request(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.warn_about_zelmite_mine(npc, player)
		return
	end
end

--- Routes the painter conversation by request progress.
function quest_dialogue.talk_painter(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_golden_paint(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_parn_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_new_power(npc, player)
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
			"Qu'est-ce qui se passe ?\nTu baisses encore les bras ?<page>Tu me d[UNI00e9][UNI00e7]ois.\nC'est [UNI00e0] [UNI00e7]a que [UNI00e7]a m[UNI00e8]ne de bricoler\ndes machines [UNI00e0] longueur de journ[UNI00e9]e ?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh ! On dirait que tu commences\n[UNI00e0] t'y conna[UNI00ee]tre en armes aussi !<page>Il suffit de voir comment tu les\ntiens pour s'en rendre compte..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"OK, je vais t'aider.\nMais je ne le fais pas pour toi.<page>Si cette ville est en danger,\nje ne peux pas rester assis\nici [UNI00e0] me tourner les pouces."
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

return quest_dialogue
