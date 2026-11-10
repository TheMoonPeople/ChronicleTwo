--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d977cd5f(arg0: any, arg1: any)
	local var3: s32 = 0
	var3 = 0
	while var3 < arg0 do
		vm.wait(1)
		var3 = vm.i32(var3 + 1)
	end
end

return helper_d977cd5f
