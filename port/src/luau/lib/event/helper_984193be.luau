--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_984193be(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Personnellement, je m'y connais\nen poissons.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"J'ai entendu dire que des hommes\norganisaient un concours o[UNI00f9]\ns'affrontaient leurs poissons.<page>Si tu en as un, pourquoi ne pas\nessayer de finir premier ?<page>Si tu [UNI00e9]choues, je saurais que tu \nne m[UNI00e9]rites pas mon aide."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Il doit s'agir de la Course de poissons.\n   Pourquoi ne pas tenter la cat[UNI00e9]gorie\n   D[UNI00e9]butants ? Elle t'aidera peut-[UNI00ea]tre."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

return helper_984193be
