--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_c3e76d51(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Wenn du Probleme hast,\nfrag ruhig immer mich.")
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_c3e76d51
