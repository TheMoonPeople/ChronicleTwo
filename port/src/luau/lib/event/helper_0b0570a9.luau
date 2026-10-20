--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8afc4c0b = require("@lib/event/helper_8afc4c0b")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_0b0570a9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 4 then
			helper_8afc4c0b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(
			0,
			"[UNI00a1]Eh! [UNI00a1]Me has encontrado!<page>[UNI00bf]Podr[UNI00e1]s tambi[UNI00e9]n la pr[UNI00f3]xima vez?"
		)
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_b0211f82(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Vaya! [UNI00a1]Me has encontrado!<page>Me estoy hartando.<page>Esconderse es\nmuy aburrido.<page>[UNI00a1]Bueno! V[UNI00e1]monos\nde aventura."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_8afc4c0b()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

return helper_0b0570a9
