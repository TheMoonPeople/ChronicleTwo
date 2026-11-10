--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_1b7c747e()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	var3 = 0
	if var2 == 400 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.get_save_flag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.get_save_flag(536) or flag_4
					if flag_4 == 0 then
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
	if var2 == 401 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.get_save_flag(520) or flag_9
						if flag_9 == 0 then
							event.open_message_window_2(
								0,
								"Bon, pour commencer, il faut \nd[UNI00e9]truire le Lance-feu.<page>Si on ne fait rien contre\nces averses de braises en bas, \nD[UNI00e9]soland est perdu."
							)
						else
							event.open_message_window_2(
								0,
								"Alors c'est [UNI00e7]a qui se passait.\nOn peut s'estimer heureux que le\nLance-feu ait [UNI00e9]t[UNI00e9] d[UNI00e9]truit."
							)
							helper_31bbf01d(player_chara, var1, 0)
							helper_0ffc2526(0, -1, var1, player_chara, 0)
							var3 = 1
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
	if var2 == 402 then
		event.open_message_window_2(0, "H[UNI00e9] vous ! On a des trucs g[UNI00e9]niaux\npour vous ! Vous voulez quoi ?")
	end
	if var2 == 403 then
		event.open_message_window_2(0, "De quoi avez-vous besoin ? Je le\ntrouverai. J'ai tout ce qu'il faut.")
	end
	if var2 == 404 then
		event.open_message_window_2(
			0,
			"Combattre peut [UNI00ea]tre complexe.\nIl ne faut pas toujours se \npr[UNI00e9]cipiter et tirer dans le tas.<page>On peut aussi utiliser des objets,\nrep[UNI00e9]rer les faiblesses de\nl'ennemi et les exploiter."
		)
	end
	if var2 == 405 then
		event.open_message_window_2(
			0,
			"On peut tout fabriquer [UNI00e0] l'Atelier\nD[UNI00e9]sogundor. Peu importe la taille,\ngros ou petit, on peut le faire."
		)
	end
	if var2 == 406 then
		event.open_message_window_2(
			0,
			"H[UNI00e9], comment [UNI00ea]tes-vous entr[UNI00e9]s ici ?\nVous feriez mieux d'[UNI00ea]tre prudents,\n[UNI00e7]a peut [UNI00ea]tre tr[UNI00e8]s dangereux."
		)
	end
	if var2 == 407 then
		event.open_message_window_2(
			0,
			"Mais qu'est-ce qui s'est pass[UNI00e9] ?\nJ'ai l'impression d'avoir \ntout oubli[UNI00e9]..."
		)
	end
	if var2 == 408 then
		event.open_message_window_2(0, "Alors Griffon nous a tous effac[UNI00e9]s ?\nCe type est vraiment un monstre.")
	end
	if var2 == 409 then
		event.open_message_window_2(0, "J'ai pas mal de travail.\nNe te mets pas dans mes jambes.")
	end
	if var2 == 410 then
		event.open_message_window_2(0, "On est tous derri[UNI00e8]re toi, nous\naussi. [UNI00c0] 100 %.")
	end
	if var2 == 411 then
		event.open_message_window_2(
			0,
			"On dirait que les armes\nde cette bo[UNI00ee]te ne\nsont pas [UNI00e0] vendre.<page>Il y a vraiment des armes aussi\nbizarres que merveilleuses\ndans ce monde..."
		)
	end
	if var2 == 412 then
		event.open_message_window_2(
			0,
			"Alors ce type, Gaspard, peut\nactiver le Lance-feu ?<page>Il n'est pas que rus[UNI00e9]...\nIl est vraiment mal[UNI00e9]fique."
		)
	end
	if var2 == 413 then
		event.open_message_window_2(
			0,
			"[UNI00c7]a veut dire quoi ce c[UNI0153]ur,\nsur ce panneau...<page>C'est plut[UNI00f4]t moche,\nsi tu veux mon avis..."
		)
	end
	if var3 == 0 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
	end
	if var3 == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		do
			local out1, _, out3 = event.get_character_position(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.get_look_angle(var17 - var14, var19 - var16) or var20
		helper_76f23193(player_chara_2, var20)
		event.set_character_rotation(player_chara_2, 0.0, var20, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
	if var2 == 402 then
		helper_59a16271(30)
	end
	if var2 == 403 then
		helper_59a16271(28)
	end
	if var2 == 404 then
		helper_59a16271(29)
	end
end

return helper_1b7c747e
