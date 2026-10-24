--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08e3bc45 = require("@lib/event/helper_08e3bc45")
local helper_0ae8bdf0 = require("@lib/event/helper_0ae8bdf0")
local helper_0fce3b5a = require("@lib/event/helper_0fce3b5a")
local helper_1f70aa33 = require("@lib/event/helper_1f70aa33")
local helper_238797ef = require("@lib/event/helper_238797ef")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2ff93f04 = require("@lib/event/helper_2ff93f04")
local helper_46a5de77 = require("@lib/event/helper_46a5de77")
local helper_533c8884 = require("@lib/event/helper_533c8884")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_619faa72 = require("@lib/event/helper_619faa72")
local helper_66f33418 = require("@lib/event/helper_66f33418")
local helper_6d8bd987 = require("@lib/event/helper_6d8bd987")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_b696959f = require("@lib/event/helper_b696959f")
local helper_c2014886 = require("@lib/event/helper_c2014886")
local helper_cde8a121 = require("@lib/event/helper_cde8a121")
local helper_ded1ddaf = require("@lib/event/helper_ded1ddaf")
local helper_e6a92440 = require("@lib/event/helper_e6a92440")
local helper_edbc1b3c = require("@lib/event/helper_edbc1b3c")
local helper_eeefbce8 = require("@lib/event/helper_eeefbce8")
local helper_f486f8d0 = require("@lib/event/helper_f486f8d0")
local helper_f4ac04ae = require("@lib/event/helper_f4ac04ae")
local helper_f7f87dc4 = require("@lib/event/helper_f7f87dc4")
local helper_fe7d0734 = require("@lib/event/helper_fe7d0734")

--- Helper function.
local function helper_7f3f7d1d(arg0: s32, arg1: s32)
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
		helper_b696959f(arg0, arg1)
	end
	if var3 == 5 then
		helper_f4ac04ae(arg0, arg1)
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Fammi far compere\nIndaga per uno scoop")
			var7 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				if helper_238797ef(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(6)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_c2014886()
			end
		else
			event.MesMake_2(0, "Benvenuto!\nIndaga per uno scoop")
			var8 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				if helper_238797ef(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_edbc1b3c(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_1f70aa33(arg0, arg1)
	end
	if var3 == 8 then
		helper_fe7d0734(arg0, arg1)
	end
	if var3 == 10 then
		helper_0fce3b5a(arg0, arg1)
	end
	if var3 == 11 then
		helper_619faa72(arg0, arg1)
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var11 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_46a5de77(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_c2014886()
		else
			helper_46a5de77(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_0ae8bdf0(arg0, arg1)
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var14 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_08e3bc45(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_c2014886()
		else
			helper_08e3bc45(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_f7f87dc4(arg0, arg1)
	end
	if var3 == 17 then
		helper_6d8bd987(arg0, arg1)
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var17 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_f486f8d0(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_c2014886()
		else
			helper_f486f8d0(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_533c8884(arg0, arg1)
	end
	if var3 == 20 then
		helper_ded1ddaf(arg0, arg1)
	end
	if var3 == 21 then
		helper_eeefbce8(arg0, arg1)
	end
	if var3 == 23 then
		helper_2ff93f04(arg0, arg1)
	end
	if var3 == 24 then
		helper_e6a92440(arg0, arg1)
	end
	if var3 == 25 then
		helper_66f33418(arg0, arg1)
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Fammi far compere\nSalve")
			var20 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_cde8a121(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		helper_c2014886()
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Ultimamente faccio fatica\na vedere le cose piccole.<page>Mmmh... sto\ninvecchiando...")
		else
			event.MesMake_2(
				0,
				"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Se non tengo le mani\ncontinuamente occupate,\nvado fuori di testa!")
		else
			event.MesMake_2(
				0,
				"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.MesMake_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
			)
		else
			event.MesMake_2(0, "Ti piace proprio\nl'avventura, eh?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.MesMake_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	event.SetAi(1, arg0)
end

return helper_7f3f7d1d
