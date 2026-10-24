--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_8395480a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Ultimamente, non mi sento in forma.<page>Non mi va di fare un viaggio.<page>Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Anche solo stare in piedi mi\nfa venire le vertigini.<page>[UNI00c8] difficile da spiegare. [UNI00c8] come\nse il mondo fosse deformato."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Mmh... se il Dottor Dell\nnon capisce di che si tratta,\nallora io non posso fare molto...")
		helper_b5a98ffa(0, -1, arg1, arg0, 0)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ricordo quei sintomi.")
	helper_b5a98ffa(0, -1, arg1, arg0, 0)
	event.MesMake_2(
		0,
		"Quando sono nata, il mondo\nera in pessimo stato, con molte\npi[UNI00f9] distorsioni temporali\ndi quanto voi possiate immaginare."
	)
	helper_b5a98ffa(0, -1, arg1, arg0, 0)
	event.MesMake_2(
		0,
		"Di questo ne risentivano le\npersone pi[UNI00f9] deboli e fragili.<page>I pi[UNI00f9] esili lamentavano vertigini,\ni pi[UNI00f9] grossi non si reggevano in piedi."
	)
	helper_b5a98ffa(0, -1, arg1, arg0, 0)
	event.MesMake_2(
		0,
		"Forse sei troppo sensibile\na questo genere di cose.<page>Senti persino le poche distorsioni\ntemporali che abbiamo qui!"
	)
	helper_b5a98ffa(0, -1, arg1, arg0, 0)
	event.MesMake_2(0, "Se eliminassimo le distorsioni pi[UNI00f9]\nvicine, forse staresti meglio.")
	helper_b5a98ffa(0, -1, arg1, arg0, 0)
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Eliminare distorsioni temporali, Spheda!\n   Se completi circa 10 livelli,\n   forse Mena star[UNI00e0] meglio."
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

return helper_8395480a
