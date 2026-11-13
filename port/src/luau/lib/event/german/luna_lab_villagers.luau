--!strict
--- Holds the German conversations of the villagers of Luna Lab.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local luna_lab_villagers = {}

--- Plays the conversation of the Luna Lab villager that was talked to, choosing the line by villager type and story flags.
function luna_lab_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local lab_visit_flag: s32 = 0
	local aquarium_done_flag: s32 = 0
	local aquarium_quest_flag: s32 = 0
	local aquarium_invention_status: s32 = 0
	local electric_fish_state: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local griffon_hint_flag: s32 = 0
	local elena_attack_flag: s32 = 0
	local playable_character: s32 = 0
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
	if villager_type == 300 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			lab_visit_flag = event.get_save_flag(456) or lab_visit_flag
			if lab_visit_flag == 0 then
				event.open_message_window_2(
					0,
					"Wie? Wer seid ihr ...? Dies ist \ndie weltbeste Forschungs-\neinrichtung, das Mondweisheits-<page>Laboratorium. Es sieht vielleicht im\nMoment nicht beeindruckend aus, aber\nwir sollten dennoch unsere<page>Forschungen hier beenden\nk[UNI00f6]nnen."
				)
			else
				event.open_message_window_2(
					0,
					"Worte allein k[UNI00f6]nnen nicht\nbeschreiben, wie gro[UNI00df]artig das\nMondlabor ist.<page>Man muss es gesehen haben."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Wenn Griffon nicht beseitigt\nwird, kann die Geschichte nie wieder\nnormal werden.<page>Seine blo[UNI00df]e Existenz\nverzerrt den Lauf der\nGeschichte."
			)
		end
	end
	if villager_type == 301 then
		aquarium_done_flag = event.get_save_flag(420) or aquarium_done_flag
		if aquarium_done_flag == 0 then
			aquarium_quest_flag = event.get_save_flag(408) or aquarium_quest_flag
			if aquarium_quest_flag == 0 then
				event.open_message_window_2(0, "Haahn, schuuu,\nhaahn, schuuu.")
				closing_mode = 2
			else
				aquarium_invention_status = event.is_invention_created(309) or aquarium_invention_status
				if aquarium_invention_status < 0 then
					event.open_message_window_2(
						0,
						"Hier ein paar Tipps zur\nErfindung eines Aquariums. Eine\nHolzkiste, ein Fenster und ein<page>Springbrunnen. Die gibt's doch\nin eurer Stadt, nicht wahr?"
					)
				else
					electric_fish_state = event.get_save_data_value(2) or electric_fish_state
					if electric_fish_state == 0 then
						event.open_message_window_2(
							0,
							'Verf[UNI00fc]ttere erst einen "Elektro-Wurm"\nan einen Fisch im Aquarium,\num ihn unter Strom zu setzen.<page>Verf[UNI00fc]ttere dann den Fisch\nan den Shigura.\nHast du das verstanden?'
						)
					else
						event.open_message_window_2(
							0,
							"Oh, du hast den Fisch, ja?\nGib ihn jetzt dem Shigura.\nDas schaffst du locker, was?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"So! Du hast es geschafft!\nMeine Erfindung hat dir\nalso geholfen. Ja, tats[UNI00e4]chlich."
			)
		end
	end
	if villager_type == 302 then
		event.open_message_window_2(
			0,
			"Ob Osmond oder der Forschungs-\nleiter - hier gibt's einfach\nviel zu viele Verr[UNI00fc]ckte."
		)
	end
	if villager_type == 303 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				griffon_hint_flag = event.get_save_flag(600) or griffon_hint_flag
				if griffon_hint_flag == 0 then
					elena_attack_flag = event.get_save_flag(448) or elena_attack_flag
					if elena_attack_flag == 0 then
						event.open_message_window_2(
							0,
							"Pass gut auf das Muschel-\nPhon auf, ja? Das ist eine der wichtigsten\nErfindungen des Mondlabors."
						)
					else
						event.open_message_window_2(
							0,
							"Die Zeit dr[UNI00e4]ngt. Du musst dich\nbeeilen, Griffons Streitmacht n[UNI00e4]hert\nsich Elena und hat sie bald ..."
						)
					end
				else
					event.open_message_window_2(0, "Was dieser Griffon wohl f[UNI00fc]r\nein Mensch ist ...")
				end
			else
				event.open_message_window_2(
					0,
					"Edelsteine suchst du, ja ...?\nDas sind Weisheitskristalle, die\ndie Alten schufen.<page>Einer Analyse des Mondlabors\nzufolge gibt es sie an vier\nOrten:"
				)
				cutscene.face_each_other(player_slot, villager_id, 0)
				message.say_bubble(0, -1, villager_id, player_slot, 0)
				closing_mode = 1
				event.open_message_window_2(
					0,
					"Im Regenbogen-Schmetterling-Wald,\nim Sternenlicht-Canyon, in der\nH[UNI00f6]hle des Meeresdonners und auf dem<page>Gundorberg. Am Eingang dieser Orte\nm[UNI00fc]sste ein Sternsymbol sein, also\nhalte die Augen offen."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Na gut, es ist an der Zeit, Griffon\nauszuschalten. Das Schicksal der\nWelt liegt in deinen H[UNI00e4]nden.<page>Viel Gl[UNI00fc]ck!"
			)
		end
	end
	if villager_type == 304 then
		event.open_message_window_2(
			0,
			"Hier im Labor geht's nur um\nFertigkeit. Mit der richtigen Fertigkeit\nk[UNI00f6]nnte selbst ein Kind hier<page>zum Chef werden."
		)
	end
	if villager_type == 305 then
		event.open_message_window_2(
			0,
			"Die Mondsteine, die die Shigura\nuns bringen, helfen uns, einen klaren\nKopf zu behalten und uns zu<page>konzentrieren. Aber was die\nMondsteine genau sind, wei[UNI00df]\nich leider nicht ..."
		)
	end
	if villager_type == 306 then
		event.open_message_window_2(
			0,
			"Ein Labor auf dem Meer ist ganz\ncool, oder? Wei[UNI00df]t du, wie schwer\nich schuften musste, um hier<page>einen Job zu kriegen?"
		)
	end
	if villager_type == 307 then
		event.open_message_window_2(
			0,
			"Was h[UNI00e4]ltst du vom Design des\nMondlabors? Ich frage mich, wer diese\nVergn[UNI00fc]gungspark-Idee hatte ..."
		)
	end
	if villager_type == 308 then
		event.open_message_window_2(
			0,
			"Eines Tages [UNI00fc]berfl[UNI00fc]gele ich\nalle und zeige, wie schlau ich bin.\nHier geht's nur um Fertigkeit. "
		)
	end
	if villager_type == 309 then
		event.open_message_window_2(
			0,
			'Ich respektiere den Chef sehr.\nDas muss man einfach, wenn\njemand in seinem Alter einen<page>40-seitigen Bestseller namens\n"Handbuch f[UNI00fc]r Top-Forscher" schreibt.'
		)
	end
	if villager_type == 310 then
		event.open_message_window_2(
			0,
			"Ich bin noch recht neu hier.\nIch lerne viel und will sp[UNI00e4]ter\nmal ein Top-Forscher werden."
		)
	end
	if villager_type == 311 then
		event.open_message_window_2(
			0,
			"Die Aussicht aufs Meer aus diesem\nLabor ist unglaublich.<page>Am Horizont vereinigen sich die\nDunkelheit des Meeres und die\ndes Himmels."
		)
	end
	if villager_type == 312 then
		event.open_message_window_2(0, "Dies ist Labor Nr. 2.<page>Im Mondlabor hat jede\nAbteilung ihr eigenes\nForschungsgebiet.")
	end
	if villager_type == 313 then
		event.open_message_window_2(
			0,
			"Hier im Mondlabor simulieren wir\neine n[UNI00e4]chtliche Umwelt, um die\nKraft der Mondsteine zu verst[UNI00e4]rken."
		)
	end
	if villager_type == 314 then
		event.open_message_window_2(
			0,
			"Als ich hier angefangen habe,\nkonnte ich die Labors auch nie\nauseinanderhalten. Ich helfe dir.<page>Labor 1 ist rot, Labor 2\nist blau, Labor 3 ist lila\nund Labor 4 gr[UNI00fc]n.<page>Jedes Labor hat also seine\neigene Farbe."
		)
	end
	if villager_type == 315 then
		event.open_message_window_2(0, "Das Emblem [UNI00fc]ber dem Zentral-\nLabor ist dem Mond\nnachempfunden.")
	end
	if villager_type == 316 then
		event.open_message_window_2(
			0,
			"Angeblich wurde dieses Monlabor\nmithilfe von Mondsteinen gebaut,\ndie ein Seedrache namens<page>Shingala herbrachte. Manche dieser\nSeedrachen m[UNI00fc]ssen wohl recht\nschlau sein!"
		)
	end
	if villager_type == 317 then
		event.open_message_window_2(
			0,
			"Erz[UNI00e4]hl ihm nicht, dass ich das\ngesagt habe, aber<page>Osmonds so genannte Witze\nstehen uns bis hier.\nSie machen einen krank. "
		)
	end
	if villager_type == 318 then
		event.open_message_window_2(
			0,
			"Ich kann nicht l[UNI00fc]gen. Ja, auch\nich habe [UNI00fc]ber den Elektro-Wurm\ngeforscht. Jetzt hab ich ein<page>neues Projekt. Aber ich darf's\nnicht verraten! Streng geheim!\nAusgeplaudert wird nichts!"
		)
	end
	if villager_type == 319 then
		event.open_message_window_2(
			0,
			"Wie? Ihr wollt auch Forscher\nwerden?<page>Es ist nicht leicht, hier\naufgenommen zu werden.\nDie Konkurrenz ist hart."
		)
	end
	if villager_type == 320 then
		event.open_message_window_2(
			0,
			"Manche Forscher m[UNI00f6]gen das Design\ndes Mondlabors nicht. Ich finde\nes eigentlich cool ...<page>Aber damit geh[UNI00f6]re ich\nwohl zur Minderheit."
		)
	end
	if villager_type == 321 then
		event.open_message_window_2(
			0,
			"Wir sprechen gerade [UNI00fc]ber streng\ngeheime Forschungsdaten.<page>K[UNI00f6]nntest du uns bitte\nallein lassen?"
		)
	end
	if villager_type == 322 then
		event.open_message_window_2(
			0,
			"Es tut mir sehr Leid,\naber wir besprechen gerade streng\ngeheime Forschungsdaten.<page>Das geht nicht, wenn du hier\nherumstehst, also ..."
		)
	end
	if villager_type == 323 then
		event.open_message_window_2(
			0,
			"Nat[UNI00fc]rlich ist Dr. Nobb begabt,\naber auch sehr flei[UNI00df]ig.<page>Ich bin nichts dagegen ...\nWie ein Staubkorn ..."
		)
	end
	if villager_type == 324 then
		event.open_message_window_2(
			0,
			"Du? Ich hab geh[UNI00f6]rt, du hast mit\nDr. Osmond gestritten.<page>Das ist nicht schlecht - eigentlich\nsogar gut. Wir entdecken nur\ndann Neues, wenn wir alles<page>in Frage stellen."
		)
	end
	if villager_type == 325 then
		event.open_message_window_2(
			0,
			"Das helle Licht st[UNI00f6]rt dich, ja?<page>Ihr Besucher aus der Vergangenheit\nm[UNI00fc]sst euch wohl einfach\netwas eingew[UNI00f6]hnen."
		)
	end
	if villager_type == 326 then
		event.open_message_window_2(
			0,
			"Ach, ich mach nur ein P[UNI00e4]uschen.<page>Man muss seinem Hirn auch mal\nRuhe g[UNI00f6]nnen, sonst bringt\nman's irgendwann nicht mehr."
		)
	end
	if villager_type == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Du sollst ein guter Erfinder sein.\nWie w[UNI00e4]r's - kommst du zu uns,\nwenn du gro[UNI00df] bist?<page>Hey, wenn du erwachsen wirst, wird\ndieses Mondlabor gerade neu\neingerichtet worden sein.<page>Die sind bestimmt froh,\nwenn du kommst."
			)
		else
			event.open_message_window_2(
				0,
				"Findest du Erfinder nicht auch\ntotal m[UNI00e4]nnlich?<page>Aber verlieb dich blo[UNI00df] nicht\nin mich, klar? Meine Arbeit\nist mein Leben.<page>Es w[UNI00fc]rde nie funktionieren."
			)
		end
	end
	if villager_type == 328 then
		event.open_message_window_2(
			0,
			"Ich hab eine revolution[UNI00e4]re Idee.\nSie soll erm[UNI00f6]glichen, dass Monster\nund Menschen zusammenleben.<page>Ich baue eine Maschine,\ndie die menschliche\nSprache versteht."
		)
	end
	if villager_type == 329 then
		event.open_message_window_2(
			0,
			"Die Mondsteine sind die\nGrundlage des Mondlabors.<page>Ohne sie w[UNI00fc]rde hier\nsofort alles stillstehen."
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
end

return luna_lab_villagers
