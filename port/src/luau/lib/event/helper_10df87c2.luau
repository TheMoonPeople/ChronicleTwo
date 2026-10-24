--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")

--- Helper function.
local function helper_10df87c2(arg0: s32, arg1: s32)
	local var2: any = 0
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Klar, ich versuch's.\nIch pack's nicht.")
	var2 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "Na gut ...<page>Gut, wenn du's wieder probieren\nwillst, sag Bescheid. Ich warte.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "Auf die Pl[UNI00e4]tze, fertig,\nlos!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

return helper_10df87c2
