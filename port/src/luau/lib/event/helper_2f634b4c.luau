--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0aceb7cd = require("@lib/event/helper_0aceb7cd")
local helper_180ab6ea = require("@lib/event/helper_180ab6ea")
local helper_20840539 = require("@lib/event/helper_20840539")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_301641fe = require("@lib/event/helper_301641fe")
local helper_33f6b360 = require("@lib/event/helper_33f6b360")
local helper_3596e01d = require("@lib/event/helper_3596e01d")
local helper_36257792 = require("@lib/event/helper_36257792")
local helper_484643e4 = require("@lib/event/helper_484643e4")
local helper_4cf73d28 = require("@lib/event/helper_4cf73d28")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_632104df = require("@lib/event/helper_632104df")
local helper_70dad2d3 = require("@lib/event/helper_70dad2d3")
local helper_7a73586f = require("@lib/event/helper_7a73586f")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_9b89649b = require("@lib/event/helper_9b89649b")
local helper_a8fe2988 = require("@lib/event/helper_a8fe2988")
local helper_bd07bb63 = require("@lib/event/helper_bd07bb63")
local helper_c3d46ae1 = require("@lib/event/helper_c3d46ae1")
local helper_caf7a073 = require("@lib/event/helper_caf7a073")
local helper_daafd17c = require("@lib/event/helper_daafd17c")
local helper_de36343d = require("@lib/event/helper_de36343d")
local helper_df177641 = require("@lib/event/helper_df177641")
local helper_df1e3fc0 = require("@lib/event/helper_df1e3fc0")
local helper_fc9ca1c3 = require("@lib/event/helper_fc9ca1c3")

--- Helper function.
local function helper_2f634b4c(arg0: s32, arg1: s32)
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
		helper_caf7a073(arg0, arg1)
	end
	if var3 == 5 then
		helper_0aceb7cd(arg0, arg1)
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				if helper_484643e4(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(6)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_daafd17c()
			end
		else
			event.MesMake_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				if helper_484643e4(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_a8fe2988(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_70dad2d3(arg0, arg1)
	end
	if var3 == 8 then
		helper_df177641(arg0, arg1)
	end
	if var3 == 10 then
		helper_20840539(arg0, arg1)
	end
	if var3 == 11 then
		helper_df1e3fc0(arg0, arg1)
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_9b89649b(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_daafd17c()
		else
			helper_9b89649b(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_33f6b360(arg0, arg1)
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_7a73586f(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_daafd17c()
		else
			helper_7a73586f(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_c3d46ae1(arg0, arg1)
	end
	if var3 == 17 then
		helper_301641fe(arg0, arg1)
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_de36343d(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_daafd17c()
		else
			helper_de36343d(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_fc9ca1c3(arg0, arg1)
	end
	if var3 == 20 then
		helper_36257792(arg0, arg1)
	end
	if var3 == 21 then
		helper_4cf73d28(arg0, arg1)
	end
	if var3 == 23 then
		helper_3596e01d(arg0, arg1)
	end
	if var3 == 24 then
		helper_180ab6ea(arg0, arg1)
	end
	if var3 == 25 then
		helper_bd07bb63(arg0, arg1)
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_632104df(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		helper_daafd17c()
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.MesMake_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.MesMake_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.MesMake_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.MesMake_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.MesMake_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	event.SetAi(1, arg0)
end

return helper_2f634b4c
