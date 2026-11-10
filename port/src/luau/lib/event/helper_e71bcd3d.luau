--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")

--- Helper function.
local function helper_e71bcd3d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.open_message_window_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "わかったよ\nおことわり")
	var3 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(arg0, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var3 ~= 0 then
		event.open_message_window_2(0, "なによ、いじわる！\nけちんぼ！")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"ほんとに連れて\n行ってくれるの？<page>ダメモトでも\n言ってみるものね。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_888ab2a3(30)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_villager_ai_enabled(1, arg0)
	event.set_character_active(0, arg0)
	event.delete_villager(arg0)
	event.fade_in_screen(30)
	helper_888ab2a3(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

return helper_e71bcd3d
