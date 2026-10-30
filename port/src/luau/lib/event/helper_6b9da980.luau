--!strict
-- Shared event helper used by 23 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6b9da980(arg0: s32)
	local var1: s32 = 0
	return vm.i32(bit32.band(var1, arg0))
end

return helper_6b9da980
