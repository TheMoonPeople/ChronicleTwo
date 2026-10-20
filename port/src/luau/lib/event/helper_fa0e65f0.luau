--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_c3bcf7bb = require("@lib/event/helper_c3bcf7bb")

--- Helper function.
local function helper_fa0e65f0(arg0: s32, arg1: s32)
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
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_c3bcf7bb(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "He, Max, suchst du mich?<page>Ich hab auf dich gewartet.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Die Burgmauer sch[UNI00fc]tzt diese\nStadt recht gut.<page>Wir m[UNI00fc]ssen jetzt rausgehen.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es ist gut, dass du immer\nan Maschinen bastelst,\naber wie stark bist du wohl?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Beim K[UNI00e4]mpfen geht's um\nSchnelligkeit und Beinarbeit.<page>Wenn du langsamer bist als\nich, bringt es nichts."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Machen wir einen kleinen Test.\nLauf zum Boot am See und zur[UNI00fc]ck.<page>Mein Rekord ist 2 Min., 1 Sek.\nWenn du langsamer bist,\nbringt es nichts."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Wie w[UNI00e4]r's, probierst du's mal?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_c3bcf7bb(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_fa0e65f0
