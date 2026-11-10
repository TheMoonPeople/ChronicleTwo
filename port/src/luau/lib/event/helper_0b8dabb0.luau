--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0b8dabb0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(9) or var2
	money = event.get_money() or money
	if var2 == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Questa cifra non mi permetter[UNI00e0]\ndi partecipare all'asta.<page>Ho bisogno di 1000 Gilda.\nCercate di non sbagliare!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(0, "Non ci crederete!<page>Il prezzo [UNI00e8] salito\na 1200 Gilda.")
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.open_message_window_2(0, "Scusate tanto, vi dispiacerebbe\nprocurarmi 1500 Gilda?")
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nsar[UNI00e0] venduto a qualcun altro.<page>Portatemi 1500 Gilda, presto!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
		else
			event.open_message_window_2(
				0,
				"[UNI00c8] terribile!\nQualcuno ha offerto 1800 Gilda!<page>Se non offro almeno 2000 Gilda,\nnon riuscir[UNI00f2] ad aggiudicarmelo."
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Non perdiamo tempo, altrimenti\nverr[UNI00e0] venduto a qualcun altro.<page>Portatemi 2000 Gilda, presto!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Figliolo, sei riuscito a\nracimolare i miei 2000 Gilda?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Che posso farci, [UNI00e8] tuo.\nPer[UNI00f2] che spreco!")
		var4 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if var4 ~= 0 then
			event.open_message_window_2(
				0,
				"Gi[UNI00e0], 2000 Gilda sono molti soldi.\nDev'essere duro separarsene.\nAnche per un damerino come te...<page>Va bene allora, non importa!\nMa l'asta non [UNI00e8] ancora finita.\nAspetter[UNI00f2] anche in eterno!"
			)
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Grazie tante.<page>Andr[UNI00f2] subito all'asta!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_villager_ai_enabled(1, arg0)
		event.set_character_active(0, arg0)
		event.delete_villager(arg0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Grazie tante.\nLa mia era l’offerta migliore.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Alzata l'offerta, si sono ritirati\ntutti: l'ho avuto per 1400 Gilda!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Quindi posso ridarvene 600.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.add_money(600)
	event.open_message_window_2(0, "E d'ora in poi, lavorer[UNI00f2] sodo per\nrestituirvi il resto del prestito.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "So di avervi messo nei guai.\nVi devo un favore.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

return helper_0b8dabb0
