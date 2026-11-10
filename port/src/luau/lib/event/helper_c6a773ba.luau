--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_c6a773ba(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Du denkst bestimmt, ich bin nutzlos,\nweil ich ein M[UNI00e4]dchen bin.<page>Aber ich bringe den Leuten\nimmer viel Gl[UNI00fc]ck."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Wenn ich unterwegs bin, regnet\nes nie, und eine Los-Niete hab\nich noch nie gesehen.<page>Was meinst du?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Na gut.\nNein, tut mir Leid.")
	var3 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(arg0, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if var3 ~= 0 then
		event.open_message_window_2(0, "Was? Sei nicht gemein!\nDu bist so fies!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Du bist bl[UNI00f6]d!<page>Du Dummkopf!<page>Du Idiot!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Du nimmst mich mit?<page>Das h[UNI00e4]tte ich nicht gedacht!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Aber warum muss ich als Einzige\nfragen, wenn du all die anderen\nselbst um Hilfe bittest?<page>Wenn du einfach gefragt h[UNI00e4]ttest,\nh[UNI00e4]tte ich nat[UNI00fc]rlich geholfen."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df] - wenn du mich findest,\nhelf ich dir. Abgemacht?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mit anderen Worten, wir\nspielen  Verstecken!<page>Gut, los geht's!")
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
		"[(!)]Na ja ... Du versuchst wohl besser,\n   Corinne zu finden. Sie hat sich\n   bestimmt in Palm Brinks versteckt."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

return helper_c6a773ba
