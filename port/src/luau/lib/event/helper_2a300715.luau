--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_a9cbe524 = require("@lib/event/helper_a9cbe524")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_2a300715(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var6 = event.get_save_counter(7) or var6
	if var6 == 0 then
		event.open_message_window_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_a9cbe524(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.open_message_window_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_a9cbe524(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.open_message_window_2(0, "H[UNI00e9], on ne triche pas !")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_a9cbe524(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_message_number(0, 1, var2)
	event.set_message_number(0, 2, var3)
	event.set_message_number(0, 3, var4)
	if var5 == 0 then
		event.open_message_window_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_a9cbe524(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

return helper_2a300715
