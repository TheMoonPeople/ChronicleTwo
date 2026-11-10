--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_bbfc85f8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	flag = event.get_save_flag(41) or flag
	if flag == 0 then
		event.open_message_window_2(0, "They say that a fish mirrors its owner.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "There's no way I'll talk to such a \nweak fish's owner.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"I was watching, you know.\nIt was a great race.<page>I doubt that I could've raised\nsuch a good fish.<page>Please take me with you.\nPlease teach me what you know."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

return helper_bbfc85f8
