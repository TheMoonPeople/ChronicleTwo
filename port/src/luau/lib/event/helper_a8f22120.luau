--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_a8f22120(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_c8484b43(arg0, 0, 0)
		event.open_message_window_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.open_message_window_2(0, "...")
		helper_0ffc2526(0, -1, arg1, arg0, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
		)
		show_message(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "H[UNI00e9] Max.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "...")
	helper_0ffc2526(0, -1, arg1, arg0, 0)
	event.open_message_window_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Personne ne peut dessiner la vie.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

return helper_a8f22120
