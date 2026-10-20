--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3513260d = require("@lib/event/helper_3513260d")

--- Helper function.
local function helper_a5feeb16(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3513260d(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_a5feeb16
