--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_eecf7fd1(arg0: s32, arg1: s32)
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
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je ferai de mon mieux pour t'aider\nsi tu as besoin de quoi que ce<page>soit. Pas de probl[UNI00e8]me."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Je ne sais pas si tu peux<page>m'aider... Mais [UNI00e9]coute bien [UNI00e7]a.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je travaille dur depuis pr[UNI00e8]s de 30\nans dans cette maison.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Je consacre tout mon temps libre\n[UNI00e0] mon seul et unique passe-temps,\nla lecture.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Un livre extr[UNI00ea]mement rare et\npr[UNI00e9]cieux est [UNI00e0] vendre aux ench[UNI00e8]res\nen ce moment."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tout le monde se bat pour l'avoir.\nJe pense qu'une somme d'environ\n1000 Gildas devrait suffire."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Mais je n'ai pas une telle somme,\net mon ma[UNI00ee]tre serait outr[UNI00e9] si je\nlui demandais de me la pr[UNI00ea]ter."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Alors tu es mon seul espoir.<page>[UNI00c7]a ne veut pas dire que si tu ne\npeux pas m'aider, je ne ferai rien pour toi."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Malgr[UNI00e9] ses dires, Stewart ne t'aidera\n   s[UNI00fb]rement pas, sauf pour 1000 Gildas.\n   Bref, il va falloir trouver de l'argent."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

return helper_eecf7fd1
