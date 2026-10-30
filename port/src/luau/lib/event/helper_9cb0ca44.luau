--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_9cb0ca44()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
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
	if var2 == 300 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(456) or flag_2
			if flag_2 == 0 then
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
	if var2 == 301 then
		flag_3 = event.get_save_flag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.get_save_flag(408) or flag_4
			if flag_4 == 0 then
				event.open_message_window_2(0, "Haaan, houuu, haaan, houuu.")
				var3 = 2
			else
				argc = event.is_invention_created(309) or argc
				if argc < 0 then
					event.open_message_window_2(
						0,
						"Ces quelques trucs t'aideront [UNI00e0]\ninventer un aquarium : une bo[UNI00ee]te en\nbois, une fen[UNI00ea]tre et une fontaine.\nTu as bien [UNI00e7]a dans ta ville, non ?"
					)
				else
					var9 = event.get_save_data_value(2) or var9
					if var9 == 0 then
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
	if var2 == 302 then
		event.open_message_window_2(0, "Que ce soit Osmond ou le directeur\ndu labo, ils sont un peu bizarres\nici.")
	end
	if var2 == 303 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(448) or flag_8
					if flag_8 == 0 then
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
				helper_31bbf01d(player_chara, var1, 0)
				helper_0ffc2526(0, -1, var1, player_chara, 0)
				var3 = 1
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
	if var2 == 304 then
		event.open_message_window_2(
			0,
			"Tout est question de talent dans ce\nLabo. M[UNI00ea]me un enfant, s'il est tr[UNI00e8]s\ndou[UNI00e9], peut [UNI00ea]tre le chef ici."
		)
	end
	if var2 == 305 then
		event.open_message_window_2(
			0,
			"Les lunites du Shigura aident [UNI00e0]\nnous lib[UNI00e9]rer l'esprit et [UNI00e0] nous\nconcentrer sur nos recherches.<page>Mais je ne sais pas exactement en\nquoi consistent ces lunites..."
		)
	end
	if var2 == 306 then
		event.open_message_window_2(
			0,
			"Un labo oc[UNI00e9]anique, c'est pas top ?\nTu te rends compte du travail que\nj'ai fourni pour travailler ici ?"
		)
	end
	if var2 == 307 then
		event.open_message_window_2(
			0,
			"Que penses-tu du design du Labo ?\nJe me demande qui a eu l'id[UNI00e9]e\nde ce dr[UNI00f4]le de concept..."
		)
	end
	if var2 == 308 then
		event.open_message_window_2(
			0,
			"Un jour, je les surpasserai et ils\nverront mon intelligence. Ici, tout\nest question de talent, tu sais."
		)
	end
	if var2 == 309 then
		event.open_message_window_2(
			0,
			"Je respecte beaucoup le patron. Il\nfaut reconna[UNI00ee]tre qu'un type qui\n[UNI00e9]crit un best-seller de 40 volumes<page> \"La Bible du G[UNI00e9]nie scientifique\n\" [UNI00e0] son [UNI00e2]ge, c'est quelqu'un."
		)
	end
	if var2 == 310 then
		event.open_message_window_2(
			0,
			"Je suis encore novice ici. Mais\nje progresse chaque jour, je\ndeviendrai un grand chercheur."
		)
	end
	if var2 == 311 then
		event.open_message_window_2(
			0,
			"Depuis ce labo, la vue sur la\nmer est exceptionnelle.<page>Tr[UNI00e8]s loin, [UNI00e0] l'horizon,\nl'obscurit[UNI00e9] de la mer et\ncelle du ciel fusionnent."
		)
	end
	if var2 == 312 then
		event.open_message_window_2(
			0,
			"Ici c'est le Labo N[UNI00b0]2.<page>Au Labo psy, les laboratoires\ntravaillent tous sur\ndes domaines diff[UNI00e9]rents."
		)
	end
	if var2 == 313 then
		event.open_message_window_2(
			0,
			"Ici, au Labo psy, nous simulons un\nenvironnement nocturne pour activer\nle pouvoir des lunites."
		)
	end
	if var2 == 314 then
		event.open_message_window_2(
			0,
			"Quand j'ai commenc[UNI00e9] ici, moi aussi\nje me perdais sans cesse dans les\nlabos. Je vais t'expliquer : le<page>Labo 1 est rouge, le 2 est bleu,\nle 3 est violet et le Labo 4 est\nvert. Chacun a sa propre couleur."
		)
	end
	if var2 == 315 then
		event.open_message_window_2(0, "L'embl[UNI00e8]me au-dessus du Labo\ncentral repr[UNI00e9]sente la lune.")
	end
	if var2 == 316 then
		event.open_message_window_2(
			0,
			"Il para[UNI00ee]t que ce Labo a pu [UNI00ea]tre\ntermin[UNI00e9] gr[UNI00e2]ce aux lunites apport[UNI00e9]es\npar Shingala, un Drac de mer. <page>Il semble que ces cr[UNI00e9]atures soient\nplut[UNI00f4]t intelligentes, hein ? "
		)
	end
	if var2 == 317 then
		event.open_message_window_2(
			0,
			"Ne lui dis pas que je t'ai dit [UNI00e7]a,<page> mais on en a ras-le-bol des\nsoi-disant blagues d'Osmond.\n Elles donnent envie de le frapper."
		)
	end
	if var2 == 318 then
		event.open_message_window_2(
			0,
			"C'est vrai, moi aussi, j'ai pris\npart aux [UNI00e9]tudes du Ver [UNI00e9]lectrique.\nL[UNI00e0], je bosse sur un autre projet.<page> Ah non ! Je ne dirai pas quoi !\nJe peux pas le raconter [UNI00e0] tout le\nmonde, c'est top secret !"
		)
	end
	if var2 == 319 then
		event.open_message_window_2(
			0,
			"Comment ? Toi aussi tu veux\ndevenir chercheur ?<page>C'est pas [UNI00e9]vident pour y arriver,\ntu sais.\nIl y a beaucoup de concurrence."
		)
	end
	if var2 == 320 then
		event.open_message_window_2(
			0,
			"Certains chercheurs critiquent le\ndesign du Labo psy. Pour ma part,\nje le trouve plut[UNI00f4]t chouette...<page> Mais il semble que je sois un\ndes rares [UNI00e0] l'appr[UNI00e9]cier."
		)
	end
	if var2 == 321 then
		event.open_message_window_2(
			0,
			"Nous discutons de recherches\ntr[UNI00e8]s confidentielles.<page>Pourriez-vous nous laisser\n seuls pendant un petit moment ?"
		)
	end
	if var2 == 322 then
		event.open_message_window_2(
			0,
			"Pardonnez-nous, mais notre\ndiscussion concerne des\nrecherches tr[UNI00e8]s confidentielles.<page>On ne peut pas vraiment vous\nparler pour le moment, alors..."
		)
	end
	if var2 == 323 then
		event.open_message_window_2(
			0,
			"Dr Nobb est tr[UNI00e8]s talentueux,\nbien s[UNI00fb]r, mais il\ntravaille aussi tr[UNI00e8]s dur.<page>En comparaison, je fais bien peu...\nJe serais presque paresseux..."
		)
	end
	if var2 == 324 then
		event.open_message_window_2(
			0,
			"C'est toi ? On m'a dit que tu\nt'[UNI00e9]tais pris le bec avec Dr Osmond.<page>Je ne critique pas. Je trouve [UNI00e7]a\nbien. La remise en cause permet\nsouvent de nouvelles d[UNI00e9]couvertes."
		)
	end
	if var2 == 325 then
		event.open_message_window_2(
			0,
			"Tu n'arrives pas [UNI00e0] t'habituer aux\nlumi[UNI00e8]res fortes, hein ?<page>Je suppose qu'il vous faudra\nun peu de temps pour vous y\nhabituer, vous qui venez du pass[UNI00e9]."
		)
	end
	if var2 == 326 then
		event.open_message_window_2(
			0,
			"H[UNI00e9] bien, je fais une petite\npause.<page> Il faut parfois donner [UNI00e0] son\ncerveau un temps de repos, sinon on\nfinit par perdre de son acuit[UNI00e9]."
		)
	end
	if var2 == 327 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
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
	if var2 == 328 then
		event.open_message_window_2(
			0,
			"J'ai une id[UNI00e9]e r[UNI00e9]volutionnaire. Un\nsyst[UNI00e8]me qui permettrait [UNI00e0] monstres\net hommes de vivre en harmonie.<page>Je vais cr[UNI00e9]er une machine qui\ncomprend la langue humaine."
		)
	end
	if var2 == 329 then
		event.open_message_window_2(
			0,
			"Les lunites sont [UNI00e0] la base de\ntoutes les activit[UNI00e9]s du Labo psy.<page>Sans elles, tous nos syst[UNI00e8]mes\ns'arr[UNI00ea]teraient instantan[UNI00e9]ment."
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
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.get_look_angle(var19 - var16, var21 - var18) or var22
		helper_76f23193(player_chara_2, var22)
		event.set_character_rotation(player_chara_2, 0.0, var22, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
end

return helper_9cb0ca44
