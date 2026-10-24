--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_b74f3920 = require("@lib/event/helper_b74f3920")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_5ef2ff27(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	var2 = event.GotoUseItem(376) or var2
	vm.wait(3)
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 376 then
		event.MesMake_2(
			0,
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.SetNpcStatus(22, 130)
	helper_b74f3920(22)
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

return helper_5ef2ff27
