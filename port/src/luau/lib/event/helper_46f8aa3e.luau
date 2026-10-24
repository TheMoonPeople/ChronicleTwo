--!strict
-- Shared event helper used by 160 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0820be1a = require("@lib/event/helper_0820be1a")

--- Helper function.
local function helper_46f8aa3e(arg0: s32, arg1: any)
	helper_0820be1a(arg0, vm.ftoi(arg1), -1)
end

return helper_46f8aa3e
