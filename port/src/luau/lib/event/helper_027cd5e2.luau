--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_24fa5d55 = require("@lib/event/helper_24fa5d55")

--- Helper function.
local function helper_027cd5e2(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_24fa5d55(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_027cd5e2
