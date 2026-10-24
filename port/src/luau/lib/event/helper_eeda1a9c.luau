--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_65db22ac = require("@lib/event/helper_65db22ac")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_eeda1a9c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_65db22ac(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max! Du siehst in letzter\nZeit oft traurig aus. Ist alles\nin Ordnung bei dir?<page>Kann ich etwas f[UNI00fc]r dich tun?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Wie? Ich soll dich auf\ndeinem Abenteuer begleiten?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Hmm ... ich w[UNI00fc]rde gern mitkommen ...\nAber dieser arme Baum\nist krank.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Die Pflege der B[UNI00e4]ume und\nBlumen auf diesem Gel[UNI00e4]nde\nist mir das Wichtigste [UNI00fc]berhaupt.<page>Wenn ich einfach abhaue,\nverliere ich noch meinen Job."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Etwas von Brunos Weihwasser\nw[UNI00fc]rde diesem Baum sicher helfen!<page>Aber du wei[UNI00df]t ja, dein Vater und\nder Priester verstehen sich nicht...<page>Dein Vater w[UNI00fc]rde mir nie Geld\nf[UNI00fc]r Priester Brunos Weihwasser geben!<page>Ich sitze in der Klemme."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Um Gordon nach Sindain zu\n   bringen, musst du ihn erst\n   als Begleiter gewinnen.")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "[(!)]Wenn du Gordon hilfst,\n   schlie[UNI00df]t er sich dir an\n   und steigt in den Zug.")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Deine Auftr[UNI00e4]ge findest du\n   im Notizbuch\n   im Gegenst[UNI00e4]nde-Men[UNI00fc]."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(0, "[(!)]Oh, du hast kein Notizbuch.\n   Auf dem Tisch im\n   Ger[UNI00e4]teladen liegt eins.")
		helper_d1353c5b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]In Donnys Versteck liegt auch\n   eins. Es ist egal, welches\n   du nimmst, aber mach schnell!"
		)
		helper_d1353c5b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

return helper_eeda1a9c
