--!strict
--- Dialogue and scripted conversations of the Palm Brinks townspeople in the Spanish version of the game.

local vm = require("@lib/vm")
local auction_bidder = vm.module("@lib/event/spanish/auction_bidder")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local party = vm.module("@lib/event/party")
local party_recruit = vm.module("@lib/event/spanish/party_recruit")
local quest_dialogue = vm.module("@lib/event/spanish/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/spanish/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local palm_brinks_villagers = {}

--- Remarks that the player resembles Elena and warns about Zelmite Mine.
function palm_brinks_villagers.compare_player_to_elena(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Quiz[UNI00e1] s[UNI00f3]lo me pase a m[UNI00ed], pero hay\nalgo en ti que me recuerda a Elena.<page>No s[UNI00e9] qu[UNI00e9] es, pero tienes cierta cualidad\ndistinta al resto de los habitantes de la ciudad."
		)
	else
		event.open_message_window_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Explains that the Firbit people only grant favours to those who are better than themselves.
function palm_brinks_villagers.explain_firbit_favours(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Runs the request in which a villager asks for escalating sums of Gilda for an auction bid and returns 600 Gilda after winning it.
function palm_brinks_villagers.lend_auction_money(character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local handover_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	auction_stage = event.get_save_counter(9) or auction_stage
	money = event.get_money() or money
	if auction_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Ese dinero no\nme vale para la subasta.<page>Necesito 1000 Gildas.\nNo s[UNI00e9] si est[UNI00e1] claro."
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(0, "[UNI00a1]No te lo vas a creer!<page>El precio ha subido a\n1200 Gildas.")
			message.say_bubble(0, -1, character, player_character, 0)
			event.open_message_window_2(0, "Lo siento mucho, pero [UNI00bf]podr[UNI00ed]as\nconseguir 1500 Gildas?")
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"No podemos perder el tiempo,\nsi no, se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 1500 Gildas cuanto antes!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"[UNI00a1]Es terrible!\nAlguien ofrece 1800 Gildas.<page>Si no doy m[UNI00e1]s de 2000,\nno me lo llevar[UNI00e9] ni en broma."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"No podemos perder el tiempo,\nsi no se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 2000 Gildas cuanto antes!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Sonny, [UNI00bf]has conseguido reunir\nlas 2000 Gildas?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.set_character_motion(character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] hago? Es tuyo.\nHa sido un despilfarro.")
		handover_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if handover_choice ~= 0 then
			event.open_message_window_2(
				0,
				"Ya... Bueno, 2000 Gildas es mucho dinero.\nDebe de ser duro gast[UNI00e1]rselo.\nIncluso para un joven bien acomodado como t[UNI00fa]... <page>Bueno, no importa.\nPero la subasta a[UNI00fa]n no ha terminado.\nEsperar[UNI00e9] lo que haga falta..."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Gracias por todo.<page>[UNI00a1]Me largo corriendo a la subasta!")
		message.say_bubble(0, -1, character, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, character)
		event.set_character_active(0, character)
		event.delete_villager(character)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Muchas gracias.\nHe conseguido ganar la subasta.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Puj[UNI00e9] mucho y los dem[UNI00e1]s desistieron\nr[UNI00e1]pidamente. [UNI00a1]Me lo he llevado por 1400 Gildas!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Tengo que devolverte 600.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "Y trabajar[UNI00e9] para devolverte\nel resto del dinero que te debo.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"S[UNI00e9] que te he causado muchas molestias.\nTe devolver[UNI00e9] el favor en cualquier momento."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Invites the player to bring any problem to the villager first.
function palm_brinks_villagers.offer_help_with_problems(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Si tienes alg[UNI00fa]n problema,\nhabla primero conmigo.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Greets the shopkeeper that was talked to, then opens that shop's menu once the conversation ends.
function palm_brinks_villagers.open_shop_after_greeting()
	local npc_type: s32 = 0
	local npc_character: s32 = 0
	local baker_greeted: s32 = 0
	local weapon_shop_greeted: s32 = 0
	local priest_greeted: s32 = 0
	print("IN go_shop_up()\n")
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	npc_character = event.get_triggered_event_data_2(13) or npc_character
	print("talk_chara=", npc_type, "talk_chara_id=", npc_character, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bienvenido.")
	if npc_type == 18 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
		)
	end
	if npc_type == 4 then
		event.open_message_window_2(
			0,
			"Trabajando duro, [UNI00bf]no?\n[UNI00bf]Necesit[UNI00e1]is algo?<page>Pero por la cara, nada.\nNi siquiera para ti, Max."
		)
	end
	if npc_type == 34 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Necesitas m[UNI00e1]s elementos\nde Georama?<page>Si no tienes tiempo\npara conseguirlos t[UNI00fa] mismo, a lo mejor\npuedes solucionar tus problemas con un poco de dinero."
		)
	end
	if npc_type == 1012 then
		baker_greeted = event.get_save_flag(45) or baker_greeted
		if baker_greeted == 0 then
			event.open_message_window_2(
				0,
				"Hola. Soy un aprendiz de panadero.\nMe encargo de la panader[UNI00ed]a mientras\nPolly est[UNI00e1] fuera.<page>Estoy un poco nervioso, pero es\nparte de mi formaci[UNI00f3]n, supongo.\n[UNI00a1]Har[UNI00e9] lo que pueda!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_type == 1015 then
		weapon_shop_greeted = event.get_save_flag(46) or weapon_shop_greeted
		if weapon_shop_greeted == 0 then
			event.open_message_window_2(
				0,
				"No nos parecemos mucho...\nPero soy la hermana peque[UNI00f1]a de Milane.<page>Me pidi[UNI00f3] que cuidara de la tienda mientras ella no est[UNI00e1].\n[UNI00a1]Yo no s[UNI00e9] nada de armas!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_type == 1018 then
		priest_greeted = event.get_save_flag(47) or priest_greeted
		if priest_greeted == 0 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Te he sorprendido, a que s[UNI00ed]? Cualquiera se sorprender[UNI00ed]a\nal ver a alguien\nvestido de esta manera aqu[UNI00ed].<page>Soy un buen amigo del Padre Bruno. Estoy\npara informar a la gente mientras [UNI00e9]l est[UNI00e1] de viaje.\nBueno, [UNI00bf]te puedo ayudar en algo?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
			)
		end
	end
	if npc_character ~= -1 then
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_type == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_type == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_type == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_type == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_type == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_type == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_type == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_type == 1018 then
		menu.open_type_6_alt(37)
	end
end

--- Has the seamstress decline to join the party for lack of confidence and registers request 7 to restore it.
function palm_brinks_villagers.request_adel_confidence(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(
		0,
		"Ya veo... Me gustar[UNI00ed]a\npoder ayudaros, de verdad.\nM[UNI00e1]s que nada.<page>Pero no tengo ninguna\nconfianza en m[UNI00ed] misma."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Siempre me rindo antes de tiempo\ny nunca he hecho nada hasta el final.<page>Cuando era peque[UNI00f1]a, so[UNI00f1]aba con convertirme en sastre\ne intent[UNI00e9] hacer algo muchas veces,\npero nunca termin[UNI00e9] ninguna prenda."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Si os acompa[UNI00f1]ara, estoy segura\nde que molestar[UNI00ed]a.<page>Perdonad, pero no.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vaya por Dios, Adel ha perdido\ntoda su confianza. Eso no es nada bueno. Hay\n que lograr que haga ropa otra vez."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Challenges the player to catch a Nonky over 60cm and registers request 15.
function palm_brinks_villagers.request_catch_big_nonky(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]Quieres que te haga un favor?<page>Pues esc[UNI00fa]chame primero.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"S[UNI00f3]lo presto atenci[UNI00f3]n a la gente que respeto.<page>Y s[UNI00f3]lo respeto a la gente\nque ha pescado peces m[UNI00e1]s grandes que yo."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"El mayor pez que he cogido\nfue un Nonky de 60 cm.<page>[UNI00bf]Qu[UNI00e9], impresionado?\nSi te apetece competir conmigo,\nestar[UNI00e9] encantado."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Al parecer, la [UNI00fa]nica forma de\nconseguir que se una a ti es capturando un Nonky\n de m[UNI00e1]s de 60 cm. [UNI00a1]T[UNI00fa] puedes!"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Prueba de todas formas en\nel lago de Palm Brinks.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Asks the player to find Chestnuts for the Castagnaccio sweet and registers the request.
function palm_brinks_villagers.request_chestnuts(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Ah, por cierto!\nQuer[UNI00ed]a charlar contigo sobre un asunto.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ya sabr[UNI00e1]s que estoy\nhaciendo caramelos extra[UNI00f1]os de todo\nel mundo como parte de mi investigaci[UNI00f3]n."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Me han hablado de un caramelo llamado Castagnaccio.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "que se fabrica con una cosa llamada Castarna.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "He descubierto que la Castarna crece\nen el mismo tipo de [UNI00e1]rbol que las Nueces.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Por eso pens[UNI00e9] que dar[UNI00ed]a lo mismo usar Nueces en su lugar,\npero ha pasado algo raro...\nNo quedan Nueces en toda la ciudad."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Parece ser que el alcalde las ha vendido todas.\nNo s[UNI00e9] si podr[UNI00ed]as ayudarme.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Has the Scoop Memo villager review the player's Scoop Memos, announcing new scoops, and returns nonzero when a reward can be claimed.
function palm_brinks_villagers.review_scoop_memos(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local memo_count: s32 = 0
	local collected_scoops: s32 = 0
	local total_scoops: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Tr[UNI00e1]eme una\nNota de Logros, anda.")
			if current_map == 22 then
				resume_step = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			collected_scoops = out1 or collected_scoops
			total_scoops = out2 or total_scoops
		end
		if collected_scoops == total_scoops then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Parece que no quedan\nlogros.")
			if current_map == 22 then
				resume_step = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
			resume_step = 5
			return npc_chatter.explain_photography_scoops(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Yo calculo [Number1] logros m[UNI00e1]s.")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(
				window,
				"[UNI00a1]Oye, t[UNI00ed]o! [UNI00a1]No te relajes!\n[UNI00bf]D[UNI00f3]nde est[UNI00e1]n todas tus nuevos logros Interiores?"
			)
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(
				window,
				"[UNI00a1]Guau! [UNI00a1]Ya tienes [Number 1] nuevos logros!\n[UNI00a1]Sab[UNI00ed]a que lo llevabas dentro de ti!"
			)
		end
		if current_map == 22 then
			resume_step = 7
			message.say_bubble(window, -1, npc_character, player_character, 0)
		else
			resume_step = 8
			message.show(window, -1, 3, 256, 208)
		end
		resume_step = 9
		return npc_chatter.explain_photography_scoops(window)
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_step <= 9 then
			if resume_step <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_step <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Remarks on the player's trips out of town, or hands over to the girl's greeting when the playable character is the girl.
function palm_brinks_villagers.talk_about_leaving_town(character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Has estado fuera [UNI00fa]ltimamente,\n[UNI00bf]no, Max?<page>No lo niegues.\nLo s[UNI00e9] de buena tinta."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the remark that Max is hardly ever seen since the player arrived.
function palm_brinks_villagers.talk_about_max_absence(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Desde que has venido,\napenas he visto a Max.\nNo s[UNI00e9] qu[UNI00e9] pretendes,<page>pero espero que no lo est[UNI00e9]s utilizando."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the aspiring chef's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_aspiring_chef(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Hola. [UNI00bf]Qu[UNI00e9] clase de comida\nquieres, M[UNI00f3]nica?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Me gusta la comida normal, pero\nno le hago ascos a lo extra[UNI00f1]o.")
	else
		event.open_message_window_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Chooses the dialogue of the church candle puzzle giver from the progress of the main request chain and of request 13.
function palm_brinks_villagers.talk_candle_puzzle_giver(character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		npc_dialogue.pose_candle_puzzle(character, player_character)
		return
	end
	if request_status == 1 then
		party_recruit.recruit_partner(character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(character, player_character)
		return
	end
end

--- Plays the circus performer's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_circus_performer(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"[UNI00bf]As[UNI00ed] que me has visto en el circo?\n[UNI00bf]Est[UNI00e1] bien, eh?<page>Para m[UNI00ed] es m[UNI00e1]s una afici[UNI00f3]n\nque un trabajo."
		)
	else
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Asks about discoveries and describes the villager's cooking experiments.
function palm_brinks_villagers.talk_cooking_experiments(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Has hecho alg[UNI00fa]n gran descubrimiento?<page>Mientras t[UNI00fa] descubres\nm[UNI00e1]quinas y chismes,\nyo invento platos.<page>Todos los d[UNI00ed]as investigo para\npreparar comida que nadie haya\nprobado a[UNI00fa]n."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the angler's remark about fishing as a hobby and respecting those who catch big fish.
function palm_brinks_villagers.talk_fishing_hobby(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mi afici[UNI00f3]n es la pesca.<page>Mi sue[UNI00f1]o es capturar un Mardan Garayan.<page>S[UNI00f3]lo respeto a la gente que pesca peces grandes."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the request 9 giver from the playable character, the character's position and the progress of request 9.
function palm_brinks_villagers.talk_request_9_giver(character: s32, player_character: s32)
	local playable_character: s32 = 0
	local request_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_dialogue.talk_about_armed_women(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_town_too_peaceful(character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_dialogue.chat_busy_with_materials(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 9) or request_status
	if request_status == 0 then
		npc_dialogue.explain_boat_run_test(character, player_character)
		return
	end
	if request_status == 1 then
		npc_dialogue.check_boat_run_time(character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_agile_admirer(character, player_character)
		return
	end
end

--- Starts the conversation with a villager by dispatching on the villager's character type to that villager's own dialogue.
function palm_brinks_villagers.talk_to_npc(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_type: s32 = 0
	local current_submap: s32 = 0
	local state_flag: s32 = 0
	local shop_or_scoop_choice: any = 0
	local friend_or_scoop_choice: any = 0
	local request_0_status: s32 = 0
	local request_8_status: s32 = 0
	local greeting_choice: any = 0
	local request_0_status_2: s32 = 0
	local request_10_status: s32 = 0
	local greeting_choice_2: any = 0
	local request_0_status_3: s32 = 0
	local request_13_status: s32 = 0
	local greeting_choice_3: any = 0
	local request_8_status_2: s32 = 0
	local playable_character: s32 = 0
	local greeting_choice_4: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	chapter = event.get_chapter() or chapter
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	event.get_current_map()
	current_submap = event.get_current_submap() or current_submap
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, npc_character)
	if npc_type == 3 then
		npc_dialogue.talk_to_gardener(npc_character, player_character)
	end
	if npc_type == 5 then
		quest_dialogue.talk_painter(npc_character, player_character)
	end
	if npc_type == 4 then
		state_flag = event.get_save_flag(104) or state_flag
		if state_flag == 0 then
			event.open_message_window_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			shop_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if shop_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if shop_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				palm_brinks_villagers.open_shop_after_greeting()
			end
		else
			event.open_message_window_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			friend_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if friend_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if friend_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				npc_dialogue.talk_to_coin_collector(npc_character, player_character)
			end
		end
	end
	if npc_type == 7 then
		quest_dialogue.talk_candy_maker(npc_character, player_character)
	end
	if npc_type == 8 then
		villager_dialogue.talk_quest_4_villager(npc_character, player_character)
	end
	if npc_type == 10 then
		auction_bidder.start_conversation(npc_character, player_character)
	end
	if npc_type == 11 then
		npc_dialogue.talk_to_adel(npc_character, player_character)
	end
	if npc_type == 12 then
		request_0_status = event.get_quest_request_status(0, 0) or request_0_status
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if request_0_status == 2 and request_8_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			greeting_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice == 1 then
				quest_dialogue.talk_baker(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_baker(npc_character, player_character)
		end
	end
	if npc_type == 14 then
		palm_brinks_villagers.talk_request_9_giver(npc_character, player_character)
	end
	if npc_type == 15 then
		request_0_status_2 = event.get_quest_request_status(0, 0) or request_0_status_2
		request_10_status = event.get_quest_request_status(0, 10) or request_10_status
		if request_0_status_2 == 2 and request_10_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			greeting_choice_2 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_2 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_2 == 1 then
				villager_dialogue.talk_quest_10_villager(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			villager_dialogue.talk_quest_10_villager(npc_character, player_character)
		end
	end
	if npc_type == 16 then
		quest_dialogue.talk_gun_fighter(npc_character, player_character)
	end
	if npc_type == 17 then
		villager_dialogue.talk_quest_12_villager(npc_character, player_character)
	end
	if npc_type == 18 then
		request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if request_0_status_3 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			greeting_choice_3 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_3 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_3 == 1 then
				palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 33 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
		end
	end
	if npc_type == 19 then
		quest_dialogue.talk_rufio(npc_character, player_character)
	end
	if npc_type == 20 then
		quest_dialogue.talk_angler(npc_character, player_character)
	end
	if npc_type == 21 then
		npc_dialogue.talk_to_fisherman(npc_character, player_character)
	end
	if npc_type == 23 then
		npc_dialogue.talk_to_mena(npc_character, player_character)
	end
	if npc_type == 24 then
		npc_dialogue.talk_to_hide_and_seek_child(npc_character, player_character)
	end
	if npc_type == 25 then
		villager_dialogue.talk_quest_19_villager(npc_character, player_character)
	end
	if npc_type == 33 then
		request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_2 == 1 and playable_character == 0 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "D[UNI00e9]jame comprar\nHola")
			greeting_choice_4 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_4 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_4 == 1 then
				quest_dialogue.talk_bread_delivery_recipient(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		palm_brinks_villagers.open_shop_after_greeting()
	end
	if npc_type == 1 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.open_message_window_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.open_message_window_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.open_message_window_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.open_message_window_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.open_message_window_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc_character)
end

--- Starts the ordinary villager conversation when the talked-to character type is outside the special 100 to 1000 range.
function palm_brinks_villagers.talk_to_ordinary_villager()
	local npc_type: s32 = 0
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	if npc_type < 100 or 1000 < npc_type then
		npc_chatter.talk_to_villager()
	end
end

--- Plays a worried villager's remark about the player, with a prayer for the player's safety in chapter 8.
function palm_brinks_villagers.talk_worried_villager(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Por favor, deja de meter\na Max en situaciones peligrosas.")
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Como le hagan un ara[UNI00f1]azo,\nno te perdonar[UNI00e9] nunca.")
	else
		event.open_message_window_2(0, "Rezar[UNI00e9] por ti...")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

return palm_brinks_villagers
