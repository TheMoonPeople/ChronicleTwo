--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e3daee3 = require("@lib/event/helper_0e3daee3")
local helper_1197de8c = require("@lib/event/helper_1197de8c")
local helper_2cceabd2 = require("@lib/event/helper_2cceabd2")
local helper_349b1f0d = require("@lib/event/helper_349b1f0d")
local helper_3e691670 = require("@lib/event/helper_3e691670")
local helper_4244fa92 = require("@lib/event/helper_4244fa92")
local helper_44e01112 = require("@lib/event/helper_44e01112")
local helper_47ac04e8 = require("@lib/event/helper_47ac04e8")
local helper_516932d0 = require("@lib/event/helper_516932d0")
local helper_5c8704e5 = require("@lib/event/helper_5c8704e5")
local helper_6336b270 = require("@lib/event/helper_6336b270")
local helper_64180664 = require("@lib/event/helper_64180664")
local helper_6d4b41a6 = require("@lib/event/helper_6d4b41a6")
local helper_7408556b = require("@lib/event/helper_7408556b")
local helper_81fe8c47 = require("@lib/event/helper_81fe8c47")
local helper_85dfe7c6 = require("@lib/event/helper_85dfe7c6")
local helper_90240f38 = require("@lib/event/helper_90240f38")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")
local helper_9f5da110 = require("@lib/event/helper_9f5da110")
local helper_ac1f571d = require("@lib/event/helper_ac1f571d")
local helper_cc5c45bd = require("@lib/event/helper_cc5c45bd")
local helper_e4e369ed = require("@lib/event/helper_e4e369ed")
local helper_ea7260bf = require("@lib/event/helper_ea7260bf")

--- Helper function.
local function helper_e385fedf(arg0: s32, arg1: s32)
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_85dfe7c6(arg0, arg1)
			end
			if at <= 2 then
				helper_516932d0()
			end
			if at <= 3 then
				helper_81fe8c47(arg0, arg1)
			end
			if at <= 4 then
				helper_47ac04e8(arg0, arg1)
			end
			if at <= 5 then
				helper_64180664(arg0, arg1)
			end
			if at <= 6 then
				helper_e4e369ed(arg0, arg1)
			end
			if at <= 7 then
				helper_ac1f571d(arg0, arg1)
			end
			if at <= 8 then
				var9 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 10 then
			return
		end
		if at <= 14 then
			if at <= 11 then
				helper_4244fa92(arg0, arg1)
			end
			if at <= 12 then
				helper_2cceabd2(arg0, arg1)
			end
			if at <= 13 then
				var12 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 15 then
			return
		end
		if at <= 20 then
			if at <= 16 then
				helper_3e691670(arg0, arg1)
			end
			if at <= 17 then
				helper_6336b270(arg0, arg1)
			end
			if at <= 18 then
				helper_9f5da110(arg0, arg1)
			end
			if at <= 19 then
				var15 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 21 then
			return
		end
		if at <= 30 then
			if at <= 22 then
				helper_5c8704e5(arg0, arg1)
			end
			if at <= 23 then
				helper_6d4b41a6(arg0, arg1)
			end
			if at <= 24 then
				helper_1197de8c(arg0, arg1)
			end
			if at <= 25 then
				helper_0e3daee3(arg0, arg1)
			end
			if at <= 26 then
				helper_ea7260bf(arg0, arg1)
			end
			if at <= 27 then
				helper_90240f38(arg0, arg1)
			end
			if at <= 28 then
				helper_44e01112(arg0, arg1)
			end
			if at <= 29 then
				var18 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 31 then
			return
		end
		if at <= 32 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
		if at <= 33 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
		if at <= 34 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
		if at <= 35 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
		if at <= 36 then
			helper_9d142a11(arg0, -1, 0, 0)
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
		helper_349b1f0d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_85dfe7c6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			helper_516932d0()
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_81fe8c47(arg0, arg1)
			if vm.skipping() then
				return skip(4)
			end
		end
	end
	if var3 == 7 then
		helper_47ac04e8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var3 == 8 then
		helper_64180664(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var3 == 10 then
		helper_e4e369ed(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var3 == 11 then
		helper_ac1f571d(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var3 == 12 then
		var7 = event.GetQuestEtc(0, 0) or var7
		var8 = event.GetQuestEtc(0, 8) or var8
		if var7 == 2 and var8 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var9 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(9)
			end
			if var9 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var9 == 1 then
				helper_4244fa92(arg0, arg1)
				if vm.skipping() then
					return skip(10)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_516932d0()
			if vm.skipping() then
				return skip(11)
			end
		else
			helper_4244fa92(arg0, arg1)
			if vm.skipping() then
				return skip(12)
			end
		end
	end
	if var3 == 14 then
		helper_2cceabd2(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 15 then
		var10 = event.GetQuestEtc(0, 0) or var10
		var11 = event.GetQuestEtc(0, 10) or var11
		if var10 == 2 and var11 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var12 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(14)
			end
			if var12 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var12 == 1 then
				helper_3e691670(arg0, arg1)
				if vm.skipping() then
					return skip(15)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_516932d0()
			if vm.skipping() then
				return skip(16)
			end
		else
			helper_3e691670(arg0, arg1)
			if vm.skipping() then
				return skip(17)
			end
		end
	end
	if var3 == 16 then
		helper_6336b270(arg0, arg1)
		if vm.skipping() then
			return skip(18)
		end
	end
	if var3 == 17 then
		helper_9f5da110(arg0, arg1)
		if vm.skipping() then
			return skip(19)
		end
	end
	if var3 == 18 then
		var13 = event.GetQuestEtc(0, 0) or var13
		var14 = event.GetQuestEtc(0, 13) or var14
		if var13 == 2 and var14 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var15 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(20)
			end
			if var15 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var15 == 1 then
				helper_5c8704e5(arg0, arg1)
				if vm.skipping() then
					return skip(21)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_516932d0()
			if vm.skipping() then
				return skip(22)
			end
		else
			helper_5c8704e5(arg0, arg1)
			if vm.skipping() then
				return skip(23)
			end
		end
	end
	if var3 == 19 then
		helper_6d4b41a6(arg0, arg1)
		if vm.skipping() then
			return skip(24)
		end
	end
	if var3 == 20 then
		helper_1197de8c(arg0, arg1)
		if vm.skipping() then
			return skip(25)
		end
	end
	if var3 == 21 then
		helper_0e3daee3(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 23 then
		helper_ea7260bf(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 24 then
		helper_90240f38(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 25 then
		helper_44e01112(arg0, arg1)
		if vm.skipping() then
			return skip(29)
		end
	end
	if var3 == 33 then
		var16 = event.GetQuestEtc(0, 8) or var16
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var16 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "買い物させて\nこんにちは")
			var18 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(30)
			end
			if var18 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var18 == 1 then
				helper_cc5c45bd(arg0, arg1)
				if vm.skipping() then
					return skip(31)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_516932d0()
		if vm.skipping() then
			return skip(32)
		end
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
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(33)
		end
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
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
		else
			event.MesMake_2(0, "ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。")
		end
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(35)
		end
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
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(36)
		end
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
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(37)
		end
	end
	event.SetAi(1, arg0)
end

return helper_e385fedf
