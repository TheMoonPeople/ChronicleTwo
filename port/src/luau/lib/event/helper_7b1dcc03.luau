--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e5f78c9b = require("@lib/event/helper_e5f78c9b")

--- Helper function.
local function helper_7b1dcc03(arg0: s32, arg1: any)
	helper_e5f78c9b(arg0, vm.ftoi(arg1), -1)
end

return helper_7b1dcc03
