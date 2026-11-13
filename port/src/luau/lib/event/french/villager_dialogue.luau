--!strict
--- French villager conversations triggered from the town and dungeon scripts.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/french/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_dialogue = {}

--- Plays Corinne's request to join the player, her hide-and-seek challenge and her disappearance.
function villager_dialogue.start_corinne_hide_and_seek(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.open_message_window_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Je parie que tu crois que je serai\ninutile parce que je suis une fille<page>alors qu'en fait, je porte chance\naux gens que je c[UNI00f4]toie."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Il ne pleut jamais quand je sors,\net je n'ai jamais vu un billet de\nloterie perdant.<page>Qu'est-ce que tu en penses ?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "D'accord.\nNon merci.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Pourquoi ? C'est injuste !\nT'es horrible !")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "T'es naze !<page>Imb[UNI00e9]cile !<page>Stupide !")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Tu m'emm[UNI00e8]neras avec toi ?<page>Je croyais pas que tu le ferais !")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais pourquoi je suis la seule qui\ndoive te le demander, alors que tu\nl'as demand[UNI00e9] [UNI00e0] tous les autres ?<page>Il suffisait de le demander pour\nque je vienne."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je sais, si tu arrives [UNI00e0] me\ntrouver, je t'aiderai. D'accord ?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Bref, on va jouer [UNI00e0] cache-cache !<page>Allez, on y va !")
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
		"[(!)]Bien... on dirait qu'il va falloir\n   retrouver Corinne. Elle se cache\n   s[UNI00fb]rement quelque part [UNI00e0] Palm Brinks."
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
		"Oh, Max ! Tu as l'air de tra[UNI00ee]ner\npas mal en ce moment. Tu te\nportes bien ?<page>Je peux faire quelque chose ?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ah bon ! Tu veux que je\nt'accompagne dans tes aventures ?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Mmm... J'aimerais bien venir avec\ntoi... Mais ce pauvre arbre ne va\npas tr[UNI00e8]s bien.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Soigner les arbres et les fleurs\nde cette propri[UNI00e9]t[UNI00e9] est ma grande\npriorit[UNI00e9], tu sais.<page>Si je pars me balader maintenant,\nje pourrais perdre mon travail."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Je parie que l'eau sacr[UNI00e9]e vendue [UNI00e0]\nl'[UNI00e9]glise soignerait cet arbre !<page>Mais, comme tu le sais, ton p[UNI00e8]re et\nP[UNI00e8]re Bruno ne s'entendent pas...<page>Ton p[UNI00e8]re ne me donnera jamais de\nsous pour acheter de l'eau sacr[UNI00e9]e !<page>J'ai un vrai probl[UNI00e8]me l[UNI00e0]."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Pour que Gordon aille [UNI00e0] Sindain,\n   tu dois le convaincre de venir\n   avec toi.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]R[UNI00e9]alise la mission de Gordon\n   et il montera dans le train pour\n   t'accompagner."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux consulter tes missions\n   en lisant ton carnet de notes,\n   situ[UNI00e9] dans le menu Objets."
	)
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]Oh, tu n'as pas de carnet.\n   Il y en a un sur la table\n   chez C[UNI00e9]dric, le r[UNI00e9]parateur."
		)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Il y en a un autre dans la\n   base secr[UNI00e8]te de Donny. Ils se valent.\n   R[UNI00e9]cup[UNI00e8]re l'un d'eux !"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Speaks a villager's lines about learning to cook.
function villager_dialogue.talk_about_cooking(villager: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Alors, tu as fait des trouvailles ?<page>Tu sais, pendant que tu d[UNI00e9]couvres\nles rouages des machines,\nmoi, je d[UNI00e9]couvre la cuisine.<page>Chaque jour, je me perfectionne\ndans l'art de faire des plats\nd[UNI00e9]licieux et totalement in[UNI00e9]dits."
	)
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's surprise at the player's speed, with different lines in chapter 8.
function villager_dialogue.talk_about_speed(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Tu es bien plus rapide\nque tu en as l'air.\nTu m'as surpris !")
	else
		event.open_message_window_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Chooses the villager's conversation from the progress of quest request 14, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_14_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_moon_longing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		npc_dialogue.explain_moon_photo_condition(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_moon_photo(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.thank_for_moon_photo(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 2, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_2_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_closed_shop(villager, player_character)
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

--- Chooses the villager's conversation from the progress of quest request 6, using a default talk until quest request 0 is complete, with a separate talk while Monica is playable.
function villager_dialogue.talk_quest_6_villager(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_book_servant_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.offer_help_with_problems(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_book_funds(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_villagers.lend_auction_money(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_unread_book(villager, player_character)
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

--- Speaks the villager of type 16's lines when Monica is the playable character, with different lines in chapter 8.
function villager_dialogue.talk_villager_16_as_monica(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Les armes ne sont pas des jouets.<page>Sois prudent quand tu t'en sers,\nou tu pourrais te blesser."
		)
	else
		event.open_message_window_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's reminder to sort trash and warning about the Zelmite Mine, with different lines in chapter 8.
function villager_dialogue.warn_about_zelmite_mine(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Pense [UNI00e0] bien trier tes d[UNI00e9]chets et\n[UNI00e0] les jeter les bons jours, OK ?"
		)
	else
		event.open_message_window_2(
			0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

return villager_dialogue
