--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")

--- Helper function.
local function helper_8a39abce(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 == 0 then
		event.open_message_window_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 1)
	end
	if var2 == 1 then
		event.open_message_window_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.open_message_window_2(0, "中止だって！？\nそいつは残念だな。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 3)
	end
	if var2 == 3 then
		event.open_message_window_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_8a39abce
