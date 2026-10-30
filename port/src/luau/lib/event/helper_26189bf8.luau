--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_cedb80c8 = require("@lib/event/helper_cedb80c8")

--- Helper function.
local function helper_26189bf8(arg0: s32, arg1: s32)
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
		event.open_message_window_2(0, "Ehi, Max.\nVieni a provarci di nuovo?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_cedb80c8(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.open_message_window_2(0, "Ohi! Non sei arrivato alla barca,\nvero? Hai cercato di fregarmi.\nNon imbrogliare!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_cedb80c8(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.open_message_window_2(0, "Ehi, niente scherzi!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_cedb80c8(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh, sei tornato!\nBene,<page>Controlliamo\nil tuo tempo!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_message_number(0, 1, var2)
	event.set_message_number(0, 2, var3)
	event.set_message_number(0, 3, var4)
	if var5 == 0 then
		event.open_message_window_2(0, "Oh mio Dio!\n[数値１] minuti [数値２].[数値３] secondi [UNI00e8]\ntroppo.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Vuoi provare di nuovo?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_cedb80c8(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] minuti [数値２] secondi [数値３]\nnon [UNI00e8] niente male!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Sei pi[UNI00f9] veloce di quanto sembra.\nOK, combattiamo i cattivi insieme!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

return helper_26189bf8
