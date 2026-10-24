--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_81ba7dbe = require("@lib/event/helper_81ba7dbe")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e5219064 = require("@lib/event/helper_e5219064")

--- Helper function.
local function helper_65c8e03f(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_81ba7dbe(arg0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Ronchonnements...")
	helper_81ba7dbe(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"...1212,<page>Mais non, c'[UNI00e9]tait 2211, c'est certain.<page>Ou peut-[UNI00ea]tre bien 1010."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ronchonnements...")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]S'il ne te remarque m[UNI00ea]me pas quand \n   tu dis \"Bonjour\", c'est qu'il \n   doit avoir de gros, gros probl[UNI00e8]mes.<page>[(!)]Pourquoi ne pas r[UNI00e9]essayer plus tard\n   Tu pourras peut-[UNI00ea]tre l'aider, ou\n   l'[UNI00e9]couter se plaindre, au pire !"
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

return helper_65c8e03f
