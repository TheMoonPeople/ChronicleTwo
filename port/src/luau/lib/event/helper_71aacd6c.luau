--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_dae6aadb = require("@lib/event/helper_dae6aadb")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_71aacd6c()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 13 then
		set_window_mode(0, 1)
		event.open_message_window_2(
			0,
			"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
		)
		var2 = event.get_chapter() or var2
		flag = event.get_save_flag(280) or flag
		if var2 == 2 and flag == 0 then
			event.open_message_window_2(
				0,
				"こんな岩、ファイナルボムなら\n一発で吹っ飛ばせるんだけどなぁ。"
			)
		end
		flag_2 = event.get_save_flag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.open_message_window_2(
				0,
				"ちびちび削るしかないなんて、\n性に合わない仕事だぜ。<page>でも、下手に爆破して、\n崩れちまったら大変だからな。"
			)
		end
		flag_3 = event.get_save_flag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.open_message_window_2(
				0,
				"正直言って、俺は何かを作ったり、\n修理したりするのって苦手なんだよな。"
			)
		end
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var6 = event.get_triggered_event_data_2(13) or var6
		helper_dae6aadb(var6, 3)
	end
end

return helper_71aacd6c
