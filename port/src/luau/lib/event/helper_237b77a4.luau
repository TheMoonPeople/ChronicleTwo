--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_927b384d = require("@lib/event/helper_927b384d")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_237b77a4()
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
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Wie? Wer seid ihr ...? Dies ist \ndie weltbeste Forschungs-\neinrichtung, das Mondweisheits-<page>Laboratorium. Es sieht vielleicht im\nMoment nicht beeindruckend aus, aber\nwir sollten dennoch unsere<page>Forschungen hier beenden\nk[UNI00f6]nnen."
				)
			else
				event.MesMake_2(
					0,
					"Worte allein k[UNI00f6]nnen nicht\nbeschreiben, wie gro[UNI00df]artig das\nMondlabor ist.<page>Man muss es gesehen haben."
				)
			end
		else
			event.MesMake_2(
				0,
				"Wenn Griffon nicht beseitigt\nwird, kann die Geschichte nie wieder\nnormal werden.<page>Seine blo[UNI00df]e Existenz\nverzerrt den Lauf der\nGeschichte."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haahn, schuuu,\nhaahn, schuuu.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Hier ein paar Tipps zur\nErfindung eines Aquariums. Eine\nHolzkiste, ein Fenster und ein<page>Springbrunnen. Die gibt's doch\nin eurer Stadt, nicht wahr?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							'Verf[UNI00fc]ttere erst einen "Elektro-Wurm"\nan einen Fisch im Aquarium,\num ihn unter Strom zu setzen.<page>Verf[UNI00fc]ttere dann den Fisch\nan den Shigura.\nHast du das verstanden?'
						)
					else
						event.MesMake_2(
							0,
							"Oh, du hast den Fisch, ja?\nGib ihn jetzt dem Shigura.\nDas schaffst du locker, was?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"So! Du hast es geschafft!\nMeine Erfindung hat dir\nalso geholfen. Ja, tats[UNI00e4]chlich."
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(
			0,
			"Ob Osmond oder der Forschungs-\nleiter - hier gibt's einfach\nviel zu viele Verr[UNI00fc]ckte."
		)
	end
	if var2 == 303 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(448) or flag_8
					if flag_8 == 0 then
						event.MesMake_2(
							0,
							"Pass gut auf das Muschel-\nPhon auf, ja? Das ist eine der wichtigsten\nErfindungen des Mondlabors."
						)
					else
						event.MesMake_2(
							0,
							"Die Zeit dr[UNI00e4]ngt. Du musst dich\nbeeilen, Griffons Streitmacht n[UNI00e4]hert\nsich Elena und hat sie bald ..."
						)
					end
				else
					event.MesMake_2(0, "Was dieser Griffon wohl f[UNI00fc]r\nein Mensch ist ...")
				end
			else
				event.MesMake_2(
					0,
					"Edelsteine suchst du, ja ...?\nDas sind Weisheitskristalle, die\ndie Alten schufen.<page>Einer Analyse des Mondlabors\nzufolge gibt es sie an vier\nOrten:"
				)
				helper_927b384d(player_chara, var1, 0)
				helper_b5a98ffa(0, -1, var1, player_chara, 0)
				var3 = 1
				event.MesMake_2(
					0,
					"Im Regenbogen-Schmetterling-Wald,\nim Sternenlicht-Canyon, in der\nH[UNI00f6]hle des Meeresdonners und auf dem<page>Gundorberg. Am Eingang dieser Orte\nm[UNI00fc]sste ein Sternsymbol sein, also\nhalte die Augen offen."
				)
			end
		else
			event.MesMake_2(
				0,
				"Na gut, es ist an der Zeit, Griffon\nauszuschalten. Das Schicksal der\nWelt liegt in deinen H[UNI00e4]nden.<page>Viel Gl[UNI00fc]ck!"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"Hier im Labor geht's nur um\nFertigkeit. Mit der richtigen Fertigkeit\nk[UNI00f6]nnte selbst ein Kind hier<page>zum Chef werden."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Die Mondsteine, die die Shigura\nuns bringen, helfen uns, einen klaren\nKopf zu behalten und uns zu<page>konzentrieren. Aber was die\nMondsteine genau sind, wei[UNI00df]\nich leider nicht ..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Ein Labor auf dem Meer ist ganz\ncool, oder? Wei[UNI00df]t du, wie schwer\nich schuften musste, um hier<page>einen Job zu kriegen?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Was h[UNI00e4]ltst du vom Design des\nMondlabors? Ich frage mich, wer diese\nVergn[UNI00fc]gungspark-Idee hatte ..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Eines Tages [UNI00fc]berfl[UNI00fc]gele ich\nalle und zeige, wie schlau ich bin.\nHier geht's nur um Fertigkeit. "
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			'Ich respektiere den Chef sehr.\nDas muss man einfach, wenn\njemand in seinem Alter einen<page>40-seitigen Bestseller namens\n"Handbuch f[UNI00fc]r Top-Forscher" schreibt.'
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Ich bin noch recht neu hier.\nIch lerne viel und will sp[UNI00e4]ter\nmal ein Top-Forscher werden."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"Die Aussicht aufs Meer aus diesem\nLabor ist unglaublich.<page>Am Horizont vereinigen sich die\nDunkelheit des Meeres und die\ndes Himmels."
		)
	end
	if var2 == 312 then
		event.MesMake_2(0, "Dies ist Labor Nr. 2.<page>Im Mondlabor hat jede\nAbteilung ihr eigenes\nForschungsgebiet.")
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Hier im Mondlabor simulieren wir\neine n[UNI00e4]chtliche Umwelt, um die\nKraft der Mondsteine zu verst[UNI00e4]rken."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Als ich hier angefangen habe,\nkonnte ich die Labors auch nie\nauseinanderhalten. Ich helfe dir.<page>Labor 1 ist rot, Labor 2\nist blau, Labor 3 ist lila\nund Labor 4 gr[UNI00fc]n.<page>Jedes Labor hat also seine\neigene Farbe."
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "Das Emblem [UNI00fc]ber dem Zentral-\nLabor ist dem Mond\nnachempfunden.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Angeblich wurde dieses Monlabor\nmithilfe von Mondsteinen gebaut,\ndie ein Seedrache namens<page>Shingala herbrachte. Manche dieser\nSeedrachen m[UNI00fc]ssen wohl recht\nschlau sein!"
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Erz[UNI00e4]hl ihm nicht, dass ich das\ngesagt habe, aber<page>Osmonds so genannte Witze\nstehen uns bis hier.\nSie machen einen krank. "
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"Ich kann nicht l[UNI00fc]gen. Ja, auch\nich habe [UNI00fc]ber den Elektro-Wurm\ngeforscht. Jetzt hab ich ein<page>neues Projekt. Aber ich darf's\nnicht verraten! Streng geheim!\nAusgeplaudert wird nichts!"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Wie? Ihr wollt auch Forscher\nwerden?<page>Es ist nicht leicht, hier\naufgenommen zu werden.\nDie Konkurrenz ist hart."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Manche Forscher m[UNI00f6]gen das Design\ndes Mondlabors nicht. Ich finde\nes eigentlich cool ...<page>Aber damit geh[UNI00f6]re ich\nwohl zur Minderheit."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Wir sprechen gerade [UNI00fc]ber streng\ngeheime Forschungsdaten.<page>K[UNI00f6]nntest du uns bitte\nallein lassen?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Es tut mir sehr Leid,\naber wir besprechen gerade streng\ngeheime Forschungsdaten.<page>Das geht nicht, wenn du hier\nherumstehst, also ..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Nat[UNI00fc]rlich ist Dr. Nobb begabt,\naber auch sehr flei[UNI00df]ig.<page>Ich bin nichts dagegen ...\nWie ein Staubkorn ..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"Du? Ich hab geh[UNI00f6]rt, du hast mit\nDr. Osmond gestritten.<page>Das ist nicht schlecht - eigentlich\nsogar gut. Wir entdecken nur\ndann Neues, wenn wir alles<page>in Frage stellen."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Das helle Licht st[UNI00f6]rt dich, ja?<page>Ihr Besucher aus der Vergangenheit\nm[UNI00fc]sst euch wohl einfach\netwas eingew[UNI00f6]hnen."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"Ach, ich mach nur ein P[UNI00e4]uschen.<page>Man muss seinem Hirn auch mal\nRuhe g[UNI00f6]nnen, sonst bringt\nman's irgendwann nicht mehr."
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"Du sollst ein guter Erfinder sein.\nWie w[UNI00e4]r's - kommst du zu uns,\nwenn du gro[UNI00df] bist?<page>Hey, wenn du erwachsen wirst, wird\ndieses Mondlabor gerade neu\neingerichtet worden sein.<page>Die sind bestimmt froh,\nwenn du kommst."
			)
		else
			event.MesMake_2(
				0,
				"Findest du Erfinder nicht auch\ntotal m[UNI00e4]nnlich?<page>Aber verlieb dich blo[UNI00df] nicht\nin mich, klar? Meine Arbeit\nist mein Leben.<page>Es w[UNI00fc]rde nie funktionieren."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"Ich hab eine revolution[UNI00e4]re Idee.\nSie soll erm[UNI00f6]glichen, dass Monster\nund Menschen zusammenleben.<page>Ich baue eine Maschine,\ndie die menschliche\nSprache versteht."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Die Mondsteine sind die\nGrundlage des Mondlabors.<page>Ohne sie w[UNI00fc]rde hier\nsofort alles stillstehen."
		)
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
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.GetRotLookPos(var19 - var16, var21 - var18) or var22
		helper_cfca3481(player_chara_2, var22)
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
end

return helper_237b77a4
