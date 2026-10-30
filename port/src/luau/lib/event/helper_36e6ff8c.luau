--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_36e6ff8c(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Really? You need my help?<page>Then let me pose you a problem.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"The candles in this church are\ncontrolled by a small mechanism.<page>When they're lit it puts them out,\nand when they're out it lights them.<page>If one of them changes,\nthe adjacent candles change too."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"If you can put all the candles out successfully,\nit'll prove your wisdom, and I'll go with you.<page>If you solve it, great! If not,\nplease understand that I cannot help you."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]This is another puzzler. Give\n   it a few attempts, and make use\n   of what you learn each time."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]If you re-enter the church,\n   the candles will be reset.\n   So don't worry about going wrong.\n   The answer could be simple."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

return helper_36e6ff8c
