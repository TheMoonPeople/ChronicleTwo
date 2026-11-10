--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_62109c36(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(24)
	helper_f38eabca(24, 1)
	helper_d61bc810(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

return helper_62109c36
