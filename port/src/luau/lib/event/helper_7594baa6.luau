--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_7594baa6(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "Ah, tu arrives bien !\nJe voulais te parler de quelque\nchose.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Tu sais s[UNI00fb]rement que je cherche\ntoujours [UNI00e0] d[UNI00e9]couvrir de nouvelles\np[UNI00e2]tisseries venues du monde entier.\n"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "On m'a parl[UNI00e9] d'un g[UNI00e2]teau appel[UNI00e9]\ncastagnaccio...")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Confectionn[UNI00e9] [UNI00e0] base de castarnas.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"J'ai appris que ces castarnas\npoussaient sur des arbres de la\nfamille des ch[UNI00e2]taigniers."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Alors j'ai pens[UNI00e9] essayer la recette\navec des marrons, mais bizarrement,\nil n'y a plus un marron en ville."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Il para[UNI00ee]t que le Maire les a tous\nachet[UNI00e9]s... Tu ne pourrais pas\nm'aider ?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

return helper_7594baa6
