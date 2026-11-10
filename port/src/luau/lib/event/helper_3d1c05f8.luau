--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_3d1c05f8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Ah, capitate a proposito!\nVolevo parlarvi di una cosa.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Sicuramente sapete che sto\npreparando dolci esotici da tutto\nil mondo, per la mia ricerca.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Pare che esista un dolce chiamato\nCastagnaccio.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "fatto con una certa Castagna.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ho scoperto che la Castagna cresce\nsu alberi chiamati Castagni.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Pensavo di usare le Castagne,\nma stranamente...\nnon se ne trovano pi[UNI00f9] in citt[UNI00e0]!"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Il Sindaco se le [UNI00e8] accaparrate tutte.\nNon [UNI00e8] che potreste darmi una mano?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

return helper_3d1c05f8
