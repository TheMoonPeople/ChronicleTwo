--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_136a94b8 = require("@lib/event/helper_136a94b8")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_8668c8fd = require("@lib/event/helper_8668c8fd")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_360fd6fa(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
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
			helper_8668c8fd(24, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Seg[UNI00fa]n Cedric,\nhas estado fuera\npor ciertos asuntos.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Eres bueno en muchas cosas,\npero luego\nnunca terminas nada.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Por eso cuando me pides\nayuda me resulta dif[UNI00ed]cil tomarte\nen serio a la primera.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ya. [UNI00bf]Por qu[UNI00e9] no mejoras esta Pistola Trompeta y la conviertes en Pistola Campana?<page>[UNI00bf]Ser[UNI00e1]s capaz?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_8668c8fd(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Para conseguir que Gerald te acepte,\n tendr[UNI00e1]s que\nconseguirle una Pistola Trompeta.<page>[(!)]Puedes mejorar el arma\n que te han dado, comprar una\n o conseguir una en las Mazmorras."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

return helper_360fd6fa
