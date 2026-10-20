--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_87c945a8 = require("@lib/event/helper_87c945a8")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_266f1f07(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_87c945a8(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ehi Max, sei venuto a cercare me?<page>Ti stavo aspettando.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Grazie alle mura del castello,\nquesta citt[UNI00e0] [UNI00e8] abbastanza sicura.<page>[UNI00c8] giunto il momento di uscire."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"[UNI00c8] un bene che tu stia sempre\nad armeggiare con le macchine,\nma mi chiedo quanto forte tu sia."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Combattere significa velocit[UNI00e0]\ne lavoro di gambe.<page>Se sei pi[UNI00f9] lento di me,\nnon va affatto bene."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Facciamo una prova! Corri alla\nbarca sul lago e torna indietro.<page>Il mio record [UNI00e8] 2 minuti e\n1 secondo. Se non lo superi,\nnon va affatto bene."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Che ne dici, vuoi provare?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_87c945a8(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_266f1f07
