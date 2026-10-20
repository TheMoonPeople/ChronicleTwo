--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_e99f2884(arg0: s32, arg1: s32)
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
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]S[UNI00ed]? [UNI00bf]Necesitas mi ayuda?\nEntonces d[UNI00e9]jame que te plantee un problema."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Las velas de la iglesia\nest[UNI00e1]n controladas por un peque[UNI00f1]o mecanismo.<page>Cuando est[UNI00e1]n encendidas\nlas apaga y,\ncuando se apagan, las enciende.<page>Si una cambia,\nlas adyacentes a ella tambi[UNI00e9]n lo hacen."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si apagas todas las velas,\nme demostrar[UNI00e1]s tu sabidur[UNI00ed]a y te acompa[UNI00f1]ar[UNI00e9].<page>Si resuelves el problema, estupendo.\nSi no, tendr[UNI00e1]s que entender que no puedo ayudarte."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Este es otro puzzle. Int[UNI00e9]ntalo\nun par de veces y f[UNI00ed]jate bien\nen lo que pasa."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Si vuelves a entrar en la iglesia,\n las velas volver[UNI00e1]n a su estado original.\n O sea que no hay de qu[UNI00e9] preocuparse.\n La soluci[UNI00f3]n podr[UNI00ed]a ser muy simple."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

return helper_e99f2884
