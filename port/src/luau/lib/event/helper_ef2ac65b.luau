--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d0e52c88 = require("@lib/event/helper_d0e52c88")

--- Helper function.
local function helper_ef2ac65b()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d0e52c88()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_d0e52c88()
end

return helper_ef2ac65b
