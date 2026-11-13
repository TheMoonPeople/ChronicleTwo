--!strict
--- Holds the German conversations of the villagers of Starlight Temple.

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
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
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
						"F[UNI00fc]r das Wunderrezept ben[UNI00f6]tige\nich eine Wei[UNI00df]e Windblume. Aber ich\nhabe keine. Tut mir Leid."
					)
				else
					event.open_message_window_2(
						0,
						"Hast du schon die Wunderkl[UNI00f6][UNI00df]e\nprobiert? Wenn sie kalt werden, l[UNI00e4]sst\nihre Wirkung nach - iss schnell!"
					)
				end
			else
				event.open_message_window_2(
					0,
					"Der Wunderklo[UNI00df] hat geholfen, was?\nFreut mich. He, willst du noch\nwas essen, bevor du gehst?"
				)
			end
		else
			event.open_message_window_2(0, "Liebe G[UNI00fc]te, es ist Zeit, was?\nDann mal ran - an nichts, wie?")
		end
	end
	if villager_type == 201 then
		event.open_message_window_2(
			0,
			"Verschiedene Gegenst[UNI00e4]nde haben\nunterschiedliche Wirkungen. Manche helfen,\nandere werden zu Waffen ...<page>Wenn du etwas experimentierst, kannst\ndu selbst die st[UNI00e4]rksten Gegner\nbesiegen. Probiere alles aus."
		)
	end
	if villager_type == 202 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Ich kann nicht fassen, dass der\nteuflische Kaiser Griffon diesen\nTempel vernichtet hat ...<page>W[UNI00e4]re doch nur\nCrest hier ..."
			)
		else
			event.open_message_window_2(
				0,
				"Da Crest wieder bei uns\nist, haben wir nichts zu f[UNI00fc]rchten.\nGeh nun und stelle Griffon."
			)
		end
	end
	if villager_type == 203 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Dieser Tempel liegt in ewiger\nNacht, denn die Kraft des Mondkristalls\nist nachts am gr[UNI00f6][UNI00df]ten.<page>Er nutzt die Kraft des Tempels,\num das Gebiet in Nacht\nzu h[UNI00fc]llen."
			)
		else
			event.open_message_window_2(
				0,
				"M[UNI00f6]ge Crest die Macht\ndes Mondkristalls nutzen,um alles auf\ndieser Welt zu sehen.<page>Niemand entkommt den allsehenden\nAugen von Crest. "
			)
		end
	end
	if villager_type == 204 then
		event.open_message_window_2(
			0,
			"Tag. Wir haben eine tolle\nAuswahl f[UNI00fc]r dich. Unsere Waffen\nsind bekannt f[UNI00fc]r ihre Robustheit."
		)
	end
	if villager_type == 205 then
		if final_battle_flag == 0 then
			if rescued_flag == 0 then
				event.open_message_window_2(
					0,
					"He! H[UNI00f6]r auf, herumzutr[UNI00f6]deln und zeig\ndiesem Griffon, wer hier der\nBoss ist! Beeil dich!"
				)
			else
				event.open_message_window_2(
					0,
					"Tja, hier ist Schluss f[UNI00fc]r mich!\nAb jetzt liegt's an euch.\nK[UNI00fc]mmert euch um Griffon, ja?<page>Ihr habt mir das Leben gerettet.\nWenn irgendjemand diese Aufgabe\nbew[UNI00e4]ltigen kann, dann ihr."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Deine Reise scheint fast am Ende\nzu sein. Erledige diesen Griffon,\nf[UNI00fc]r Master und uns alle.<page>Du musst ihn unbedingt schlagen.\nWenn Griffon f[UNI00e4]llt ... k[UNI00f6]nnen Crest\nund ich ... echte Weise werden."
			)
		end
	end
	if villager_type == 206 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Auch wenn er wieder normal ist, ist der\nSternenlicht-Tempel ohne Crest nutzlos.<page>Niemand au[UNI00df]er Crest hat die\ngewaltige astrologische Macht, die\nganze Welt zu [UNI00fc]berblicken."
			)
		else
			event.open_message_window_2(
				0,
				"Selbst Crest war einst\nLehrling eines Weisen. Er muss\nein guter Lehrer gewesen sein ..."
			)
		end
	end
	if villager_type == 207 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Das Essen hier ist erstklassig.\nMir l[UNI00e4]uft schon beim Gedanken daran\ndas Wasser im Mund zusammen ..."
			)
		else
			event.open_message_window_2(
				0,
				"Er hat nach seinem Wunderrezept\ngekocht! Lao Chao ist ein\nwahrhaft gro[UNI00df]er Koch!"
			)
		end
	end
	if villager_type == 208 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Wenn du hier gegessen hast, wirst\ndu nie mehr etwas Vergleichbares\nessen. Es ist so toll!"
			)
		else
			event.open_message_window_2(
				0,
				"Wow! Diese Wunderkl[UNI00f6][UNI00df]e w[UNI00fc]rde\nich ja zu gern auch mal\nprobieren!"
			)
		end
	end
	if villager_type == 209 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Du findest das Sternglas\nunheimlich?<page>Sag blo[UNI00df]! Ich hab auch eins,\naber ich halte nicht viel davon ...\nEs hat mit Sicherheit nie<page>die Zeit zur[UNI00fc]ckgedreht."
			)
		else
			event.open_message_window_2(
				0,
				"Es ist toll, dass ihr mit Crest\nbefreundet wart.<page>Aber dass es eine so enge\nFreundschaft war, h[UNI00e4]tte ich\nnie gedacht ..."
			)
		end
	end
	if villager_type == 210 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Crest ist nicht hier.\nWo mag Crest wohl sein ...?<page>Ohne Crest f[UNI00fc]hlen wir uns immer\nunsicher."
			)
		else
			event.open_message_window_2(
				0,
				"Crest hat mir mal was erz[UNI00e4]hlt ...\nVor langer Zeit versuchte ein Mann\nnamens Gaspard diesen Mondkristall zu<page>vernichten. Und es war der Meister von\nCrest, der den Kristall mit seinem\nLeben besch[UNI00fc]tzt hat ..."
			)
		end
	end
	if villager_type == 211 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Crest ist mit dem\nMondkristall verschwunden, um ihn zu\nbesch[UNI00fc]tzen ...?<page>Das versteh ich nicht ..."
			)
		else
			event.open_message_window_2(
				0,
				"Du hast die gro[UNI00df]e Macht des\nMondkristalls gesehen, nicht? Aber nur einer\nkann ihn benutzen ...<page>Crest  ...<page>Normale Leute wie wir k[UNI00f6]nnten\nso etwas nie tun."
			)
		end
	end
	if villager_type == 212 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"K[UNI00f6]nntet ihr es sein ...?\nCrest sagte mir, eines Tages k[UNI00e4]men\nein Junge und ein M[UNI00e4]dchen zu mir ...<page>Ich wusste doch, dass diese\nVerhei[UNI00df]ung wahr wird!<page>Aber leider ist Crest\nselbst auch verschwunden."
			)
		else
			event.open_message_window_2(
				0,
				"Vor 10000 Jahren?<page>Du behauptest, das Mondlabor\nkann etwas schaffen, das selbst\nCrest nicht leisten konnte?"
			)
		end
	end
	if villager_type == 213 then
		event.open_message_window_2(
			0,
			"Der Mond hat eine merkw[UNI00fc]rdige\nMacht, die alle Lebewesen\nbeeinflusst.<page>Und der Mondkristall\nverk[UNI00f6]rpert diese Macht."
		)
	end
	if villager_type == 214 then
		if dumpling_helped_flag == 0 then
			event.open_message_window_2(
				0,
				"Wenn du so gut essen\nwillst wie sonst nirgends,\nbesuche Lao Chaos Bistro!<page>Du hast schon davon geh[UNI00f6]rt, oder?"
			)
		else
			event.open_message_window_2(
				0,
				"Ihr seid es also.\nCrest hat mir von euch erz[UNI00e4]hlt -\ndass ihr ihr vor langer Zeit das<page>Leben gerettet h[UNI00e4]ttet. Aber\nich h[UNI00e4]tte nie gedacht, dass ihr\nblo[UNI00df] Kinder seid ..."
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
