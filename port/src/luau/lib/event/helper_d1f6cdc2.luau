--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_d1f6cdc2(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"The shop's closed. You'll have to\ngo to my old man's shop instead.<page>Look for the pumpkins. I'm sure you'll see 'em.\nIt's just at the top of that ladder."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_d1f6cdc2
