--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c59fe05 = require("@lib/event/helper_0c59fe05")
local helper_10625ea5 = require("@lib/event/helper_10625ea5")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1fc4ff92 = require("@lib/event/helper_1fc4ff92")
local helper_20fe9833 = require("@lib/event/helper_20fe9833")
local helper_35ac2bde = require("@lib/event/helper_35ac2bde")
local helper_420f6442 = require("@lib/event/helper_420f6442")
local helper_464b0610 = require("@lib/event/helper_464b0610")
local helper_4e2a00d9 = require("@lib/event/helper_4e2a00d9")
local helper_4f0230b2 = require("@lib/event/helper_4f0230b2")
local helper_52d29060 = require("@lib/event/helper_52d29060")
local helper_5b6403c6 = require("@lib/event/helper_5b6403c6")
local helper_5cfb3070 = require("@lib/event/helper_5cfb3070")
local helper_5e014937 = require("@lib/event/helper_5e014937")
local helper_601200b0 = require("@lib/event/helper_601200b0")
local helper_684f356d = require("@lib/event/helper_684f356d")
local helper_6b43f254 = require("@lib/event/helper_6b43f254")
local helper_6ec29fcc = require("@lib/event/helper_6ec29fcc")
local helper_71d47461 = require("@lib/event/helper_71d47461")
local helper_7cc9b820 = require("@lib/event/helper_7cc9b820")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_8a39abce = require("@lib/event/helper_8a39abce")
local helper_9635ea34 = require("@lib/event/helper_9635ea34")
local helper_ba4251cf = require("@lib/event/helper_ba4251cf")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c06765bb = require("@lib/event/helper_c06765bb")
local helper_c09a5ddc = require("@lib/event/helper_c09a5ddc")
local helper_c319e890 = require("@lib/event/helper_c319e890")
local helper_c4aeb2aa = require("@lib/event/helper_c4aeb2aa")
local helper_c79dc3a2 = require("@lib/event/helper_c79dc3a2")
local helper_cb396976 = require("@lib/event/helper_cb396976")
local helper_d2e2f515 = require("@lib/event/helper_d2e2f515")
local helper_d6b92828 = require("@lib/event/helper_d6b92828")
local helper_eec107f7 = require("@lib/event/helper_eec107f7")
local helper_ef11a8cb = require("@lib/event/helper_ef11a8cb")
local helper_f266fe03 = require("@lib/event/helper_f266fe03")
local helper_f6fb599a = require("@lib/event/helper_f6fb599a")

--- Helper function.
local function helper_145c94fe(chara_no: s32, arg1: s32)
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
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		var2 = event.get_chapter() or var2
		var3 = event.get_triggered_event_data_2(14) or var3
		event.get_current_map()
		now_sub_map_no = event.get_current_submap() or now_sub_map_no
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, chara_no)
		if var3 == 3 then
			at = 1
			helper_9635ea34(chara_no, arg1)
		end
		if var3 == 5 then
			at = 2
			helper_d2e2f515(chara_no, arg1)
		end
		if var3 == 4 then
			flag = event.get_save_flag(104) or flag
			if flag == 0 then
				at = 3
				helper_52d29060()
			else
				at = 4
				helper_ef11a8cb(chara_no, arg1)
			end
		end
		if var3 == 7 then
			at = 5
			helper_d6b92828(chara_no, arg1)
		end
		if var3 == 8 then
			at = 6
			helper_420f6442(chara_no, arg1)
		end
		if var3 == 10 then
			at = 7
			helper_71d47461(chara_no, arg1)
		end
		if var3 == 11 then
			at = 8
			helper_6ec29fcc(chara_no, arg1)
		end
		if var3 == 12 then
			var7 = event.get_quest_request_status(0, 0) or var7
			var8 = event.get_quest_request_status(0, 8) or var8
			if var7 == 2 and var8 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 9
				var9 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var9 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var9 == 1 then
					at = 10
					helper_c06765bb(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 28 then
				at = 11
				helper_52d29060()
			else
				at = 12
				helper_c06765bb(chara_no, arg1)
			end
		end
		if var3 == 14 then
			at = 13
			helper_c09a5ddc(chara_no, arg1)
		end
		if var3 == 15 then
			var10 = event.get_quest_request_status(0, 0) or var10
			var11 = event.get_quest_request_status(0, 10) or var11
			if var10 == 2 and var11 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 14
				var12 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var12 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var12 == 1 then
					at = 15
					helper_35ac2bde(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 30 then
				at = 16
				helper_52d29060()
			else
				at = 17
				helper_35ac2bde(chara_no, arg1)
			end
		end
		if var3 == 16 then
			at = 18
			helper_cb396976(chara_no, arg1)
		end
		if var3 == 17 then
			at = 19
			helper_20fe9833(chara_no, arg1)
		end
		if var3 == 18 then
			var13 = event.get_quest_request_status(0, 0) or var13
			var14 = event.get_quest_request_status(0, 13) or var14
			if var13 == 2 and var14 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 20
				var15 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var15 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var15 == 1 then
					at = 21
					helper_f6fb599a(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 33 then
				at = 22
				helper_52d29060()
			else
				at = 23
				helper_f6fb599a(chara_no, arg1)
			end
		end
		if var3 == 19 then
			at = 24
			helper_1fc4ff92(chara_no, arg1)
		end
		if var3 == 20 then
			at = 25
			helper_4f0230b2(chara_no, arg1)
		end
		if var3 == 21 then
			at = 26
			helper_5b6403c6(chara_no, arg1)
		end
		if var3 == 23 then
			at = 27
			helper_4e2a00d9(chara_no, arg1)
		end
		if var3 == 24 then
			at = 28
			helper_601200b0(chara_no, arg1)
		end
		if var3 == 25 then
			at = 29
			helper_eec107f7(chara_no, arg1)
		end
		if var3 == 33 then
			var16 = event.get_quest_request_status(0, 8) or var16
			active_chr_no = event.get_playable_character() or active_chr_no
			if var16 == 1 and active_chr_no == 0 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "買い物させて\nこんにちは")
				at = 30
				var18 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var18 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var18 == 1 then
					at = 31
					helper_8a39abce(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			at = 32
			helper_52d29060()
		end
		if var3 == 1 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.open_message_window_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			at = 33
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 2 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			at = 34
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 6 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			at = 35
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 13 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.open_message_window_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			at = 36
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 22 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			at = 37
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		event.set_villager_ai_enabled(1, chara_no)
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 9 then
				var9 = received[1] :: number
			end
			if at <= 1 then
				helper_6b43f254(chara_no, arg1)
			end
			if at <= 2 then
				helper_c4aeb2aa()
			end
			if at <= 3 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 4 then
				helper_7cc9b820(chara_no, arg1)
			end
			if at <= 5 then
				helper_5e014937(chara_no, arg1)
			end
			if at <= 6 then
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 7 then
				helper_5cfb3070(chara_no, arg1)
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
				helper_7cc9b820(chara_no, arg1)
			end
			if at <= 12 then
				helper_464b0610(chara_no, arg1)
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
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 17 then
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 18 then
				helper_c79dc3a2(chara_no, arg1)
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
				helper_ba4251cf(chara_no, arg1)
			end
			if at <= 23 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 24 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 25 then
				helper_c319e890(chara_no, arg1)
			end
			if at <= 26 then
				helper_f266fe03(chara_no, arg1)
			end
			if at <= 27 then
				helper_6b43f254(chara_no, arg1)
			end
			if at <= 28 then
				helper_0c59fe05(chara_no, arg1)
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
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 33 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 34 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 35 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 36 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

return helper_145c94fe
