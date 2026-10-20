--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1942253a = require("@lib/event/helper_1942253a")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_64144c15(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_1942253a()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Avete trovato delle Castagne?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(0, "Allora non potete aiutarmi...<page>Oh beh, meglio lasciar\nperdere il Castagnaccio.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Ah, eccole! Grazie tante.<page>Prover[UNI00f2] a fare il Castagnaccio.<page>Ve lo far[UNI00f2] assaggiare appena pronto!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Posso fare qualcosa in cambio?<page>Cosa? Un'avventura al vostro fianco?<page>Ah ah! Certo che verr[UNI00f2].<page>Ma potevate dirlo subito!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_1942253a()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

return helper_64144c15
