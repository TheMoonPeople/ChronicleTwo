--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_fce95934(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 == 0 then
		event.open_message_window_2(0, "Oh, stai\naiutando Polly?<page>Grandioso.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Che me ne faccio\ndi 20 pagnotte?<page>Beh, dar[UNI00f2] un\nfonduta-party oggi!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			'Per fare un parallelo con le tue famose\n"invenzioni", [UNI00e8] una combo culinaria di<page>formaggio, pane e vino!'
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"[UNI00c8] buono. Ne mangiano a tonnellate,\nper questo mi serve tanto pane.<page>Ma veramente non volevo che\nmi venisse consegnato qui."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Scusa Max, potresti portarmele\na casa, per favore?<page>Sai dov'[UNI00e8], vero?\nVicino al campo di zucche."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 1)
	end
	if var2 == 1 then
		event.open_message_window_2(0, "Sai dov'[UNI00e8], vero?\nVicino al campo di zucche.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.open_message_window_2(0, "Niente pi[UNI00f9] party?!\nChe peccato!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "In tal caso, il pane non mi serve.\nLo riporteresti a Polly per me?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 3)
	end
	if var2 == 3 then
		event.open_message_window_2(0, "Scusa, riporteresti il\npane a Polly per me?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_fce95934
