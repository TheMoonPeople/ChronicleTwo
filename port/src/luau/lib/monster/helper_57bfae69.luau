--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_32147814 = require("@lib/monster/helper_32147814")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")

--- Helper function.
local function helper_57bfae69(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	local var5: f32 = 0
	var4 = helper_57b569a8(var4)
	var5 = helper_32147814(arg0, arg1, arg2, var5)
	arg3 = vm.f32(var5 - var4)
	return arg3
end

return helper_57bfae69
