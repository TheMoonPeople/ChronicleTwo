--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a6119e46 = require("@lib/event/helper_a6119e46")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_5bda467f(arg0: s32, arg1: s32)
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
			helper_a6119e46(arg0, arg1)
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a6119e46(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Grrr, grrr..")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir con\neso de que qu[UNI00e9] estoy murmullando?<page>Estoy intentando\nrecordar la combinaci[UNI00f3]n de la caja fuerte."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir?\n[UNI00bf]Qu[UNI00e9] caja?<page>La caja fuerte escondida\ndetr[UNI00e1]s del cuadro de mi despacho, claro..."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_a6119e46(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00a1]Ah, qu[UNI00e9] susto!<page>[UNI00a1]Porras!<page>Me he ido y he desvelado\nmi mayor secreto.<page>Bueno, ya lo sabes.<page>A lo mejor me puedes\nechar una mano."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Tengo muchos problemas\nporque he olvidado\nla combinaci[UNI00f3]n de la caja fuerte.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Es un n[UNI00fa]mero de\n4 d[UNI00ed]gitos. Us[UNI00e9]\nla fecha de nacimiento de Claire\npara no olvidarme nunca."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo lo habr[UNI00e9] olvidado?<page>Vaya padre soy...")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]El alcalde parece muy preocupado.\n Escucha lo que te dice sobre\nel cumplea[UNI00f1]os de Claire y trata de descifrar la combinaci[UNI00f3]n."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

return helper_5bda467f
