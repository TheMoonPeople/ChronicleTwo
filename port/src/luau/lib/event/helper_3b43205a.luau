--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3535925d = require("@lib/event/helper_3535925d")

--- Helper function.
local function helper_3b43205a()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_3535925d(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3535925d(1)
end

return helper_3b43205a
