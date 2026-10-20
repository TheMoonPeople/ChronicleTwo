--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d4dff83 = require("@lib/event/helper_0d4dff83")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")

--- Helper function.
local function helper_5c37b559(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_0d4dff83(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Eh, Max, [UNI00bf]has venido a buscarme?<page>Te he estado esperando.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Gracias a las murallas,\nla ciudad es segura.<page>Es hora de salir.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Me parece bien que te pases\nel d[UNI00ed]a manipulando m[UNI00e1]quinas,\npero me gustar[UNI00ed]a saber qu[UNI00e9] fuerza tienes."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"La lucha\nes cuesti[UNI00f3]n de velocidad y juego de pies.<page>Si eres m[UNI00e1]s lento que yo,\nest[UNI00e1]s listo."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] no te ponemos a prueba?\nCorre hasta la barca del lago y vuelve.<page>Mi r[UNI00e9]cord es de 2 minutos y 1 segundo.\nSi eres m[UNI00e1]s lento,\nno hay nada que hacer."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] dices, quieres probar?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_0d4dff83(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_5c37b559
