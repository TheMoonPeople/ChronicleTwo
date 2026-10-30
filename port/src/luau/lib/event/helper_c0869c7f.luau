--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c0869c7f()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(732) or flag
	if flag ~= 0 then
		event.open_message_window_2(3, "やったな！ニンゲンも\n少しはやるもんだ。<page>見直したぜ。")
		return
	end
	flag = event.get_save_flag(728) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"いよいよ最後だね。\n奴を倒せば全て終わる。<page>そして、新しい何かが\n始まるんだ。"
		)
		return
	end
	flag = event.get_save_flag(712) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"グリフォンの気持ちもわかるけど、\n彼のした事は許されないと思うんだ。"
		)
		return
	end
	flag = event.get_save_flag(702) or flag
	if flag ~= 0 then
		event.open_message_window_2(3, "庭園を元に戻して、グリフォン、\nいやサンの秘密をあばくんだ。")
		return
	end
	flag = event.get_save_flag(700) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"「サンの思い出」って何の事かな？\n宮殿に入ってみなきゃわかんないよ。"
		)
		return
	end
	flag = event.get_save_flag(640) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"ぼやぼやしているとグリフォンを\n逃がしてしまうよ。<page>早く月花宮殿へ行かなきゃ。"
		)
		return
	end
	flag_2 = event.get_save_flag(624) or flag_2
	flag_3 = event.get_save_flag(628) or flag_3
	flag_4 = event.get_save_flag(632) or flag_4
	flag_5 = event.get_save_flag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.open_message_window_2(
			3,
			"ラピスは全て手に入れたよね。\n急いでカザロフストーンへ行こう。"
		)
		return
	end
	flag = event.get_save_flag(616) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"とにかく、急いでラピスを探さなきゃ、\n取り返しのつかない事になっちゃうよ。"
		)
		return
	end
	flag = event.get_save_flag(600) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"この宮殿から全てが始まったんだね。\nとりあえず、中に入ってみようよ。"
		)
		return
	end
	flag = event.get_save_flag(540) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"そろそろ、ルナ研に戻ってみない？\nイクシオンが完成してるかもしれないよ。"
		)
		return
	end
	flag = event.get_save_flag(536) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"いよいよグリフォンへの反撃開始だ。\nパズノス要塞へ行ってみようよ。"
		)
		return
	end
	flag = event.get_save_flag(526) or flag
	if flag ~= 0 then
		event.open_message_window_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.get_save_flag(524) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"ドナ・ホーンさんが\n言っていたよね。<page>ファイアーホーンを奏でれば\n道は開けるって。"
		)
		return
	end
	flag = event.get_save_flag(520) or flag
	if flag ~= 0 then
		event.open_message_window_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.get_save_flag(508) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			3,
			"ファイアースコール装置を\n壊さなきゃ。<page>ガンドール火山の頂上に\nあるって言っていたよね。"
		)
		return
	end
	event.open_message_window_2(
		3,
		"待っているだけでは\n何も起きないよ。<page>まだ行った事のない場所が\nあるんじゃないの。"
	)
end

return helper_c0869c7f
