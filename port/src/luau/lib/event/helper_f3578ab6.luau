--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f3578ab6()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
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

return helper_f3578ab6
