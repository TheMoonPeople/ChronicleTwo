--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_7055d59a = require("@lib/event/helper_7055d59a")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_2380c1db(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_7055d59a(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_7055d59a(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "H[UNI00e9], on ne triche pas !")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_7055d59a(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_7055d59a(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

return helper_2380c1db
