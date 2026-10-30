--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

--- Helper function.
local function helper_7870f366(arg0: s32, arg1: s32, arg2: s32)
	helper_ee1c51d0(0, 2750, 8, 0, 0)
	helper_ee1c51d0(0, 2760, 8, 0, 0)
	helper_ee1c51d0(0, vm.i32(2700 + arg2), 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, 2760, 8, 0, 0)
end

return helper_7870f366
