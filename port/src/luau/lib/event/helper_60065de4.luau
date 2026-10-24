--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_5f9540e0 = require("@lib/event/helper_5f9540e0")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_60065de4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_5f9540e0(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Dovresti gi[UNI00e0] sapere la risposta:\nNEANCHE PER SOGNO!<page>Perch[UNI00e9] dovrei faticare per\nfare un favore a qualcun altro?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "A me non ne viene niente\ned [UNI00e8] troppo pericoloso.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Comunque, siccome sei tu, potrei\nanche farci un pensierino.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Sono figlio di un commerciante io,\nnon faccio certo favori gratis!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Saprai che colleziono monete.<page>Sono il perno degli affari. Come\nvorrei completare la collezione!"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Non riesco mai a mettere\nle mani sulla Moneta oscura\ne sulla Moneta eterna.<page>Se mi aiutassi,\nforse io potrei aiutare te."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

return helper_60065de4
