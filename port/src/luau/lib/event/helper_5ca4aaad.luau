--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b3d3e2 = require("@lib/event/helper_19b3d3e2")
local helper_1a9ac338 = require("@lib/event/helper_1a9ac338")
local helper_1d8b114c = require("@lib/event/helper_1d8b114c")
local helper_2194af33 = require("@lib/event/helper_2194af33")
local helper_243113c9 = require("@lib/event/helper_243113c9")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_69e5680f = require("@lib/event/helper_69e5680f")
local helper_6b19ac13 = require("@lib/event/helper_6b19ac13")
local helper_7b3c6627 = require("@lib/event/helper_7b3c6627")
local helper_7feb0351 = require("@lib/event/helper_7feb0351")
local helper_82d2a815 = require("@lib/event/helper_82d2a815")
local helper_868a98b2 = require("@lib/event/helper_868a98b2")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8e8fb883 = require("@lib/event/helper_8e8fb883")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_8fe4e906 = require("@lib/event/helper_8fe4e906")
local helper_9d950616 = require("@lib/event/helper_9d950616")
local helper_bda4332d = require("@lib/event/helper_bda4332d")
local helper_bdc9e1e6 = require("@lib/event/helper_bdc9e1e6")
local helper_be169fcb = require("@lib/event/helper_be169fcb")
local helper_c2c21b27 = require("@lib/event/helper_c2c21b27")
local helper_c98fe971 = require("@lib/event/helper_c98fe971")
local helper_cee50fa6 = require("@lib/event/helper_cee50fa6")
local helper_cfa3d6fd = require("@lib/event/helper_cfa3d6fd")
local helper_fff3a27b = require("@lib/event/helper_fff3a27b")

--- Helper function.
local function helper_5ca4aaad(arg0: s32, arg1: s32)
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
		helper_1a9ac338(arg0, arg1)
	end
	if var3 == 5 then
		helper_7feb0351(arg0, arg1)
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Lass mich einkaufen.\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var7 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				if helper_82d2a815(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(6)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_6b19ac13()
			end
		else
			event.MesMake_2(0, "Sei mein Freund!\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var8 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				if helper_82d2a815(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_cee50fa6(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_bda4332d(arg0, arg1)
	end
	if var3 == 8 then
		helper_fff3a27b(arg0, arg1)
	end
	if var3 == 10 then
		helper_7b3c6627(arg0, arg1)
	end
	if var3 == 11 then
		helper_9d950616(arg0, arg1)
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var11 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_8e8fb883(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_6b19ac13()
		else
			helper_8e8fb883(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_c2c21b27(arg0, arg1)
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var14 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_2194af33(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_6b19ac13()
		else
			helper_2194af33(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_8fe4e906(arg0, arg1)
	end
	if var3 == 17 then
		helper_19b3d3e2(arg0, arg1)
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var17 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_69e5680f(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_6b19ac13()
		else
			helper_69e5680f(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_c98fe971(arg0, arg1)
	end
	if var3 == 20 then
		helper_be169fcb(arg0, arg1)
	end
	if var3 == 21 then
		helper_cfa3d6fd(arg0, arg1)
	end
	if var3 == 23 then
		helper_868a98b2(arg0, arg1)
	end
	if var3 == 24 then
		helper_bdc9e1e6(arg0, arg1)
	end
	if var3 == 25 then
		helper_1d8b114c(arg0, arg1)
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Lass mich einkaufen.\nHallo.")
			var20 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_243113c9(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		helper_6b19ac13()
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
		helper_899661d6(arg0, -1, 0, 0)
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
		helper_899661d6(arg0, -1, 0, 0)
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
		helper_899661d6(arg0, -1, 0, 0)
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
		helper_899661d6(arg0, -1, 0, 0)
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
		helper_899661d6(arg0, -1, 0, 0)
	end
	event.SetAi(1, arg0)
end

return helper_5ca4aaad
