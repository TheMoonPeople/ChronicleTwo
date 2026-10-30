--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_52d29060 = require("@lib/event/helper_52d29060")

--- Helper function.
local function helper_c53220da()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_52d29060()
		event.set_villager_ai_enabled(1, var1)
		return
	end
	if var2 == 50 then
		event.open_message_window_2(0, "おい、この先は\n立ち入り禁止だ。")
		helper_1c04a0eb(var1, -1, 0, 0)
		event.set_villager_ai_enabled(1, var1)
		return
	end
	var7 = event.get_chapter() or var7
	if var7 == 1 then
		flag = event.get_save_flag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"見てみろよ、こんなでっかい物が\n動いてたなんて、信じられないだろう。\nでもな、昔は本当に動いてたんだぜ。<page>また、こいつに乗って旅するのがオレの夢だ。\nだから、今でも整備にぬかりはねぇ。\n許しが出たら、いつでも動かせるようにな。"
				)
			else
				event.open_message_window_2(
					0,
					"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
				)
			end
			helper_1c04a0eb(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"やあ、ユリス。\n鉄道が廃止されて\nどれだけの時間が流れたかのう。<page>私はたとえ、鉄道が動かずとも\nこうやって毎日駅を見回っているのだよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ようやく町長が、重い腰を上げたのじゃな。\n列車は走っているとはいえ、まだまだ\n一般開放できる状態ではない。<page>早く町のみんなを乗せて\nあげたいのじゃが・・・"
				)
			end
			helper_1c04a0eb(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"こんにちは、ユリス。\nそこにいる駅長、うちのパパなの。\nこうやって親子で駅を守っているの。<page>いつの日か、鉄道が復活する日まで・・・"
				)
			else
				event.open_message_window_2(
					0,
					"列車が動いたわ！\nだけど、まだ駅が元通りになるのは、\n時間がかかりそうね・・・"
				)
			end
			helper_1c04a0eb(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.get_save_flag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"おっちゃん、モニカちゃんの\n隠れファンだったんだけど、\n最近モニカちゃんの姿が見えねーな。<page>おかげで、仕事のやる気が出ねーよ。"
				)
			else
				active_chr_no_2 = event.get_playable_character() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.open_message_window_2(
						0,
						"よお、ユリス。\nモニカが帰って来たらしいな。\n町のみんなも喜ぶぞー！"
					)
				else
					event.open_message_window_2(
						0,
						"モニカー！元気だったか？\nおっちゃん、寂しかったよー。"
					)
				end
			end
			helper_1c04a0eb(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"やっとモニカちゃんと普通に\nしゃべれるようになったのに\n突然いなくなるんだもんな。<page>ユリス、一体モニカちゃん、\nどこに行ったんだ？"
				)
			else
				active_chr_no_3 = event.get_playable_character() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.open_message_window_2(0, "モニカが帰ってきたんだね。\n一体、どうやって？？")
				else
					event.open_message_window_2(0, "モニカ、帰ってきたんだね。\n一体、どうやって？？")
				end
			end
			helper_1c04a0eb(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
	end
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

return helper_c53220da
