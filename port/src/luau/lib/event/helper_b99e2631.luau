--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_b99e2631(arg0: s32, arg1: s32)
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
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Vraiment ? Tu as besoin de mon<page>aide ? Alors laisse-moi t'exposer\nun petit probl[UNI00e8]me."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Les bougies de cette [UNI00e9]glise sont\ncontr[UNI00f4]l[UNI00e9]es par un petit m[UNI00e9]canisme.<page>Il [UNI00e9]teint les bougies allum[UNI00e9]es,\net allume les bougies [UNI00e9]teintes.<page>Si l'une d'entre elles change, les\nbougies adjacentes changent aussi."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] [UNI00e9]teindre toutes\nles bougies, je viendrai.<page>J'en serais tr[UNI00e8]s content ! Sinon,\nje ne viendrai pas."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Une petite [UNI00e9]nigme. Essaie une ou\n   deux fois, et sers-toi de ce que ces\n   petites exp[UNI00e9]riences t'auront appris."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Si tu rentres [UNI00e0] nouveau dans l'[UNI00e9]glise,\n   les bougies seront r[UNI00e9]initialis[UNI00e9]es.\n   Alors n'aie pas peur de te tromper.\n   La r[UNI00e9]ponse peut [UNI00ea]tre tr[UNI00e8]s simple."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

return helper_b99e2631
