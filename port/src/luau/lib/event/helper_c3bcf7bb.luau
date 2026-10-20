--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_c3bcf7bb(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Klar, ich versuch's.\nIch pack's nicht.")
	var2 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "Na gut ...<page>Gut, wenn du's wieder probieren\nwillst, sag Bescheid. Ich warte.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "Auf die Pl[UNI00e4]tze, fertig,\nlos!")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

return helper_c3bcf7bb
