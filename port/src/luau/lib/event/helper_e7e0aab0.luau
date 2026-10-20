--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b273bb5d = require("@lib/event/helper_b273bb5d")

--- Helper function.
local function helper_e7e0aab0()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b273bb5d()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_b273bb5d()
end

return helper_e7e0aab0
