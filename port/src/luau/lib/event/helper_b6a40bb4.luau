--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_6fd4648e = require("@lib/event/helper_6fd4648e")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_b6a40bb4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_6fd4648e(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Tu devrais conna[UNI00ee]tre ma r[UNI00e9]ponse [UNI00e0]\n[UNI00e7]a : PAS QUESTION !<page>C'est pas mon genre de travailler\npour le compte des autres !"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "[UNI00c7]a ne m'apporte pas grand-chose et\nen plus, c'est trop dangereux.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mais puisque c'est toi, je pense\nque je vais y r[UNI00e9]fl[UNI00e9]chir.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mais bon, je suis fils de\ncommer[UNI00e7]ant et chez nous, rien\nn'est gratuit.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je collectionne les pi[UNI00e8]ces de<page>monnaie, le symbole du commerce. Et\nje r[UNI00ea]ve de compl[UNI00e9]ter ma collection."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Mais je n'arrive pas [UNI00e0] mettre la\nmain sur la Pi[UNI00e8]ce de sacrifice et\nla Pi[UNI00e8]ce de Solidit[UNI00e9].<page>Si tu les trouves pour moi, je\nt'aiderai peut-[UNI00ea]tre [UNI00e0] mon tour."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

return helper_b6a40bb4
