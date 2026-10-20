--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_546181df(arg0: s32, arg1: s32)
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
			helper_635ee3fd(0, -1, arg0, arg1, 0)
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
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Qualunque cosa vi serva, far[UNI00f2]\ndel mio meglio per aiutarvi.<page>Lasciate fare a me.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Non so se potete aiutarmi...<page>Comunque ascoltate.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Sono 30 anni che lavoro\nsodo in questa casa.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Il lavoro [UNI00e8] la mia vita, ma\nun hobby ce l’ho: la lettura.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "C'[UNI00e8] un libro raro e prezioso,\nora in vendita all'asta.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "La gente fa a botte per averlo.\nCredo che un'offerta di circa\n1000 Gilda possa bastare.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Non ho tanto denaro e, se lo\nchiedessi al padrone, andrebbe su tutte\nle furie e io dovrei andarmene."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Siete la mia unica speranza.<page>Ma questo non significa che se\nnon mi aiutate io non aiuter[UNI00f2] voi."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Malgrado le sue parole, Stewart non vi\n   aiuter[UNI00e0] se non gli darete 1000 Gilda.\n   Bisogner[UNI00e0] racimolare soldi!"
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

return helper_546181df
