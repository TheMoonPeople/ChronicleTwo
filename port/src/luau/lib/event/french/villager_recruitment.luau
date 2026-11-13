--!strict
--- Holds the French recruitment of the old woman villager into the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local max_concern = vm.module("@lib/event/french/max_concern")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local npc_recruit = vm.module("@lib/event/french/npc_recruit")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/french/palm_brinks_quests")
local palm_brinks_talk = vm.module("@lib/event/french/palm_brinks_talk")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/french/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_recruitment = {}

--- Prompts the player for the invitation phrase and recruits the old woman villager when it is entered correctly.
function villager_recruitment.ask_phrase_to_join(villager: s32, player_character: s32)
	local entry_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Qu'est-ce que tu as dit ?<page>Peux-tu parler plus lentement?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Saisis : "Partons ensemble."', "Partons ensemble.", 0)
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
		event.open_message_window_2(0, "Que veux-tu dire par l[UNI00e0] ?\nJe n'y comprends rien...")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Une aventure ?\n[UNI00c7]a me tenterait bien...<page>Mais [UNI00e0] quoi pourrait servir\nune vieille femme comme moi ?"
	)
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
				"[UNI00c7]a n'est pas assez pour que je\npuisse remporter les ench[UNI00e8]res.<page>Il me faut 1000 Gildas. Je t'en\nprie, trouve-les !"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"Tu ne vas pas le croire !<page>L'ench[UNI00e8]re est mont[UNI00e9]e [UNI00e0]\n1200 Gildas."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.open_message_window_2(
				0,
				"Je suis vraiment d[UNI00e9]sol[UNI00e9], mais tu\nne pourrais pas te procurer\n1500 Gildas ?"
			)
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 1500 Gildas !"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"C'est terrible ! Quelqu'un est\npr[UNI00ea]t [UNI00e0] payer 1800 Gildas !<page>Si je ne surench[UNI00e9]ris pas avec 2000\nGildas, je n'aurai pas le livre."
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 2000 Gildas !"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Fiston, tu as r[UNI00e9]ussi [UNI00e0] rassembler\nmes 2000 Gildas ?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(
			0,
			"Ben oui. Ils sont [UNI00e0] toi.\nM[UNI00ea]me si j'ai l'impression que\nc'est du g[UNI00e2]chis."
		)
		choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if choice ~= 0 then
			event.open_message_window_2(
				0,
				"Mmm... 2000 Gildas, c'est beaucoup.\n[UNI00c7]a doit [UNI00ea]tre dur de s'en s[UNI00e9]parer.\nM[UNI00ea]me pour un gar[UNI00e7]on ais[UNI00e9] comme toi.<page>Tr[UNI00e8]s bien, tant pis ! Mais l'ench[UNI00e8]re\nn'est pas encore termin[UNI00e9]e.\nJ'attendrai le temps qu'il faudra."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Merci de tout c[UNI0153]ur.<page>Je file aux ench[UNI00e8]res !")
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
	event.open_message_window_2(0, "Merci de tout c[UNI0153]ur.\nMa surench[UNI00e8]re a r[UNI00e9]ussi.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Les autres acheteurs potentiels ont\nvite abandonn[UNI00e9] et j'ai eu le livre\npour 1400 Gildas !"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je peux donc t'en rendre 600.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(
		0,
		"Et maintenant, je vais travailler\ndur pour rembourser le reste de\nla somme que je t'ai emprunt[UNI00e9]e."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Je sais que tu t'es d[UNI00e9]men[UNI00e9] pour\nmoi. Je te rendrai la pareille\nquand tu voudras."
	)
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
		event.open_message_window_2(0, "Oh ! Tu m'as trouv[UNI00e9]e !<page>Mais y arriveras-tu encore ?")
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
		"Oh ! Tu m'as trouv[UNI00e9]e...<page>Je commence [UNI00e0] en avoir assez.<page>Se cacher, en fait, c'est\nplut[UNI00f4]t ennuyeux.<page>Bon ! Allez, on part [UNI00e0]\nl'aventure !"
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
	event.open_message_window_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Personnellement, je m'y connais\nen poissons.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"J'ai entendu dire que des hommes\norganisaient un concours o[UNI00f9]\ns'affrontaient leurs poissons.<page>Si tu en as un, pourquoi ne pas\nessayer de finir premier ?<page>Si tu [UNI00e9]choues, je saurais que tu \nne m[UNI00e9]rites pas mon aide."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Il doit s'agir de la Course de poissons.\n   Pourquoi ne pas tenter la cat[UNI00e9]gorie\n   D[UNI00e9]butants ? Elle t'aidera peut-[UNI00ea]tre."
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
	event.open_message_window_2(
		0,
		"Tu es Monica,\nc'est [UNI00e7]a ?<page>J'ai entendu dire que tu te\nd[UNI00e9]brouillais plut[UNI00f4]t bien [UNI00e0] l'[UNI00e9]p[UNI00e9]e."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais les [UNI00e9]p[UNI00e9]es ne sont\npas des jouets, tu sais.<page>Il faut faire preuve de jugeote\nface [UNI00e0] l'ennemi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] faire [UNI00e9]voluer\nune [UNI00e9]p[UNI00e9]e de 2 niveaux, tu\nm'auras convaincue de ton talent."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Pourquoi ne pas commencer\navec ce Gladius ?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.add_inventory_item(44)
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pour que Milane t'aide, il va\n   falloir faire [UNI00e9]voluer le\n   Gladius de 2 niveaux."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux aussi acheter ou r[UNI00e9]cup[UNI00e9]rer des\n   armes. Il te suffit de te procurer une\n   arme puissante et Milane t'aidera."
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
	event.open_message_window_2(0, "Tu veux que je te rende service ?<page>Alors, [UNI00e9]coute-moi.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Pour cela, tu devras gagner mon<page>respect. Et je ne respecte que\nceux qui ont d[UNI00e9]j[UNI00e0] attrap[UNI00e9] de\nplus gros poissons que moi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Le plus gros poisson que j'aie\nattrap[UNI00e9] [UNI00e9]tait un Nonky de 60 cm.<page>[UNI00c7]a t'impressionne ?\nSi le d[UNI00e9]fi te tente, je t'offre de\nte mesurer [UNI00e0] moi quand tu veux !"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Il semble que le seul moyen de le\n   faire venir soit de p[UNI00ea]cher un Nonky\n   de plus de 60 cm. Tu peux y arriver !"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Enfin, essaie d'aller p[UNI00ea]cher\n   dans le lac de Palm Brinks.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Plays the villager's worry about a tree and hints that Gordon must be spoken to first.
function villager_recruitment.hint_talk_to_gordon(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Apparemment il faut parler [UNI00e0]\n   Gordon pour attirer son attention.")
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
		event.open_message_window_2(0, "On dirait que tu n'es pas tout\n[UNI00e0] fait assez bon pour l'instant.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(
			0,
			"Je suis s[UNI00fb]r que tu vas progresser,\nmais en attendant, j'ai bien peur\nde ne pouvoir coop[UNI00e9]rer avec toi."
		)
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Tu t'es bien d[UNI00e9]brouill[UNI00e9].\nMagnifique.<page>Je suis s[UNI00fb]r que tu sauras\nr[UNI00e9]pondre [UNI00e0] mes attentes.<page>Je t'ai fait une promesse...\nJe viens avec toi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Has the villager pose the church candle puzzle as the condition for joining the party.
function villager_recruitment.pose_candle_puzzle(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Vraiment ? Tu as besoin de mon<page>aide ? Alors laisse-moi t'exposer\nun petit probl[UNI00e8]me."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Les bougies de cette [UNI00e9]glise sont\ncontr[UNI00f4]l[UNI00e9]es par un petit m[UNI00e9]canisme.<page>Il [UNI00e9]teint les bougies allum[UNI00e9]es,\net allume les bougies [UNI00e9]teintes.<page>Si l'une d'entre elles change, les\nbougies adjacentes changent aussi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] [UNI00e9]teindre toutes\nles bougies, je viendrai.<page>J'en serais tr[UNI00e8]s content ! Sinon,\nje ne viendrai pas."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Une petite [UNI00e9]nigme. Essaie une ou\n   deux fois, et sers-toi de ce que ces\n   petites exp[UNI00e9]riences t'auront appris."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Si tu rentres [UNI00e0] nouveau dans l'[UNI00e9]glise,\n   les bougies seront r[UNI00e9]initialis[UNI00e9]es.\n   Alors n'aie pas peur de te tromper.\n   La r[UNI00e9]ponse peut [UNI00ea]tre tr[UNI00e8]s simple."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Gives the player one of three garments depending on which they already own, then recruits the tailor villager.
function villager_recruitment.receive_garment_and_join(villager: s32, player_character: s32)
	local item_id: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
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
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
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
		"Je vois... J'aimerais vraiment\npouvoir t'aider.\nTu le sais.<page>Mais je n'ai vraiment pas\nassez confiance en moi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"J'abandonne toujours tout [UNI00e0] mi-\nchemin, je n'ai jamais rien fini.<page>J'ai toujours voulu devenir\ncouturi[UNI00e8]re, mais je n'ai jamais\ntermin[UNI00e9] un seul v[UNI00ea]tement."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Si je venais avec toi,\nje ne ferais que t'emb[UNI00ea]ter.<page>Alors, d[UNI00e9]sol[UNI00e9]e, mais c'est non."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh non, Ad[UNI00e8]le a perdu toute\n   confiance en elle. C'est un probl[UNI00e8]me.\n   Faisons-lui faire de nouveaux habits."
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
	event.open_message_window_2(
		0,
		"J'aimerais bien t'aider, mais j'ai\ntr[UNI00e8]s peur de me battre et je\nrisquerais de me salir."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Et j'ai horreur d'[UNI00ea]tre un poids\npour les autres. D[UNI00e9]sol[UNI00e9]e, mais...\nje vais devoir dire non."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Il y a plein de trucs bizarres\nhors de la ville, je parie !<page>Je me demande comment sont les\narbres, et quelles fleurs il y a."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Si tu vois une fleur [UNI00e9]trange, tu\npeux la prendre en photo pour moi\nMax ? J'aimerais tant en voir une."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Elle a dit non cette fois-ci, mais\n   si tu lui montres une photo qui\n   l'int[UNI00e9]resse, elle capitulera s[UNI00fb]rement."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Plays the butler's request for money to bid on a rare book at auction.
function villager_recruitment.request_book_auction_funds(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Je ferai de mon mieux pour t'aider\nsi tu as besoin de quoi que ce<page>soit. Pas de probl[UNI00e8]me."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je ne sais pas si tu peux<page>m'aider... Mais [UNI00e9]coute bien [UNI00e7]a.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je travaille dur depuis pr[UNI00e8]s de 30\nans dans cette maison.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je consacre tout mon temps libre\n[UNI00e0] mon seul et unique passe-temps,\nla lecture.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Un livre extr[UNI00ea]mement rare et\npr[UNI00e9]cieux est [UNI00e0] vendre aux ench[UNI00e8]res\nen ce moment."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Tout le monde se bat pour l'avoir.\nJe pense qu'une somme d'environ\n1000 Gildas devrait suffire."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais je n'ai pas une telle somme,\net mon ma[UNI00ee]tre serait outr[UNI00e9] si je\nlui demandais de me la pr[UNI00ea]ter."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Alors tu es mon seul espoir.<page>[UNI00c7]a ne veut pas dire que si tu ne\npeux pas m'aider, je ne ferai rien pour toi."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Malgr[UNI00e9] ses dires, Stewart ne t'aidera\n   s[UNI00fb]rement pas, sauf pour 1000 Gildas.\n   Bref, il va falloir trouver de l'argent."
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
		event.open_message_window_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, villager, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "H[UNI00e9] Max.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, villager, 0)
	event.open_message_window_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Personne ne peut dessiner la vie.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
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

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 10, with a separate talk for Max.
function villager_recruitment.route_request_10_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		npc_chatter.talk_swordsmith_max(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_chatter.talk_swordsmith_shop(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		villager_recruitment.give_gladius_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_milane(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_sword_fan(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 14.
function villager_recruitment.route_request_14_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_moon_longing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		palm_brinks_quests.explain_moon_condition(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_rufio_with_moon_photo(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.thank_for_moon_photo(villager, player_character)
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
		npc_dialogue.chat_new_power(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 4.
function villager_recruitment.route_request_4_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_until_flower_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_flower_photos(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(villager, player_character)
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
		max_concern.chat_about_max(villager, player_character)
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
		npc_chatter.talk_tailor_done(villager, player_character)
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
		palm_brinks_villagers.talk_customer_trust(villager, player_character)
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
		npc_dialogue.chat_about_bread(villager, player_character)
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
		npc_dialogue.chat_about_swords(villager, player_character)
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
		npc_dialogue.chat_busy_with_materials(villager, player_character)
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
		villager_dialogue.talk_about_speed(villager, player_character)
		return
	end
end

return villager_recruitment
