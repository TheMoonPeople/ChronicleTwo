--!strict
--- Holds the French conversations of the villagers of Luna Lab.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local luna_lab_villagers = {}

--- Plays the conversation of the Luna Lab villager that was talked to, choosing the line by villager type and story flags.
function luna_lab_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local lab_visit_flag: s32 = 0
	local aquarium_done_flag: s32 = 0
	local aquarium_quest_flag: s32 = 0
	local aquarium_invention_status: s32 = 0
	local electric_fish_state: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local griffon_hint_flag: s32 = 0
	local elena_attack_flag: s32 = 0
	local playable_character: s32 = 0
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
	if villager_type == 300 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			lab_visit_flag = event.get_save_flag(456) or lab_visit_flag
			if lab_visit_flag == 0 then
				event.open_message_window_2(
					0,
					"H[UNI00e9] ! Qui [UNI00ea]tes... ? Ceci est le plus\ngrand des centres de recherches,\nle Laboratoire psych[UNI00e9]-psychique.<page>Et m[UNI00ea]me si pour l'instant il n'en\na pas trop l'aspect, nous devrions\npouvoir terminer nos recherches."
				)
			else
				event.open_message_window_2(
					0,
					"Il est impossible de qualifier le\nniveau d'excellence du Labo psy.\nIl faut le voir pour le croire."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Si on laisse faire Griffon,\nl'histoire ne reprendra jamais\nson cours normal.<page>L'existence m[UNI00ea]me de Griffon\nperturbe le cours de l'histoire."
			)
		end
	end
	if villager_type == 301 then
		aquarium_done_flag = event.get_save_flag(420) or aquarium_done_flag
		if aquarium_done_flag == 0 then
			aquarium_quest_flag = event.get_save_flag(408) or aquarium_quest_flag
			if aquarium_quest_flag == 0 then
				event.open_message_window_2(0, "Haaan, houuu, haaan, houuu.")
				closing_mode = 2
			else
				aquarium_invention_status = event.is_invention_created(309) or aquarium_invention_status
				if aquarium_invention_status < 0 then
					event.open_message_window_2(
						0,
						"Ces quelques trucs t'aideront [UNI00e0]\ninventer un aquarium : une bo[UNI00ee]te en\nbois, une fen[UNI00ea]tre et une fontaine.\nTu as bien [UNI00e7]a dans ta ville, non ?"
					)
				else
					electric_fish_state = event.get_save_data_value(2) or electric_fish_state
					if electric_fish_state == 0 then
						event.open_message_window_2(
							0,
							"D[UNI00e9]j[UNI00e0], donne un \"ver [UNI00e9]lectrique\" [UNI00e0]\nun poisson de l'aquarium pour\nl'[UNI00e9]lectrifier. Ensuite donne<page>ce poisson au Shigura. Tu as bien\ncompris, hein ?"
						)
					else
						event.open_message_window_2(
							0,
							"Ooh, alors tu as le poisson ?\nMaintenant, donne-le au Shigura.\nTu devrais y arriver, non ?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"H[UNI00e9] bien, oui, tu y es arriv[UNI00e9] !\nOn dirait que mon invention a\nmarch[UNI00e9] pour toi, hein ? H[UNI00e9] oui."
			)
		end
	end
	if villager_type == 302 then
		event.open_message_window_2(0, "Que ce soit Osmond ou le directeur\ndu labo, ils sont un peu bizarres\nici.")
	end
	if villager_type == 303 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				griffon_hint_flag = event.get_save_flag(600) or griffon_hint_flag
				if griffon_hint_flag == 0 then
					elena_attack_flag = event.get_save_flag(448) or elena_attack_flag
					if elena_attack_flag == 0 then
						event.open_message_window_2(
							0,
							"Prends soin de la traducoquille\ncar c'est l'une des plus\nimportantes inventions du Labo psy."
						)
					else
						event.open_message_window_2(
							0,
							"Le temps presse. D[UNI00e9]p[UNI00ea]che-toi,\nles forces de Griffon s'approchent\nd'H[UNI00e9]l[UNI00e8]ne, et elles sont rapides..."
						)
					end
				else
					event.open_message_window_2(0, "Je me demande quel type de\npersonne peut [UNI00ea]tre ce Griffon...")
				end
			else
				event.open_message_window_2(
					0,
					"Les pierres que tu cherches sont les\ncristaux de sagesse des anciens.<page>Selon l'analyse de l'ordinateur du\nLabo psy, elles sont cach[UNI00e9]es en\nquatre lieux diff[UNI00e9]rents :"
				)
				cutscene.face_each_other(player_slot, villager_id, 0)
				message.say_bubble(0, -1, villager_id, player_slot, 0)
				closing_mode = 1
				event.open_message_window_2(
					0,
					"le Bois du Papillon arc-en-ciel, le\nCa[UNI00f1]on astral, la Caverne grondante \net le Mt. Gundor.<page>[UNI00c0] l'entr[UNI00e9]e de chaque lieu, il\ndevrait y avoir un symbole en forme\nd'[UNI00e9]toile... Ouvre bien les yeux."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Bien, il est temps d'[UNI00e9]liminer\nGriffon. Le destin du monde est\nentre vos mains. Bonne chance !"
			)
		end
	end
	if villager_type == 304 then
		event.open_message_window_2(
			0,
			"Tout est question de talent dans ce\nLabo. M[UNI00ea]me un enfant, s'il est tr[UNI00e8]s\ndou[UNI00e9], peut [UNI00ea]tre le chef ici."
		)
	end
	if villager_type == 305 then
		event.open_message_window_2(
			0,
			"Les lunites du Shigura aident [UNI00e0]\nnous lib[UNI00e9]rer l'esprit et [UNI00e0] nous\nconcentrer sur nos recherches.<page>Mais je ne sais pas exactement en\nquoi consistent ces lunites..."
		)
	end
	if villager_type == 306 then
		event.open_message_window_2(
			0,
			"Un labo oc[UNI00e9]anique, c'est pas top ?\nTu te rends compte du travail que\nj'ai fourni pour travailler ici ?"
		)
	end
	if villager_type == 307 then
		event.open_message_window_2(
			0,
			"Que penses-tu du design du Labo ?\nJe me demande qui a eu l'id[UNI00e9]e\nde ce dr[UNI00f4]le de concept..."
		)
	end
	if villager_type == 308 then
		event.open_message_window_2(
			0,
			"Un jour, je les surpasserai et ils\nverront mon intelligence. Ici, tout\nest question de talent, tu sais."
		)
	end
	if villager_type == 309 then
		event.open_message_window_2(
			0,
			"Je respecte beaucoup le patron. Il\nfaut reconna[UNI00ee]tre qu'un type qui\n[UNI00e9]crit un best-seller de 40 volumes<page> \"La Bible du G[UNI00e9]nie scientifique\n\" [UNI00e0] son [UNI00e2]ge, c'est quelqu'un."
		)
	end
	if villager_type == 310 then
		event.open_message_window_2(
			0,
			"Je suis encore novice ici. Mais\nje progresse chaque jour, je\ndeviendrai un grand chercheur."
		)
	end
	if villager_type == 311 then
		event.open_message_window_2(
			0,
			"Depuis ce labo, la vue sur la\nmer est exceptionnelle.<page>Tr[UNI00e8]s loin, [UNI00e0] l'horizon,\nl'obscurit[UNI00e9] de la mer et\ncelle du ciel fusionnent."
		)
	end
	if villager_type == 312 then
		event.open_message_window_2(
			0,
			"Ici c'est le Labo N[UNI00b0]2.<page>Au Labo psy, les laboratoires\ntravaillent tous sur\ndes domaines diff[UNI00e9]rents."
		)
	end
	if villager_type == 313 then
		event.open_message_window_2(
			0,
			"Ici, au Labo psy, nous simulons un\nenvironnement nocturne pour activer\nle pouvoir des lunites."
		)
	end
	if villager_type == 314 then
		event.open_message_window_2(
			0,
			"Quand j'ai commenc[UNI00e9] ici, moi aussi\nje me perdais sans cesse dans les\nlabos. Je vais t'expliquer : le<page>Labo 1 est rouge, le 2 est bleu,\nle 3 est violet et le Labo 4 est\nvert. Chacun a sa propre couleur."
		)
	end
	if villager_type == 315 then
		event.open_message_window_2(0, "L'embl[UNI00e8]me au-dessus du Labo\ncentral repr[UNI00e9]sente la lune.")
	end
	if villager_type == 316 then
		event.open_message_window_2(
			0,
			"Il para[UNI00ee]t que ce Labo a pu [UNI00ea]tre\ntermin[UNI00e9] gr[UNI00e2]ce aux lunites apport[UNI00e9]es\npar Shingala, un Drac de mer. <page>Il semble que ces cr[UNI00e9]atures soient\nplut[UNI00f4]t intelligentes, hein ? "
		)
	end
	if villager_type == 317 then
		event.open_message_window_2(
			0,
			"Ne lui dis pas que je t'ai dit [UNI00e7]a,<page> mais on en a ras-le-bol des\nsoi-disant blagues d'Osmond.\n Elles donnent envie de le frapper."
		)
	end
	if villager_type == 318 then
		event.open_message_window_2(
			0,
			"C'est vrai, moi aussi, j'ai pris\npart aux [UNI00e9]tudes du Ver [UNI00e9]lectrique.\nL[UNI00e0], je bosse sur un autre projet.<page> Ah non ! Je ne dirai pas quoi !\nJe peux pas le raconter [UNI00e0] tout le\nmonde, c'est top secret !"
		)
	end
	if villager_type == 319 then
		event.open_message_window_2(
			0,
			"Comment ? Toi aussi tu veux\ndevenir chercheur ?<page>C'est pas [UNI00e9]vident pour y arriver,\ntu sais.\nIl y a beaucoup de concurrence."
		)
	end
	if villager_type == 320 then
		event.open_message_window_2(
			0,
			"Certains chercheurs critiquent le\ndesign du Labo psy. Pour ma part,\nje le trouve plut[UNI00f4]t chouette...<page> Mais il semble que je sois un\ndes rares [UNI00e0] l'appr[UNI00e9]cier."
		)
	end
	if villager_type == 321 then
		event.open_message_window_2(
			0,
			"Nous discutons de recherches\ntr[UNI00e8]s confidentielles.<page>Pourriez-vous nous laisser\n seuls pendant un petit moment ?"
		)
	end
	if villager_type == 322 then
		event.open_message_window_2(
			0,
			"Pardonnez-nous, mais notre\ndiscussion concerne des\nrecherches tr[UNI00e8]s confidentielles.<page>On ne peut pas vraiment vous\nparler pour le moment, alors..."
		)
	end
	if villager_type == 323 then
		event.open_message_window_2(
			0,
			"Dr Nobb est tr[UNI00e8]s talentueux,\nbien s[UNI00fb]r, mais il\ntravaille aussi tr[UNI00e8]s dur.<page>En comparaison, je fais bien peu...\nJe serais presque paresseux..."
		)
	end
	if villager_type == 324 then
		event.open_message_window_2(
			0,
			"C'est toi ? On m'a dit que tu\nt'[UNI00e9]tais pris le bec avec Dr Osmond.<page>Je ne critique pas. Je trouve [UNI00e7]a\nbien. La remise en cause permet\nsouvent de nouvelles d[UNI00e9]couvertes."
		)
	end
	if villager_type == 325 then
		event.open_message_window_2(
			0,
			"Tu n'arrives pas [UNI00e0] t'habituer aux\nlumi[UNI00e8]res fortes, hein ?<page>Je suppose qu'il vous faudra\nun peu de temps pour vous y\nhabituer, vous qui venez du pass[UNI00e9]."
		)
	end
	if villager_type == 326 then
		event.open_message_window_2(
			0,
			"H[UNI00e9] bien, je fais une petite\npause.<page> Il faut parfois donner [UNI00e0] son\ncerveau un temps de repos, sinon on\nfinit par perdre de son acuit[UNI00e9]."
		)
	end
	if villager_type == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Para[UNI00ee]t que t'es bon inventeur ?\n Alors plus tard, [UNI00e7]a te dirait\nde venir travailler ici ?<page>Ce Labo psy sera tout juste fini\nquand tu deviendras adulte. Tu y\n serais s[UNI00fb]rement bien accueilli."
			)
		else
			event.open_message_window_2(
				0,
				"Tu trouves pas que les inventeurs\nont beaucoup de charme ?<page>Mais ne tombe pas amoureuse de moi,\nmes recherches, c'est toute ma vie.\n[UNI00c7]a ne marcherait jamais entre nous."
			)
		end
	end
	if villager_type == 328 then
		event.open_message_window_2(
			0,
			"J'ai une id[UNI00e9]e r[UNI00e9]volutionnaire. Un\nsyst[UNI00e8]me qui permettrait [UNI00e0] monstres\net hommes de vivre en harmonie.<page>Je vais cr[UNI00e9]er une machine qui\ncomprend la langue humaine."
		)
	end
	if villager_type == 329 then
		event.open_message_window_2(
			0,
			"Les lunites sont [UNI00e0] la base de\ntoutes les activit[UNI00e9]s du Labo psy.<page>Sans elles, tous nos syst[UNI00e8]mes\ns'arr[UNI00ea]teraient instantan[UNI00e9]ment."
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
end

return luna_lab_villagers
