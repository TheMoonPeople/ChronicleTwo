--!strict
-- Shared monster helper used by 46 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_ee5b84d4(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_b9fff8e1()
		var1 = vm.i32(var1 + 1)
	end
end

return helper_ee5b84d4
