--!strict
-- Shared event helper used by 24 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_eac5726b = require("@lib/event/helper_eac5726b")

--- Helper function.
local function helper_52d29060()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	print("IN go_shop_up()\n")
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	language_code = event.get_language() or language_code
	if language_code ~= 0 then
		event.open_message_window_2(0, "Welcome.")
	else
		event.open_message_window_2(0, "いらっしゃい。")
		if var0 == 18 then
			event.open_message_window_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if var0 == 4 then
			event.open_message_window_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if var0 == 34 then
			event.open_message_window_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if var0 == 1012 then
			flag = event.get_save_flag(45) or flag
			if flag == 0 then
				event.open_message_window_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.set_save_flag(45, 1)
			end
		end
		if var0 == 1015 then
			flag_2 = event.get_save_flag(46) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.set_save_flag(46, 1)
			end
		end
		if var0 == 1018 then
			flag_3 = event.get_save_flag(47) or flag_3
			if flag_3 == 0 then
				event.open_message_window_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.set_save_flag(47, 1)
			else
				event.open_message_window_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if var1 ~= -1 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var0 == 18 then
		helper_eac5726b(15)
	end
	if var0 == 12 then
		helper_eac5726b(1)
	end
	if var0 == 4 then
		helper_eac5726b(6)
	end
	if var0 == 15 then
		helper_eac5726b(0)
	end
	if var0 == 33 then
		helper_eac5726b(4)
	end
	if var0 == 34 then
		helper_eac5726b(31)
	end
	if var0 == 1012 then
		helper_eac5726b(35)
	end
	if var0 == 1015 then
		helper_eac5726b(36)
	end
	if var0 == 1018 then
		helper_eac5726b(37)
	end
end

return helper_52d29060
