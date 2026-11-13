--!strict
--- Holds the German conversations of the villagers of Gundorada Workshop.

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
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
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
							"Gaspard ist ein m[UNI00e4]chtiger Gegner.\nDu musst immer wachsam\nbleiben, jeden Moment.<page>Du kannst ihn besiegen.\nDer Atlamillia hat dich\nnicht ohne Grund erw[UNI00e4]hlt ..."
						)
					else
						event.open_message_window_2(
							0,
							"Tja, Gaspard war auch unzufrieden.<page>Was will Griffon nur -\nda legt er sich mit Leuten\naus zwei Zeitaltern an ..."
						)
					end
				else
					event.open_message_window_2(
						0,
						"Wenn jemand Griffon besiegen\nkann, dann seid ihr das.<page>Wir z[UNI00e4]hlen auf euch."
					)
				end
			else
				event.open_message_window_2(
					0,
					"Die Chrono-Verbindung ...\nDie Welt wird also durch das\nWissen der Alten gerettet ..."
				)
			end
		else
			event.open_message_window_2(
				0,
				"So - das ist es also. Das Blut\nvieler Freunde wurde im Kampf\ngegen Griffon vergossen ...<page>Ihr seid unsere letzte Hoffnung!\nIch z[UNI00e4]hle auf euch, Max und Monica.\nIhr m[UNI00fc]sst Griffon besiegen!"
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
								"Na gut. Zuerst m[UNI00fc]sst ihr die\nFeuer-B[UNI00f6]e vernichten.<page>Wenn wir nichts gegen diesen\nFeuerregen unternehmen, ist\nHeim Rada erledigt."
							)
						else
							event.open_message_window_2(
								0,
								"Na gut, das ist also passiert.\nWir sollten wohl froh sein,\ndass die Feuer-B[UNI00f6]e weg ist."
							)
							cutscene.face_each_other(player_slot, villager_id, 0)
							message.say_bubble(0, -1, villager_id, player_slot, 0)
							closing_mode = 1
							event.open_message_window_2(
								0,
								"Aber ich mache mir Sorgen um\ndeine Freundin, die in den Krater\ngefallen ist.<page>Aber das einzige, was wir tun\nk[UNI00f6]nnen, ist wohl Heim Rada wieder\naufzubauen und die<page>Werkstatt noch besser zu\nmachen als vorher."
							)
						end
					else
						event.open_message_window_2(
							0,
							"Ihr habt Gaspard besiegt!\nIhr seid echt unglaublich!<page>Jetzt geht's um seinen Chef,\nKaiser Griffon. Erledigt die\nSache ein f[UNI00fc]r alle Mal!"
						)
					end
				else
					event.open_message_window_2(
						0,
						"Ich war so froh, Paznos in\nAktion zu sehen, dass ich\nweinen musste.<page>All unsere Arbeit\nhat sich endlich bezahlt\ngemacht."
					)
				end
			else
				event.open_message_window_2(0, "Edelstein? Tut mir Leid,\nvon solchem Zeug hab\nich gar keine Ahnung.")
			end
		else
			event.open_message_window_2(0, "Endlich stellt ihr Griffon, ja?\nViel Gl[UNI00fc]ck. Erledigt ihn!")
		end
	end
	if villager_type == 402 then
		event.open_message_window_2(0, "Hallo! Wir haben lauter\ntolle Sachen hier! Was\ndarf's denn sein?")
	end
	if villager_type == 403 then
		event.open_message_window_2(0, "Was immer du brauchst, ich\nhab's da. Ich bin dein\nMann!")
	end
	if villager_type == 404 then
		event.open_message_window_2(
			0,
			"K[UNI00e4]mpfe k[UNI00f6]nnen sehr schwierig\nsein. Man kann nicht immer\neinfach drauflosst[UNI00fc]rmen.<page>Wer cool ist, benutzt auch\nGegenst[UNI00e4]nde. Finde den\nSchwachpunkt deines Gegners<page>und nutze ihn aus."
		)
	end
	if villager_type == 405 then
		event.open_message_window_2(
			0,
			"Es gibt nichts, was wir hier in\nder Gundorada-Werkstatt nicht\nbauen k[UNI00f6]nnten.<page>Ob gro[UNI00df], ob klein -\nwir bauen's dir."
		)
	end
	if villager_type == 406 then
		event.open_message_window_2(
			0,
			"He, wie seid ihr hier rein-\ngekommen? Passt lieber\nauf hier.<page>Es kann hier recht\ngef[UNI00e4]hrlich werden."
		)
	end
	if villager_type == 407 then
		event.open_message_window_2(0, "Was war denn die ganze Zeit\nlos? Ich kann mich einfach\nan nichts erinnern.")
	end
	if villager_type == 408 then
		event.open_message_window_2(
			0,
			"Wir wurden also alle von\nGriffon ausgel[UNI00f6]scht, ja? Er\nmuss ein schreckliches Monster sein."
		)
	end
	if villager_type == 409 then
		event.open_message_window_2(0, "Ich bin gerade sehr besch[UNI00e4]ftigt.\nBitte geh aus dem Weg.")
	end
	if villager_type == 410 then
		event.open_message_window_2(0, "Wir stehen alle hinter euch.\nUnd zwar zu 100 Prozent.")
	end
	if villager_type == 411 then
		event.open_message_window_2(
			0,
			"Die Waffen in dieser Kiste\nsind wohl nicht zu verkaufen.<page>Aber es gibt schon komische,\nsonderbare Waffen,\nnicht wahr ...?"
		)
	end
	if villager_type == 412 then
		event.open_message_window_2(
			0,
			"Dieser Gaspard kann also die\nFeuer-B[UNI00f6]e entfesseln?<page>Er ist nicht nur hinterlistig,\ner ist wahrhaft b[UNI00f6]se."
		)
	end
	if villager_type == 413 then
		event.open_message_window_2(
			0,
			"Was soll das Herz auf diesem\nSchild ...?<page>Das ist ziemlich widerlich,\nwenn du mich fragst ..."
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
