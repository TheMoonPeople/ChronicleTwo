--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_e062d24d(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"坊ちゃんの頼みとあらば、\n出来る限りの事をして\n差し上げます。<page>お任せください。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "・・・")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"引き受けてくれとは\n申しません・・・<page>ただ、私の話を聞いて\n頂きとうございます。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"この家にお仕えして３０余年、\n真面目だけが取り得と\n今まで尽くしてまいりました。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "そんな仕事しか取り得の\nない私の、唯一の趣味が\n読書なんです。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"すごく貴重で珍しい本が\nありまして、その本が今、\nオークションに出ているのです。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"まさに競り合っている最中なのです。\n思うに、１０００ギルダもあれば\n落札出来ます。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"でも、そんな大金、とても\n持ち合わせていませんし、<page>こんな事、だんな様に\nご相談したなら、呆れ果てて、\nお暇を頂く事になるでしょう。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"ですから、お頼みできるのは、\n坊ちゃんだけなのです。<page>決して、決して交換条件と\nいう訳ではございませんよ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]なんだかんだ言って、１０００ギルダ渡さないと\n   スチュアートは仲間になってくれそうにないですね。\n   仕方ありません。お金を用意しましょう。"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

return helper_e062d24d
