--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_b723892d(arg0: s32, arg1: s32)
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
		if at <= 5 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]Quieres que te haga un favor?<page>Pues esc[UNI00fa]chame primero.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"S[UNI00f3]lo presto atenci[UNI00f3]n a la gente que respeto.<page>Y s[UNI00f3]lo respeto a la gente\nque ha pescado peces m[UNI00e1]s grandes que yo."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"El mayor pez que he cogido\nfue un Nonky de 60 cm.<page>[UNI00bf]Qu[UNI00e9], impresionado?\nSi te apetece competir conmigo,\nestar[UNI00e9] encantado."
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
		"[(!)]Al parecer, la [UNI00fa]nica forma de\nconseguir que se una a ti es capturando un Nonky\n de m[UNI00e1]s de 60 cm. [UNI00a1]T[UNI00fa] puedes!"
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Prueba de todas formas en\nel lago de Palm Brinks.")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

return helper_b723892d
