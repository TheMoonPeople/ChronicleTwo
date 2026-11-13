--!strict
--- Holds the Spanish conversations of the villagers of Luna Lab.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local luna_lab_villagers = {}

--- Plays the conversation of the Luna Lab villager that was talked to, choosing the line by villager type and story flags.
function luna_lab_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local lab_visit_flag: s32 = 0
	local aquarium_done_flag: s32 = 0
	local aquarium_quest_flag: s32 = 0
	local aquarium_invention_status: s32 = 0
	local electric_fish_state: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local griffon_hint_flag: s32 = 0
	local elena_attack_flag: s32 = 0
	local playable_character: s32 = 0
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
	if villager_type == 300 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			lab_visit_flag = event.get_save_flag(456) or lab_visit_flag
			if lab_visit_flag == 0 then
				event.open_message_window_2(
					0,
					"[UNI00bf]Eh? [UNI00bf]Qui[UNI00e9]n eres t[UNI00fa]...?\nEste es el mejor centro de investigaciones del mundo,\nel Laboratorio Lun[UNI00e1]tico de Sabidur[UNI00ed]a.\nAunque en estos momentos\neste lugar no sea muy aparente,\nterminaremos nuestra investigaci[UNI00f3]n."
				)
			else
				event.open_message_window_2(
					0,
					"No se puede explicar con palabras la\ngrandeza de Laboratorio Lunar. Hay que verlo\npara creerlo."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Si Griffon no cae, la historia\nnunca volver[UNI00e1] a su curso\nnatural.<page>La propia existencia de Griffon\ndistorsiona los hechos hist[UNI00f3]ricos."
			)
		end
	end
	if villager_type == 301 then
		aquarium_done_flag = event.get_save_flag(420) or aquarium_done_flag
		if aquarium_done_flag == 0 then
			aquarium_quest_flag = event.get_save_flag(408) or aquarium_quest_flag
			if aquarium_quest_flag == 0 then
				event.open_message_window_2(0, "Haahn, shooo, haahn, shooo.")
				closing_mode = 2
			else
				aquarium_invention_status = event.is_invention_created(309) or aquarium_invention_status
				if aquarium_invention_status < 0 then
					event.open_message_window_2(
						0,
						"Os voy a dar unas pistas para ayudaros\na construir un acuario. Una caja de madera,\nuna ventana y una fuente. Seguro que lo\nencontr[UNI00e1]is todo en vuestra ciudad."
					)
				else
					electric_fish_state = event.get_save_data_value(2) or electric_fish_state
					if electric_fish_state == 0 then
						event.open_message_window_2(
							0,
							'Primero dale un "Gusano el[UNI00e9]ctrico" a\nun pez del acuario para\nelectrificarlo. Luego, dale el pez al<page>Shigura. [UNI00bf]Entiendes,\nno?'
						)
					else
						event.open_message_window_2(
							0,
							"Ooh, ya tienes el pez, [UNI00bf]eh?\nAhora d[UNI00e1]selo al Shigura.\nPara ti est[UNI00e1] chupado, [UNI00bf]no?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"[UNI00a1]Vaya! [UNI00a1]Lo has conseguido!\nSupongo que mi invento\nte ha ayudado, [UNI00bf]no? S[UNI00ed], seguro que s[UNI00ed]."
			)
		end
	end
	if villager_type == 302 then
		event.open_message_window_2(
			0,
			"Este Osmond y el jefe del laboratorio...\nHay mucho t[UNI00ed]o raro suelto por aqu[UNI00ed]."
		)
	end
	if villager_type == 303 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				griffon_hint_flag = event.get_save_flag(600) or griffon_hint_flag
				if griffon_hint_flag == 0 then
					elena_attack_flag = event.get_save_flag(448) or elena_attack_flag
					if elena_attack_flag == 0 then
						event.open_message_window_2(
							0,
							"Cuida bien del Tradu-talkie.\nEs uno de los inventos m[UNI00e1]s\nimportantes del Laboratorio Lunar"
						)
					else
						event.open_message_window_2(
							0,
							"No hay tiempo. Tienes que darte prisa,\nlas fuerzas de Griffon se acercan\na Elena; no aguantar[UNI00e1]n mucho..."
						)
					end
				else
					event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] clase de hombre ser[UNI00e1]\nGriffon...?")
				end
			else
				event.open_message_window_2(
					0,
					"Est[UNI00e1]s buscando gemas, [UNI00bf]eh? Las gemas son cristales\ndel saber forjados por los ancianos.<page>Seg[UNI00fa]n los an[UNI00e1]lisis del ordenador\ndel Laboratorio Lunar, est[UNI00e1]n ocultos en cuatro\nlugares:"
				)
				cutscene.face_each_other(player_slot, villager_id, 0)
				message.say_bubble(0, -1, villager_id, player_slot, 0)
				closing_mode = 1
				event.open_message_window_2(
					0,
					"el Bosque Mariposa Arco Iris, el Ca[UNI00f1][UNI00f3]n Starlight, la Cueva Boca de Mar y\nel Monte Gundor.<page>Deber[UNI00ed]a haber un s[UNI00ed]mbolo estrellado a\nla entrada de cada uno de estos sitios:\nten los ojos bien abiertos."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Muy bien: es hora de mandar a Griffon\nal otro barrio. El destino del mundo est[UNI00e1]\nen tus manos. [UNI00a1]Buena suerte!"
			)
		end
	end
	if villager_type == 304 then
		event.open_message_window_2(
			0,
			"En este laboratorio todo es cuesti[UNI00f3]n\nde habilidad. Con habilidad, hasta\nel ni[UNI00f1]o m[UNI00e1]s peque[UNI00f1]o puede convertirse en un pez gordo."
		)
	end
	if villager_type == 305 then
		event.open_message_window_2(
			0,
			"Las Piedras lunares que nos traen\nlos Shigura nos despejan la mente y\nmejoran nuestra concentraci[UNI00f3]n en la investigaci[UNI00f3]n.<page>No s[UNI00e9] exactamente qu[UNI00e9] son,\npero..."
		)
	end
	if villager_type == 306 then
		event.open_message_window_2(
			0,
			"Un laboratorio en el oc[UNI00e9]ano mola mucho,\n[UNI00bf]eh? Pero para ganarse una plaza\naqu[UNI00ed] hay que sudar la gota gorda."
		)
	end
	if villager_type == 307 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] te parece el dise[UNI00f1]o\ndel Laboratorio Lunar? No s[UNI00e9] a qui[UNI00e9]n se le\nocurrir[UNI00ed]a darle este aspecto de parque recreativo..."
		)
	end
	if villager_type == 308 then
		event.open_message_window_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a superar[UNI00e9] a todos\ny les demostrar[UNI00e9] lo inteligente que soy. Aqu[UNI00ed]\ntodo es cuesti[UNI00f3]n de habilidad, ya lo sabes."
		)
	end
	if villager_type == 309 then
		event.open_message_window_2(
			0,
			'Mira, yo respeto un mont[UNI00f3]n al jefe.\nTienes que d[UNI00e1]rselo a otro que sea\ncapaz de escribir un bestseller<page>de 40 p[UNI00e1]ginas a esta edad. Algo como "La Biblia del\nS[UNI00fa]per Cient[UNI00ed]fico".'
		)
	end
	if villager_type == 310 then
		event.open_message_window_2(
			0,
			"Yo todav[UNI00ed]a soy una especie de novatillo.\nEstoy aprendiendo un mont[UNI00f3]n y quiero\nconvertirme en un investigador de primera alg[UNI00fa]n d[UNI00ed]a."
		)
	end
	if villager_type == 311 then
		event.open_message_window_2(
			0,
			"Las vistas al mar desde este laboratorio\nson impresionantes.<page>A lo lejos, en el horizonte,\nconviven la oscuridad del mar y\nla claridad del cielo."
		)
	end
	if villager_type == 312 then
		event.open_message_window_2(
			0,
			"Este es el Laboratorio n[UNI00ba] 2.<page>En el Laboratorio Lunar\ncada laboratorio tiene su\npropia zona de investigaci[UNI00f3]n."
		)
	end
	if villager_type == 313 then
		event.open_message_window_2(
			0,
			"En el Laboratorio Lunar simulamos\nun entorno nocturno para potenciar\nel poder de las Piedras lunares."
		)
	end
	if villager_type == 314 then
		event.open_message_window_2(
			0,
			"Cuando empec[UNI00e9] a trabajar,\nno era capaz de distinguir\nlos laboratorios. A lo mejor esto te sirve.<page>El Laboratorio 1 es rojo, el 2 es azul, el 3,\nmorado y el 4 verde.\nCada uno es de un color."
		)
	end
	if villager_type == 315 then
		event.open_message_window_2(0, "El emblema del Laboratorio Central\nest[UNI00e1] inspirado en la luna.")
	end
	if villager_type == 316 then
		event.open_message_window_2(
			0,
			"Me han dicho que este Laboratorio se complet[UNI00f3]\ngracias a las Piedras lunares que\ntrajo un drag[UNI00f3]n marino llamado Shingala.<page>Esos dragones\ndeben de ser muy listos, [UNI00bf]eh?"
		)
	end
	if villager_type == 317 then
		event.open_message_window_2(
			0,
			"No le puedes decir que yo te lo he contado,<page>pero estamos hasta la coronilla de\nlos chistes de Osmond.\nNos ponen de los nervios."
		)
	end
	if villager_type == 318 then
		event.open_message_window_2(
			0,
			"No s[UNI00e9] mentir. S[UNI00ed], yo tambi[UNI00e9]n tuve que\nver en la investigaci[UNI00f3]n sobre el Gusano el[UNI00e9]ctrico.\nAhora estoy trabajando en otro proyecto.<page>[UNI00a1]Pero no puedo hablar!\nEs secreto. No puedo ir por ah[UNI00ed]\nsolt[UNI00e1]ndoselo a todo el mundo."
		)
	end
	if villager_type == 319 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] es eso? [UNI00bf]Vosotros tambi[UNI00e9]n\nquer[UNI00e9]is ser investigadores?<page>No es nada f[UNI00e1]cil llegar\nhasta aqu[UNI00ed], os lo digo yo.\nLa competencia es enorme."
		)
	end
	if villager_type == 320 then
		event.open_message_window_2(
			0,
			"Algunos investigadores critican los\ndise[UNI00f1]os que se hacen en el Laboratorio Lunar.\nEn mi opini[UNI00f3]n, son bastante chulos...<page>Me da que en esta cuesti[UNI00f3]n\nestoy con la minor[UNI00ed]a."
		)
	end
	if villager_type == 321 then
		event.open_message_window_2(
			0,
			"Estamos en plena discusi[UNI00f3]n\nsobre ciertas investigaciones de gran secreto.<page>[UNI00bf]Podr[UNI00ed]as dejarnos\nsolos un rato?"
		)
	end
	if villager_type == 322 then
		event.open_message_window_2(
			0,
			"Lo siento, pero\nestamos enfrascados en una discusi[UNI00f3]n\nsobre investigaciones muy confidenciales.<page>No podemos hablar si\nte quedas ah[UNI00ed]..."
		)
	end
	if villager_type == 323 then
		event.open_message_window_2(
			0,
			"El Dr. Nobb es un gran cerebro,\nno hay duda, pero\ntambi[UNI00e9]n es muy trabajador.<page>Yo palidezco a su lado...\nSoy como un albino..."
		)
	end
	if villager_type == 324 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Eres t[UNI00fa]? He o[UNI00ed]do que te\nhas peleado con el Dr. Osmond.<page>No es una cr[UNI00ed]tica. De hecho,\nme parece estupendo. Los descubrimientos\nse hacen cuestionando las cosas."
		)
	end
	if villager_type == 325 then
		event.open_message_window_2(
			0,
			"[UNI00bf]No te acostumbras al\nbrillo de las luces?<page>Imagino que a cualquier\nvisitante del pasado le llevar[UNI00ed]a un\ntiempo adaptarse."
		)
	end
	if villager_type == 326 then
		event.open_message_window_2(
			0,
			"Estoy tom[UNI00e1]ndome un\nrespiro, nada m[UNI00e1]s.<page>Hay que darle un descanso al cerebro de\nvez en cuando o, si no, empiezas\na perder facultades."
		)
	end
	if villager_type == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Me han dicho que no eres un mal inventor.\n[UNI00bf]Es verdad? [UNI00bf]Quieres trabajar aqu[UNI00ed]\ncon nosotros cuando crezcas?<page>Cuando seas adulto, ya habr[UNI00e1]n\nterminado el Laboratorio Lunar.\nSeguro que les encantar[UNI00e1] tenerte aqu[UNI00ed]."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]No te parece que los inventores\nson los t[UNI00ed]os m[UNI00e1]s buenos?<page>Pero ni se te ocurra enamorarte de\nm[UNI00ed], [UNI00bf]oyes? La investigaci[UNI00f3]n es mi\nvida. Lo nuestro nunca funcionar[UNI00ed]a."
			)
		end
	end
	if villager_type == 328 then
		event.open_message_window_2(
			0,
			"Tengo una idea revolucionaria.\nSe trata de un sistema que\npermitir[UNI00ed]a a los monstruos convivir con los humanos.<page>Crear[UNI00e9] una m[UNI00e1]quina que\nentienda el lenguaje humano."
		)
	end
	if villager_type == 329 then
		event.open_message_window_2(
			0,
			"Las Piedras lunares son la espina dorsal\ndel Laboratorio Lunar.<page>Sin ellas, todos nuestros\nsistemas se\ndetendr[UNI00ed]an en un instante."
		)
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
end

return luna_lab_villagers
