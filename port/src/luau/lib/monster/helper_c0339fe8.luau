--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_274f6d9a = require("@lib/monster/helper_274f6d9a")

--- Helper function.
local function helper_c0339fe8(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_274f6d9a()
		var1 = vm.i32(var1 + 1)
	end
end

return helper_c0339fe8
