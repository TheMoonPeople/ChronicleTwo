--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_fb2b6b13 = require("@lib/event/helper_fb2b6b13")

--- Helper function.
local function helper_88ce71c3(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_fb2b6b13(arg1, arg0)
	event.open_message_window_2(0, "Mpfffff...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Che vuoi dire con\n'cosa sto blaterando'?<page>Sto tentando di ricordare\nla combinazione della cassaforte."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Come sarebbe\n'quale cassaforte'?<page>La cassaforte nascosta dietro\nil quadro nel mio ufficio, no?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_fb2b6b13(arg0, arg1)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(
		0,
		"Ah, mi hai messo una paura!<page>Oh, maledizione!<page>Mi son lasciato scappare il\nmio segreto pi[UNI00f9] grande!<page>Oh bene, ora lo sai.<page>Forse puoi darmi una mano\na risolvere il problema."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ho un grosso problema:\nnon riesco a ricordare\nla combinazione della cassaforte.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] un numero a 4 cifre. Ho usato\nla data di nascita di Claire,\nconvinto di ricordarmela sempre."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Come posso essermela dimenticata?<page>Che padre snaturato sono!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pare che il Sindaco sia nei guai.\n   Ascolta cosa dice del compleanno\n   di Claire e scopri la combinazione."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

return helper_88ce71c3
