--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_07936a80 = require("@lib/event/helper_07936a80")
local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_8b5773f5(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hola, Max.\n[UNI00bf]Quieres probar otra vez?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_07936a80(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"Eh. No has ido hasta la barca,\n[UNI00bf]no? Quer[UNI00ed]as enga[UNI00f1]arme.\n[UNI00a1]No seas tramposo!"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_07936a80(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "[UNI00a1]Eh, no hagas trampas!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_07936a80(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Has llegado.\nBien,<page>vamos a ver\ntu tiempo.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "[UNI00a1]Vaya por Dios!\n[数値２] minutos.[数値３] segundos.\nDemasiado lento.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_07936a80(arg0, arg1)
		return
	end
	event.MesMake_2(0, "[UNI00a1]Oh!\n[数値１] minutos [数値２] segundos[数値３].\nNo est[UNI00e1] mal.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Eres m[UNI00e1]s r[UNI00e1]pido de lo que parece. Vale,\nvamos a pelear contra los malos juntos."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_95dae095()
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

return helper_8b5773f5
