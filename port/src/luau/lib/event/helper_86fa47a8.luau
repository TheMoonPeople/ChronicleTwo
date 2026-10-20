--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_969c5ad6 = require("@lib/event/helper_969c5ad6")

--- Helper function.
local function helper_86fa47a8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_969c5ad6(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_969c5ad6(1)
end

return helper_86fa47a8
