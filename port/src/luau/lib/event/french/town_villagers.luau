--!strict
--- Holds the French conversations of the villagers living in the player's town.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local partner_talk = vm.module("@lib/event/french/partner_talk")

local town_villagers = {}

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
function town_villagers.say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	local villager_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"J'habite ici maintenant,\nmais je m'inqui[UNI00e8]te\ndavantage pour Noirpierre I.<page>C'est moi qui vais\nfaire fonctionner le\ntrain, comme avant."
				)
				villager_id = event.get_triggered_event_data_2(13) or villager_id
				cutscene.talk(villager_id, -1, 0, 0)
				event.open_message_window_2(
					window,
					"Born[UNI00e9]o est un peu maladroit,\net [UNI00c9]rik encore bien jeune.<page>Pour les types comme moi,\nla vie se r[UNI00e9]sume [UNI00e0] maison-\nboulot-dodo jour apr[UNI00e8]s jour.<page>Mais que veux-tu, c'est la vie..."
				)
			else
				event.open_message_window_2(window, "Et Steve, que devient-il ?")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "Je n'en peux plus de rester dans ma\nchambre [UNI00e0] me tourner les pouces.")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"Plantes et fleurs ne s'[UNI00e9]panouissent\nque lorsqu'on s'en occupe. Jamais\nje ne pourrais les n[UNI00e9]gliger."
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"Je me demande ce que devient la\nbase secr[UNI00e8]te. Je ne peux pas faire\nv[UNI00e9]rifier, [UNI00e7]a reste un secret !"
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"Le violet est une couleur superbe.\nSa fra[UNI00ee]cheur est... chaleureuse et\nson c[UNI00f4]t[UNI00e9] sombre... lumineux."
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "Je pourrais aller au bout du monde\npour aider un malade.")
		end
		if villager_type == 7 then
			event.open_message_window_2(
				window,
				"Seul un grand chef peut concocter \ndes plats d[UNI00e9]licieux quel que \nsoit l'endroit o[UNI00f9] il se trouve."
			)
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "Les maisons, plus elles sont\nsolides, mieux c'est, non ?")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"Les noix, c'est bon, mais ces trucs\nrouges sont vraiment d[UNI00e9]licieux. Tu\npourrais m'en ramener d'autres ?"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"Le pire ennemi du livre, c'est\nl'humidit[UNI00e9]. Je ne supporterais\npas d'habiter pr[UNI00e8]s de l'eau."
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(
				window,
				"Mes v[UNI00ea]tements ne sont ni jolis, ni\ndans le vent, mais je peux faire\ndes habits comme personne."
			)
		end
		if villager_type == 12 then
			event.open_message_window_2(window, "Ce lieu m'a rajeunie. Comme si\nje redevenais une jeune boulang[UNI00e8]re.")
		end
		if villager_type == 13 then
			event.open_message_window_2(window, "Peu importe quoi,\nj'ai juste envie de\npulv[UNI00e9]riser quelque chose !")
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "Si tu d[UNI00e9]couvres un nouveau monstre,\nsignale-le imm[UNI00e9]diatement.")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"Certains disent que c'est pas pour\nles femmes, mais l'[UNI00e9]p[UNI00e9]e s'en moque\nbien, elle. Le meilleur l'emporte."
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "Cette petite maison pourrait faire\nl'affaire pour [UNI00e9]lever des enfants.")
		end
		if villager_type == 17 then
			event.open_message_window_2(
				window,
				"Je me demande si Morton arrive [UNI00e0] se\nd[UNI00e9]brouiller. Il m'inqui[UNI00e8]te un peu."
			)
		end
		if villager_type == 18 then
			event.open_message_window_2(
				window,
				"Si tu connais une ville ayant\nbesoin d'[UNI00e9]glise, je suis le pr[UNI00ea]tre\nqu'il te faut ! Fais-moi signe."
			)
		end
		if villager_type == 19 then
			event.open_message_window_2(
				window,
				"Je n'ai pas beaucoup pens[UNI00e9] [UNI00e0] la\nlune derni[UNI00e8]rement. [UNI00c7]a doit [UNI00ea]tre [UNI00e0]\ncause de tous mes nouveaux amis."
			)
		end
		if villager_type == 20 then
			event.open_message_window_2(
				window,
				"Autres lieux, autres poissons.\nIl faut savoir s'adapter en\nfonction de l'environnement."
			)
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "Une eau parfaite pour les poissons.")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"Parn a commenc[UNI00e9] un nouveau portrait\nde femme. Elle sera soi-disant\nencore plus jolie que moi."
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(window, "Je me demande pourquoi les\ninsectes sont si r[UNI00e9]pugnants...")
		end
		if villager_type == 24 then
			event.open_message_window_2(window, "Tu pourrais embellir ma maison ?\nUne maison n'est jamais trop\nbelle, tu sais !")
		end
		if villager_type == 25 then
			event.open_message_window_2(
				window,
				"Je n'aurais jamais imagin[UNI00e9]\nd[UNI00e9]m[UNI00e9]nager [UNI00e0] mon [UNI00e2]ge."
			)
		end
	else
		partner_talk.show_npc_remark(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
function town_villagers.talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	town_villagers.say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

return town_villagers
