--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_40864615 = require("@lib/event/helper_40864615")

--- Helper function.
local function helper_747c054f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"J'habite ici maintenant,\nmais je m'inqui[UNI00e8]te\ndavantage pour Noirpierre I.<page>C'est moi qui vais\nfaire fonctionner le\ntrain, comme avant."
				)
				var4 = event.get_triggered_event_data_2(13) or var4
				helper_1c04a0eb(var4, -1, 0, 0)
				event.open_message_window_2(
					arg0,
					"Born[UNI00e9]o est un peu maladroit,\net [UNI00c9]rik encore bien jeune.<page>Pour les types comme moi,\nla vie se r[UNI00e9]sume [UNI00e0] maison-\nboulot-dodo jour apr[UNI00e8]s jour.<page>Mais que veux-tu, c'est la vie..."
				)
			else
				event.open_message_window_2(arg0, "Et Steve, que devient-il ?")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "Je n'en peux plus de rester dans ma\nchambre [UNI00e0] me tourner les pouces.")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"Plantes et fleurs ne s'[UNI00e9]panouissent\nque lorsqu'on s'en occupe. Jamais\nje ne pourrais les n[UNI00e9]gliger."
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"Je me demande ce que devient la\nbase secr[UNI00e8]te. Je ne peux pas faire\nv[UNI00e9]rifier, [UNI00e7]a reste un secret !"
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"Le violet est une couleur superbe.\nSa fra[UNI00ee]cheur est... chaleureuse et\nson c[UNI00f4]t[UNI00e9] sombre... lumineux."
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "Je pourrais aller au bout du monde\npour aider un malade.")
		end
		if arg1 == 7 then
			event.open_message_window_2(
				arg0,
				"Seul un grand chef peut concocter \ndes plats d[UNI00e9]licieux quel que \nsoit l'endroit o[UNI00f9] il se trouve."
			)
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "Les maisons, plus elles sont\nsolides, mieux c'est, non ?")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"Les noix, c'est bon, mais ces trucs\nrouges sont vraiment d[UNI00e9]licieux. Tu\npourrais m'en ramener d'autres ?"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"Le pire ennemi du livre, c'est\nl'humidit[UNI00e9]. Je ne supporterais\npas d'habiter pr[UNI00e8]s de l'eau."
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(
				arg0,
				"Mes v[UNI00ea]tements ne sont ni jolis, ni\ndans le vent, mais je peux faire\ndes habits comme personne."
			)
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "Ce lieu m'a rajeunie. Comme si\nje redevenais une jeune boulang[UNI00e8]re.")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "Peu importe quoi,\nj'ai juste envie de\npulv[UNI00e9]riser quelque chose !")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "Si tu d[UNI00e9]couvres un nouveau monstre,\nsignale-le imm[UNI00e9]diatement.")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"Certains disent que c'est pas pour\nles femmes, mais l'[UNI00e9]p[UNI00e9]e s'en moque\nbien, elle. Le meilleur l'emporte."
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "Cette petite maison pourrait faire\nl'affaire pour [UNI00e9]lever des enfants.")
		end
		if arg1 == 17 then
			event.open_message_window_2(
				arg0,
				"Je me demande si Morton arrive [UNI00e0] se\nd[UNI00e9]brouiller. Il m'inqui[UNI00e8]te un peu."
			)
		end
		if arg1 == 18 then
			event.open_message_window_2(
				arg0,
				"Si tu connais une ville ayant\nbesoin d'[UNI00e9]glise, je suis le pr[UNI00ea]tre\nqu'il te faut ! Fais-moi signe."
			)
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"Je n'ai pas beaucoup pens[UNI00e9] [UNI00e0] la\nlune derni[UNI00e8]rement. [UNI00c7]a doit [UNI00ea]tre [UNI00e0]\ncause de tous mes nouveaux amis."
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(
				arg0,
				"Autres lieux, autres poissons.\nIl faut savoir s'adapter en\nfonction de l'environnement."
			)
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "Une eau parfaite pour les poissons.")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"Parn a commenc[UNI00e9] un nouveau portrait\nde femme. Elle sera soi-disant\nencore plus jolie que moi."
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(arg0, "Je me demande pourquoi les\ninsectes sont si r[UNI00e9]pugnants...")
		end
		if arg1 == 24 then
			event.open_message_window_2(arg0, "Tu pourrais embellir ma maison ?\nUne maison n'est jamais trop\nbelle, tu sais !")
		end
		if arg1 == 25 then
			event.open_message_window_2(
				arg0,
				"Je n'aurais jamais imagin[UNI00e9]\nd[UNI00e9]m[UNI00e9]nager [UNI00e0] mon [UNI00e2]ge."
			)
		end
	else
		helper_40864615(arg0, arg1)
	end
end

return helper_747c054f
