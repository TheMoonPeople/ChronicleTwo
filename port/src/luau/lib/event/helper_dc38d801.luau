--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_dc38d801()
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
	if var2 == 400 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.get_save_flag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.get_save_flag(536) or flag_4
					if flag_4 == 0 then
						event.open_message_window_2(
							0,
							"Gaspard [UNI00e8] un rivale formidabile.\nNon abbassate la guardia,\nneppure per un istante!<page>So che potete sconfiggerlo.\nCi sar[UNI00e0] una ragione se le\nAtlamillia hanno scelto voi..."
						)
					else
						event.open_message_window_2(
							0,
							"S[UNI00ec], anche Gaspard era infelice.<page>Perch[UNI00e9] mai Grifone vuole rovinare\nla vita alla gente di due ere?"
						)
					end
				else
					event.open_message_window_2(
						0,
						"Se qualcuno pu[UNI00f2] battere Grifone,\nquelli siete proprio voi.<page>Contiamo su di voi."
					)
				end
			else
				event.open_message_window_2(
					0,
					"I Raccordi temporali... Cos[UNI00ec], il\nmondo verr[UNI00e0] salvato grazie alla\nsaggezza degli antichi..."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Cos[UNI00ec], ci siamo, eh? Il sangue di\nmolti amici [UNI00e8] stato versato\ncombattendo Grifone...<page>Siete la nostra ultima speranza!\nMax, Monica, conto su voi due.\nDovete sconfiggere Grifone!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.get_save_flag(520) or flag_9
						if flag_9 == 0 then
							event.open_message_window_2(
								0,
								"Bene, per prima cosa dovrete \ndistruggere la Sputa Fuoco.<page>Se non facciamo qualcosa per\nquesta pioggia di fuoco,\nDesolandia [UNI00e8] spacciata."
							)
						else
							event.open_message_window_2(
								0,
								"OK, ecco cos'[UNI00e8] successo!\nDobbiamo essere contenti che\nla Sputa Fuoco sia fuori gioco."
							)
							helper_31bbf01d(player_chara, var1, 0)
							helper_0ffc2526(0, -1, var1, player_chara, 0)
							var3 = 1
							event.open_message_window_2(
								0,
								"Ma sono preoccupato per la tua\namica precipitata nel cratere.<page>L'unica cosa che possiamo fare\nora [UNI00e8] ricostruire Desolandia e\nl'Officina meglio di prima."
							)
						end
					else
						event.open_message_window_2(
							0,
							"Avete sconfitto Gaspard! Ragazzi,\nsiete semplicemente incredibili!<page>Ora tocca al capo, l'Imperatore\nGrifone. Sistematelo per sempre!"
						)
					end
				else
					event.open_message_window_2(
						0,
						"Che gioia vedere il Paznos in\nazione! [UNI00c8] stato commovente.<page>Finalmente il nostro duro lavoro\nha dato i suoi frutti."
					)
				end
			else
				event.open_message_window_2(0, "Gemma? Mmh, mi spiace, non ho\nproprio idea di cosa sia.")
			end
		else
			event.open_message_window_2(0, "[UNI00c8] ora di affrontare Grifone, eh?\nBuona fortuna. Acciuffatelo!")
		end
	end
	if var2 == 402 then
		event.open_message_window_2(0, "Ehil[UNI00e0]! Abbiamo tutta roba buona!\nAllora, cosa posso offrirvi?")
	end
	if var2 == 403 then
		event.open_message_window_2(0, "Qualsiasi cosa serva, sono l'uomo\ngiusto. Ho tutto!")
	end
	if var2 == 404 then
		event.open_message_window_2(
			0,
			"Il combattimento pu[UNI00f2] farsi duro.\nNon puoi affrontare ogni<page>situazione ad armi spianate.<page>Fatti furbo, usa anche gli\noggetti. Scopri le debolezze dei\nnemici e sfruttale a tuo favore!"
		)
	end
	if var2 == 405 then
		event.open_message_window_2(
			0,
			"Si pu[UNI00f2] fare tutto nell'Officina\nGundorandia. Non importa se grande\no piccolo, noi lo faremo!"
		)
	end
	if var2 == 406 then
		event.open_message_window_2(
			0,
			"Ehi ragazzi, come siete entrati?\nState attenti! Pu[UNI00f2] diventare\npericoloso qui dentro."
		)
	end
	if var2 == 407 then
		event.open_message_window_2(0, "Cos'[UNI00e8] successo in tutto questo\ntempo? Non riesco proprio\na ricordare...")
	end
	if var2 == 408 then
		event.open_message_window_2(0, "Grifone ci ha eliminati dalla\nstoria, eh? Che mostro terribile!")
	end
	if var2 == 409 then
		event.open_message_window_2(0, "Ho da fare ora.\nVolete togliervi di torno?")
	end
	if var2 == 410 then
		event.open_message_window_2(0, "Facciamo tutti il tifo per voi.\nVi appoggiamo al 100%.")
	end
	if var2 == 411 then
		event.open_message_window_2(
			0,
			"Sembra che le armi\nqui dentro non\nsiano in vendita.<page>Certo ci sono delle armi\nveramente strane e\nmeravigliose al mondo..."
		)
	end
	if var2 == 412 then
		event.open_message_window_2(
			0,
			"Allora quel tipo, Gaspard, pu[UNI00f2]\ncontrollare la Sputa Fuoco?<page>Non [UNI00e8] solo furbo...\n[UNI00c8] proprio malvagio!"
		)
	end
	if var2 == 413 then
		event.open_message_window_2(
			0,
			"Cos'[UNI00e8] quel cuore\nsull'insegna?<page>[UNI00c8] abbastanza disgustoso,\nse mi permetti..."
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
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.get_look_angle(var17 - var14, var19 - var16) or var20
		helper_76f23193(player_chara_2, var20)
		event.set_character_rotation(player_chara_2, 0.0, var20, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
	if var2 == 402 then
		helper_59a16271(30)
	end
	if var2 == 403 then
		helper_59a16271(28)
	end
	if var2 == 404 then
		helper_59a16271(29)
	end
end

return helper_dc38d801
