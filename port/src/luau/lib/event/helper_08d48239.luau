--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_08d48239()
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
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
						"F[UNI00fc]r das Wunderrezept ben[UNI00f6]tige\nich eine Wei[UNI00df]e Windblume. Aber ich\nhabe keine. Tut mir Leid."
					)
				else
					event.MesMake_2(
						0,
						"Hast du schon die Wunderkl[UNI00f6][UNI00df]e\nprobiert? Wenn sie kalt werden, l[UNI00e4]sst\nihre Wirkung nach - iss schnell!"
					)
				end
			else
				event.MesMake_2(
					0,
					"Der Wunderklo[UNI00df] hat geholfen, was?\nFreut mich. He, willst du noch\nwas essen, bevor du gehst?"
				)
			end
		else
			event.MesMake_2(0, "Liebe G[UNI00fc]te, es ist Zeit, was?\nDann mal ran - an nichts, wie?")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"Verschiedene Gegenst[UNI00e4]nde haben\nunterschiedliche Wirkungen. Manche helfen,\nandere werden zu Waffen ...<page>Wenn du etwas experimentierst, kannst\ndu selbst die st[UNI00e4]rksten Gegner\nbesiegen. Probiere alles aus."
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Ich kann nicht fassen, dass der\nteuflische Kaiser Griffon diesen\nTempel vernichtet hat ...<page>W[UNI00e4]re doch nur\nCrest hier ..."
			)
		else
			event.MesMake_2(
				0,
				"Da Crest wieder bei uns\nist, haben wir nichts zu f[UNI00fc]rchten.\nGeh nun und stelle Griffon."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Dieser Tempel liegt in ewiger\nNacht, denn die Kraft des Mondkristalls\nist nachts am gr[UNI00f6][UNI00df]ten.<page>Er nutzt die Kraft des Tempels,\num das Gebiet in Nacht\nzu h[UNI00fc]llen."
			)
		else
			event.MesMake_2(
				0,
				"M[UNI00f6]ge Crest die Macht\ndes Mondkristalls nutzen,um alles auf\ndieser Welt zu sehen.<page>Niemand entkommt den allsehenden\nAugen von Crest. "
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Tag. Wir haben eine tolle\nAuswahl f[UNI00fc]r dich. Unsere Waffen\nsind bekannt f[UNI00fc]r ihre Robustheit."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"He! H[UNI00f6]r auf, herumzutr[UNI00f6]deln und zeig\ndiesem Griffon, wer hier der\nBoss ist! Beeil dich!"
				)
			else
				event.MesMake_2(
					0,
					"Tja, hier ist Schluss f[UNI00fc]r mich!\nAb jetzt liegt's an euch.\nK[UNI00fc]mmert euch um Griffon, ja?<page>Ihr habt mir das Leben gerettet.\nWenn irgendjemand diese Aufgabe\nbew[UNI00e4]ltigen kann, dann ihr."
				)
			end
		else
			event.MesMake_2(
				0,
				"Deine Reise scheint fast am Ende\nzu sein. Erledige diesen Griffon,\nf[UNI00fc]r Master und uns alle.<page>Du musst ihn unbedingt schlagen.\nWenn Griffon f[UNI00e4]llt ... k[UNI00f6]nnen Crest\nund ich ... echte Weise werden."
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Auch wenn er wieder normal ist, ist der\nSternenlicht-Tempel ohne Crest nutzlos.<page>Niemand au[UNI00df]er Crest hat die\ngewaltige astrologische Macht, die\nganze Welt zu [UNI00fc]berblicken."
			)
		else
			event.MesMake_2(
				0,
				"Selbst Crest war einst\nLehrling eines Weisen. Er muss\nein guter Lehrer gewesen sein ..."
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Das Essen hier ist erstklassig.\nMir l[UNI00e4]uft schon beim Gedanken daran\ndas Wasser im Mund zusammen ..."
			)
		else
			event.MesMake_2(
				0,
				"Er hat nach seinem Wunderrezept\ngekocht! Lao Chao ist ein\nwahrhaft gro[UNI00df]er Koch!"
			)
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Wenn du hier gegessen hast, wirst\ndu nie mehr etwas Vergleichbares\nessen. Es ist so toll!"
			)
		else
			event.MesMake_2(
				0,
				"Wow! Diese Wunderkl[UNI00f6][UNI00df]e w[UNI00fc]rde\nich ja zu gern auch mal\nprobieren!"
			)
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Du findest das Sternglas\nunheimlich?<page>Sag blo[UNI00df]! Ich hab auch eins,\naber ich halte nicht viel davon ...\nEs hat mit Sicherheit nie<page>die Zeit zur[UNI00fc]ckgedreht."
			)
		else
			event.MesMake_2(
				0,
				"Es ist toll, dass ihr mit Crest\nbefreundet wart.<page>Aber dass es eine so enge\nFreundschaft war, h[UNI00e4]tte ich\nnie gedacht ..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Crest ist nicht hier.\nWo mag Crest wohl sein ...?<page>Ohne Crest f[UNI00fc]hlen wir uns immer\nunsicher."
			)
		else
			event.MesMake_2(
				0,
				"Crest hat mir mal was erz[UNI00e4]hlt ...\nVor langer Zeit versuchte ein Mann\nnamens Gaspard diesen Mondkristall zu<page>vernichten. Und es war der Meister von\nCrest, der den Kristall mit seinem\nLeben besch[UNI00fc]tzt hat ..."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Crest ist mit dem\nMondkristall verschwunden, um ihn zu\nbesch[UNI00fc]tzen ...?<page>Das versteh ich nicht ..."
			)
		else
			event.MesMake_2(
				0,
				"Du hast die gro[UNI00df]e Macht des\nMondkristalls gesehen, nicht? Aber nur einer\nkann ihn benutzen ...<page>Crest  ...<page>Normale Leute wie wir k[UNI00f6]nnten\nso etwas nie tun."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"K[UNI00f6]nntet ihr es sein ...?\nCrest sagte mir, eines Tages k[UNI00e4]men\nein Junge und ein M[UNI00e4]dchen zu mir ...<page>Ich wusste doch, dass diese\nVerhei[UNI00df]ung wahr wird!<page>Aber leider ist Crest\nselbst auch verschwunden."
			)
		else
			event.MesMake_2(
				0,
				"Vor 10000 Jahren?<page>Du behauptest, das Mondlabor\nkann etwas schaffen, das selbst\nCrest nicht leisten konnte?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"Der Mond hat eine merkw[UNI00fc]rdige\nMacht, die alle Lebewesen\nbeeinflusst.<page>Und der Mondkristall\nverk[UNI00f6]rpert diese Macht."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Wenn du so gut essen\nwillst wie sonst nirgends,\nbesuche Lao Chaos Bistro!<page>Du hast schon davon geh[UNI00f6]rt, oder?"
			)
		else
			event.MesMake_2(
				0,
				"Ihr seid es also.\nCrest hat mir von euch erz[UNI00e4]hlt -\ndass ihr ihr vor langer Zeit das<page>Leben gerettet h[UNI00e4]ttet. Aber\nich h[UNI00e4]tte nie gedacht, dass ihr\nblo[UNI00df] Kinder seid ..."
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

return helper_08d48239
