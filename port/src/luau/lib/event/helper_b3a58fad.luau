--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_b3a58fad(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.open_message_window_2(0, "Oh, hallo, junge Dame.\nKann ich etwas f[UNI00fc]r dich tun?")
		else
			event.open_message_window_2(0, "Max, erz[UNI00e4]hl deinem Vater\nnichts von dem Weihwasser, ja?")
		end
	else
		event.open_message_window_2(0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_b3a58fad
