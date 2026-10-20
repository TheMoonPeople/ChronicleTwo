--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0aa78fba = require("@lib/event/helper_0aa78fba")
local helper_1a8c9e9e = require("@lib/event/helper_1a8c9e9e")
local helper_22ed3c29 = require("@lib/event/helper_22ed3c29")
local helper_2b963b7e = require("@lib/event/helper_2b963b7e")
local helper_34dde942 = require("@lib/event/helper_34dde942")
local helper_391d8410 = require("@lib/event/helper_391d8410")
local helper_3de905f7 = require("@lib/event/helper_3de905f7")
local helper_580810ee = require("@lib/event/helper_580810ee")
local helper_64b0c307 = require("@lib/event/helper_64b0c307")
local helper_65f16098 = require("@lib/event/helper_65f16098")
local helper_73329049 = require("@lib/event/helper_73329049")
local helper_75971e61 = require("@lib/event/helper_75971e61")
local helper_82e5a0b5 = require("@lib/event/helper_82e5a0b5")
local helper_8c72e4d3 = require("@lib/event/helper_8c72e4d3")
local helper_9dde08bd = require("@lib/event/helper_9dde08bd")
local helper_a1f7541d = require("@lib/event/helper_a1f7541d")
local helper_a3559941 = require("@lib/event/helper_a3559941")
local helper_ab5f473e = require("@lib/event/helper_ab5f473e")
local helper_afc674c9 = require("@lib/event/helper_afc674c9")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")
local helper_b6ded4eb = require("@lib/event/helper_b6ded4eb")
local helper_b760cdf1 = require("@lib/event/helper_b760cdf1")
local helper_bdf91484 = require("@lib/event/helper_bdf91484")
local helper_dbdd3bdb = require("@lib/event/helper_dbdd3bdb")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_fc91638c = require("@lib/event/helper_fc91638c")

--- Helper function.
local function helper_c2963624(arg0: s32, arg1: s32)
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
				helper_fc91638c(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_3de905f7(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_ed0a80b8(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_3de905f7(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_ed0a80b8(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_8c72e4d3(arg0, arg1)
			end
			if at <= 13 then
				helper_ab5f473e(arg0, arg1)
			end
			if at <= 14 then
				helper_1a8c9e9e(arg0, arg1)
			end
			if at <= 15 then
				helper_65f16098(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_9dde08bd(arg0, arg1)
			end
			if at <= 20 then
				helper_b760cdf1(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_580810ee(arg0, arg1)
			end
			if at <= 25 then
				helper_b6ded4eb(arg0, arg1)
			end
			if at <= 26 then
				helper_0aa78fba(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_bdf91484(arg0, arg1)
			end
			if at <= 31 then
				helper_a1f7541d(arg0, arg1)
			end
			if at <= 32 then
				helper_75971e61(arg0, arg1)
			end
			if at <= 33 then
				helper_34dde942(arg0, arg1)
			end
			if at <= 34 then
				helper_a3559941(arg0, arg1)
			end
			if at <= 35 then
				helper_22ed3c29(arg0, arg1)
			end
			if at <= 36 then
				helper_64b0c307(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_b33603c6(arg0, -1, 0, 0)
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
		helper_afc674c9(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_fc91638c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Lass mich einkaufen.\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var7 = helper_3de905f7(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_82e5a0b5(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_ed0a80b8(30)
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
				helper_73329049()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Sei mein Freund!\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var8 = helper_3de905f7(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_82e5a0b5(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_ed0a80b8(30)
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
				helper_dbdd3bdb(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_8c72e4d3(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_ab5f473e(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_1a8c9e9e(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_65f16098(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var11 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_9dde08bd(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_73329049()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_9dde08bd(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_b760cdf1(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var14 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_580810ee(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_73329049()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_580810ee(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_b6ded4eb(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_0aa78fba(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var17 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_bdf91484(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_73329049()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_bdf91484(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_a1f7541d(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_75971e61(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_34dde942(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_a3559941(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_22ed3c29(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_64b0c307(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Lass mich einkaufen.\nHallo.")
			var20 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_391d8410(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_73329049()
		if vm.skipping() then
			return skip(40)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Ich hab in letzter Zeit Probleme,\ndie kleinen Teile zu sehen.<page>Ich werde wohl auch\nnicht j[UNI00fc]nger ..."
			)
		else
			event.MesMake_2(
				0,
				"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
			)
		end
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Wenn ich nicht immer\nwas zu tun habe,\nwerde ich unausstehlich.")
		else
			event.MesMake_2(
				0,
				"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
			)
		end
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Ich habe in letzter Zeit viel\nUngeziefer im Gefieder,\ndas juckt schrecklich.")
		else
			event.MesMake_2(
				0,
				"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
			)
		end
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Ich liebe Schwarzpulver-Duft!\nDas ist echt mein Traumjob.<page>Aber mein Boss ist ziemlich\nstur und altmodisch.\nAch, na ja."
			)
		else
			event.MesMake_2(0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
		end
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Abgesehen davon, dass ich als\nGem[UNI00e4]lde zur Welt kam, bin\nich genau wie alle anderen."
			)
		else
			event.MesMake_2(0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
		end
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

return helper_c2963624
