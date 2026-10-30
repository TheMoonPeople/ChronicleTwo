--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_57badc8f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(9) or var2
	money = event.get_money() or money
	if var2 == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"That kind of money won't\nget me into the auction.<page>I need 1000 Gilda.\nPlease get it right!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(0, "You won't believe this!<page>The price has gone up to\n1200 Gilda.")
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.open_message_window_2(0, "I'm terribly sorry, but could you\npossibly get hold a of 1500 Gilda?")
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 1500 Gilda as quick as you can!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(
				0,
				"This is terrible!\nThere's someone who'll pay 1800 Gilda!<page>If I don't bid about 2000 Gilda,\nthere's no way I'll win."
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 2000 Gilda as quick as you can!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Sonny, did you manage to get\nmy 2000 Gilders together?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "What can I do, it's yours.\nIt does seem a bit of a waste.")
		var4 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if var4 ~= 0 then
			event.open_message_window_2(
				0,
				"I see... well, 2000 Gilda is a lot of money.\nso it must be hard to part with.\nEven for a well-off young lad like you...<page>Okay then, never mind!\nBut the auction isn't over yet.\nI'll wait, no matter how long it takes..."
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Thank you so much.<page>I'll get straight down to the auction!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_villager_ai_enabled(1, arg0)
		event.set_character_active(0, arg0)
		event.delete_villager(arg0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Thank you very much.\nI managed to make a successful bid.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "I bid strong and everyone else dropped out really\nquickly, so I got it for 1400 Gilda!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "So now I can give you 600 back.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.add_money(600)
	event.open_message_window_2(0, "And I'll work hard from now on to repay\nyou the rest of the money I borrowed.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "I know I put you to a lot of trouble.\nI'll repay the favour anytime.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

return helper_57badc8f
