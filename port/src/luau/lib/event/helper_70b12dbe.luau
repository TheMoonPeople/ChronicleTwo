--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_70b12dbe(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 == 0 then
		event.open_message_window_2(0, "Oh, du hilfst\nPolly?<page>Toll.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Was ich mit\n20 Laiben will?<page>Ich mache heute mit ein\npaar Leuten K[UNI00e4]sefondue.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			'Um mit deinen "Erfindungen" zu\nsprechen - es ist eine Kombination<page>aus K[UNI00e4]se, Brot und Wein!'
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Es ist super. Man isst viel,\ndeshalb brauche ich das Brot.<page>Aber ich wollte es eigentlich\nnicht hierher geliefert haben."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Sag mal, Max, k[UNI00f6]nntest du es zu mir\nnach Hause bringen?<page>Du wei[UNI00df]t doch, wo das ist?\nBeim K[UNI00fc]rbisfeld."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 1)
	end
	if var2 == 1 then
		event.open_message_window_2(0, "Du wei[UNI00df]t, wo es ist, nicht?\nBeim K[UNI00fc]rbisfeld.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.open_message_window_2(0, "Abgesagt?\nWie schade!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Dann brauche ich das Brot nicht.\nKannst du es f[UNI00fc]r mich zu Polly\nzur[UNI00fc]ckbringen?"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 3)
	end
	if var2 == 3 then
		event.open_message_window_2(0, "Tut mir Leid - kannst du Polly\ndas Brot f[UNI00fc]r mich zur[UNI00fc]ckbringen?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_70b12dbe
