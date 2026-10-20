--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_228c999d = require("@lib/event/helper_228c999d")

--- Helper function.
local function helper_677bd3a6(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_228c999d(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_677bd3a6
