--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b3fc698 = require("@lib/event/helper_2b3fc698")
local helper_92866686 = require("@lib/event/helper_92866686")
local helper_afa3edbd = require("@lib/event/helper_afa3edbd")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_32040723()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_afa3edbd(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_92866686(player_chara_2, var22)
		end
		if at <= 5 then
			helper_b8950300(0, -1, var1, player_chara_2, 0)
		end
	end
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
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"[UNI00bf]Eh? [UNI00bf]Qui[UNI00e9]n eres t[UNI00fa]...?\nEste es el mejor centro de investigaciones del mundo,\nel Laboratorio Lun[UNI00e1]tico de Sabidur[UNI00ed]a.\nAunque en estos momentos\neste lugar no sea muy aparente,\nterminaremos nuestra investigaci[UNI00f3]n."
				)
			else
				event.MesMake_2(
					0,
					"No se puede explicar con palabras la\ngrandeza de Laboratorio Lunar. Hay que verlo\npara creerlo."
				)
			end
		else
			event.MesMake_2(
				0,
				"Si Griffon no cae, la historia\nnunca volver[UNI00e1] a su curso\nnatural.<page>La propia existencia de Griffon\ndistorsiona los hechos hist[UNI00f3]ricos."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haahn, shooo, haahn, shooo.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Os voy a dar unas pistas para ayudaros\na construir un acuario. Una caja de madera,\nuna ventana y una fuente. Seguro que lo\nencontr[UNI00e1]is todo en vuestra ciudad."
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							'Primero dale un "Gusano el[UNI00e9]ctrico" a\nun pez del acuario para\nelectrificarlo. Luego, dale el pez al<page>Shigura. [UNI00bf]Entiendes,\nno?'
						)
					else
						event.MesMake_2(
							0,
							"Ooh, ya tienes el pez, [UNI00bf]eh?\nAhora d[UNI00e1]selo al Shigura.\nPara ti est[UNI00e1] chupado, [UNI00bf]no?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"[UNI00a1]Vaya! [UNI00a1]Lo has conseguido!\nSupongo que mi invento\nte ha ayudado, [UNI00bf]no? S[UNI00ed], seguro que s[UNI00ed]."
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(
			0,
			"Este Osmond y el jefe del laboratorio...\nHay mucho t[UNI00ed]o raro suelto por aqu[UNI00ed]."
		)
	end
	if var2 == 303 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(448) or flag_8
					if flag_8 == 0 then
						event.MesMake_2(
							0,
							"Cuida bien del Tradu-talkie.\nEs uno de los inventos m[UNI00e1]s\nimportantes del Laboratorio Lunar"
						)
					else
						event.MesMake_2(
							0,
							"No hay tiempo. Tienes que darte prisa,\nlas fuerzas de Griffon se acercan\na Elena; no aguantar[UNI00e1]n mucho..."
						)
					end
				else
					event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] clase de hombre ser[UNI00e1]\nGriffon...?")
				end
			else
				event.MesMake_2(
					0,
					"Est[UNI00e1]s buscando gemas, [UNI00bf]eh? Las gemas son cristales\ndel saber forjados por los ancianos.<page>Seg[UNI00fa]n los an[UNI00e1]lisis del ordenador\ndel Laboratorio Lunar, est[UNI00e1]n ocultos en cuatro\nlugares:"
				)
				helper_2b3fc698(player_chara, var1, 0)
				if vm.skipping() then
					return skip(1)
				end
				helper_b8950300(0, -1, var1, player_chara, 0)
				if vm.skipping() then
					return skip(2)
				end
				var3 = 1
				event.MesMake_2(
					0,
					"el Bosque Mariposa Arco Iris, el Ca[UNI00f1][UNI00f3]n Starlight, la Cueva Boca de Mar y\nel Monte Gundor.<page>Deber[UNI00ed]a haber un s[UNI00ed]mbolo estrellado a\nla entrada de cada uno de estos sitios:\nten los ojos bien abiertos."
				)
			end
		else
			event.MesMake_2(
				0,
				"Muy bien: es hora de mandar a Griffon\nal otro barrio. El destino del mundo est[UNI00e1]\nen tus manos. [UNI00a1]Buena suerte!"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"En este laboratorio todo es cuesti[UNI00f3]n\nde habilidad. Con habilidad, hasta\nel ni[UNI00f1]o m[UNI00e1]s peque[UNI00f1]o puede convertirse en un pez gordo."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Las Piedras lunares que nos traen\nlos Shigura nos despejan la mente y\nmejoran nuestra concentraci[UNI00f3]n en la investigaci[UNI00f3]n.<page>No s[UNI00e9] exactamente qu[UNI00e9] son,\npero..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Un laboratorio en el oc[UNI00e9]ano mola mucho,\n[UNI00bf]eh? Pero para ganarse una plaza\naqu[UNI00ed] hay que sudar la gota gorda."
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] te parece el dise[UNI00f1]o\ndel Laboratorio Lunar? No s[UNI00e9] a qui[UNI00e9]n se le\nocurrir[UNI00ed]a darle este aspecto de parque recreativo..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a superar[UNI00e9] a todos\ny les demostrar[UNI00e9] lo inteligente que soy. Aqu[UNI00ed]\ntodo es cuesti[UNI00f3]n de habilidad, ya lo sabes."
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			'Mira, yo respeto un mont[UNI00f3]n al jefe.\nTienes que d[UNI00e1]rselo a otro que sea\ncapaz de escribir un bestseller<page>de 40 p[UNI00e1]ginas a esta edad. Algo como "La Biblia del\nS[UNI00fa]per Cient[UNI00ed]fico".'
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Yo todav[UNI00ed]a soy una especie de novatillo.\nEstoy aprendiendo un mont[UNI00f3]n y quiero\nconvertirme en un investigador de primera alg[UNI00fa]n d[UNI00ed]a."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"Las vistas al mar desde este laboratorio\nson impresionantes.<page>A lo lejos, en el horizonte,\nconviven la oscuridad del mar y\nla claridad del cielo."
		)
	end
	if var2 == 312 then
		event.MesMake_2(
			0,
			"Este es el Laboratorio n[UNI00ba] 2.<page>En el Laboratorio Lunar\ncada laboratorio tiene su\npropia zona de investigaci[UNI00f3]n."
		)
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"En el Laboratorio Lunar simulamos\nun entorno nocturno para potenciar\nel poder de las Piedras lunares."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Cuando empec[UNI00e9] a trabajar,\nno era capaz de distinguir\nlos laboratorios. A lo mejor esto te sirve.<page>El Laboratorio 1 es rojo, el 2 es azul, el 3,\nmorado y el 4 verde.\nCada uno es de un color."
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "El emblema del Laboratorio Central\nest[UNI00e1] inspirado en la luna.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Me han dicho que este Laboratorio se complet[UNI00f3]\ngracias a las Piedras lunares que\ntrajo un drag[UNI00f3]n marino llamado Shingala.<page>Esos dragones\ndeben de ser muy listos, [UNI00bf]eh?"
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"No le puedes decir que yo te lo he contado,<page>pero estamos hasta la coronilla de\nlos chistes de Osmond.\nNos ponen de los nervios."
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"No s[UNI00e9] mentir. S[UNI00ed], yo tambi[UNI00e9]n tuve que\nver en la investigaci[UNI00f3]n sobre el Gusano el[UNI00e9]ctrico.\nAhora estoy trabajando en otro proyecto.<page>[UNI00a1]Pero no puedo hablar!\nEs secreto. No puedo ir por ah[UNI00ed]\nsolt[UNI00e1]ndoselo a todo el mundo."
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] es eso? [UNI00bf]Vosotros tambi[UNI00e9]n\nquer[UNI00e9]is ser investigadores?<page>No es nada f[UNI00e1]cil llegar\nhasta aqu[UNI00ed], os lo digo yo.\nLa competencia es enorme."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Algunos investigadores critican los\ndise[UNI00f1]os que se hacen en el Laboratorio Lunar.\nEn mi opini[UNI00f3]n, son bastante chulos...<page>Me da que en esta cuesti[UNI00f3]n\nestoy con la minor[UNI00ed]a."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Estamos en plena discusi[UNI00f3]n\nsobre ciertas investigaciones de gran secreto.<page>[UNI00bf]Podr[UNI00ed]as dejarnos\nsolos un rato?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Lo siento, pero\nestamos enfrascados en una discusi[UNI00f3]n\nsobre investigaciones muy confidenciales.<page>No podemos hablar si\nte quedas ah[UNI00ed]..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"El Dr. Nobb es un gran cerebro,\nno hay duda, pero\ntambi[UNI00e9]n es muy trabajador.<page>Yo palidezco a su lado...\nSoy como un albino..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"[UNI00bf]Eres t[UNI00fa]? He o[UNI00ed]do que te\nhas peleado con el Dr. Osmond.<page>No es una cr[UNI00ed]tica. De hecho,\nme parece estupendo. Los descubrimientos\nse hacen cuestionando las cosas."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"[UNI00bf]No te acostumbras al\nbrillo de las luces?<page>Imagino que a cualquier\nvisitante del pasado le llevar[UNI00ed]a un\ntiempo adaptarse."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"Estoy tom[UNI00e1]ndome un\nrespiro, nada m[UNI00e1]s.<page>Hay que darle un descanso al cerebro de\nvez en cuando o, si no, empiezas\na perder facultades."
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"Me han dicho que no eres un mal inventor.\n[UNI00bf]Es verdad? [UNI00bf]Quieres trabajar aqu[UNI00ed]\ncon nosotros cuando crezcas?<page>Cuando seas adulto, ya habr[UNI00e1]n\nterminado el Laboratorio Lunar.\nSeguro que les encantar[UNI00e1] tenerte aqu[UNI00ed]."
			)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]No te parece que los inventores\nson los t[UNI00ed]os m[UNI00e1]s buenos?<page>Pero ni se te ocurra enamorarte de\nm[UNI00ed], [UNI00bf]oyes? La investigaci[UNI00f3]n es mi\nvida. Lo nuestro nunca funcionar[UNI00ed]a."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"Tengo una idea revolucionaria.\nSe trata de un sistema que\npermitir[UNI00ed]a a los monstruos convivir con los humanos.<page>Crear[UNI00e9] una m[UNI00e1]quina que\nentienda el lenguaje humano."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Las Piedras lunares son la espina dorsal\ndel Laboratorio Lunar.<page>Sin ellas, todos nuestros\nsistemas se\ndetendr[UNI00ed]an en un instante."
		)
	end
	if var3 == 0 then
		helper_afa3edbd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_b8950300(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.GetRotLookPos(var19 - var16, var21 - var18) or var22
		helper_92866686(player_chara_2, var22)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b8950300(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
end

return helper_32040723
