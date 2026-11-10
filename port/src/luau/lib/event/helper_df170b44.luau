--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_af068bc2 = require("@lib/event/helper_af068bc2")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_df170b44(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_af068bc2(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	argc = event.get_item_count(201) or argc
	argc_2 = event.get_item_count(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.open_message_window_2(
			0,
			"What? Aah, coin collecting?<page>I'm looking for the Dark Coin\nand the Indestructible Coin.<page>You'll never get hold of those. I've looked all\nover for them, but they're impossible to find."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Eh? You've got them? Unbelievable!<page>Don't just stand there! Gimme, gimme, gimme!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK.\nWhat shall I do?")
	var5 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var5 ~= 0 then
		event.open_message_window_2(0, "Argh! If you're going to mess me\naround I definitely won't help you.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, I've got them all!\nAnd I thought it was impossible...<page>Well, I guess I've got no choice now.\nI'd better go with you!"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

return helper_df170b44
