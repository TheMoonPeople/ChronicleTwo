--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_4c4d40e1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"I've not been feeling too good lately.<page>I'm just not up to going on a trip.<page>I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"But even standing normally I feel\nlike I'm going to fall down.<page>It's hard to explain. It's almost\nas if the world has been distorted."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(
			0,
			"Hmmm...\nif Dr. Dell doesn't know what the problem is,\nthen there's not much I can do to help..."
		)
		helper_0ffc2526(0, -1, arg1, arg0, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "I remember those symptoms.")
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.open_message_window_2(
		0,
		"In the time I was born,\nthe world was in a very bad state,\nwith more time distortions than\nyou can possibly imagine."
	)
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.open_message_window_2(
		0,
		"This had an effect on physically\nweak and fragile people.<page>Light people would get dizzy or faint,\nand heavier people couldn't stand at all."
	)
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.open_message_window_2(
		0,
		"Maybe you're particularly susceptible\nto this kind of thing.<page>Even the few time distortions we have\nhere are enough to affect you."
	)
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.open_message_window_2(0, "If we can just get rid of some of the closest\ndistortions, maybe you'll start to feel better.")
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.set_character_motion(arg1, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]How to fix a time distortion... Spheda!\n   If you can complete about 10 stages,\n   maybe Mena will start to feel better."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	var3 = event.get_menu_value_2(0) or var3
	event.set_save_counter(19, var3)
	event.set_quest_request(0, 17, 1)
end

return helper_4c4d40e1
