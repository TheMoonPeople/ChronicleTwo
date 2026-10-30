--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_84c07dcc = require("@lib/event/helper_84c07dcc")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_8788f143(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	helper_84c07dcc(arg0)
	event.open_message_window_2(0, "... 1212,<page>Nein, nein, es war bestimmt 1122.<page>Oder vielleicht auch 1010.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Wenn er nicht einmal Notiz\n  von dir nimmt, wenn du "Hallo." sagst, hat er \n   wohl ernsthafte Probleme.<page>[(!)]Versuch\'s doch sp[UNI00e4]ter nochmal.\n   Vielleicht kannst du ihm zur\n   Hand gehen oder ein Ohr leihen.'
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

return helper_8788f143
