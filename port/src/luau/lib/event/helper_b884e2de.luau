--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_b884e2de(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Wie bitte?<page>Kannst du nicht langsamer reden?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Bitte gib ein:"Komm mit mir." ', "Komm mit mir.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 == 0 then
		event.open_message_window_2(0, "Was redest du da?\nIch verstehe nichts ...")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ein Abenteuer?\nDas w[UNI00e4]re sch[UNI00f6]n.<page>Aber was n[UNI00fc]tzt dir da\neine alte Frau wie ich?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

return helper_b884e2de
