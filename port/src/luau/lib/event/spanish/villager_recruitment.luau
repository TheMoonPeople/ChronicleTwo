--!strict
--- Holds the Spanish recruitment of the old woman villager into the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local npc_recruit = vm.module("@lib/event/spanish/npc_recruit")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/spanish/palm_brinks_quests")
local palm_brinks_talk = vm.module("@lib/event/spanish/palm_brinks_talk")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/spanish/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/spanish/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_recruitment = {}

--- Prompts the player for the invitation phrase and recruits the old woman villager when it is entered correctly.
function villager_recruitment.ask_phrase_to_join(villager: s32, player_character: s32)
	local entry_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo?<page>[UNI00bf]No puedes hablar m[UNI00e1]s despacio?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Escribe: "Vamos juntos."', "Vamos juntos.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if entry_result == 0 then
		event.open_message_window_2(0, "[UNI00bf]De qu[UNI00e9] me est[UNI00e1]s hablando?\nNo tengo ni idea...")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Una aventura?\nEso estar[UNI00ed]a bien.<page>Pero, [UNI00bf]de qu[UNI00e9] te servir[UNI00ed]a una\nvieja como yo?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Runs the butler's rising auction bids, taking 2000 Gilda once the player pays and returning 600 after the successful bid.
function villager_recruitment.collect_auction_funds(villager: s32, player_character: s32)
	local bid_stage: s32 = 0
	local money: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	bid_stage = event.get_save_counter(9) or bid_stage
	money = event.get_money() or money
	if bid_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Ese dinero no\nme vale para la subasta.<page>Necesito 1000 Gildas.\nNo s[UNI00e9] si est[UNI00e1] claro."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(0, "[UNI00a1]No te lo vas a creer!<page>El precio ha subido a\n1200 Gildas.")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.open_message_window_2(0, "Lo siento mucho, pero [UNI00bf]podr[UNI00ed]as\nconseguir 1500 Gildas?")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"No podemos perder el tiempo,\nsi no, se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 1500 Gildas cuanto antes!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"[UNI00a1]Es terrible!\nAlguien ofrece 1800 Gildas.<page>Si no doy m[UNI00e1]s de 2000,\nno me lo llevar[UNI00e9] ni en broma."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"No podemos perder el tiempo,\nsi no se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 2000 Gildas cuanto antes!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Sonny, [UNI00bf]has conseguido reunir\nlas 2000 Gildas?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] hago? Es tuyo.\nHa sido un despilfarro.")
		choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if choice ~= 0 then
			event.open_message_window_2(
				0,
				"Ya... Bueno, 2000 Gildas es mucho dinero.\nDebe de ser duro gast[UNI00e1]rselo.\nIncluso para un joven bien acomodado como t[UNI00fa]... <page>Bueno, no importa.\nPero la subasta a[UNI00fa]n no ha terminado.\nEsperar[UNI00e9] lo que haga falta..."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Gracias por todo.<page>[UNI00a1]Me largo corriendo a la subasta!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Muchas gracias.\nHe conseguido ganar la subasta.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Puj[UNI00e9] mucho y los dem[UNI00e1]s desistieron\nr[UNI00e1]pidamente. [UNI00a1]Me lo he llevado por 1400 Gildas!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Tengo que devolverte 600.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "Y trabajar[UNI00e9] para devolverte\nel resto del dinero que te debo.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"S[UNI00e9] que te he causado muchas molestias.\nTe devolver[UNI00e9] el favor en cualquier momento."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Plays the villager's reaction to being found hiding, sending them off to hide again on the first find and recruiting them on the second.
function villager_recruitment.finish_hide_and_seek(villager: s32, player_character: s32)
	local found_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	found_count = event.get_save_counter(11) or found_count
	if found_count < 1 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Eh! [UNI00a1]Me has encontrado!<page>[UNI00bf]Podr[UNI00e1]s tambi[UNI00e9]n la pr[UNI00f3]xima vez?"
		)
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		event.set_save_counter(11, found_count + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Vaya! [UNI00a1]Me has encontrado!<page>Me estoy hartando.<page>Esconderse es\nmuy aburrido.<page>[UNI00a1]Bueno! V[UNI00e1]monos\nde aventura."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- Has the villager challenge the player to win the Fish Race Beginners' Class before agreeing to help.
function villager_recruitment.give_fish_race_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Cuando se trata de pescar,\nvoy muy seguro.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Me han dicho que los humanos\ncelebran un concurso en el que\nse enfrentan peces entre s[UNI00ed].<page>Si tienes un pez, [UNI00bf]por qu[UNI00e9]\nno intentas ganar?<page>Si lo consigues,\nme demostrar[UNI00e1]s que eres merecedor de mi ayuda."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Parece que se refiere a la Carrera\n de Peces. [UNI00bf]Por qu[UNI00e9] no pruebas en la categor[UNI00ed]a de Principiantes\n? A lo mejor as[UNI00ed] te ayuda."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Has the villager hand Monica a Gladius and challenge her to build it up by two levels before Milane will join.
function villager_recruitment.give_gladius_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "T[UNI00fa] eres M[UNI00f3]nica,\n[UNI00bf]no?<page>Me han dicho que no\nmanejas mal la espada.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero las espadas no\nson ning[UNI00fa]n juguete.<page>Tienes que darte cuenta de lo que tienes enfrente."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Si puedes mejorar dos niveles una espada,\nadmitir[UNI00e9] que tienes aptitudes.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Empieza con este\nGladius.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.add_inventory_item(44)
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Si quieres que Milane te acepte, deber[UNI00e1]s\nmejorar el Gladius\ndos niveles.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tambi[UNI00e9]n se pueden comprar o recoger armas.\n Consigue un arma fuerte y\n Milane te ayudar[UNI00e1]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Has the villager challenge the player to catch a Nonky over 60 cm before agreeing to help.
function villager_recruitment.give_nonky_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]Quieres que te haga un favor?<page>Pues esc[UNI00fa]chame primero.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"S[UNI00f3]lo presto atenci[UNI00f3]n a la gente que respeto.<page>Y s[UNI00f3]lo respeto a la gente\nque ha pescado peces m[UNI00e1]s grandes que yo."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"El mayor pez que he cogido\nfue un Nonky de 60 cm.<page>[UNI00bf]Qu[UNI00e9], impresionado?\nSi te apetece competir conmigo,\nestar[UNI00e9] encantado."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Al parecer, la [UNI00fa]nica forma de\nconseguir que se una a ti es capturando un Nonky\n de m[UNI00e1]s de 60 cm. [UNI00a1]T[UNI00fa] puedes!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Prueba de todas formas en\nel lago de Palm Brinks.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Plays the villager's worry about a tree and hints that Gordon must be spoken to first.
function villager_recruitment.hint_talk_to_gordon(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Tendr[UNI00e1]s que hablar con\nGordon para atraer su atenci[UNI00f3]n.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Recruits the villager if the church candles are all out, otherwise turns the player away.
function villager_recruitment.join_after_candle_puzzle(villager: s32, player_character: s32)
	local visible_candle_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	visible_candle_count = object.count_visible_map_parts()
	if 0 < visible_candle_count then
		event.open_message_window_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Gives the player one of three garments depending on which they already own, then recruits the tailor villager.
function villager_recruitment.receive_garment_and_join(villager: s32, player_character: s32)
	local item_id: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Ah, Max! Ya he acabado una prenda.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"No quer[UNI00ed]a dejar\nque desecharan los materiales que me trajiste\ny gracias a eso llegu[UNI00e9] hasta el final."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "No me he quedado completamente satisfecha,\n[UNI00bf]pero te lo pondr[UNI00ed]as igualmente?")
	message.say_bubble(0, -1, villager, player_character, 0)
	item_id = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		item_id = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			item_id = 260
		end
	end
	event.add_inventory_item(item_id)
	inventory.show_obtained_message_for_item_id(item_id, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ah, qu[UNI00e9] bien sienta\nterminar algo.<page>Ahora siento mucha\nm[UNI00e1]s confianza.<page>Har[UNI00e9] todo lo que pueda.\nLlevadme con vosotros."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Starts the old woman villager's recruitment conversation by asking for the invitation phrase.
function villager_recruitment.recruit_old_woman(villager_slot: s32, player_slot: s32)
	villager_recruitment.ask_phrase_to_join(villager_slot, player_slot)
end

--- Has the tailor villager decline to join because of lost confidence and hint that she should sew again.
function villager_recruitment.refuse_for_lack_of_confidence(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Ya veo... Me gustar[UNI00ed]a\npoder ayudaros, de verdad.\nM[UNI00e1]s que nada.<page>Pero no tengo ninguna\nconfianza en m[UNI00ed] misma."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Siempre me rindo antes de tiempo\ny nunca he hecho nada hasta el final.<page>Cuando era peque[UNI00f1]a, so[UNI00f1]aba con convertirme en sastre\ne intent[UNI00e9] hacer algo muchas veces,\npero nunca termin[UNI00e9] ninguna prenda."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Si os acompa[UNI00f1]ara, estoy segura\nde que molestar[UNI00ed]a.<page>Perdonad, pero no.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vaya por Dios, Adel ha perdido\ntoda su confianza. Eso no es nada bueno. Hay\n que lograr que haga ropa otra vez."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Has the villager decline to join and ask Max for a flower photo, or defers to Monica's version of the talk.
function villager_recruitment.refuse_until_flower_photo(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Me gustar[UNI00ed]a ayudarte pero pelear\nme da miedo y, adem[UNI00e1]s, es muy sucio.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Adem[UNI00e1]s, no me gusta incordiar a nadie.\nLo siento pero no.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero tiene que haber muchas\ncosas interesantes fuera de la ciudad.<page>[UNI00c1]rboles que no hemos visto\ny flores de todas las clases."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Si ves una flor interesante, [UNI00bf]podr[UNI00ed]as\nsacarle una foto y tra[UNI00e9]rmela, Max?\nMe encantar[UNI00ed]a verla."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ha dicho que no, pero si\nle ense[UNI00f1]as una foto de algo que\nle interese puede que acepte."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the distrustful villager decline to join and hint that a photo of the moon would win their trust.
function villager_recruitment.refuse_until_moon_photo(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Bah, no me importa acompa[UNI00f1]arte,\npero... [UNI00bf]Hay luna en el lugar al que vamos?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "[UNI00bf]De verdad? A lo mejor te lo inventas.\nS[UNI00e9] que los humanos mienten.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"En realidad he cambiado de opini[UNI00f3]n.\nEsperar[UNI00e9] aqu[UNI00ed] a que salga la luna."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Quiz[UNI00e1] se deba a alg[UNI00fa]n suceso pasado,\npero Rufio no se f[UNI00ed]a\n nada de los humanos."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tienes que conseguir que Rufio\nte crea. Si le dieras una\nfoto de la luna quiz[UNI00e1] lo lograr[UNI00ed]as."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Plays the butler's request for money to bid on a rare book at auction.
function villager_recruitment.request_book_auction_funds(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Si necesitas algo,\nhar[UNI00e9] lo que pueda para ayudarte.<page>T[UNI00fa] d[UNI00e9]jame a m[UNI00ed]."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "No s[UNI00e9] si podr[UNI00e1]s solucionar algo,<page>pero escucha.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Me he tirado 30 a[UNI00f1]os trabajando\ncomo un mulo en esta casa.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Es todo lo que hago, pero\nmi afici[UNI00f3]n es la lectura.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "En estos momentos est[UNI00e1]n subastando\nun libro muy valioso.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "La gente se pega por [UNI00e9]l.\nCreo que con una oferta\nde 1000 Gildas bastar[UNI00ed]a.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Yo no dispongo de ese dinero y, si se\nlo pidiera a mi maestro, se escandalizar[UNI00ed]a y\nseguramente me echar[UNI00ed]a."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Eres mi [UNI00fa]nica esperanza.<page>Pero no quiere decir\nque si no me ayudas yo no vaya a echarte una mano."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A pesar de lo que diga, Stewart seguramente\n no te ayudar[UNI00e1] si no le consigues 1000 Gildas.\n En fin, ser[UNI00e1] mejor que empieces a ahorrar."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Plays the magical artist Parn's introduction and his request for Golden Paint, with a shorter version for Monica.
function villager_recruitment.request_golden_paint(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(villager, 0, 0)
		event.open_message_window_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, villager, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]A M[UNI00f3]nica no se le dan muy bien\nestas situaciones. Podr[UNI00ed]a lograr algo,\npero es probable que no lo haga. Prueba m[UNI00e1]s tarde con Max."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Hola, Max.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, villager, 0)
	event.open_message_window_2(
		0,
		"Puedes re[UNI00ed]rte lo que quieras.\nYa s[UNI00e9] que es raro.<page>[UNI00bf]Qui[UNI00e9]n se enamorar[UNI00ed]a de\nun retrato?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero soy un artista m[UNI00e1]gico.\nTengo el poder de convertir en realidad las cosas que pinto.<page>Todo lo que pinto existe en el cuadro verdaderamente.\nA menos que se trate de un ser vivo..."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ni siquiera un artista m[UNI00e1]gico puede pintar vida.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aunque he o[UNI00ed]do que existe una forma.\nHay un Huevo dorado en un [UNI00e1]rbol grande y viejo."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Se cuenta que con el color dorado\nse puede dar vida a cualquier cosa que pintes.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, tengo entendido que\nte marchas de la ciudad, [UNI00bf]no?<page>[UNI00bf]Podr[UNI00ed]as traerme algo de Pintura dorada?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Por supuesto que no espero que lo hagas a cambio de nada.<page>Si me ayudas, usar[UNI00e9]\nmi nuevo poder para devolverte el favor."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un [UNI00e1]rbol grande y viejo...\n [UNI00a1]Con un Huevo dorado! [UNI00bf]Y d[UNI00f3]nde se supone\nque hay algo as[UNI00ed]?"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Routes a triggered NPC talk to the villager conversation for NPC ids up to 34 and to the generic handler otherwise.
function villager_recruitment.route_npc_talk()
	local npc_id: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if npc_id <= 34 then
			resume_point = 1
			palm_brinks_talk.talk_to_villager(villager, player_character)
		else
			resume_point = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 11, with a separate talk for Monica.
function villager_recruitment.route_request_11_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_dialogue.talk_villager_16_as_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_mining(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		palm_brinks_quests.offer_bell_trigger_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.check_owned_weapon(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_weapon_caution(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 15.
function villager_recruitment.route_request_15_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_fishing_hobby(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		villager_recruitment.give_nonky_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.judge_nonky_catch(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_angler_done(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 2.
function villager_recruitment.route_request_2_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_shop_closed(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_coin_collector(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 4.
function villager_recruitment.route_request_4_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_until_flower_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_flower_photos(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 6, with a separate talk for Monica.
function villager_recruitment.route_request_6_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.compare_player_to_elena(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.offer_help_with_problems(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		villager_recruitment.request_book_auction_funds(villager, player_character)
		return
	end
	if quest_status == 1 then
		villager_recruitment.collect_auction_funds(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_book_servant_done(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 7 and the garment progress counter, with a separate talk for Monica.
function villager_recruitment.route_request_7_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local garment_stage: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_worried_villager(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 7) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_for_lack_of_confidence(villager, player_character)
		return
	end
	if quest_status == 1 then
		garment_stage = event.get_save_counter(8) or garment_stage
		if garment_stage == 0 then
			quest_dialogue.request_tailor_materials(villager, player_character)
		end
		if garment_stage == 1 then
			npc_dialogue.deliver_tailoring_materials(villager, player_character)
		end
		if garment_stage == 2 then
			villager_recruitment.receive_garment_and_join(villager, player_character)
		end
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_clothes(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 9, once the villager stands at their post, with a separate talk for Monica.
function villager_recruitment.route_request_9_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_dialogue.talk_about_armed_women(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_town_too_peaceful(villager, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(villager)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_dialogue.chat_busy_with_materials(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 9) or quest_status
	if quest_status == 0 then
		npc_dialogue.explain_boat_run_test(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_boat_race_time(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_agile_admirer(villager, player_character)
		return
	end
end

return villager_recruitment
