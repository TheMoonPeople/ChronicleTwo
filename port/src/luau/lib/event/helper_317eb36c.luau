--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b6af9005 = require("@lib/event/helper_b6af9005")

--- Helper function.
local function helper_317eb36c(arg0: s32, arg1: any)
	helper_b6af9005(arg0, vm.ftoi(arg1), -1)
end

return helper_317eb36c
