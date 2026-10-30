--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")

--- Helper function.
local function helper_b551b11d(arg0: s32, arg1: any)
	local _ = helper_f8bbcc57(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
end

return helper_b551b11d
