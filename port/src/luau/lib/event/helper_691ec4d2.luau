--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_691ec4d2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.open_message_window_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je parie que tu crois que je serai\ninutile parce que je suis une fille<page>alors qu'en fait, je porte chance\naux gens que je c[UNI00f4]toie."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Il ne pleut jamais quand je sors,\net je n'ai jamais vu un billet de\nloterie perdant.<page>Qu'est-ce que tu en penses ?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "D'accord.\nNon merci.")
	var3 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(arg0, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var3 ~= 0 then
		event.open_message_window_2(0, "Pourquoi ? C'est injuste !\nT'es horrible !")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "T'es naze !<page>Imb[UNI00e9]cile !<page>Stupide !")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Tu m'emm[UNI00e8]neras avec toi ?<page>Je croyais pas que tu le ferais !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Mais pourquoi je suis la seule qui\ndoive te le demander, alors que tu\nl'as demand[UNI00e9] [UNI00e0] tous les autres ?<page>Il suffisait de le demander pour\nque je vienne."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Je sais, si tu arrives [UNI00e0] me\ntrouver, je t'aiderai. D'accord ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Bref, on va jouer [UNI00e0] cache-cache !<page>Allez, on y va !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	wait_frames(30)
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_villager_ai_enabled(1, arg0)
	event.set_character_active(0, arg0)
	event.delete_villager(arg0)
	event.fade_in_screen(30)
	wait_frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Bien... on dirait qu'il va falloir\n   retrouver Corinne. Elle se cache\n   s[UNI00fb]rement quelque part [UNI00e0] Palm Brinks."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

return helper_691ec4d2
