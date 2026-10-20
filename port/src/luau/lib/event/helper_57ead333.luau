--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c357943 = require("@lib/event/helper_1c357943")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")

--- Helper function.
local function helper_57ead333(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
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
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_1c357943()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Qu'est-ce que c'est que [UNI00e7]a ?\nAlors c'[UNI00e9]tait juste du pipeau ?<page>Sors d'ici !\nTu g[UNI00ea]nes [UNI00e0] tra[UNI00ee]ner dans le coin."
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
		"Ouaah, c'est une [UNI00e9]p[UNI00e9]e\nplut[UNI00f4]t impressionnante.<page>Je m'excuse, mais\nje devais te tester."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Car tu sais, se battre avec un\namateur, c'est dangereux pour moi\naussi.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Mais j'ai l'impression que je n'ai\npas [UNI00e0] m'inqui[UNI00e9]ter de [UNI00e7]a avec toi.<page>Tr[UNI00e8]s bien, allons\ncombattre ensemble."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_1c357943()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

return helper_57ead333
