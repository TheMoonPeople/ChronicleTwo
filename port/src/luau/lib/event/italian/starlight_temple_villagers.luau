--!strict
--- Holds the Italian conversations of the villagers of Starlight Temple.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local starlight_temple_villagers = {}

--- Plays the conversation of the Starlight Temple villager that was talked to, choosing the line by villager type and story flags.
function starlight_temple_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local miracle_dish_flag: s32 = 0
	local dumpling_helped_flag: s32 = 0
	local crest_returned_flag: s32 = 0
	local rescued_flag: s32 = 0
	local final_battle_flag: s32 = 0
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
	miracle_dish_flag = event.get_save_flag(324) or miracle_dish_flag
	dumpling_helped_flag = event.get_save_flag(330) or dumpling_helped_flag
	crest_returned_flag = event.get_save_flag(372) or crest_returned_flag
	rescued_flag = event.get_save_flag(400) or rescued_flag
	final_battle_flag = event.get_save_flag(640) or final_battle_flag
	if villager_type == 200 then
		if final_battle_flag == 0 then
			if dumpling_helped_flag == 0 then
				if miracle_dish_flag == 0 then
					event.open_message_window_2(
						0,
						"Per il piatto miracoloso mi serve\nun Fiore Biancovento. Ma non ne ho\npi[UNI00f9]. Ops... non posso aiutarvi!"
					)
				else
					event.open_message_window_2(
						0,
						"Avete gi[UNI00e0] provato gli Gnocchi\nmiracolosi? Se si freddano perdono\nd'efficacia: vanno mangiati subito!"
					)
				end
			else
				event.open_message_window_2(
					0,
					"Gli Gnocchi miracolosi sono stati\nutili, eh? Mi fa piacere. Ehi,\nMangiate qualcosa prima di andare?"
				)
			end
		else
			event.open_message_window_2(0, "Oh cielo, [UNI00e8] quasi ora, eh?\nVediamo che succede.")
		end
	end
	if villager_type == 201 then
		event.open_message_window_2(
			0,
			"I vari oggetti hanno effetti\ndiversi. Alcuni sono utili. Altri\npermettono di creare delle armi...<page>Sperimentando, sarai in grado di\nsconfiggere anche il peggiore\ndei nemici. Prova di tutto!"
		)
	end
	if villager_type == 202 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Non posso credere che questo\ntempio sia stato distrutto\ndal diabolico Imperatore Grifone.<page>Se solo il Grande Saggio Crest\nfosse qui..."
			)
		else
			event.open_message_window_2(
				0,
				"Con il Grande Crest di nuovo tra\nnoi, non avremo niente da temere.\nOra andate ad affrontare Grifone."
			)
		end
	end
	if villager_type == 203 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Questo tempio [UNI00e8] immerso in una\nnotte perpetua: il Cristallunare\n[UNI00e8] pi[UNI00f9] potente di notte.<page>Sfrutta la forza del tempio\nper creare un'area di oscurit[UNI00e0]."
			)
		else
			event.open_message_window_2(
				0,
				"Che Crest il Grande possa usare il\npotere del Cristallunare per\nvedere ogni cosa a questo mondo!<page>Nulla sfugge alla vista\nonnipotente di Crest!"
			)
		end
	end
	if villager_type == 204 then
		event.open_message_window_2(
			0,
			"Salve! Abbiamo un vasto\nassortimento. Le nostre armi sono\nnote per essere forti e resistenti."
		)
	end
	if villager_type == 205 then
		if final_battle_flag == 0 then
			if rescued_flag == 0 then
				event.open_message_window_2(
					0,
					"Ehi! Basta perder tempo! [UNI00c8] ora di\nmostrare a quel Grifone chi [UNI00e8] il\npi[UNI00f9] forte! Presto!"
				)
			else
				event.open_message_window_2(
					0,
					"Bene, questo [UNI00e8] tutto per quanto mi\nriguarda. Il resto dipende da voi.\nSu, andate ad occuparvi di Grifone!<page>Mi avete salvato la vita:\nso che potete farcela, ragazzi!"
				)
			end
		else
			event.open_message_window_2(
				0,
				"Pare che il vostro viaggio sia\nquasi terminato. Battete Grifone,\nper il Maestro e per tutti noi.<page>Dovete assolutamente sconfiggerlo.\nSolo allora, io e Crest\ndiventeremo davvero Grandi Saggi!"
			)
		end
	end
	if villager_type == 206 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Anche se tornasse come'era prima,\nil Tempio stellare, senza Crest,\n[UNI00e8] inservibile.<page>Solo Crest detiene l'immenso\npotere astrologico di esaminare\nil mondo intero."
			)
		else
			event.open_message_window_2(
				0,
				"Persino il Grande Crest, un tempo,\nera l'apprendista di un saggio.\nChiss[UNI00e0] che grande maestro era!"
			)
		end
	end
	if villager_type == 207 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Il cibo qui [UNI00e8] di prima qualit[UNI00e0].\nMi viene l'acquolina in bocca\nsolo a pensarci..."
			)
		else
			event.open_message_window_2(0, "Ha preparato il piatto miracoloso!\nLao Chao [UNI00e8] proprio un grande chef!")
		end
	end
	if villager_type == 208 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Una volta mangiato qui,\nniente sar[UNI00e0] pi[UNI00f9] cos[UNI00ec]\ngustoso. [UNI00c8] talmente buono!"
			)
		else
			event.open_message_window_2(0, "Wow! Certo che piacerebbe\nanche a me assaggiare un\npo' di Gnocchi miracolosi!")
		end
	end
	if villager_type == 209 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Pensi che la Clessidra stellare\nsia bizzarra?<page>A chi lo dici! Ne ho una anch'io,\nma non mi sembra un granch[UNI00e9]...\nNon riporta indietro il tempo."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00c8] stupendo che voi ragazzi siate\namici del Grande Saggio Crest.<page>Ma non immaginavo\nfoste cos[UNI00ec] intimi..."
			)
		end
	end
	if villager_type == 210 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Il Grande Saggio Crest non [UNI00e8] qui.\nMi chiedo dove sia andato...<page>Ci sentiamo a disagio\nquando non c'[UNI00e8]."
			)
		else
			event.open_message_window_2(
				0,
				"Il Grande Crest mi disse che in\npassato un certo Gaspard volle\ndistruggere il Cristallunare.<page>E fu il maestro del Sommo Crest a\nrischiare la vita per difenderlo..."
			)
		end
	end
	if villager_type == 211 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Il Grande Crest [UNI00e8] scomparso\ncon il Cristallunare,\nper proteggerlo...?<page>Non capisco..."
			)
		else
			event.open_message_window_2(
				0,
				"Avete visto l'incredibile potere\ndel Cristallunare, giusto? Ma\n solo LUI [UNI00e8] in grado di usarlo...<page>il Grande Saggio Crest...<page>Noi comuni mortali non\npotremmo mai riuscirci."
			)
		end
	end
	if villager_type == 212 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Che siate voi...? Il Grande Crest\nmi disse che un giorno un ragazzo\ne una ragazza sarebbero venuti...<page>Sapevo che questa profezia\nsi sarebbe avverata!<page>Sfortunatamente anche il Grande\nSaggio [UNI00e8] scomparso."
			)
		else
			event.open_message_window_2(
				0,
				"10.000 anni fa?<page>Volete dire che il Lab-Lunatica\npu[UNI00f2] portare a termine un'impresa\nimpossibile anche al Grande Crest?"
			)
		end
	end
	if villager_type == 213 then
		event.open_message_window_2(
			0,
			"La luna detiene uno strano potere,\nche influisce su ogni\nspecie di essere vivente.<page>E il Cristallunare\nincarna questo potere."
		)
	end
	if villager_type == 214 then
		if dumpling_helped_flag == 0 then
			event.open_message_window_2(
				0,
				"Se cerchi il cibo pi[UNI00f9] buono\ndel mondo, dovresti andare\nal Bistrot di Lao Chao!<page>Ne hai gi[UNI00e0] sentito parlare, vero?"
			)
		else
			event.open_message_window_2(
				0,
				"Cos[UNI00ec] sareste voi. Il Grande Crest\nmi ha parlato di voi e di come\nle salvaste la vita.<page>Ma non avrei mai immaginato\nche foste solo dei ragazzi..."
			)
		end
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
	if villager_type == 201 then
		menu.open_type_6_alt(5)
	end
	if villager_type == 204 then
		menu.open_type_6_alt(27)
	end
end

return starlight_temple_villagers
