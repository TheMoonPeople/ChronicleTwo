--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_def90cd6(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f1049565(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon hobby [UNI00e0] moi, c'est la p[UNI00ea]che.<page>Je r[UNI00ea]ve de p[UNI00ea]cher un Mardan Garayan.<page>Il faut p[UNI00ea]cher gros pour m'[UNI00e9]pater."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_def90cd6
