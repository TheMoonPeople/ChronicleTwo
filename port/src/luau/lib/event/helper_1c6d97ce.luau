--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_1c6d97ce(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "What was that?<page>Can't you talk a bit more slowly?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Please enter, "Let\'s go together."', "Let's go together.", 0)
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
		event.open_message_window_2(0, "What are you going on about?\nI've no idea...")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "An adventure?\nThat would be nice.<page>What use could an old\nwoman like me be?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

return helper_1c6d97ce
