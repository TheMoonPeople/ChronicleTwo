--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_632104df(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Oh, tu aides\nPolly ?<page>Super.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Ce que je vais faire\navec ces 20 pains ?<page>Eh bien, j'ai organis[UNI00e9] une soir[UNI00e9]e\nfondue savoyarde pour ce soir."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Pour l'\"inventeur\" que tu es,\nc'est une combinaison culinaire<page>de fromage, de pain et de vin !"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"C'est super bon. On en mange tant\nqu'il faut des tonnes de pain.<page>Mais je ne voulais pas\nqu'il soit livr[UNI00e9] ici."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9] Max, mais tu pourrais\nl'emporter chez moi ?<page>Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.MesMake_2(0, "Annul[UNI00e9]e ?!\nComme c'est dommage !")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Dans ce cas, je n'ai plus besoin\nde pain. Tu pourrais le rapporter\n[UNI00e0] Polly ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "D[UNI00e9]sol[UNI00e9], mais tu peux rapporter\nle pain [UNI00e0] Polly pour moi ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_632104df
