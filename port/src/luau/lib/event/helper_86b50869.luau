--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_136a94b8 = require("@lib/event/helper_136a94b8")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_8668c8fd = require("@lib/event/helper_8668c8fd")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_86b50869(arg0: s32, arg1: s32)
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
			helper_8668c8fd(300, 20)
		end
		if at <= 5 then
			helper_136a94b8(1)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Tu veux que je\nvienne avec toi ?<page>Je ne suis qu'une femme qui fait\ndu pain, mais si je peux t'aider,\nje le ferai avec plaisir."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, mais d'abord, j'ai quelque chose\n[UNI00e0] faire livrer [UNI00e0] Morton.<page>[UNI00c7]a t'emb[UNI00ea]terait d'emporter pour moi\n20 pains [UNI00e0] son magasin ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Pendant ce temps-l[UNI00e0], je vais\nfaire mes bagages pour le voyage.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_8668c8fd(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Je me demande ce qu'il peut bien\nvouloir faire avec 20 pains ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

return helper_86b50869
