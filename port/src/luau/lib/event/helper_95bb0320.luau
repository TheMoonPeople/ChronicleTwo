--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_95bb0320(arg0: s32, arg1: s32)
	local argc: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	argc = event.get_item_count(25) or argc
	if argc <= 0 then
		event.open_message_window_2(
			0,
			"Qu'est-ce qui se passe ?\nTu baisses encore les bras ?<page>Tu me d[UNI00e9][UNI00e7]ois.\nC'est [UNI00e0] [UNI00e7]a que [UNI00e7]a m[UNI00e8]ne de bricoler\ndes machines [UNI00e0] longueur de journ[UNI00e9]e ?"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh ! On dirait que tu commences\n[UNI00e0] t'y conna[UNI00ee]tre en armes aussi !<page>Il suffit de voir comment tu les\ntiens pour s'en rendre compte..."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"OK, je vais t'aider.\nMais je ne le fais pas pour toi.<page>Si cette ville est en danger,\nje ne peux pas rester assis\nici [UNI00e0] me tourner les pouces."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

return helper_95bb0320
