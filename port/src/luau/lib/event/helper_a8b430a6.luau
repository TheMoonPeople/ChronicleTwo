--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5494b752 = require("@lib/event/helper_5494b752")

--- Helper function.
local function helper_a8b430a6(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5494b752(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_a8b430a6
