--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_7bc99d2c = require("@lib/event/helper_7bc99d2c")

--- Helper function.
local function helper_8c11b14b()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7bc99d2c(1, 7)
		helper_24d1805d(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_7bc99d2c(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Si ferma con il pulsante (O).")
	helper_24d1805d(1, -1, 15, 0, 0)
end

return helper_8c11b14b
