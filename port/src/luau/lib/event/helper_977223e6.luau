--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2ba993e3 = require("@lib/event/helper_2ba993e3")

--- Helper function.
local function helper_977223e6()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2ba993e3(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2ba993e3(1)
end

return helper_977223e6
