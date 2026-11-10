--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_46754465(arg0: s32, arg1: any)
	for var3 = 0, arg0 - 1 do
		vm.wait(1)
	end
end

return helper_46754465
