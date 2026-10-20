--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09a8b82f = require("@lib/event/helper_09a8b82f")
local helper_14e8dd3e = require("@lib/event/helper_14e8dd3e")
local helper_1ac9ff30 = require("@lib/event/helper_1ac9ff30")
local helper_1e7bfebe = require("@lib/event/helper_1e7bfebe")
local helper_223a6c9b = require("@lib/event/helper_223a6c9b")
local helper_2aaa0ced = require("@lib/event/helper_2aaa0ced")
local helper_3314d96e = require("@lib/event/helper_3314d96e")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_5515f51f = require("@lib/event/helper_5515f51f")
local helper_597cd5f7 = require("@lib/event/helper_597cd5f7")
local helper_5d471bd3 = require("@lib/event/helper_5d471bd3")
local helper_601370c4 = require("@lib/event/helper_601370c4")
local helper_62ab596d = require("@lib/event/helper_62ab596d")
local helper_6c2df9e9 = require("@lib/event/helper_6c2df9e9")
local helper_79472a56 = require("@lib/event/helper_79472a56")
local helper_79d8c095 = require("@lib/event/helper_79d8c095")
local helper_891a7e7b = require("@lib/event/helper_891a7e7b")
local helper_927ca5f6 = require("@lib/event/helper_927ca5f6")
local helper_97fe1f78 = require("@lib/event/helper_97fe1f78")
local helper_a11a83f8 = require("@lib/event/helper_a11a83f8")
local helper_ae9f7c2f = require("@lib/event/helper_ae9f7c2f")
local helper_c353b7a8 = require("@lib/event/helper_c353b7a8")
local helper_d37f73f8 = require("@lib/event/helper_d37f73f8")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_f1c92cbc = require("@lib/event/helper_f1c92cbc")
local helper_f39cfbfe = require("@lib/event/helper_f39cfbfe")

--- Helper function.
local function helper_1504f4a3(arg0: s32, arg1: s32)
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_62ab596d(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_3314d96e(arg0, arg1)
			end
			if at <= 13 then
				helper_ae9f7c2f(arg0, arg1)
			end
			if at <= 14 then
				helper_14e8dd3e(arg0, arg1)
			end
			if at <= 15 then
				helper_601370c4(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_d37f73f8(arg0, arg1)
			end
			if at <= 20 then
				helper_c353b7a8(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_a11a83f8(arg0, arg1)
			end
			if at <= 25 then
				helper_97fe1f78(arg0, arg1)
			end
			if at <= 26 then
				helper_09a8b82f(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_927ca5f6(arg0, arg1)
			end
			if at <= 31 then
				helper_2aaa0ced(arg0, arg1)
			end
			if at <= 32 then
				helper_6c2df9e9(arg0, arg1)
			end
			if at <= 33 then
				helper_1ac9ff30(arg0, arg1)
			end
			if at <= 34 then
				helper_5d471bd3(arg0, arg1)
			end
			if at <= 35 then
				helper_891a7e7b(arg0, arg1)
			end
			if at <= 36 then
				helper_597cd5f7(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_5515f51f(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_62ab596d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_1e7bfebe(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_e2203e72(30)
					if vm.skipping() then
						return skip(5)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(6)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_f1c92cbc()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_1e7bfebe(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_e2203e72(30)
					if vm.skipping() then
						return skip(10)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(11)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_79d8c095(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_3314d96e(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_ae9f7c2f(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_14e8dd3e(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_601370c4(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_d37f73f8(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_f1c92cbc()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_d37f73f8(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_c353b7a8(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_a11a83f8(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_f1c92cbc()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_a11a83f8(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_97fe1f78(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_09a8b82f(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_927ca5f6(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_f1c92cbc()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_927ca5f6(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_2aaa0ced(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_6c2df9e9(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_1ac9ff30(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_5d471bd3(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_891a7e7b(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_597cd5f7(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_223a6c9b(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_f1c92cbc()
		if vm.skipping() then
			return skip(40)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

return helper_1504f4a3
