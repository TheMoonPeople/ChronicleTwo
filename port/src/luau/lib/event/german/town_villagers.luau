--!strict
--- Holds the German conversations of the villagers living in the player's town.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local partner_talk = vm.module("@lib/event/german/partner_talk")

local town_villagers = {}

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
function town_villagers.say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	local villager_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"Ich wohne jetzt hier,\naber ich mache mir mehr Sorgen\num Blackstone Eins.<page>Ich werde mich darum k[UNI00fc]mmern,\ndass der Zug f[UNI00e4]hrt - wie\nin den alten Zeiten."
				)
				villager_id = event.get_triggered_event_data_2(13) or villager_id
				cutscene.talk(villager_id, -1, 0, 0)
				event.open_message_window_2(
					window,
					"Borneo ist etwas ungeschickt,\nund Erik ist blo[UNI00df] ein Kind.<page>Nichts als Schlafen, Arbeiten,\nSchlafen und wieder Arbeiten\nf[UNI00fc]r Leute wie mich.<page>Aber so ist das Leben, was ...?"
				)
			else
				event.open_message_window_2(window, "Wie geht's Steve?")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "Ich schaff's nicht, blo[UNI00df]\nD[UNI00e4]umchen zu drehen.")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"Pflanzen und Blumen wachsen\nnur, wenn man sie pflegt. Ich\nk[UNI00f6]nnte meine Kleinen nie verlassen."
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"Ob der geheime St[UNI00fc]tzpunkt wohl in\nOrdnung ist? Ich kann niemand hin-\nschicken, er ist ja geheim, nicht?"
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"Lila ist eine tolle Farbe.\nEs hat so eine warme K[UNI00e4]lte,\nund eine helle Dunkelheit."
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "Wenn jemand krank ist, komme\nich [UNI00fc]berall hin, um zu helfen.")
		end
		if villager_type == 7 then
			event.open_message_window_2(window, "Nur ein Spitzenkoch kann\njederzeit und [UNI00fc]berall\ntolles Essen machen.")
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "Bei H[UNI00e4]usern gilt: Je\nrobuster, desto besser, stimmt's?")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"N[UNI00fc]sse sind nicht schlecht, aber\ndiese roten Dinger waren super.\nK[UNI00f6]nntest du noch welche holen?"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"Feuchte Luft ist Gift f[UNI00fc]r\nB[UNI00fc]cher. Ich k[UNI00f6]nnte es nie\nertragen, am Wasser zu wohnen."
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(
				window,
				"Sie sind weder s[UNI00fc][UNI00df] noch\nmodern, aber meine Kleider\nkann sonst niemand machen."
			)
		end
		if villager_type == 12 then
			event.open_message_window_2(
				window,
				"Ein neues Haus, ein neues Ich.\nIch f[UNI00fc]hl mich wieder wie\nein junger B[UNI00e4]cker."
			)
		end
		if villager_type == 13 then
			event.open_message_window_2(
				window,
				"Mir ist egal, was es ist,\naber ich will irgendetwas in\neine Million Teile zerschlagen!"
			)
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "Wenn du ein neues Monster findest,\nberichte sofort davon.")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"Manche sagen, das ist nichts f[UNI00fc]r\nFrauen, aber dem Schwert ist das\negal. M[UNI00f6]ge der Bessere gewinnen."
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "In diesem H[UNI00e4]uschen k[UNI00f6]nnte man\ngut eine Familie gr[UNI00fc]nden.")
		end
		if villager_type == 17 then
			event.open_message_window_2(window, "Ob Morton wohl am Ball bleibt?\nIch mach mir Sorgen um ihn ...")
		end
		if villager_type == 18 then
			event.open_message_window_2(
				window,
				"Falls du eine Stadt wei[UNI00df]t, die\neine Kirche braucht, bin ich\ndein Priester. Sag nur Bescheid."
			)
		end
		if villager_type == 19 then
			event.open_message_window_2(
				window,
				"Ich denke in letzter Zeit nicht\nmehr oft an den Mond. Das muss\nan meinen neuen Freunden liegen."
			)
		end
		if villager_type == 20 then
			event.open_message_window_2(window, "Anderer Ort, andere Fische.\nMan muss sein Denken immer\nan den Ort anpassen.")
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "Hier muss ein toller\nFischgrund sein.")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"Parn hat ein neues Frauen-\nportr[UNI00e4]t angefangen. Er sagt,\nsie wird noch h[UNI00fc]bscher als ich."
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(window, "Warum sieht Ungeziefer\nblo[UNI00df] so widerlich aus?")
		end
		if villager_type == 24 then
			event.open_message_window_2(
				window,
				"Kannst du mein Haus noch\ns[UNI00fc][UNI00df]er machen? Ein Haus kann\nnie s[UNI00fc][UNI00df] genug sein!"
			)
		end
		if villager_type == 25 then
			event.open_message_window_2(window, "H[UNI00e4]tte nie gedacht, dass ich in\ndem Alter umziehen w[UNI00fc]rde.")
		end
	else
		partner_talk.show_npc_remark(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
function town_villagers.talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	town_villagers.say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

return town_villagers
