--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_ae607693(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 < 3 then
		event.open_message_window_2(0, "Mi spiace, non sono\nancora pronta.<page>Puoi concedermi\naltro tempo?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "A proposito, hai gi[UNI00e0] fatto\nquella consegna a Morton?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Cosa! Come pu[UNI00f2] essere\ncos[UNI00ec] sconsiderato?<page>Oh, va bene:\nprendile tu.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Lascia perdere,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

return helper_ae607693
