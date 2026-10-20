--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7d9a42e5 = require("@lib/event/helper_7d9a42e5")
local helper_8333218b = require("@lib/event/helper_8333218b")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_d2022a4b(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8333218b(300, 20)
		end
		if at <= 5 then
			helper_7d9a42e5(1)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Du willst, dass ich\nmitkomme?<page>Ich bin nur eine B[UNI00e4]ckerin,\naber wenn du mich brauchst,\nhelfe ich gern."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, aber zuerst habe ich eine\nLieferung f[UNI00fc]r Morton.<page>K[UNI00f6]nntest du diese 20 Brotlaibe\nf[UNI00fc]r mich zu Mortons Laden bringen?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "W[UNI00e4]hrend du das erledigst,\npacke ich f[UNI00fc]r die Reise.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_8333218b(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_7d9a42e5(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Was um alles in der\nWelt will er mit 20 Laiben?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

return helper_d2022a4b
