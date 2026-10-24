--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ba8b0411 = require("@lib/event/helper_ba8b0411")

--- Helper function.
local function helper_a0450e0f(arg0: s32, arg1: any)
	helper_ba8b0411(arg0, vm.ftoi(arg1), -1)
end

return helper_a0450e0f
