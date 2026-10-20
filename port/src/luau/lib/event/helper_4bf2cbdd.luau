--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_cd6723ca = require("@lib/event/helper_cd6723ca")

--- Helper function.
local function helper_4bf2cbdd(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cd6723ca(arg0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grrr, grrr..")
	helper_cd6723ca(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grrr, grrr..")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

return helper_4bf2cbdd
