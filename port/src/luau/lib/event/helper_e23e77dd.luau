--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_e23e77dd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Che hai detto?<page>Puoi parlare pi[UNI00f9] lentamente?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Scrivi "Andiamo insieme."', "Andiamo insieme.", 0)
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
		event.open_message_window_2(0, "Cosa stai blaterando?\nNon capisco...")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Un'avventura?\nSarebbe carino.<page>Ma a cosa pu[UNI00f2] servirti\nuna vecchia come me?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

return helper_e23e77dd
