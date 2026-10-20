--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_375124ef = require("@lib/event/helper_375124ef")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_f81f97b4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_375124ef()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_375124ef()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

return helper_f81f97b4
