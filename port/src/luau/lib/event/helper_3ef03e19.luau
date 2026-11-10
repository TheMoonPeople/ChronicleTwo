--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_3ef03e19(arg0: s32, arg1: s32)
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Tu as trouv[UNI00e9] des marrons ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 301 then
		event.open_message_window_2(
			0,
			"Alors, tu ne peux pas m'aider...<page>Tant pis, je ne ferai pas\nde castagnaccio, voil[UNI00e0] tout."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oui, c'est [UNI00e7]a ! Merci beaucoup ! Je<page>vais pouvoir faire un castagnaccio.<page>Je te ferai go[UNI00fb]ter si tu veux."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Comment te remercier... ?<page>Quoi, te suivre dans une aventure ?<page>Ha ha ! Mais bien s[UNI00fb]r...<page>Il fallait le dire tout de suite."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

return helper_3ef03e19
