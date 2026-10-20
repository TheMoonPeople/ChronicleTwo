--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13fb948c = require("@lib/event/helper_13fb948c")
local helper_36017445 = require("@lib/event/helper_36017445")
local helper_941ed74e = require("@lib/event/helper_941ed74e")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_3bf9bb87(arg0: s32, arg1: s32)
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
			helper_36017445(44, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_941ed74e(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_941ed74e(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Tu sei Monica,\ngiusto?<page>Ho sentito dire che\nnon sei niente male con la spada.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ma le spade non sono\ngiocattoli, lo sai.<page>Devi pensare a\ncosa hai davanti.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Se potenzi una spada di 2 livelli,\nmi convincer[UNI00f2] del tuo talento!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Perch[UNI00e9] non cominci\ncon il Gladio?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_36017445(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Se vuoi farti accettare da\n   Milane, dovrai potenziare il\n   Gladio di 2 livelli.")
	helper_941ed74e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Puoi anche comprare o trovare le armi.\n   L'importante [UNI00e8] procurarsene di\n   potenti, cos[UNI00ec] Milane ti aiuter[UNI00e0]."
	)
	helper_941ed74e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

return helper_3bf9bb87
