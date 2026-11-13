--!strict
--- Holds the French conversations of the villagers of Starlight Temple.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local starlight_temple_villagers = {}

--- Plays the conversation of the Starlight Temple villager that was talked to, choosing the line by villager type and story flags.
function starlight_temple_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local miracle_dish_flag: s32 = 0
	local dumpling_helped_flag: s32 = 0
	local crest_returned_flag: s32 = 0
	local rescued_flag: s32 = 0
	local final_battle_flag: s32 = 0
	local current_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle_degrees: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	closing_mode = 0
	miracle_dish_flag = event.get_save_flag(324) or miracle_dish_flag
	dumpling_helped_flag = event.get_save_flag(330) or dumpling_helped_flag
	crest_returned_flag = event.get_save_flag(372) or crest_returned_flag
	rescued_flag = event.get_save_flag(400) or rescued_flag
	final_battle_flag = event.get_save_flag(640) or final_battle_flag
	if villager_type == 200 then
		if final_battle_flag == 0 then
			if dumpling_helped_flag == 0 then
				if miracle_dish_flag == 0 then
					event.open_message_window_2(
						0,
						"Pour faire le plat miracle, il me\nfaut une fleur de vent-blanc. Et\nmalheureusement, je n'en ai plus."
					)
				else
					event.open_message_window_2(
						0,
						"Tu as d[UNI00e9]j[UNI00e0] go[UNI00fb]t[UNI00e9] une boulette\nmiracle ? Elle perd ses effets en\nrefroidissant, il faut manger vite."
					)
				end
			else
				event.open_message_window_2(
					0,
					"La boulette miracle a march[UNI00e9] ?\nJ'en suis bien content. H[UNI00e9],\ntu veux manger avant de partir ?"
				)
			end
		else
			event.open_message_window_2(0, "Mais il ne reste plus beaucoup\nde temps, non ? Bonne chance,\nen tout cas.")
		end
	end
	if villager_type == 201 then
		event.open_message_window_2(
			0,
			"Les diff[UNI00e9]rents objets ont des\neffets divers. Ils peuvent\nt'aider, se transformer en arme...<page>Sois inventif et tu pourras vaincre\nm[UNI00ea]me tes ennemis les plus coriaces.\nEssaie tout ce que tu peux."
		)
	end
	if villager_type == 202 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Je n'arrive pas [UNI00e0] croire que ce\ntemple ait [UNI00e9]t[UNI00e9] ras[UNI00e9] par ce \ndiabolique Empereur Griffon...<page>Si seulement Crest le Grand sage\n[UNI00e9]tait ici..."
			)
		else
			event.open_message_window_2(
				0,
				"Maintenant que Crest est de\nretour, il n'y a rien [UNI00e0] craindre.\nAllez-y, partez affronter Griffon."
			)
		end
	end
	if villager_type == 203 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Comme le Cristal lunaire est\nplus puissant la nuit, ce temple\nest perp[UNI00e9]tuellement dans le noir.<page>Il utilise la force du temple pour\ncr[UNI00e9]er une zone d'obscurit[UNI00e9]."
			)
		else
			event.open_message_window_2(
				0,
				"Le Grand Crest utilise le\npouvoir du Cristal lunaire\npour tout voir du monde. <page>Rien n'[UNI00e9]chappe au regard\ntout-puissant de Crest."
			)
		end
	end
	if villager_type == 204 then
		event.open_message_window_2(
			0,
			"Salut ! On a un super choix en\nmagasin. Robustes et solides, telle\nest la r[UNI00e9]putation de nos armes."
		)
	end
	if villager_type == 205 then
		if final_battle_flag == 0 then
			if rescued_flag == 0 then
				event.open_message_window_2(
					0,
					"H[UNI00e9] ! Arr[UNI00ea]tez de tergiverser et\nallez montrer [UNI00e0] ce Griffon\nqui est le chef ici !"
				)
			else
				event.open_message_window_2(
					0,
					"Voil[UNI00e0], c'est l[UNI00e0] que je m'arr[UNI00ea]te.\nC'est [UNI00e0] vous de jouer maintenant.\nEt m[UNI00e9]fiez-vous de ce Griffon hein ?<page>Vous m'avez sauv[UNI00e9] la vie et si\nquelqu'un peut r[UNI00e9]ussir, c'est vous."
				)
			end
		else
			event.open_message_window_2(
				0,
				"On dirait que votre voyage touche\npresque [UNI00e0] sa fin. Vous devez\nbattre ce Griffon, pour nous tous.<page>Il faut le vaincre co[UNI00fb]te que co[UNI00fb]te.\nApr[UNI00e8]s... Crest et moi... pourrons\nenfin devenir de Grands sages."
			)
		end
	end
	if villager_type == 206 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"M[UNI00ea]me si le temple est revenu [UNI00e0] la\nnormale, sans Crest, le Temple\nastral est inutile. <page>Seul Crest d[UNI00e9]tient le pouvoir\nastrologique n[UNI00e9]cessaire [UNI00e0]\nl'observation du monde entier."
			)
		else
			event.open_message_window_2(
				0,
				"M[UNI00ea]me le Grand Crest a [UNI00e9]t[UNI00e9] un jour\nl'apprenti d'un sage. Ce fut sans\ndoute un excellent professeur..."
			)
		end
	end
	if villager_type == 207 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(0, "La nourriture est digne d'un roi\nici. J'en salive rien que\nd'y penser.")
		else
			event.open_message_window_2(0, "Il a cuisin[UNI00e9] son plat miracle !\nLao Chao est vraiment un grand chef !")
		end
	end
	if villager_type == 208 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Une fois que tu auras d[UNI00ee]n[UNI00e9] ici,\nrien n'aura plus jamais le m[UNI00ea]me\ngo[UNI00fb]t. C'est absolument d[UNI00e9]licieux."
			)
		else
			event.open_message_window_2(
				0,
				"Oah ! [UNI00c7]a, j'aimerais vraiment\nessayer aussi quelques-unes de\nces boulettes miracle !"
			)
		end
	end
	if villager_type == 209 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Tu trouves le Sablier stellaire\nun peu bizarre... ? Ah oui ?<page>J'en ai un moi aussi mais je n'en\nsuis pas tr[UNI00e8]s content... Il n'a\njamais invers[UNI00e9] le cours du temps."
			)
		else
			event.open_message_window_2(
				0,
				"C'est super que vous ayez [UNI00e9]t[UNI00e9]\namis avec Crest le Grand sage.<page>Je n'avais pas r[UNI00e9]alis[UNI00e9] que\nvous [UNI00e9]tiez aussi proches..."
			)
		end
	end
	if villager_type == 210 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Crest le Grand sage n'est pas ici.\nJe me demande o[UNI00f9] il est parti...<page>C'est [UNI00e9]trange, mais on est mal\n[UNI00e0] l'aise quand il n'est pas l[UNI00e0]."
			)
		else
			event.open_message_window_2(
				0,
				"Crest m'a racont[UNI00e9] une fois \nqu'un certain Gaspard avait tent[UNI00e9]\nde d[UNI00e9]truire le Cristal lunaire.<page>Et que le ma[UNI00ee]tre du Grand sage\ns'[UNI00e9]tait sacrifi[UNI00e9] pour le prot[UNI00e9]ger."
			)
		end
	end
	if villager_type == 211 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Crest le Grand sage a disparu\navec le Cristal lunaire,\npour le prot[UNI00e9]ger... ?<page>Je ne comprends pas..."
			)
		else
			event.open_message_window_2(
				0,
				"Le pouvoir du Cristal lunaire\nest hallucinant hein ? Mais seule\nune personne peut l'utiliser...<page>Crest le Grand sage...<page>Les gens comme toi et moi ne\npourraient jamais faire ce genre de\nchoses."
			)
		end
	end
	if villager_type == 212 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Serait-ce vous... ? Le Grand Crest\nm'a dit qu'un jour une fille\net un gar[UNI00e7]on viendraient [UNI00e0] moi...<page>Je savais que cette proph[UNI00e9]tie\nallait se r[UNI00e9]aliser !<page>Mais, malheureusement, le Grand\nsage a disparu."
			)
		else
			event.open_message_window_2(
				0,
				"10 000 ans ?<page>Le Labo psy pourrait accomplir un\nmiracle dont m[UNI00ea]me Crest le Grand\nsage est incapable ?"
			)
		end
	end
	if villager_type == 213 then
		event.open_message_window_2(
			0,
			"La lune a d'[UNI00e9]tranges pouvoirs qui\naffectent toutes sortes d'[UNI00ea]tres\nvivants.<page> Et c'est le Cristal lunaire\nqui incarne ce pouvoir."
		)
	end
	if villager_type == 214 then
		if dumpling_helped_flag == 0 then
			event.open_message_window_2(
				0,
				"Le meilleur restaurant\nau monde, c'est sans conteste\nle Bistrot de Lao Chao !<page>Tu en as entendu parler, non ?"
			)
		else
			event.open_message_window_2(
				0,
				"Alors c'est donc vous. Crest le\nGrand Sage m'a parl[UNI00e9] de vous, vous\nauriez sauv[UNI00e9] sa vie autrefois.<page>Mais je n'aurais jamais imagin[UNI00e9] que\nvous n'[UNI00e9]tiez que des enfants..."
			)
		end
	end
	if closing_mode == 0 then
		cutscene.talk(villager_id, -1, 0, 0)
	end
	if closing_mode == 1 then
		message.say_bubble(0, -1, villager_id, player_slot, 0)
		event.set_character_motion(villager_id, "立ち")
		event.finish_event()
	end
	if closing_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		current_player_slot = event.get_player_character_slot() or current_player_slot
		do
			local out1, _, out3 = event.get_character_position(current_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_id)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle_degrees = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle_degrees
		character.turn_to_angle(current_player_slot, look_angle_degrees)
		event.set_character_rotation(current_player_slot, 0.0, look_angle_degrees, 0.0)
		event.set_character_motion(current_player_slot, "立ち")
		message.say_bubble(0, -1, villager_id, current_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_id)
	if villager_type == 201 then
		menu.open_type_6_alt(5)
	end
	if villager_type == 204 then
		menu.open_type_6_alt(27)
	end
end

return starlight_temple_villagers
