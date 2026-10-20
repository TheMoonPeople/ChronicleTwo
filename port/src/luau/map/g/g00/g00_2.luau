--!strict
-- map/g/g00/g00_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_62059bfe = require("@lib/event/helper_62059bfe")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_bf8a16c2 = require("@lib/event/helper_bf8a16c2")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_be7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(
			arg0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "H[UNI00e9], [UNI00e7]a roule ? Moi, c'est l'top !")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Je prie pour que le monde vive\nenfin en paix.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
end

--- Helper function.
local function helper_208a8(arg0: s32, arg1: s32, sp: number)
	local junk = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 8)
			junk += 3
		end
		helper_be7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"J'habite ici maintenant,\nmais je m'inqui[UNI00e8]te\ndavantage pour Noirpierre I.<page>C'est moi qui vais\nfaire fonctionner le\ntrain, comme avant."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Born[UNI00e9]o est un peu maladroit,\net [UNI00c9]rik encore bien jeune.<page>Pour les types comme moi,\nla vie se r[UNI00e9]sume [UNI00e0] maison-\nboulot-dodo jour apr[UNI00e8]s jour.<page>Mais que veux-tu, c'est la vie..."
				)
			else
				event.MesMake_2(arg0, "Et Steve, que devient-il ?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "Je n'en peux plus de rester dans ma\nchambre [UNI00e0] me tourner les pouces.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Plantes et fleurs ne s'[UNI00e9]panouissent\nque lorsqu'on s'en occupe. Jamais\nje ne pourrais les n[UNI00e9]gliger."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Je me demande ce que devient la\nbase secr[UNI00e8]te. Je ne peux pas faire\nv[UNI00e9]rifier, [UNI00e7]a reste un secret !"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Le violet est une couleur superbe.\nSa fra[UNI00ee]cheur est... chaleureuse et\nson c[UNI00f4]t[UNI00e9] sombre... lumineux."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Je pourrais aller au bout du monde\npour aider un malade.")
		end
		if arg1 == 7 then
			event.MesMake_2(
				arg0,
				"Seul un grand chef peut concocter \ndes plats d[UNI00e9]licieux quel que \nsoit l'endroit o[UNI00f9] il se trouve."
			)
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Les maisons, plus elles sont\nsolides, mieux c'est, non ?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Les noix, c'est bon, mais ces trucs\nrouges sont vraiment d[UNI00e9]licieux. Tu\npourrais m'en ramener d'autres ?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Le pire ennemi du livre, c'est\nl'humidit[UNI00e9]. Je ne supporterais\npas d'habiter pr[UNI00e8]s de l'eau."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"Mes v[UNI00ea]tements ne sont ni jolis, ni\ndans le vent, mais je peux faire\ndes habits comme personne."
			)
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "Ce lieu m'a rajeunie. Comme si\nje redevenais une jeune boulang[UNI00e8]re.")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "Peu importe quoi,\nj'ai juste envie de\npulv[UNI00e9]riser quelque chose !")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Si tu d[UNI00e9]couvres un nouveau monstre,\nsignale-le imm[UNI00e9]diatement.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Certains disent que c'est pas pour\nles femmes, mais l'[UNI00e9]p[UNI00e9]e s'en moque\nbien, elle. Le meilleur l'emporte."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "Cette petite maison pourrait faire\nl'affaire pour [UNI00e9]lever des enfants.")
		end
		if arg1 == 17 then
			event.MesMake_2(
				arg0,
				"Je me demande si Morton arrive [UNI00e0] se\nd[UNI00e9]brouiller. Il m'inqui[UNI00e8]te un peu."
			)
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Si tu connais une ville ayant\nbesoin d'[UNI00e9]glise, je suis le pr[UNI00ea]tre\nqu'il te faut ! Fais-moi signe."
			)
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"Je n'ai pas beaucoup pens[UNI00e9] [UNI00e0] la\nlune derni[UNI00e8]rement. [UNI00c7]a doit [UNI00ea]tre [UNI00e0]\ncause de tous mes nouveaux amis."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(
				arg0,
				"Autres lieux, autres poissons.\nIl faut savoir s'adapter en\nfonction de l'environnement."
			)
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Une eau parfaite pour les poissons.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn a commenc[UNI00e9] un nouveau portrait\nde femme. Elle sera soi-disant\nencore plus jolie que moi."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "Je me demande pourquoi les\ninsectes sont si r[UNI00e9]pugnants...")
		end
		if arg1 == 24 then
			event.MesMake_2(arg0, "Tu pourrais embellir ma maison ?\nUne maison n'est jamais trop\nbelle, tu sais !")
		end
		if arg1 == 25 then
			event.MesMake_2(
				arg0,
				"Je n'aurais jamais imagin[UNI00e9]\nd[UNI00e9]m[UNI00e9]nager [UNI00e0] mon [UNI00e2]ge."
			)
		end
	else
		helper_be7c(arg0, arg1)
	end
end

--- Helper function.
local function helper_22004(sp: number)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	helper_208a8(0, var2, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_222f8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7e2956fd(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_7e2956fd(1)
	event.Finish()
end

--- Helper function.
local function helper_224a4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		helper_222f8()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_222f8()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e594(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(
			arg0,
			"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
		)
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_ec1c(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return helper_e594(arg0)
		end
		if at <= 5 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return helper_e594(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Va me chercher un\nM[UNI00e9]mo de scoops, tu veux bien ?")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "On dirait qu'il n'y\na plus de scoops.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_e594(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_4005e7b5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "J'ai trouv[UNI00e9] [Number1] nouveau(x) scoop(s).")
		event.SetMesDrawspeed(arg0, 0)
		helper_d1353c5b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_4005e7b5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allez ! Arr[UNI00ea]te de lambiner !\nIls sont o[UNI00f9] tes super scoops ?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ouah ! Tu as [Number1] nouveau(x)\nscoop(s) ! Je savais que tu y\narriverais.")
	end
	if now_map_no == 22 then
		helper_b8950300(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_d1353c5b(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_e594(arg0)
end

--- Helper function.
local function helper_d2a4()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Bravo ! Les hommes ne sont\npas si mauvais apr[UNI00e8]s tout !<page>J'avais tort !")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00c7]a y est. C'est presque termin[UNI00e9].\nIl ne reste plus qu'[UNI00e0] le vaincre.<page>Apr[UNI00e8]s [UNI00e7]a, le monde pourra revivre."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Je crois comprendre Griffon, mais\nje ne pourrai jamais lui pardonner.")
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Reconstruis le jardin, et d[UNI00e9]couvre\nle secret de Griffon, euh... Sirus.")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Qu'est-ce que [UNI00e7]a veut dire les\n\"souvenirs de Sirus\"?\nJe suppose qu'il\nfaut entrer au palais pour comprendre."
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Vite, Griffon va s'[UNI00e9]chapper, allons\nau Palais de fleur-lune !")
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Les pierres semblent toutes l[UNI00e0].\nAllons vite [UNI00e0] Stonehenge Kazarov.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Peu importe, trouvons vite les\npierres, ou il sera trop tard.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Tout a d[UNI00e9]but[UNI00e9] dans ce palais,\nhein. Bon, allons dans le jardin.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Rentrons au Labo psy. Peut-[UNI00ea]tre\nauront-ils fini l'Ixion ?")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Il est temps de riposter contre\nGriffon. Allons au QG de Paznos.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Galen Agaris a dit que jouer de la\nCorne de feu t'ouvrirait la route.")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Il faut pulv[UNI00e9]riser ce Lance-feu.<page>Il serait au sommet du Mt Gundor.")
		return
	end
	event.MesMake_2(
		3,
		"Attendre ici ne changera rien.<page>Il y a s[UNI00fb]rement un lieu o[UNI00f9] on\nn'est pas encore all[UNI00e9]s."
	)
end

--- Helper function.
local function helper_225c0(sp: number)
	local junk = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var4 = 0
				var4 = 20
				var4 = 24
				var4 = 28
				var4 = 32
				var4 = 40
				var4 = 44
				var4 = 48
				var4 = 52
				var4 = 56
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
				junk += 25
			end
			if at <= 2 then
				var29 = 0
				helper_4005e7b5(3, 1)
				helper_208a8(3, var2, sp + junk + 34)
				junk += 1
			end
			if at <= 3 then
				var30 = -1
				helper_4005e7b5(1, 8)
				helper_dc39b923(1, 1, 1, 0, 0)
				helper_4005e7b5(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
				junk += 3
			end
			helper_222f8()
			return
		end
		if at <= 6 then
			helper_222f8()
			return
		end
		if at <= 11 then
			if at <= 7 then
				helper_4005e7b5(3, 8)
				helper_d1353c5b(3, var30, 9, 0, 0)
				junk += 1
			end
			if at <= 8 then
				helper_d1353c5b(3, -1, 3, 256, 208)
				junk += 4
			end
			if at <= 9 then
				helper_222f8()
				helper_224a4(6)
				junk += 1
			end
			if at <= 10 then
				helper_224a4(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_224a4(33)
			end
			return
		end
		if at <= 14 then
			helper_224a4(1)
			junk += 1
		end
		if at <= 15 then
			helper_224a4(2)
			junk += 1
		end
		if at <= 16 then
			helper_224a4(3)
			junk += 1
		end
		if at <= 17 then
			helper_224a4(7)
			junk += 1
		end
		if at <= 18 then
			helper_224a4(8)
			junk += 1
		end
		if at <= 19 then
			helper_224a4(9)
			junk += 1
		end
		if at <= 20 then
			helper_224a4(10)
			junk += 1
		end
		if at <= 21 then
			helper_224a4(11)
			junk += 1
		end
		if at <= 22 then
			helper_224a4(12)
			junk += 1
		end
		if at <= 23 then
			helper_224a4(13)
			junk += 1
		end
		if at <= 24 then
			helper_224a4(14)
			junk += 1
		end
		if at <= 25 then
			helper_224a4(15)
			junk += 1
		end
		if at <= 26 then
			helper_224a4(16)
			junk += 1
		end
		if at <= 27 then
			helper_224a4(17)
			junk += 1
		end
		if at <= 28 then
			helper_224a4(18)
			junk += 1
		end
		if at <= 29 then
			helper_224a4(19)
			junk += 1
		end
		if at <= 30 then
			helper_224a4(20)
			junk += 1
		end
		if at <= 31 then
			helper_224a4(21)
			junk += 1
		end
		if at <= 32 then
			helper_224a4(22)
			junk += 1
		end
		if at <= 33 then
			helper_224a4(32)
			junk += 1
		end
		if at <= 34 then
			helper_d2a4()
			helper_d1353c5b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_222f8()
			helper_b0211f82(30)
			junk += 1
		end
		helper_222f8()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_4005e7b5(3, 1)
		helper_208a8(3, var2, sp + junk + 33)
		if vm.skipping() then
			return skip(3)
		end
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_4005e7b5(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_dc39b923(1, 1, 1, 0, 0)
		helper_4005e7b5(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(4)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_222f8()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_b0211f82(30)
				if vm.skipping() then
					return skip(5)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(6)
				end
				helper_222f8()
				event.SetFadeIn(30)
				return
			end
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]Tu ne peux pas faire [UNI00e7]a maintenant. Tu\ndois d'abord emmener Lin au phare !"
			)
			helper_d1353c5b(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_d1353c5b(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Tr[UNI00e8]s bien, on a termin[UNI00e9]\nles r[UNI00e9]parations !")
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_222f8()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_224a4(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_224a4(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_ec1c(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_224a4(33)
							if vm.skipping() then
								return skip(13)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_224a4(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_224a4(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_224a4(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_224a4(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_224a4(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_224a4(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_224a4(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_224a4(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_224a4(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_224a4(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_224a4(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_224a4(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_224a4(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_224a4(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_224a4(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_224a4(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_224a4(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_224a4(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_224a4(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_224a4(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_224a4(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d2a4()
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_222f8()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_b0211f82(30)
						if vm.skipping() then
							return skip(36)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(37)
						end
						helper_222f8()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_222f8()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_c6c63376

--- Program 100.
script[100] = function()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "お洒落")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_225c0(sp + 0)
		end
	end
	helper_22004(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_225c0(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

return script
