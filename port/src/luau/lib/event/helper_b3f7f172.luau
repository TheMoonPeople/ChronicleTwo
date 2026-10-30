--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_b3f7f172(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_save_counter(12) or var2
	if var2 == 0 then
		event.open_message_window_2(0, "Oh, tu aides\nPolly ?<page>Super.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Ce que je vais faire\navec ces 20 pains ?<page>Eh bien, j'ai organis[UNI00e9] une soir[UNI00e9]e\nfondue savoyarde pour ce soir."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Pour l'\"inventeur\" que tu es,\nc'est une combinaison culinaire<page>de fromage, de pain et de vin !"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"C'est super bon. On en mange tant\nqu'il faut des tonnes de pain.<page>Mais je ne voulais pas\nqu'il soit livr[UNI00e9] ici."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"D[UNI00e9]sol[UNI00e9] Max, mais tu pourrais\nl'emporter chez moi ?<page>Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 1)
	end
	if var2 == 1 then
		event.open_message_window_2(0, "Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.open_message_window_2(0, "Annul[UNI00e9]e ?!\nComme c'est dommage !")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Dans ce cas, je n'ai plus besoin\nde pain. Tu pourrais le rapporter\n[UNI00e0] Polly ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_save_counter(12, 3)
	end
	if var2 == 3 then
		event.open_message_window_2(0, "D[UNI00e9]sol[UNI00e9], mais tu peux rapporter\nle pain [UNI00e0] Polly pour moi ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	end
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_b3f7f172
