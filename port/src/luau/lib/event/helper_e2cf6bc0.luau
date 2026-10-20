--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5c5a8609 = require("@lib/event/helper_5c5a8609")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_e2cf6bc0(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_5c5a8609()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"Che c'[UNI00e8] che non va?\nTi arrendi di nuovo?<page>Mi deludi!\n[UNI00c8] questo che succede ad armeggiare\ntroppo con le macchine?"
		)
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Oh! Sembra che tu sia diventato\nbravo anche con le armi!<page>Non serve guardarti sparare:\nsi vede gi[UNI00e0] da come la tieni."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"OK, ti aiuter[UNI00f2].\nMa non lo faccio per te.<page>Se questa citt[UNI00e0] [UNI00e8] in pericolo,\nnon posso stare con\nle mani in mano."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_5c5a8609()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

return helper_e2cf6bc0
