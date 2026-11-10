--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")

--- Helper function.
local function helper_736fa717(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	argc = event.get_item_count(214) or argc
	argc_2 = event.get_item_count(245) or argc_2
	argc_3 = event.get_item_count(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.open_message_window_2(
			0,
			"材料がないと服は作れません。<page>『ぶあつい皮』『銅のかたまり』\nそれと『意外と丈夫な布』です。<page>甘えるようですが、\nお願いします。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "これで服を作ってみなよ！\nやっぱり、もったいないや")
	var5 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var5 ~= 0 then
		event.open_message_window_2(0, "材料がないと服は作れません。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(
		0,
		"ありがとうございます！\nこれで服を作ってみます。<page>坊ちゃんのお気持ち、\n決してむだにはしません。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_villager_ai_enabled(1, arg0)
	event.set_character_active(0, arg0)
	event.delete_villager(arg0)
	event.finish_event()
	event.fade_in_screen(30)
end

return helper_736fa717
