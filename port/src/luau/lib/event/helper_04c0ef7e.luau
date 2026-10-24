--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8699770f = require("@lib/event/helper_8699770f")

--- Helper function.
local function helper_04c0ef7e(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8699770f(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_04c0ef7e
