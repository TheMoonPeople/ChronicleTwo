--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_95af68d6(arg0: s32, arg1: s32)
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Hast du Kastanien bekommen?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 301 then
		event.open_message_window_2(0, "Du kannst also nicht helfen.<page>Tja, dann vergesse ich das\nCastagnaccio besser.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ja, genau die. Vielen Dank.<page>Jetzt kann ich mal Castagnaccio machen.<page>Du kannst probieren, wenn's\nfertig ist."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Kann ich mich denn revanchieren?<page>Wie? Ich soll dich begleiten?<page>Ha ha! Nat[UNI00fc]rlich mach ich das.<page>Warum hast du nicht gleich gefragt?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

return helper_95af68d6
