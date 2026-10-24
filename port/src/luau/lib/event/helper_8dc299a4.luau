--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d467b6b = require("@lib/event/helper_1d467b6b")

--- Helper function.
local function helper_8dc299a4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1d467b6b(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8dc299a4
