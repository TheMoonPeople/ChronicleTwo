--!strict
--- Holds the Italian conversations of the villagers of Gundorada Workshop.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local workshop_villagers = {}

--- Plays the conversation of the Gundorada Workshop villager that was talked to, choosing the line by villager type and story flags.
function workshop_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local paznos_flag: s32 = 0
	local gaspard_defeated_flag: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_recheck_flag: s32 = 0
	local paznos_recheck_flag: s32 = 0
	local gaspard_defeated_recheck_flag: s32 = 0
	local fire_squall_defeated_flag: s32 = 0
	local current_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle_degrees: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	closing_mode = 0
	if villager_type == 400 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				paznos_flag = event.get_save_flag(540) or paznos_flag
				if paznos_flag == 0 then
					gaspard_defeated_flag = event.get_save_flag(536) or gaspard_defeated_flag
					if gaspard_defeated_flag == 0 then
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
	if villager_type == 401 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_recheck_flag = event.get_save_flag(616) or gem_hint_recheck_flag
			if gem_hint_recheck_flag == 0 then
				paznos_recheck_flag = event.get_save_flag(540) or paznos_recheck_flag
				if paznos_recheck_flag == 0 then
					gaspard_defeated_recheck_flag = event.get_save_flag(536) or gaspard_defeated_recheck_flag
					if gaspard_defeated_recheck_flag == 0 then
						fire_squall_defeated_flag = event.get_save_flag(520) or fire_squall_defeated_flag
						if fire_squall_defeated_flag == 0 then
							event.open_message_window_2(
								0,
								"Bene, per prima cosa dovrete \ndistruggere la Sputa Fuoco.<page>Se non facciamo qualcosa per\nquesta pioggia di fuoco,\nDesolandia [UNI00e8] spacciata."
							)
						else
							event.open_message_window_2(
								0,
								"OK, ecco cos'[UNI00e8] successo!\nDobbiamo essere contenti che\nla Sputa Fuoco sia fuori gioco."
							)
							cutscene.face_each_other(player_slot, villager_id, 0)
							message.say_bubble(0, -1, villager_id, player_slot, 0)
							closing_mode = 1
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
	if villager_type == 402 then
		event.open_message_window_2(0, "Ehil[UNI00e0]! Abbiamo tutta roba buona!\nAllora, cosa posso offrirvi?")
	end
	if villager_type == 403 then
		event.open_message_window_2(0, "Qualsiasi cosa serva, sono l'uomo\ngiusto. Ho tutto!")
	end
	if villager_type == 404 then
		event.open_message_window_2(
			0,
			"Il combattimento pu[UNI00f2] farsi duro.\nNon puoi affrontare ogni<page>situazione ad armi spianate.<page>Fatti furbo, usa anche gli\noggetti. Scopri le debolezze dei\nnemici e sfruttale a tuo favore!"
		)
	end
	if villager_type == 405 then
		event.open_message_window_2(
			0,
			"Si pu[UNI00f2] fare tutto nell'Officina\nGundorandia. Non importa se grande\no piccolo, noi lo faremo!"
		)
	end
	if villager_type == 406 then
		event.open_message_window_2(
			0,
			"Ehi ragazzi, come siete entrati?\nState attenti! Pu[UNI00f2] diventare\npericoloso qui dentro."
		)
	end
	if villager_type == 407 then
		event.open_message_window_2(0, "Cos'[UNI00e8] successo in tutto questo\ntempo? Non riesco proprio\na ricordare...")
	end
	if villager_type == 408 then
		event.open_message_window_2(0, "Grifone ci ha eliminati dalla\nstoria, eh? Che mostro terribile!")
	end
	if villager_type == 409 then
		event.open_message_window_2(0, "Ho da fare ora.\nVolete togliervi di torno?")
	end
	if villager_type == 410 then
		event.open_message_window_2(0, "Facciamo tutti il tifo per voi.\nVi appoggiamo al 100%.")
	end
	if villager_type == 411 then
		event.open_message_window_2(
			0,
			"Sembra che le armi\nqui dentro non\nsiano in vendita.<page>Certo ci sono delle armi\nveramente strane e\nmeravigliose al mondo..."
		)
	end
	if villager_type == 412 then
		event.open_message_window_2(
			0,
			"Allora quel tipo, Gaspard, pu[UNI00f2]\ncontrollare la Sputa Fuoco?<page>Non [UNI00e8] solo furbo...\n[UNI00c8] proprio malvagio!"
		)
	end
	if villager_type == 413 then
		event.open_message_window_2(
			0,
			"Cos'[UNI00e8] quel cuore\nsull'insegna?<page>[UNI00c8] abbastanza disgustoso,\nse mi permetti..."
		)
	end
	if closing_mode == 0 then
		cutscene.talk(villager_id, -1, 0, 0)
	end
	if closing_mode == 1 then
		message.say_bubble(0, -1, villager_id, player_slot, 0)
		event.set_character_motion(villager_id, "立ち")
		event.finish_event()
	end
	if closing_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		current_player_slot = event.get_player_character_slot() or current_player_slot
		do
			local out1, _, out3 = event.get_character_position(current_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_id)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle_degrees = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle_degrees
		character.turn_to_angle(current_player_slot, look_angle_degrees)
		event.set_character_rotation(current_player_slot, 0.0, look_angle_degrees, 0.0)
		event.set_character_motion(current_player_slot, "立ち")
		message.say_bubble(0, -1, villager_id, current_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_id)
	if villager_type == 402 then
		menu.open_type_6_alt(30)
	end
	if villager_type == 403 then
		menu.open_type_6_alt(28)
	end
	if villager_type == 404 then
		menu.open_type_6_alt(29)
	end
end

return workshop_villagers
