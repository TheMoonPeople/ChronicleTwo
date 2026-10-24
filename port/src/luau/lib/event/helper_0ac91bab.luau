--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_0ac91bab()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local player_chara_2: s32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	var3 = 0
	flag = event.GetFlag(324) or flag
	flag_2 = event.GetFlag(330) or flag_2
	flag_3 = event.GetFlag(372) or flag_3
	flag_4 = event.GetFlag(400) or flag_4
	flag_5 = event.GetFlag(640) or flag_5
	if var2 == 200 then
		if flag_5 == 0 then
			if flag_2 == 0 then
				if flag == 0 then
					event.MesMake_2(
						0,
						"Para preparar un Plato milagroso necesito\nuna Flor del viento, pero no\nme quedan. Lo siento, no puedo hacer nada."
					)
				else
					event.MesMake_2(
						0,
						"[UNI00bf]Has probado ya la\nEmpanadilla milagro? Se desvirt[UNI00fa]a\nal enfriarse, as[UNI00ed] que c[UNI00f3]metela r[UNI00e1]pido."
					)
				end
			else
				event.MesMake_2(
					0,
					"As[UNI00ed] que te ha venido bien la Empanadilla milagro, [UNI00bf]eh?\nMe alegro de saberlo. Oye, [UNI00bf]quieres comer\nalgo antes de marcharte?"
				)
			end
		else
			event.MesMake_2(0, "[UNI00a1]Ah[UNI00ed] va! Ya es casi la hora.\nBueno, pues entonces nada.")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"Cada objeto tiene\nsus propiedades. Algunos te ayudan, otros\ncambian para formar armas...<page>Si experimentas con ellos, podr[UNI00e1]s\nvencer al peor\nenemigo. Pru[UNI00e9]balo todo."
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"No me puedo creer que\nel diab[UNI00f3]lico Emperador Griffon destruyera\neste templo...<page>Si el Gran Sabio Crest\nestuviera aqu[UNI00ed]..."
			)
		else
			event.MesMake_2(
				0,
				"Ahora que el Gran Sabio est[UNI00e1]\notra vez con nosotros, no hay nada\nque temer. Ve y enfr[UNI00e9]ntate a Griffon."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"El templo est[UNI00e1] en una\nnoche perpetua porque el poder del\nCristal lunar es mayor por la noche.<page>Utiliza la fuerza del templo\npara crear una zona nocturna."
			)
		else
			event.MesMake_2(
				0,
				"Que Crest el Grande use el poder\nde este Cristal lunar para ver\ntodas las cosas de este mundo.<page>No hay forma de ocultarse\na los ubicuos ojos de Crest."
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Hola. Hay un gran surtido para\nti. Nuestras armas tienen fama\nde ser fuertes y resistentes."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"[UNI00a1]Eh! D[UNI00e9]jate de perder el tiempo\ny ens[UNI00e9][UNI00f1]ale\na Griffon qui[UNI00e9]n manda.\nR[UNI00e1]pido."
				)
			else
				event.MesMake_2(
					0,
					"Bueno, aqu[UNI00ed] se acaba mi\nparte. Ahora te toca a ti. Enc[UNI00e1]rgate\nde Griffon, [UNI00bf]vale?<page>Me has salvado. S[UNI00e9] que si alguien\npuede hacer esto, sois vosotros."
				)
			end
		else
			event.MesMake_2(
				0,
				"Parece que se acerca\nel final del viaje. Acaba con Griffon\npor el Maestro y por todos nosotros.<page>Tienes que vencerlo a toda costa.\nCuando caiga Griffon... Crest y\nyo... seremos verdaderos Sabios."
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Aunque el templo haya recuperado\nla normalidad, sin Crest\nes in[UNI00fa]til.<page>S[UNI00f3]lo [UNI00e9]l posee el enorme poder\nastrol[UNI00f3]gico para\nescrutar el mundo entero."
			)
		else
			event.MesMake_2(
				0,
				"Hasta el propio Crest fue una vez\naprendiz de un sabio. Tuvo que\nser un maestro fabuloso..."
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Aqu[UNI00ed] la comida es de primera.\nSe me hace la boca agua s[UNI00f3]lo de pensar en ella."
			)
		else
			event.MesMake_2(0, "[UNI00a1]Ha preparado el Plato milagroso!\nLao Chao es un chef de los que no hay.")
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Cuando hayas cenado aqu[UNI00ed],\nnada te sabr[UNI00e1] igual\nde bien. La comida que ponen es incre[UNI00ed]ble."
			)
		else
			event.MesMake_2(0, "[UNI00a1]Guau! Me muero\npor probar las\nEmpanadillas milagro.")
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Te parece raro\nel Reloj de estrellas?<page>[UNI00a1]A qui[UNI00e9]n se lo dices! Yo tengo uno\n, pero no me acuerdo nunca de [UNI00e9]l...\nNunca he viajado al pasado."
			)
		else
			event.MesMake_2(
				0,
				"Es estupendo que fuerais\namigos de Crest, el Gran Sabio.<page>Aunque no sab[UNI00ed]a\nque fuerais tan [UNI00ed]ntimos..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"El Gran Sabio Crest no est[UNI00e1].\n[UNI00bf]D[UNI00f3]nde se habr[UNI00e1] metido...?<page>Sin [UNI00e9]l se nos cae el alma\na los pies."
			)
		else
			event.MesMake_2(
				0,
				"El Gran Crest me dijo una vez:\nEn el pasado, un hombre llamado Gaspar\ntrat[UNI00f3] de destruir este Cristal lunar.<page>Y el gran maestro de Crest\narriesg[UNI00f3] la vida para protegerlo..."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]O sea que el Gran Crest ha desaparecido\ncon el Cristal lunar\npara protegerlo?<page>No entiendo nada..."
			)
		else
			event.MesMake_2(
				0,
				"Has visto el enorme poder\nque atesora el Cristal lunar, [UNI00bf]no? Pero\ns[UNI00f3]lo hay una persona que pueda usarlo...<page>Crest, el Gran Sabio...<page>La gente corriente como nosotros\nno puede hacer nada\nparecido."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Ser[UNI00e9]is acaso vosotros...? El Gran Sabio\nCrest me dijo una vez que un d[UNI00ed]a\nvendr[UNI00ed]an un chico y una chica...<page>[UNI00a1]Sab[UNI00ed]a que la profec[UNI00ed]a se cumplir[UNI00ed]a!<page>Pero por desgracia el Gran Sabio\ntambi[UNI00e9]n ha desaparecido."
			)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]Hace 10.000 a[UNI00f1]os?<page>[UNI00bf]Quieres decir que el Laboratorio Lunar puede\nrealizar una proeza\nfuera del alcance del propio Gran Crest?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"La luna ejerce un poder de\nextra[UNI00f1]os efectos\nsobre todos los seres vivos.<page>El Cristal lunar\nencierra ese poder."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Si buscas la mejor\ncomida del mundo, deber[UNI00ed]as pasarte\npor el restaurante Lao Chao.<page>Lo conoces, [UNI00bf]no?"
			)
		else
			event.MesMake_2(
				0,
				"As[UNI00ed] que sois vosotros. El Gran Crest\nme habl[UNI00f3] de vosotros y de c[UNI00f3]mo\nle salvasteis la vida hace mucho tiempo.<page>Nunca hubiera pensado\nque fuerais unos ni[UNI00f1]os..."
			)
		end
	end
	if var3 == 0 then
		helper_907fd9a8(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_b5a98ffa(0, -1, var1, player_chara, 0)
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var10 = out1 or var10
			var12 = out3 or var12
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var13 = out1 or var13
			var15 = out3 or var15
		end
		var16 = event.GetRotLookPos(var13 - var10, var15 - var12) or var16
		helper_cfca3481(player_chara_2, var16)
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_59a16271(5)
	end
	if var2 == 204 then
		helper_59a16271(27)
	end
end

return helper_0ac91bab
