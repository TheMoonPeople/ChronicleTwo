--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b3fc698 = require("@lib/event/helper_2b3fc698")
local helper_92866686 = require("@lib/event/helper_92866686")
local helper_afa3edbd = require("@lib/event/helper_afa3edbd")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f30d69fc = require("@lib/event/helper_f30d69fc")

--- Helper function.
local function helper_a5b894b6()
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_afa3edbd(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_92866686(player_chara_2, var20)
		end
		if at <= 5 then
			helper_b8950300(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_f30d69fc(30)
		end
		if at <= 7 then
			helper_f30d69fc(28)
		end
		if at <= 8 then
			helper_f30d69fc(29)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"Gaspard [UNI00e8] un rivale formidabile.\nNon abbassate la guardia,\nneppure per un istante!<page>So che potete sconfiggerlo.\nCi sar[UNI00e0] una ragione se le\nAtlamillia hanno scelto voi..."
						)
					else
						event.MesMake_2(
							0,
							"S[UNI00ec], anche Gaspard era infelice.<page>Perch[UNI00e9] mai Grifone vuole rovinare\nla vita alla gente di due ere?"
						)
					end
				else
					event.MesMake_2(
						0,
						"Se qualcuno pu[UNI00f2] battere Grifone,\nquelli siete proprio voi.<page>Contiamo su di voi."
					)
				end
			else
				event.MesMake_2(
					0,
					"I Raccordi temporali... Cos[UNI00ec], il\nmondo verr[UNI00e0] salvato grazie alla\nsaggezza degli antichi..."
				)
			end
		else
			event.MesMake_2(
				0,
				"Cos[UNI00ec], ci siamo, eh? Il sangue di\nmolti amici [UNI00e8] stato versato\ncombattendo Grifone...<page>Siete la nostra ultima speranza!\nMax, Monica, conto su voi due.\nDovete sconfiggere Grifone!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"Bene, per prima cosa dovrete \ndistruggere la Sputa Fuoco.<page>Se non facciamo qualcosa per\nquesta pioggia di fuoco,\nDesolandia [UNI00e8] spacciata."
							)
						else
							event.MesMake_2(
								0,
								"OK, ecco cos'[UNI00e8] successo!\nDobbiamo essere contenti che\nla Sputa Fuoco sia fuori gioco."
							)
							helper_2b3fc698(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_b8950300(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"Ma sono preoccupato per la tua\namica precipitata nel cratere.<page>L'unica cosa che possiamo fare\nora [UNI00e8] ricostruire Desolandia e\nl'Officina meglio di prima."
							)
						end
					else
						event.MesMake_2(
							0,
							"Avete sconfitto Gaspard! Ragazzi,\nsiete semplicemente incredibili!<page>Ora tocca al capo, l'Imperatore\nGrifone. Sistematelo per sempre!"
						)
					end
				else
					event.MesMake_2(
						0,
						"Che gioia vedere il Paznos in\nazione! [UNI00c8] stato commovente.<page>Finalmente il nostro duro lavoro\nha dato i suoi frutti."
					)
				end
			else
				event.MesMake_2(0, "Gemma? Mmh, mi spiace, non ho\nproprio idea di cosa sia.")
			end
		else
			event.MesMake_2(0, "[UNI00c8] ora di affrontare Grifone, eh?\nBuona fortuna. Acciuffatelo!")
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "Ehil[UNI00e0]! Abbiamo tutta roba buona!\nAllora, cosa posso offrirvi?")
	end
	if var2 == 403 then
		event.MesMake_2(0, "Qualsiasi cosa serva, sono l'uomo\ngiusto. Ho tutto!")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"Il combattimento pu[UNI00f2] farsi duro.\nNon puoi affrontare ogni<page>situazione ad armi spianate.<page>Fatti furbo, usa anche gli\noggetti. Scopri le debolezze dei\nnemici e sfruttale a tuo favore!"
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"Si pu[UNI00f2] fare tutto nell'Officina\nGundorandia. Non importa se grande\no piccolo, noi lo faremo!"
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"Ehi ragazzi, come siete entrati?\nState attenti! Pu[UNI00f2] diventare\npericoloso qui dentro."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "Cos'[UNI00e8] successo in tutto questo\ntempo? Non riesco proprio\na ricordare...")
	end
	if var2 == 408 then
		event.MesMake_2(0, "Grifone ci ha eliminati dalla\nstoria, eh? Che mostro terribile!")
	end
	if var2 == 409 then
		event.MesMake_2(0, "Ho da fare ora.\nVolete togliervi di torno?")
	end
	if var2 == 410 then
		event.MesMake_2(0, "Facciamo tutti il tifo per voi.\nVi appoggiamo al 100%.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Sembra che le armi\nqui dentro non\nsiano in vendita.<page>Certo ci sono delle armi\nveramente strane e\nmeravigliose al mondo..."
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"Allora quel tipo, Gaspard, pu[UNI00f2]\ncontrollare la Sputa Fuoco?<page>Non [UNI00e8] solo furbo...\n[UNI00c8] proprio malvagio!"
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"Cos'[UNI00e8] quel cuore\nsull'insegna?<page>[UNI00c8] abbastanza disgustoso,\nse mi permetti..."
		)
	end
	if var3 == 0 then
		helper_afa3edbd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_b8950300(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_92866686(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b8950300(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_f30d69fc(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_f30d69fc(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_f30d69fc(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

return helper_a5b894b6
