--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_048ef29b(arg0: s32, arg1: f32, arg2: f32, arg3: s32)
	local _ = arg2 == -1.0
	arg2 = vm.f32(0.01)
end

return helper_048ef29b
