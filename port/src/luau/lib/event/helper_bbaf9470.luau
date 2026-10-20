--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_604d1827 = require("@lib/event/helper_604d1827")

--- Helper function.
local function helper_bbaf9470()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_604d1827(2)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_604d1827(2)
end

return helper_bbaf9470
