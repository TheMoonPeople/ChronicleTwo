--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")

--- Helper function.
local function helper_7c10c531(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	var2 = event.get_save_counter(9) or var2
	money = event.get_money() or money
	if var2 == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"坊ちゃん、そんな額では、\nオークションにすら\n出られませんよ。<page>１０００ギルダです。\nしっかりして下さい。"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.open_message_window_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>１５００ギルダ、\n急いでください。"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>２０００ギルダ、\n急いでください。"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		var4 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if var4 ~= 0 then
			event.open_message_window_2(
				0,
				"そうですか・・・やはり２０００ギルダは\n大金ですから、惜しくなってしまうのですね。\nこんなに裕福な坊ちゃんと言えども・・・<page>わかりました。あきらめます！\nでも、オークションはまだ続いています。\n私は待っていますよ、いつまでも・・・"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(
			0,
			"あぁ、坊ちゃん、\nありがとうございます。<page>では、急いで\nオークショニアの所へ\n行って来ます！"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_villager_ai_enabled(1, arg0)
		event.set_character_active(0, arg0)
		event.delete_villager(arg0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "坊ちゃん、\nありがとうございました。\n無事、落札できました。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.add_money(600)
	event.open_message_window_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

return helper_7c10c531
