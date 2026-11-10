--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_e787350a = require("@lib/event/helper_e787350a")

--- Helper function.
local function helper_2d25d662(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Du willst, dass ich\nmitkomme?<page>Ich bin nur eine B[UNI00e4]ckerin,\naber wenn du mich brauchst,\nhelfe ich gern."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Oh, aber zuerst habe ich eine\nLieferung f[UNI00fc]r Morton.<page>K[UNI00f6]nntest du diese 20 Brotlaibe\nf[UNI00fc]r mich zu Mortons Laden bringen?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "W[UNI00e4]hrend du das erledigst,\npacke ich f[UNI00fc]r die Reise.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(300, 20)
	helper_e787350a(300, 20)
	helper_a87eb945(1)
	event.open_message_window_2(0, "Was um alles in der\nWelt will er mit 20 Laiben?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

return helper_2d25d662
