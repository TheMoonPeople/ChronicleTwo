--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_329c1757 = require("@lib/event/helper_329c1757")

--- Helper function.
local function helper_1b552e70()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_329c1757(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_329c1757(1)
end

return helper_1b552e70
