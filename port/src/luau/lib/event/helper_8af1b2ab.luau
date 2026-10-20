--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a567a0e9 = require("@lib/event/helper_a567a0e9")

--- Helper function.
local function helper_8af1b2ab(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a567a0e9(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8af1b2ab
