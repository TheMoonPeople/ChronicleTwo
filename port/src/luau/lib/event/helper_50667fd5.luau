--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")

--- Helper function.
local function helper_50667fd5()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b90ffbb8(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_b90ffbb8(1)
end

return helper_50667fd5
