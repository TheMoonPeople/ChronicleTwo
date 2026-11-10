--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_61744c1a(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	flag = event.get_save_flag(41) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Man sagt, ein Fisch ist\nwie sein Besitzer.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Mit dem Besitzer eines so schwachen\nFisches spreche ich niemals.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ich hab's mir angesehen.\nEs war ein gutes Rennen.<page>So einen Fisch h[UNI00e4]tte ich\nselbst nicht z[UNI00fc]chten k[UNI00f6]nnen.<page>Bitte nimm mich mit dir.\nBitte bring mir bei, was du kannst."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

return helper_61744c1a
