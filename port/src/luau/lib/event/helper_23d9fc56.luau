--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c169170b = require("@lib/event/helper_c169170b")

--- Helper function.
local function helper_23d9fc56()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_c169170b()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_c169170b()
end

return helper_23d9fc56
