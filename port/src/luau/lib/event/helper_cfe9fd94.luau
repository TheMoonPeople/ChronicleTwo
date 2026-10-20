--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_cfe9fd94(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Aha ... Ich w[UNI00fc]rde dir sehr\ngern helfen. Mehr\nals gern sogar.<page>Aber ich habe einfach\nkein Selbstvertrauen."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ich gebe immer auf halbem Weg\nauf - ich hab noch nie etwas\nzu Ende gebracht.<page>Als Kind wollte ich Schneiderin\nwerden und habe viel ausprobiert,\naber ich habe nie was fertig gen[UNI00e4]ht."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wenn ich mitk[UNI00e4]me, w[UNI00e4]re ich\nbestimmt nur im Weg.<page>Tut mir Leid, aber - nein."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh Mann, Adel hat gar kein\n   Selbstvertrauen. Das ist nicht\n   gut. Bring sie wieder zum N[UNI00e4]hen."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

return helper_cfe9fd94
