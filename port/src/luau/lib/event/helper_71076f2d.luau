--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_5f586269 = require("@lib/event/helper_5f586269")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_71076f2d(arg0: s32, arg1: s32)
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
		event.open_message_window_2(0, "Hallo, Max.\nWillst du nochmal probieren?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_5f586269(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.open_message_window_2(0, "He! Du warst nicht beim Boot,\noder? Du wolltest mich\ndrankriegen! Mogeln gilt nicht.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_5f586269(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.open_message_window_2(0, "He, nicht mogeln!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_5f586269(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh, da bist du ja wieder!\nGut,<page>sehen wir mal\nnach der Zeit!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_message_number(0, 1, var2)
	event.set_message_number(0, 2, var3)
	event.set_message_number(0, 3, var4)
	if var5 == 0 then
		event.open_message_window_2(0, "Oh Mann!\n[数値１] Min. [数値２] Sek. [数値３] ist\nzu langsam.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		helper_5f586269(arg0, arg1)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] Min. [数値２] Sek. [数値３]\nist keine schlechte Zeit!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Du bist schneller als du aussiehst.\nDann verm[UNI00f6]beln wir zusammen\ndie Fieslinge!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

return helper_71076f2d
