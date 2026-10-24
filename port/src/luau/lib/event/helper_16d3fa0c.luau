--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c6e8776a = require("@lib/event/helper_c6e8776a")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_16d3fa0c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Ehi, Max.\nVieni a provarci di nuovo?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_c6e8776a(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "Ohi! Non sei arrivato alla barca,\nvero? Hai cercato di fregarmi.\nNon imbrogliare!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_c6e8776a(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "Ehi, niente scherzi!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_c6e8776a(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh, sei tornato!\nBene,<page>Controlliamo\nil tuo tempo!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh mio Dio!\n[数値１] minuti [数値２].[数値３] secondi [UNI00e8]\ntroppo.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_c6e8776a(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] minuti [数値２] secondi [数値３]\nnon [UNI00e8] niente male!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Sei pi[UNI00f9] veloce di quanto sembra.\nOK, combattiamo i cattivi insieme!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_95dae095()
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

return helper_16d3fa0c
