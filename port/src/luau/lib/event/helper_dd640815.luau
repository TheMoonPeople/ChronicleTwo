--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_dd640815(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il mio hobby [UNI00e8] la pesca.<page>Vorrei prendere un Mardan Karayan!<page>Rispetto solo chi cattura pesci grossi."
	)
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_dd640815
