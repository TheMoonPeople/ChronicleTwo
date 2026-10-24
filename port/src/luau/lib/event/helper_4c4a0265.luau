--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_aedd1be5 = require("@lib/event/helper_aedd1be5")

--- Helper function.
local function helper_4c4a0265()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_aedd1be5()
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "[UNI00a1]Eh! Prohibido\nel paso.")
		helper_899661d6(var1, -1, 0, 0)
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Mira. Cualquiera se cree\nque este trasto iba por ah[UNI00ed]\nzumbando, [UNI00bf]eh?<page>Pues as[UNI00ed] era... Hace mucho tiempo.<page>Mi sue[UNI00f1]o es volver a viajar\nen [UNI00e9]l. Por eso\nme preocupo de mantenerlo a punto.<page>As[UNI00ed], si alg[UNI00fa]n d[UNI00ed]a llega la ocasi[UNI00f3]n,\n lo pondr[UNI00e9] a funcionar\nen un periquete."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
				)
			end
			helper_899661d6(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"[UNI00a1]Max, hola!\nHace ya mucho\nque no circula el tren,<page>pero yo sigo vigilando\nla estaci[UNI00f3]n todos los d[UNI00ed]as."
				)
			else
				event.MesMake_2(
					0,
					"El alcalde levant[UNI00f3] por fin el trasero\nde la silla y puso en marcha los trenes otra vez. Pero\ntodav[UNI00ed]a no est[UNI00e1]n listos.<page>Ni te imaginas las ganas que tengo\nde que se monten los de la ciudad..."
				)
			end
			helper_899661d6(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hola, Max. [UNI00bf]Sab[UNI00ed]as que el jefe de la estaci[UNI00f3]n\nes mi padre? Vigilamos\njuntos la estaci[UNI00f3]n.<page>Hasta que el tren vuelva\na funcionar como antes..."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00a1]El tren ya funciona!\nPero todav[UNI00ed]a queda tiempo para\nque la estaci[UNI00f3]n vuelva a la normalidad..."
				)
			end
			helper_899661d6(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"He sido admirador secreto de\nM[UNI00f3]nica durante a[UNI00f1]os, pero\nno la hab[UNI00ed]a visto [UNI00fa]ltimamente.<page>Por eso no me\npuedo concentrar en el trabajo."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"[UNI00a1]Oye, Max!\nParece ser que M[UNI00f3]nica ha vuelto.\n[UNI00a1]Se va alegrar todo el mundo!"
					)
				else
					event.MesMake_2(
						0,
						"[UNI00a1]M[UNI00f3]nica! [UNI00bf]C[UNI00f3]mo te ha ido?\nTe he echado de menos."
					)
				end
			end
			helper_899661d6(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Estaba hablando\ncon ella  como siempre,\ny va y desaparece.<page>Max, dime:\n[UNI00bf]d[UNI00f3]nde est[UNI00e1]?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Ha vuelto M[UNI00f3]nica.\n[UNI00bf]C[UNI00f3]mo puede ser?")
				else
					event.MesMake_2(0, "M[UNI00f3]nica, has vuelto.\n[UNI00bf]C[UNI00f3]mo es posible?")
				end
			end
			helper_899661d6(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_899661d6(var1, -1, 0, 0)
	event.SetAi(1, var1)
end

return helper_4c4a0265
