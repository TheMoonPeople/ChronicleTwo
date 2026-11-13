--!strict
--- Holds the Spanish conversations of the villagers of Starlight Temple.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local starlight_temple_villagers = {}

--- Plays the conversation of the Starlight Temple villager that was talked to, choosing the line by villager type and story flags.
function starlight_temple_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local miracle_dish_flag: s32 = 0
	local dumpling_helped_flag: s32 = 0
	local crest_returned_flag: s32 = 0
	local rescued_flag: s32 = 0
	local final_battle_flag: s32 = 0
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
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	closing_mode = 0
	miracle_dish_flag = event.get_save_flag(324) or miracle_dish_flag
	dumpling_helped_flag = event.get_save_flag(330) or dumpling_helped_flag
	crest_returned_flag = event.get_save_flag(372) or crest_returned_flag
	rescued_flag = event.get_save_flag(400) or rescued_flag
	final_battle_flag = event.get_save_flag(640) or final_battle_flag
	if villager_type == 200 then
		if final_battle_flag == 0 then
			if dumpling_helped_flag == 0 then
				if miracle_dish_flag == 0 then
					event.open_message_window_2(
						0,
						"Para preparar un Plato milagroso necesito\nuna Flor del viento, pero no\nme quedan. Lo siento, no puedo hacer nada."
					)
				else
					event.open_message_window_2(
						0,
						"[UNI00bf]Has probado ya la\nEmpanadilla milagro? Se desvirt[UNI00fa]a\nal enfriarse, as[UNI00ed] que c[UNI00f3]metela r[UNI00e1]pido."
					)
				end
			else
				event.open_message_window_2(
					0,
					"As[UNI00ed] que te ha venido bien la Empanadilla milagro, [UNI00bf]eh?\nMe alegro de saberlo. Oye, [UNI00bf]quieres comer\nalgo antes de marcharte?"
				)
			end
		else
			event.open_message_window_2(0, "[UNI00a1]Ah[UNI00ed] va! Ya es casi la hora.\nBueno, pues entonces nada.")
		end
	end
	if villager_type == 201 then
		event.open_message_window_2(
			0,
			"Cada objeto tiene\nsus propiedades. Algunos te ayudan, otros\ncambian para formar armas...<page>Si experimentas con ellos, podr[UNI00e1]s\nvencer al peor\nenemigo. Pru[UNI00e9]balo todo."
		)
	end
	if villager_type == 202 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"No me puedo creer que\nel diab[UNI00f3]lico Emperador Griffon destruyera\neste templo...<page>Si el Gran Sabio Crest\nestuviera aqu[UNI00ed]..."
			)
		else
			event.open_message_window_2(
				0,
				"Ahora que el Gran Sabio est[UNI00e1]\notra vez con nosotros, no hay nada\nque temer. Ve y enfr[UNI00e9]ntate a Griffon."
			)
		end
	end
	if villager_type == 203 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"El templo est[UNI00e1] en una\nnoche perpetua porque el poder del\nCristal lunar es mayor por la noche.<page>Utiliza la fuerza del templo\npara crear una zona nocturna."
			)
		else
			event.open_message_window_2(
				0,
				"Que Crest el Grande use el poder\nde este Cristal lunar para ver\ntodas las cosas de este mundo.<page>No hay forma de ocultarse\na los ubicuos ojos de Crest."
			)
		end
	end
	if villager_type == 204 then
		event.open_message_window_2(
			0,
			"Hola. Hay un gran surtido para\nti. Nuestras armas tienen fama\nde ser fuertes y resistentes."
		)
	end
	if villager_type == 205 then
		if final_battle_flag == 0 then
			if rescued_flag == 0 then
				event.open_message_window_2(
					0,
					"[UNI00a1]Eh! D[UNI00e9]jate de perder el tiempo\ny ens[UNI00e9][UNI00f1]ale\na Griffon qui[UNI00e9]n manda.\nR[UNI00e1]pido."
				)
			else
				event.open_message_window_2(
					0,
					"Bueno, aqu[UNI00ed] se acaba mi\nparte. Ahora te toca a ti. Enc[UNI00e1]rgate\nde Griffon, [UNI00bf]vale?<page>Me has salvado. S[UNI00e9] que si alguien\npuede hacer esto, sois vosotros."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Parece que se acerca\nel final del viaje. Acaba con Griffon\npor el Maestro y por todos nosotros.<page>Tienes que vencerlo a toda costa.\nCuando caiga Griffon... Crest y\nyo... seremos verdaderos Sabios."
			)
		end
	end
	if villager_type == 206 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Aunque el templo haya recuperado\nla normalidad, sin Crest\nes in[UNI00fa]til.<page>S[UNI00f3]lo [UNI00e9]l posee el enorme poder\nastrol[UNI00f3]gico para\nescrutar el mundo entero."
			)
		else
			event.open_message_window_2(
				0,
				"Hasta el propio Crest fue una vez\naprendiz de un sabio. Tuvo que\nser un maestro fabuloso..."
			)
		end
	end
	if villager_type == 207 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Aqu[UNI00ed] la comida es de primera.\nSe me hace la boca agua s[UNI00f3]lo de pensar en ella."
			)
		else
			event.open_message_window_2(0, "[UNI00a1]Ha preparado el Plato milagroso!\nLao Chao es un chef de los que no hay.")
		end
	end
	if villager_type == 208 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(
				0,
				"Cuando hayas cenado aqu[UNI00ed],\nnada te sabr[UNI00e1] igual\nde bien. La comida que ponen es incre[UNI00ed]ble."
			)
		else
			event.open_message_window_2(0, "[UNI00a1]Guau! Me muero\npor probar las\nEmpanadillas milagro.")
		end
	end
	if villager_type == 209 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Te parece raro\nel Reloj de estrellas?<page>[UNI00a1]A qui[UNI00e9]n se lo dices! Yo tengo uno\n, pero no me acuerdo nunca de [UNI00e9]l...\nNunca he viajado al pasado."
			)
		else
			event.open_message_window_2(
				0,
				"Es estupendo que fuerais\namigos de Crest, el Gran Sabio.<page>Aunque no sab[UNI00ed]a\nque fuerais tan [UNI00ed]ntimos..."
			)
		end
	end
	if villager_type == 210 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"El Gran Sabio Crest no est[UNI00e1].\n[UNI00bf]D[UNI00f3]nde se habr[UNI00e1] metido...?<page>Sin [UNI00e9]l se nos cae el alma\na los pies."
			)
		else
			event.open_message_window_2(
				0,
				"El Gran Crest me dijo una vez:\nEn el pasado, un hombre llamado Gaspar\ntrat[UNI00f3] de destruir este Cristal lunar.<page>Y el gran maestro de Crest\narriesg[UNI00f3] la vida para protegerlo..."
			)
		end
	end
	if villager_type == 211 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00bf]O sea que el Gran Crest ha desaparecido\ncon el Cristal lunar\npara protegerlo?<page>No entiendo nada..."
			)
		else
			event.open_message_window_2(
				0,
				"Has visto el enorme poder\nque atesora el Cristal lunar, [UNI00bf]no? Pero\ns[UNI00f3]lo hay una persona que pueda usarlo...<page>Crest, el Gran Sabio...<page>La gente corriente como nosotros\nno puede hacer nada\nparecido."
			)
		end
	end
	if villager_type == 212 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Ser[UNI00e9]is acaso vosotros...? El Gran Sabio\nCrest me dijo una vez que un d[UNI00ed]a\nvendr[UNI00ed]an un chico y una chica...<page>[UNI00a1]Sab[UNI00ed]a que la profec[UNI00ed]a se cumplir[UNI00ed]a!<page>Pero por desgracia el Gran Sabio\ntambi[UNI00e9]n ha desaparecido."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]Hace 10.000 a[UNI00f1]os?<page>[UNI00bf]Quieres decir que el Laboratorio Lunar puede\nrealizar una proeza\nfuera del alcance del propio Gran Crest?"
			)
		end
	end
	if villager_type == 213 then
		event.open_message_window_2(
			0,
			"La luna ejerce un poder de\nextra[UNI00f1]os efectos\nsobre todos los seres vivos.<page>El Cristal lunar\nencierra ese poder."
		)
	end
	if villager_type == 214 then
		if dumpling_helped_flag == 0 then
			event.open_message_window_2(
				0,
				"Si buscas la mejor\ncomida del mundo, deber[UNI00ed]as pasarte\npor el restaurante Lao Chao.<page>Lo conoces, [UNI00bf]no?"
			)
		else
			event.open_message_window_2(
				0,
				"As[UNI00ed] que sois vosotros. El Gran Crest\nme habl[UNI00f3] de vosotros y de c[UNI00f3]mo\nle salvasteis la vida hace mucho tiempo.<page>Nunca hubiera pensado\nque fuerais unos ni[UNI00f1]os..."
			)
		end
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
	if villager_type == 201 then
		menu.open_type_6_alt(5)
	end
	if villager_type == 204 then
		menu.open_type_6_alt(27)
	end
end

return starlight_temple_villagers
