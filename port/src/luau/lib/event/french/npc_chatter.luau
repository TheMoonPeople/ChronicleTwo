--!strict
--- Holds the French villager small talk and post-request chatter events.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")

local npc_chatter = {}

--- Answers the photo shop menu choice with either a demand for more scoops or an explanation of how ideas and scoops set the Photography level.
function npc_chatter.explain_photography_scoops(window: s32)
	local talk_character_id: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local menu_status: s32 = 0
	local menu_selection: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_character_id = event.get_triggered_event_data_2(13) or talk_character_id
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		do
			local out1, out2 = event.get_menu_value_3(6)
			menu_status = out1 or menu_status
			menu_selection = out2 or menu_selection
		end
		if 0 < menu_status then
			return 1
		end
		if menu_selection == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
		end
		if menu_selection == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
			)
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_step <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, talk_character_id, player_slot, 0)
			end
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the book servant small talk addressed to Monica.
function npc_chatter.talk_book_servant_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Je suis peut-[UNI00ea]tre le seul [UNI00e0] le\npenser, quelque chose en toi me<page>rappelle H[UNI00e9]l[UNI00e8]ne. Un je-ne-sais-\nquoi qui te distingue des autres."
		)
	else
		event.open_message_window_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the candy maker promise of a free meal after the request is finished.
function npc_chatter.talk_candy_maker_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Moi, je ne pourrais jamais\nrien te refuser.")
	else
		event.open_message_window_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the candy maker asking Monica what food she likes.
function npc_chatter.talk_candy_maker_monica(npc: s32, player: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Bonjour. Quels types de plats\naimes-tu, Monica ?")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Oui, j'aime les plats classiques,\nmais je m'int[UNI00e9]resse aussi aux\nsaveurs plus... inhabituelles."
		)
	else
		event.open_message_window_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the gun fighter small talk addressed to Monica.
function npc_chatter.talk_gun_fighter_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Tu es une amie de Max ?<page>Alors, tiens-toi bien.")
	else
		event.open_message_window_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the hide-and-seek hider small talk once the request is finished.
function npc_chatter.talk_hide_and_seek_hider_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Le jeu de cache-cache, c'est\npour les petits.")
	else
		event.open_message_window_2(
			0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who guards the Holy Water secret.
function npc_chatter.talk_holy_water_keeper(npc: s32, player: any)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.open_message_window_2(0, "Oh, bonjour jeune dame.\nQue puis-je faire pour vous ?")
		else
			event.open_message_window_2(
				0,
				"Max, ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
			)
		end
	else
		event.open_message_window_2(0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who is excited about the Blackstone Railroad.
function npc_chatter.talk_railroad_fan(npc: s32, player: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc_dialogue.greet_monica_about_hair(npc, player)
			return
		end
		event.open_message_window_2(0, "[UNI00c9]vite les endroits\ntrop dangereux.")
	else
		event.open_message_window_2(
			0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the ailing villager who cannot find what is wrong.
function npc_chatter.talk_sick_villager(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Je ne suis pas tr[UNI00e8]s en forme.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Le Dr Dell est venu me voir\nmais selon lui tout va bien.<page>Je me demande ce que j'ai ?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the swordsmith's small talk to Max, who remembers seeing her at the circus, differing by chapter.
function npc_chatter.talk_swordsmith_max(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Alors tu m'as vue au cirque ?\nC'[UNI00e9]tait pas mal, non ?<page>Mais ce n'est pas vraiment un\nboulot, plut[UNI00f4]t un passe-temps."
		)
	else
		event.open_message_window_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the swordsmith describing his blade-only shop.
function npc_chatter.talk_swordsmith_shop(npc: s32, player: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mon magasin est sp[UNI00e9]cialis[UNI00e9] en\narmes blanches.<page>J'ai quelques armes [UNI00e0] feu,\nmais [UNI00e7]a n'est pas\nvraiment mon truc."
	)
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the tailor asking how her clothes fit once her request is finished, differing by chapter.
function npc_chatter.talk_tailor_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Qu'est-ce que [UNI00e7]a donne ?<page>Sois honn[UNI00ea]te avec moi !")
	else
		event.open_message_window_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the generic villager conversation selected by the villager, the chapter and the story flags.
function npc_chatter.talk_to_villager()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	local message_group: s32 = 0
	local message_page: s32 = 0
	local speaker_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local railway_running_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_character, "talk_chara=", villager_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, villager_id)
		message_group = out1 or message_group
		message_page = out2 or message_page
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		speaker_variant = 2
	else
		speaker_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_character)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if villager_id == 1012 or villager_id == 1015 or villager_id == 1018 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	if villager_id == 50 then
		event.open_message_window_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
		cutscene.talk_to_character(villager_character, -1, 0, 0)
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		railway_running_flag = event.get_save_flag(9) or railway_running_flag
		if villager_id == 2 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Regarde-moi [UNI00e7]a. Difficile de croire\nqu'autrefois cet engin avan[UNI00e7]ait [UNI00e0]\ntoute vitesse, hein ?<page>Ah mais si, si... Il y a longtemps.<page>Je r[UNI00ea]ve de faire un autre\nvoyage dans ce truc. C'est pour\n[UNI00e7]a que je le bichonne. Comme [UNI00e7]a,<page>si un jour on me "
				)
			else
				event.open_message_window_2(
					0,
					"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 63 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"H[UNI00e9], salut Max !\nIl y a une [UNI00e9]ternit[UNI00e9] que la\nvoie ferr[UNI00e9]e ne fonctionne plus.<page>Mais je continue [UNI00e0] surveiller\nla gare jour apr[UNI00e8]s jour."
				)
			else
				event.open_message_window_2(
					0,
					"Le Maire s'est enfin boug[UNI00e9] un peu\net les trains ont repris du service\nmais pas encore pour le public.<page>Ah [UNI00e7]a, je meurs d'envie d'y faire\nmonter les gens de la ville..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 65 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Salut, Max. Tu savais que mon p[UNI00e8]re\nest le chef de gare ? On surveille\nla gare tous les deux.<page>Jusqu'au jour o[UNI00f9] les trains\nseront remis en service..."
				)
			else
				event.open_message_window_2(
					0,
					"Le train marche ! Mais il va\nfalloir un moment avant que la\ngare ne fonctionne [UNI00e0] nouveau normalement..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if villager_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"J'admire secr[UNI00e8]tement Monica depuis\ntoujours, mais je ne l'ai pas vue\ndans le coin derni[UNI00e8]rement.<page>C'est pour [UNI00e7]a que je n'arrive pas\n[UNI00e0] me concentrer sur mon travail."
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(
						0,
						"H[UNI00e9], Max !\nMonica est de retour, on dirait.\nTout le monde va [UNI00ea]tre enchant[UNI00e9] !"
					)
				else
					event.open_message_window_2(0, "Monica ! Comment [UNI00e7]a va ?\nTu m'as vraiment manqu[UNI00e9].")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Je commen[UNI00e7]ais tout juste [UNI00e0] pouvoir\ndiscuter normalement avec\nMonica quand elle a disparu.<page>Allez Max,\ndis-moi o[UNI00f9] elle est, s'te pla[UNI00ee]t ?"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Monica est revenue.\nComment elle a fait ?")
				else
					event.open_message_window_2(0, "Monica, tu es revenue !\nComment t'as fait ?")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_page * 10)) + speaker_variant))
	cutscene.talk_to_character(villager_character, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_character)
end

--- Plays the gardener tending a sick tree, differing by playable character.
function npc_chatter.talk_tree_gardener(npc: s32, player: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.set_character_motion(player, "立ち")
		event.open_message_window_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
		message.say_bubble(0, -1, npc, player, 0)
	else
		event.open_message_window_2(
			0,
			"Oh, Max ! Tu m'as fait peur.\nJ'[UNI00e9]tais en train de traiter\ncet arbre contre les insectes.<page>Certains arbres poussent mal, tu\nsais. Il y en a, comme lui, qui\nont vraiment besoin de soins."
		)
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
end

return npc_chatter
