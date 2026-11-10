--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_883d6941(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_c8484b43(arg0, 0, 0)
		event.open_message_window_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hey, Max.<page>Warum siehst du immer\nso gesund aus?")
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_883d6941
