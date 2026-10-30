--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_5c6fab98()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	var3 = 0
	if var2 == 400 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.get_save_flag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.get_save_flag(536) or flag_4
					if flag_4 == 0 then
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
	if var2 == 401 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.get_save_flag(520) or flag_9
						if flag_9 == 0 then
							event.open_message_window_2(
								0,
								"Bien. En primer lugar,\nten[UNI00e9]is que destruir la Tromba de fuego.<page>Si no hacemos algo\npara parar la lluvia de fuego,\nHeim Rada est[UNI00e1] acabada."
							)
						else
							event.open_message_window_2(
								0,
								"Bueno, pues ya est[UNI00e1]. Deber[UNI00ed]amos\nestar contentos de que\nla Tromba de fuego haya terminado."
							)
							helper_31bbf01d(player_chara, var1, 0)
							helper_0ffc2526(0, -1, var1, player_chara, 0)
							var3 = 1
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
	if var2 == 402 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Hola! Tenemos un mont[UNI00f3]n de cosas\npara vosotros. [UNI00bf]Qu[UNI00e9] os pongo?"
		)
	end
	if var2 == 403 then
		event.open_message_window_2(0, "P[UNI00ed]deme lo que sea. Cualquier pieza\nque busques, yo la tengo fijo.")
	end
	if var2 == 404 then
		event.open_message_window_2(
			0,
			"El combate es todo un arte. No\npuedes meterte de\ncabeza en medio de un tiroteo.<page>Si quieres portarte como un campe[UNI00f3]n,\ntendr[UNI00e1]s que usar objetos. Busca las debilidades del\nenemigo y expl[UNI00f3]talas."
		)
	end
	if var2 == 405 then
		event.open_message_window_2(0, "En el Taller de Gundorada\ntodo es posible. Sea lo\nque sea, podemos hacerlo.")
	end
	if var2 == 406 then
		event.open_message_window_2(
			0,
			"Eh, [UNI00bf]c[UNI00f3]mo hab[UNI00e9]is llegado hasta aqu[UNI00ed]?\nTened cuidado,\nesto es peligroso."
		)
	end
	if var2 == 407 then
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] ha ocurrido en este\ntiempo? No me acuerdo de\nnada.")
	end
	if var2 == 408 then
		event.open_message_window_2(0, "O sea que Griffon ha acabado con nosotros.\nQu[UNI00e9] pedazo de monstruo tiene que ser.")
	end
	if var2 == 409 then
		event.open_message_window_2(0, "Tengo cosas que hacer.\nApartaos de mi camino, por favor.")
	end
	if var2 == 410 then
		event.open_message_window_2(0, "Todos te animamos.\nEstamos contigo al 100%.")
	end
	if var2 == 411 then
		event.open_message_window_2(
			0,
			"Las armas de\nesta caja\nno se venden.<page>Hay armas extra[UNI00f1]as\ny bonitas en el\nmundo, de todas formas..."
		)
	end
	if var2 == 412 then
		event.open_message_window_2(
			0,
			"[UNI00bf]O sea que el Gaspar ese puede\ndesatar la Tromba de fuego?<page>No es que sea astuto...\nEs malo de verdad."
		)
	end
	if var2 == 413 then
		event.open_message_window_2(
			0,
			"Qu[UNI00e9] es ese coraz[UNI00f3]n\nque hay en el signo... <page>No me gusta nada,\ntodo sea dicho."
		)
	end
	if var3 == 0 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
	end
	if var3 == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		do
			local out1, _, out3 = event.get_character_position(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.get_look_angle(var17 - var14, var19 - var16) or var20
		helper_76f23193(player_chara_2, var20)
		event.set_character_rotation(player_chara_2, 0.0, var20, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
	if var2 == 402 then
		helper_59a16271(30)
	end
	if var2 == 403 then
		helper_59a16271(28)
	end
	if var2 == 404 then
		helper_59a16271(29)
	end
end

return helper_5c6fab98
