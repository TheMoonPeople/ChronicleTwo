--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a33c92c8 = require("@lib/event/helper_a33c92c8")
local helper_cb99d2e8 = require("@lib/event/helper_cb99d2e8")
local helper_fd98eb80 = require("@lib/event/helper_fd98eb80")

--- Helper function.
local function helper_e6106d27(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, sp: number)
	vm.stack(sp + 8)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 8)
		helper_cb99d2e8(arg0, sp + 8)
		vm.stack(sp + 8)
	end
	vm.stack(sp + 13)
	local _ = helper_fd98eb80(arg0, arg1, arg2, arg3, arg4, sp + 9)
	vm.stack(sp + 8)
	vm.stack(sp + 11)
	_, var6 = helper_a33c92c8(arg0, 0, var6, sp + 9)
	vm.stack(sp + 8)
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 8)
	helper_cb99d2e8(arg0, sp + 8)
	vm.stack(sp + 8)
end

return helper_e6106d27
