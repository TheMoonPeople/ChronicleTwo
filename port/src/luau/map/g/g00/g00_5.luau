--!strict
-- map/g/g00/g00_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_62059bfe = require("@lib/event/helper_62059bfe")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_bf8a16c2 = require("@lib/event/helper_bf8a16c2")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_be7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Tiene que haber much[UNI00ed]simas plantas\npor ah[UNI00ed] que ni siquiera conozcamos.")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"[UNI00a1]Eh! [UNI00bf]C[UNI00f3]mo va la b[UNI00fa]squeda de Zelmite?\nSi puedo ayudar,\ndame una voz."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(
			arg0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "[UNI00a1]Eh! [UNI00bf]Qu[UNI00e9] tal? [UNI00a1]Por aqu[UNI00ed] genial!")
	end
	if arg1 == 10 then
		event.MesMake_2(
			arg0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Rezar[UNI00e9] por ti...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	if arg1 == 15 then
		event.MesMake_2(
			arg0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"F[UNI00ed]jate bien en lo que te digo:\ns[UNI00e9] que la Mina de Zelmite es un lugar\npeligroso. No hagas tonter[UNI00ed]as."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Rezo por que haya paz\nen el mundo a partir de hoy y para siempre.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Si el Ferrocarril Blackstone recorre\ntodo el mundo, podremos visitar\nun mont[UNI00f3]n de sitios nuevos."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Tengo unas ganas de\nver todos los lugares para pescar\ndel mundo... S[UNI00ed] que va a ser divertido."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(arg0, "Me gustar[UNI00ed]a que Fabio se interesase\npor algo m[UNI00e1]s aparte\nde la pesca.")
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"A m[UNI00ed] no me enga[UNI00f1]as. T[UNI00fa] has\nestado por ah[UNI00ed] pas[UNI00e1]ndotelo\nbomba. [UNI00a1]Tienes que contarme tus andanzas alg[UNI00fa]n d[UNI00ed]a!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Cuando est[UNI00e9] terminado el Ferrocarril Blackstone\nme gustar[UNI00ed]a\nir al "Fin del mundo".'
		)
	end
end

--- Helper function.
local function helper_20a28(arg0: s32, arg1: s32, sp: number)
	local junk = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 8)
			junk += 3
		end
		helper_be7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"Ahora vivo aqu[UNI00ed],\npero estoy preocupado\npor el Blackstone I.<page>Me encargar[UNI00e9] de\nque el tren siga rodando,\ncomo antes."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Borneo es un poco bruto,\ny Erik es un ni[UNI00f1]o.<page>Para la gente como yo, la vida\nconsiste en trabajar, dormir y volver a trabajar.<page>Pero as[UNI00ed] es la vida..."
				)
			else
				event.MesMake_2(arg0, "[UNI00bf]Qu[UNI00e9] tal va Steve?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "No puedo soportar quedarme en\nla habitaci[UNI00f3]n mirando las musara[UNI00f1]as.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Las plantas y las flores crecen\ndependiendo del cuidado que se les dedique. Yo\nno podr[UNI00ed]a descuidar a mis chiquitines."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Me gustar[UNI00ed]a saber si la base secreta est[UNI00e1] a salvo.\nYo le preguntar[UNI00ed]a a alguien\npara averiguarlo, pero es un secreto, y claro..."
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"El morado es un buen color.\nEs de un fr[UNI00ed]o templado\ny de una oscuridad luminosa."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Si alguien se pusiera enfermo\n, ir[UNI00ed]a a ayudarle a cualquier parte.")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Para hacer platos deliciosos\nen cualquier parte hay que ser un gran cocinero.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Trat[UNI00e1]ndose de casas, cuanto m[UNI00e1]s robustas\nmejor, [UNI00bf]no?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Me encantan los frutos secos, pero esos\nrojos est[UNI00e1]n para chuparse los dedos.\n[UNI00bf]Puedes traerme m[UNI00e1]s?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"La humedad ambiental es el peor enemigo de los libros.\nCreo que no podr[UNI00ed]a vivir nunca\ncerca del agua."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(arg0, "No son chulas ni est[UNI00e1]n de moda, pero\nhago prendas que nadie\npuede imitar.")
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "Casa nueva, vida nueva.\nMe siento como un joven panadero otra vez.")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "No me importa el qu[UNI00e9],\npero quiero romper algo\nen mil pedazos.")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Si descubres alg[UNI00fa]n monstruo nuevo,\navisa cuanto antes.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Dicen que no es para mujeres,\npero a la espada no le importa\nqui[UNI00e9]n la empu[UNI00f1]a. Que gane el mejor."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "A lo mejor esta casa no\nest[UNI00e1] tan mal para criar a una familia.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "Me pregunto si Morton sigue\nbien. Me tiene preocupado...")
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Si sabes de una ciudad que necesite una\niglesia, yo soy el cura indicado.\nAv[UNI00ed]same."
			)
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"[UNI00da]ltimamente no he pensado\nmucho en la luna. Ser[UNI00e1] por todos\nmis amigos nuevos."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(arg0, "Casa nueva, peces nuevos.\nHay que adaptarse\nal nuevo territorio.")
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Esta agua tiene que ser perfecta para los peces.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn ha empezado otro retrato\nde mujer. Dice que va a\nser incluso m[UNI00e1]s guapa que yo."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "[UNI00bf]Por qu[UNI00e9] ser[UNI00e1]n tan asquerosos los insectos...?")
		end
		if arg1 == 24 then
			event.MesMake_2(
				arg0,
				"[UNI00bf]Puedes hacer que mi casa sea m[UNI00e1]s chula?\nUna casa nunca es demasiado chula,\nt[UNI00fa] ya lo sabes."
			)
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "Nunca imagin[UNI00e9] que me fuera\na mudar a mi edad.")
		end
	else
		helper_be7c(arg0, arg1)
	end
end

--- Helper function.
local function helper_220b4(sp: number)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	helper_20a28(0, var2, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_223b8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7e2956fd(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_7e2956fd(1)
	event.Finish()
end

--- Helper function.
local function helper_22564(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		helper_223b8()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_223b8()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e704(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Si no me traes m[UNI00e1]s logros\nno puedo darte nada.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(
			arg0,
			"El nivel de tu Fotograf[UNI00ed]a est[UNI00e1] determinado\npor el n[UNI00fa]mero de ideas y logros\nque tengas.<page>Conforme vayas aumentando de nivel, conseguir[UNI00e1]s\nm[UNI00e1]s objetos como recompensa."
		)
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_ed8c(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return helper_e704(arg0)
		end
		if at <= 5 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return helper_e704(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Tr[UNI00e1]eme una\nNota de Logros, anda.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Parece que no quedan\nlogros.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_e704(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_4005e7b5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Yo calculo [Number1] logros m[UNI00e1]s.")
		event.SetMesDrawspeed(arg0, 0)
		helper_d1353c5b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_4005e7b5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"[UNI00a1]Oye, t[UNI00ed]o! [UNI00a1]No te relajes!\n[UNI00bf]D[UNI00f3]nde est[UNI00e1]n todas tus nuevos logros Interiores?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(
			arg0,
			"[UNI00a1]Guau! [UNI00a1]Ya tienes [Number 1] nuevos logros!\n[UNI00a1]Sab[UNI00ed]a que lo llevabas dentro de ti!"
		)
	end
	if now_map_no == 22 then
		helper_b8950300(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_d1353c5b(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_e704(arg0)
end

--- Helper function.
local function helper_d304()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00a1]Genial! Al fin y al cabo, los humanos\nno son tan malos.<page>[UNI00a1]Estaba equivocado!"
		)
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ya est[UNI00e1]. Esto es lo [UNI00fa]ltimo.\nTenemos que derrotarle.<page>Despu[UNI00e9]s, el mundo revivir[UNI00e1]."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Creo que s[UNI00e9] c[UNI00f3]mo se siente Griffon, pero no\npodr[UNI00e9] perdonarle nunca lo que ha hecho."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Devuelve el jard[UNI00ed]n a su estado anterior y\ndescubre el secreto de Griffon... O sea, de Sirus."
		)
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			'[UNI00bf]Qu[UNI00e9] querr[UNI00e1] de decir con "los recuerdos de Sirus"?\nMe temo que tendremos que entrar en el palacio para averiguarlo.'
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Griffon se escapar[UNI00e1] si seguimos perdiendo el\ntiempo. R[UNI00e1]pido, vamos al Palacio Moon Flower."
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Ya tenemos todas las gemas. Ahora\ntenemos que ir deprisa al Stonehenge de Kazarov.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Sea lo que sea, ser[UNI00e1] mejor que demos con las gemas\nantes de que sea demasiado tarde."
		)
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Todo empez[UNI00f3] en este palacio.\nDa igual; entremos en el jard[UNI00ed]n.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ser[UNI00e1] mejor que volvamos al Laboratorio Lunar.\nPuede que ya hayan acabado con el Ixion."
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Va siendo hora de arreglar cuentas\ncon Griffon. Vamos a la base de Paznos.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00a1]No te quedes ah[UNI00ed] parado!\n[UNI00a1]Tenemos que rescatar a M[UNI00f3]nica, r[UNI00e1]pido!"
		)
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00bf]Te acuerdas? Galen Agaris dijo que\ntocando el Cuerno de fuego se abrir[UNI00ed]a el camino."
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00a1]No te quedes ah[UNI00ed] parado!\n[UNI00a1]Tenemos que rescatar a M[UNI00f3]nica, r[UNI00e1]pido!"
		)
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Voy a terminar con esa Tromba de fuego.<page>As[UNI00ed] que est[UNI00e1] en la cima del Monte Gundor, [UNI00bf]verdad? "
		)
		return
	end
	event.MesMake_2(
		3,
		"Aqu[UNI00ed] parados no vamos a hacer nada.<page>Todav[UNI00ed]a tienen que quedarnos sitios por ver."
	)
end

--- Helper function.
local function helper_22680(sp: number)
	local junk = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var4 = 0
				var4 = 20
				var4 = 24
				var4 = 28
				var4 = 32
				var4 = 40
				var4 = 44
				var4 = 48
				var4 = 52
				var4 = 56
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
				junk += 25
			end
			if at <= 2 then
				var29 = 0
				helper_4005e7b5(3, 1)
				helper_20a28(3, var2, sp + junk + 34)
				junk += 1
			end
			if at <= 3 then
				var30 = -1
				helper_4005e7b5(1, 8)
				helper_dc39b923(1, 1, 1, 0, 0)
				helper_4005e7b5(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
				junk += 3
			end
			helper_223b8()
			return
		end
		if at <= 6 then
			helper_223b8()
			return
		end
		if at <= 11 then
			if at <= 7 then
				helper_4005e7b5(3, 8)
				helper_d1353c5b(3, var30, 9, 0, 0)
				junk += 1
			end
			if at <= 8 then
				helper_d1353c5b(3, -1, 3, 256, 208)
				junk += 4
			end
			if at <= 9 then
				helper_223b8()
				helper_22564(6)
				junk += 1
			end
			if at <= 10 then
				helper_22564(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_22564(33)
			end
			return
		end
		if at <= 14 then
			helper_22564(1)
			junk += 1
		end
		if at <= 15 then
			helper_22564(2)
			junk += 1
		end
		if at <= 16 then
			helper_22564(3)
			junk += 1
		end
		if at <= 17 then
			helper_22564(7)
			junk += 1
		end
		if at <= 18 then
			helper_22564(8)
			junk += 1
		end
		if at <= 19 then
			helper_22564(9)
			junk += 1
		end
		if at <= 20 then
			helper_22564(10)
			junk += 1
		end
		if at <= 21 then
			helper_22564(11)
			junk += 1
		end
		if at <= 22 then
			helper_22564(12)
			junk += 1
		end
		if at <= 23 then
			helper_22564(13)
			junk += 1
		end
		if at <= 24 then
			helper_22564(14)
			junk += 1
		end
		if at <= 25 then
			helper_22564(15)
			junk += 1
		end
		if at <= 26 then
			helper_22564(16)
			junk += 1
		end
		if at <= 27 then
			helper_22564(17)
			junk += 1
		end
		if at <= 28 then
			helper_22564(18)
			junk += 1
		end
		if at <= 29 then
			helper_22564(19)
			junk += 1
		end
		if at <= 30 then
			helper_22564(20)
			junk += 1
		end
		if at <= 31 then
			helper_22564(21)
			junk += 1
		end
		if at <= 32 then
			helper_22564(22)
			junk += 1
		end
		if at <= 33 then
			helper_22564(32)
			junk += 1
		end
		if at <= 34 then
			helper_d304()
			helper_d1353c5b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_223b8()
			helper_b0211f82(30)
			junk += 1
		end
		helper_223b8()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_4005e7b5(3, 1)
		helper_20a28(3, var2, sp + junk + 33)
		if vm.skipping() then
			return skip(3)
		end
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_4005e7b5(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_dc39b923(1, 1, 1, 0, 0)
		helper_4005e7b5(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(4)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_223b8()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_b0211f82(30)
				if vm.skipping() then
					return skip(5)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(6)
				end
				helper_223b8()
				event.SetFadeIn(30)
				return
			end
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Ahora no puedes hacer eso. [UNI00a1]Antes tienes que\nllevar a Lin al faro!")
			helper_d1353c5b(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_d1353c5b(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Perfecto, [UNI00a1]hemos terminado las reparaciones!")
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_223b8()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_22564(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_22564(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_ed8c(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_22564(33)
							if vm.skipping() then
								return skip(13)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_22564(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_22564(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_22564(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_22564(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_22564(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_22564(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_22564(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_22564(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_22564(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_22564(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_22564(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_22564(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_22564(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_22564(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_22564(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_22564(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_22564(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_22564(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_22564(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_22564(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_22564(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d304()
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_223b8()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_b0211f82(30)
						if vm.skipping() then
							return skip(36)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(37)
						end
						helper_223b8()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_223b8()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_c6c63376

--- Program 100.
script[100] = function()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "お洒落")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_22680(sp + 0)
		end
	end
	helper_220b4(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_22680(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

return script
