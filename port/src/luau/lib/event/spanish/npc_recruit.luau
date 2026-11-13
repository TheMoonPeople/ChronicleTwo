--!strict
--- Holds the Spanish dialogue of the villager recruitment events and request conversations.

local vm = require("@lib/vm")
local baker = vm.module("@lib/event/spanish/baker")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/spanish/palm_brinks_quests")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/spanish/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/spanish/villager_recruitment")
local wait = vm.module("@lib/event/wait")

local npc_recruit = {}

--- Has the girl ask to join the party and, when the player agrees, starts a hide-and-seek by removing her from town.
function npc_recruit.challenge_hide_and_seek(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.open_message_window_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Seguro que piensas que\nno valdr[UNI00e9] para nada porque soy una chica.<page>Pues la verdad es que\ntraigo suerte a la gente."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Nunca llueve cuando salgo\ny nunca he visto ning[UNI00fa]n\nbillete de loter[UNI00ed]a perdedor.<page>[UNI00bf]Qu[UNI00e9] me dices?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Est[UNI00e1] bien.\nNo, lo siento.")
	choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "[UNI00a1][UNI00bf]Por qu[UNI00e9]?! No seas as[UNI00ed].\nEres muy mala.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00a1]Eres una in[UNI00fa]til!<page>[UNI00a1]Est[UNI00fa]pida!<page>[UNI00a1]Idiota!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00bf]Me vas a llevar contigo?<page>[UNI00a1]Cre[UNI00ed]a que no lo har[UNI00ed]as!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] soy yo la [UNI00fa]nica\nque tiene que ped[UNI00ed]rtelo, cuando t[UNI00fa] has ido\npor ah[UNI00ed] preguntando a los dem[UNI00e1]s?<page>Si me lo hubieras pedido, te\nhabr[UNI00ed]a ayudado."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ya lo s[UNI00e9]: si me encuentras,\nte ayudar[UNI00e9]. [UNI00bf]Qu[UNI00e9] te parece?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "En otras palabras: [UNI00a1]vamos a jugar al escondite!<page>[UNI00a1]Venga, vamos!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vaya... Ser[UNI00e1] mejor que te pongas\na buscar a Corinne. Seguramente estar[UNI00e1] escondida\nen alg[UNI00fa]n lugar de Palm Brinks."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Recruits the character when the player holds the required weapon item, otherwise scolds the player for giving up.
function npc_recruit.check_owned_weapon(npc_character: s32, player_character: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] pasa?\n[UNI00bf]Te rindes otra vez?<page>Me decepcionas.\n[UNI00bf]Es eso todo lo que sabes\nhacer despu[UNI00e9]s de pasarte toda la vida entre m[UNI00e1]quinas?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Vaya! Parece que te\nhas acostumbrado a manejar armas.<page>No me hace falta ni verte disparar.\nBasta con ver c[UNI00f3]mo la coges."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Vale, te ayudar[UNI00e9].\nPero no lo hago por ti.<page>No me puedo\nquedar aqu[UNI00ed] parado si\nla ciudad est[UNI00e1] en peligro."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Plays the mayor muttering about the forgotten safe combination, admitting the problem and starting the safe request.
function npc_recruit.explain_safe_problem(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player_character, npc_character)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir con\neso de que qu[UNI00e9] estoy murmullando?<page>Estoy intentando\nrecordar la combinaci[UNI00f3]n de la caja fuerte."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir?\n[UNI00bf]Qu[UNI00e9] caja?<page>La caja fuerte escondida\ndetr[UNI00e1]s del cuadro de mi despacho, claro..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	character.face_toward(npc_character, player_character)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"[UNI00a1]Ah, qu[UNI00e9] susto!<page>[UNI00a1]Porras!<page>Me he ido y he desvelado\nmi mayor secreto.<page>Bueno, ya lo sabes.<page>A lo mejor me puedes\nechar una mano."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Tengo muchos problemas\nporque he olvidado\nla combinaci[UNI00f3]n de la caja fuerte.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Es un n[UNI00fa]mero de\n4 d[UNI00ed]gitos. Us[UNI00e9]\nla fecha de nacimiento de Claire\npara no olvidarme nunca."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo lo habr[UNI00e9] olvidado?<page>Vaya padre soy...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]El alcalde parece muy preocupado.\n Escucha lo que te dice sobre\nel cumplea[UNI00f1]os de Claire y trata de descifrar la combinaci[UNI00f3]n."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Judges the length of the player's recorded Nonky catch and recruits the character once it reaches 60 centimeters.
function npc_recruit.judge_nonky_catch(npc_character: s32, player_character: s32)
	local catch_length_meters: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	catch_length_meters = vm.bits_float(event.get_menu_value(2, 322)) or catch_length_meters
	if catch_length_meters <= 0 then
		event.open_message_window_2(
			0,
			"Apostar[UNI00ed]a a que nunca has\npescado un Nonky, [UNI00bf]eh?<page>Ja, ja. [UNI00a1]Tienes que ser p[UNI00e9]simo pescando!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "[UNI00a1]Ja, ja! S[UNI00f3]lo has cogido\nun pezque[UNI00f1][UNI00ed]n de [数値１] cm.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"[UNI00a1]No me llegas ni a la altura del bet[UNI00fa]n!<page>Te recomiendo que empieces de nuevo."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "... Vaya, te he subestimado.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"En fin, soy un hombre de palabra.\nNo tienes que record[UNI00e1]rmelo.<page>Escuchar[UNI00e9] lo que tengas que decirme."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00a1]Habla cuanto quieras!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Judges whether the player's fish race was won and recruits the character when it was.
function npc_recruit.judge_race_result(npc_character: s32, player_character: s32)
	local race_won: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	race_won = event.get_save_flag(41) or race_won
	if race_won == 0 then
		event.open_message_window_2(0, "Se dice que los peces se parecen a sus amos.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "No le voy a dirigir la palabra al\ndue[UNI00f1]o de una birria de pez.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"La he visto.\nHa sido una carrera muy emocionante.<page>No creo que yo hubiera\npodido criar un pez tan bueno.<page>Ll[UNI00e9]vame contigo, por favor.\nEns[UNI00e9][UNI00f1]ame c[UNI00f3]mo lo haces."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Recruits the character once the current counter has grown by 10 since the request started, otherwise has him complain of feeling unwell.
function npc_recruit.judge_recovery_progress(npc_character: s32, player_character: s32)
	local current_counter: s32 = 0
	local start_counter: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		resume_point = 1
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		current_counter = event.get_menu_value_2(0) or current_counter
		start_counter = event.get_save_counter(19) or start_counter
		print("start=", start_counter, ",now=", current_counter, ",clear=", vm.i32(current_counter - start_counter), "\n")
		if vm.i32(current_counter - start_counter) < 10 then
			event.open_message_window_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
			resume_point = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
			)
			resume_point = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
		resume_point = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
		)
		resume_point = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
		)
		resume_point = 6
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		resume_point = 7
		i04_girard_house.recruit_triggered_villager()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				print("start=", start_counter, ",now=", current_counter, ",clear=", current_counter - start_counter, "\n")
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 2 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			return 0
		end
		if resume_point <= 7 then
			if resume_point <= 4 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 5 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Replays the mayor's birthday hints until the player enters the safe combination, then stages the safe opening or failing and recruits the mayor on success.
function npc_recruit.open_mayor_safe(npc_character: s32, player_character: s32)
	local listen_choice: any = 0
	local entry_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local saved_npc_x: f32 = 0
	local saved_npc_y: f32 = 0
	local saved_npc_z: f32 = 0
	local saved_npc_rotation_x: f32 = 0
	local saved_npc_rotation_y: f32 = 0
	local saved_npc_rotation_z: f32 = 0
	local saved_player_x: f32 = 0
	local saved_player_y: f32 = 0
	local saved_player_z: f32 = 0
	local saved_player_rotation_x: f32 = 0
	local saved_player_rotation_y: f32 = 0
	local saved_player_rotation_z: f32 = 0
	local angle_to_npc: f32 = 0
	local saved_camera_x: f32 = 0
	local saved_camera_y: f32 = 0
	local saved_camera_z: f32 = 0
	local saved_look_at_x: f32 = 0
	local saved_look_at_y: f32 = 0
	local saved_look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	while true do
		event.open_message_window_2(0, "Hace mucho le di un broche\ncon su signo del zodiaco.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Holly se encarg[UNI00f3] de todo,\nas[UNI00ed] que no me acuerdo exactamente,\npero estoy seguro de que era un animal de 4 patas..."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"[UNI00bf]Que qu[UNI00e9] clase de\nregalos de cumplea[UNI00f1]os le he hecho?<page>Umm... Muchos abrigos\ny pa[UNI00f1]uelos, supongo.<page>Nunca s[UNI00e9] qu[UNI00e9] comprarle.\nTodos los a[UNI00f1]os es la misma historia."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"[UNI00a1]Y tanto! El cumplea[UNI00f1]os de Claire siempre es un sufrimiento.\nCae siempre en el d[UNI00ed]a que recogen la basura\nque se puede quemar y la que no.<page>A m[UNI00ed] me toca sacar\nla basura de casa."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"La basura que no se puede quemar\nse recoge los d[UNI00ed]as divisibles por 7<page>y la que s[UNI00ed] se puede quemar\nlos divisibles por tres."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00bf]A que t[UNI00fa] tampoco te olvidar[UNI00ed]as\nde eso, eh?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"[UNI00a1]Ya est[UNI00e1]! [UNI00a1]Misterio resuelto!\nLa combinaci[UNI00f3]n es... <page>No s[UNI00e9]... Vamos a escuchar un poco m[UNI00e1]s."
		)
		listen_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if listen_choice == 0 then
			break
		else
			if listen_choice == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_character, "会話")
		end
	end
	event.set_menu_value(0, "Introduce el c[UNI00f3]digo secreto.", "1221", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_character)
		saved_npc_x = out1 or saved_npc_x
		saved_npc_y = out2 or saved_npc_y
		saved_npc_z = out3 or saved_npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_character)
		saved_npc_rotation_x = out1 or saved_npc_rotation_x
		saved_npc_rotation_y = out2 or saved_npc_rotation_y
		saved_npc_rotation_z = out3 or saved_npc_rotation_z
	end
	event.set_character_position(npc_character, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_character, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_character, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		saved_player_x = out1 or saved_player_x
		saved_player_y = out2 or saved_player_y
		saved_player_z = out3 or saved_player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		saved_player_rotation_x = out1 or saved_player_rotation_x
		saved_player_rotation_y = out2 or saved_player_rotation_y
		saved_player_rotation_z = out3 or saved_player_rotation_z
	end
	angle_to_npc = event.get_arc_tangent(-100.0 - saved_player_x, -110.0 - saved_player_z) or angle_to_npc
	event.set_character_rotation(0, 0.0, angle_to_npc, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		saved_camera_x = out1 or saved_camera_x
		saved_camera_y = out2 or saved_camera_y
		saved_camera_z = out3 or saved_camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		saved_look_at_x = out1 or saved_look_at_x
		saved_look_at_y = out2 or saved_look_at_y
		saved_look_at_z = out3 or saved_look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if entry_result == 0 then
		event.set_character_motion(npc_character, "会話")
		event.open_message_window_2(0, "Vaya, no se abre. Cachis la mar... <page>Dentro tengo documentos\nmuy importantes...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
		event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
		event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
		event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
		event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Esto... Um...\n1,<page>2,<page>2,<page>1...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "[UNI00a1]Yujuuuu!<page>Bien,\n[UNI00a1]ha funcionado!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, saved_player_x, saved_player_y, saved_player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"[UNI00a1]Genial! Ahora podr[UNI00e9]\nsacar los documentos que necesito.<page>[UNI00a1]Muchas gracias!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
	event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
	event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
	event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
	event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] documentos?<page>Unos que ayudar[UNI00e1]n al Teniente Alcalde Morton\na sustituirme mientras estoy fuera.<page>Me preocupa un poco,\npero no creo que pase nada."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ahora ya estoy listo para marcharme.<page>Cedric me lo ha contado todo.<page>Venga, vamos.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Asks the player to hand over Chestnuts and recruits the cook.
function npc_recruit.receive_chestnuts(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]Has conseguido alguna Casta[UNI00f1]a?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(0, "No puedes...<page>En fin, tendr[UNI00e9] que dejar\nel Castagnaccio.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Muy bien. Muchas gracias.<page>Intentar[UNI00e9] preparar algo de Castagnaccio.<page>Te lo dar[UNI00e9] a probar en cuanto termine."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Puedo devolverte el favor de alguna manera?<page>[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e en tu aventura?<page>[UNI00a1]Ja, ja! Eso est[UNI00e1] hecho.<page>[UNI00bf]Por qu[UNI00e9] no me has preguntado antes?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Asks the player to hand over the Golden Paint, brings the painting to life and recruits the magical artist.
function npc_recruit.receive_golden_paint(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.set_npc_party_status(22, 130)
	i04_girard_house.show_join_announcement(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Has the baker ask the player to deliver 20 loaves of bread to the shop and hands the player the loaves.
function npc_recruit.request_bread_delivery(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Quieres que\nte acompa[UNI00f1]e?<page>S[UNI00f3]lo soy una mujer que hace Pan,\npero si crees que puedo ser [UNI00fa]til,\nir[UNI00e9] encantada."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ah, pero antes tengo\nque hacer un env[UNI00ed]o a Morton.<page>[UNI00bf]Te importar[UNI00ed]a llevarle 20 barras\nde Pan a Morton a su tienda?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mientras vas y vienes,\nhar[UNI00e9] las maletas.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] querr[UNI00e1] hacer\ncon 20 barras?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Has Gordon explain his sick tree and how to recruit him and starts his request, deferring to a hint talk for the second playable character.
function npc_recruit.start_gordon_request(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local notebook_count: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00a1]Max! Has estado limpiando mucho\n[UNI00fa]ltimamente. [UNI00bf]Seguro que cuidas\nde ti?<page>[UNI00bf]Puedo hacer algo por ti?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e\nen tu aventura?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Umm... Me gustar[UNI00ed]a ir contigo,\npero este [UNI00e1]rbol necesita\natenci[UNI00f3]n.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ver[UNI00e1]s, mi prioridad consiste en cuidar las\nplantas y los [UNI00e1]rboles de este\nterreno.<page>Si me voy a dar vueltas por ah[UNI00ed], podr[UNI00ed]a\nperder el trabajo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Seguro que este [UNI00e1]rbol se repondr[UNI00ed]a con un poco del Agua bendita que el Padre Bruno\nvende en la iglesia.<page>Pero ya sabes que tu padre\ny el cura no se llevan bien...<page>Tu padre no me dar[UNI00ed]a ni loco dinero\npara comparle Agua bendita al cura.<page>[UNI00a1]Vaya berenjenal!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Para que Gordon vaya a Sindain, primero debes\nconseguir que se apunte a\ntu viaje.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Si ayudas a Gordon,\nse apuntar[UNI00e1] al viaje y\nsubir[UNI00e1] al tren.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Puedes consultar tus misiones\nleyendo la Libreta\nque hay en el men[UNI00fa] Objetos.")
	message.show_and_wait(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)][UNI00a1]Pero si no tienes Libreta!\nHay una sobre la mesa\ndel Taller de Mantenimiento."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Hay otra en el escondrijo\nde Donny. Cualquiera valdr[UNI00e1].\n [UNI00a1]Pero coge una r[UNI00e1]pido!"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Starts the conversation with the baker matching the status of her bread request, with a separate talk for the second playable character and the default talk until the first request is finished.
function npc_recruit.talk_baker(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		baker.chat_about_max(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		villager_dialogue.talk_about_business_trust(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 8) or request_status
	if request_status == 0 then
		npc_recruit.request_bread_delivery(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_polly(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_baker_done(npc_character, player_character)
		return
	end
end

--- Starts Gordon's conversation matching his state flag and the status of his request.
function npc_recruit.talk_gordon(npc_character: s32, player_character: s32)
	local state_flag: s32 = 0
	local request_status: s32 = 0
	state_flag = event.get_save_flag(42) or state_flag
	if state_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status == 0 then
		npc_recruit.start_gordon_request(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_gordon(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the moon photo villager matching the status of his request, or the default talk until the first request is finished.
function npc_recruit.talk_moon_photo_villager(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_moon_longing(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 14) or request_status
	if request_status == 0 then
		villager_recruitment.refuse_until_moon_photo(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_rufio_with_moon_photo(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_moon_photo_thanks(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the priest matching the status of his candle puzzle request, or the default talk until the first request is finished.
function npc_recruit.talk_priest(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(npc_character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		palm_brinks_quests.explain_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 1 then
		villager_recruitment.join_after_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(npc_character, player_character)
		return
	end
end

return npc_recruit
