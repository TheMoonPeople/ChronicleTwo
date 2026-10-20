--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a6119e46 = require("@lib/event/helper_a6119e46")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_66460095(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_a6119e46(arg0, arg1)
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a6119e46(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ronchonnements...")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_a6119e46(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

return helper_66460095
