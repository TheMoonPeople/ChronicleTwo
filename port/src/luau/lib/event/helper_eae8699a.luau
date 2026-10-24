--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a61838c = require("@lib/event/helper_0a61838c")
local helper_0b998b84 = require("@lib/event/helper_0b998b84")
local helper_183adbb5 = require("@lib/event/helper_183adbb5")
local helper_1d314451 = require("@lib/event/helper_1d314451")
local helper_2000dbd9 = require("@lib/event/helper_2000dbd9")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2625cecd = require("@lib/event/helper_2625cecd")
local helper_320a7f61 = require("@lib/event/helper_320a7f61")
local helper_4680a022 = require("@lib/event/helper_4680a022")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_5e2e56ca = require("@lib/event/helper_5e2e56ca")
local helper_6fd9406e = require("@lib/event/helper_6fd9406e")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_92cbe42c = require("@lib/event/helper_92cbe42c")
local helper_9f1ffa9a = require("@lib/event/helper_9f1ffa9a")
local helper_9f36a6d1 = require("@lib/event/helper_9f36a6d1")
local helper_c17fe7b7 = require("@lib/event/helper_c17fe7b7")
local helper_c2014886 = require("@lib/event/helper_c2014886")
local helper_cde8a121 = require("@lib/event/helper_cde8a121")
local helper_d890bbad = require("@lib/event/helper_d890bbad")
local helper_e0c1e277 = require("@lib/event/helper_e0c1e277")
local helper_e20fb83e = require("@lib/event/helper_e20fb83e")
local helper_e283da4e = require("@lib/event/helper_e283da4e")
local helper_e5bae155 = require("@lib/event/helper_e5bae155")
local helper_faa89135 = require("@lib/event/helper_faa89135")

--- Helper function.
local function helper_eae8699a(arg0: s32, arg1: s32)
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
		helper_1d314451(arg0, arg1)
	end
	if var3 == 5 then
		helper_d890bbad(arg0, arg1)
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
				if helper_320a7f61(0) ~= 0 then
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
				if helper_320a7f61(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_e5bae155(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_6fd9406e(arg0, arg1)
	end
	if var3 == 8 then
		helper_c17fe7b7(arg0, arg1)
	end
	if var3 == 10 then
		helper_92cbe42c(arg0, arg1)
	end
	if var3 == 11 then
		helper_2000dbd9(arg0, arg1)
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
				helper_0b998b84(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_c2014886()
		else
			helper_0b998b84(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_0a61838c(arg0, arg1)
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
				helper_9f36a6d1(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_c2014886()
		else
			helper_9f36a6d1(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_e20fb83e(arg0, arg1)
	end
	if var3 == 17 then
		helper_faa89135(arg0, arg1)
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
				helper_5e2e56ca(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_c2014886()
		else
			helper_5e2e56ca(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_183adbb5(arg0, arg1)
	end
	if var3 == 20 then
		helper_2625cecd(arg0, arg1)
	end
	if var3 == 21 then
		helper_e283da4e(arg0, arg1)
	end
	if var3 == 23 then
		helper_9f1ffa9a(arg0, arg1)
	end
	if var3 == 24 then
		helper_e0c1e277(arg0, arg1)
	end
	if var3 == 25 then
		helper_4680a022(arg0, arg1)
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

return helper_eae8699a
