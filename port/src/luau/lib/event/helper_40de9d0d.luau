--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_625be81f = require("@lib/event/helper_625be81f")

--- Helper function.
local function helper_40de9d0d(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(0, "やぁ、ユリス。私を\n呼びに来たのかい？<page>待っていたよ。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"城壁のおかげでこの町は\nとりあえず無事だ。<page>今度は我々が\n打って出る番だ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"しかし、ユリスは\n機械いじりばかりしてるけど、\n体力は大丈夫なんだろうね。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"戦いの基本はスピードと\nフットワークだ。<page>私よりのろまだと\n話にならんよ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"そうだな、試しに\n池のボートまで行って\n戻って来てみろ。<page>私の記録は２分１秒だ。\nそれ以上かかるようなら\n話にならんね。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "どうだ、挑戦してみるか？")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_625be81f(arg0, arg1)
end

return helper_40de9d0d
