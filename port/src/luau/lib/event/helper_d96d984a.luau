--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_d96d984a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.open_message_window_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Seguro que piensas que\nno valdr[UNI00e9] para nada porque soy una chica.<page>Pues la verdad es que\ntraigo suerte a la gente."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Nunca llueve cuando salgo\ny nunca he visto ning[UNI00fa]n\nbillete de loter[UNI00ed]a perdedor.<page>[UNI00bf]Qu[UNI00e9] me dices?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Est[UNI00e1] bien.\nNo, lo siento.")
	var3 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(arg0, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var3 ~= 0 then
		event.open_message_window_2(0, "[UNI00a1][UNI00bf]Por qu[UNI00e9]?! No seas as[UNI00ed].\nEres muy mala.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "[UNI00a1]Eres una in[UNI00fa]til!<page>[UNI00a1]Est[UNI00fa]pida!<page>[UNI00a1]Idiota!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00bf]Me vas a llevar contigo?<page>[UNI00a1]Cre[UNI00ed]a que no lo har[UNI00ed]as!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] soy yo la [UNI00fa]nica\nque tiene que ped[UNI00ed]rtelo, cuando t[UNI00fa] has ido\npor ah[UNI00ed] preguntando a los dem[UNI00e1]s?<page>Si me lo hubieras pedido, te\nhabr[UNI00ed]a ayudado."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ya lo s[UNI00e9]: si me encuentras,\nte ayudar[UNI00e9]. [UNI00bf]Qu[UNI00e9] te parece?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "En otras palabras: [UNI00a1]vamos a jugar al escondite!<page>[UNI00a1]Venga, vamos!")
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
		"[(!)]Vaya... Ser[UNI00e1] mejor que te pongas\na buscar a Corinne. Seguramente estar[UNI00e1] escondida\nen alg[UNI00fa]n lugar de Palm Brinks."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

return helper_d96d984a
