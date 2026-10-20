--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_85bd97d8 = require("@lib/event/helper_85bd97d8")

--- Helper function.
local function helper_1e35a3b0()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_85bd97d8(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_85bd97d8(1)
end

return helper_1e35a3b0
