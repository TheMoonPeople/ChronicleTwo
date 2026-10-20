--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b6d778a6 = require("@lib/event/helper_b6d778a6")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_968430c3(arg0: s32, arg1: s32)
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
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_b6d778a6(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "H[UNI00e9] Max, tu es venu me chercher ?<page>Je t'attendais.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Gr[UNI00e2]ce aux remparts, cette ville\nest bien prot[UNI00e9]g[UNI00e9]e. Nous devrions<page>maintenant en sortir."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"C'est bien de passer son temps\n[UNI00e0] bricoler comme tu le fais,\nmais fais-tu assez d'exercice ?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Au combat, tout est dans la\nrapidit[UNI00e9] et le jeu de jambes.<page>Si tu es plus lent que moi, c'est\nm[UNI00ea]me pas la peine d'insister."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Tiens, on va voir ! Cours jusqu'au\nbateau sur le lac et reviens. Mon<page>record est de 2 minutes 1 seconde.\nSi tu es plus lent que [UNI00e7]a,\npas la peine d'insister."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Alors, tu veux essayer ?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_b6d778a6(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_968430c3
