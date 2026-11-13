--!strict
--- Holds the French conversations of the villagers of Gundorada Workshop.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local workshop_villagers = {}

--- Plays the conversation of the Gundorada Workshop villager that was talked to, choosing the line by villager type and story flags.
function workshop_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local paznos_flag: s32 = 0
	local gaspard_defeated_flag: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_recheck_flag: s32 = 0
	local paznos_recheck_flag: s32 = 0
	local gaspard_defeated_recheck_flag: s32 = 0
	local fire_squall_defeated_flag: s32 = 0
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
	if villager_type == 400 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				paznos_flag = event.get_save_flag(540) or paznos_flag
				if paznos_flag == 0 then
					gaspard_defeated_flag = event.get_save_flag(536) or gaspard_defeated_flag
					if gaspard_defeated_flag == 0 then
						event.open_message_window_2(
							0,
							"Gaspard est redoutable. Sois \nvigilant, ne baisse jamais \nla garde, pas m[UNI00ea]me un instant.<page>Je sais que tu peux le battre.\nL'Atlamillia t'a choisi,\nce n'est sans doute pas pour rien."
						)
					else
						event.open_message_window_2(
							0,
							"Ah, Gaspard aussi [UNI00e9]tait malheureux.<page>Pourquoi Griffon s'acharne-t-il\n[UNI00e0] d[UNI00e9]truire tant de gens..."
						)
					end
				else
					event.open_message_window_2(
						0,
						"Si quelqu'un peut vaincre Griffon, \nc'est bien vous, je le sais.<page>On compte sur vous."
					)
				end
			else
				event.open_message_window_2(
					0,
					"L'union chrono... Ainsi, le monde\nva [UNI00ea]tre sauv[UNI00e9] par le savoir des\nanciens..."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Alors, nous y voil[UNI00e0], hein ? J'ai\nperdu de nombreux amis dans\nce combat contre Griffon...<page>Vous [UNI00ea]tes notre dernier espoir !\nMax, Monica, je compte sur vous. \nVous devez vaincre Griffon !"
			)
		end
	end
	if villager_type == 401 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_recheck_flag = event.get_save_flag(616) or gem_hint_recheck_flag
			if gem_hint_recheck_flag == 0 then
				paznos_recheck_flag = event.get_save_flag(540) or paznos_recheck_flag
				if paznos_recheck_flag == 0 then
					gaspard_defeated_recheck_flag = event.get_save_flag(536) or gaspard_defeated_recheck_flag
					if gaspard_defeated_recheck_flag == 0 then
						fire_squall_defeated_flag = event.get_save_flag(520) or fire_squall_defeated_flag
						if fire_squall_defeated_flag == 0 then
							event.open_message_window_2(
								0,
								"Bon, pour commencer, il faut \nd[UNI00e9]truire le Lance-feu.<page>Si on ne fait rien contre\nces averses de braises en bas, \nD[UNI00e9]soland est perdu."
							)
						else
							event.open_message_window_2(
								0,
								"Alors c'est [UNI00e7]a qui se passait.\nOn peut s'estimer heureux que le\nLance-feu ait [UNI00e9]t[UNI00e9] d[UNI00e9]truit."
							)
							cutscene.face_each_other(player_slot, villager_id, 0)
							message.say_bubble(0, -1, villager_id, player_slot, 0)
							closing_mode = 1
							event.open_message_window_2(
								0,
								"Mais je m'inqui[UNI00e8]te pour la personne\nqui est tomb[UNI00e9]e dans le crat[UNI00e8]re.<page>Je suppose que tout ce que nous\npouvons faire, c'est reconstruire\nD[UNI00e9]soland et am[UNI00e9]liorer l'Atelier."
							)
						end
					else
						event.open_message_window_2(
							0,
							"Vous avez vaincu Gaspard !\nEh bien ! Vous [UNI00ea]tes [UNI00e9]tonnants !<page>Finissons-en maintenant avec son\nchef, l'Empereur Griffon !"
						)
					end
				else
					event.open_message_window_2(
						0,
						"La joie de revoir Paznos [UNI00e0] l'action\nm'a mis les larmes aux yeux.<page>Tout ce pour quoi nous avons\ntravaill[UNI00e9] si dur a finalement pay[UNI00e9]."
					)
				end
			else
				event.open_message_window_2(0, "Une pierre ? Huum, ah non, je ne\nconnais vraiment rien [UNI00e0] ce sujet.")
			end
		else
			event.open_message_window_2(0, "Il est temps d'affronter Griffon,\nhein ? Bonne chance. Vous l'aurez !")
		end
	end
	if villager_type == 402 then
		event.open_message_window_2(0, "H[UNI00e9] vous ! On a des trucs g[UNI00e9]niaux\npour vous ! Vous voulez quoi ?")
	end
	if villager_type == 403 then
		event.open_message_window_2(0, "De quoi avez-vous besoin ? Je le\ntrouverai. J'ai tout ce qu'il faut.")
	end
	if villager_type == 404 then
		event.open_message_window_2(
			0,
			"Combattre peut [UNI00ea]tre complexe.\nIl ne faut pas toujours se \npr[UNI00e9]cipiter et tirer dans le tas.<page>On peut aussi utiliser des objets,\nrep[UNI00e9]rer les faiblesses de\nl'ennemi et les exploiter."
		)
	end
	if villager_type == 405 then
		event.open_message_window_2(
			0,
			"On peut tout fabriquer [UNI00e0] l'Atelier\nD[UNI00e9]sogundor. Peu importe la taille,\ngros ou petit, on peut le faire."
		)
	end
	if villager_type == 406 then
		event.open_message_window_2(
			0,
			"H[UNI00e9], comment [UNI00ea]tes-vous entr[UNI00e9]s ici ?\nVous feriez mieux d'[UNI00ea]tre prudents,\n[UNI00e7]a peut [UNI00ea]tre tr[UNI00e8]s dangereux."
		)
	end
	if villager_type == 407 then
		event.open_message_window_2(
			0,
			"Mais qu'est-ce qui s'est pass[UNI00e9] ?\nJ'ai l'impression d'avoir \ntout oubli[UNI00e9]..."
		)
	end
	if villager_type == 408 then
		event.open_message_window_2(0, "Alors Griffon nous a tous effac[UNI00e9]s ?\nCe type est vraiment un monstre.")
	end
	if villager_type == 409 then
		event.open_message_window_2(0, "J'ai pas mal de travail.\nNe te mets pas dans mes jambes.")
	end
	if villager_type == 410 then
		event.open_message_window_2(0, "On est tous derri[UNI00e8]re toi, nous\naussi. [UNI00c0] 100 %.")
	end
	if villager_type == 411 then
		event.open_message_window_2(
			0,
			"On dirait que les armes\nde cette bo[UNI00ee]te ne\nsont pas [UNI00e0] vendre.<page>Il y a vraiment des armes aussi\nbizarres que merveilleuses\ndans ce monde..."
		)
	end
	if villager_type == 412 then
		event.open_message_window_2(
			0,
			"Alors ce type, Gaspard, peut\nactiver le Lance-feu ?<page>Il n'est pas que rus[UNI00e9]...\nIl est vraiment mal[UNI00e9]fique."
		)
	end
	if villager_type == 413 then
		event.open_message_window_2(
			0,
			"[UNI00c7]a veut dire quoi ce c[UNI0153]ur,\nsur ce panneau...<page>C'est plut[UNI00f4]t moche,\nsi tu veux mon avis..."
		)
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
	if villager_type == 402 then
		menu.open_type_6_alt(30)
	end
	if villager_type == 403 then
		menu.open_type_6_alt(28)
	end
	if villager_type == 404 then
		menu.open_type_6_alt(29)
	end
end

return workshop_villagers
