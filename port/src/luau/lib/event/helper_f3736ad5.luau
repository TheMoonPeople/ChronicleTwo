--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_e787350a = require("@lib/event/helper_e787350a")

--- Helper function.
local function helper_f3736ad5(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(44)
	helper_e787350a(44, 1)
	helper_d61bc810(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

return helper_f3736ad5
