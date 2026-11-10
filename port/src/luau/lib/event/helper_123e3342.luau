--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_84c07dcc = require("@lib/event/helper_84c07dcc")

--- Helper function.
local function helper_123e3342(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Mpfffff...")
	helper_84c07dcc(arg0)
	event.open_message_window_2(0, "...1212,<page>No, no, era proprio 1122.<page>O forse 1010...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mpfffff...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Se non ti ha neppure sentito\n   dire "Salve." allora deve\n   avere dei problemi seri.<page>[(!)]Perch[UNI00e9] non provi pi[UNI00f9] tardi?\n   Potresti dargli una mano, o\n   un orecchio o qualcos\'altro.'
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

return helper_123e3342
