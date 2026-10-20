--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_2f004f4d(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Hier ist zu. Geh doch stattdessen\nzum Laden meines alten Herrn.<page>Achte auf die K[UNI00fc]rbisse. Du siehst\nsie bestimmt. Einfach die Leiter rauf."
	)
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_2f004f4d
