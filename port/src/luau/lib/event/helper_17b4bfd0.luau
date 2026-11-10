--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_17b4bfd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 == 0 then
		event.open_message_window_2(0, "Oh, you're\nhelping Polly?<page>Great.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "What'll I do\nwith 20 loaves?<page>Well, I'm having a cheese\nfondue party today.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			'In terms of your famous "inventions",\nit\'s a culinary combination of cheese,<page>bread and wine!'
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"It's mighty good. Everyone eats loads,\nso that's why I need so much bread.<page>But I didn't want it\ndelivered here really."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Sorry Max, but you couldn't\ntake it to my house could you?<page>You know where it is, don't you?\nNear the pumpkin field."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 1)
	end
	if var2 == 1 then
		event.open_message_window_2(0, "You know where it is, don't you?\nNear the pumpkin field.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.open_message_window_2(0, "Cancelled?!\nWhat a shame!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "In that case, I don't need the bread.\nCan you take it back to Polly for me?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 3)
	end
	if var2 == 3 then
		event.open_message_window_2(0, "Sorry, but can you take the\nbread back to Polly for me?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_17b4bfd0
