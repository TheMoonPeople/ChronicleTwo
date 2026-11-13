--!strict
--- Dialogue and scripted conversations of the Palm Brinks townspeople in the French version of the game.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local party = vm.module("@lib/event/party")
local party_recruit = vm.module("@lib/event/french/party_recruit")
local quest_dialogue = vm.module("@lib/event/french/quest_dialogue")
local swordsmith = vm.module("@lib/event/french/swordsmith")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local palm_brinks_villagers = {}

--- Explains that the Firbit people only grant favours to those who are better than themselves.
function palm_brinks_villagers.explain_firbit_favours(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Runs the request in which a villager asks for escalating sums of Gilda for an auction bid and returns 600 Gilda after winning it.
function palm_brinks_villagers.lend_auction_money(character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local handover_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	auction_stage = event.get_save_counter(9) or auction_stage
	money = event.get_money() or money
	if auction_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"[UNI00c7]a n'est pas assez pour que je\npuisse remporter les ench[UNI00e8]res.<page>Il me faut 1000 Gildas. Je t'en\nprie, trouve-les !"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"Tu ne vas pas le croire !<page>L'ench[UNI00e8]re est mont[UNI00e9]e [UNI00e0]\n1200 Gildas."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.open_message_window_2(
				0,
				"Je suis vraiment d[UNI00e9]sol[UNI00e9], mais tu\nne pourrais pas te procurer\n1500 Gildas ?"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 1500 Gildas !"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"C'est terrible ! Quelqu'un est\npr[UNI00ea]t [UNI00e0] payer 1800 Gildas !<page>Si je ne surench[UNI00e9]ris pas avec 2000\nGildas, je n'aurai pas le livre."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 2000 Gildas !"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Fiston, tu as r[UNI00e9]ussi [UNI00e0] rassembler\nmes 2000 Gildas ?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.set_character_motion(character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(
			0,
			"Ben oui. Ils sont [UNI00e0] toi.\nM[UNI00ea]me si j'ai l'impression que\nc'est du g[UNI00e2]chis."
		)
		handover_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if handover_choice ~= 0 then
			event.open_message_window_2(
				0,
				"Mmm... 2000 Gildas, c'est beaucoup.\n[UNI00c7]a doit [UNI00ea]tre dur de s'en s[UNI00e9]parer.\nM[UNI00ea]me pour un gar[UNI00e7]on ais[UNI00e9] comme toi.<page>Tr[UNI00e8]s bien, tant pis ! Mais l'ench[UNI00e8]re\nn'est pas encore termin[UNI00e9]e.\nJ'attendrai le temps qu'il faudra."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Merci de tout c[UNI0153]ur.<page>Je file aux ench[UNI00e8]res !")
		message.say_bubble(0, -1, character, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, character)
		event.set_character_active(0, character)
		event.delete_villager(character)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Merci de tout c[UNI0153]ur.\nMa surench[UNI00e8]re a r[UNI00e9]ussi.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Les autres acheteurs potentiels ont\nvite abandonn[UNI00e9] et j'ai eu le livre\npour 1400 Gildas !"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Je peux donc t'en rendre 600.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(
		0,
		"Et maintenant, je vais travailler\ndur pour rembourser le reste de\nla somme que je t'ai emprunt[UNI00e9]e."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je sais que tu t'es d[UNI00e9]men[UNI00e9] pour\nmoi. Je te rendrai la pareille\nquand tu voudras."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Invites the player to bring any problem to the villager first.
function palm_brinks_villagers.offer_help_with_problems(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Quel que soit ton probl[UNI00e8]me,\nn'h[UNI00e9]site pas [UNI00e0] venir me voir\nen premier.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Greets the shopkeeper that was talked to, then opens that shop's menu once the conversation ends.
function palm_brinks_villagers.open_shop_after_greeting()
	local npc_type: s32 = 0
	local npc_character: s32 = 0
	local baker_greeted: s32 = 0
	local weapon_shop_greeted: s32 = 0
	local priest_greeted: s32 = 0
	print("IN go_shop_up()\n")
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	npc_character = event.get_triggered_event_data_2(13) or npc_character
	print("talk_chara=", npc_type, "talk_chara_id=", npc_character, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bienvenue.")
	if npc_type == 18 then
		event.open_message_window_2(
			0,
			"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
		)
	end
	if npc_type == 4 then
		event.open_message_window_2(
			0,
			"[UNI00c7]a travaille dur, je vois ?\nIl te faut quelque chose ?<page>Ah mais, rien n'est gratuit.\nPas m[UNI00ea]me pour toi, Max."
		)
	end
	if npc_type == 34 then
		event.open_message_window_2(
			0,
			"Il te faut plus d'[UNI00e9]l[UNI00e9]ments de\nG[UNI00e9]orama ?<page>Si tu n'as pas le temps d'aller en\nchercher toi-m[UNI00ea]me, peut-[UNI00ea]tre que\nl'argent r[UNI00e9]soudra tes probl[UNI00e8]mes."
		)
	end
	if npc_type == 1012 then
		baker_greeted = event.get_save_flag(45) or baker_greeted
		if baker_greeted == 0 then
			event.open_message_window_2(
				0,
				"Bonjour, je suis apprentie boulang[UNI00e8]re\net je m'occupe de la boulangerie\npendant l'absence de Polly.<page>Je suis un peu nerveuse, mais [UNI00e7]a\npassera avec l'exp[UNI00e9]rience, je\nsuppose. Je ferai de mon mieux !"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_type == 1015 then
		weapon_shop_greeted = event.get_save_flag(46) or weapon_shop_greeted
		if weapon_shop_greeted == 0 then
			event.open_message_window_2(
				0,
				"On se ressemble peu mais...\nJe suis la petite s[UNI0153]ur de Milane.<page>Je tiens le magasin pendant son absence.\nEt je suis archi-nulle en armes !"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_type == 1018 then
		priest_greeted = event.get_save_flag(47) or priest_greeted
		if priest_greeted == 0 then
			event.open_message_window_2(
				0,
				"Tu ne t'y attendais pas ? N'importe\nqui serait surpris de voir ici un\nindividu habill[UNI00e9] de cette mani[UNI00e8]re.<page>Je suis bon ami avec le P[UNI00e8]re Bruno.\nJe le remplace pendant son voyage.\nAlors, que puis-je faire pour toi ?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
			)
		end
	end
	if npc_character ~= -1 then
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_type == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_type == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_type == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_type == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_type == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_type == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_type == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_type == 1018 then
		menu.open_type_6_alt(37)
	end
end

--- Has the seamstress decline to join the party for lack of confidence and registers request 7 to restore it.
function palm_brinks_villagers.request_adel_confidence(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(
		0,
		"Je vois... J'aimerais vraiment\npouvoir t'aider.\nTu le sais.<page>Mais je n'ai vraiment pas\nassez confiance en moi."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"J'abandonne toujours tout [UNI00e0] mi-\nchemin, je n'ai jamais rien fini.<page>J'ai toujours voulu devenir\ncouturi[UNI00e8]re, mais je n'ai jamais\ntermin[UNI00e9] un seul v[UNI00ea]tement."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Si je venais avec toi,\nje ne ferais que t'emb[UNI00ea]ter.<page>Alors, d[UNI00e9]sol[UNI00e9]e, mais c'est non."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh non, Ad[UNI00e8]le a perdu toute\n   confiance en elle. C'est un probl[UNI00e8]me.\n   Faisons-lui faire de nouveaux habits."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Asks the player to find Chestnuts for the Castagnaccio sweet and registers the request.
function palm_brinks_villagers.request_chestnuts(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Ah, tu arrives bien !\nJe voulais te parler de quelque\nchose.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Tu sais s[UNI00fb]rement que je cherche\ntoujours [UNI00e0] d[UNI00e9]couvrir de nouvelles\np[UNI00e2]tisseries venues du monde entier.\n"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "On m'a parl[UNI00e9] d'un g[UNI00e2]teau appel[UNI00e9]\ncastagnaccio...")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Confectionn[UNI00e9] [UNI00e0] base de castarnas.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"J'ai appris que ces castarnas\npoussaient sur des arbres de la\nfamille des ch[UNI00e2]taigniers."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Alors j'ai pens[UNI00e9] essayer la recette\navec des marrons, mais bizarrement,\nil n'y a plus un marron en ville."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Il para[UNI00ee]t que le Maire les a tous\nachet[UNI00e9]s... Tu ne pourrais pas\nm'aider ?")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Poses the church candle puzzle to the player and registers request 13.
function palm_brinks_villagers.request_extinguish_candles(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(
		0,
		"Vraiment ? Tu as besoin de mon<page>aide ? Alors laisse-moi t'exposer\nun petit probl[UNI00e8]me."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Les bougies de cette [UNI00e9]glise sont\ncontr[UNI00f4]l[UNI00e9]es par un petit m[UNI00e9]canisme.<page>Il [UNI00e9]teint les bougies allum[UNI00e9]es,\net allume les bougies [UNI00e9]teintes.<page>Si l'une d'entre elles change, les\nbougies adjacentes changent aussi."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] [UNI00e9]teindre toutes\nles bougies, je viendrai.<page>J'en serais tr[UNI00e8]s content ! Sinon,\nje ne viendrai pas."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Une petite [UNI00e9]nigme. Essaie une ou\n   deux fois, et sers-toi de ce que ces\n   petites exp[UNI00e9]riences t'auront appris."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Si tu rentres [UNI00e0] nouveau dans l'[UNI00e9]glise,\n   les bougies seront r[UNI00e9]initialis[UNI00e9]es.\n   Alors n'aie pas peur de te tromper.\n   La r[UNI00e9]ponse peut [UNI00ea]tre tr[UNI00e8]s simple."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Has the Scoop Memo villager review the player's Scoop Memos, announcing new scoops, and returns nonzero when a reward can be claimed.
function palm_brinks_villagers.review_scoop_memos(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local memo_count: s32 = 0
	local collected_scoops: s32 = 0
	local total_scoops: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Va me chercher un\nM[UNI00e9]mo de scoops, tu veux bien ?")
			if current_map == 22 then
				resume_step = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			collected_scoops = out1 or collected_scoops
			total_scoops = out2 or total_scoops
		end
		if collected_scoops == total_scoops then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "On dirait qu'il n'y\na plus de scoops.")
			if current_map == 22 then
				resume_step = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
			resume_step = 5
			return npc_chatter.explain_photography_scoops(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "J'ai trouv[UNI00e9] [Number1] nouveau(x) scoop(s).")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(window, "Allez ! Arr[UNI00ea]te de lambiner !\nIls sont o[UNI00f9] tes super scoops ?")
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Ouah ! Tu as [Number1] nouveau(x)\nscoop(s) ! Je savais que tu y\narriverais.")
		end
		if current_map == 22 then
			resume_step = 7
			message.say_bubble(window, -1, npc_character, player_character, 0)
		else
			resume_step = 8
			message.show(window, -1, 3, 256, 208)
		end
		resume_step = 9
		return npc_chatter.explain_photography_scoops(window)
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_step <= 9 then
			if resume_step <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_step <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Remarks on the player's trips out of town, or hands over to the girl's greeting when the playable character is the girl.
function palm_brinks_villagers.talk_about_leaving_town(character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Tu as quitt[UNI00e9] la ville r[UNI00e9]cemment,\nnon, Max ?<page>Ne dis pas le contraire.\nJe le sais."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the remark that Max is hardly ever seen since the player arrived.
function palm_brinks_villagers.talk_about_max_absence(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Depuis ton arriv[UNI00e9]e, j'ai\n[UNI00e0] peine vu Max. Je ne sais pas\n[UNI00e0] quoi tu t'amuses, mais j'esp[UNI00e8]re<page>que tu ne te sers pas de lui."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the baker's remark about the girl travelling with Max, with a different line in chapter 8.
function palm_brinks_villagers.talk_baker_about_max(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"C'est toi la fille qui tra[UNI00ee]ne\navec Max depuis quelque temps.<page>Je sais reconna[UNI00ee]tre une personne de\nvaleur quand j'en rencontre une."
		)
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Si j'[UNI00e9]tais un peu plus jeune, je\nne le laisserais pas partir.")
	else
		event.open_message_window_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Plays the villager's remark about joining the player while avoiding bugs, with a railroad line in chapter 8.
function palm_brinks_villagers.talk_bug_averse_villager(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Tu m'as aid[UNI00e9]e, je le ferai donc\naussi, mais piti[UNI00e9], ne m'emm[UNI00e8]ne pas\ndans un endroit plein d'insectes !"
		)
	else
		event.open_message_window_2(
			0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the church candle puzzle giver from the progress of the main request chain and of request 13.
function palm_brinks_villagers.talk_candle_puzzle_giver(character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_extinguish_candles(character, player_character)
		return
	end
	if request_status == 1 then
		party_recruit.recruit_partner(character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(character, player_character)
		return
	end
end

--- Plays the shopkeeper's remark about the importance of customer trust.
function palm_brinks_villagers.talk_customer_trust(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"En affaires, il est essentiel de\ngagner la confiance de tes clients.<page>C'est quelque chose qu'il ne faut\njamais consid[UNI00e9]rer comme acquis."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the villager's complaint that the town is too peaceful to find work.
function palm_brinks_villagers.talk_peaceful_town(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Cette ville est tr[UNI00e8]s calme, du coup\nje n'ai pas de travail du tout.<page>[UNI00c9]videmment, je sais que c'est une\nbonne chose, mais quand m[UNI00ea]me..."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the request 9 giver from the playable character, the character's position and the progress of request 9.
function palm_brinks_villagers.talk_request_9_giver(character: s32, player_character: s32)
	local playable_character: s32 = 0
	local request_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.chat_about_swords(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_peaceful_town(character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_dialogue.chat_busy_with_materials(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 9) or request_status
	if request_status == 0 then
		npc_dialogue.explain_boat_run_test(character, player_character)
		return
	end
	if request_status == 1 then
		npc_dialogue.check_boat_run_time(character, player_character)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_about_speed(character, player_character)
		return
	end
end

--- Plays the sword enthusiast's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_sword_fan(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"L'[UNI00e9]clat d'une [UNI00e9]p[UNI00e9]e forg[UNI00e9]e\npar un ma[UNI00ee]tre est magnifique.<page>[UNI00c0] couper le souffle."
		)
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(
			0,
			"Je n'arrive pas [UNI00e0] comprendre\ncomment on peut [UNI00ea]tre heureux [UNI00e0]\npolir des cailloux."
		)
	else
		event.open_message_window_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Starts the conversation with a villager by dispatching on the villager's character type to that villager's own dialogue.
function palm_brinks_villagers.talk_to_npc(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_type: s32 = 0
	local current_submap: s32 = 0
	local state_flag: s32 = 0
	local shop_or_scoop_choice: any = 0
	local friend_or_scoop_choice: any = 0
	local request_0_status: s32 = 0
	local request_8_status: s32 = 0
	local greeting_choice: any = 0
	local request_0_status_2: s32 = 0
	local request_10_status: s32 = 0
	local greeting_choice_2: any = 0
	local request_0_status_3: s32 = 0
	local request_13_status: s32 = 0
	local greeting_choice_3: any = 0
	local request_8_status_2: s32 = 0
	local playable_character: s32 = 0
	local greeting_choice_4: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	chapter = event.get_chapter() or chapter
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	event.get_current_map()
	current_submap = event.get_current_submap() or current_submap
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, npc_character)
	if npc_type == 3 then
		npc_dialogue.talk_to_gordon(npc_character, player_character)
	end
	if npc_type == 5 then
		quest_dialogue.talk_painter(npc_character, player_character)
	end
	if npc_type == 4 then
		state_flag = event.get_save_flag(104) or state_flag
		if state_flag == 0 then
			event.open_message_window_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			shop_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if shop_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if shop_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				palm_brinks_villagers.open_shop_after_greeting()
			end
		else
			event.open_message_window_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			friend_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if friend_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if friend_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				villager_dialogue.talk_quest_2_villager(npc_character, player_character)
			end
		end
	end
	if npc_type == 7 then
		quest_dialogue.talk_candy_maker(npc_character, player_character)
	end
	if npc_type == 8 then
		villager_dialogue.talk_quest_4_villager(npc_character, player_character)
	end
	if npc_type == 10 then
		villager_dialogue.talk_quest_6_villager(npc_character, player_character)
	end
	if npc_type == 11 then
		npc_dialogue.talk_to_adel(npc_character, player_character)
	end
	if npc_type == 12 then
		request_0_status = event.get_quest_request_status(0, 0) or request_0_status
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if request_0_status == 2 and request_8_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			greeting_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice == 1 then
				quest_dialogue.talk_baker(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_baker(npc_character, player_character)
		end
	end
	if npc_type == 14 then
		palm_brinks_villagers.talk_request_9_giver(npc_character, player_character)
	end
	if npc_type == 15 then
		request_0_status_2 = event.get_quest_request_status(0, 0) or request_0_status_2
		request_10_status = event.get_quest_request_status(0, 10) or request_10_status
		if request_0_status_2 == 2 and request_10_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			greeting_choice_2 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_2 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_2 == 1 then
				swordsmith.start_conversation(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			swordsmith.start_conversation(npc_character, player_character)
		end
	end
	if npc_type == 16 then
		quest_dialogue.talk_gun_fighter(npc_character, player_character)
	end
	if npc_type == 17 then
		quest_dialogue.talk_mayor(npc_character, player_character)
	end
	if npc_type == 18 then
		request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if request_0_status_3 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			greeting_choice_3 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_3 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_3 == 1 then
				palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 33 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
		end
	end
	if npc_type == 19 then
		villager_dialogue.talk_quest_14_villager(npc_character, player_character)
	end
	if npc_type == 20 then
		npc_dialogue.talk_to_fisherman_by_request_15(npc_character, player_character)
	end
	if npc_type == 21 then
		npc_dialogue.talk_to_fisherman(npc_character, player_character)
	end
	if npc_type == 23 then
		npc_dialogue.talk_to_unwell_villager(npc_character, player_character)
	end
	if npc_type == 24 then
		quest_dialogue.talk_hide_and_seek_hider(npc_character, player_character)
	end
	if npc_type == 25 then
		npc_dialogue.talk_to_grandmother(npc_character, player_character)
	end
	if npc_type == 33 then
		request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_2 == 1 and playable_character == 0 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Je veux faire des achats\nBonjour")
			greeting_choice_4 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_4 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_4 == 1 then
				quest_dialogue.talk_bread_delivery_recipient(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		palm_brinks_villagers.open_shop_after_greeting()
	end
	if npc_type == 1 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.open_message_window_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.open_message_window_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.open_message_window_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.open_message_window_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.open_message_window_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc_character)
end

--- Starts the ordinary villager conversation when the talked-to character type is outside the special 100 to 1000 range.
function palm_brinks_villagers.talk_to_ordinary_villager()
	local npc_type: s32 = 0
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	if npc_type < 100 or 1000 < npc_type then
		npc_chatter.talk_to_villager()
	end
end

--- Thanks the player for the moon photo, with a line about the railroad in chapter 8.
function palm_brinks_villagers.thank_for_moon_photo(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Tu m'as donn[UNI00e9] cette photo de la\nlune. Tu es g[UNI00e9]n[UNI00e9]reux.")
	else
		event.open_message_window_2(
			0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

return palm_brinks_villagers
