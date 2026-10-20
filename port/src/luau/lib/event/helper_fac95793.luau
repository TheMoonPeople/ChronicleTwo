--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_200b59e0 = require("@lib/event/helper_200b59e0")
local helper_2085f9ae = require("@lib/event/helper_2085f9ae")
local helper_2c9d3fe2 = require("@lib/event/helper_2c9d3fe2")
local helper_346f57cb = require("@lib/event/helper_346f57cb")
local helper_38dbefca = require("@lib/event/helper_38dbefca")
local helper_3d05eb42 = require("@lib/event/helper_3d05eb42")
local helper_3d4f36c4 = require("@lib/event/helper_3d4f36c4")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_47e881ba = require("@lib/event/helper_47e881ba")
local helper_4a2e3d00 = require("@lib/event/helper_4a2e3d00")
local helper_50ef85e4 = require("@lib/event/helper_50ef85e4")
local helper_53011591 = require("@lib/event/helper_53011591")
local helper_79472a56 = require("@lib/event/helper_79472a56")
local helper_79482576 = require("@lib/event/helper_79482576")
local helper_7b799235 = require("@lib/event/helper_7b799235")
local helper_7c955bd0 = require("@lib/event/helper_7c955bd0")
local helper_8b633d82 = require("@lib/event/helper_8b633d82")
local helper_8bd33ad1 = require("@lib/event/helper_8bd33ad1")
local helper_902c54f5 = require("@lib/event/helper_902c54f5")
local helper_99e1b962 = require("@lib/event/helper_99e1b962")
local helper_a94740a4 = require("@lib/event/helper_a94740a4")
local helper_c7525334 = require("@lib/event/helper_c7525334")
local helper_d6b99e41 = require("@lib/event/helper_d6b99e41")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_f39cfbfe = require("@lib/event/helper_f39cfbfe")
local helper_f4babe06 = require("@lib/event/helper_f4babe06")

--- Helper function.
local function helper_fac95793(arg0: s32, arg1: s32)
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
				helper_7b799235(arg0, arg1)
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
				helper_3d05eb42(arg0, arg1)
			end
			if at <= 13 then
				helper_99e1b962(arg0, arg1)
			end
			if at <= 14 then
				helper_902c54f5(arg0, arg1)
			end
			if at <= 15 then
				helper_f4babe06(arg0, arg1)
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
				helper_47e881ba(arg0, arg1)
			end
			if at <= 20 then
				helper_50ef85e4(arg0, arg1)
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
				helper_79482576(arg0, arg1)
			end
			if at <= 25 then
				helper_c7525334(arg0, arg1)
			end
			if at <= 26 then
				helper_2085f9ae(arg0, arg1)
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
				helper_200b59e0(arg0, arg1)
			end
			if at <= 31 then
				helper_8b633d82(arg0, arg1)
			end
			if at <= 32 then
				helper_4a2e3d00(arg0, arg1)
			end
			if at <= 33 then
				helper_8bd33ad1(arg0, arg1)
			end
			if at <= 34 then
				helper_53011591(arg0, arg1)
			end
			if at <= 35 then
				helper_346f57cb(arg0, arg1)
			end
			if at <= 36 then
				helper_d6b99e41(arg0, arg1)
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
		helper_7c955bd0(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_7b799235(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_38dbefca(0)
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
				helper_2c9d3fe2()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_38dbefca(0)
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
				helper_a94740a4(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_3d05eb42(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_99e1b962(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_902c54f5(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_f4babe06(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_47e881ba(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_2c9d3fe2()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_47e881ba(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_50ef85e4(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_79482576(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_2c9d3fe2()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_79482576(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_c7525334(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_2085f9ae(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_200b59e0(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_2c9d3fe2()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_200b59e0(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_8b633d82(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_4a2e3d00(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_8bd33ad1(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_53011591(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_346f57cb(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_d6b99e41(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_3d4f36c4(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_2c9d3fe2()
		if vm.skipping() then
			return skip(40)
		end
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
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
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
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.MesMake_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
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
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.MesMake_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
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
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.MesMake_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

return helper_fac95793
