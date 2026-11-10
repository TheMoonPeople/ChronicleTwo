--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_27f87c4b = require("@lib/event/helper_27f87c4b")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_863f4c9c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local item: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_27f87c4b(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Max, sistemare quest'albero\n[UNI00e8] ci[UNI00f2] che mi preme di pi[UNI00f9].<page>Allora, per rimetterlo in sesto,\nmi serve..."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 276 then
		event.open_message_window_2(0, "Max, non funzioner[UNI00e0]...<page>Mi serve l'Acqua Sacra\ndi Don Bruno.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"S[UNI00ec]! Max, ce l'hai fatta! Ora\nposso prendermi cura dell'albero!<page>Ti ringrazio, Max."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Bene, sembra che abbia sbrigato\ntutte le mie faccende.<page>Ora posso seguirti\nnella tua avventura!<page>Oh, e mi raccomando, non parlare\na tuo padre dell'Acqua Sacra, OK?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon si [UNI00e8] unito al gruppo.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puoi sfruttare le sue capacit[UNI00e0]\n   con il comando Stato sotto\n   Personaggi, nel Menu principale.<page>[(!)]Se recluti qualcun altro\n   nella tua avventura, quella\n   persona salir[UNI00e0] sul treno."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Parla alla persona sul treno\n   per inserirla nel gruppo\n   come terzo membro.<page>[(!)]Per trasferire uno dei tuoi amici\n   in una casa, scegli Alloggia persone\n   dal Menu sulla porta della casa."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Molti altri potrebbero\n   voler venire con te.\n   Mi raccomando, cercali!")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	var4 = event.get_triggered_event_data_2(14) or var4
	event.set_npc_party_status(var4, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

return helper_863f4c9c
