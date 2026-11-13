--!strict
--- Holds the Spanish conversations of the villagers of Gundorada Workshop.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local workshop_villagers = {}

--- Plays the conversation of the Gundorada Workshop villager that was talked to, choosing the line by villager type and story flags.
function workshop_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local paznos_flag: s32 = 0
	local gaspard_defeated_flag: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_recheck_flag: s32 = 0
	local paznos_recheck_flag: s32 = 0
	local gaspard_defeated_recheck_flag: s32 = 0
	local fire_squall_defeated_flag: s32 = 0
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
	if villager_type == 400 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				paznos_flag = event.get_save_flag(540) or paznos_flag
				if paznos_flag == 0 then
					gaspard_defeated_flag = event.get_save_flag(536) or gaspard_defeated_flag
					if gaspard_defeated_flag == 0 then
						event.open_message_window_2(
							0,
							"Gaspar es un adversario terrible.\nNo bajes la guardia ni\nun momento.<page>S[UNI00e9] que puedes derrotarle.\nLa Atlamillia te eligi[UNI00f3] por\nalgo..."
						)
					else
						event.open_message_window_2(
							0,
							"Es verdad, Gaspar tambi[UNI00e9]n era infeliz.<page>[UNI00bf]Qu[UNI00e9] pretender[UNI00e1] Griffon\nmeti[UNI00e9]ndose con gente de dos [UNI00e9]pocas?"
						)
					end
				else
					event.open_message_window_2(
						0,
						"Estoy seguro de que si alguien\npuede derrotar a Griffon, sois vosotros.<page>Confiamos en vosotros."
					)
				end
			else
				event.open_message_window_2(
					0,
					"La Uni[UNI00f3]n Cronol[UNI00f3]gica... Entonces, la sabidur[UNI00ed]a\nde los ancianos salvar[UNI00e1]\nel mundo..."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Con esta va la vencida. Muchos amigos\nhan derramado su sangre en\nla lucha contra Griffon...<page>[UNI00a1]Sois nuestra [UNI00fa]ltima esperanza!\nConf[UNI00ed]o en vosotros. [UNI00a1]Ten[UNI00e9]is que\nderrotar a Griffon!"
			)
		end
	end
	if villager_type == 401 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_recheck_flag = event.get_save_flag(616) or gem_hint_recheck_flag
			if gem_hint_recheck_flag == 0 then
				paznos_recheck_flag = event.get_save_flag(540) or paznos_recheck_flag
				if paznos_recheck_flag == 0 then
					gaspard_defeated_recheck_flag = event.get_save_flag(536) or gaspard_defeated_recheck_flag
					if gaspard_defeated_recheck_flag == 0 then
						fire_squall_defeated_flag = event.get_save_flag(520) or fire_squall_defeated_flag
						if fire_squall_defeated_flag == 0 then
							event.open_message_window_2(
								0,
								"Bien. En primer lugar,\nten[UNI00e9]is que destruir la Tromba de fuego.<page>Si no hacemos algo\npara parar la lluvia de fuego,\nHeim Rada est[UNI00e1] acabada."
							)
						else
							event.open_message_window_2(
								0,
								"Bueno, pues ya est[UNI00e1]. Deber[UNI00ed]amos\nestar contentos de que\nla Tromba de fuego haya terminado."
							)
							cutscene.face_each_other(player_slot, villager_id, 0)
							message.say_bubble(0, -1, villager_id, player_slot, 0)
							closing_mode = 1
							event.open_message_window_2(
								0,
								"Pero estoy preocupado por tu amigo\nque cay[UNI00f3] al cr[UNI00e1]ter.<page>Imagino que lo [UNI00fa]nico que podemos hacer\nes reconstruir Heim Rada y hacer\nque el Taller sea mejor que antes."
							)
						end
					else
						event.open_message_window_2(
							0,
							"[UNI00a1]Hab[UNI00e9]is vencido a Gaspar!\nChicos, sois fant[UNI00e1]sticos.<page>Ahora le toca el turno a su jefe, el Emperador Griffon.\n[UNI00a1]Acabad con esto de una vez!"
						)
					end
				else
					event.open_message_window_2(
						0,
						"Qu[UNI00e9] alegr[UNI00ed]a me dio ver a Paznos en acci[UNI00f3]n.\nSe me ca[UNI00ed]an las l[UNI00e1]grimas.<page>Todo el esfuerzo que hemos invertido ha\nvalido la pena."
					)
				end
			else
				event.open_message_window_2(0, "[UNI00bf]Gema? Umm, lo siento pero no\ntengo ni idea de eso.")
			end
		else
			event.open_message_window_2(
				0,
				"Ha llegado la hora de v[UNI00e9]rselas con Griffon, [UNI00bf]eh?\nBuena suerte. [UNI00a1]A por [UNI00e9]l!"
			)
		end
	end
	if villager_type == 402 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Hola! Tenemos un mont[UNI00f3]n de cosas\npara vosotros. [UNI00bf]Qu[UNI00e9] os pongo?"
		)
	end
	if villager_type == 403 then
		event.open_message_window_2(0, "P[UNI00ed]deme lo que sea. Cualquier pieza\nque busques, yo la tengo fijo.")
	end
	if villager_type == 404 then
		event.open_message_window_2(
			0,
			"El combate es todo un arte. No\npuedes meterte de\ncabeza en medio de un tiroteo.<page>Si quieres portarte como un campe[UNI00f3]n,\ntendr[UNI00e1]s que usar objetos. Busca las debilidades del\nenemigo y expl[UNI00f3]talas."
		)
	end
	if villager_type == 405 then
		event.open_message_window_2(0, "En el Taller de Gundorada\ntodo es posible. Sea lo\nque sea, podemos hacerlo.")
	end
	if villager_type == 406 then
		event.open_message_window_2(
			0,
			"Eh, [UNI00bf]c[UNI00f3]mo hab[UNI00e9]is llegado hasta aqu[UNI00ed]?\nTened cuidado,\nesto es peligroso."
		)
	end
	if villager_type == 407 then
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] ha ocurrido en este\ntiempo? No me acuerdo de\nnada.")
	end
	if villager_type == 408 then
		event.open_message_window_2(0, "O sea que Griffon ha acabado con nosotros.\nQu[UNI00e9] pedazo de monstruo tiene que ser.")
	end
	if villager_type == 409 then
		event.open_message_window_2(0, "Tengo cosas que hacer.\nApartaos de mi camino, por favor.")
	end
	if villager_type == 410 then
		event.open_message_window_2(0, "Todos te animamos.\nEstamos contigo al 100%.")
	end
	if villager_type == 411 then
		event.open_message_window_2(
			0,
			"Las armas de\nesta caja\nno se venden.<page>Hay armas extra[UNI00f1]as\ny bonitas en el\nmundo, de todas formas..."
		)
	end
	if villager_type == 412 then
		event.open_message_window_2(
			0,
			"[UNI00bf]O sea que el Gaspar ese puede\ndesatar la Tromba de fuego?<page>No es que sea astuto...\nEs malo de verdad."
		)
	end
	if villager_type == 413 then
		event.open_message_window_2(
			0,
			"Qu[UNI00e9] es ese coraz[UNI00f3]n\nque hay en el signo... <page>No me gusta nada,\ntodo sea dicho."
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
	if villager_type == 402 then
		menu.open_type_6_alt(30)
	end
	if villager_type == 403 then
		menu.open_type_6_alt(28)
	end
	if villager_type == 404 then
		menu.open_type_6_alt(29)
	end
end

return workshop_villagers
