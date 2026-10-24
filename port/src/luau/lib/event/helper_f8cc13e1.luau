--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_f8cc13e1(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "Ah, capitate a proposito!\nVolevo parlarvi di una cosa.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Sicuramente sapete che sto\npreparando dolci esotici da tutto\nil mondo, per la mia ricerca.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Pare che esista un dolce chiamato\nCastagnaccio.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "fatto con una certa Castagna.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Ho scoperto che la Castagna cresce\nsu alberi chiamati Castagni.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Pensavo di usare le Castagne,\nma stranamente...\nnon se ne trovano pi[UNI00f9] in citt[UNI00e0]!"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Il Sindaco se le [UNI00e8] accaparrate tutte.\nNon [UNI00e8] che potreste darmi una mano?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

return helper_f8cc13e1
