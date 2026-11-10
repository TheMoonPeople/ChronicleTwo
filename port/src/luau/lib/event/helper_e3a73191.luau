--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_e3a73191(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 < 3 then
		event.open_message_window_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

return helper_e3a73191
