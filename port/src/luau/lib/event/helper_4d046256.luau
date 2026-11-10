--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_625be81f = require("@lib/event/helper_625be81f")

--- Helper function.
local function helper_4d046256(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	var6 = event.get_save_counter(7) or var6
	if var6 == 0 then
		event.open_message_window_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_625be81f(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.open_message_window_2(
			0,
			"こら、ボートまで行かなかった\nだろう。俺にはお見通しだぞ。\nインチキするな！"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_625be81f(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.open_message_window_2(0, "こら、インチキするな！")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_625be81f(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "お、戻ってきたな。\nじゃ、タイム発表！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_message_number(0, 1, var2)
	event.set_message_number(0, 2, var3)
	event.set_message_number(0, 3, var4)
	if var5 == 0 then
		event.open_message_window_2(0, "おいおい、\n[数値１]分[数値２]秒[数値３]なんて\n遅すぎるぞ。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_625be81f(arg0, arg1)
		return
	end
	event.open_message_window_2(
		0,
		"お、[数値１]分[数値２]秒[数値３]とは\nなかなかのタイムじゃないか。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"見かけによらず、良い足を\nしている。わかった、\nいっしょに悪と戦おう！"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

return helper_4d046256
