--!strict
--- Spanish villager conversations triggered from the town and dungeon scripts.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/spanish/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_dialogue = {}

--- Plays Corinne's request to join the player, her hide-and-seek challenge and her disappearance.
function villager_dialogue.start_corinne_hide_and_seek(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.open_message_window_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Seguro que piensas que\nno valdr[UNI00e9] para nada porque soy una chica.<page>Pues la verdad es que\ntraigo suerte a la gente."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Nunca llueve cuando salgo\ny nunca he visto ning[UNI00fa]n\nbillete de loter[UNI00ed]a perdedor.<page>[UNI00bf]Qu[UNI00e9] me dices?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Est[UNI00e1] bien.\nNo, lo siento.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "[UNI00a1][UNI00bf]Por qu[UNI00e9]?! No seas as[UNI00ed].\nEres muy mala.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "[UNI00a1]Eres una in[UNI00fa]til!<page>[UNI00a1]Est[UNI00fa]pida!<page>[UNI00a1]Idiota!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00bf]Me vas a llevar contigo?<page>[UNI00a1]Cre[UNI00ed]a que no lo har[UNI00ed]as!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] soy yo la [UNI00fa]nica\nque tiene que ped[UNI00ed]rtelo, cuando t[UNI00fa] has ido\npor ah[UNI00ed] preguntando a los dem[UNI00e1]s?<page>Si me lo hubieras pedido, te\nhabr[UNI00ed]a ayudado."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ya lo s[UNI00e9]: si me encuentras,\nte ayudar[UNI00e9]. [UNI00bf]Qu[UNI00e9] te parece?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "En otras palabras: [UNI00a1]vamos a jugar al escondite!<page>[UNI00a1]Venga, vamos!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, villager)
	event.set_character_active(0, villager)
	event.delete_villager(villager)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vaya... Ser[UNI00e1] mejor que te pongas\na buscar a Corinne. Seguramente estar[UNI00e1] escondida\nen alg[UNI00fa]n lugar de Palm Brinks."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Plays Gordon's explanation of his tree problem, his quest and the notebook that tracks it.
function villager_dialogue.start_gordon_quest(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local notebook_count: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.hint_talk_to_gordon(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00a1]Max! Has estado limpiando mucho\n[UNI00fa]ltimamente. [UNI00bf]Seguro que cuidas\nde ti?<page>[UNI00bf]Puedo hacer algo por ti?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e\nen tu aventura?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Umm... Me gustar[UNI00ed]a ir contigo,\npero este [UNI00e1]rbol necesita\natenci[UNI00f3]n.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ver[UNI00e1]s, mi prioridad consiste en cuidar las\nplantas y los [UNI00e1]rboles de este\nterreno.<page>Si me voy a dar vueltas por ah[UNI00ed], podr[UNI00ed]a\nperder el trabajo."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Seguro que este [UNI00e1]rbol se repondr[UNI00ed]a con un poco del Agua bendita que el Padre Bruno\nvende en la iglesia.<page>Pero ya sabes que tu padre\ny el cura no se llevan bien...<page>Tu padre no me dar[UNI00ed]a ni loco dinero\npara comparle Agua bendita al cura.<page>[UNI00a1]Vaya berenjenal!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Para que Gordon vaya a Sindain, primero debes\nconseguir que se apunte a\ntu viaje.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Si ayudas a Gordon,\nse apuntar[UNI00e1] al viaje y\nsubir[UNI00e1] al tren.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Puedes consultar tus misiones\nleyendo la Libreta\nque hay en el men[UNI00fa] Objetos.")
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)][UNI00a1]Pero si no tienes Libreta!\nHay una sobre la mesa\ndel Taller de Mantenimiento."
		)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Hay otra en el escondrijo\nde Donny. Cualquiera valdr[UNI00e1].\n [UNI00a1]Pero coge una r[UNI00e1]pido!"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Speaks a villager's opinion on women wielding swords, with different lines in chapter 8.
function villager_dialogue.talk_about_armed_women(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"No quiero ver a ninguna mujer\nempu[UNI00f1]ando una espada por ah[UNI00ed].<page>Las mejores mujeres son las\nfinas. F[UNI00ed]jate en Adel, por ejemplo."
		)
	else
		event.open_message_window_2(0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's lines about trust in business.
function villager_dialogue.talk_about_business_trust(villager: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Lo m[UNI00e1]s importante en los negocios\nes contar con la confianza de los clientes.<page>Es algo que nunca\nse puede descuidar."
	)
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's lines about Fabio, with different lines in chapter 8.
function villager_dialogue.talk_about_fabio(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Un d[UNI00ed]a espero poder\nsubirme al podio yo tambi[UNI00e9]n.")
	else
		event.open_message_window_2(0, "Me gustar[UNI00ed]a que Fabio se interesase\npor algo m[UNI00e1]s aparte\nde la pesca.")
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Chooses the villager's conversation from the progress of quest request 10, using a default talk until quest request 0 is complete, with a separate talk while Monica is playable.
function villager_dialogue.talk_quest_10_villager(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		palm_brinks_villagers.talk_circus_performer(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_blade_shop(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_sword_upgrade(villager, player_character)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_sword_for_recruit(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_swordsmith_done(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 12, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_12_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_muttering_numbers(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_safe_combination(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_safe_code_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_mayor_done(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 19, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_19_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_chatter.talk_grandmother_hard_of_hearing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		npc_dialogue.recruit_hard_of_hearing_woman(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_grandmother(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_grandmother_done(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 4, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_4_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_flower_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_flower_photo_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(villager, player_character)
		return
	end
end

--- Starts the conversation of the villager that triggered the event.
function villager_dialogue.talk_to_triggered_villager()
	local villager_type: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		villager_type = event.get_triggered_event_data_2(14) or villager_type
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if villager_type <= 34 then
			step = 1
			palm_brinks_villagers.talk_to_npc(villager, player_character)
		else
			step = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Speaks the villager of type 16's lines when Monica is the playable character, with different lines in chapter 8.
function villager_dialogue.talk_villager_16_as_monica(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "[UNI00bf]Eres amiga de Max?<page>Bueno, ten cuidado.")
	else
		event.open_message_window_2(
			0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

return villager_dialogue
