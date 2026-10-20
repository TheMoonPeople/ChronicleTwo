--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fdd09729 = require("@lib/event/helper_fdd09729")

--- Helper function.
local function helper_e690e785(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fdd09729(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_e690e785
