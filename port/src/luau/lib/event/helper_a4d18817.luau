--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_a4d18817(arg0: any, arg1: s32)
	for var3 = 0, arg1 - 1 do
		vm.wait(1)
	end
end

return helper_a4d18817
