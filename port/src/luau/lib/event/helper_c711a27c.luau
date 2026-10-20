--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c711a27c()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

return helper_c711a27c
