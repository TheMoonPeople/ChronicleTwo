--!strict
-- Shared monster helper used by 26 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")

--- Helper function.
local function helper_97663440(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_0ba23e4e()
		var1 = vm.i32(var1 + 1)
	end
end

return helper_97663440
