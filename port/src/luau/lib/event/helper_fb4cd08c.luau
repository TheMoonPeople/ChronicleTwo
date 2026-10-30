--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_fb4cd08c(arg0: s32, arg1: f32, arg2: f32, arg3: any)
	local _ = arg2 == -1.0
	arg2 = vm.f32(0.01)
	local _ = arg3 > 0
end

return helper_fb4cd08c
