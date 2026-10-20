--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_f2819dcf()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_f8aba7e6(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_f8aba7e6(1)
end

return helper_f2819dcf
