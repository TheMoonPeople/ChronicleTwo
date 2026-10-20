--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09f03e07 = require("@lib/event/helper_09f03e07")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_135c47c2 = require("@lib/event/helper_135c47c2")
local helper_338c09af = require("@lib/event/helper_338c09af")
local helper_36b4b27c = require("@lib/event/helper_36b4b27c")
local helper_36bc4ca6 = require("@lib/event/helper_36bc4ca6")
local helper_417760a7 = require("@lib/event/helper_417760a7")
local helper_4413bb92 = require("@lib/event/helper_4413bb92")
local helper_56839ab3 = require("@lib/event/helper_56839ab3")
local helper_614e6a96 = require("@lib/event/helper_614e6a96")
local helper_66015f0b = require("@lib/event/helper_66015f0b")
local helper_6ed96194 = require("@lib/event/helper_6ed96194")
local helper_782657f7 = require("@lib/event/helper_782657f7")
local helper_8fec6047 = require("@lib/event/helper_8fec6047")
local helper_9239d177 = require("@lib/event/helper_9239d177")
local helper_97e40e9b = require("@lib/event/helper_97e40e9b")
local helper_9817d359 = require("@lib/event/helper_9817d359")
local helper_9cbf7600 = require("@lib/event/helper_9cbf7600")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b370ce8a = require("@lib/event/helper_b370ce8a")
local helper_c17a8778 = require("@lib/event/helper_c17a8778")
local helper_c729682a = require("@lib/event/helper_c729682a")
local helper_dfb95bfd = require("@lib/event/helper_dfb95bfd")
local helper_ee2fed44 = require("@lib/event/helper_ee2fed44")
local helper_ef3dadd9 = require("@lib/event/helper_ef3dadd9")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_007c5a3d(arg0: s32, arg1: s32)
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
				helper_dfb95bfd(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_4413bb92(arg0, arg1)
			end
			if at <= 13 then
				helper_c17a8778(arg0, arg1)
			end
			if at <= 14 then
				helper_b370ce8a(arg0, arg1)
			end
			if at <= 15 then
				helper_9cbf7600(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_782657f7(arg0, arg1)
			end
			if at <= 20 then
				helper_97e40e9b(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_417760a7(arg0, arg1)
			end
			if at <= 25 then
				helper_6ed96194(arg0, arg1)
			end
			if at <= 26 then
				helper_c729682a(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_9817d359(arg0, arg1)
			end
			if at <= 31 then
				helper_8fec6047(arg0, arg1)
			end
			if at <= 32 then
				helper_614e6a96(arg0, arg1)
			end
			if at <= 33 then
				helper_9239d177(arg0, arg1)
			end
			if at <= 34 then
				helper_09f03e07(arg0, arg1)
			end
			if at <= 35 then
				helper_338c09af(arg0, arg1)
			end
			if at <= 36 then
				helper_ef3dadd9(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_f1049565(arg0, -1, 0, 0)
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
		helper_66015f0b(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_dfb95bfd(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Fammi far compere\nIndaga per uno scoop")
			var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_56839ab3(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
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
				helper_135c47c2()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Benvenuto!\nIndaga per uno scoop")
			var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_56839ab3(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
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
				helper_36bc4ca6(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_4413bb92(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_c17a8778(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_b370ce8a(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_9cbf7600(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_782657f7(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_782657f7(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_97e40e9b(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_417760a7(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_417760a7(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_6ed96194(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_c729682a(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_9817d359(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_9817d359(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_8fec6047(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_614e6a96(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_9239d177(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_09f03e07(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_338c09af(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_ef3dadd9(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Fammi far compere\nSalve")
			var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_36b4b27c(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_135c47c2()
		if vm.skipping() then
			return skip(40)
		end
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
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
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
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.MesMake_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
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
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.MesMake_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

return helper_007c5a3d
