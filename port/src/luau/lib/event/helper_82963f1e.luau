--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_daad34bd = require("@lib/event/helper_daad34bd")

--- Helper function.
local function helper_82963f1e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"Ahora vivo aqu[UNI00ed],\npero estoy preocupado\npor el Blackstone I.<page>Me encargar[UNI00e9] de\nque el tren siga rodando,\ncomo antes."
				)
				var4 = event.get_triggered_event_data_2(13) or var4
				helper_1c04a0eb(var4, -1, 0, 0)
				event.open_message_window_2(
					arg0,
					"Borneo es un poco bruto,\ny Erik es un ni[UNI00f1]o.<page>Para la gente como yo, la vida\nconsiste en trabajar, dormir y volver a trabajar.<page>Pero as[UNI00ed] es la vida..."
				)
			else
				event.open_message_window_2(arg0, "[UNI00bf]Qu[UNI00e9] tal va Steve?")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "No puedo soportar quedarme en\nla habitaci[UNI00f3]n mirando las musara[UNI00f1]as.")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"Las plantas y las flores crecen\ndependiendo del cuidado que se les dedique. Yo\nno podr[UNI00ed]a descuidar a mis chiquitines."
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"Me gustar[UNI00ed]a saber si la base secreta est[UNI00e1] a salvo.\nYo le preguntar[UNI00ed]a a alguien\npara averiguarlo, pero es un secreto, y claro..."
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"El morado es un buen color.\nEs de un fr[UNI00ed]o templado\ny de una oscuridad luminosa."
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "Si alguien se pusiera enfermo\n, ir[UNI00ed]a a ayudarle a cualquier parte.")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "Para hacer platos deliciosos\nen cualquier parte hay que ser un gran cocinero.")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "Trat[UNI00e1]ndose de casas, cuanto m[UNI00e1]s robustas\nmejor, [UNI00bf]no?")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"Me encantan los frutos secos, pero esos\nrojos est[UNI00e1]n para chuparse los dedos.\n[UNI00bf]Puedes traerme m[UNI00e1]s?"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"La humedad ambiental es el peor enemigo de los libros.\nCreo que no podr[UNI00ed]a vivir nunca\ncerca del agua."
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(arg0, "No son chulas ni est[UNI00e1]n de moda, pero\nhago prendas que nadie\npuede imitar.")
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "Casa nueva, vida nueva.\nMe siento como un joven panadero otra vez.")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "No me importa el qu[UNI00e9],\npero quiero romper algo\nen mil pedazos.")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "Si descubres alg[UNI00fa]n monstruo nuevo,\navisa cuanto antes.")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"Dicen que no es para mujeres,\npero a la espada no le importa\nqui[UNI00e9]n la empu[UNI00f1]a. Que gane el mejor."
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "A lo mejor esta casa no\nest[UNI00e1] tan mal para criar a una familia.")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "Me pregunto si Morton sigue\nbien. Me tiene preocupado...")
		end
		if arg1 == 18 then
			event.open_message_window_2(
				arg0,
				"Si sabes de una ciudad que necesite una\niglesia, yo soy el cura indicado.\nAv[UNI00ed]same."
			)
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"[UNI00da]ltimamente no he pensado\nmucho en la luna. Ser[UNI00e1] por todos\nmis amigos nuevos."
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(arg0, "Casa nueva, peces nuevos.\nHay que adaptarse\nal nuevo territorio.")
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "Esta agua tiene que ser perfecta para los peces.")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"Parn ha empezado otro retrato\nde mujer. Dice que va a\nser incluso m[UNI00e1]s guapa que yo."
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(arg0, "[UNI00bf]Por qu[UNI00e9] ser[UNI00e1]n tan asquerosos los insectos...?")
		end
		if arg1 == 24 then
			event.open_message_window_2(
				arg0,
				"[UNI00bf]Puedes hacer que mi casa sea m[UNI00e1]s chula?\nUna casa nunca es demasiado chula,\nt[UNI00fa] ya lo sabes."
			)
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "Nunca imagin[UNI00e9] que me fuera\na mudar a mi edad.")
		end
	else
		helper_daad34bd(arg0, arg1)
	end
end

return helper_82963f1e
