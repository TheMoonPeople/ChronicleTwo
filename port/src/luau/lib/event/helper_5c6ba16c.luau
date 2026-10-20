--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_43fb4864 = require("@lib/event/helper_43fb4864")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_5c6ba16c(arg0: s32, arg1: s32)
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
			helper_43fb4864(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Eh, Max, [UNI00bf]has venido a buscarme?<page>Te he estado esperando.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Gracias a las murallas,\nla ciudad es segura.<page>Es hora de salir.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Me parece bien que te pases\nel d[UNI00ed]a manipulando m[UNI00e1]quinas,\npero me gustar[UNI00ed]a saber qu[UNI00e9] fuerza tienes."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"La lucha\nes cuesti[UNI00f3]n de velocidad y juego de pies.<page>Si eres m[UNI00e1]s lento que yo,\nest[UNI00e1]s listo."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] no te ponemos a prueba?\nCorre hasta la barca del lago y vuelve.<page>Mi r[UNI00e9]cord es de 2 minutos y 1 segundo.\nSi eres m[UNI00e1]s lento,\nno hay nada que hacer."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] dices, quieres probar?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_43fb4864(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_5c6ba16c
