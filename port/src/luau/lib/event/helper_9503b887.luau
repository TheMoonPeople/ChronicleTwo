--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_51b8af5f = require("@lib/event/helper_51b8af5f")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_9503b887(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_51b8af5f(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max! Hai avuto parecchi\npensieri ultimamente.\nTi stai riguardando?<page>Posso fare qualcosa per te?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Cosa! Vuoi che ti segua\nnella tua avventura?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mmh... Vorrei venire con te...\nMa questo povero albero non\nsta mica tanto bene.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Prendermi cura degli alberi e dei\nfiori di questa tenuta [UNI00e8] ci[UNI00f2] che\nmi preme di pi[UNI00f9], lo sai.<page>Se me ne andassi a zonzo,\nperderei il mio lavoro!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"L'Acqua sacra che Don Bruno vende\nin chiesa sanerebbe quest'albero!<page>Ma, come sai, tuo padre e Don\nBruno non vanno molto d'accordo...<page>Tuo padre non mi darebbe mai soldi\nper comprare la sua Acqua Sacra!<page>Sono in un bel pasticcio!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Per portare Gordon a Sindain,\n   devi fare in modo che ti\n   segua in viaggio.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Se soddisfi la richiesta di Gordon,\n   ti seguir[UNI00e0] in viaggio\n   e salir[UNI00e0] sul treno."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "[(!)]Puoi controllare le richieste\n   leggendo il Taccuino,\n   nel Menu Oggetti.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(0, "[(!)]Oh, non hai un Taccuino?\n   Ce n'[UNI00e8] uno sul tavolo\n   nel Negozio di Cedric.")
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]Ce ne [UNI00e8] un altro nella tana\n   di Donny. Vanno bene entrambi.\n   Prendine uno, sbrigati!"
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

return helper_9503b887
