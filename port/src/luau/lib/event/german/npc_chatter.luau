--!strict
--- Holds the German villager small talk and post-request chatter events.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")

local npc_chatter = {}

--- Answers the photo shop menu choice with either a demand for more scoops or an explanation of how ideas and scoops set the Photography level.
function npc_chatter.explain_photography_scoops(window: s32)
	local talk_character_id: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local menu_status: s32 = 0
	local menu_selection: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_character_id = event.get_triggered_event_data_2(13) or talk_character_id
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		do
			local out1, out2 = event.get_menu_value_3(6)
			menu_status = out1 or menu_status
			menu_selection = out2 or menu_selection
		end
		if 0 < menu_status then
			return 1
		end
		if menu_selection == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
		end
		if menu_selection == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
			)
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_step <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, talk_character_id, player_slot, 0)
			end
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the small talk of the villager who admires the player speed.
function npc_chatter.talk_agile_admirer(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Du bist viel schneller\nals du aussiehst.\nDu [UNI00fc]berraschst mich!")
	else
		event.open_message_window_2(0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the agile admirer small talk addressed to Monica.
function npc_chatter.talk_agile_admirer_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Ich mag eigentlich keine Frauen,\ndie mit Schwertern wedeln.<page>Die besten Frauen sind die\ndamenhaften. Adel zum Beispiel."
		)
	else
		event.open_message_window_2(0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the angler small talk about his fishing hobby before any request.
function npc_chatter.talk_angler_intro(npc: s32, player: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Angeln ist mein Hobby.<page>Ich tr[UNI00e4]ume davon, einmal einen\nMardan Garayan zu fangen.<page>Ich respektiere nur Leute,\ndie gro[UNI00df]e Fische fangen."
	)
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the villager too busy guarding important materials to talk.
function npc_chatter.talk_busy_with_materials(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Hallo, Max.\nTut mir Leid, ich bin\ngerade sehr besch[UNI00e4]ftigt.<page>Ich k[UNI00fc]mmere mich um wichtiges\nMaterial, mit dem ich diese Stadt\nsichern kann."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Falls es nicht dringend ist,\nhat es vielleicht Zeit bis morgen?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the candy maker promise of a free meal after the request is finished.
function npc_chatter.talk_candy_maker_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Ich k[UNI00f6]nnte dir nie\netwas abschlagen.")
	else
		event.open_message_window_2(0, "Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the gun fighter small talk addressed to Monica.
function npc_chatter.talk_gun_fighter_monica(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Bist du eine Freundin von Max?<page>Na ja, pass auf dich auf.")
	else
		event.open_message_window_2(
			0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who guards the Holy Water secret.
function npc_chatter.talk_holy_water_keeper(npc: s32, player: any)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.open_message_window_2(0, "Oh, hallo, junge Dame.\nKann ich etwas f[UNI00fc]r dich tun?")
		else
			event.open_message_window_2(0, "Max, erz[UNI00e4]hl deinem Vater\nnichts von dem Weihwasser, ja?")
		end
	else
		event.open_message_window_2(0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the painter's small talk once his request is finished, offering his new power.
function npc_chatter.talk_painter_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Bitte nutze meine neue\nKraft, wann immer du willst.")
	else
		event.open_message_window_2(
			0,
			"Die Welt der Bilder ist gro[UNI00df].\nMalen zu lernen mag ein Leben\ndauern, doch es ist die Zeit wert."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who is excited about the Blackstone Railroad.
function npc_chatter.talk_railroad_fan(npc: s32, player: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc_dialogue.greet_monica_about_hair(npc, player)
			return
		end
		event.open_message_window_2(0, "Aber geh nirgends hin,\nwo's zu gef[UNI00e4]hrlich ist.")
	else
		event.open_message_window_2(0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the swordsmith's small talk to Max, who remembers seeing her at the circus, differing by chapter.
function npc_chatter.talk_swordsmith_max(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Du hast mich im Zirkus gesehen?\nNicht schlecht, was?<page>Es ist weniger mein Beruf\nals mein Hobby."
		)
	else
		event.open_message_window_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the tailor's small talk to Monica, asking her not to put Max in danger, differing by chapter.
function npc_chatter.talk_tailor_monica(npc: s32, player: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Bitte h[UNI00f6]r auf, Max in\nGefahr zu bringen.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Wenn ich nur einen Kratzer an\nihm finde, verzeih ich dir das nie!")
	else
		event.open_message_window_2(0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the generic villager conversation selected by the villager, the chapter and the story flags.
function npc_chatter.talk_to_villager()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	local message_group: s32 = 0
	local message_page: s32 = 0
	local speaker_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local railway_running_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_character, "talk_chara=", villager_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, villager_id)
		message_group = out1 or message_group
		message_page = out2 or message_page
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		speaker_variant = 2
	else
		speaker_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_character)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if villager_id == 1012 or villager_id == 1015 or villager_id == 1018 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	if villager_id == 50 then
		event.open_message_window_2(0, "Hey! Ab hier\nist abgesperrt.")
		cutscene.talk_to_character(villager_character, -1, 0, 0)
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		railway_running_flag = event.get_save_flag(9) or railway_running_flag
		if villager_id == 2 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Sieh dir das an. Kaum zu\nglauben, dass das Ding\nfr[UNI00fc]her richtig gerast ist, was?<page>Ist es aber ... vor langer Zeit.<page>Ich tr[UNI00e4]ume davon, mit dem\nDing noch mal loszufahren. Darum\nhalte ich es auch in Schuss.<page>Wenn es je dazu kommt, kann\nich ihn sofort wieder\nauf die Gleise bringen."
				)
			else
				event.open_message_window_2(
					0,
					"Du wei[UNI00df]t doch, dass man immer ver-\nsteift, wenn man zu selten trainiert.\nDas gilt f[UNI00fc]r Maschinen auch."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 63 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Hallo Max!\nDie Bahn f[UNI00e4]hrt schon seit\neiner Ewigkeit nicht mehr.<page>Aber ich k[UNI00fc]mmere mich\ntrotzdem immer um den Bahnhof."
				)
			else
				event.open_message_window_2(
					0,
					"Der B[UNI00fc]rgermeister l[UNI00e4]sst die Bahn\nendlich wieder fahren. Aber\nnicht f[UNI00fc]r alle.<page>Oh Mann, ich w[UNI00fc]rde die\nLeute so gern einsteigen lassen ..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 65 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Hi, Max. Wusstest du, dass der\nBahnhofsvorsteher mein Vater ist?\nWir k[UNI00fc]mmern uns um den Bahnhof.<page>Bis die Bahn eines Tages\nwieder fahren darf ..."
				)
			else
				event.open_message_window_2(
					0,
					"Die Bahn f[UNI00e4]hrt!\nAber es wird etwas dauern, bis\nder Bahnhof wieder normal ist ..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if villager_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Ich verehre Monica seit langem\nheimlich, aber in letzter\nZeit war sie nicht hier.<page>Darum kann ich mich so schlecht\nauf die Arbeit konzentrieren."
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(0, "He, Max!\nMonica ist zur[UNI00fc]ck, ja?\nDa werden sich alle freuen!")
				else
					event.open_message_window_2(0, "Monica! Wie geht's dir?\nIch hab dich echt vermisst.")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Ich konnte gerade normal mit\nMonica reden, da ist sie\nverschwunden.<page>Komm schon,  Max,\nsag mir doch, wo sie ist!"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Monica ist zur[UNI00fc]ck.\nWie kann das sein?")
				else
					event.open_message_window_2(0, "Monica, du bist zur[UNI00fc]ck!\nWie kann das sein?")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_page * 10)) + speaker_variant))
	cutscene.talk_to_character(villager_character, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_character)
end

--- Plays the gardener tending a sick tree, differing by playable character.
function npc_chatter.talk_tree_gardener(npc: s32, player: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.set_character_motion(player, "立ち")
		event.open_message_window_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
		message.say_bubble(0, -1, npc, player, 0)
	else
		event.open_message_window_2(
			0,
			"Oh, Max! Du hast mich erschreckt.\nIch entferne gerade Ungeziefer von\ndiesem Baum.<page>Nicht alle B[UNI00e4]ume wachsen\nvon alleine gut. Manche\nmuss man gut pflegen, so wie diesen."
		)
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
end

return npc_chatter
