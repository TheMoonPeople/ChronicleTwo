--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b3fc698 = require("@lib/event/helper_2b3fc698")
local helper_92866686 = require("@lib/event/helper_92866686")
local helper_afa3edbd = require("@lib/event/helper_afa3edbd")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_c54edef2 = require("@lib/event/helper_c54edef2")

--- Helper function.
local function helper_99392a7a()
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
			helper_92866686(player_chara_2, var20)
		end
		if at <= 5 then
			helper_b8950300(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_c54edef2(30)
		end
		if at <= 7 then
			helper_c54edef2(28)
		end
		if at <= 8 then
			helper_c54edef2(29)
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
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"Gaspar es un adversario terrible.\nNo bajes la guardia ni\nun momento.<page>S[UNI00e9] que puedes derrotarle.\nLa Atlamillia te eligi[UNI00f3] por\nalgo..."
						)
					else
						event.MesMake_2(
							0,
							"Es verdad, Gaspar tambi[UNI00e9]n era infeliz.<page>[UNI00bf]Qu[UNI00e9] pretender[UNI00e1] Griffon\nmeti[UNI00e9]ndose con gente de dos [UNI00e9]pocas?"
						)
					end
				else
					event.MesMake_2(
						0,
						"Estoy seguro de que si alguien\npuede derrotar a Griffon, sois vosotros.<page>Confiamos en vosotros."
					)
				end
			else
				event.MesMake_2(
					0,
					"La Uni[UNI00f3]n Cronol[UNI00f3]gica... Entonces, la sabidur[UNI00ed]a\nde los ancianos salvar[UNI00e1]\nel mundo..."
				)
			end
		else
			event.MesMake_2(
				0,
				"Con esta va la vencida. Muchos amigos\nhan derramado su sangre en\nla lucha contra Griffon...<page>[UNI00a1]Sois nuestra [UNI00fa]ltima esperanza!\nConf[UNI00ed]o en vosotros. [UNI00a1]Ten[UNI00e9]is que\nderrotar a Griffon!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"Bien. En primer lugar,\nten[UNI00e9]is que destruir la Tromba de fuego.<page>Si no hacemos algo\npara parar la lluvia de fuego,\nHeim Rada est[UNI00e1] acabada."
							)
						else
							event.MesMake_2(
								0,
								"Bueno, pues ya est[UNI00e1]. Deber[UNI00ed]amos\nestar contentos de que\nla Tromba de fuego haya terminado."
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
								"Pero estoy preocupado por tu amigo\nque cay[UNI00f3] al cr[UNI00e1]ter.<page>Imagino que lo [UNI00fa]nico que podemos hacer\nes reconstruir Heim Rada y hacer\nque el Taller sea mejor que antes."
							)
						end
					else
						event.MesMake_2(
							0,
							"[UNI00a1]Hab[UNI00e9]is vencido a Gaspar!\nChicos, sois fant[UNI00e1]sticos.<page>Ahora le toca el turno a su jefe, el Emperador Griffon.\n[UNI00a1]Acabad con esto de una vez!"
						)
					end
				else
					event.MesMake_2(
						0,
						"Qu[UNI00e9] alegr[UNI00ed]a me dio ver a Paznos en acci[UNI00f3]n.\nSe me ca[UNI00ed]an las l[UNI00e1]grimas.<page>Todo el esfuerzo que hemos invertido ha\nvalido la pena."
					)
				end
			else
				event.MesMake_2(0, "[UNI00bf]Gema? Umm, lo siento pero no\ntengo ni idea de eso.")
			end
		else
			event.MesMake_2(
				0,
				"Ha llegado la hora de v[UNI00e9]rselas con Griffon, [UNI00bf]eh?\nBuena suerte. [UNI00a1]A por [UNI00e9]l!"
			)
		end
	end
	if var2 == 402 then
		event.MesMake_2(
			0,
			"[UNI00a1]Hola! Tenemos un mont[UNI00f3]n de cosas\npara vosotros. [UNI00bf]Qu[UNI00e9] os pongo?"
		)
	end
	if var2 == 403 then
		event.MesMake_2(0, "P[UNI00ed]deme lo que sea. Cualquier pieza\nque busques, yo la tengo fijo.")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"El combate es todo un arte. No\npuedes meterte de\ncabeza en medio de un tiroteo.<page>Si quieres portarte como un campe[UNI00f3]n,\ntendr[UNI00e1]s que usar objetos. Busca las debilidades del\nenemigo y expl[UNI00f3]talas."
		)
	end
	if var2 == 405 then
		event.MesMake_2(0, "En el Taller de Gundorada\ntodo es posible. Sea lo\nque sea, podemos hacerlo.")
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"Eh, [UNI00bf]c[UNI00f3]mo hab[UNI00e9]is llegado hasta aqu[UNI00ed]?\nTened cuidado,\nesto es peligroso."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] ha ocurrido en este\ntiempo? No me acuerdo de\nnada.")
	end
	if var2 == 408 then
		event.MesMake_2(0, "O sea que Griffon ha acabado con nosotros.\nQu[UNI00e9] pedazo de monstruo tiene que ser.")
	end
	if var2 == 409 then
		event.MesMake_2(0, "Tengo cosas que hacer.\nApartaos de mi camino, por favor.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "Todos te animamos.\nEstamos contigo al 100%.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Las armas de\nesta caja\nno se venden.<page>Hay armas extra[UNI00f1]as\ny bonitas en el\nmundo, de todas formas..."
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"[UNI00bf]O sea que el Gaspar ese puede\ndesatar la Tromba de fuego?<page>No es que sea astuto...\nEs malo de verdad."
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"Qu[UNI00e9] es ese coraz[UNI00f3]n\nque hay en el signo... <page>No me gusta nada,\ntodo sea dicho."
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
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_92866686(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b8950300(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_c54edef2(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_c54edef2(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_c54edef2(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

return helper_99392a7a
