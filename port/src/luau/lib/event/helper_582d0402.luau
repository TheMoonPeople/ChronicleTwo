--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c59fe05 = require("@lib/event/helper_0c59fe05")
local helper_10625ea5 = require("@lib/event/helper_10625ea5")
local helper_16499da3 = require("@lib/event/helper_16499da3")
local helper_16957235 = require("@lib/event/helper_16957235")
local helper_1d17b5fb = require("@lib/event/helper_1d17b5fb")
local helper_23bc2332 = require("@lib/event/helper_23bc2332")
local helper_3bca4422 = require("@lib/event/helper_3bca4422")
local helper_40f3e1d7 = require("@lib/event/helper_40f3e1d7")
local helper_42a88811 = require("@lib/event/helper_42a88811")
local helper_43aaaf16 = require("@lib/event/helper_43aaaf16")
local helper_464b0610 = require("@lib/event/helper_464b0610")
local helper_5cfb3070 = require("@lib/event/helper_5cfb3070")
local helper_5e014937 = require("@lib/event/helper_5e014937")
local helper_684f356d = require("@lib/event/helper_684f356d")
local helper_6b43f254 = require("@lib/event/helper_6b43f254")
local helper_7cc9b820 = require("@lib/event/helper_7cc9b820")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_7ddb322e = require("@lib/event/helper_7ddb322e")
local helper_7ded0a83 = require("@lib/event/helper_7ded0a83")
local helper_84e1c96f = require("@lib/event/helper_84e1c96f")
local helper_85550c55 = require("@lib/event/helper_85550c55")
local helper_8c2b41a9 = require("@lib/event/helper_8c2b41a9")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_a6f84554 = require("@lib/event/helper_a6f84554")
local helper_ab4b0bdc = require("@lib/event/helper_ab4b0bdc")
local helper_ad5cf095 = require("@lib/event/helper_ad5cf095")
local helper_ba4251cf = require("@lib/event/helper_ba4251cf")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c319e890 = require("@lib/event/helper_c319e890")
local helper_c4aeb2aa = require("@lib/event/helper_c4aeb2aa")
local helper_c79dc3a2 = require("@lib/event/helper_c79dc3a2")
local helper_d9638962 = require("@lib/event/helper_d9638962")
local helper_e3c0b943 = require("@lib/event/helper_e3c0b943")
local helper_e3dcc786 = require("@lib/event/helper_e3dcc786")
local helper_e9438054 = require("@lib/event/helper_e9438054")
local helper_f266fe03 = require("@lib/event/helper_f266fe03")
local helper_f295781c = require("@lib/event/helper_f295781c")

--- Helper function.
local function helper_582d0402(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: any = 0
	local var16: s32 = 0
	local active_chr_no: s32 = 0
	local var18: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesPreset(0, 0)
		event.SetMesShippo(0, 1)
		var2 = event.GetChapter() or var2
		var3 = event.GetEventData_2(14) or var3
		event.GetNowMapNo()
		now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
		event.CtrlcStay()
		event.SetAi(0, arg0)
		if var3 == 3 then
			at = 1
			helper_1d17b5fb(arg0, arg1)
		end
		if var3 == 5 then
			at = 2
			helper_43aaaf16(arg0, arg1)
		end
		if var3 == 4 then
			flag = event.GetFlag(104) or flag
			if flag == 0 then
				at = 3
				helper_16499da3()
			else
				at = 4
				helper_16957235(arg0, arg1)
			end
		end
		if var3 == 7 then
			at = 5
			helper_d9638962(arg0, arg1)
		end
		if var3 == 8 then
			at = 6
			helper_7ded0a83(arg0, arg1)
		end
		if var3 == 10 then
			at = 7
			helper_ab4b0bdc(arg0, arg1)
		end
		if var3 == 11 then
			at = 8
			helper_f295781c(arg0, arg1)
		end
		if var3 == 12 then
			var7 = event.GetQuestEtc(0, 0) or var7
			var8 = event.GetQuestEtc(0, 8) or var8
			if var7 == 2 and var8 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 9
				var9 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var9 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var9 == 1 then
					at = 10
					helper_23bc2332(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 28 then
				at = 11
				helper_16499da3()
			else
				at = 12
				helper_23bc2332(arg0, arg1)
			end
		end
		if var3 == 14 then
			at = 13
			helper_ad5cf095(arg0, arg1)
		end
		if var3 == 15 then
			var10 = event.GetQuestEtc(0, 0) or var10
			var11 = event.GetQuestEtc(0, 10) or var11
			if var10 == 2 and var11 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 14
				var12 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var12 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var12 == 1 then
					at = 15
					helper_e9438054(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 30 then
				at = 16
				helper_16499da3()
			else
				at = 17
				helper_e9438054(arg0, arg1)
			end
		end
		if var3 == 16 then
			at = 18
			helper_8c2b41a9(arg0, arg1)
		end
		if var3 == 17 then
			at = 19
			helper_3bca4422(arg0, arg1)
		end
		if var3 == 18 then
			var13 = event.GetQuestEtc(0, 0) or var13
			var14 = event.GetQuestEtc(0, 13) or var14
			if var13 == 2 and var14 ~= 2 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
				at = 20
				var15 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var15 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var15 == 1 then
					at = 21
					helper_e3dcc786(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			if now_sub_map_no == 33 then
				at = 22
				helper_16499da3()
			else
				at = 23
				helper_e3dcc786(arg0, arg1)
			end
		end
		if var3 == 19 then
			at = 24
			helper_85550c55(arg0, arg1)
		end
		if var3 == 20 then
			at = 25
			helper_a6f84554(arg0, arg1)
		end
		if var3 == 21 then
			at = 26
			helper_42a88811(arg0, arg1)
		end
		if var3 == 23 then
			at = 27
			helper_7ddb322e(arg0, arg1)
		end
		if var3 == 24 then
			at = 28
			helper_e3c0b943(arg0, arg1)
		end
		if var3 == 25 then
			at = 29
			helper_40f3e1d7(arg0, arg1)
		end
		if var3 == 33 then
			var16 = event.GetQuestEtc(0, 8) or var16
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if var16 == 1 and active_chr_no == 0 then
				event.SetMotion(arg1, "立ち")
				event.MesMake_2(0, "買い物させて\nこんにちは")
				at = 30
				var18 = helper_c190f878(0, -1, 5, 256, 208, 2, 1)
				if var18 < 0 then
					event.SetAi(1, arg0)
					return
				end
				if var18 == 1 then
					at = 31
					helper_84e1c96f(arg0, arg1)
					event.SetAi(1, arg0)
					return
				end
			end
			at = 32
			helper_16499da3()
		end
		if var3 == 1 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.MesMake_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			at = 33
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 2 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.MesMake_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			at = 34
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 6 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.MesMake_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			at = 35
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 13 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.MesMake_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			at = 36
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		if var3 == 22 then
			event.SetMesPreset(0, 0)
			if var2 ~= 8 then
				event.MesMake_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.MesMake_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			at = 37
			helper_907fd9a8(arg0, -1, 0, 0)
		end
		event.SetAi(1, arg0)
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 9 then
				var9 = received[1] :: number
			end
			if at <= 1 then
				helper_6b43f254(arg0, arg1)
			end
			if at <= 2 then
				helper_c4aeb2aa()
			end
			if at <= 3 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 4 then
				helper_7cc9b820(arg0, arg1)
			end
			if at <= 5 then
				helper_5e014937(arg0, arg1)
			end
			if at <= 6 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 7 then
				helper_5cfb3070(arg0, arg1)
			end
			if at <= 8 then
				var9 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		if at <= 14 then
			if at == 14 then
				var12 = received[1] :: number
			end
			if at <= 11 then
				helper_7cc9b820(arg0, arg1)
			end
			if at <= 12 then
				helper_464b0610(arg0, arg1)
			end
			if at <= 13 then
				var12 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 15 then
			return 0
		end
		if at <= 20 then
			if at == 20 then
				var15 = received[1] :: number
			end
			if at <= 16 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 17 then
				helper_10625ea5(arg0, arg1)
			end
			if at <= 18 then
				helper_c79dc3a2(arg0, arg1)
			end
			if at <= 19 then
				var15 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 21 then
			return 0
		end
		if at <= 30 then
			if at == 30 then
				var18 = received[1] :: number
			end
			if at <= 22 then
				helper_ba4251cf(arg0, arg1)
			end
			if at <= 23 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 24 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 25 then
				helper_c319e890(arg0, arg1)
			end
			if at <= 26 then
				helper_f266fe03(arg0, arg1)
			end
			if at <= 27 then
				helper_6b43f254(arg0, arg1)
			end
			if at <= 28 then
				helper_0c59fe05(arg0, arg1)
			end
			if at <= 29 then
				var18 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 31 then
			return 0
		end
		if at <= 37 then
			if at <= 32 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 33 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 34 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 35 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			if at <= 36 then
				helper_684f356d(arg0, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

return helper_582d0402
