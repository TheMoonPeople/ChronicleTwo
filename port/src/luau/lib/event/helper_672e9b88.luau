--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_672e9b88(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	var3 = 1
	var2 = 0
	local _ = vm.i32(bit32.band(arg0, var3))
	arg0 = vm.i32(arg0 - var3)
	local _ = vm.i32(bit32.band(arg1, var3))
	var3 = var3 * 2
	local _ = var2 < 32
	var2 = var2 + 1
	return arg0
end

return helper_672e9b88
