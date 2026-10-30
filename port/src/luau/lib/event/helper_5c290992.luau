--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_f38eabca = require("@lib/event/helper_f38eabca")

--- Helper function.
local function helper_5c290992(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	var2 = 259
	argc = event.get_item_count(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.get_item_count(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.add_inventory_item(var2)
	helper_f38eabca(var2, 1)
	helper_d61bc810(1)
	event.open_message_window_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

return helper_5c290992
