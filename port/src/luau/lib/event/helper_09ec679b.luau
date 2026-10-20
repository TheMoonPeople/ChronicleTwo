--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b051e80 = require("@lib/event/helper_1b051e80")

--- Helper function.
local function helper_09ec679b()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1b051e80()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_1b051e80()
end

return helper_09ec679b
