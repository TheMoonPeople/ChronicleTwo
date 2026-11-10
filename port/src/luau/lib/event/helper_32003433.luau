--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_12b70c35 = require("@lib/event/helper_12b70c35")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_32003433(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_12b70c35(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Oh, Max ! Tu as l'air de tra[UNI00ee]ner\npas mal en ce moment. Tu te\nportes bien ?<page>Je peux faire quelque chose ?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ah bon ! Tu veux que je\nt'accompagne dans tes aventures ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mmm... J'aimerais bien venir avec\ntoi... Mais ce pauvre arbre ne va\npas tr[UNI00e8]s bien.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Soigner les arbres et les fleurs\nde cette propri[UNI00e9]t[UNI00e9] est ma grande\npriorit[UNI00e9], tu sais.<page>Si je pars me balader maintenant,\nje pourrais perdre mon travail."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je parie que l'eau sacr[UNI00e9]e vendue [UNI00e0]\nl'[UNI00e9]glise soignerait cet arbre !<page>Mais, comme tu le sais, ton p[UNI00e8]re et\nP[UNI00e8]re Bruno ne s'entendent pas...<page>Ton p[UNI00e8]re ne me donnera jamais de\nsous pour acheter de l'eau sacr[UNI00e9]e !<page>J'ai un vrai probl[UNI00e8]me l[UNI00e0]."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Pour que Gordon aille [UNI00e0] Sindain,\n   tu dois le convaincre de venir\n   avec toi.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]R[UNI00e9]alise la mission de Gordon\n   et il montera dans le train pour\n   t'accompagner."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux consulter tes missions\n   en lisant ton carnet de notes,\n   situ[UNI00e9] dans le menu Objets."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	argc = event.get_owned_item_count(386) or argc
	if argc <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]Oh, tu n'as pas de carnet.\n   Il y en a un sur la table\n   chez C[UNI00e9]dric, le r[UNI00e9]parateur."
		)
		helper_75684dd8(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Il y en a un autre dans la\n   base secr[UNI00e8]te de Donny. Ils se valent.\n   R[UNI00e9]cup[UNI00e8]re l'un d'eux !"
		)
		helper_75684dd8(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

return helper_32003433
