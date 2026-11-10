--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_fb164946(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.open_message_window_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_fb164946
