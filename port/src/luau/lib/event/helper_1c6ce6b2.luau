--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13fb948c = require("@lib/event/helper_13fb948c")
local helper_c57200a6 = require("@lib/event/helper_c57200a6")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_1c6ce6b2(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_c57200a6(44, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Tu es Monica,\nc'est [UNI00e7]a ?<page>J'ai entendu dire que tu te\nd[UNI00e9]brouillais plut[UNI00f4]t bien [UNI00e0] l'[UNI00e9]p[UNI00e9]e."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais les [UNI00e9]p[UNI00e9]es ne sont\npas des jouets, tu sais.<page>Il faut faire preuve de jugeote\nface [UNI00e0] l'ennemi."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] faire [UNI00e9]voluer\nune [UNI00e9]p[UNI00e9]e de 2 niveaux, tu\nm'auras convaincue de ton talent."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Pourquoi ne pas commencer\navec ce Gladius ?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_c57200a6(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Pour que Milane t'aide, il va\n   falloir faire [UNI00e9]voluer le\n   Gladius de 2 niveaux."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux aussi acheter ou r[UNI00e9]cup[UNI00e9]rer des\n   armes. Il te suffit de te procurer une\n   arme puissante et Milane t'aidera."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

return helper_1c6ce6b2
