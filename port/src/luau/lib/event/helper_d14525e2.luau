--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_d14525e2(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Was Fische angeht, bin ich\nsehr selbstbewusst.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Ich hab geh[UNI00f6]rt, dass einige Menschen\nihre Fische in einem Wettkampf\ngegeneinander antreten lassen.<page>Wenn du einen Fisch hast,\nkannst du doch versuchen,\ndas Wettschwimmen zu gewinnen!<page>Wenn du das schaffst, wei[UNI00df]\nich, dass du meine Hilfe\nverdienst."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sie redet wohl vom Flossen-\n   Fieber. Gewinne die Anf[UNI00e4]nger-\n   Klasse, dann hilft sie vielleicht!"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

return helper_d14525e2
