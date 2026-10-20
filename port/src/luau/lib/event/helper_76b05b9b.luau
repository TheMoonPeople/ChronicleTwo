--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13fb948c = require("@lib/event/helper_13fb948c")
local helper_60737e5d = require("@lib/event/helper_60737e5d")
local helper_941ed74e = require("@lib/event/helper_941ed74e")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_76b05b9b(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_60737e5d(44, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_941ed74e(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_941ed74e(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "T[UNI00fa] eres M[UNI00f3]nica,\n[UNI00bf]no?<page>Me han dicho que no\nmanejas mal la espada.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pero las espadas no\nson ning[UNI00fa]n juguete.<page>Tienes que darte cuenta de lo que tienes enfrente."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Si puedes mejorar dos niveles una espada,\nadmitir[UNI00e9] que tienes aptitudes.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Empieza con este\nGladius.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_60737e5d(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Si quieres que Milane te acepte, deber[UNI00e1]s\nmejorar el Gladius\ndos niveles.")
	helper_941ed74e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tambi[UNI00e9]n se pueden comprar o recoger armas.\n Consigue un arma fuerte y\n Milane te ayudar[UNI00e1]."
	)
	helper_941ed74e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

return helper_76b05b9b
