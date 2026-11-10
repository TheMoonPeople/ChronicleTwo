--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_e2ebceb9()
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
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 300 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(456) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"Eh? Chi siete...?\nIl Laboratorio di Scienza Lunatica\n[UNI00e8] il miglior centro di ricerca<page>del mondo. Non [UNI00e8] ancora un\ngranch[UNI00e9], ma dovremmo riuscire\na terminare i nostri studi."
				)
			else
				event.open_message_window_2(
					0,
					"Le parole non possono descrivere\nla maestosit[UNI00e0] del Lab-Lunatica.\nDovete vederlo con i vostri occhi."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Se la questione Grifone non viene\nrisolta, la storia non torner[UNI00e0]\nmai com'era prima.<page>La sola esistenza di Grifone\naltera il corso della storia."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.get_save_flag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.get_save_flag(408) or flag_4
			if flag_4 == 0 then
				event.open_message_window_2(0, "Haahn, shooo, haahn, shooo.")
				var3 = 2
			else
				argc = event.is_invention_created(309) or argc
				if argc < 0 then
					event.open_message_window_2(
						0,
						"Ecco delle dritte per inventare un\nacquario: Una Scatola di Legno,\nuna Finestra e una Fontana. Puoi\ntrovarli in citt[UNI00e0], capito?"
					)
				else
					var9 = event.get_save_data_value(2) or var9
					if var9 == 0 then
						event.open_message_window_2(
							0,
							"Prima, dai un \"Verme elettrico\"\na un pesce dell'acquario\nper elettrificarlo.<page>Poi, dai il pesce allo Shigura.\nTutto chiaro, 'sta volta?"
						)
					else
						event.open_message_window_2(
							0,
							"Ooh, hai il pesce, vero?\nDallo da mangiare allo Shigura!\nNon dovrebbe essere difficile, no?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"Bene! Sembra ce l'abbiate fatta!\nA quanto pare, la mia invenzione\n[UNI00e8] stata proprio utile, eh?"
			)
		end
	end
	if var2 == 302 then
		event.open_message_window_2(0, "Che sia Osmond o il capo del\nlaboratorio, ce n'[UNI00e8] di matti qui!")
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
							"Badate alla Radioconchiglia.\n[UNI00c8] tra le invenzioni pi[UNI00f9]\nimportanti del Lab-Lunatica."
						)
					else
						event.open_message_window_2(
							0,
							"Presto, muovetevi! Le truppe\ndi Grifone stanno raggiungendo\nElena: non resisteranno a lungo..."
						)
					end
				else
					event.open_message_window_2(0, "Mi chiedo che uomo sia\nquesto Grifone...")
				end
			else
				event.open_message_window_2(
					0,
					"Cercate le gemme? Sono cristalli\ndi saggezza, forgiati dagli antichi.<page>Secondo l'analisi del computer del\nLab-Lunatica,si trovano nascoste\nin quattro luoghi:"
				)
				helper_31bbf01d(player_chara, var1, 0)
				helper_0ffc2526(0, -1, var1, player_chara, 0)
				var3 = 1
				event.open_message_window_2(
					0,
					"il Bosco Farfalla Arcobaleno, il\nCanyon Stellare, la Caverna \nRuggente e il Monte Gundor.<page>Un simbolo a forma di stella\ndovrebbe trovarsi ad ogni entrata,\nquindi fate attenzione."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Bene, [UNI00e8] ora di sistemare Grifone\nper sempre! Il destino del mondo [UNI00e8]\nnelle vostre mani. Buona fortuna!"
			)
		end
	end
	if var2 == 304 then
		event.open_message_window_2(
			0,
			"In questo laboratorio, anche un\nragazzino, con le giuste qualit[UNI00e0],\npu[UNI00f2] diventare un pezzo grosso."
		)
	end
	if var2 == 305 then
		event.open_message_window_2(
			0,
			"Le Pietre Luna, portate dagli\nShigura, ci liberano la mente per\nmeglio concentrarci sulla ricerca.<page>Ma non saprei dirti cosa siano\nesattamente queste Pietre Luna..."
		)
	end
	if var2 == 306 then
		event.open_message_window_2(
			0,
			"Un laboratorio sull'oceano, niente\nmale, eh? Sapete quanto ho dovuto\nfaticare per avere un posto qui?"
		)
	end
	if var2 == 307 then
		event.open_message_window_2(
			0,
			"Che ne pensate del progetto del\nLab-Lunatica? Chiss[UNI00e0] chi ha ideato\nil parco dei divertimenti..."
		)
	end
	if var2 == 308 then
		event.open_message_window_2(
			0,
			"Un giorno dimostrer[UNI00f2] a tutti\nquanto sono in gamba! Sapete,\nqui si tratta solo di abilit[UNI00e0]."
		)
	end
	if var2 == 309 then
		event.open_message_window_2(
			0,
			'Sapete, io rispetto molto il capo.\n[UNI00c8] da ammirare uno che scrive\nun best seller di 40 volumi,<page>"La Bibbia del Super\nScienziato,", a quell\'et[UNI00e0] poi!'
		)
	end
	if var2 == 310 then
		event.open_message_window_2(
			0,
			"Io sono ancora un pivellino qui.\nSto imparando molto e un giorno\ndiventer[UNI00f2] un grande ricercatore."
		)
	end
	if var2 == 311 then
		event.open_message_window_2(
			0,
			"La vista del mare da questo\nlaboratorio [UNI00e8] incredibile.<page>Laggi[UNI00f9] all'orizzonte,\nl'oscurit[UNI00e0] del mare e del cielo\nsi fondono in un tutt'uno."
		)
	end
	if var2 == 312 then
		event.open_message_window_2(
			0,
			"Questo [UNI00e8] il Laboratorio Numero 2.<page>Nel Lab-Lunatica, ogni\nsingolo laboratorio ha\nla sua area di ricerca."
		)
	end
	if var2 == 313 then
		event.open_message_window_2(
			0,
			"Al Lab-Lunatica, viene simulato\nun ambiente notturno che amplifica\nil potere delle Pietre Luna."
		)
	end
	if var2 == 314 then
		event.open_message_window_2(
			0,
			"Quando iniziai a lavorare qui, non\nriuscivo neanch'io a distinguere i\nlaboratori. Questo pu[UNI00f2] aiutarvi:<page>il laboratorio 1 [UNI00e8] rosso, il 2 [UNI00e8]\nblu, il 3 [UNI00e8] viola e il 4 [UNI00e8] verde.\nUn colore per ogni laboratorio!"
		)
	end
	if var2 == 315 then
		event.open_message_window_2(0, "L'emblema sul Laboratorio Centrale\nha la forma della luna.")
	end
	if var2 == 316 then
		event.open_message_window_2(
			0,
			"Ho saputo che il Laboratorio [UNI00e8]\nstato terminato grazie alle Pietre\nLuna portate dal drago Shingala.<page>A quanto pare, alcuni draghi\nmarini sanno essere in gamba, eh?"
		)
	end
	if var2 == 317 then
		event.open_message_window_2(
			0,
			"Non dirglielo, ma ne abbiamo fin<page>sopra i capelli delle cosiddette\nbattute di Osmond.\nSono cos[UNI00ec] irritanti!"
		)
	end
	if var2 == 318 then
		event.open_message_window_2(
			0,
			"Ebbene s[UNI00ec]: anch'io ho contribuito\nalla ricerca sul Verme elettrico.\nOra seguo un altro progetto.<page>Ehi, non posso rivelare quale!\nTop secret! Mica posso andare a\nspifferarlo ai quattro venti!"
		)
	end
	if var2 == 319 then
		event.open_message_window_2(
			0,
			"Cosa? Anche voi ragazzi volete\ndiventare dei ricercatori?<page>Non penserete mica che sia una\npasseggiata entrare qui?!\nLa competizione [UNI00e8] spietata."
		)
	end
	if var2 == 320 then
		event.open_message_window_2(
			0,
			"Alcuni ricercatori criticano i\nprogetti qui al Lab-Lunatica.\nIn effetti non sono un granch[UNI00e9]...<page>Ad ogni modo, [UNI00e8] solo\nuna piccola minoranza."
		)
	end
	if var2 == 321 then
		event.open_message_window_2(
			0,
			"Siamo nel mezzo di una riunione\nsu ricerche di massima segretezza.<page>Vi spiacerebbe lasciarci\nsoli un momento?"
		)
	end
	if var2 == 322 then
		event.open_message_window_2(
			0,
			"Mi spiace molto, ma siamo nel\nmezzo di una riunione su\nricerche di massima segretezza.<page>Non possiamo andare avanti\ncon voi qui, quindi..."
		)
	end
	if var2 == 323 then
		event.open_message_window_2(
			0,
			"Il Dottor Nobb [UNI00e8] un vero genio,\ncerto, ma [UNI00e8] anche un\ngran lavoratore.<page>Io impallidisco a confronto...\nUn vero albino direi..."
		)
	end
	if var2 == 324 then
		event.open_message_window_2(
			0,
			"Sei tu? Ho sentito dire che hai\nlitigato con il Dottor Osmond.<page>Ehi! Non sto criticando, anzi! Le\nscoperte avvengono quando si mette\nin discussione qualcosa."
		)
	end
	if var2 == 325 then
		event.open_message_window_2(
			0,
			"Dite di non riuscire ad abituarvi\nalla luce intensa?<page>Ritengo che per voi\nvisitatori dal passato\nci voglia del tempo per adattarsi."
		)
	end
	if var2 == 326 then
		event.open_message_window_2(
			0,
			"Beh, sto riprendendo\nfiato un attimo.<page>Bisogna far riposare il cervello\ndi quando in quando, altrimenti\nsi d[UNI00e0] fuori di matto!"
		)
	end
	if var2 == 327 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"So che sei bravino come inventore.\nChe ne dici? Ti andrebbe di venire\na lavorare con noi da grande?<page>Per allora, il Lab-Lunatica sar[UNI00e0]\nstato appena terminato. La tua\ncollaborazione sar[UNI00e0] apprezzata."
			)
		else
			event.open_message_window_2(
				0,
				"Non credi che gli inventori\nsiano veramente affascinanti?<page>Beh, vedi di non innamorarti di\nme, intesi? La ricerca [UNI00e8] la mia\nvita. Non funzionerebbe mai."
			)
		end
	end
	if var2 == 328 then
		event.open_message_window_2(
			0,
			"Ho avuto un'idea rivoluzionaria:\nun sistema che permette ai mostri\ndi vivere al fianco degli Umani.<page>Realizzer[UNI00f2] una macchina che\ncomprende il linguaggio umano."
		)
	end
	if var2 == 329 then
		event.open_message_window_2(
			0,
			"Le Pietre Luna sono la spina\ndorsale del Lab-Lunatica.<page>Senza, tutto il nostro\nsistema si paralizzerebbe."
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

return helper_e2ebceb9
