--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_267bc7b4 = require("@lib/event/helper_267bc7b4")
local helper_e6106d27 = require("@lib/event/helper_e6106d27")

--- Helper function.
local function helper_11a72f87(sp: number)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(1, 4)
	helper_267bc7b4(1, 4, sp + 0)
	event.GetFishingtournamentEtc_2(0, 1)
	helper_e6106d27(1, -1, 8, 0, 0, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_11a72f87
