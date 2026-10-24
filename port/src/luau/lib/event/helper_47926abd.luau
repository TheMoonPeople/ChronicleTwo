--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00773c81 = require("@lib/event/helper_00773c81")
local helper_0b064184 = require("@lib/event/helper_0b064184")
local helper_14e43a9b = require("@lib/event/helper_14e43a9b")
local helper_25351458 = require("@lib/event/helper_25351458")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_375e57b3 = require("@lib/event/helper_375e57b3")
local helper_45ddfee9 = require("@lib/event/helper_45ddfee9")
local helper_4f10998a = require("@lib/event/helper_4f10998a")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_602ad1af = require("@lib/event/helper_602ad1af")
local helper_6216a83a = require("@lib/event/helper_6216a83a")
local helper_6b0dbb8f = require("@lib/event/helper_6b0dbb8f")
local helper_74b706ae = require("@lib/event/helper_74b706ae")
local helper_77464c6c = require("@lib/event/helper_77464c6c")
local helper_78a96380 = require("@lib/event/helper_78a96380")
local helper_7adf849a = require("@lib/event/helper_7adf849a")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_a6f301bd = require("@lib/event/helper_a6f301bd")
local helper_ac447808 = require("@lib/event/helper_ac447808")
local helper_aedd1be5 = require("@lib/event/helper_aedd1be5")
local helper_b234173d = require("@lib/event/helper_b234173d")
local helper_b49f2b6a = require("@lib/event/helper_b49f2b6a")
local helper_e2eeda09 = require("@lib/event/helper_e2eeda09")
local helper_ec27826a = require("@lib/event/helper_ec27826a")
local helper_fd8e2fbb = require("@lib/event/helper_fd8e2fbb")

--- Helper function.
local function helper_47926abd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_6216a83a(arg0, arg1)
	end
	if var3 == 5 then
		helper_b49f2b6a(arg0, arg1)
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				if helper_375e57b3(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(6)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_aedd1be5()
			end
		else
			event.MesMake_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				if helper_375e57b3(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_45ddfee9(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_fd8e2fbb(arg0, arg1)
	end
	if var3 == 8 then
		helper_0b064184(arg0, arg1)
	end
	if var3 == 10 then
		helper_a6f301bd(arg0, arg1)
	end
	if var3 == 11 then
		helper_e2eeda09(arg0, arg1)
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_77464c6c(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_aedd1be5()
		else
			helper_77464c6c(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_14e43a9b(arg0, arg1)
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_ec27826a(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_aedd1be5()
		else
			helper_ec27826a(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_78a96380(arg0, arg1)
	end
	if var3 == 17 then
		helper_ac447808(arg0, arg1)
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_b234173d(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_aedd1be5()
		else
			helper_b234173d(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_4f10998a(arg0, arg1)
	end
	if var3 == 20 then
		helper_602ad1af(arg0, arg1)
	end
	if var3 == 21 then
		helper_00773c81(arg0, arg1)
	end
	if var3 == 23 then
		helper_25351458(arg0, arg1)
	end
	if var3 == 24 then
		helper_6b0dbb8f(arg0, arg1)
	end
	if var3 == 25 then
		helper_7adf849a(arg0, arg1)
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_74b706ae(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		helper_aedd1be5()
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.MesMake_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.MesMake_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.MesMake_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.MesMake_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.MesMake_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	event.SetAi(1, arg0)
end

return helper_47926abd
