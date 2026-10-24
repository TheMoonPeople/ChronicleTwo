--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19c92a8d = require("@lib/event/helper_19c92a8d")

--- Helper function.
local function helper_05deb318(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_19c92a8d(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_05deb318
