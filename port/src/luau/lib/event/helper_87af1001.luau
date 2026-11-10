--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_59a16271 = require("@lib/event/helper_59a16271")

--- Helper function.
local function helper_87af1001()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	print("IN go_shop_up()\n")
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Welcome.")
	if var0 == 18 then
		event.open_message_window_2(
			0,
			"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
		)
	end
	if var0 == 4 then
		event.open_message_window_2(
			0,
			"Working hard, I see?\nYou need something?<page>No freebies, though.\nNot even for you, Max."
		)
	end
	if var0 == 34 then
		event.open_message_window_2(
			0,
			"You need some more Georama\nelements?<page>If you don't have the time to\ncollect them yourself, maybe\nmoney can solve your problems."
		)
	end
	if var0 == 1012 then
		flag = event.get_save_flag(45) or flag
		if flag == 0 then
			event.open_message_window_2(
				0,
				"Hello. I'm a baker's apprentice.\nI'm handling the bakery while\nPolly's away.<page>I'm a little nervous, but this is\nall part of my training, I guess.\nI'll do my best!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.get_save_flag(46) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"We may not look very much alike...\nBut I'm Milane's little sister.<page>Milane made me watch the shop while she's away.\nI don't know the first thing about weapons!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.get_save_flag(47) or flag_3
		if flag_3 == 0 then
			event.open_message_window_2(
				0,
				"Surprise you, did I? I guess anyone\nwould be surprised to see someone\nstanding here dressed like this.<page>I'm a good friend of Priest Bruno. I'm\nfilling in for him while he's away on a trip.\nSo, is there anything I can help you with?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
			)
		end
	end
	if var1 ~= -1 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var0 == 18 then
		helper_59a16271(15)
	end
	if var0 == 12 then
		helper_59a16271(1)
	end
	if var0 == 4 then
		helper_59a16271(6)
	end
	if var0 == 15 then
		helper_59a16271(0)
	end
	if var0 == 33 then
		helper_59a16271(4)
	end
	if var0 == 34 then
		helper_59a16271(31)
	end
	if var0 == 1012 then
		helper_59a16271(35)
	end
	if var0 == 1015 then
		helper_59a16271(36)
	end
	if var0 == 1018 then
		helper_59a16271(37)
	end
end

return helper_87af1001
