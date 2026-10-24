--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_c1919660()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local player_chara_2: s32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	var3 = 0
	flag = event.GetFlag(324) or flag
	flag_2 = event.GetFlag(330) or flag_2
	flag_3 = event.GetFlag(372) or flag_3
	flag_4 = event.GetFlag(400) or flag_4
	flag_5 = event.GetFlag(640) or flag_5
	if var2 == 200 then
		if flag_5 == 0 then
			if flag_2 == 0 then
				if flag == 0 then
					event.MesMake_2(
						0,
						"Pour faire le plat miracle, il me\nfaut une fleur de vent-blanc. Et\nmalheureusement, je n'en ai plus."
					)
				else
					event.MesMake_2(
						0,
						"Tu as d[UNI00e9]j[UNI00e0] go[UNI00fb]t[UNI00e9] une boulette\nmiracle ? Elle perd ses effets en\nrefroidissant, il faut manger vite."
					)
				end
			else
				event.MesMake_2(
					0,
					"La boulette miracle a march[UNI00e9] ?\nJ'en suis bien content. H[UNI00e9],\ntu veux manger avant de partir ?"
				)
			end
		else
			event.MesMake_2(0, "Mais il ne reste plus beaucoup\nde temps, non ? Bonne chance,\nen tout cas.")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"Les diff[UNI00e9]rents objets ont des\neffets divers. Ils peuvent\nt'aider, se transformer en arme...<page>Sois inventif et tu pourras vaincre\nm[UNI00ea]me tes ennemis les plus coriaces.\nEssaie tout ce que tu peux."
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Je n'arrive pas [UNI00e0] croire que ce\ntemple ait [UNI00e9]t[UNI00e9] ras[UNI00e9] par ce \ndiabolique Empereur Griffon...<page>Si seulement Crest le Grand sage\n[UNI00e9]tait ici..."
			)
		else
			event.MesMake_2(
				0,
				"Maintenant que Crest est de\nretour, il n'y a rien [UNI00e0] craindre.\nAllez-y, partez affronter Griffon."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Comme le Cristal lunaire est\nplus puissant la nuit, ce temple\nest perp[UNI00e9]tuellement dans le noir.<page>Il utilise la force du temple pour\ncr[UNI00e9]er une zone d'obscurit[UNI00e9]."
			)
		else
			event.MesMake_2(
				0,
				"Le Grand Crest utilise le\npouvoir du Cristal lunaire\npour tout voir du monde. <page>Rien n'[UNI00e9]chappe au regard\ntout-puissant de Crest."
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Salut ! On a un super choix en\nmagasin. Robustes et solides, telle\nest la r[UNI00e9]putation de nos armes."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"H[UNI00e9] ! Arr[UNI00ea]tez de tergiverser et\nallez montrer [UNI00e0] ce Griffon\nqui est le chef ici !"
				)
			else
				event.MesMake_2(
					0,
					"Voil[UNI00e0], c'est l[UNI00e0] que je m'arr[UNI00ea]te.\nC'est [UNI00e0] vous de jouer maintenant.\nEt m[UNI00e9]fiez-vous de ce Griffon hein ?<page>Vous m'avez sauv[UNI00e9] la vie et si\nquelqu'un peut r[UNI00e9]ussir, c'est vous."
				)
			end
		else
			event.MesMake_2(
				0,
				"On dirait que votre voyage touche\npresque [UNI00e0] sa fin. Vous devez\nbattre ce Griffon, pour nous tous.<page>Il faut le vaincre co[UNI00fb]te que co[UNI00fb]te.\nApr[UNI00e8]s... Crest et moi... pourrons\nenfin devenir de Grands sages."
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"M[UNI00ea]me si le temple est revenu [UNI00e0] la\nnormale, sans Crest, le Temple\nastral est inutile. <page>Seul Crest d[UNI00e9]tient le pouvoir\nastrologique n[UNI00e9]cessaire [UNI00e0]\nl'observation du monde entier."
			)
		else
			event.MesMake_2(
				0,
				"M[UNI00ea]me le Grand Crest a [UNI00e9]t[UNI00e9] un jour\nl'apprenti d'un sage. Ce fut sans\ndoute un excellent professeur..."
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(0, "La nourriture est digne d'un roi\nici. J'en salive rien que\nd'y penser.")
		else
			event.MesMake_2(0, "Il a cuisin[UNI00e9] son plat miracle !\nLao Chao est vraiment un grand chef !")
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Une fois que tu auras d[UNI00ee]n[UNI00e9] ici,\nrien n'aura plus jamais le m[UNI00ea]me\ngo[UNI00fb]t. C'est absolument d[UNI00e9]licieux."
			)
		else
			event.MesMake_2(
				0,
				"Oah ! [UNI00c7]a, j'aimerais vraiment\nessayer aussi quelques-unes de\nces boulettes miracle !"
			)
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Tu trouves le Sablier stellaire\nun peu bizarre... ? Ah oui ?<page>J'en ai un moi aussi mais je n'en\nsuis pas tr[UNI00e8]s content... Il n'a\njamais invers[UNI00e9] le cours du temps."
			)
		else
			event.MesMake_2(
				0,
				"C'est super que vous ayez [UNI00e9]t[UNI00e9]\namis avec Crest le Grand sage.<page>Je n'avais pas r[UNI00e9]alis[UNI00e9] que\nvous [UNI00e9]tiez aussi proches..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Crest le Grand sage n'est pas ici.\nJe me demande o[UNI00f9] il est parti...<page>C'est [UNI00e9]trange, mais on est mal\n[UNI00e0] l'aise quand il n'est pas l[UNI00e0]."
			)
		else
			event.MesMake_2(
				0,
				"Crest m'a racont[UNI00e9] une fois \nqu'un certain Gaspard avait tent[UNI00e9]\nde d[UNI00e9]truire le Cristal lunaire.<page>Et que le ma[UNI00ee]tre du Grand sage\ns'[UNI00e9]tait sacrifi[UNI00e9] pour le prot[UNI00e9]ger."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Crest le Grand sage a disparu\navec le Cristal lunaire,\npour le prot[UNI00e9]ger... ?<page>Je ne comprends pas..."
			)
		else
			event.MesMake_2(
				0,
				"Le pouvoir du Cristal lunaire\nest hallucinant hein ? Mais seule\nune personne peut l'utiliser...<page>Crest le Grand sage...<page>Les gens comme toi et moi ne\npourraient jamais faire ce genre de\nchoses."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Serait-ce vous... ? Le Grand Crest\nm'a dit qu'un jour une fille\net un gar[UNI00e7]on viendraient [UNI00e0] moi...<page>Je savais que cette proph[UNI00e9]tie\nallait se r[UNI00e9]aliser !<page>Mais, malheureusement, le Grand\nsage a disparu."
			)
		else
			event.MesMake_2(
				0,
				"10 000 ans ?<page>Le Labo psy pourrait accomplir un\nmiracle dont m[UNI00ea]me Crest le Grand\nsage est incapable ?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"La lune a d'[UNI00e9]tranges pouvoirs qui\naffectent toutes sortes d'[UNI00ea]tres\nvivants.<page> Et c'est le Cristal lunaire\nqui incarne ce pouvoir."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Le meilleur restaurant\nau monde, c'est sans conteste\nle Bistrot de Lao Chao !<page>Tu en as entendu parler, non ?"
			)
		else
			event.MesMake_2(
				0,
				"Alors c'est donc vous. Crest le\nGrand Sage m'a parl[UNI00e9] de vous, vous\nauriez sauv[UNI00e9] sa vie autrefois.<page>Mais je n'aurais jamais imagin[UNI00e9] que\nvous n'[UNI00e9]tiez que des enfants..."
			)
		end
	end
	if var3 == 0 then
		helper_907fd9a8(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_b5a98ffa(0, -1, var1, player_chara, 0)
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var10 = out1 or var10
			var12 = out3 or var12
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var13 = out1 or var13
			var15 = out3 or var15
		end
		var16 = event.GetRotLookPos(var13 - var10, var15 - var12) or var16
		helper_cfca3481(player_chara_2, var16)
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_59a16271(5)
	end
	if var2 == 204 then
		helper_59a16271(27)
	end
end

return helper_c1919660
