--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_84c07dcc = require("@lib/event/helper_84c07dcc")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_4524c68a(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	helper_84c07dcc(arg0)
	event.open_message_window_2(
		0,
		"・・・１２１２、<page>いやいや、１１２２\nだったような気が。<page>それとも１０１０\nだったかな。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]目の前で話しかけているのに気づかないなんて、\n   何やら大きな悩み事があるみたいですね。<page>   後でまた来てみましょう。もしかしたら、\n   力になってあげられるかもしれませんよ。"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

return helper_4524c68a
