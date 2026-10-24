--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02b69e90 = require("@lib/event/helper_02b69e90")
local helper_e62dd413 = require("@lib/event/helper_e62dd413")

--- Helper function.
local function helper_72407cf0()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_02b69e90(1, 7)
		helper_e62dd413(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_02b69e90(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Anhalten mit (O).")
	helper_e62dd413(1, -1, 15, 0, 0)
end

return helper_72407cf0
