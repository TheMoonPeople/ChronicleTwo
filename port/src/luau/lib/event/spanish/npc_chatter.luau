--!strict
--- Holds the Spanish villager small talk and post-request chatter events.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")

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
			event.open_message_window_2(window, "Si no me traes m[UNI00e1]s logros\nno puedo darte nada.")
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
				"El nivel de tu Fotograf[UNI00ed]a est[UNI00e1] determinado\npor el n[UNI00fa]mero de ideas y logros\nque tengas.<page>Conforme vayas aumentando de nivel, conseguir[UNI00e1]s\nm[UNI00e1]s objetos como recompensa."
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
		event.open_message_window_2(0, "Eres mucho m[UNI00e1]s r[UNI00e1]pido\nde lo que parece.\n[UNI00a1]Me has sorprendido!")
	else
		event.open_message_window_2(0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the angler small talk once the fishing request is finished.
function npc_chatter.talk_angler_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Umm. No me hace falta saberlo ahora mismo,\npero quiz[UNI00e1] alg[UNI00fa]n d[UNI00ed]a\npuedas ense[UNI00f1]arme alguno de tus trucos."
		)
	else
		event.open_message_window_2(
			0,
			"Tengo unas ganas de\nver todos los lugares para pescar\ndel mundo... S[UNI00ed] que va a ser divertido."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the baker once she has joined the party.
function npc_chatter.talk_baker_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Vamos, Max,\nen marcha.<page>[UNI00bf]A d[UNI00f3]nde vamos?")
	else
		event.open_message_window_2(0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the servant after the book request is finished.
function npc_chatter.talk_book_servant_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"[UNI00bf]El libro que compr[UNI00e9]?\nEn realidad todav[UNI00ed]a no lo he le[UNI00ed]do.<page>Me bastaba\nel hecho de tenerlo."
		)
	else
		event.open_message_window_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the grandmother small talk once her request is finished.
function npc_chatter.talk_grandmother_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Pero, [UNI00bf]de qu[UNI00e9] te iba a servir una\nabuelita como yo?")
	else
		event.open_message_window_2(
			0,
			'Cuando est[UNI00e9] terminado el Ferrocarril Blackstone\nme gustar[UNI00ed]a\nir al "Fin del mundo".'
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the grandmother small talk about her poor hearing.
function npc_chatter.talk_grandmother_hard_of_hearing(npc: s32, player: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>[UNI00a1]Ah! [UNI00a1]Hola!\n[UNI00da]ltimamente no oigo muy bien.<page>No te entiendo si no\nme hablas m[UNI00e1]s despacio."
	)
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
			event.open_message_window_2(0, "Oh. Hola, joven.\n[UNI00bf]Puedo hacer algo por ti?")
		else
			event.open_message_window_2(0, "Max, no le hables a tu padre del\nAgua bendita, [UNI00bf]entendido?")
		end
	else
		event.open_message_window_2(0, "Tiene que haber much[UNI00ed]simas plantas\npor ah[UNI00ed] que ni siquiera conozcamos.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the mayor small talk once the safe request is finished.
function npc_chatter.talk_mayor_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"No te olvides de reciclar y\nsaca la basura los d[UNI00ed]as apropiados. [UNI00bf]Te acordar[UNI00e1]s?"
		)
	else
		event.open_message_window_2(
			0,
			"F[UNI00ed]jate bien en lo que te digo:\ns[UNI00e9] que la Mina de Zelmite es un lugar\npeligroso. No hagas tonter[UNI00ed]as."
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
		event.open_message_window_2(0, "Pero no me lleves\na ning[UNI00fa]n sitio demasiado peligroso.")
	else
		event.open_message_window_2(
			0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the ailing villager who cannot find what is wrong.
function npc_chatter.talk_sick_villager(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "[UNI00da]ltimamente no me encuentro muy bien.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada.<page>[UNI00bf]C[UNI00f3]mo es posible?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the swordsmith small talk once the sword request is finished.
function npc_chatter.talk_swordsmith_done(npc: s32, player: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Los destellos de las espadas\nbien forjadas brillan mucho.<page>Te quitan el aliento.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "No s[UNI00e9] c[UNI00f3]mo le puede gustar\na nadie pulir piedras.")
	else
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
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
		event.open_message_window_2(0, "[UNI00a1]Eh! Prohibido\nel paso.")
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
					"Mira. Cualquiera se cree\nque este trasto iba por ah[UNI00ed]\nzumbando, [UNI00bf]eh?<page>Pues as[UNI00ed] era... Hace mucho tiempo.<page>Mi sue[UNI00f1]o es volver a viajar\nen [UNI00e9]l. Por eso\nme preocupo de mantenerlo a punto.<page>As[UNI00ed], si alg[UNI00fa]n d[UNI00ed]a llega la ocasi[UNI00f3]n,\n lo pondr[UNI00e9] a funcionar\nen un periquete."
				)
			else
				event.open_message_window_2(
					0,
					"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
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
					"[UNI00a1]Max, hola!\nHace ya mucho\nque no circula el tren,<page>pero yo sigo vigilando\nla estaci[UNI00f3]n todos los d[UNI00ed]as."
				)
			else
				event.open_message_window_2(
					0,
					"El alcalde levant[UNI00f3] por fin el trasero\nde la silla y puso en marcha los trenes otra vez. Pero\ntodav[UNI00ed]a no est[UNI00e1]n listos.<page>Ni te imaginas las ganas que tengo\nde que se monten los de la ciudad..."
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
					"Hola, Max. [UNI00bf]Sab[UNI00ed]as que el jefe de la estaci[UNI00f3]n\nes mi padre? Vigilamos\njuntos la estaci[UNI00f3]n.<page>Hasta que el tren vuelva\na funcionar como antes..."
				)
			else
				event.open_message_window_2(
					0,
					"[UNI00a1]El tren ya funciona!\nPero todav[UNI00ed]a queda tiempo para\nque la estaci[UNI00f3]n vuelva a la normalidad..."
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
					"He sido admirador secreto de\nM[UNI00f3]nica durante a[UNI00f1]os, pero\nno la hab[UNI00ed]a visto [UNI00fa]ltimamente.<page>Por eso no me\npuedo concentrar en el trabajo."
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(
						0,
						"[UNI00a1]Oye, Max!\nParece ser que M[UNI00f3]nica ha vuelto.\n[UNI00a1]Se va alegrar todo el mundo!"
					)
				else
					event.open_message_window_2(
						0,
						"[UNI00a1]M[UNI00f3]nica! [UNI00bf]C[UNI00f3]mo te ha ido?\nTe he echado de menos."
					)
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
					"Estaba hablando\ncon ella  como siempre,\ny va y desaparece.<page>Max, dime:\n[UNI00bf]d[UNI00f3]nde est[UNI00e1]?"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Ha vuelto M[UNI00f3]nica.\n[UNI00bf]C[UNI00f3]mo puede ser?")
				else
					event.open_message_window_2(0, "M[UNI00f3]nica, has vuelto.\n[UNI00bf]C[UNI00f3]mo es posible?")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
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
		event.open_message_window_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
		message.say_bubble(0, -1, npc, player, 0)
	else
		event.open_message_window_2(
			0,
			"[UNI00a1]Max! Qu[UNI00e9] susto.\nEstaba quit[UNI00e1]ndole los bichos\na este [UNI00e1]rbol.<page>No todos los [UNI00e1]rboles crecen bien\nsolos. A algunos, como\neste, hay que vigilarlos."
		)
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
end

return npc_chatter
