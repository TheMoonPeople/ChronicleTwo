--!strict
--- Holds the Spanish conversations of the villagers living in the player's town.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local partner_talk = vm.module("@lib/event/spanish/partner_talk")

local town_villagers = {}

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
function town_villagers.say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	local villager_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"Ahora vivo aqu[UNI00ed],\npero estoy preocupado\npor el Blackstone I.<page>Me encargar[UNI00e9] de\nque el tren siga rodando,\ncomo antes."
				)
				villager_id = event.get_triggered_event_data_2(13) or villager_id
				cutscene.talk(villager_id, -1, 0, 0)
				event.open_message_window_2(
					window,
					"Borneo es un poco bruto,\ny Erik es un ni[UNI00f1]o.<page>Para la gente como yo, la vida\nconsiste en trabajar, dormir y volver a trabajar.<page>Pero as[UNI00ed] es la vida..."
				)
			else
				event.open_message_window_2(window, "[UNI00bf]Qu[UNI00e9] tal va Steve?")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "No puedo soportar quedarme en\nla habitaci[UNI00f3]n mirando las musara[UNI00f1]as.")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"Las plantas y las flores crecen\ndependiendo del cuidado que se les dedique. Yo\nno podr[UNI00ed]a descuidar a mis chiquitines."
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"Me gustar[UNI00ed]a saber si la base secreta est[UNI00e1] a salvo.\nYo le preguntar[UNI00ed]a a alguien\npara averiguarlo, pero es un secreto, y claro..."
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"El morado es un buen color.\nEs de un fr[UNI00ed]o templado\ny de una oscuridad luminosa."
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "Si alguien se pusiera enfermo\n, ir[UNI00ed]a a ayudarle a cualquier parte.")
		end
		if villager_type == 7 then
			event.open_message_window_2(window, "Para hacer platos deliciosos\nen cualquier parte hay que ser un gran cocinero.")
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "Trat[UNI00e1]ndose de casas, cuanto m[UNI00e1]s robustas\nmejor, [UNI00bf]no?")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"Me encantan los frutos secos, pero esos\nrojos est[UNI00e1]n para chuparse los dedos.\n[UNI00bf]Puedes traerme m[UNI00e1]s?"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"La humedad ambiental es el peor enemigo de los libros.\nCreo que no podr[UNI00ed]a vivir nunca\ncerca del agua."
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(window, "No son chulas ni est[UNI00e1]n de moda, pero\nhago prendas que nadie\npuede imitar.")
		end
		if villager_type == 12 then
			event.open_message_window_2(window, "Casa nueva, vida nueva.\nMe siento como un joven panadero otra vez.")
		end
		if villager_type == 13 then
			event.open_message_window_2(window, "No me importa el qu[UNI00e9],\npero quiero romper algo\nen mil pedazos.")
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "Si descubres alg[UNI00fa]n monstruo nuevo,\navisa cuanto antes.")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"Dicen que no es para mujeres,\npero a la espada no le importa\nqui[UNI00e9]n la empu[UNI00f1]a. Que gane el mejor."
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "A lo mejor esta casa no\nest[UNI00e1] tan mal para criar a una familia.")
		end
		if villager_type == 17 then
			event.open_message_window_2(window, "Me pregunto si Morton sigue\nbien. Me tiene preocupado...")
		end
		if villager_type == 18 then
			event.open_message_window_2(
				window,
				"Si sabes de una ciudad que necesite una\niglesia, yo soy el cura indicado.\nAv[UNI00ed]same."
			)
		end
		if villager_type == 19 then
			event.open_message_window_2(
				window,
				"[UNI00da]ltimamente no he pensado\nmucho en la luna. Ser[UNI00e1] por todos\nmis amigos nuevos."
			)
		end
		if villager_type == 20 then
			event.open_message_window_2(window, "Casa nueva, peces nuevos.\nHay que adaptarse\nal nuevo territorio.")
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "Esta agua tiene que ser perfecta para los peces.")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"Parn ha empezado otro retrato\nde mujer. Dice que va a\nser incluso m[UNI00e1]s guapa que yo."
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(window, "[UNI00bf]Por qu[UNI00e9] ser[UNI00e1]n tan asquerosos los insectos...?")
		end
		if villager_type == 24 then
			event.open_message_window_2(
				window,
				"[UNI00bf]Puedes hacer que mi casa sea m[UNI00e1]s chula?\nUna casa nunca es demasiado chula,\nt[UNI00fa] ya lo sabes."
			)
		end
		if villager_type == 25 then
			event.open_message_window_2(window, "Nunca imagin[UNI00e9] que me fuera\na mudar a mi edad.")
		end
	else
		partner_talk.show_npc_remark(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
function town_villagers.talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	town_villagers.say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

return town_villagers
