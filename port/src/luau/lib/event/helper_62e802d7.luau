--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a79d0b65 = require("@lib/event/helper_a79d0b65")

--- Helper function.
local function helper_62e802d7(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_a79d0b65()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"Che c'[UNI00e8] che non va?\nTi arrendi di nuovo?<page>Mi deludi!\n[UNI00c8] questo che succede ad armeggiare\ntroppo con le macchine?"
		)
		helper_635ee3fd(0, -1, arg0, arg1, 0)
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
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"OK, ti aiuter[UNI00f2].\nMa non lo faccio per te.<page>Se questa citt[UNI00e0] [UNI00e8] in pericolo,\nnon posso stare con\nle mani in mano."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_a79d0b65()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

return helper_62e802d7
