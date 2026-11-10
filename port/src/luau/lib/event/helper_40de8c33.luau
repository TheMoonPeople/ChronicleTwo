--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_40de8c33(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Tu sei Monica,\ngiusto?<page>Ho sentito dire che\nnon sei niente male con la spada.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ma le spade non sono\ngiocattoli, lo sai.<page>Devi pensare a\ncosa hai davanti.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Se potenzi una spada di 2 livelli,\nmi convincer[UNI00f2] del tuo talento!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Perch[UNI00e9] non cominci\ncon il Gladio?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(44)
	helper_f38eabca(44, 1)
	helper_a87eb945(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Se vuoi farti accettare da\n   Milane, dovrai potenziare il\n   Gladio di 2 livelli.")
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi anche comprare o trovare le armi.\n   L'importante [UNI00e8] procurarsene di\n   potenti, cos[UNI00ec] Milane ti aiuter[UNI00e0]."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

return helper_40de8c33
