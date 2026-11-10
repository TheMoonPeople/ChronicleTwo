--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_53ffa82b = require("@lib/event/helper_53ffa82b")

--- Helper function.
local function helper_37bc8151(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"Ich wohne jetzt hier,\naber ich mache mir mehr Sorgen\num Blackstone Eins.<page>Ich werde mich darum k[UNI00fc]mmern,\ndass der Zug f[UNI00e4]hrt - wie\nin den alten Zeiten."
				)
				var4 = event.get_triggered_event_data_2(13) or var4
				helper_1c04a0eb(var4, -1, 0, 0)
				event.open_message_window_2(
					arg0,
					"Borneo ist etwas ungeschickt,\nund Erik ist blo[UNI00df] ein Kind.<page>Nichts als Schlafen, Arbeiten,\nSchlafen und wieder Arbeiten\nf[UNI00fc]r Leute wie mich.<page>Aber so ist das Leben, was ...?"
				)
			else
				event.open_message_window_2(arg0, "Wie geht's Steve?")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "Ich schaff's nicht, blo[UNI00df]\nD[UNI00e4]umchen zu drehen.")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"Pflanzen und Blumen wachsen\nnur, wenn man sie pflegt. Ich\nk[UNI00f6]nnte meine Kleinen nie verlassen."
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"Ob der geheime St[UNI00fc]tzpunkt wohl in\nOrdnung ist? Ich kann niemand hin-\nschicken, er ist ja geheim, nicht?"
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"Lila ist eine tolle Farbe.\nEs hat so eine warme K[UNI00e4]lte,\nund eine helle Dunkelheit."
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "Wenn jemand krank ist, komme\nich [UNI00fc]berall hin, um zu helfen.")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "Nur ein Spitzenkoch kann\njederzeit und [UNI00fc]berall\ntolles Essen machen.")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "Bei H[UNI00e4]usern gilt: Je\nrobuster, desto besser, stimmt's?")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"N[UNI00fc]sse sind nicht schlecht, aber\ndiese roten Dinger waren super.\nK[UNI00f6]nntest du noch welche holen?"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"Feuchte Luft ist Gift f[UNI00fc]r\nB[UNI00fc]cher. Ich k[UNI00f6]nnte es nie\nertragen, am Wasser zu wohnen."
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(
				arg0,
				"Sie sind weder s[UNI00fc][UNI00df] noch\nmodern, aber meine Kleider\nkann sonst niemand machen."
			)
		end
		if arg1 == 12 then
			event.open_message_window_2(
				arg0,
				"Ein neues Haus, ein neues Ich.\nIch f[UNI00fc]hl mich wieder wie\nein junger B[UNI00e4]cker."
			)
		end
		if arg1 == 13 then
			event.open_message_window_2(
				arg0,
				"Mir ist egal, was es ist,\naber ich will irgendetwas in\neine Million Teile zerschlagen!"
			)
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "Wenn du ein neues Monster findest,\nberichte sofort davon.")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"Manche sagen, das ist nichts f[UNI00fc]r\nFrauen, aber dem Schwert ist das\negal. M[UNI00f6]ge der Bessere gewinnen."
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "In diesem H[UNI00e4]uschen k[UNI00f6]nnte man\ngut eine Familie gr[UNI00fc]nden.")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "Ob Morton wohl am Ball bleibt?\nIch mach mir Sorgen um ihn ...")
		end
		if arg1 == 18 then
			event.open_message_window_2(
				arg0,
				"Falls du eine Stadt wei[UNI00df]t, die\neine Kirche braucht, bin ich\ndein Priester. Sag nur Bescheid."
			)
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"Ich denke in letzter Zeit nicht\nmehr oft an den Mond. Das muss\nan meinen neuen Freunden liegen."
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(arg0, "Anderer Ort, andere Fische.\nMan muss sein Denken immer\nan den Ort anpassen.")
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "Hier muss ein toller\nFischgrund sein.")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"Parn hat ein neues Frauen-\nportr[UNI00e4]t angefangen. Er sagt,\nsie wird noch h[UNI00fc]bscher als ich."
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(arg0, "Warum sieht Ungeziefer\nblo[UNI00df] so widerlich aus?")
		end
		if arg1 == 24 then
			event.open_message_window_2(
				arg0,
				"Kannst du mein Haus noch\ns[UNI00fc][UNI00df]er machen? Ein Haus kann\nnie s[UNI00fc][UNI00df] genug sein!"
			)
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "H[UNI00e4]tte nie gedacht, dass ich in\ndem Alter umziehen w[UNI00fc]rde.")
		end
	else
		helper_53ffa82b(arg0, arg1)
	end
end

return helper_37bc8151
