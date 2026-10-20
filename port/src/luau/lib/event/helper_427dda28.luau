--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_046d525c = require("@lib/event/helper_046d525c")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_427dda28()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_b33603c6(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_046d525c(15)
		end
		if at <= 3 then
			helper_046d525c(1)
		end
		if at <= 4 then
			helper_046d525c(6)
		end
		if at <= 5 then
			helper_046d525c(0)
		end
		if at <= 6 then
			helper_046d525c(4)
		end
		if at <= 7 then
			helper_046d525c(31)
		end
		if at <= 8 then
			helper_046d525c(35)
		end
		if at <= 9 then
			helper_046d525c(36)
		end
		if at <= 10 then
			helper_046d525c(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bienvenido.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Trabajando duro, [UNI00bf]no?\n[UNI00bf]Necesit[UNI00e1]is algo?<page>Pero por la cara, nada.\nNi siquiera para ti, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"[UNI00bf]Necesitas m[UNI00e1]s elementos\nde Georama?<page>Si no tienes tiempo\npara conseguirlos t[UNI00fa] mismo, a lo mejor\npuedes solucionar tus problemas con un poco de dinero."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hola. Soy un aprendiz de panadero.\nMe encargo de la panader[UNI00ed]a mientras\nPolly est[UNI00e1] fuera.<page>Estoy un poco nervioso, pero es\nparte de mi formaci[UNI00f3]n, supongo.\n[UNI00a1]Har[UNI00e9] lo que pueda!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"No nos parecemos mucho...\nPero soy la hermana peque[UNI00f1]a de Milane.<page>Me pidi[UNI00f3] que cuidara de la tienda mientras ella no est[UNI00e1].\n[UNI00a1]Yo no s[UNI00e9] nada de armas!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Te he sorprendido, a que s[UNI00ed]? Cualquiera se sorprender[UNI00ed]a\nal ver a alguien\nvestido de esta manera aqu[UNI00ed].<page>Soy un buen amigo del Padre Bruno. Estoy\npara informar a la gente mientras [UNI00e9]l est[UNI00e1] de viaje.\nBueno, [UNI00bf]te puedo ayudar en algo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
			)
		end
	end
	if var1 ~= -1 then
		helper_b33603c6(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_046d525c(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_046d525c(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_046d525c(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_046d525c(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_046d525c(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_046d525c(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_046d525c(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_046d525c(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_046d525c(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

return helper_427dda28
